; *************************************************************************
;
;       TecM8 1.0 Assembler for the Tec-1 
;
;       by John Hardy
;
;       GNU GENERAL PUBLIC LICENSE                   Version 3, 29 June 2007
;
;       see the LICENSE file in this repo for more information 
;
; *****************************************************************************

; **************************************************************************
; Page 0  Initialisation
; **************************************************************************		

	.ORG ROMSTART + $180	; 0+180 put TecM8 code from here	


start:                      ; entry point of TecM8
    ld sp,STACK		        
    call init
    call printStr		
    .cstr "TecM8 0.0\r\n"
    jp parse

init:
    xor a                       
    ld (vPushBack),a            ; nothing in push back buffer
    ld (vToken),a               ; NUL_ token
    ld hl,chars
    ld (vCharPtr),hl
    ld hl,assembly
    ld (vAsmPtr),hl
    ld hl,strings
    ld (vStrPtr),hl
    ld (vTokenVal),hl
    ld hl,symbols
    ld (vSymPtr),hl
    ld hl,exprs
    ld (vExprPtr),hl
    ret

parse:
    call statementList
    call printStr		
    .cstr "Parsing completed successfully.";
    halt

statementList:
    ld a,(vToken)
    cp EOF_
    ret z
    call statement
    cp END_
    call match
    jr z,statementList 
    call error		
    .cstr "Expected newline"

statement:
    ret

match:
    ret nz
    push af
    call nextToken
    ld l,a
    pop af
    ld a,l
    ret

; nextToken is a lexer function that reads characters from the input and classifies 
; them into different token types. It handles whitespace, end of input, newlines, 
; comments, identifiers, labels, directives, hexadecimal numbers, and other symbols.

; Input: None

; Output:
; a: contains the type of the next token.
; hl: contains the value associated with the next token.

; Destroyed: None

nextToken:
    ld hl,0
nextToken1:
    call nextChar                   ; Get the next character
    cp " "                          ; Is it a space?
    jr z,nextToken1                 ; If yes, skip it and get the next character
    cp "\t"                         ; Is it a tab?
    jr z,nextToken1                 ; If yes, skip it and get the next character
    or a                            ; Is it null (end of input)?
    jr nz,nextToken2                ; If not, continue to the next check
    ld a,EOF_                       ; If yes, return with EOF token
    ret
nextToken2:
    cp "\n"                         ; Is it a newline?
    jr nz,nextToken2x               ; If not, continue to the next check
    ld a,NEWLN_                     ; If yes, return with NEWLN token
    ret
nextToken2x:
    cp ";"                          ; Is it a comment?
    call nz,nextToken4              ; If not, continue to the next check
nextToken3:
    call nextChar                   ; Get the next character in the comment
    cp " "+1                        ; Loop until the next control character
    jr nc,nextToken3
    ld a,COMMENT_                   ; Return with COMMENT token
    ret
nextToken4:
    cp "_"                          ; Is it an identifier?
    jr z,nextToken5                 ; If yes, continue to the next check
    call isAlphaNum                 ; If not, check if it's alphanumeric
    jr nc,nextToken7x               ; If not, continue to the next check
nextToken5:
    call ident                      ; Parse the identifier
    call nextChar                   ; Get the next character
    cp ":"                          ; Is it a label?
    jr nz,nextToken6                ; If not, continue to the next check
    ld a,LABEL_                     ; If yes, return with LABEL token
    ret
nextToken6:    
    call nz,pushBackChar            ; Push back the character if it's not null
    call opcode
    jr z,nextToken7x
    ld a,OPCODE_                    ; Return with IDENT token
    ret
nextToken7x:
    cp "."                          ; Is it a directive?
    jr nz,nextToken7                ; If not, continue to the next check
    call directive                  ; Parse the directive
    ld a,DIRECT_                    ; Return with DIRECT token
    ret
