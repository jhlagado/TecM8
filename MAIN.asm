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
; Constants
; **************************************************************************

    TRUE        EQU -1		
    FALSE       EQU 0
    CTRL_C      equ 3
    CTRL_H      equ 8

; **************************************************************************
; Page 0  Initialisation
; **************************************************************************		

	.ORG ROMSTART + $180	; 0+180 put TecM8 code from here	


EOF_        .equ 0
NEWLN_      .equ 1
COMMENT_    .equ 2
NUM_        .equ 3
LABEL_      .equ 4
IDENT_      .equ 5


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
    call nz,pushBack                ; Push back the character if it's not null
    ld a,IDENT_                     ; Return with IDENT token
    ret
nextToken7x:
    cp "."                          ; Is it a directive?
    jr nz,nextToken7                ; If not, continue to the next check
    call directive                  ; Parse the directive
    ld a,DIR_                       ; Return with DIR token
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
    ld a,SYM_                       ; Return with SYM token
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

directive:
    ld hl,0
    ret

;     jr c,ident1                     ; loop while alpha numeric
;     cp ":"
;     jr nz,ident2
;     call endStr
;     scf
;     ret
; ident2:  
;     call endStr
;     scf                             ; clear carry flag
;     ccf
;     ret


;     ld (hl),a                       ; write char
;     inc hl
;     call nextChar
; ident3:  
;     cp " "                          ; is it a control char? \0 \r \n ?
;     jr c,ident5
;     cp ","                          ; is it end of arg?
;     jr z,ident5
;     cp ";"                          ; is it a comment at end of line
;     jr z,ident5
;     cp ")"                          ; todo: check nesting
;     jr z,ident5
; ident4:
;     call endStr
;     scf                             ; clear carry flag
;     ccf
;     ret
; ident5:
;     call pushBackChar               ; push the char back to input
;     jr ident4

; endStr: completes adding a string to the strings heap area
; and stores the length at the start of the string.

; Input:
; hl: points to the end of the string.

; Output:
; hl: points to the start of the string.
; vStrPtr: is updated to pointer to memory after the string

; Destroyed: None

; endStr:
;     ld de,(vStrPtr)                 ; de = string start
;     ld (vStrPtr),hl                 ; update top of strings heap
;     or a
;     sbc hl,de                       ; hl = length, de = strPtr 
;     ex de,hl                        ; e = len, hl = strPtr
;     ld (hl),e                       ; save lsb(length)
;     ret
    



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
    jr z, getchar                   ; If the high bit is 0, jump to getchar
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
    









    


    ld bc,(vCharPtr)
    ld a,(bc)
    inc bc
    ld (vCharPtr),bc
    or a
    ret nz
    call nextLine
    jr nextChar

nextLine:
    call prompt
    ld bc,chars             ; load bc with start of chars buffer         
nextLine2:                  
    call getchar            ; get character from serial port
    cp $20			        ; compare to space
    jr c,nextLine3		    
    ld (bc),A               ; store the character in textbuf
    inc bc
    call putchar            ; echo character to screen
    jr nextLine2            ; wait for next character

nextLine3:                  ; control char
    cp '\r'                 ; carriage return? ascii 13
    jr Z,nextLine4		    ; if anything else its control char
    cp '\n'                 ; carriage return? ascii 13
    jr Z,nextLine4		    ; if anything else its control char
    cp CTRL_H               ; backSpace ?
    jr nz,nextLine2         ; no, ignore
    ld hl,chars             ; is bc already at start of chars buffer
    or a
    sbc hl,bc
    ld a,h                   
    or l
    jr z, nextLine2         ; if so, ignore backspace
    dec bc
    call printStr           ; backspace over previous letter
    .cstr "\b \b"           ; erase letter
    jr nextLine2

nextLine4:
    xor a                   ; store null in text buffer
    ld (bc),a                
    call crlf               ; echo newline to screen
    ld bc,chars             ; Instructions stored on heap at address HERE, we pressed enter
    ld (vCharPtr),bc        ; point vCharPtr to start of chars buffer
    ret

; *******************************************************************************
; *********  END OF MAIN   ******************************************************
; *******************************************************************************

