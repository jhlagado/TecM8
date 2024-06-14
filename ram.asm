.ORG RAMSTART

.align $100

BUFFER      ds BUFFER_SIZE      ; line BUFFER, page aligned
            ds $100
STACK:                          ; grows down

RST08:      DS 2                 
RST10:      DS 2                 
RST18:      DS 2                 
RST20:      DS 2                 
RST28:      DS 2                 
RST30:      DS 2                ; 
BAUD        DS 2                ; 
INTVEC:     DS 2                ; 
NMIVEC:     DS 2                ; 
GETCVEC:    DS 2                ;   
PUTCVEC:    DS 2                ;   

vTemp1:     ds 2                ; temp var 1
vTemp2:     ds 2                ; temp var 2

vToken:     ds 1                ; BUFFER for pushed back token
vTokenVal:  ds 2                ; BUFFER for pushed back token value
vBufferPos: ds 2                ; pointer to char position into input BUFFER
vAsmPtr:    ds 2                ; pointer to ASSEMBLY point
vStrPtr:    ds 2                ; pointer to string STACK
vSymPtr:    ds 2                ; pointer to symbol STACK
vExprPtr:   ds 2                ; pointer to expression STACK

STRINGS:    ds $100             ; string heap - grows up
SYMBOLS:    ds $100             ; symbol heap - grows up
EXPRS:      ds $100             ; expression heap - grows up

ASSEMBLY:
