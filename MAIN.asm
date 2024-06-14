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


; *****************************************************************************
; Routine: start
; 
; Purpose:
;    Entry point of TecM8. Initializes the stack pointer, calls the initialization
;    routine, prints TecM8 version information, and jumps to the parsing routine.
; 
; Inputs:
;    None
; 
; Outputs:
;    None
; 
; Registers Destroyed:
;    A, HL
; *****************************************************************************

start:
    ld sp, STACK        ; Initialize stack pointer
    call init           ; Call initialization routine
    call print          ; Print TecM8 version information
    .pstr "TecM8 0.0\r\n"
    jp parse            ; Jump to the parsing routine

; *****************************************************************************
; Routine: init
; 
; Purpose:
;    Initializes various pointers and variables used by TecM8.
; 
; Inputs:
;    None
; 
; Outputs:
;    None
; 
; Registers Destroyed:
;    A, HL
; *****************************************************************************

init:
    xor a               ; Clear A register
    ld (vToken), a      ; Initialize vToken with NUL_ token
    ld (vBufferPos), a  ; Initialize buffer position
    ld hl, assembly     ; Load assembly pointer
    ld (vAsmPtr), hl    ; Store in vAsmPtr
    ld hl, strings      ; Load strings pointer
    ld (vStrPtr), hl    ; Store in vStrPtr
    ld (vTokenVal), hl  ; Initialize token value pointer
    ld hl, symbols      ; Load symbols pointer
    ld (vSymPtr), hl    ; Store in vSymPtr
    ld hl, exprs        ; Load expressions pointer
    ld (vExprPtr), hl   ; Store in vExprPtr
    ret                 ; Return

; *****************************************************************************
; Routine: parse
; 
; Purpose:
;    Parses the input program, calling the statementList routine, printing the
;    completion message, and halting the system.
; 
; Inputs:
;    None
; 
; Outputs:
;    None
; 
; Registers Destroyed:
;    None
; *****************************************************************************

parse:
    call statementList         ; Parse the input program
    call print                 ; Print completion message
    .pstr "Parsing completed successfully."
    halt                       ; Halt the system

; *****************************************************************************
; Routine: statementList
; 
; Purpose:
;    Parses a list of statements, repeatedly calling the statement routine until
;    the end of file (EOF) token is encountered.
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

statementList:
    call nextToken             ; Get the next token
    cp EOF_                    ; Check if it's the end of file
    ret z                      ; If yes, return
    call statement             ; Parse a statement
    jr statementList           ; Repeat for the next statement

; *****************************************************************************
; Routine: statement
; 
; Purpose:
;    Parses a single statement, checking its type (label, opcode, or directive)
;    and performing corresponding actions.
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

statement:
    ; setOpcode null
    ; setOperand1 null
    ; setOperand2 null
    cp LABEL_                  ; Check if it's a label
    jr nz, statement10         ; If not, jump to statement10
    ; call addLabel            ; Add label to symbol table
    call nextToken             ; Get the next token
statement10:
    cp OPCODE_                 ; Check if it's an opcode
    jr nz, statement1          
    ; call instruction      ; Jump to parseInstruction routine
    ; call nextToken
    ; jr statement2
statement1:
    cp DIRECT_                 ; Check if it's a directive
    jr nz, statement2          
    ; jp directive        ; Jump to parseDirective routine
    ; call nextToken
statement2:
    cp NEWLN_
    ret z
    cp EOF_
    ret z
    ; throw error, expected NEWLN or EOF
    ret

instruction:
    ; check if Opcode has been set
    ; setOpcode a
    call nextToken
    cp NEWLN_
    jr z,instruction1
    cp EOF_
    jr z,instruction2
instruction1:
    call pushBackToken
instruction2:
    call firstOperand
    call nextToken
    cp COMMA_
    call nextToken
    call secondOperand

firstOperand:
secondOperand:

directive:    

; nextToken is a lexer function that reads characters from the input and classifies 
; them into different token types. It handles whitespace, end of input, newlines, 
; comments, identifiers, labels, directives, hexadecimal numbers, and other symbols.

