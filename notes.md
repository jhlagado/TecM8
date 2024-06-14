; ident
;
; Reads characters from the input stream and stores them in a string on the heap until a non-alphanumeric character is encountered. The string is stored in Pascal string format, with the length of the string stored in the first byte.
;
; Input:
;   A: The first character of the identifier.
;   (vStrPtr): Points to the top of the strings heap.
;
; Output:
;   HL: Points to the start of the stored string in memory.
;   E: Contains the length of the string.
;   (vStrPtr): Updated to point to the top of the strings heap after the stored string.
;
; Destroyed:
;   A, DE, HL: These registers are used and modified by the routine.

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