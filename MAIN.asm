; *************************************************************************
;
;       TecM8 1.0 Extended Minimal Interpreter for the Z80 
;
;       John Hardy
;       incorporates code by Ken Boak and Craig Jones 
;
;       GNU GENERAL PUBLIC LICENSE                   Version 3, 29 June 2007
;
;       see the LICENSE file in this repo for more information 
;
; *****************************************************************************
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
assign:
    pop hl                  ; discard value of last accessed variable
    pop de                  ; new value
    ld hl,(vPointer)
    ld (hl),e          
    ld a,(vByteMode)                   
    inc a                   ; is it byte?
    jr z,assign1
    inc hl              
    ld (hl),d          
assign1:
    jp (iy)

plus_:                           ; add the top 2 members of the stack
    pop     de                 
    pop     hl                 
    add     hl,de              
    push    hl                 
    ld hl,0
    rl l
    ld (vCarry),hl
    jp (iy)              
 
dot_:       
    pop hl
    call printDec
dot2:
    ld a,' '           
    call putChar
    jp (iy)

semi_:
    ld ix,(vBasePtr)        ; 
    call rpop               ; Restore old base pointer
    ld (vBasePtr),hl
    call rpop               ; Restore Instruction pointer
    ld bc,hl                
    jp (iy)             

colon_:   
    jp def



init:
    ld ix,RSTACK
    ld (vBasePtr),ix
    ld iy,next		            ; iy provides a faster jump to next

    ld hl,vars              
    ld de,hl
    inc de
    ld (hl),0
    ld bc,VARS_SIZE * 3         ; init vars, defs and altVars
    ldir

    ld hl,HEAP
    ld (vHeapPtr),hl
    ret

start:                          ; start of TecM8
    ld sp,DSTACK		        
    call init
    
    call printStr		; prog count to stack, put code line 235 on stack then call print
    .cstr "TecM8 0.0\r\n"

interpret:
    call prompt

    ld bc,0                 ; load bc with offset into TIB, decide char into tib or execute or control         
    ld (vTIBPtr),bc

interpret2:                 ; calc nesting 
    ld E,0                  ; initilize nesting value
    push bc                 ; save offset into TIB, 
                            ; bc is also the count of chars in TIB
    ld hl,TIB               ; hl is start of TIB
    jr interpret4

interpret3:
    ld a,(hl)               ; A = char in TIB
    inc hl                  ; inc pointer into TIB
    dec bc                  ; dec count of chars in TIB
    call nesting            ; update nesting value

interpret4:
    ld a,C                  ; is count zero?
    or B
    jr NZ, interpret3       ; if not loop
    pop bc                  ; restore offset into TIB

interpret5:   
    call getchar            ; loop around waiting for character from serial port
    cp $20			        ; compare to space
    jr NC,interpret6		    ; if >= space, if below 20 set cary flag
    cp $0                   ; is it end of string? null end of string
    jr Z,interpret8
    cp '\r'                 ; carriage return? ascii 13
    jr Z,interpret7		    ; if anything else its control char
    cp CTRL_H
    jr nz,interpret2

backSpace:
    ld a,c
    or b
    jr z, interpret2
    dec bc
    call printStr
    .cstr "\b \b"
    jr interpret2

interpret6:
    ld hl,TIB
    add hl,bc
    ld (hl),A               ; store the character in textbuf
    inc bc
    call putchar            ; echo character to screen
    call nesting
    jr  interpret5            ; wait for next character

interpret7:
    ld hl,TIB
    add hl,bc
    ld (hl),"\r"            ; store the crlf in textbuf
    inc hl
    ld (hl),"\n"            
    inc hl                  ; ????
    inc bc
    inc bc
    call crlf               ; echo character to screen
    ld a,E                  ; if zero nesting append and ETX after \r
    or A
    jr NZ,interpret5
    ld (hl),$03             ; store end of text ETX in text buffer 
    inc bc

interpret8:    
    ld (vTIBPtr),bc
    ld bc,TIB               ; Instructions stored on heap at address HERE, we pressed enter
    dec bc

next:                           
    inc bc                      ; Increment the IP
    ld a,(bc)                   ; Get the next character and dispatch
    or a                        ; is it NUL?       
    jr z,exit
    cp CTRL_C
    jr z,etx
    cp "0"
    ld d,"!"
    jr c,op
    cp "9"+1
    jr c,num
    cp "A"
    ld d,"!"+10
    jr c,op
    cp "Z"+1
    jr c,callx
    cp "a"
    ld d,"!"+10+26
    jr c,op
    cp "z"+1
    jp c,var
    ld d,"!"+10+26+26
op:    
    sub d
    jr c,next
    add a,lsb(opcodes)
    ld l,A                      ; Index into table
    ld h,msb(opcodes)           ; Start address of jump table         
    ld l,(hl)                   ; get low jump address
    inc h                       ; msb on next page
    jp (hl)                     ; Jump to routine

