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
;    Entry point of TecM8. Initializes the STACK pointer, calls the initialization
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
    ld sp, STACK        ; Initialize STACK pointer
    call init           ; Call initialization routine
    call print         ; Print TecM8 version information
    .cstr "TecM8 0.0\r\n"
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
    ld hl, 0            ; 
    ld (vTokenVal), hl  ; vTokenVal = 0
    ld (vSymPtr), hl    ; vSymPtr = 0
    ld (vExprPtr), hl   ; vExprPtr = 0
    xor a               ; 
    ld (vToken), a      ; vToken = 0
    ld (vBufferPos), a  ; vBufferPos = 0
    ld a, "\n"          ; put new line into first char of buffer
    ld (BUFFER),a       ; 
    ld hl, HEAP         ; vHeapPtr = HEAP
    ld (vHeapPtr), hl   ; 
    ld hl, ASSEMBLY     ; vAsmPtr = ASSEMBLY
    ld (vAsmPtr), hl    ; 
    ret                 

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
    .cstr "Parsing completed successfully."
    halt                       

parseError:
    .cstr "Unexpected token."
    halt                       

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
    call nextToken              ; Get the next token
    call statement              ; Parse a statement
    cp EOF_                     ; Check if it's the end of file
    ret z                       ; If yes, return
    cp NEWLN_
    jr nz, parseError
    jr statementList            ; Repeat for the next statement

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
    push af                     ; save token
    ld a, -1
    ld (vOpcode), a
    ld (vOperand1), a
    ld (vOperand2), a
    xor a
    ld (vOpExpr), a
    ld (vOpDisp), a
    pop af                      ; restore token

    cp EOF_
    ret z
    cp NEWLN_
    ret z
    cp LABEL_                   ; Check if it's a label
    jr nz, statement1           ; If not, jump to statement10
    ld de, (vAsmPtr)            ; HL = symbol name DE = symbol value (assembler pointer)
    call addSymbol              ; Add label to symbol list
    call nextToken              ; Get the next token

statement1:
    cp OPCODE_                  ; Check if it's an opcode
    jr z, instruction           ; Jump to parseInstruction routine
    cp DIRECT_                  ; Check if it's a directive
    jr z, directive
    ret

instruction:
    ld a, l
    ld (vOpcode), a
    call nextToken
    call operand
    ld (vOperand1), a
    call nextToken
    cp COMMA_
    ret nz
    call nextToken
    call operand
    ld (vOperand2), a
    ret

directive:    
    ret

; *****************************************************************************
; Routine: operand
; 
; Purpose:
;    Parses and identifies different types of operands (registers, memory,
;    immediate values, etc.) used in assembly instructions. Sets the appropriate
;    flags based on the operand type.
; 
; Inputs:
;    None (uses the current token from a token stream)
; 
; Outputs:
;    A - Contains the code indicating the type of operand identified.
; 
; Registers Destroyed:
;    A, DE, HL
; Define operand codes for readability and use in the operand routine.
;
; reg_    .equ    0x00        ; A, B etc
; rp_     .equ    0x08        ; bit 3: register pair e.g. HL, DE
; flag_   .equ    0x10        ; bit 4: flag NZ etc
; immed_  .equ    0x20        ; bit 5: immediate 0xff or 0xffff
; mem_    .equ    0x40        ; bit 6: memory ref (HL) or (0xffff)
; idx_    .equ    0x80        ; bit 7: indexed (IX+dd)
; *****************************************************************************

operand:
    cp OPELEM_              ; Check if the token is an op element i.e. reg, rp or flag
    ret z                   ; Return if it is

    cp LPAREN_              ; Check if the token is a left parenthesis
    jr z, operand1          ; If so, handle as a memory reference

    call expression         ; Otherwise, treat as an expression
    ld (vOpExpr), hl        ; Store the result of the operand expression
    ld a, immed_            ; Set A to indicate an immediate value
    ret

operand1:
    call nextToken          ; Memory reference. Get the next token
    cp OPELEM_              ; Check if the next token is an op element
    jr nz, operand2         ; If not, handle as an expression inside parentheses

    ld a, l                 ; Otherwise, Load A with the lower byte of HL (operand)
    call isIndexReg
    jr nz, operand4
    push af                 ; Save HL on the stack
    call expression         ; Treat as an expression
    ld (vOpDisp), hl        ; Store the result of the expression
    pop af                  ; Restore HL from the stack
    set 7, a                ; Set A to indicate an indexed memory reference

operand3:
    set 6, a                ; Otherwise, set A to indicate a memory reference
    jr operand4

operand2:
    call expression         ; Treat as a new expression
    ld (vOpExpr), hl        ; Store the result of the expression
    ld a, immed_ | mem_     ; Set A to indicate an immediate memory reference
    jr operand4

operand4:
    call nextToken          ; Get the next token
    cp RPAREN_              ; Check if the next token is a right parenthesis
    jp nz, parseError       ; If not, handle as a parse error
    ret

; *****************************************************************************
; Routine: expression
; 
; Purpose:
;    Parses an expression as an array of tokens and stores it in an array. 
;    Each token in the expression is appended to an array which is terminated by 
;    a NULL token type. 
;    The expression list pointer is updated to point to the start of the last token list.
; 
; Inputs:
;    A - token type
;    HL - token value
; 
; Outputs:
;    Updates the heap with the parsed expression and updates the expression list pointer.
; 
; Registers Destroyed:
;    AF, B, HL
; *****************************************************************************

expression:
    ld b, 0                 ; Initialize nesting level
    push hl                 ; Save token value
    ld de, (vHeapPtr)       ; Load the current heap pointer into DE
    ld hl, (vExprPtr)       ; Load the current expression list pointer into HL
    call hpush              ; Push the pointer to the last symbol onto the heap
    ld hl, 0                ; Append two words in header (for future use)
    call hpush
    call hpush
    ld (vExprPtr), de       ; Update the expression list pointer with the new address
    pop hl                  ; HL = token value

expression1:
    ex de, hl               ; DE = token value
    ld l, a                 ; HL = token type
    ld h, 0                 
    call hpush              ; Push the token type
    ex de, hl               ; HL = token value
    call hpush              ; Push the token value
    call nextToken          ; Get the next token
    cp "("                  ; increase nesting?
    jr nz, expression2
    inc b                   
    call nextToken          ; Get the next token
    jr expression1          ; Repeat the main loop

expression2:
    inc b                   ; Check if nesting level is zero
    dec b
    jr z, expression3       ; If yes, skip to expression3
    cp ")"                  ; if nesting > 0, decrease nesting?
    jr nz, expression3
    dec b                   ; Decrease nesting level
    call nextToken          ; Get the next token
    jr expression1          ; Repeat the main loop

expression3:
    cp RPAREN_              ; Check if the end of the expression
    jr z, expression4
    cp COMMA_                  
    jr z, expression4
    cp NEWLN_                 
    jr z, expression4
    cp EOF_                 
    jr nz, expression1

expression4:
    ld hl, NULL             ; Mark the end of the expression with NULL
    call hpush              ; Push NULL onto the heap
    jp pushBackToken        ; Rewind the token to the last valid one

; *****************************************************************************
; Routine: addSymbol
; 
; Purpose:
;    Adds a new symbol to the symbol list. The symbol's name is in HL and the 
;    symbol's value is in DE. Updates the symbol list pointer and ensures 
;    the previous symbol's pointer is preserved.
; 
; Inputs:
;    HL - Points to the name of the new symbol.
;    DE - Contains the value of the new symbol.
; 
; Outputs:
;    Updates the symbol list pointer in vSymPtr.
; 
; Registers Destroyed:
;    DE, HL
; *****************************************************************************
addSymbol:
    push de
    push hl                 ; Push symbol name onto the stack
    ld de, (vHeapPtr)       ; BC = symbol address from the heap pointer
    ld hl, (vSymPtr)        ; Load the current symbol list pointer into HL
    call hpush              ; Push pointer to the last symbol onto the heap
    ld (vSymPtr), de        ; Update the symbol list pointer with the new symbol address
    pop hl                  ; HL = symbol name
    call hpush              ; Push symbol name onto the heap
    pop hl                  ; HL = symbol value
    call hpush              ; Push symbol value onto the heap
    ret                     ; Return from subroutine

