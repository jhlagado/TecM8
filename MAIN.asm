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
    ld (vToken), a                      ; NUL_ token
    ld (vBufferPos), a                  ; 0th buffer pos
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
    call nextToken
    cp EOF_
    ret z
    call statement
    jr statementList 

statement:
    cp LABEL_
    jr nz,statement10
    ; call addLabel                     ; add label to symbol table 
statement10:    
    call nextToken
    cp OPCODE_
    jr nz, statement1
    ; jp parseInstruction
statement1:    
    cp DIRECT_
    ret nz
    ; jp parseDirective
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
    bit 7, (vToken)                 ; Check the high bit of the pushback buffer
    jp z, nextToken0               
    ld a, (vToken)                  ; If the high bit is 1, load the pushed back character into A
    ld hl, (vTokenVal)
    res 7,a                         ; Clear the high bit
    ld (vToken), a                  ; Store the character back in the buffer
    ret                             ; Return with the pushed back character in A
nextToken0:
    ld hl, 0
nextToken1:
    call nextChar                   ; Get the next character
    call isSpace                    ; Is it a space?
    jr z, nextToken1                ; If yes, skip it and get the next character
    or a                            ; Is it null (end of input)?
    jr nz, nextToken2               ; If not, continue to the next check
    ld a, EOF_                      ; If yes, return with EOF token
    ret
nextToken2:
    cp "\n"                         ; Is it a newline?
    jr nz, nextToken3               ; If not, continue to the next check
    ret z                           ; token same value as char in a
nextToken3:
    cp ";"                          ; Is it a comment?
    call nz, nextToken5             ; If not, continue to the next check
nextToken4:
    call nextChar                   ; Get the next character in the comment
    cp " "+1                        ; Loop until the next control character
    jr nc, nextToken4
    ld a, COMMENT_                  ; Return with COMMENT token
    ret
nextToken5:
    cp "_"                          ; Is it an identifier?
    jr z, nextToken6                ; If yes, continue to the next check
    call isAlphaNum                 ; If not, check if it's alphanumeric
    jr nc, nextToken13              ; If not, continue to the next check
nextToken6:
    call ident                      ; Parse the identifier
    call nextChar                   ; Get the next character
    cp ":"                          ; Is it a label?
    jr nz, nextToken7               ; If not, continue to the next check
    ld a, LABEL_                    ; If yes, return with LABEL token
    ret
nextToken7:    
    call rewindChar               ; Push back the character
    ld (vStrPtr), hl                ; restore string heap ptr to prev location
    ld de, opcodes                  ; list of opcodes to search
    call searchStr
    jr nc, nextToken8
    ld a, OPCODE_                   ; Return with IDENT token
    ret
nextToken8:
    ld de, reg_pairs                ; list of register pairs to search
    call searchStr
    jr nc, nextToken9
    ld a, REGPAIR_                  ; Return with REGPAIR token
    ret
nextToken9:
    ld de, registers                ; list of registers to search
    call searchStr
    jr nc, nextToken10
    ld a, REG_                      ; Return with REG token
    ret
nextToken10:
    ld de, flags                    ; list of registers to search
    call searchStr
    jr nc, nextToken10
    ld a, FLAG_                     ; Return with FLAG token
    ret
nextToken11:
    ld de, flags                    ; list of registers to search
    call searchStr
    jr nc, nextToken12
    ld a, DIRECT_                   ; Return with DIRECT token
    ret
nextToken12:
    ld a, IDENT_                    ; Return with IDENT token
    ret
nextToken13:
    ld hl, 0
    cp "$"                          ; Is it a hexadecimal number?
    jr nz, nextToken14              ; If not, continue to the next check
    call nextChar                   ; Get the next character
    call isSpace                    ; Check if it's the assembly pointer
    call rewindChar               ; Push back the character (flags unaffected)
    ret z                           ; token same value as char in a
    call number0                    ; process hexasdecimal number
    jr nextToken16