exit:
    inc bc			; store offests into a table of bytes, smaller
    ld de,bc                
    ld ix,(vBasePtr)        ; 
    call rpop               ; Restore old base pointer
    ld (vBasePtr),hl
    call rpop               ; Restore Instruction pointer
    ld bc,hl
    EX de,hl
    jp (hl)

etx:                                
    ld hl,-DSTACK               ; check if stack pointer is underwater
    add hl,sp
    jr NC,etx1
    ld sp,DSTACK
etx1:
    jp interpret

num:
	ld hl,$0000				    ; Clear hl to accept the number
    cp '-'
    jr nz,num0
    inc bc                      ; move to next char, no flags affected
num0:
    ex af,af'                   ; save zero flag = 0 for later
num1:
    ld a,(bc)                   ; read digit    
    sub "0"                     ; less than 0?
    jr c, num2                  ; not a digit, exit loop 
    cp 10                       ; greater that 9?
    jr nc, num2                 ; not a digit, exit loop
    inc bc                      ; inc IP
    ld de,hl                    ; multiply hl * 10
    add hl,hl    
    add hl,hl    
    add hl,de    
    add hl,hl    
    add a,l                     ; add digit in a to hl
    ld l,a
    ld a,0
    adc a,h
    ld h,a
    jr num1 
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

callx:
    call lookupRef0
    ld E,(hl)
    inc hl
    ld D,(hl)
    ld a,D                      ; skip if destination address is null
    or E
    jr Z,call2
    ld hl,bc
    inc bc                      ; read next char from source
    ld a,(bc)                   ; if ; to tail call optimise
    cp ";"                      ; by jumping to rather than calling destination
    jr Z,call1
    call rpush                  ; save Instruction Pointer
    ld hl,(vBasePtr)
    call rpush
    ld (vBasePtr),ix
call1:
    ld bc,de
    dec bc
call2:
    jp (iy) 
    
var:
    ld hl,vars
    call lookupRef
var1:
    ld (vPointer),hl
    ld d,0
    ld e,(hl)
    ld a,(vByteMode)                   
    inc a                       ; is it byte?
    jr z,var2
    inc hl
    ld d,(hl)
var2:
    push de
    jp (iy)

lookupRef0:
    ld hl,defs
    sub "A"
    jr lookupRef1        
lookupRef:
    sub "a"
lookupRef1:
    add a,a
    add a,l
    ld l,a
    ld a,0
    ADC a,h
    ld h,a
    XOR a
    or e                        ; sets Z flag if A-Z
    ret

; **************************************************************************             
; calculate nesting value
; A is char to be tested, 
; E is the nesting value (initially 0)
; E is increased by ( and [ 
; E is decreased by ) and ]
; E has its bit 7 toggled by `
; limited to 127 levels
; **************************************************************************             

nesting:                        
    cp '`'
    jr NZ,nesting1
    ld a,$80
    xor e
    ld e,a
    ret
nesting1:
    BIT 7,E             
    ret NZ             
    cp ':'
    jr Z,nesting2
    cp '['
    jr Z,nesting2
    cp '('
    jr NZ,nesting3
nesting2:
    inc E
    ret
nesting3:
    cp ';'
    jr Z,nesting4
    cp ']'
    jr Z,nesting4
    cp ')'
    ret NZ
nesting4:
    dec E
    ret 

prompt:                            
    call printStr
    .cstr "\r\n> "
    ret

crlf:                               
    call printStr
    .cstr "\r\n"
    ret

printStr:                           
    EX (sp),hl		                ; swap			
    call putStr		
    inc hl			                ; inc past null
    EX (sp),hl		                ; put it back	
    ret

putStr0:                            
    call putchar
    inc hl
putStr:
    ld a,(hl)
    or A
    jr NZ,putStr0
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

enter:                              
    ld hl,bc
    call rpush                      ; save Instruction Pointer
    ld hl,(vBasePtr)
    call rpush
    ld (vBasePtr),ix
    pop bc
    dec bc
    jp (iy)                    

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

def:                                ; Create a colon definition
    inc bc
    ld  a,(bc)                  ; Get the next character
    cp ":"                      ; is it anonymouse
    jr nz,def0
    inc bc
    ld de,(vHeapPtr)            ; return start of definition
    push de
    jr def1
def0:    
    call lookupRef0
    ld de,(vHeapPtr)            ; start of defintion
    ld (hl),E                   ; Save low byte of address in CFA
    inc hl              
    ld (hl),D                   ; Save high byte of address in CFA+1
    inc bc
def1:                               ; Skip to end of definition   
    ld a,(bc)                   ; Get the next character
    inc bc                      ; Point to next character
    ld (de),A
    inc de
    cp ";"                      ; Is it a semicolon 
    jr Z, def2                  ; end the definition
    jr  def1                    ; get the next element
def2:    
    dec bc
def3:
    ld (vHeapPtr),de            ; bump heap ptr to after definiton
    jp (iy)       

; *******************************************************************************
; *********  END OF MAIN   ******************************************************
; *******************************************************************************
; *******************************************************************************
