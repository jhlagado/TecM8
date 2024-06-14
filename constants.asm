ROMSTART    .EQU $0000
RAMSTART    .EQU $0800
ROMSIZE     .EQU $0800
RAMSIZE     .EQU $0800

CTRL_C      .equ    3
CTRL_H      .equ    8
ESC         .equ    27 
BUFFER_SIZE .equ    80
EOF         .equ    -1
NO_MATCH    .equ    -1

tokens:

COLON_      .equ    ":"
COMMA_      .equ    ","
DIRECT_     .equ    "D"
DOLLAR_     .equ    "$"
EOF_        .equ    "E"
FLAG_       .equ    "F"
IDENT_      .equ    "I"
LABEL_      .equ    "L"
LPAREN_     .equ    "("
NEWLN_      .equ    "\n"
NUM_        .equ    "9"
OPCODE_     .equ    "C"
REG_        .equ    "R"
REGPAIR_    .equ    "P"
RPAREN_     .equ    ")"
UNKNOWN_    .equ    "U"

alu_idx:

ADD_   .equ  0
ADC_   .equ  1
SUB_   .equ  2
SBC_   .equ  3
AND_   .equ  4
XOR_   .equ  5
OR_    .equ  6
CP_    .equ  7

rot_idx:

RLC_   .equ  0 | 0x10
RRC_   .equ  1 | 0x10
RL_    .equ  2 | 0x10
RR_    .equ  3 | 0x10
SLA_   .equ  4 | 0x10
SRA_   .equ  5 | 0x10
SLL_   .equ  6 | 0x10
SRL_   .equ  7 | 0x10

gen_idx:

; Opcode values
BIT_   .equ  0  | 0x40
CALL_  .equ  1  | 0x40
CCF_   .equ  2  | 0x40
CPD_   .equ  3  | 0x40
CPDR_  .equ  4  | 0x40
CPI_   .equ  5  | 0x40
CPIR_  .equ  6  | 0x40
CPL_   .equ  7  | 0x40
DAA_   .equ  8  | 0x40
DEC_   .equ  9  | 0x40
DI_    .equ  10 | 0x40
DJNZ_  .equ  11 | 0x40
EI_    .equ  12 | 0x40
EX_    .equ  13 | 0x40
EXX_   .equ  14 | 0x40
HALT_  .equ  15 | 0x40
IM_    .equ  16 | 0x40
IN_    .equ  17 | 0x40
INC_   .equ  18 | 0x40
IND_   .equ  19 | 0x40
INDR_  .equ  20 | 0x40
INI_   .equ  21 | 0x40
INIR_  .equ  22 | 0x40
JP_    .equ  23 | 0x40
JR_    .equ  24 | 0x40
LD_    .equ  25 | 0x40
LDD_   .equ  26 | 0x40
LDDR_  .equ  27 | 0x40
LDI_   .equ  28 | 0x40
LDIR_  .equ  29 | 0x40
NEG_   .equ  30 | 0x40
NOP_   .equ  31 | 0x40
OTDR_  .equ  32 | 0x40
OTIR_  .equ  33 | 0x40
OUT_   .equ  34 | 0x40
OUTD_  .equ  35 | 0x40
OUTI_  .equ  36 | 0x40
POP_   .equ  37 | 0x40
PUSH_  .equ  38 | 0x40
RES_   .equ  39 | 0x40
RET_   .equ  40 | 0x40
RETI_  .equ  41 | 0x40
RETN_  .equ  42 | 0x40
RLA_   .equ  43 | 0x40
RLCA_  .equ  44 | 0x40
RLD_   .equ  45 | 0x40
RRA_   .equ  46 | 0x40
RRCA_  .equ  47 | 0x40
RRD_   .equ  48 | 0x40
RST_   .equ  49 | 0x40
SCF_   .equ  50 | 0x40
SET_   .equ  51 | 0x40

reg_idx:

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

reg_pair_idx:

BC_         .equ    0
DE_         .equ    1
HL_         .equ    2
SP_         .equ    3
AF_         .equ    4           ; NOTE: AF has the same code as SP in some instructions
IX_         .equ    5
IY_         .equ    6
AFP_        .equ    7           ; AF' (prime)

flag_idx:

NZ_         .equ    0
Z_          .equ    1
NC_         .equ    2
C_          .equ    3
PO_         .equ    4
PE_         .equ    5
P_          .equ    6
M_          .equ    7

directive_idx:

ALIGN_      .equ    0                    
DB_         .equ    1               
ORG_        .equ    2 
SET_        .equ    3

; -----------------------------------------------------------------------------------------------

TEC_1       .EQU 1
RC2014      .EQU 0

EXTENDED    .EQU 0

LOADER      .EQU 0
BITBANG     .EQU 0
        