nextToken14:    
    cp "-"                          ; Is it a negative number?
    jr z, nextToken15               ; If yes, continue to the next check
    call isDigit                    ; Check if it's a digit
    jr nc, nextToken17              ; Jump to the next check
nextToken15:
    call number                     ; Parse the number
nextToken16:
    ld a, NUM_                      ; Return with NUM token
    ret
nextToken17:
    cp "("
    ret z                           ; token same value as char in a
    cp ")"
    ret z                           ; token same value as char in a
    cp ","
    ret z                           ; token same value as char in a
    ld a, UNKNOWN_                  ; Return with UNKNOWN token
    ret


pushBackToken:
    set 7, a                        ; Set the high bit of the character with affecting flags
    ld (vToken), a                  ; Store the character in the pushback buffer
    ld (vTokenVal), hl
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
    call rewindChar
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

number0:
    xor a
    ld (vTemp1), a                  ; Store the sign flag in vTemp1
    call hex                        ; If yes, parse the hexadecimal number
    jr number3                       

number:
    cp "-"                          ; Is it a negative number?
    ld a, -1                        ; a = sign flag
    jr z, number1                      
    inc a                          
number1:
    ld (vTemp1), a                  ; Store the sign flag in vTemp1
    call nextChar                   ; Get the next character
    cp "$"                          ; Is it a hexadecimal number?
    jr nz, number2                    
    call hex                        ; If yes, parse the hexadecimal number
    jr number3                       
number2:
    call rewindChar               ; Push back the character
    call decimal                    ; Parse the decimal number
number3:
    ld a, (vTemp1)                  ; Load the sign from vTemp1
    inc a                           ; Increment a
    ret nz                        
    ex de, hl                       ; negate the value of HL
    ld hl, 0                       
    or a                          
    sbc hl, de                     
    call rewindChar               ; Push back the character
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
    ret c                           ; < 0 not a valid hexadecimal digit so return
    cp $10                          ; Compare the result with $10
    ret nc                          ; > $10 not a valid hexadecimal digit so return
    add hl, hl                      ; Multiply the number in HL by 16 by shifting it left 4 times
    add hl, hl                      ; This is done because each hexadecimal digit represents 16^n where n is the position of the digit from the right
    add hl, hl
    add hl, hl
    add a, l                        ; Add the new digit to the number in HL
    ld  l, a                        ; Store the result back in L
    jp  hex1                        ; Jump back to hex1 to process the next character

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
    sub "0"                      ; convert from ASCII to binary
    ret c                        ; < 0 not a digit; return
    cp 10                        ; Compare the result with 10
    ret nc                       ; > 10 not a digit; return
    inc bc                       ; Increment BC to point to the next digit
    ld de, hl                    ; Copy HL to DE
    add hl, hl                   ; Multiply HL by 2
    add hl, hl                   ; Multiply HL by 4
    add hl, de                   ; Add DE to HL to multiply HL by 5
    add hl, hl                   ; Multiply HL by 10
    add a, l                     ; hl += a
    ld l, a                      
    ld a, 0                      
    adc a, h                     
    ld h, a                      
    jr decimal1                  ; Jump back to the start of the loop    


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

    ex de, hl                   ; de = search string hl = string list
    xor a                       ; Initialize the index counter, zf = true, cf = false
    ex af, af'
searchStr:
    ld a, (de)                  ; Load the length of search string
    ld b, a                     ; Copy the length to b for looping
    push de                     ; Store search string 
    push hl                     ; Store current string 
    cp (hl)                     ; Compare with the length of the current string
    jr nz, searchStr2           ; If the lengths are not equal, move to the next string
    inc de                      ; Move to the start of the search string
    inc hl                      ; Move to the start of the current string