; Input: None

; Output:
; a: contains the type of the next token.
; hl: contains the value associated with the next token.

; Destroyed: None

; *****************************************************************************
; Routine: nextToken
; 
; Purpose:
;    Parses the next token from the input stream, identifying various types of
;    tokens such as identifiers, labels, opcodes, registers, flags, numbers,
;    and special characters.
; 
; Inputs:
;    None
; 
; Outputs:
;    A - Token representing the type of the parsed element
; 
; Registers Destroyed:
;    A, BC, DE, HL
; *****************************************************************************

nextToken:
    bit 7, (vToken)             ; Check the high bit of the pushback buffer
    jp z, nextToken0            ; If high bit clear, nothing pushed back 
    ld a, (vToken)              ; If high bit set, load the pushed back token type into A
    ld hl, (vTokenVal)          ; and token value into HL
    res 7, a                    ; Clear the high bit
    ld (vToken), a              ; Store the character back in the buffer
    ret                         ; Return with the pushed back character in A

nextToken0:
    ld hl, 0                    ; Initialize HL with 0

nextToken1:
    call nextChar               ; Get the next character
    call isSpace                ; Check if it's a space
    jr z, nextToken1            ; If yes, skip it and get the next character
    or a                        ; Is it null (end of input)?
    jr nz, nextToken2           ; If not, continue to the next check
    ld a, EOF_                  ; If yes, return with EOF token
    ret

nextToken2:
    cp "\n"                     ; Is it a newline?
    jr nz, nextToken3           ; If not, continue to the next check
    ld a, EOF_                  ; If yes, return with EOF token
    ret                         ; Return with newline token

nextToken3:
    cp ";"                      ; Is it a comment?
    call nz, nextToken5         ; If not, continue to the next check

nextToken4:
    call nextChar               ; Get the next character in the comment
    cp " "+1                    ; Loop until the next control character
    jr nc, nextToken4
    call rewindChar             ; Push back the character
    jr nextToken0               ; return with control char

nextToken5:
    cp "_"                      ; Is it an identifier?
    jr z, nextToken6            ; If yes, continue to the next check
    call isAlphaNum             ; If not, check if it's alphanumeric
    jr nc, nextToken13          ; If not, continue to the next check

nextToken6:
    call ident                  ; Parse the identifier
    call nextChar               ; Get the next character
    cp ":"                      ; Is it a label?
    jr nz, nextToken7           ; If not, continue to the next check
    ld a, LABEL_                ; If yes, return with LABEL token
    ret

nextToken7:    
    call rewindChar             ; Push back the character
    ld (vStrPtr), hl            ; Restore string heap pointer to previous location
    call searchOpcode
    jr nc, nextToken8
    ld a, OPCODE_               ; Return with OPCODE token
    ret

nextToken8:
    ld de, reg_pairs            ; List of register pairs to search
    call searchStr
    jr nc, nextToken9
    ld a, REGPAIR_              ; Return with REGPAIR token
    ret

nextToken9:
    ld de, registers            ; List of registers to search
    call searchStr
    jr nc, nextToken10
    ld a, REG_                  ; Return with REG token
    ret

nextToken10:
    ld de, flags                ; List of flags to search
    call searchStr
    jr nc, nextToken11
    ld a, FLAG_                 ; Return with FLAG token
    ret

nextToken11:
    ld de, flags                ; List of flags to search
    call searchStr
    jr nc, nextToken12

    ld a, DIRECT_               ; Return with DIRECT token
    ret

nextToken12:
    ld a, IDENT_                ; Return with IDENT token
    ret

nextToken13:
    ld hl, 0
    cp "$"                      ; Is it a hexadecimal number?
    jr nz, nextToken14          ; If not, continue to the next check
    call nextChar               ; Get the next character
    call isSpace                ; Check if it's the assembly pointer
    call rewindChar             ; Push back the character (flags unaffected)
    ret z                       ; Return with the assembly pointer token
    call number_hex             ; Process hexadecimal number
    jr nextToken16