nextToken7:
    cp "$"                          ; Is it a hexadecimal number?
    jr nz,nextToken8                ; If not, continue to the next check
    call nextChar                   ; Get the next character
    call isHexDigit                 ; Check if it's a hexadecimal digit
    jr c,nextToken8                 ; If not, continue to the next check
    call pushBackChar               ; Push back the character
    jr nextToken10                  ; Jump to the next check
nextToken8:        
    call hex                        ; Parse the hexadecimal number
    ld a,NUM_                       ; Return with NUM token
    ret
    cp "-"                          ; Is it a negative number?
    jr z,nextToken9                 ; If yes, continue to the next check
    call isDigit                    ; Check if it's a digit
    jr nextToken10                  ; Jump to the next check
nextToken9:
    call number                     ; Parse the number
    ld a,NUM_                       ; Return with NUM token
    ret
nextToken10:
    ld l,a                          ; Load the token into L
    ld h,0                          ; Clear H
    ld a,UNKNOWN_                   ; Return with UNKNOWN token
    ret
    
; collects adds ident to string heap
; returns hl = ptr to ident
; destroys a,d,e,h,l
; updates vStrPtr
ident:
    ld hl,(vStrPtr)                 ; hl = top of strings heap
    inc hl                          ; skip length byte
ident1:
    ld (hl),a                       ; write char
    inc hl
    call nextChar
    cp "_"
    jr z,ident1
    call isAlphanum
    call pushBackChar
    ld de,(vStrPtr)                 ; de = string start
    ld (vStrPtr),hl                 ; update top of strings heap
    or a
    sbc hl,de                       ; hl = length, de = strPtr 
    ex de,hl                        ; e = len, hl = strPtr
    ld (hl),e                       ; save lsb(length)
    ret

opcode:
    ex de,hl                        ; de = string to search for
    ld hl,opcodes                   ; list of strings to search
    call searchStr
    cp NO_MATCH                     ; update zero flag                           
    ret
    
directive:
    ld hl,0
    ret

; isAlphaNum checks if the character in the a register is an alphanumeric character 
; (either uppercase or lowercase). 
; If the character is alphabetic, it converts it to uppercase and sets the carry flag. 
; If the character is not alphabetic, it clears the carry flag.

; Input:
; a: Contains the character to be checked.

; Output:
; a: Contains the uppercase version of the input character if it was alphabetic.
; cf: Set if the input character was alphabetic, cleared otherwise.

; Destroyed: c

isAlphaNum:
    call isDigit
    ret z                           ; falls thru to isAlpha                          

; isAlpha: checks if the character in the a register is an alphabetic character 
; (either uppercase or lowercase). 
; If the character is alphabetic, it converts it to uppercase and sets the carry flag. 

; Input:
; a: Contains the character to be checked.

; Output:
; a: Contains the uppercase version of the input character if it was alphabetic.
; cf: Set if the input character was alphabetic, cleared otherwise.

; Destroyed: c

isAlpha:
    ld c,"Z"+1                      ; last uppercase letter
isAlpha0:
    cp "a"                          ; is char lowercase?
    jr c,isAlpha1                   
    sub $20                         ; yes, convert a to uppercase
isAlpha1:
    cp c                            ; is char > last letter?
    ret nc                          ; yes, exit with cf cleared
    cp "A"                          ; is char an uppercase letter ?
    ccf                             ; invert cf
    ret                             

; isHexDigit: checks if the character in the a register is a hexadecimal 
; digit (0-9,A-F,a-f). If the character is a hex digit, it sets the carry flag. 

; Input:
; a: Contains the character to be checked.

; Output:
; cf: Set if the input character was a digit, cleared otherwise.

; Destroyed: none

isHexDigit:
    ld c,"F"+1
    call isAlpha0
    ret z                           ; fall thru to isDigit 

; isDigit: checks if the character in the a register is a decimal 
; digit (0-9). If the character is a decimal digit, it sets the carry flag. 

