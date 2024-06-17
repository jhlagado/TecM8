ROMSTART    .equ    $0000
RAMSTART    .equ    $0800
ROMSIZE     .equ    $0800
RAMSIZE     .equ    $0800

EOF         .equ    -1
NULL        .equ    0
CTRL_C      .equ    3
CTRL_H      .equ    8
ESC         .equ    27 
NO_MATCH    .equ    -1

BUFFER_SIZE .equ    $80
STRS_SIZE:  .equ    $100
SYMS_SIZE:  .equ    $100
EXPRS_SIZE: .equ    $100

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
OPERAND_    .equ    "R"
RPAREN_     .equ    ")"
UNKNOWN_    .equ    "U"

alu_code    .equ    0x00
rot_code    .equ    0x20
bli_code    .equ    0x40
gen1_code   .equ    0x60
gen2_code   .equ    0x80

alu_idx:

ADD_        .equ  0 | alu_code
ADC_        .equ  1 | alu_code
SUB_        .equ  2 | alu_code
SBC_        .equ  3 | alu_code
AND_        .equ  4 | alu_code
XOR_        .equ  5 | alu_code
OR_         .equ  6 | alu_code
CP_         .equ  7 | alu_code

rot_idx:

RLC_        .equ  0 | rot_code
RRC_        .equ  1 | rot_code
RL_         .equ  2 | rot_code
RR_         .equ  3 | rot_code
SLA_        .equ  4 | rot_code
SRA_        .equ  5 | rot_code
SLL_        .equ  6 | rot_code
SRL_        .equ  7 | rot_code

bli_idx:

LDI_        .equ  00 | bli_code
CPI_        .equ  01 | bli_code
INI_        .equ  02 | bli_code
OUTI_       .equ  03 | bli_code
LDD_        .equ  04 | bli_code
CPD_        .equ  05 | bli_code
IND_        .equ  06 | bli_code
OUTD_       .equ  07 | bli_code
LDIR_       .equ  08 | bli_code
CPIR_       .equ  09 | bli_code
INIR_       .equ  10 | bli_code
OTIR_       .equ  11 | bli_code
LDDR_       .equ  12 | bli_code
CPDR_       .equ  13 | bli_code
INDR_       .equ  14 | bli_code
OTDR_       .equ  15 | bli_code

gen1_idx:

CCF_        .equ  00  | gen1_code
CPL_        .equ  01  | gen1_code
DAA_        .equ  02  | gen1_code
DI_         .equ  03  | gen1_code
EI_         .equ  04  | gen1_code
HALT_       .equ  05  | gen1_code
NOP_        .equ  06  | gen1_code
RLCA_       .equ  07  | gen1_code
RST_        .equ  08  | gen2_code
SCF_        .equ  09  | gen1_code

gen2_idx:

BIT_        .equ  00  | gen2_code
CALL_       .equ  01  | gen2_code
DEC_        .equ  02  | gen2_code
DJNZ_       .equ  03  | gen2_code
EX_         .equ  04  | gen2_code
EXX_        .equ  05  | gen2_code
IM_         .equ  06  | gen2_code
IN_         .equ  07  | gen2_code
INC_        .equ  08  | gen2_code
JP_         .equ  09  | gen2_code
JR_         .equ  10  | gen2_code
LD_         .equ  11  | gen2_code
NEG_        .equ  12  | gen2_code
OUT_        .equ  13  | gen2_code
POP_        .equ  14  | gen2_code
PUSH_       .equ  15  | gen2_code
RES_        .equ  16  | gen2_code
RET_        .equ  17  | gen2_code
RETI_       .equ  18  | gen2_code
RETN_       .equ  19  | gen2_code
RLA_        .equ  20  | gen2_code
RLD_        .equ  21  | gen2_code
RRA_        .equ  22  | gen2_code
RRCA_       .equ  23  | gen2_code
RRD_        .equ  24  | gen2_code
SET_        .equ  25  | gen2_code

flag_code   .equ    0x08    ; NZ etc
reg_code    .equ    0x10    ; A, B etc
immed_code  .equ    0x18    ; 0xff or 0xffff
i16_code    .equ    0x20    ; 8-bit or 16-bit e.g. A or HL, 0xff or 0xffff
mem_code    .equ    0x40    ; (HL) or (0xffff)
na_code     .equ    0x80    ; n/a high 7th bit means no operand (can use -1)

reg8_idx:                        ; 8-bit registers

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

BC_         .equ    0
DE_         .equ    1
HL_         .equ    2
SP_         .equ    3
IX_         .equ    5
IY_         .equ    6
AFP_        .equ    4           ; AF' (prime)
AF_         .equ    7           ; NOTE: AF has the same code as SP in some instructions

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

TEC_1       .equ 1
RC2014      .equ 0

EXTENDED    .equ 0

LOADER      .equ 0
BITBANG     .equ 0
        