; nextToken is a lexer function that reads characters from the input and classifies 
; them into different token types. It handles whitespace, end of input, newlines, 
; comments, identifiers, labels, directives, hexadecimal numbers, and other SYMBOLS.

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
    bit 7, (vToken)             ; Check the high bit of the pushback BUFFER
    jp z, nextToken0            ; If high bit clear, nothing pushed back 
    ld a, (vToken)              ; If high bit set, load the pushed back token type into A
    ld hl, (vTokenVal)          ; and token value into HL
    res 7, a                    ; Clear the high bit
    ld (vToken), a              ; Store the character back in the BUFFER
    ret                         ; Return with the pushed back character in A

nextToken0:
    ld hl, 0                    ; Initialize HL with 0

nextToken1:
    call nextChar               ; Get the next character
    cp " "                      ; is it space? 
    jr z, nextToken1            ; If yes, skip it and get the next character
    cp EOF                      ; Is it null (end of input)?
    jr nz, nextToken2           ; If not, continue to the next check
    ld a, EOF_                  ; If yes, return with EOF token
    ret

nextToken2:
    cp $5C                      ; Is it a statement separator? "\"
    jr nz, nextToken3           ; If not, continue to the next check
    cp ":"                      ; Is it a statement separator? ":"
    jr nz, nextToken3           ; If not, continue to the next check
    cp "\n"                     ; Is it a new line
    jr nc, nextToken3           ; If not, continue to the next check
    ld a, NEWLN_                ; If yes, return with NEWLIN token
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
    call isAlpha                ; If not, check if it's alphabetic
    jr nc, nextToken11          ; If not, continue to the next check

nextToken6:
    call ident                  ; Parse the identifier
    cp ":"                      ; Is it a label?
    jr nz, nextToken7           ; If not, continue to the next check
    ld a, LABEL_                ; If yes, return A = LABEL HL = string
    ret

nextToken7:    
    call rewindChar             ; Push back the character
    ld (vHeapPtr), hl           ; Restore string heap pointer to previous location
    call searchOpcode
    jr nz, nextToken8
    ld l, a                     ; hl = opcode value
    ld h, 0
    ld a, OPCODE_               ; Return with OPCODE token
    ret

nextToken8:
    call searchOpElem
    jr nz, nextToken9
    ld l, a                     ; hl = op element value
    ld h, 0
    ld a, OPELEM_              ; Return with OPELEM token
    ret

nextToken9:
    ld de, directives           ; List of directives to search
    call searchStr
    jr nz, nextToken10
    ld l, a                     ; hl = directive value
    ld h, 0
    ld a, DIRECT_               ; Return with DIRECT token
    ret

nextToken10:
    ld a, IDENT_                ; Return with IDENT token
    ret

nextToken11:
    ld hl, 0
    cp "$"                      ; Is it a hexadecimal number?
    jr nz, nextToken12          ; If not, continue to the next check
    call nextChar               ; Get the next character
    call isAlphaNum             ; Check if it's the ASSEMBLY pointer
    jr nz, nextToken11a         ; If not, continue to the next check
    call number_hex             ; Process hexadecimal number
    ld a, NUM_                  ; Return with NUM token
    ret

nextToken11a:
    call rewindChar             ; Push back the character (flags unaffected)
    ld a, DOLLAR_               ; Return with DOLLAR token
    ret                         ; Return with the DOLLAR token

nextToken12:    
    cp "-"                      ; Is it a negative number?
    jr z, nextToken13           ; If yes, continue to the next check
    call isDigit                ; Check if it's a digit
    jr nc, nextToken15          ; Jump to the next check

nextToken13:
    call number                 ; Parse the number

nextToken14:
    ld a, NUM_                  ; Return with NUM token
    ret

nextToken15:
    cp "("
    ret z                       ; Return with the LPAREN token
    cp ")"
    ret z                       ; Return with the RPAREN token
    cp ","
    ret z                       ; Return with the COMMA token
    ld a, UNKNOWN_              ; Return with UNKNOWN token
    ret