; Input:
; a: Contains the character to be checked.

; Output:
; cf: Set if the input character was a digit, cleared otherwise.

; Destroyed: none

isDigit:
    cp "9"+1                        ; is char > '9'?
    ret nc                          ; yes, exit with cf cleared
    cp "0"                          ; is char a decimal digit ?
    ccf                             ; invert cf
    ret

; number: parse a number from the input. It handles both decimal and hexadecimal 
; numbers, and also supports negative numbers.

; Input: None

; Output:
; hl: Contains the parsed number.

; Destroyed: None

; vTemp1: A temporary memory location used to store the sign of the number.

number:
    cp "-"                        ; Is it a negative number?
    ld a,-1                       ; a = sign flag
    jr z,num1                      
    inc a                          
num1:
    ld (vTemp1),a                 ; Store the sign flag in vTemp1
    call nextChar                 ; Get the next character
    cp "$"                        ; Is it a hexadecimal number?
    jr nz,num2                    
    call hex                      ; If yes, parse the hexadecimal number
    jr num3                       
num2:
    call pushBackChar             ; Push back the character
    call decimal                  ; Parse the decimal number
num3:
    ld a,(vTemp1)                 ; Load the sign from vTemp1
    inc a                         ; Increment a
    ret nz                        
    ex de,hl                      ; negate the value of HL
    ld hl,0                       
    or a                          
    sbc hl,de                     
    ret                           
    
; hex: parses a hexadecimal number

; Input: none

; Output:
; hl: parsed number

; Destroyed: a

hex:
    ld hl,0                         ; Initialize HL to 0 to hold the result
hex1:
    call nextChar
    cp "0"                          ; Compare with ASCII '0'
    ret c                           ; If less, exit
    cp "9"+1                        ; Compare with ASCII '9'
    jr c, valid                     ; If less or equal, jump to valid
    cp "a"                          ; is char lowercase letter?
    jr c,hex2                   
    sub $20                         ; yes, convert a to uppercase
hex2:
    cp "A"                          ; Compare with ASCII 'A'
    ret c                           ; If less, exit invalid
    cp "F"+1                        ; Compare with ASCII 'F'
    jr c, upper                     ; If less or equal, jump to upper
upper:
    sub $37                         ; Convert from ASCII to hex
valid:
    sub "0"                         ; Convert from ASCII to numeric value
    ret c                           ; If the result is negative, the character was not a valid hexadecimal digit, so return
    cp $10                          ; Compare the result with $10
    ret nc                          ; If the result is $10 or more, the character was not a valid hexadecimal digit, so return
    add hl,hl                       ; Multiply the number in HL by 16 by shifting it left 4 times
    add hl,hl                       ; This is done because each hexadecimal digit represents 16^n where n is the position of the digit from the right
    add hl,hl
    add hl,hl
    add a,l                     ; Add the new digit to the number in HL
    ld  l,a                     ; Store the result back in L
    jp  hex1                    ; Jump back to hex1 to process the next character

; decimal: parses a decimal number

; Input: none

; Output:
; hl: parsed number.

; Destroyed registers:

; A: Used for temporary storage and calculations.
; DE: Used for temporary storage and calculations.

decimal:
    ld hl,0                     ; Initialize HL to 0 to hold the result
decimal1:
    call nextChar
    sub "0"                     ; Subtract ASCII '0' to convert from ASCII to binary
    ret c                       ; If the result is negative, the character was not a digit; return
    cp 10                       ; Compare the result with 10
    ret nc                      ; If the result is 10 or more, the character was not a digit; return
    inc bc                      ; Increment BC to point to the next digit
    ld de,hl                    ; Copy HL to DE
    add hl,hl                   ; Multiply HL by 2
    add hl,hl                   ; Multiply HL by 4
    add hl,de                   ; Add DE to HL to multiply HL by 5
    add hl,hl                   ; Multiply HL by 10
    add a,l                     ; Add the digit in A to the low byte of HL
    ld l,a                      ; Store the result in the low byte of HL
    ld a,0                      ; Clear A
    adc a,h                     ; Add the carry from the previous addition to the high byte of HL
    ld h,a                      ; Store the result in the high byte of HL
    jr decimal1                 ; Jump back to the start of the loop    