; next:                           
;     inc bc                  ; Increment the IP
;     ld a,(bc)               ; Get the next character and dispatch
;     or a                    ; is it NUL?       
;     jr z,exit
;     cp "\n"                 ; is it newline?
;     jr z,interpret
;     cp "0"
;     ld d,"!"
;     jr c,op
;     cp "9"+1
;     jr c,num
;     cp "A"
;     ld d,"!"+10
;     jr c,op
;     cp "Z"+1
;     jr c,callx
;     cp "a"
;     ld d,"!"+10+26
;     jr c,op
;     cp "z"+1
;     jp c,var
;     ld d,"!"+10+26+26
; op:    
;     sub d
;     jr c,next
;     add a,lsb(opcodes)
;     ld l,A                      ; Index into table
;     ld h,msb(opcodes)           ; Start address of jump table         
;     ld l,(hl)                   ; get low jump address
;     inc h                       ; msb on next page
;     jp (hl)                     ; Jump to routine

; exit:
;     inc bc			; store offests into a table of bytes, smaller
;     ld de,bc                
;     ld ix,(vBasePtr)        ; 
;     call rpop               ; Restore old base pointer
;     ld (vBasePtr),hl
;     call rpop               ; Restore Instruction pointer
;     ld bc,hl
;     EX de,hl
;     jp (hl)

; num:
; 	ld hl,$0000				    ; Clear hl to accept the number
;     cp '-'
;     jr nz,num0
;     inc bc                      ; move to next char, no flags affected
; num0:
;     ex af,af'                   ; save zero flag = 0 for later
; num1:
;     ld a,(bc)                   ; read digit    
;     sub "0"                     ; less than 0?
;     jr c, num2                  ; not a digit, exit loop 
;     cp 10                       ; greater that 9?
;     jr nc, num2                 ; not a digit, exit loop
;     inc bc                      ; inc IP
;     ld de,hl                    ; multiply hl * 10
;     add hl,hl    
;     add hl,hl    
;     add hl,de    
;     add hl,hl    
;     add a,l                     ; add digit in a to hl
;     ld l,a
;     ld a,0
;     adc a,h
;     ld h,a
;     jr num1 
; num2:
;     dec bc
;     ex af,af'                   ; restore zero flag
;     jr nz, num3
;     ex de,hl                    ; negate the value of hl
;     ld hl,0
;     or a                        ; jump to sub2
;     sbc hl,de    
; num3:
;     push hl                     ; Put the number on the stack
;     jp (iy)                     ; and process the next character

; callx:
;     call lookupRef0
;     ld E,(hl)
;     inc hl
;     ld D,(hl)
;     ld a,D                      ; skip if destination address is null
;     or E
;     jr Z,call2
;     ld hl,bc
;     inc bc                      ; read next char from source
;     ld a,(bc)                   ; if ; to tail call optimise
;     cp ";"                      ; by jumping to rather than calling destination
;     jr Z,call1
;     call rpush                  ; save Instruction Pointer
;     ld hl,(vBasePtr)
;     call rpush
;     ld (vBasePtr),ix
; call1:
;     ld bc,de
;     dec bc
; call2:
;     jp (iy) 
    
; var:
;     ld hl,vars
;     call lookupRef
; var1:
;     ld (vPointer),hl
;     ld d,0
;     ld e,(hl)
;     ld a,(vByteMode)                   
;     inc a                       ; is it byte?
;     jr z,var2
;     inc hl
;     ld d,(hl)
; var2:
;     push de
;     jp (iy)

; lookupRef0:
;     ld hl,defs
;     sub "A"
;     jr lookupRef1        
; lookupRef:
;     sub "a"
; lookupRef1:
;     add a,a
;     add a,l
;     ld l,a
;     ld a,0
;     ADC a,h
;     ld h,a
;     XOR a
;     or e                        ; sets Z flag if A-Z
;     ret

prompt:                            
    call printStr
    .cstr "\r\n> "
    ret

crlf:                               
    call printStr
    .cstr "\r\n"
    ret

; printStr:                           
;     EX (sp),hl		                ; swap			
;     call putStr		
;     inc hl			                ; inc past null
;     EX (sp),hl		                ; put it back	
;     ret

printStr:                           
    pop hl		                    ; "return" address is address of string			
    call putStr		
    inc hl			                ; inc past null
    jp (hl)		                    ; put it back	

error:
    pop hl
    call putStr
    halt

putStr0:                            
    call putchar
    inc hl
putStr:
    ld a,(hl)
    or A
    jr nz,putStr0
    ret

rpush:                              
    dec ix                  
    ld (ix+0),H
    dec ix
    ld (ix+0),L
    ret

rpop:                               
    ld L,(ix+0)         
    inc ix              
    ld H,(ix+0)
    inc ix                  
rpop2:
    ret

; enter:                              
;     ld hl,bc
;     call rpush                      ; save Instruction Pointer
;     ld hl,(vBasePtr)
;     call rpush
;     ld (vBasePtr),ix
;     pop bc
;     dec bc
;     jp (iy)                    

; hl = value
printDec:    
    bit 7,h
    jr z,printDec2
    ld a,'-'
    call putchar
    xor a  
    sub l  
    ld l,a
    sbc a,a  
    sub h  
    ld h,a
printDec2:        
    push bc
    ld c,0                      ; leading zeros flag = false
    ld de,-10000
    call printDec4
    ld de,-1000
    call printDec4
    ld de,-100
    call printDec4
    ld e,-10
    call printDec4
    inc c                       ; flag = true for at least digit
    ld e,-1
    call printDec4
    pop bc
    ret
printDec4:
    ld b,'0'-1
printDec5:	    
    inc b
    add hl,de
    jr c,printDec5
    sbc hl,de
    ld a,'0'
    cp b
    jr nz,printDec6
    xor a
    or c
    ret z
    jr printDec7
printDec6:	    
    inc c
printDec7:	    
    ld a,b
    jp putchar

; def:                                ; Create a colon definition
;     inc bc
;     ld  a,(bc)                  ; Get the next character
;     cp ":"                      ; is it anonymouse
;     jr nz,def0
;     inc bc
;     ld de,(vHeapPtr)            ; return start of definition
;     push de
;     jr def1
; def0:    
;     call lookupRef0
;     ld de,(vHeapPtr)            ; start of defintion
;     ld (hl),E                   ; Save low byte of address in CFA
;     inc hl              
;     ld (hl),D                   ; Save high byte of address in CFA+1
;     inc bc
; def1:                               ; Skip to end of definition   
;     ld a,(bc)                   ; Get the next character
;     inc bc                      ; Point to next character
;     ld (de),A
;     inc de
;     cp ";"                      ; Is it a semicolon 
;     jr Z, def2                  ; end the definition
;     jr  def1                    ; get the next element
; def2:    
;     dec bc
; def3:
;     ld (vHeapPtr),de            ; bump heap ptr to after definiton
;     jp (iy)       

; opcodes:
;     db    lsb(bang_)        ;   !            
;     db    lsb(dquote_)      ;   "
;     db    lsb(hash_)        ;   #
;     db    lsb(dollar_)      ;   $            
;     db    lsb(percent_)     ;   %            
;     db    lsb(amper_)       ;   &
;     db    lsb(quote_)       ;   '
;     db    lsb(lparen_)      ;   (        
;     db    lsb(rparen_)      ;   )
;     db    lsb(star_)        ;   *            
;     db    lsb(plus_)        ;   +
;     db    lsb(comma_)       ;   ,            
;     db    lsb(minus_)       ;   -
;     db    lsb(dot_)         ;   .
;     db    lsb(slash_)       ;   /	

;     db    lsb(colon_)       ;    :        
;     db    lsb(semi_)        ;    ;
;     db    lsb(lt_)          ;    <
;     db    lsb(eq_)          ;    =            
;     db    lsb(gt_)          ;    >            
;     db    lsb(question_)    ;    ?   
;     db    lsb(at_)          ;    @    

;     db    lsb(lbrack_)      ;    [
;     db    lsb(bslash_)      ;    \
;     db    lsb(rbrack_)      ;    ]
;     db    lsb(caret_)       ;    ^
;     db    lsb(underscore_)  ;    _   
;     db    lsb(grave_)       ;    `           

;     db    lsb(lbrace_)      ;    {
;     db    lsb(pipe_)        ;    |            
;     db    lsb(rbrace_)      ;    }            
;     db    lsb(tilde_)       ;    ~             

; .align $100

; nop_:
; bslash_:
; quote_:                          ; Discard the top member of the stack
; at_:
; underscore_: 
; percent_:  
; amper_:        
; pipe_: 		 
; caret_:		 
; tilde_:                               
; invert:				        ; Bitwise INVert the top member of the stack
; dquote_:        
; comma_:                          ; print hexadecimal
; lbrace_:   
; rbrace_:    
; dollar_:        
; minus_:       		        ; Subtract the value 2nd on stack from top of stack 
; eq_:    
; gt_:    
; lt_:    
; grave_:                         
; rparen_: 
; lbrack_:
; rbrack_:
; lparen_: 
; slash_:   
; question_:
; hash_:
; star_:   
;     jp (iy)

; bang_:                      ; Store the value at the address placed on the top of the stack

; plus_:                           ; add the top 2 members of the stack

; dot_:       

; semi_:

; colon_:   


