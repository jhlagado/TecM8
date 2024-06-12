.ORG RAMSTART

.align $100

buffer      ds BUFFER_SIZE      ; line buffer, page aligned
            ds $100
stack:                          ; grows down

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

vBufferPos: ds 2                ; pointer to char position into input buffer
vToken:     ds 1                ; buffer for pushed back token
vTokenVal:  ds 2                ; buffer for pushed back token value
vAsmPtr:    ds 2                ; pointer to assembly point
vStrPtr:    ds 2                ; pointer to string stack
vSymPtr:    ds 2                ; pointer to symbol stack
vExprPtr:   ds 2                ; pointer to expression stack

strings:    ds $100             ; string heap - grows up
symbols:    ds $100             ; symbol heap - grows up
exprs:      ds $100             ; expression heap - grows up

assembly:
