.macro expect,msg1,val1
    POP HL
    push HL
    ld DE,val1
    or A
    sbc HL,DE
    ld A,L
    or H
    pop hl
    jr Z,expect%%M

    call print
    .cstr "\r\n\r\n",msg1

    call print
    .cstr "\r\nActual: "
    call printHex

    call print
    .cstr "\r\nExpected: "
    ld HL,val1
    call printHex

    halt
    .cstr
expect%%M:
.endm

.macro test,code1,val1
    jr test2%%M
test1%%M:
    .cstr code1
test2%%M:
    ld sp,STACK
    call init
    ld hl,testGetCharImpl               
    ld (GETCVEC),hl
    ld hl,test1%%M
    ld (tbPtr),hl
    call nextToken
    call statementList
    ; expect code1,val1
.endm

.macro println,msg1
    call print
    .cstr "\r\n",msg1,"\r\n"
.endm

tbPtr:
    dw 0                

testGetCharImpl:
    PUSH HL
    LD HL,(tbPtr)
    LD A,(HL)
    INC HL
    LD (tbPtr),HL
    POP HL
    RET                 ;NZ flagged if character input

parseStr:                           
    call init
    ld hl,testGetCharImpl               
    ld (GETCVEC),hl
    pop hl
    push hl
    ld (tbPtr),hl
    call statementList
    pop hl
    ld a,(vBufferPos)
    ld e,a
    ld d,0
    add hl,de
    inc hl
    jp (hl)		                    ; continue after string	

printHex:                           ; Display hl as a 16-bit number in hex.
    push bc                         ; preserve the IP
    ld a,H
    call printHex2
    ld a,L
    call printHex2
    pop bc
    ret
printHex2:		                    
    ld	C,A
	rra 
	rra 
	rra 
	rra 
    call printHex3
    ld a,C
printHex3:		
    and	0x0F
	add	a,0x90
	daa
	adc	a,0x40
	daa
	jp putchar
	