nextToken14:    
    cp "-"                      ; Is it a negative number?
    jr z, nextToken15           ; If yes, continue to the next check
    call isDigit                ; Check if it's a digit
    jr nc, nextToken17          ; Jump to the next check

nextToken15:
    call number                 ; Parse the number

nextToken16:
    ld a, NUM_                  ; Return with NUM token
    ret

nextToken17:
    cp "("
    ret z                       ; Return with the '(' token
    cp ")"
    ret z                       ; Return with the ')' token
    cp ","
    ret z                       ; Return with the ',' token
    ld a, UNKNOWN_              ; Return with UNKNOWN token
    ret

; *****************************************************************************
; Routine: searchOpcode
; 
; Purpose:
;    Searches for a matching opcode in various lists of opcodes.
; 
; Inputs:
;    HL - Points to the string to search for.
; 
; Outputs:
;    CF - Set if a match is found, cleared otherwise.
;    A  - Contains the index of the matching opcode if a match is found,
;         or the last checked index if no match is found.
; 
; Registers Destroyed:
;    A, DE, F
; *****************************************************************************

searchOpcode:
    ld de, alu_opcodes          ; Point DE to the list of ALU opcodes
    call searchStr              ; Call searchStr to search for the string in ALU opcodes
    ret c                       ; If carry flag is set, return (match found)

    ld de, rot_opcodes          ; Point DE to the list of ROT opcodes
    call searchStr              ; Call searchStr to search for the string in ROT opcodes
    bit 1, a                    ; Check bit 1 of register A (flags unaffected)
    ret c                       ; If carry flag is set, return (match found)

    ld de, gen_opcodes          ; Point DE to the list of general opcodes
    call searchStr              ; Call searchStr to search for the string in general opcodes
    bit 5, a                    ; Check bit 5 of register A (flags unaffected)
    ret                         ; Return (if match found or not)

; *****************************************************************************
; Routine: pushBackToken
; 
; Purpose:
;    Pushes back a token into the pushback buffer to allow the token to be
;    re-read by the nextToken routine.
; 
; Inputs:
;    A  - token type
;    HL - token value
; 
; Outputs:
;    None
; 
; Registers Destroyed:
;    A, DE
; *****************************************************************************

pushBackToken:
    set 7, a                    ; Set the high bit of the token type (without affecting flags)
    ld (vToken), a              ; push back the token
    ld (vTokenVal), hl          ; push back the token value
    ret                         
   

; *****************************************************************************
; Routine: ident
; 
; Purpose:
;    Reads characters from the input stream until a charcter which is not an
;    an underscore or an alphanumeric character is encountered. Writes the chars 
;    to a Pascal string and updates the top of the strings heap pointer.
;    It also calculates the length of the string and stores it at the beginning
;    of the string.
; 
; Inputs:
;    A - Current character read from the input stream
;    vStrPtr - Address of the top of strings heap pointer
; 
; Outputs:
;    None
; 
; Registers Destroyed:
;    A, DE, HL
; *****************************************************************************

ident:
    ld hl, (vStrPtr)        ; Load the address of the top of strings heap
    ld de, hl               ; Copy it to DE (DE = HL = top of strings heap)
    inc hl                  ; Move to the next byte to skip the length byte
ident1:
    ld (hl), a              ; Write the current character to the string buffer
    inc hl                  ; Move to the next position in the buffer
    call nextChar           ; Get the next character from the input stream
    cp "_"                  ; Compare with underscore character
    jr z, ident2            ; If underscore, jump to ident2
    call isAlphanum         ; Check if the character is alphanumeric
    jr nc, ident3           ; If not alphanumeric, jump to ident3
ident2:
    ld (hl), a              ; Write the current character to the string buffer
    inc hl                  ; Move to the next position in the buffer
    jr ident1               ; Repeat the process
ident3:
    call rewindChar         ; Rewind the input stream by one character
    ld (vStrPtr), hl        ; Update the top of strings heap pointer
    or a                    ; Clear A register
    sbc hl, de              ; Calculate the length of the string (HL = length, DE = string)
    ex de, hl               ; Swap DE and HL (E = length, HL = string)
    ld (hl), e              ; Store the length at the beginning of the string buffer
    ld a, e                 ; Load the length into A
    ret                     

; *****************************************************************************
; Routine: expr
; 
; Purpose:
;    Collects a string until it reaches a right parenthesis, comma, semicolon,
;    or newline character. Keeps track of parentheses to ensure correct ending
;    of the expression.
; 
; Inputs:
;    None
; 
; Outputs:
;    HL - Points to the collected string.
;    A - Contains the length of the collected string.
; 
; Registers Destroyed:
;    A, C, D, E, HL
; *****************************************************************************

expr:
    ld hl, (vStrPtr)        ; Load the address of the top of strings heap
    ld de, hl               ; Copy it to DE (DE = HL = top of strings heap)
    inc hl                  ; Move to the next byte to skip the length byte
    ld c, 1                 ; Initialize parenthesis count to 1
expr1:
    ld (hl), a              ; Write the current character to the string buffer
    inc hl                  ; Move to the next position in the buffer
    call nextChar           ; Get the next character from the input stream
    cp '('                  ; Compare with left parenthesis character
    jr z, expr2             ; If left parenthesis, increase count
    cp ')'                  ; Compare with right parenthesis character
    jr z, expr3             ; If right parenthesis, decrease count
    cp ','                  ; Compare with comma character
    jr z, expr4             ; If comma, check if parentheses count is zero
    cp ';'                  ; Compare with semicolon character
    jr z, expr4             ; If semicolon, check if parentheses count is zero
    cp '\n'                 ; Compare with newline character
    jr z, expr4             ; If newline, check if parentheses count is zero
    call isAlphanum         ; Check if the character is alphanumeric
    jr nc, expr4            ; If not alphanumeric, check if parentheses count is zero
    jr expr1                ; Repeat the process
expr2:
    inc c                   ; Increase parentheses count
    jr expr1                ; Repeat the process
expr3:
    dec c                   ; Decrease parentheses count
    jr nz, expr1            ; If not zero, continue collecting
    jr expr5                ; If zero, end collection
expr4:
    xor a
    cp c                    ; Check if parentheses count is zero
    jr nz, expr1            ; If not zero, continue collecting
expr5:
    call rewindChar         ; Rewind the input stream by one character
    ld (vStrPtr), hl        ; Update the top of strings heap pointer
    or a                    ; Clear A register
    sbc hl, de              ; Calculate the length of the string (HL = length, DE = string)
    ex de, hl               ; Swap DE and HL (E = length, HL = string)
    ld (hl), e              ; Store the length at the beginning of the string buffer
    ld a, e                 ; Load the length into A
    ret                    

; *****************************************************************************
; Routine: isSpace
; 
; Purpose:
;    Checks if the character in the A register is a space or tab character.
; 
; Input:
;    A - Contains the character to be checked.
; 
; Output:
;    A - Contains the character to be checked.
;    CF - Set if the input character was space or tab, cleared otherwise.
; 
; Destroyed:
;    None
; *****************************************************************************

isSpace:
    cp " "            ; Compare with space character
    ret z             ; Return if it's space
    cp "\t"           ; Compare with tab character
    ret               ; Return

; *****************************************************************************
; Routine: isAlphaNum
; 
; Purpose:
;    Checks if the character in the A register is an alphanumeric character 
;    (either uppercase or lowercase). If the character is alphabetic, it converts 
;    it to uppercase and sets the carry flag. If the character is not alphabetic, 
;    it clears the carry flag.
; 
; Input:
;    A - Contains the character to be checked.
; 
; Output:
;    A - Contains the uppercase version of the input character if it was alphabetic.
;    CF - Set if the input character was alphabetic, cleared otherwise.
; 
; Destroyed:
;    C
; *****************************************************************************

isAlphaNum:
    call isDigit        ; Check if it's a digit
    ret z               ; If it's not a digit, continue to isAlpha
                        ; Falls through to isAlpha

