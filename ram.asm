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
vIsBranch:  ds 1

vOpcode:    ds 1                ; must be contiguous for expect
vOp1:                           ; operand1 lsb = type, msb = val
vOp1Type:   ds 1
vOp1Val:    ds 1
vOp2:                           ; operand2 lsb = type, msb = val
vOp2Type:   ds 1
vOp2Val:    ds 1

vOpExpr:    ds 2
vOpDisp:    ds 2


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
