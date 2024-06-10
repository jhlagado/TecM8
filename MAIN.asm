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
    ld sp, STACK		        
    call init
    call print		
    .pstr "TecM8 0.0\r\n"
    jp parse

init:
    xor a                       
    ld (vPushBack), a            ; nothing in push back buffer
    ld (vToken), a               ; NUL_ token
    ld hl, chars
    ld (vCharPtr), hl
    ld hl, assembly
    ld (vAsmPtr), hl
    ld hl, strings
    ld (vStrPtr), hl
    ld (vTokenVal), hl
    ld hl, symbols
    ld (vSymPtr), hl
    ld hl, exprs
    ld (vExprPtr), hl
    ret

parse:
    call statementList
    call print		
    .pstr "Parsing completed successfully.";
    halt

statementList:
    ld a, (vToken)
    cp EOF_
    ret z
    call statement
    cp END_
    call match
    jr z, statementList 
    call error		
    .pstr "Expected newline"

statement:
    ret

match:
    ret nz
    push af
    call nextToken
    ld l, a
    pop af
    ld a, l
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
    ld hl, 0
nextToken1:
    call nextChar                   ; Get the next character
    call isSpace                    ; Is it a space?
    jr z, nextToken1                 ; If yes, skip it and get the next character
    or a                            ; Is it null (end of input)?
    jr nz, nextToken2                ; If not, continue to the next check
    ld a, EOF_                       ; If yes, return with EOF token
    ret
nextToken2:
    cp "\n"                         ; Is it a newline?
    jr nz, nextToken2x               ; If not, continue to the next check
    ld a, NEWLN_                     ; If yes, return with NEWLN token
    ret
nextToken2x:
    cp ";"                          ; Is it a comment?
    call nz, nextToken4              ; If not, continue to the next check
nextToken3:
    call nextChar                   ; Get the next character in the comment
    cp " "+1                        ; Loop until the next control character
    jr nc, nextToken3
    ld a, COMMENT_                   ; Return with COMMENT token
    ret
nextToken4:
    cp "_"                          ; Is it an identifier?
    jr z, nextToken5                 ; If yes, continue to the next check
    call isAlphaNum                 ; If not, check if it's alphanumeric
    jr nc, nextToken7                ; If not, continue to the next check
nextToken5:
    call ident                      ; Parse the identifier
    call nextChar                   ; Get the next character
    cp ":"                          ; Is it a label?
    jr nz, nextToken6                ; If not, continue to the next check
    ld a, LABEL_                     ; If yes, return with LABEL token
    ret
nextToken6:    
    call pushBackChar                ; Push back the character
    ld (vStrPtr), hl                 ; restore string heap ptr to prev location
    ld de, opcodes                   ; list of opcodes to search
    call searchStr
    jr nc, nextToken7z
    ld a, OPCODE_                    ; Return with IDENT token
    ret
nextToken7z:
    ld de, reg_pairs                 ; list of register pairs to search
    call searchStr
    jr nc, nextToken7y
    ld a, REGPAIR_                   ; Return with REGPAIR token
    ret
nextToken7y:
    ld de, registers                 ; list of registers to search
    call searchStr
    jr nc, nextToken7x
    ld a, REG_                       ; Return with REG token
    ret
nextToken7x:
    ld de, flags                     ; list of registers to search
    call searchStr
    jr nc, nextToken7x
    ld a, FLAG_                       ; Return with FLAG token
    ret
nextToken7a:
    ld de, flags                     ; list of registers to search
    call searchStr
    jr nc, nextToken7b
    ld a, DIRECT_                    ; Return with DIRECT token
    ret
nextToken7b:
    ld a, IDENT_                     ; Return with IDENT token
    ret
nextToken7:
    ld hl, 0
    cp "$"                          ; Is it a hexadecimal number?
    jr nz, nextToken8               ; If not, continue to the next check
    call nextChar                   ; Get the next character
    call isSpace                    ; Check if it's the assembly pointer
    call pushBackChar               ; Push back the character (flags unaffected)
    jr nz, nextToken8a                
    ld a, ASMLOC_
    ret
nextToken8a:    
    call hex
    jr nextToken9a
nextToken8:    
    cp "-"                          ; Is it a negative number?
    jr z, nextToken9                 ; If yes, continue to the next check
    call isDigit                    ; Check if it's a digit
    jr nc, nextToken10                  ; Jump to the next check
nextToken9:
    call number                     ; Parse the number
nextToken9a:
    call pushBackChar               ; Push back the character
    ld a, NUM_                       ; Return with NUM token
    ret
nextToken10:
    ld l, a                          ; Load the token into L
    ld h, 0                          ; Clear H
    ld a, UNKNOWN_                   ; Return with UNKNOWN token
    ret
    
; ident
;
; Reads characters from the input stream and stores them in a string on the heap 
; until a non-alphanumeric character is encountered. The string is stored in 
; Pascal string format, with the length of the string stored in the first byte.
;
; Input:
;   a: The first character of the identifier.
;   (vStrPtr): Points to the top of the strings heap.
;
; Output:
;   hl: Points to the start of the stored string in memory.
;   a: Contains the length of the string.
;   (vStrPtr): Updated to point to the top of the strings heap after the stored string.
;
; Destroyed:
;   c, de