; *****************************************************************************
; Routine: isAlpha
; 
; Purpose:
;    Checks if the character in the A register is an alphabetic character 
;    (either uppercase or lowercase). If the character is alphabetic, it converts 
;    it to uppercase and sets the carry flag.
; 
; Input:
;    A - Contains the character to be checked.
; 
; Output:
;    A - Contains the uppercase version of the input character if it was alphabetic.
;    CF - Set if the input character was alphabetic, cleared otherwise.
; 
; Destroyed:
;    None
; *****************************************************************************

isAlpha:
    cp "a"            ; Compare with lowercase 'a'
    jr c, isAlpha1    ; Jump if it's lower than 'a'
    sub $20           ; Convert lowercase to uppercase
isAlpha1:
    cp "Z"+1          ; Compare with 'Z' + 1
    ret nc            ; Return if it's not alphabetic
    cp "A"            ; Compare with 'A'
    ccf               ; Invert CF to set it if it's alphabetic
    ret               ; Return

; *****************************************************************************
; Routine: isDigit
; 
; Purpose:
;    Checks if the character in the A register is a decimal digit (0-9). If 
;    the character is a decimal digit, it sets the carry flag.
; 
; Input:
;    A - Contains the character to be checked.
; 
; Output:
;    CF - Set if the input character was a digit, cleared otherwise.
; 
; Destroyed:
;    None
; *****************************************************************************

isDigit:
    cp "9"+1          ; Compare with '9' + 1
    ret nc            ; Return if it's not a digit
    cp "0"            ; Compare with '0'
    ccf               ; Invert CF to set it if it's a digit
    ret               ; Return

; *****************************************************************************
; Routine: number
; 
; Purpose:
;    Parse a number from the input. Handles both decimal and hexadecimal 
;    numbers, and supports negative numbers.
; 
; Input:
;    None
; 
; Output:
;    HL - Contains the parsed number.
; 
; Destroyed:
;    None
; *****************************************************************************

number:
    cp "-"             ; Check if it's a negative number
    ld a, -1           ; Set sign flag
    jr z, number1      
    inc a              ; Set sign flag to positive
number1:
    ld (vTemp1), a     ; Store the sign flag in vTemp1
    call nextChar      ; Get the next character
    cp "$"             ; Check if it's a hexadecimal number
    jr nz, number2     
    call hex           ; If yes, parse hexadecimal number
    jr number3         
number2:
    call rewindChar    ; Push back the character
    call decimal       ; Parse decimal number
number3:
    ld a, (vTemp1)     ; Load the sign from vTemp1
    inc a              ; Increment to negate if necessary
    ret nz             ; Return if sign is not zero
    ex de, hl          ; Negate the value of HL
    ld hl, 0           ; Load zero to clear carry
    or a               ; Clear carry flag
    sbc hl, de         ; Subtract DE from HL
    call rewindChar    ; Push back the character
    ret                ; Return

number_hex:
    xor a
    ld (vTemp1), a     ; Store the sign flag in vTemp1
    call hex           ; Parse hexadecimal number
    jr number3         

; *****************************************************************************
; Routine: hex
; 
; Purpose:
;    Parse a hexadecimal number.
; 
; Input:
;    None
; 
; Output:
;    HL - Parsed number.
; 
; Destroyed:
;    A
; *****************************************************************************

hex:
    ld hl, 0           ; Initialize HL to 0
hex1:
    call nextChar      ; Get the next character
    cp "0"             ; Compare with ASCII '0'
    ret c              ; Return if less than '0'
    cp "9"+1           ; Compare with ASCII '9' + 1
    jr c, valid        ; If less or equal, jump to valid
    cp "a"             ; Compare with ASCII 'a'
    jr c, hex2         ; If less, jump to hex2
    sub $20            ; Convert lowercase to uppercase
hex2:
    cp "A"             ; Compare with ASCII 'A'
    ret c              ; Return if less than 'A'
    cp "F"+1           ; Compare with ASCII 'F' + 1
    jr c, upper        ; If less or equal, jump to upper
