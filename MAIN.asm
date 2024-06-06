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

opcodes:
    db    lsb(bang_)        ;   !            
    db    lsb(dquote_)      ;   "
    db    lsb(hash_)        ;   #
    db    lsb(dollar_)      ;   $            
    db    lsb(percent_)     ;   %            
    db    lsb(amper_)       ;   &
    db    lsb(quote_)       ;   '
    db    lsb(lparen_)      ;   (        
    db    lsb(rparen_)      ;   )
    db    lsb(star_)        ;   *            
    db    lsb(plus_)        ;   +
    db    lsb(comma_)       ;   ,            
    db    lsb(minus_)       ;   -
    db    lsb(dot_)         ;   .
    db    lsb(slash_)       ;   /	

    db    lsb(colon_)       ;    :        
    db    lsb(semi_)        ;    ;
    db    lsb(lt_)          ;    <
    db    lsb(eq_)          ;    =            
    db    lsb(gt_)          ;    >            
    db    lsb(question_)    ;    ?   
    db    lsb(at_)          ;    @    

    db    lsb(lbrack_)      ;    [
    db    lsb(bslash_)      ;    \
    db    lsb(rbrack_)      ;    ]
    db    lsb(caret_)       ;    ^
    db    lsb(underscore_)  ;    _   
    db    lsb(grave_)       ;    `           

    db    lsb(lbrace_)      ;    {
    db    lsb(pipe_)        ;    |            
    db    lsb(rbrace_)      ;    }            
    db    lsb(tilde_)       ;    ~             

.align $100

nop_:
bslash_:
quote_:                          ; Discard the top member of the stack
at_:
underscore_: 
percent_:  
amper_:        
pipe_: 		 
caret_:		 
tilde_:                               
invert:				        ; Bitwise INVert the top member of the stack
dquote_:        
comma_:                          ; print hexadecimal
lbrace_:   
rbrace_:    
dollar_:        
minus_:       		        ; Subtract the value 2nd on stack from top of stack 
eq_:    
gt_:    
lt_:    
grave_:                         
rparen_: 
lbrack_:
rbrack_:
lparen_: 
slash_:   
question_:
hash_:
star_:   
    jp (iy)

bang_:                      ; Store the value at the address placed on the top of the stack

plus_:                           ; add the top 2 members of the stack

dot_:       

semi_:

colon_:   

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

program:
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
    cp "A"
    jr nc,nextToken6
    cp "Z"+1
    jr c,nextToken6
    cp "a"
    jr nc,nextToken6
    cp "z"+1
    jr c,nextToken6
    jr nextToken7
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

nextChar:
    ld bc,(vCharPtr)
    ld a,(bc)
    inc bc
    ld (vCharPtr),bc
    ret

number:
    ld hl,0
    ret

ident:
    ld hl,0
    ret








; interpret:
;     call prompt
;     ld bc,TIB               ; load bc with offset into TIB, decide char into tib or execute or control         
; interpret2:                 ; calc nesting 
;     call getchar            ; loop around waiting for character from serial port
;     cp $20			        ; compare to space
;     jr C,interpret3		    ; if >= space, if below 20 set carry flag
;     ld (bc),A               ; store the character in textbuf
;     inc bc
;     call putchar            ; echo character to screen
;     jr interpret2            ; wait for next character

; interpret3:
;     cp '\r'                 ; carriage return? ascii 13
;     jr Z,interpret4		    ; if anything else its control char
;     cp '\n'                 ; carriage return? ascii 13
;     jr Z,interpret4		    ; if anything else its control char
;     cp CTRL_H               ; backSpace ?
;     jr nz,interpret2        ; no, ignore
;     ld hl,TIB               ; is bc at start of TIB
;     or a
;     sbc hl,bc
;     ld a,h                  ; is bc at start of TIB?
;     or l
;     jr z, interpret2        ; yes, ignore backspace
;     dec bc
;     call printStr
;     .cstr "\b \b"
;     jr interpret2

; interpret4:
;     ld a,"\n"
;     ld (bc),a               ; store null in text buffer 
;     call crlf               ; echo newline to screen

;     ld bc,TIB               ; Instructions stored on heap at address HERE, we pressed enter
;     dec bc
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

; *******************************************************************************
; *********  END OF MAIN   ******************************************************
; *******************************************************************************
