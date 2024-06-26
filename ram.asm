.org RAMSTART

.align $100

BUFFER:     ds BUFFER_SIZE      ; line BUFFER,page aligned
            ds $100
STACK:                          ; grows down

vTemp1:     ds 2                ; temp var 1
vTemp2:     ds 2                ; temp var 2

vToken:     ds 1                ; BUFFER for pushed back token
vTokenVal:  ds 2                ; BUFFER for pushed back token value
vBufferPos: ds 2                ; pointer to char position into input BUFFER
vAsmPtr:    ds 2                ; pointer to ASSEMBLY point
vSymPtr:    ds 2                ; pointer to last symbol
vExprPtr:   ds 2                ; pointer to last expression
vHeapPtr:   ds 2                ; pointer to Heap

vOpcode     ds 1
vOperand1   ds 1
vOperand2   ds 1
vOpExpr     ds 2
vOpDisp     ds 2


RST08:      ds 2                 
RST10:      ds 2                 
RST18:      ds 2                 
RST20:      ds 2                 
RST28:      ds 2                 
RST30:      ds 2                 
BAUD        ds 2                 
INTVEC:     ds 2                 
NMIVEC:     ds 2                 
GETCVEC:    ds 2                   
PUTCVEC:    ds 2                   

HEAP:       ds HEAP_SIZE             ; expression heap - grows up
ASSEMBLY:
