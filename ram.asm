.ORG RAMSTART

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

vToken:     ds 2                ; byte containing enum of token type
vTokPtr:    ds 2                ; pointer to start of token value
vCharPtr:   ds 2                ; pointer to char position into input buffer
vAsmPtr:    ds 2                ; pointer to assembly point
vStrPtr:    ds 2                ; pointer to string stack
vSymPtr:    ds 2                ; pointer to symbol stack
vExprPtr:   ds 2                ; pointer to expression stack

chars:      ds $100             ; page aligned, 256 bytes , a long line!

            ds $100
stack:                          ; grows down
strings:    ds $100             ; string heap - grows up
symbols:    ds $100             ; symbol heap - grows up
exprs:      ds $100             ; expression heap - grows up

assembly: