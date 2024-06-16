tbPtr:
    dw 0                
tbText:
    dw 0

testGetCharImpl:
    PUSH HL
    LD HL,(tbPtr)
    LD A,(HL)
    INC HL
    LD (tbPtr),HL
    POP HL
    RET                 ;NZ flagged if character input

test:                           
    call init
    ld hl,testGetCharImpl               
    ld (GETCVEC), hl
    pop hl
    ld (tbText), hl
    push hl
    ld (tbPtr),hl
    call statementList
    pop hl
    ld a, (vBufferPos)
    ld e, a
    ld d, 0
    add hl, de
    inc hl
    jp (hl)		                    ; continue after string	

expect:
    pop hl
    ld de, ASSEMBLY
    call compareStr
    jr nz, expect1
    jp (hl)
expect1:
    call print 
    .cstr "Failed!"
    ld hl, (tbText)
    call printZStr
    halt

printHex:                           ; Display hl as a 16-bit number in hex.
    push bc                         ; preserve the IP
    ld a,h
    call printHex2
    ld a,l
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
	