searchStr1:
    ld a, (de)                  ; Load the next character from search string
    cp (hl)                     ; Compare with the next character in the current string
    jr nz, searchStr2           ; If the characters are not equal, move to the next string
    inc de                      ; Move to the next character in the search string
    inc hl                      ; Move to the next character in the current string
    djnz searchStr1             ; Loop until we've compared all characters
    pop hl                      ; discard current string
    pop hl                      ; hl = search string
    ex af, af'                  ; Load the index of the match
    ccf                         ; if match, cf = true
    ret 
searchStr2:
    pop hl                      ; Restore current string
    pop de                      ; Restore search string
    ld a, (hl)                  ; Load the length of the current string
    inc a                       ; a = length byte plus length of string
    ld c, a                     ; bc = a
    ld b, 0
    add hl, bc                  ; hl += bc, the next string
    push de                     ; Store search string
    push hl                     ; Store current string
    ex af, af'                  ; Increment the index counter, zf = false, cf = false
    inc a                       
    ex af, af'
    ld a, (hl)                  ; a = length of next string
    or a                        ; If a != 0, continue searching
    jr nz, searchStr          
    dec a                       ; a = NO_MATCH (i.e. -1), zf = false
    ccf                         ; cf = false
    ret 
    
; *****************************************************************************
; Routine: nextChar
; 
; Purpose:
;    Fetches the next character from the buffer. If the buffer is empty or 
;    contains a null character (0), it refills the buffer by calling nextLine.
; 
; Inputs:
;    None
; 
; Outputs:
;    A - The next character from the buffer
; 
; Registers Destroyed:
;    A, D, E, HL
; *****************************************************************************

nextChar:
    ld hl, vBufferPos          ; Load the offset of buffer position variable
    ld a, (hl)                 ; Load the current position offset in the buffer into A
    cp BUFFER_SIZE             ; Compare with buffer size
    jp z, nextLine             ; Jump to nextLine if end of buffer
    ld e, a                    ; Copy buffer position offset to E
    ld d, msb(buffer)          ; Load the MSB of the buffer's address into D
    ld a, (de)                 ; Load the character at the current buffer position into A
    or a                       ; Check if the character is 0 (end of line)
    jr z, nextLine             ; Jump to nextLine if character is 0
    inc (hl)                   ; Increment the buffer position offset
    ret                        ; Return with the character in A

; *****************************************************************************
; Routine: nextLine
; 
; Purpose:
;    Refills the buffer by repeatedly calling getchar to fetch new characters
;    and stores them in the buffer. Stops when the buffer is full or a 
;    non-printable character is encountered.
; 
; Inputs:
;    None
; 
; Outputs:
;    A - The first character in the refilled buffer
; 
; Registers Destroyed:
;    A, B, HL
; *****************************************************************************

nextLine:
    ld hl, buffer               ; Start of the buffer
    ld b, BUFFER_SIZE           ; Number of bytes to fill
nextLine1:
    call getchar                ; Get a character from getchar
    ld (hl), a                  ; Store it in the buffer
    inc hl                      ; Move to the next position in the buffer
    cp " "                      ; Check if the character is a space
    jr c, nextLine2             ; If less than space (non-printable), skip djnz
    djnz nextLine1              ; Repeat until B decrements to 0
nextLine2:
    xor a                       ; Clear A register
    ld (vBufferPos), a          ; Reset buffer position to 0
    jr nextChar                 ; Jump back to nextChar to return the first char

; *****************************************************************************
; Routine: rewindChar
; 
; Purpose:
;    Rewinds the buffer position by one character, effectively pushing back the
;    buffer position by one character in the input stream.
; 
; Inputs:
;    None
; 
; Outputs:
;    None
; 
; Registers Destroyed:
;    A
; *****************************************************************************

rewindChar:
    ld hl, vBufferPos     ; Load the address of buffer position variable
    ld a, (hl)            ; Load the current position in the buffer into A
    or a                  ; Check if the buffer position is zero
    ret z                 ; If zero, nothing to push back, return
    dec (hl)              ; Decrement the buffer position
    ret                   ; Return

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

