ROMSTART    .equ    $0000
RAMSTART    .equ    $3000
ROMSIZE     .equ    $3000
RAMSIZE     .equ    $0800

EOF         .equ    -1
NULL        .equ    0
CTRL_C      .equ    3
CTRL_H      .equ    8
ESC         .equ    27 
NO_MATCH    .equ    -1

BUFFER_SIZE .equ    $80
HEAP_SIZE:  .equ    $100

tokens:

COLON_      .equ    ":"
COMMA_      .equ    ","
DIRECT_     .equ    "D"
DOLLAR_     .equ    "$"
EOF_        .equ    "E"
IDENT_      .equ    "I"
LABEL_      .equ    "L"
LPAREN_     .equ    "("
NEWLN_      .equ    "\n"
NUM_        .equ    "9"
OPCODE_     .equ    "C"
OPELEM_     .equ    "M"                 ; op element: reg, rp, flag
RPAREN_     .equ    ")"
UNKNOWN_    .equ    "U"

alu_    .equ    0x00
rot_    .equ    0x20
bli_    .equ    0x40
gen1_   .equ    0x60
gen2_   .equ    0x80

alu_idx:

ADD_        .equ  0 | alu_
ADC_        .equ  1 | alu_
SUB_        .equ  2 | alu_
SBC_        .equ  3 | alu_
AND_        .equ  4 | alu_
XOR_        .equ  5 | alu_
OR_         .equ  6 | alu_
CP_         .equ  7 | alu_

rot_idx:

RLC_        .equ  0 | rot_
RRC_        .equ  1 | rot_
RL_         .equ  2 | rot_
RR_         .equ  3 | rot_
SLA_        .equ  4 | rot_
SRA_        .equ  5 | rot_
SLL_        .equ  6 | rot_
SRL_        .equ  7 | rot_

bli_idx:

LDI_        .equ  00 | bli_
CPI_        .equ  01 | bli_
INI_        .equ  02 | bli_
OUTI_       .equ  03 | bli_
LDD_        .equ  04 | bli_
CPD_        .equ  05 | bli_
IND_        .equ  06 | bli_
OUTD_       .equ  07 | bli_
LDIR_       .equ  08 | bli_
CPIR_       .equ  09 | bli_
INIR_       .equ  10 | bli_
OTIR_       .equ  11 | bli_
LDDR_       .equ  12 | bli_
CPDR_       .equ  13 | bli_
INDR_       .equ  14 | bli_
OTDR_       .equ  15 | bli_

gen1_idx:

CCF_        .equ  00 | gen1_
CPL_        .equ  01 | gen1_
DAA_        .equ  02 | gen1_
DI_         .equ  03 | gen1_
EI_         .equ  04 | gen1_
HALT_       .equ  05 | gen1_
NOP_        .equ  06 | gen1_
RLCA_       .equ  07 | gen1_
RST_        .equ  08 | gen2_
SCF_        .equ  09 | gen1_

gen2_idx:

BIT_        .equ  00 | gen2_
CALL_       .equ  01 | gen2_
DEC_        .equ  02 | gen2_
DJNZ_       .equ  03 | gen2_
EX_         .equ  04 | gen2_
EXX_        .equ  05 | gen2_
IM_         .equ  06 | gen2_
IN_         .equ  07 | gen2_
INC_        .equ  08 | gen2_
JP_         .equ  09 | gen2_
JR_         .equ  10 | gen2_
LD_         .equ  11 | gen2_
NEG_        .equ  12 | gen2_
OUT_        .equ  13 | gen2_
POP_        .equ  14 | gen2_
PUSH_       .equ  15 | gen2_
RES_        .equ  16 | gen2_
RET_        .equ  17 | gen2_
RETI_       .equ  18 | gen2_
RETN_       .equ  19 | gen2_
RLA_        .equ  20 | gen2_
RLD_        .equ  21 | gen2_
RRA_        .equ  22 | gen2_
RRCA_       .equ  23 | gen2_
RRD_        .equ  24 | gen2_
SET_        .equ  25 | gen2_

reg_        .equ    0x00        ; A, B etc
rp_         .equ    0x08        ; bit 3: register pair e.g. HL, DE
flag_       .equ    0x10        ; bit 4: flag NZ etc
immed_      .equ    0x20        ; bit 5: immediate 0xff or 0xffff
mem_        .equ    0x40        ; bit 6: memory ref (HL) or (0xffff)
idx_        .equ    0x80        ; bit 7: indexed (IX+dd)

reg8_idx:                       ; 8-bit registers

B_          .equ    0           ; B
C_          .equ    1           ; C
D_          .equ    2           ; D
E_          .equ    3           ; E
H_          .equ    4           ; H
L_          .equ    5           ; L
MHL_        .equ    6           ; (HL)
A_          .equ    7           ; A
I_          .equ    8           ; I
R_          .equ    9           ; R

reg16_idx:                         ; 16-bit registers

BC_         .equ    0 | rp_
DE_         .equ    1 | rp_
HL_         .equ    2 | rp_
SP_         .equ    3 | rp_
IX_         .equ    5 | rp_
IY_         .equ    6 | rp_
AFP_        .equ    4 | rp_    ; AF' (prime)
AF_         .equ    7 | rp_    ; NOTE: AF has the same code as SP in some instructions

flag_idx:

NZ_         .equ    0 | flag_
Z_          .equ    1 | flag_
NC_         .equ    2 | flag_
C_          .equ    3 | flag_
PO_         .equ    4 | flag_
PE_         .equ    5 | flag_
P_          .equ    6 | flag_
M_          .equ    7 | flag_

directive_idx:

ALIGN_      .equ    0                    
DB_         .equ    1               
ORG_        .equ    2 
SET_        .equ    3

; -----------------------------------------------------------------------------------------------

TEC_1       .equ 1
RC2014      .equ 0

EXTENDED    .equ 0

LOADER      .equ 0
BITBANG     .equ 0
        