; *****************************************************************************
; Routine: pushBackToken
; 
; Purpose:
;    Pushes back a token into the pushback BUFFER to allow the token to be
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
;    to a Pascal string and updates the top of the STRINGS heap pointer.
;    It also calculates the length of the string and stores it at the beginning
;    of the string.
; 
; Inputs:
;    A - Current character read from the input stream
;    vHeapPtr - Address of the top of heap pointer
; 
; Outputs:
;    A - last character read from the input stream
;    HL - identifier string
; 
; Registers Destroyed:
;    DE, HL
; *****************************************************************************

ident:
    ld hl, (vHeapPtr)       ; Load the address of the top of STRINGS heap
    push hl                 ; save start of string
    inc hl                  ; Move to the next byte to skip the length byte
ident1:
    ld (hl), a              ; Write the current character to the string BUFFER
    inc hl                  ; Move to the next position in the BUFFER
    push hl
    call nextChar           ; Get the next character from the input stream
    pop hl
    cp "_"                  ; Compare with underscore character
    jr z, ident1            ; If underscore, jump to ident2
    call isAlphanum         ; Check if the character is alphanumeric
    jr c, ident1            ; If not alphanumeric, jump to ident3
ident3:
    ld (vHeapPtr), hl       ; Update the top of STRINGS heap pointer
    pop de                  ; restore start of string into de 
    or a                    ; Clear carry
    sbc hl, de              ; Calculate the length of the string (HL = length, DE = string)
    dec l                   ; reduce by one (length byte)
    ex de, hl               ; Swap DE and HL (E = length, HL = string)
    ld (hl), e              ; Store the length at the beginning of the string BUFFER
    ret                     

; *****************************************************************************
; Routine: searchStr
; 
; Purpose:
;    Search through a list of Pascal STRINGS for a match.
; 
; Inputs:
;    HL - Points to the string to search for.
;    DE - Points to the start of the list of STRINGS.
; 
; Outputs:
;    ZF - True if match, false otherwise.
;    A - Index of the matching string if a match is found, or -1 if no match 
;        is found.
;    HL - Points to the string to search for.
; 
; Destroyed:
;    A, B, C, D, E, A', F'
; *****************************************************************************

searchStr:
    ld b, 0               ; init b with index 0 

searchStr1:
    call compareStr       ; compare strings    
    jr nz, searchStr3
    ld a, b               ; Load index of match
    ret                   ; ZF = true

searchStr3:
    ld a, (de)            ; Load length of current string
    inc a                 ; A = length byte plus length of string
    
    add a, e              ; HL += A, move HL to point to next string     
    ld e, a
    ld a, 0
    adc a, d
    ld d, a
    
    inc b                 ; increase index
    ld a, (de)            ; A = length of next string
    or a                  ; If A != 0, continue searching
    jr nz, searchStr1
    dec a                 ; A = NO_MATCH (i.e., -1), ZF = false
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
;    ZF - Set if a match is found, cleared otherwise.
;    A  - Contains the index of the matching opcode if a match is found,
;         or the last checked index if no match is found.
; 
; Registers Destroyed:
;    A, DE, F
; *****************************************************************************

searchOpcode:
    ld de, alu_opcodes          ; Point DE to the list of ALU opcodes
    call searchStr              ; Search for the string in ALU opcodes
    ret z                       ; If match found (ZF set), return

    ld de, rot_opcodes          ; Point DE to the list of ROT opcodes
    call searchStr              ; Search for the string in ROT opcodes
    set 5, a                    ; Set bit 5 in A to indicate ROT opcodes
    ret z                       ; If match found (ZF set), return

    ld de, bli_opcodes          ; Point DE to the list of BLI opcodes
    call searchStr              ; Search for the string in BLI opcodes
    set 6, a                    ; Set bit 6 in A to indicate BLI opcodes
    ret z                       ; If match found (ZF set), return

    ld de, gen1_opcodes         ; Point DE to the list of general opcodes (set 1)
    call searchStr              ; Search for the string in general opcodes
    set 5, a                    ; Set bits 5 & 6 in A to indicate general opcodes (set 1)
    set 6, a                    
    ret z                       ; If match found (ZF set), return

    ld de, gen2_opcodes         ; Point DE to the list of general opcodes (set 2)
    call searchStr              ; Search for the string in general opcodes
    set 7, a                    ; Set bit 7 in A to indicate general opcodes (set 2)

    ret                         ; Return ZF = match

; *****************************************************************************
; Routine: searchOpElem
;
; Purpose:
;    Searches for an op element in the lists of 8-bit registers, 16-bit registers,
;    and flags. Sets appropriate flags based on the type of operand found.
;
; Inputs:
;    HL - Points to the start of the string to search for.
;
; Outputs:
;    A  - The index of the matching op element if a match is found, or -1 if no
;         match is found.
;    ZF - Set if a match is found, cleared otherwise.
;
; Registers Destroyed:
;    A, DE, HL
; *****************************************************************************

; reg_    .equ    0x00    ; A, B etc
; rp_     .equ    0x08    ; bit 3: 8-bit or 16-bit e.g. A or HL, 0xff or 0xffff
; flag_   .equ    0x10    ; bit 4: NZ etc

searchOpElem:
    ld de, reg8                 ; Point DE to the list of 8-bit register operands
    call searchStr              ; Search for the string in reg8 operands
    ret z                       ; If match found (ZF set), return

    ld de, reg16                ; Point DE to the list of 16-bit register operands
    call searchStr              ; Search for the string in reg16 operands
    set 3, a                    ; Set bit 4 in A to indicate a register operand
    ret z                       ; If match found (ZF set), return

    ld de, flags                ; Point DE to the list of flag operands
    call searchStr              ; Search for the string in flag operands
    set 4, a                    ; Set bit 3 in A to indicate flag operand

    ret                         ; Return ZF = match

; *****************************************************************************
; Routine: compareStr
; 
; Purpose:
;    Compares two Pascal strings. The comparison includes
;    the length byte and continues until all characters are compared or a
;    mismatch is found.
; 
; Inputs:
;    DE - Points to the start of string1
;    HL - Points to the start of string2
; 
; Outputs:
;    ZF - Set if the strings are equal
; 
; Registers Destroyed:
;    A
; *****************************************************************************

compareStr:
    push bc                     ; save BC, DE, HL    
    push de
    push hl
    ld a, (de)                  ; Load length of search string
    ld b, a                     ; Copy length to B for looping
    inc b                       ; Increase to include length byte     

compareStr2:
    ld a, (de)                  ; Load next character from search string
    cp (hl)                     ; Compare with next character in current string
    jr nz, compareStr3          ; break if characters are not equal
    inc de                      ; Move to next character in search string
    inc hl                      ; Move to next character in current string
    djnz compareStr2            ; Loop until all characters compared or mismatch

compareStr3:
    pop hl                      ; restore BC, DE, HL
    pop de
    pop bc
    ret                         ; Return with ZF set if strings are equal

; *****************************************************************************
; Routine: isIndexReg
; 
; Purpose:
;    Checks if the current operand is an index register (IX or IY).
; 
; Inputs:
;    A - The operand to check.
; 
; Outputs:
;    ZF - Set if the operand is an index register (IX or IY).
; 
; Registers Destroyed:
;    None
; *****************************************************************************

isIndexReg:
    cp IX_                       ; Compare operand with IX
    ret z                        ; Return if equal (ZF is set)
    cp IY_                       ; Compare operand with IY
    ret                          ; Return (ZF is set if equal, cleared otherwise)

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
    cp "z"+1          ; Compare with 'Z' + 1
    ret nc            ; Return if it's not alphabetic, no carry 
    cp "a"            ; Compare with lowercase 'a'
    jr c, isAlpha1    ; Jump if it's lower than 'a'
    sub $20           ; It's lowercase alpha so convert lowercase to uppercase
    scf               ; no carry so set carry flag    
    ret
isAlpha1:
    cp "Z"+1          ; Compare with 'Z' + 1
    ret nc            ; Return if it's not alphabetic, no carry
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
;    A - first char of number
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
    call rewindChar     
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
; Routine: nextChar
; 
; Purpose:
;    Fetches the next character from the BUFFER. If the BUFFER is empty or 
;    contains a null character (0), it refills the BUFFER by calling nextLine.
; 
; Inputs:
;    None
; 
; Outputs:
;    A - The next character from the BUFFER
; 
; Registers Destroyed:
;    A, D, E, HL
; *****************************************************************************