; SearchStr: search through a list of Pascal strings for a match. 

; Inputs:
; de: Points to the string to search for.
; hl: Points to the start of the list of strings.

; Outputs:
; a: index of the matching string if a match is found, 
;    or -1 if no match is found.

; Destroyed: a,b,c,d,e,h,l

    ld c, 0                     ; Initialize the index counter
searchStr:
    ld a,(de)                   ; Load the length of the string to search for
    ld b,a                      ; Copy the length to B for looping
    push hl                     ; Store the address of the current string on the stack
    cp (hl)                     ; Compare with the length of the current string in the list
    jr nz, searchStr2           ; If the lengths are not equal, move to the next string
    inc de                      ; Move to the start of the string data
    inc hl                      ; Move to the start of the string data

searchStr1:
    ld a,(de)                   ; Load the next character from the string to search for
    cp (hl)                     ; Compare with the next character in the current string
    jr nz,searchStr2            ; If the characters are not equal, move to the next string
    inc de                      ; Move to the next character in the string to search for
    inc hl                      ; Move to the next character in the current string
    djnz searchStr1             ; Loop until we've compared all characters
    ld a,c                      ; Load the index of the matching string into A
    or a                        ; 
    ret 

searchStr2:
    pop hl                      ; Restore the address of the current string from the stack
    ld a,(hl)                   ; Load the length of the current string
    inc a                       ; a = length byte plus length of string
    add a,l                     ; hl += a
    ld l,a
    ld a,0
    adc a,h
    ld h,a
    push hl                     ; Store the address of the current string on the stack
    inc c                       ; Increment the index counter
    ld a,(hl)                   ; a = length of next string
    or a                        ; If a is not zero, continue searching
    jr nz,searchStr          
    ld a,NO_MATCH               ; No match found
    or a
    ret 
    
; nextChar: checks if there is a character that has been pushed back for re-reading. 
; If there is, it retrieves that character, otherwise it fetches a new character 
; from the input.

; Input: none

; Output:
; a: Contains the next character to be processed, either retrieved from the 
; pushback buffer or fetched from the input.

; Destroyed: None. 

nextChar:
    bit 7, (vPushBack)              ; Check the high bit of the pushback buffer
    jp z, getchar                   ; If the high bit is 0, jump to getchar
    ld a, (vPushBack)               ; If the high bit is 1, load the pushed back character into A
    and 0x7F                        ; Clear the high bit
    ld (vPushBack), a               ; Store the character back in the buffer
    ret                             ; Return with the pushed back character in A

; pushBackChar: push back a character for re-reading. It sets the high bit of the 
; character as a flag to indicate that this character has been pushed back, and 
; stores the character in the pushback buffer.

; Input:
; a: Contains the character to be pushed back.

; Output: None.

; Destroyed: None. 

pushBackChar:
    or 0x80                         ; Set the high bit of the character to be pushed back
    ld (vPushBack), a               ; Store the character in the pushback buffer
    ret 
    
prompt:                            
    call printStr
    .cstr "\r\n> "
    ret

crlf:                               
    call printStr
    .cstr "\r\n"
    ret

error:
    pop hl
    call putStr
    halt

printStr:                           
    pop hl		                    ; "return" address is address of string			
    call putStr		
    inc hl			                ; inc past null
    jp (hl)		                    ; put it back	

putStr0:                            
    call putchar
    inc hl
putStr:
    ld a,(hl)
    or A
    jr nz,putStr0
    ret

; *******************************************************************************
; *********  END OF MAIN   ******************************************************
; *******************************************************************************

