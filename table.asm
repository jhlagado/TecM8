column 0 mnemonic
=================

column 1 args
=============

column 2 opcode
===============

column 2A prefix
================
0 - none
1 - CB
2 - DD
3 - ED
4 - FD
5 - 60
6 - 62
7 - 50
8 - 54
9 - 42
A - 44

column 3 size
=============

column 4 type
=============
0 - regular
1 - index
2 - bit
3 - relative 

column 5 or
============

ADC  A,(HL)    8E 0 1 0 
ADC  A,(IX*)   8E 2 3 1 
ADC  A,(IY*)   8E 4 3 1 
ADC  A,A       8F 0 1 0 
ADC  A,B       88 0 1 0 
ADC  A,C       89 0 1 0 
ADC  A,D       8A 0 1 0 
ADC  A,E       8B 0 1 0 
ADC  A,H       8C 0 1 0 
ADC  A,IXH     8C 2 2 0 
ADC  A,IXL     8D 2 2 0 
ADC  A,IYH     8C 4 2 0 
ADC  A,IYL     8D 4 2 0 
ADC  A,L       8D 0 1 0 
ADC  A,*       CE 0 2 0 
ADC  HL,BC     4A 3 2 0 
ADC  HL,DE     5A 3 2 0 
ADC  HL,HL     6A 3 2 0 
ADC  HL,SP     7A 3 2 0 
ADD  A,(HL)    86 0 1 0 
ADD  A,(IX*)   86 2 3 1 
ADD  A,(IY*)   86 4 3 1 
ADD  A,A       87 0 1 0 
ADD  A,B       80 0 1 0 
ADD  A,C       81 0 1 0 
ADD  A,D       82 0 1 0 
ADD  A,E       83 0 1 0 
ADD  A,H       84 0 1 0 
ADD  A,IXH     84 2 2 0 
ADD  A,IXL     85 2 2 0 
ADD  A,IYH     84 4 2 0 
ADD  A,IYL     85 4 2 0 
ADD  A,L       85 0 1 0 
ADD  A,*       C6 0 2 0 
ADD  HL,BC     09 0 1 0 
ADD  HL,DE     19 0 1 0 
ADD  HL,HL     29 0 1 0 
ADD  HL,SP     39 0 1 0 
ADD  IX,BC     09 2 2 0 
ADD  IX,DE     19 2 2 0 
ADD  IX,IX     29 2 2 0 
ADD  IX,SP     39 2 2 0 
ADD  IY,BC     09 4 2 0 
ADD  IY,DE     19 4 2 0 
ADD  IY,IY     29 4 2 0 
ADD  IY,SP     39 4 2 0 
AND  (HL)      A6 0 1 0 
AND  (IX*)     A6 2 3 1 
AND  (IY*)     A6 4 3 1 
AND  A         A7 0 1 0 
AND  B         A0 0 1 0 
AND  C         A1 0 1 0 
AND  D         A2 0 1 0 
AND  E         A3 0 1 0 
AND  H         A4 0 1 0 
AND  IXH       A4 2 2 0 
AND  IXL       A5 2 2 0 
AND  IYH       A4 4 2 0 
AND  IYL       A5 4 2 0 
AND  L         A5 0 1 0 
AND  *         E6 0 2 0 
BIT  *,(HL)    46 1 2 2 
BIT  *,(IX*)   CB 2 4 2 46
BIT  *,(IY*)   CB 4 4 2 46
BIT  *,A       47 1 2 2
BIT  *,B       40 1 2 2
BIT  *,C       41 1 2 2
BIT  *,D       42 1 2 2
BIT  *,E       43 1 2 2
BIT  *,H       44 1 2 2
BIT  *,L       45 1 2 2
CALL C,*       DC 0 3 0
CALL M,*       FC 0 3 0
CALL NC,*      D4 0 3 0
CALL NZ,*      C4 0 3 0
CALL P,*       F4 0 3 0
CALL PE,*      EC 0 3 0
CALL PO,*      E4 0 3 0
CALL Z,*       CC 0 3 0
CALL *         CD 0 3 0
CCF            3F 0 1 0
CP   (HL)      BE 0 1 0
CP   (IX*)     BE 2 3 1
CP   (IY*)     BE 4 3 1
CP   A         BF 0 1 0
CP   B         B8 0 1 0
CP   C         B9 0 1 0
CP   D         BA 0 1 0
CP   E         BB 0 1 0
CP   H         BC 0 1 0
CP   IXH       BC 2 2 0
CP   IXL       BD 2 2 0
CP   IYH       BC 4 2 0
CP   IYL       BD 4 2 0
CP   L         BD 0 1 0
CP   *         FE 0 2 0
CPD            A9 3 2 0
CPDR           B9 3 2 0
CPIR           B1 3 2 0
CPI            A1 3 2 0
CPL            2F 0 1 0
DAA            27 0 1 0
DEC  (HL)      35 0 1 0
DEC  (IX*)     35 2 3 1
DEC  (IY*)     35 4 3 1
DEC  A         3D 0 1 0
DEC  B         05 0 1 0
DEC  BC        0B 0 1 0
DEC  C         0D 0 1 0
DEC  D         15 0 1 0
DEC  DE        1B 0 1 0
DEC  E         1D 0 1 0
DEC  H         25 0 1 0
DEC  HL        2B 0 1 0
DEC  IX        2B 2 2 0
DEC  IXH       25 2 2 0
DEC  IXL       2D 2 2 0
DEC  IY        2B 4 2 0
DEC  IYH       24 4 2 0
DEC  IYL       2D 4 2 0
DEC  L         2D 0 1 0
DEC  SP        3B 0 1 0
DI             F3 0 1 0
DJNZ *         10 0 2 3 
EI             FB 0 1 0
EX   (SP),HL   E3 0 1 0
EX   (SP),IX   E3 2 2 0
EX   (SP),IY   E3 4 2 0
EX   AF,AF'    08 0 1 0
EX   DE,HL     EB 0 1 0
EXX            D9 0 1 0
HALT           76 0 1 0
IM   0         46 3 2 0
IM   1         56 3 2 0
IM   2         5E 3 2 0
IN   A,(C)     78 3 2 0
IN   B,(C)     40 3 2 0
IN   C,(C)     48 3 2 0
IN   D,(C)     50 3 2 0
IN   E,(C)     58 3 2 0
IN   H,(C)     60 3 2 0
IN   L,(C)     68 3 2 0
IN   A,(*)     DB 0 2 0
INC  (HL)      34 0 1 0
INC  (IX*)     34 2 3 1
INC  (IY*)     34 4 3 1
INC  A         3C 0 1 0
INC  B         04 0 1 0
INC  BC        03 0 1 0
INC  C         0C 0 1 0
INC  D         14 0 1 0
INC  DE        13 0 1 0
INC  E         1C 0 1 0
INC  H         24 0 1 0
INC  HL        23 0 1 0
INC  IX        23 2 2 0
INC  IXH       24 2 2 0
INC  IXL       2C 2 2 0
INC  IY        23 4 2 0
INC  IYH       24 4 2 0
INC  IYL       2C 4 2 0
INC  L         2C 0 1 0
INC  SP        33 0 1 0
IND            AA 3 2 0
INDR           BA 3 2 0
INI            A2 3 2 0
INIR           B2 3 2 0
JP   (HL)      E9 0 1 0
JP   (IX)      E9 2 2 0
JP   (IY)      E9 4 2 0
JP   C,*       DA 0 3 0
JP   M,*       FA 0 3 0
JP   NC,*      D2 0 3 0
JP   NZ,*      C2 0 3 0
JP   P,*       F2 0 3 0
JP   PE,*      EA 0 3 0
JP   PO,*      E2 0 3 0
JP   Z,*       CA 0 3 0
JP   *         C3 0 3 0
JR   C,*       38 0 2 3 
JR   NC,*      30 0 2 3 
JR   NZ,*      20 0 2 3 
JR   Z,*       28 0 2 3 
JR   *         18 0 2 3 
LD   (BC),A    02 0 1 0
LD   (DE),A    12 0 1 0
LD   (HL),A    77 0 1 0
LD   (HL),B    70 0 1 0
LD   (HL),C    71 0 1 0
LD   (HL),D    72 0 1 0
LD   (HL),E    73 0 1 0
LD   (HL),H    74 0 1 0
LD   (HL),L    75 0 1 0
LD   (HL),*    36 0 2 0
LD   (IX*),A   77 2 3 1
LD   (IX*),B   70 2 3 1
LD   (IX*),C   71 2 3 1
LD   (IX*),D   72 2 3 1
LD   (IX*),E   73 2 3 1
LD   (IX*),H   74 2 3 1
LD   (IX*),L   75 2 3 1
LD   (IX*),*   36 2 4 1
LD   (IY*),A   77 4 3 1
LD   (IY*),B   70 4 3 1
LD   (IY*),C   71 4 3 1
LD   (IY*),D   72 4 3 1
LD   (IY*),E   73 4 3 1
LD   (IY*),H   74 4 3 1
LD   (IY*),L   75 4 3 1
LD   (IY*),*   36 4 4 1
LD   (*),A     32 0 3 0
LD   (*),BC    43 3 4 0
LD   (*),DE    53 3 4 0
LD   (*),HL    22 0 3 0
LD   (*),IX    22 2 4 0
LD   (*),IY    22 4 4 0
LD   (*),SP    73 3 4 0
LD   A,(BC)    0A 0 1 0
LD   A,(DE)    1A 0 1 0
LD   A,(HL)    7E 0 1 0
LD   A,(IX*)   7E 2 3 1
LD   A,(IY*)   7E 4 3 1
LD   A,A       7F 0 1 0
LD   A,B       78 0 1 0
LD   A,C       79 0 1 0
LD   A,D       7A 0 1 0
LD   A,E       7B 0 1 0
LD   A,H       7C 0 1 0
LD   A,I       57 3 2 0
LD   A,IXH     7C 2 2 0
LD   A,IXL     7D 2 2 0
LD   A,IYH     7C 4 2 0
LD   A,IYL     7D 4 2 0
LD   A,L       7D 0 1 0
LD   A,R       5F 3 2 0
LD   A,(*)     3A 0 3 0
LD   A,*       3E 0 2 0
LD   B,(HL)    46 0 1 0
LD   B,(IX*)   46 2 3 1
LD   B,(IY*)   46 4 3 1
LD   B,A       47 0 1 0
LD   B,B       40 0 1 0
LD   B,C       41 0 1 0
LD   B,D       42 0 1 0
LD   B,E       43 0 1 0
LD   B,H       44 0 1 0
LD   B,IXH     44 2 2 0
LD   B,IXL     45 2 2 0
LD   B,IYH     44 4 2 0
LD   B,IYL     45 4 2 0
LD   B,L       45 0 1 0
LD   B,*       06 0 2 0
LD   BC,(*)    4B 3 4 0
LD   BC,DE     4B 9 2 0
LD   BC,HL     4D A 2 0
LD   BC,*      01 0 3 0
LD   C,(HL)    4E 0 1 0
LD   C,(IX*)   4E 2 3 1
LD   C,(IY*)   4E 4 3 1
LD   C,A       4F 0 1 0
LD   C,B       48 0 1 0
LD   C,C       49 0 1 0
LD   C,D       4A 0 1 0
LD   C,E       4B 0 1 0
LD   C,H       4C 0 1 0
LD   C,IXH     4C 2 2 0
LD   C,IXL     4D 2 2 0
LD   C,IYH     4C 4 2 0
LD   C,IYL     4D 4 2 0
LD   C,L       4D 0 1 0
LD   C,*       0E 0 2 0
LD   D,(HL)    56 0 1 0
LD   D,(IX*)   56 2 3 1
LD   D,(IY*)   56 4 3 1
LD   D,A       57 0 1 0
LD   D,B       50 0 1 0
LD   D,C       51 0 1 0
LD   D,D       52 0 1 0
LD   D,E       53 0 1 0
LD   D,H       54 0 1 0
LD   D,IXH     54 2 2 0
LD   D,IXL     55 2 2 0
LD   D,IYH     54 4 2 0
LD   D,IYL     55 4 2 0
LD   D,L       55 0 1 0
LD   D,*       16 0 2 0
LD   DE,(*)    5B 3 4 0
LD   DE,BC     59 7 2 0
LD   DE,HL     5D 8 2 0
LD   DE,*      11 0 3 0
LD   E,(HL)    5E 0 1 0
LD   E,(IX*)   5E 2 3 1
LD   E,(IY*)   5E 4 3 1
LD   E,A       5F 0 1 0
LD   E,B       58 0 1 0
LD   E,C       59 0 1 0
LD   E,D       5A 0 1 0
LD   E,E       5B 0 1 0
LD   E,H       5C 0 1 0
LD   E,IXH     5C 2 2 0
LD   E,IXL     5D 2 2 0
LD   E,IYH     5C 4 2 0
LD   E,IYL     5D 4 2 0
LD   E,L       5D 0 1 0
LD   E,*       1E 0 2 0
LD   H,(HL)    66 0 1 0
LD   H,(IX*)   66 2 3 1
LD   H,(IY*)   66 4 3 1
LD   H,A       67 0 1 0
LD   H,B       60 0 1 0
LD   H,C       61 0 1 0
LD   H,D       62 0 1 0
LD   H,E       63 0 1 0
LD   H,H       64 0 1 0
LD   H,L       65 0 1 0
LD   H,*       26 0 2 0
LD   HL,(*)    2A 0 3 0
LD   HL,BC     69 5 2 0
LD   HL,DE     6B 6 2 0
LD   HL,*      21 0 3 0
LD   I,A       47 3 2 0
LD   IX,(*)    2A 2 4 0
LD   IX,*      21 2 4 0
LD   IXH,A     67 2 2 0
LD   IXH,B     60 2 2 0
LD   IXH,C     61 2 2 0
LD   IXH,D     62 2 2 0
LD   IXH,E     63 2 2 0
LD   IXH,IXH   64 2 2 0
LD   IXH,IXL   65 2 2 0
LD   IXH,*     26 2 3 0
LD   IXL,A     6F 2 2 0
LD   IXL,B     68 2 2 0
LD   IXL,C     69 2 2 0
LD   IXL,D     6A 2 2 0
LD   IXL,E     6B 2 2 0
LD   IXL,IXH   6C 2 2 0
LD   IXL,IXL   6D 2 2 0
LD   IXL,*     2E 2 3 0
LD   IY,(*)    2A 4 4 0
LD   IY,*      21 4 4 0
LD   IYH,A     67 4 2 0
LD   IYH,B     60 4 2 0
LD   IYH,C     61 4 2 0
LD   IYH,D     62 4 2 0
LD   IYH,E     63 4 2 0
LD   IYH,IYH   64 4 2 0
LD   IYH,IYL   65 4 2 0
LD   IYH,*     26 4 3 0
LD   IYL,A     6F 4 2 0
LD   IYL,B     68 4 2 0
LD   IYL,C     69 4 2 0
LD   IYL,D     6A 4 2 0
LD   IYL,E     6B 4 2 0
LD   IYL,IYH   6C 4 2 0
LD   IYL,IYL   6D 4 2 0
LD   IYL,*     2E 4 3 0
LD   L,(HL)    6E 0 1 0
LD   L,(IX*)   6E 2 3 1
LD   L,(IY*)   6E 4 3 1
LD   L,A       6F 0 1 0
LD   L,B       68 0 1 0
LD   L,C       69 0 1 0
LD   L,D       6A 0 1 0
LD   L,E       6B 0 1 0
LD   L,H       6C 0 1 0
LD   L,L       6D 0 1 0
LD   L,*       2E 0 2 0
LD   R,A       4F 3 2 0
LD   SP,(*)    7B 3 4 0
LD   SP,HL     F9 0 1 0
LD   SP,IX     F9 2 2 0
LD   SP,IY     F9 4 2 0
LD   SP,*      31 0 3 0
LDD            A8 3 2 0
LDDR           B8 3 2 0
LDI            A0 3 2 0
LDIR           B0 3 2 0
NEG            44 3 2 0
NOP            00 0 1 0
OR   (HL)      B6 0 1 0
OR   (IX*)     B6 2 3 1
OR   (IY*)     B6 4 3 1
OR   A         B7 0 1 0
OR   B         B0 0 1 0
OR   C         B1 0 1 0
OR   D         B2 0 1 0
OR   E         B3 0 1 0
OR   H         B4 0 1 0
OR   IXH       B4 2 2 0
OR   IXL       B5 2 2 0
OR   IYH       B4 4 2 0
OR   IYL       B5 4 2 0
OR   L         B5 0 1 0
OR   *         F6 0 2 0
OTDR           BB 3 2 0
OTIR           B3 3 2 0
OUT  (C),A     79 3 2 0
OUT  (C),B     41 3 2 0
OUT  (C),C     49 3 2 0
OUT  (C),D     51 3 2 0
OUT  (C),E     59 3 2 0
OUT  (C),H     61 3 2 0
OUT  (C),L     69 3 2 0
OUT  (*),A     D3 0 2 0
OUTD           AB 3 2 0
OUTI           A3 3 2 0
POP  AF        F1 0 1 0
POP  BC        C1 0 1 0
POP  DE        D1 0 1 0
POP  HL        E1 0 1 0
POP  IX        E1 2 2 0
POP  IY        E1 4 2 0
PUSH AF        F5 0 1 0
PUSH BC        C5 0 1 0
PUSH DE        D5 0 1 0
PUSH HL        E5 0 1 0
PUSH IX        E5 2 2 0
PUSH IY        E5 4 2 0
RES  *,(HL)    86 1 2 2
RES  *,(IX*)   CB 2 4 2 86
RES  *,(IY*)   CB 4 4 2 86
RES  *,A       87 1 2 2
RES  *,B       80 1 2 2
RES  *,C       81 1 2 2
RES  *,D       82 1 2 2
RES  *,E       83 1 2 2
RES  *,H       84 1 2 2
RES  *,L       85 1 2 2
RET            C9 0 1 0
RET  C         D8 0 1 0
RET  M         F8 0 1 0
RET  NC        D0 0 1 0
RET  NZ        C0 0 1 0
RET  P         F0 0 1 0
RET  PE        E8 0 1 0
RET  PO        E0 0 1 0
RET  Z         C8 0 1 0
RETI           4D 3 2 0
RETN           45 3 2 0
RL   (HL)      16 1 2 0
RL   (IX*)     CB 2 4 1 16
RL   (IY*)     CB 4 4 1 16
RL   A         17 1 2 0
RL   B         10 1 2 0
RL   C         11 1 2 0
RL   D         12 1 2 0
RL   E         13 1 2 0
RL   H         14 1 2 0
RL   L         15 1 2 0
RLA            17 0 1 0
RLC  (HL)      06 1 2 0
RLC  (IX*)     CB 2 4 1 06
RLC  (IY*)     CB 4 4 1 06
RLC  A         07 1 2 0
RLC  B         00 1 2 0
RLC  C         01 1 2 0
RLC  D         02 1 2 0
RLC  E         03 1 2 0
RLC  H         04 1 2 0
RLC  L         05 1 2 0
RLCA           07 0 1 0
RLD            6F 3 2 0
RR   (HL)      1E 1 2 0
RR   (IX*)     CB 2 4 1 1E
RR   (IY*)     CB 4 4 1 1E
RR   A         1F 1 2 0
RR   B         18 1 2 0
RR   C         19 1 2 0
RR   D         1A 1 2 0
RR   E         1B 1 2 0
RR   H         1C 1 2 0
RR   L         1D 1 2 0
RRA            1F 0 1 0
RRC  (HL)      0E 1 2 0
RRC  (IX*)     CB 2 4 1 0E
RRC  (IY*)     CB 4 4 1 0E
RRC  A         0F 1 2 0
RRC  B         08 1 2 0
RRC  C         09 1 2 0
RRC  D         0A 1 2 0
RRC  E         0B 1 2 0
RRC  H         0C 1 2 0
RRC  L         0D 1 2 0
RRCA           0F 0 1 0
RRD            67 3 2 0
RST  00        C7 0 1 0
RST  08        CF 0 1 0
RST  10        D7 0 1 0
RST  18        DF 0 1 0
RST  20        E7 0 1 0
RST  28        EF 0 1 0
RST  30        F7 0 1 0
RST  38        FF 0 1 0
SBC  A,(HL)    9E 0 1 0
SBC  A,(IX*)   9E 2 3 1
SBC  A,(IY*)   9E 4 3 1
SBC  A,A       9F 0 1 0
SBC  A,B       98 0 1 0
SBC  A,C       99 0 1 0
SBC  A,D       9A 0 1 0
SBC  A,E       9B 0 1 0
SBC  A,H       9C 0 1 0
SBC  A,IXH     9C 2 2 0
SBC  A,IXL     9D 2 2 0
SBC  A,IYH     9C 4 2 0
SBC  A,IYL     9D 4 2 0
SBC  A,L       9D 0 1 0
SBC  HL,BC     42 3 2 0
SBC  HL,DE     52 3 2 0
SBC  HL,HL     62 3 2 0
SBC  HL,SP     72 3 2 0
SBC  A,*       DE 0 2 0
SCF            37 0 1 0
SET  *,(HL)    C6 1 2 2
SET  *,(IX*)   CB 2 4 2 C6
SET  *,(IY*)   CB 4 4 2 C6
SET  *,A       C7 1 2 2
SET  *,B       C0 1 2 2
SET  *,C       C1 1 2 2
SET  *,D       C2 1 2 2
SET  *,E       C3 1 2 2
SET  *,H       C4 1 2 2
SET  *,L       C5 1 2 2
SLA  (HL)      26 1 2 0
SLA  (IX*)     CB 2 4 1 26
SLA  (IY*)     CB 4 4 1 26
SLA  A         27 1 2 0
SLA  B         20 1 2 0
SLA  C         21 1 2 0
SLA  D         22 1 2 0
SLA  E         23 1 2 0
SLA  H         24 1 2 0
SLA  L         25 1 2 0
SLL  (HL)      36 1 2 0
SLL  (IX*)     CB 2 4 1 36
SLL  (IY*)     CB 4 4 1 36
SLL  A         37 1 2 0
SLL  B         30 1 2 0
SLL  C         31 1 2 0
SLL  D         32 1 2 0
SLL  E         33 1 2 0
SLL  H         34 1 2 0
SLL  L         35 1 2 0
SRA  (HL)      2E 1 2 0
SRA  (IX*)     CB 2 4 1 2E
SRA  (IY*)     CB 4 4 1 2E
SRA  A         2F 1 2 0
SRA  B         28 1 2 0
SRA  C         29 1 2 0
SRA  D         2A 1 2 0
SRA  E         2B 1 2 0
SRA  H         2C 1 2 0
SRA  L         2D 1 2 0
SRL  (HL)      3E 1 2 0
SRL  (IX*)     CB 2 4 1 3E
SRL  (IY*)     CB 4 4 1 3E
SRL  A         3F 1 2 0
SRL  B         38 1 2 0
SRL  C         39 1 2 0
SRL  D         3A 1 2 0
SRL  E         3B 1 2 0
SRL  H         3C 1 2 0
SRL  L         3D 1 2 0
SUB  (HL)      96 0 1 0
SUB  (IX*)     96 2 3 1
SUB  (IY*)     96 4 3 1
SUB  A         97 0 1 0
SUB  B         90 0 1 0
SUB  C         91 0 1 0
SUB  D         92 0 1 0
SUB  E         93 0 1 0
SUB  H         94 0 1 0
SUB  IXH       94 2 2 0
SUB  IXL       95 2 2 0
SUB  IYH       94 4 2 0
SUB  IYL       95 4 2 0
SUB  L         95 0 1 0
SUB  *         D6 0 2 0
XOR  (HL)      AE 0 1 0
XOR  (IX*)     AE 2 3 1
XOR  (IY*)     AE 4 3 1
XOR  A         AF 0 1 0
XOR  B         A8 0 1 0
XOR  C         A9 0 1 0
XOR  D         AA 0 1 0
XOR  E         AB 0 1 0
XOR  H         AC 0 1 0
XOR  IXH       AC 2 2 0
XOR  IXL       AD 2 2 0
XOR  IYH       AC 4 2 0
XOR  IYL       AD 4 2 0
XOR  L         AD 0 1 0
XOR  *         EE 0 2 0