nextChar:
    ld hl, vBufferPos           ; Load the offset of BUFFER position variable
    ld a, (hl)                  ; Load the current position offset in the BUFFER into A
    cp BUFFER_SIZE              ; Compare with BUFFER size
    jp z, nextLine              ; Jump to nextLine if end of BUFFER
    ld de, BUFFER               ; Load the MSB of the BUFFER's address into D
    add a,e                     ; de += a
    ld e,a
    ld a,0
    adc a,d
    ld d,a
    ld a, (de)                  ; Load the character at the current BUFFER position into A
    inc (hl)                    ; Increment the BUFFER position offset
    cp "\n"                     ; if a != null return else load a new line into buffer 
    ret nz                      

nextLine:
    ld hl, BUFFER               ; Start of the BUFFER
    ld b, BUFFER_SIZE           ; Number of bytes to fill

nextLine1:
    call getchar                ; Get a character from getchar
    cp EOF                      ; is it EOF
    jr z, nextLine6
    or a                        ; is it NULL?
    jr z, nextLine2
    cp CTRL_C                   ; is it ctrl-C ?
    jr nz, nextLine3

nextLine2:
    ld a, EOF
    jr nextLine6

nextLine3:
    cp "\b"                     ; Check if character is backspace
    jr nz, nextLine4            ; If not, proceed to store the character
    ld a, BUFFER_SIZE
    sub b                       ; Check if at the start of the buffer
    jr z, nextLine1             ; If at the start, ignore backspace
    dec hl                      ; Move back in the buffer
    inc b                       ; Adjust buffer size counter

    call print                 ; Erase the character at the current cursor position
    .cstr ESC,"[P"              ; Escape sequence for erasing character
    jr nextLine1

nextLine4:    
    call putchar                ; Echo character to terminal

    cp "\t"
    jr nz, nextLine5             ; if a == CR or NL replace with null
    ld a, " "
    jr nextLine6

nextLine5:
    cp "\r"                     ; Check if character is carriage return
    jr nz, nextLine6
    ld a, "\n"
    jr nextLine6

nextLine6:
    ld (hl), a                  ; Store the character in the BUFFER
    inc hl                      ; Move to the next position in the BUFFER
    cp EOF                      ; Break loop if character is end of line
    jr z, nextLine7             
    cp "\n"                     ; Break loop if character is end of line
    jr z, nextLine7                           
    djnz nextLine1              ; Repeat until BUFFER is full

nextLine7:
    ld hl, vBufferPos
    ld (hl), 0
    jr nextChar                  

; *****************************************************************************
; Routine: rewindChar
; 
; Purpose:
;    Rewinds the BUFFER position by one character, effectively pushing back the
;    BUFFER position by one character in the input stream.
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
    ld a, (vBufferPos)          ; Load the current position in the BUFFER into A
    or a                        ; Check if the BUFFER position is zero
    ret z                       ; If zero, nothing to push back, return
    dec a                       ; Decrement the BUFFER position
    ld (vBufferPos), a
    ret                         

; *****************************************************************************
; Routine: prompt
; 
; Purpose:
;    Prints a prompt symbol ("> ") to indicate readiness for user input.
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

prompt:                            
    call print                  ; Print the null-terminated string (prompt message)
    .cstr "\r\n> "              ; Define the prompt message
    ret                         ; Return to the caller

; *****************************************************************************
; Routine: crlf
; 
; Purpose:
;    Prints a carriage return and line feed (new line) to the output.
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

crlf:                               
    call print                  ; Print the null-terminated string (carriage return and line feed)
    .cstr "\r\n"                 ; Define the carriage return and line feed message
    ret                          ; Return to the caller

; *****************************************************************************
; Routine: error
; 
; Purpose:
;    Prints an error message and halts execution.
; 
; Inputs:
;    (Stack) - The address of the error message to be printed
; 
; Outputs:
;    None
; 
; Registers Destroyed:
;    A, HL
; *****************************************************************************

error:
    pop hl                      ; Retrieve the "return" address which is the address of the error message
    call printStr              ; Call the routine to print the null-terminated string
    halt                        ; Halt the CPU

; *****************************************************************************
; Routine: print
; 
; Purpose:
;    Prints a null-terminated string starting from the address in HL.
; 
; Inputs:
;    HL - Points to the start of the string to be printed
; 
; Outputs:
;    None
; 
; Registers Destroyed:
;    None
; *****************************************************************************

