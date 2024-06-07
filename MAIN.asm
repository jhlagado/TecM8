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


EOF_    .equ -1
NUL_    .equ 0
END_    .equ 2
SKIP_   .equ 3
NUM_    .equ 4
ID_     .equ 5


start:                      ; entry point of TecM8
    ld sp,STACK		        
    call init
    call printStr		
    .cstr "TecM8 0.0\r\n"
    jp parse

init:
    xor a                       ; a = NUL_ token
    ld (vToken),a
    ld hl,chars
    ld (vCharPtr),hl
    ld hl,assembly
    ld (vAsmPtr),hl
    ld hl,strings
    ld (vStrPtr),hl
    ld (vTokPtr),hl
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

nextToken:
    ld hl,0
    call nextChar
    dec a                           ; if -ve then EOF
    jr c,nextToken1x
    inc a                           ; restore a
    cp " "+1                        ; is it whitespace
    jr nc,nextToken3
nextToken1:
    or a                            ; is it null
    jr z,nextToken2
    cp " "+1
    jr nc,nextToken2
    call nextChar
    jr nextToken1
nextToken2:    
    ld a,SKIP_
    jr nextToken1x
nextToken3:
    cp "-"
    jr z,nextToken4
    cp "$"
    jr z,nextToken4
    cp "0"
    jr nc,nextToken4
    cp "9"+1
    jr c,nextToken4
    jr nextToken5
nextToken4:
    call number
    ld a,NUM_
    jr nextToken1x
nextToken5:
    cp "_"
    jr z,nextToken6
    call isAlpha
    jr nz,nextToken7
nextToken6:
    call ident
    ld a,ID_
    jr nextToken1x
nextToken7:
    ld a,NUL_
    ld hl,0
nextToken1x:
    ld (vToken),a
    ld (vTokPtr),hl
    ret

number:
    ld hl,0
    ret

; adds ident to string heap
; returns hl = ptr to ident
; destroys a,b,c,d,e,h,l
; updates vStrPtr
ident:
    ld hl,(vStrPtr)
    inc hl                          ; skip length byte
ident1:
    ld (hl),a                       ; write char
    inc hl
    call nextChar
    cp "_"
    jr z,ident1
    call isAlphanum
    jr z,ident1
ident2:  
    ld de,(vStrPtr)                 ; de = string start
    ld (vStrPtr),hl                 ; save string end
    or a
    sbc hl,de                       ; hl = len, de = strPtr 
    ex de,hl                        ; e = len, hl = strPtr
    ld (hl),e                       ; save len byte
    ret

; destroys b,c
; uppercases a
isAlphanum:
    call isDigit
    ret z                           ; fall thru to isAlpha                          

; destroys b,c
; uppercases a
isAlpha:
    ld c,"Z"+1                      ; last letter
isAlpha0:
    ld b,0                          ; reset zero flag
    cp "a"
    jr c,isAlpha1
    sub "a" + "A"
isAlpha1:
    cp "A"
    jr c,isAlpha2
    cp c
    jr nc,isAlpha2
    ld b,1                          ; set zero flag
isAlpha2:
    dec b                           ; determine zero flag
    ret

; destroys b,c
; uppercases a
isHexDigit:
    ld c,"F"+1
    call isAlpha0
    ret z                           ; fall thru to isDigit 

; returns z=flag
; destroys b
isDigit:
    ld b,0                          ; set zero flag
    cp "0"
    jr c,isDigit1
    cp "9"+1
    jr nc,isDigit1
    ld b,1                          ; reset zero flag
isDigit1:
    dec b                           ; determine zero flag
    ret

nextChar:
    jp getchar

; Parses a hexadecimal number

; Input Registers:

; BC: This register pair is used as a pointer to the hexadecimal string in memory.
; Output Registers:

; HL: This register pair is used to store the result of the conversion from hexadecimal to decimal.

; Modified/Destroyed Registers:

; A: This register is used to hold the current character being processed. It's modified throughout the routine.
; BC: This register pair is incremented to point to the next character in the string.

; Preserved Registers:

; DE, IX, IY, SP, AF' (the alternate register set): These registers are not used in the routine, so they are preserved.


hex:
    ld hl,0                     ; Initialize HL to 0 to hold the result
hex1:
    inc bc                      ; Increment BC to point to the next character
    ld a,(bc)                   ; Load the next character into A
    cp "0"                      ; Compare with ASCII '0'
    ret c                       ; If less, exit
    cp "9"+1                      ; Compare with ASCII '9'
    jr c, digit                 ; If less or equal, jump to digit
    cp "A"                      ; Compare with ASCII 'A'
    jr c, invalid               ; If less, jump to invalid
    cp "F"+1                      ; Compare with ASCII 'F'
    jr c, upper                 ; If less or equal, jump to upper
    cp "a"                      ; Compare with ASCII 'a'
    ret c                       ; If less, exit
    cp "f"+1                    ; Compare with ASCII 'f'
    ret nc                      ; If more, exit
    sub $57                     ; Convert from ASCII to hex
    jr valid
digit:
    sub $30                     ; Convert from ASCII to decimal
    jr valid
upper:
    sub $37                     ; Convert from ASCII to hex
valid:
    sub $30                     ; Subtract $30 to convert the ASCII code of a digit to a decimal number
    ret c                       ; If the result is negative, the character was not a valid hexadecimal digit, so return
    cp $10                      ; Compare the result with $10
    ret nc                      ; If the result is $10 or more, the character was not a valid hexadecimal digit, so return
    add hl,hl                   ; Multiply the number in HL by 16 by shifting it left 4 times
    add hl,hl                   ; This is done because each hexadecimal digit represents 16^n where n is the position of the digit from the right
    add hl,hl
    add hl,hl
    add a,l                     ; Add the new digit to the number in HL
    ld  l,a                     ; Store the result back in L
    jp  hex1                    ; Jump back to hex1 to process the next character

; Parses a decimal number

; Input registers:

; BC: Points to the next digit to be read from memory.
; Output registers:

; HL: Holds the binary value of the decimal number.

; Destroyed registers:

; A: Used for temporary storage and calculations.
; DE: Used for temporary storage and calculations.

; Preserved registers:

; BC: Incremented to point to the next digit, but otherwise preserved.

decimal1:
    ld hl,0                     ; Initialize HL to 0 to hold the result
decimal1:
    ld a,(bc)                   ; Load the next digit from memory into A
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


num:
	ld hl,$0000				    ; Clear hl to accept the number
	ld a,(bc)				    ; Get numeral or -
    cp '-'
    jr nz,num0
    inc bc                      ; move to next char, no flags affected
num0:
    ex af,af'                   ; save zero flag = 0 for later
    call decimal

num2:
    dec bc
    ex af,af'                   ; restore zero flag
    jr nz, num3
    ex de,hl                    ; negate the value of hl
    ld hl,0
    or a                        ; jump to sub2
    sbc hl,de    
num3:
    push hl                     ; Put the number on the stack
    jp (iy)                     ; and process the next character



; inputs: DE, A
; outputs: HL = DE * A
; destroys b

DE_Times_A:
    ld B,8                          ; Initialize loop counter to 8 (for 8 bits in A)
    ld HL,0                         ; Initialize result to 0
MultiplyLoop:
    add HL,HL                       ; Double HL
    rlca                            ; Rotate A left through carry
    jr NC,SkipAdd                   ; If no carry, skip the addition
    add HL,DE                       ; Add DE to HL
SkipAdd:
    djnz MultiplyLoop               ; Decrement B and loop if not zero
    ret                             ; Return from subroutine








    


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