upper:
    sub $37            ; Convert ASCII to hexadecimal
valid:
    sub "0"            ; Convert ASCII to numeric value
    ret c              ; Return if less than 0 (not a valid digit)
    cp $10             ; Compare with 16
    ret nc             ; Return if greater than 16 (not a valid digit)
    add hl, hl         ; Multiply by 16
    add hl, hl         ; Multiply by 16
    add hl, hl         ; Multiply by 16
    add hl, hl         ; Multiply by 16
    add a, l           ; Add new digit to HL
    ld  l, a           ; Store result back in L
    jp  hex1           ; Jump back to hex1 to process next character

; *****************************************************************************
; Routine: decimal
; 
; Purpose:
;    Parse a decimal number.
; 
; Input:
;    None
; 
; Output:
;    HL - Parsed number.
; 
; Destroyed:
;    A, DE
; *****************************************************************************

decimal:
    ld hl, 0           ; Initialize HL to 0
decimal1:
    call nextChar      ; Get the next character
    sub "0"            ; Convert ASCII to binary
    ret c              ; Return if less than '0'
    cp 10              ; Compare with 10
    ret nc             ; Return if greater than 10
    inc bc             ; Increment BC to point to next digit
    ld de, hl          ; Copy HL to DE
    add hl, hl         ; Multiply HL by 2
    add hl, hl         ; Multiply HL by 4
    add hl, de         ; Add DE to HL to multiply by 5
    add hl, hl         ; Multiply HL by 10
    add a, l           ; Add A to HL
    ld l, a            ; Store result back in L
    ld a, 0            ; Clear A
    adc a, h           ; Add carry to H
    ld h, a            ; Store result back in H
    jr decimal1        ; Jump back to start of loop


; *****************************************************************************
; Routine: searchStr
; 
; Purpose:
;    Search through a list of Pascal strings for a match.
; 
; Inputs:
;    HL - Points to the string to search for.
;    DE - Points to the start of the list of strings.
; 
; Outputs:
;    CF - True if match, false otherwise.
;    A - Index of the matching string if a match is found, or -1 if no match 
;        is found.
;    HL - Points to the string to search for.
; 
; Destroyed:
;    A, B, C, D, E, A', F'
; *****************************************************************************

searchStr:
    ex de, hl             ; DE = search string, HL = string list
    xor a                 ; Initialize index counter, ZF = true, CF = false
    ex af, af'            ; Exchange AF with AF prime

searchStrLoop:
    ld a, (de)            ; Load length of search string
    ld b, a               ; Copy length to B for looping
    push de               ; Store search string
    push hl               ; Store current string
    cp (hl)               ; Compare with length of current string
    jr nz, searchStrNext  ; If lengths are not equal, move to next string
    inc de                ; Move to start of search string
    inc hl                ; Move to start of current string
searchStrCharLoop:
    ld a, (de)            ; Load next character from search string
    cp (hl)               ; Compare with next character in current string
    jr nz, searchStrNext  ; If characters are not equal, move to next string
    inc de                ; Move to next character in search string
    inc hl                ; Move to next character in current string
    djnz searchStrCharLoop ; Loop until all characters compared
    pop hl                ; Discard current string
    pop hl                ; HL = search string
    ex af, af'            ; Load index of match
    ccf                   ; If match, CF = true
    ret
searchStrNext:
    pop hl                ; Restore current string
    pop de                ; Restore search string
    ld a, (hl)            ; Load length of current string
    inc a                 ; A = length byte plus length of string
    ld c, a               ; BC = A
    ld b, 0
    add hl, bc            ; HL += BC, move to next string
    push de               ; Store search string
    push hl               ; Store current string
    ex af, af'            ; Increment index counter, ZF = false, CF = false
    inc a
    ex af, af'
    ld a, (hl)            ; A = length of next string
    or a                  ; If A != 0, continue searching
    jr nz, searchStrLoop
    dec a                 ; A = NO_MATCH (i.e., -1), ZF = false
    ccf                   ; CF = false
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