print:                           
    ex (sp),hl                ; Swap HL with the value on the stack to preserve HL
    call printZStr            ; Call the routine to print the null-terminated string
    inc hl                    ; Increment HL to skip the null terminator
    ex (sp),hl                ; Restore the original value of HL from the stack
    ret                       ; Return to the caller

; *****************************************************************************
; Routine: printStr
; 
; Purpose:
;    Prints a Pascal string stored in memory. 
; 
; Inputs:
;    HL - Points to the start of the string (first byte is the length)
; 
; Outputs:
;    None
; 
; Registers Destroyed:
;    A, B, HL
; *****************************************************************************

printStr:
    ld a, (hl)                ; Load the length of the string
    or a                      ; Check if the length is zero
    ret z                     ; If zero, return immediately
    inc hl                    ; Move HL to the start of the string data
    ld b, a                   ; Copy the length to B for looping
printStr1:
    ld a, (hl)                ; Load the next character
    call putchar              ; Call a routine that prints a single character
    inc hl                    ; Move to the next character
    djnz printStr1            ; Decrement B and jump if not zero
    ret                       ; Return from the routine

; *****************************************************************************
; Routine: printZStr
; 
; Purpose:
;    Prints a null-terminated string stored in memory. 
; 
; Inputs:
;    HL - Points to the start of the string to be printed
; 
; Outputs:
;    None
; 
; Registers Destroyed:
;    A, HL
; *****************************************************************************

printZStr:
    jr printZStr2             ; Jump to the loop condition

printZStr1:                            
    call putchar              ; Print the current character
    inc hl                    ; Move to the next character

printZStr2:
    ld a, (hl)                ; Load the current character
    or a                      ; Check if the character is null
    jr nz, printZStr1         ; If not null, continue printing
    ret                       ; Return when null character is encountered

; *****************************************************************************
; Routine: hpush
; 
; Purpose:
;    Pushes a 16-bit value onto the heap. The value to be pushed is in DE,
;    and the heap pointer is updated accordingly.
; 
; Inputs:
;    DE - The 16-bit value to be pushed onto the heap.
; 
; Outputs:
;    Updates the heap pointer in vHeapPtr.
; 
; Registers Destroyed:
;    DE, HL
; *****************************************************************************
hpush:
    push de                 ; Save DE
    ex de, hl               ; Exchange DE and HL to move value to DE
    ld hl, (vHeapPtr)       ; Load the current top of the heap into HL
    ld (hl), d              ; Store the high byte of DE (now in HL) on the heap
    inc hl                  ; Increment HL to point to the next heap position
    ld (hl), e              ; Store the low byte of DE (now in HL) on the heap
    inc hl                  ; Increment HL to point to the new top of the heap
    ld (vHeapPtr), hl       ; Update the heap pointer with the new top of the heap
    pop de                  ; Restore DE
    ret                     ; Return from the subroutine

; ; *****************************************************************************
; ; Routine: hpop
; ; 
; ; Purpose:
; ;    Pops a 16-bit value from the heap into HL. The heap pointer is updated 
; ;    accordingly.
; ; 
; ; Inputs:
; ;    None
; ; 
; ; Outputs:
; ;    HL - Contains the 16-bit value popped from the heap.
; ;    Updates the heap pointer in vHeapPtr.
; ; 
; ; Registers Destroyed:
; ;    DE, HL
; ; *****************************************************************************
; hpop:
;     push de                 ; Save DE
;     ld hl, (vHeapPtr)       ; Load the current top of the heap into HL
;     dec hl                  ; Decrement HL to point to the high byte of the value
;     ld l, (hl)              ; Load the low byte of the value into L
;     dec hl                  ; Decrement HL to point to the low byte of the value
;     ld h, (hl)              ; Load the high byte of the value into H
;     ld (vHeapPtr), hl       ; Update the heap pointer with the new top of the heap
;     ex de, hl               ; Exchange DE and HL to move the value to HL
;     pop de                  ; Restore DE
;     ret                     ; Return from the subroutine

; *******************************************************************************
; *********  END OF MAIN   ******************************************************
; *******************************************************************************

