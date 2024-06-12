ROMSTART    .EQU $0000
RAMSTART    .EQU $0800
ROMSIZE     .EQU $0800
RAMSIZE     .EQU $0800

NO_MATCH    .equ    -1
CTRL_H      .equ    8
BUFFER_SIZE  equ 80

tokens:

COMMA_      .equ    ","
COMMENT_    .equ    ";"
DIRECT_     .equ    "D"
DOLLAR_     .equ    "$"
EOF_        .equ    "E"
FLAG_       .equ    "F"
IDENT_      .equ    "I"
LABEL_      .equ    "L"
NEWLN_      .equ    "\n"
NUM_        .equ    "9"
OPCODE_     .equ    "C"
PARCLOSE_   .equ    ")"
PAROPEN_    .equ    "("
REG_        .equ    "R"
REGPAIR_    .equ    "P"
UNKNOWN_    .equ    "U"

opcode_idx:

ADC_        .equ    0
ADD_        .equ    1
AND_        .equ    2
BIT_        .equ    3
CALL_       .equ    4
CCF_        .equ    5
CP_         .equ    6
CPD_        .equ    7
CPDR_       .equ    8
CPI_        .equ    9
CPIR_       .equ    10
CPL_        .equ    11
DAA_        .equ    12
DEC_        .equ    13
DI_         .equ    14
DJNZ_       .equ    15
EI_         .equ    16
EX_         .equ    17
EXX_        .equ    18
HALT_       .equ    19
IM_         .equ    20
IN_         .equ    21
INC_        .equ    22
IND_        .equ    23
INDR_       .equ    24
INI_        .equ    25
INIR_       .equ    26
JP_         .equ    27
JR_         .equ    28
LD_         .equ    29
LDD_        .equ    30
LDDR_       .equ    31
LDI_        .equ    32
LDIR_       .equ    33
NEG_        .equ    34
NOP_        .equ    35
OR_         .equ    36
OTDR_       .equ    37
OTIR_       .equ    38
OUT_        .equ    39
OUTD_       .equ    40
OUTI_       .equ    41
POP_        .equ    42
PUSH_       .equ    43
RES_        .equ    44
RET_        .equ    45
RETI_       .equ    46
RETN_       .equ    47
RL_         .equ    48
RLA_        .equ    49
RLC_        .equ    50
RLCA_       .equ    51
RLD_        .equ    52
RR_         .equ    53
RRA_        .equ    54
RRC_        .equ    55
RRCA_       .equ    56
RRD_        .equ    57
RST_        .equ    58
SBC_        .equ    59
SCF_        .equ    60
SET_        .equ    61
SLA_        .equ    62
SRA_        .equ    63
SRL_        .equ    64
SUB_        .equ    65
XOR_        .equ    66

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
        