ident:
    ld hl, (vStrPtr)                 ; de = hl = top of strings heap
    ld de, hl                        
    inc hl                          ; skip length byte
ident1:
    ld (hl), a                       ; write char
    inc hl
    call nextChar
    cp "_"
    jr z, ident2
    call isAlphanum
    jr nc, ident3
ident2:
    ld (hl), a
    inc hl
    jr ident1
ident3:
    call pushBackChar
    ld (vStrPtr), hl                 ; update top of strings heap
    or a
    sbc hl, de                       ; hl = length, de = string 
    ex de, hl                        ; e = len, hl = string
    ld (hl), e                       ; save lsb(length)
    ld a, e                          ; a = length
    ret

; isSpace

; checks if the character in the a register is space or tab 

; Input:
;   a: Contains the character to be checked.

; Output:
;   a: Contains the character to be checked.
;   cf: Set if the input character was alphabetic, cleared otherwise.

; Destroyed: 
;   none

isSpace:
    cp " "                          ; is char lowercase?
    ret z                   
    cp "\t"                         ; is char > last letter?
    ret 

; isAlphaNum 

; checks if the character in the a register is an alphanumeric character 
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

; isAlpha

; checks if the character in the a register is an alphabetic character 
; (either uppercase or lowercase). 
; If the character is alphabetic, it converts it to uppercase and sets the carry flag. 

; Input:
;   a: Contains the character to be checked.

; Output:
;   a: Contains the uppercase version of the input character if it was alphabetic.
;   cf: Set if the input character was alphabetic, cleared otherwise.

; Destroyed: 
;   none

isAlpha:
    cp "a"                          ; is char lowercase?
    jr c, isAlpha1                   
    sub $20                         ; yes, convert a to uppercase
isAlpha1:
    cp "Z"+1                        ; is char > last letter?
    ret nc                          ; yes, exit with cf cleared
    cp "A"                          ; is char an uppercase letter ?
    ccf                             ; invert cf
    ret                             

; isHexDigit

; checks if the character in the a register is a hexadecimal 
; digit (0-9, A-F, a-f). If the character is a hex digit, it sets the carry flag. 

; Input:
;   a: Contains the character to be checked.

; Output:
;   cf: Set if the input character was a hex digit, cleared otherwise.

; Destroyed: 
;   none

isHexDigit:
    call isAlpha
    jr nc, isDigit
    cp "F"+1
    ret nc                           ; > "F", not hex, cf = false  
isHexDigit1:

; isDigit

; checks if the character in the a register is a decimal 
; digit (0-9). If the character is a decimal digit, it sets the carry flag. 

; Input:
;   a: Contains the character to be checked.

; Output:
;   cf: Set if the input character was a digit, cleared otherwise.

; Destroyed: 
;   none

isDigit:
    cp "9"+1                        ; is char > '9'?
    ret nc                          ; yes, exit with cf cleared
    cp "0"                          ; is char a decimal digit ?
    ccf                             ; invert cf
    ret

; number

; parse a number from the input. It handles both decimal and hexadecimal 
; numbers, and also supports negative numbers.

; Input: 
;   none

; Output:
;   hl: Contains the parsed number.

; Destroyed: 
;   none

; vTemp1: A temporary memory location used to store the sign of the number.

number:
    cp "-"                        ; Is it a negative number?
    ld a, -1                       ; a = sign flag
    jr z, number1                      
    inc a                          
number1:
    ld (vTemp1), a                 ; Store the sign flag in vTemp1
    call nextChar                 ; Get the next character
    cp "$"                        ; Is it a hexadecimal number?
    jr nz, number2                    
    call hex                      ; If yes, parse the hexadecimal number
    jr number3                       
number2:
    call pushBackChar             ; Push back the character
    call decimal                  ; Parse the decimal number
number3:
    ld a, (vTemp1)                 ; Load the sign from vTemp1
    inc a                         ; Increment a
    ret nz                        
    ex de, hl                      ; negate the value of HL
    ld hl, 0                       
    or a                          
    sbc hl, de                     
    call pushBackChar                ; Push back the character
    ret                           
    
; hex

; parses a hexadecimal number

; Input: none

; Output:
; hl: parsed number

; Destroyed: a

hex:
    ld hl, 0                         ; Initialize HL to 0 to hold the result
hex1:
    call nextChar
    cp "0"                          ; Compare with ASCII '0'
    ret c                           ; If less, exit
    cp "9"+1                        ; Compare with ASCII '9'
    jr c, valid                     ; If less or equal, jump to valid
    cp "a"                          ; is char lowercase letter?
    jr c, hex2                   
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
    add hl, hl                       ; Multiply the number in HL by 16 by shifting it left 4 times
    add hl, hl                       ; This is done because each hexadecimal digit represents 16^n where n is the position of the digit from the right
    add hl, hl
    add hl, hl
    add a, l                     ; Add the new digit to the number in HL
    ld  l, a                     ; Store the result back in L
    jp  hex1                    ; Jump back to hex1 to process the next character

; decimal

; parses a decimal number

; Input: none

; Output:
; hl: parsed number.

; Destroyed registers:

; A: Used for temporary storage and calculations.
; DE: Used for temporary storage and calculations.

decimal:
    ld hl, 0                     ; Initialize HL to 0 to hold the result
decimal1:
    call nextChar
    sub "0"                     ; Subtract ASCII '0' to convert from ASCII to binary
    ret c                       ; If the result is negative, the character was not a digit; return
    cp 10                       ; Compare the result with 10
    ret nc                      ; If the result is 10 or more, the character was not a digit; return
    inc bc                      ; Increment BC to point to the next digit
    ld de, hl                    ; Copy HL to DE
    add hl, hl                   ; Multiply HL by 2
    add hl, hl                   ; Multiply HL by 4
    add hl, de                   ; Add DE to HL to multiply HL by 5
    add hl, hl                   ; Multiply HL by 10
    add a, l                     ; Add the digit in A to the low byte of HL
    ld l, a                      ; Store the result in the low byte of HL
    ld a, 0                      ; Clear A
    adc a, h                     ; Add the carry from the previous addition to the high byte of HL
    ld h, a                      ; Store the result in the high byte of HL
    jr decimal1                 ; Jump back to the start of the loop    


; searchStr

; search through a list of Pascal strings for a match. 

; Inputs:
;   hl: Points to the string to search for.
;   de: Points to the start of the list of strings.

; Outputs:
;   cf: true if match
;   a: index of the matching string if a match is found, 
;      or -1 if no match is found.
;   hl: Points to the string to search for.

; Destroyed: 
;   a, b, c, d, e, a', f'

    ex de, hl                    ; de = search string hl = string list
    xor a                       ; Initialize the index counter, zf = true, cf = false
    ex af, af'
searchStr:
    ld a, (de)                   ; Load the length of search string
    ld b, a                      ; Copy the length to b for looping
    push de                     ; Store search string 
    push hl                     ; Store current string 
    cp (hl)                     ; Compare with the length of the current string
    jr nz, searchStr2           ; If the lengths are not equal, move to the next string
    inc de                      ; Move to the start of the search string
    inc hl                      ; Move to the start of the current string
searchStr1:
    ld a, (de)                   ; Load the next character from search string
    cp (hl)                     ; Compare with the next character in the current string
    jr nz, searchStr2            ; If the characters are not equal, move to the next string
    inc de                      ; Move to the next character in the search string
    inc hl                      ; Move to the next character in the current string
    djnz searchStr1             ; Loop until we've compared all characters
    pop hl                      ; discard current string
    pop hl                      ; hl = search string
    ex af, af'                   ; Load the index of the match
    ccf                         ; if match, cf = true
    ret 
searchStr2:
    pop hl                      ; Restore current string
    pop de                      ; Restore search string
    ld a, (hl)                   ; Load the length of the current string
    inc a                       ; a = length byte plus length of string
    ld c, a                      ; bc = a
    ld b, 0
    add hl, bc                   ; hl += bc, the next string
    push de                     ; Store search string
    push hl                     ; Store current string
    ex af, af'                   ; Increment the index counter, zf = false, cf = false
    inc a                       
    ex af, af'
    ld a, (hl)                   ; a = length of next string
    or a                        ; If a != 0, continue searching
    jr nz, searchStr          
    dec a                       ; a = NO_MATCH (i.e. -1), zf = false
    ccf                         ; cf = false
    ret 
    
; nextChar

; checks if there is a character that has been pushed back for re-reading. 
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

; pushBackChar

; push back a character for re-reading. It sets the high bit of the 
; character as a flag to indicate that this character has been pushed back, and 
; stores the character in the pushback buffer.

; Input:
; a: Contains the character to be pushed back.

; Output: None.

; Destroyed: none, no flags 

pushBackChar:
    set 7, a                         ; Set the high bit of the character with affecting flags
    ld (vPushBack), a               ; Store the character in the pushback buffer
    ret 
    
prompt:                            
    call print
    .pstr "\r\n> "
    ret

crlf:                               
    call print
    .pstr "\r\n"
    ret

error:
    pop hl
    call printStr
    halt

print:                           
    pop hl		                    ; "return" address is address of string			
    call printStr		
    jp (hl)		                    ; put it back	

; print
;
; Prints a Pascal string to the console.
;
; Input:
;   hl: Points to the start of the Pascal string in memory. The first byte at this location should be the length of the string, followed by the string data.
;
; Output:
;   hl: points to the byte after the end of the string .
;
; Destroyed:
;   a, b

printStr:
    ld a, (hl)     ; Load the length of the string
    or a           ; Check if A is zero
    ret z          ; If it is, return immediately
    inc hl         ; Move to the start of the string data
    ld b, a        ; Copy the length to B for looping
printStr1:
    ld a, (hl)     ; Load the next character
    call putchar   ; Call a routine that prints a single character
    inc hl         ; Move to the next character
    djnz printStr1 ; Decrement B and jump if not zero
    ret            ; Return from the routine

; *******************************************************************************
; *********  END OF MAIN   ******************************************************
; *******************************************************************************

