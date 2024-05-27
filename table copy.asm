column 0 mnemonic
=================

column 1 args
=============

column 2 opcode
===============

column 2A prefix
================
0 - none
1 - CB prefix
2 - DD prefix
3 - FD prefix

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

ADC  A,(HL)    8E    1 0 
ADC  A,(IX*)   8E DD 3 1 
ADC  A,(IY*)   8E FD 3 1 
ADC  A,A       8F    1 0 
ADC  A,B       88    1 0 
ADC  A,C       89    1 0 
ADC  A,D       8A    1 0 
ADC  A,E       8B    1 0 
ADC  A,H       8C    1 0 
ADC  A,IXH     8C DD 2 0 
ADC  A,IXL     8D DD 2 0 
ADC  A,IYH     8C FD 2 0 
ADC  A,IYL     8D FD 2 0 
ADC  A,L       8D    1 0 
ADC  A,*       CE    2 0 
ADC  HL,BC     4A ED 2 0 
ADC  HL,DE     5A ED 2 0 
ADC  HL,HL     6A ED 2 0 
ADC  HL,SP     7A ED 2 0 
   
ADD  A,(HL)    86    1 0 
ADD  A,(IX*)   86 DD 3 1 
ADD  A,(IY*)   86 FD 3 1 
ADD  A,A       87    1 0 
ADD  A,B       80    1 0 
ADD  A,C       81    1 0 
ADD  A,D       82    1 0 
ADD  A,E       83    1 0 
ADD  A,H       84    1 0 
ADD  A,IXH     84 DD 2 0 
ADD  A,IXL     85 DD 2 0 
ADD  A,IYH     84 FD 2 0 
ADD  A,IYL     85 FD 2 0 
ADD  A,L       85    1 0 
ADD  A,*       C6    2 0 
ADD  HL,BC     09    1 0 
ADD  HL,DE     19    1 0 
ADD  HL,HL     29    1 0 
ADD  HL,SP     39    1 0 
ADD  IX,BC     09 DD 2 0 
ADD  IX,DE     19 DD 2 0 
ADD  IX,IX     29 DD 2 0 
ADD  IX,SP     39 DD 2 0 
ADD  IY,BC     09 FD 2 0 
ADD  IY,DE     19 FD 2 0 
ADD  IY,IY     29 FD 2 0 
ADD  IY,SP     39 FD 2 0 
   
AND  (HL)      A6    1 0 
AND  (IX*)     A6 DD 3 1 
AND  (IY*)     A6 FD 3 1 
AND  A         A7    1 0 
AND  B         A0    1 0 
AND  C         A1    1 0 
AND  D         A2    1 0 
AND  E         A3    1 0 
AND  H         A4    1 0 
AND  IXH       A4 DD 2 0 
AND  IXL       A5 DD 2 0 
AND  IYH       A4 FD 2 0 
AND  IYL       A5 FD 2 0 
AND  L         A5    1 0 
AND  *         E6    2 0 
   
BIT  *,(HL)    46 CB 2 2 
BIT  *,(IX*)   CB DD 4 2 46
BIT  *,(IY*)   CB FD 4 2 46
BIT  *,A       47 CB 2 2
BIT  *,B       40 CB 2 2
BIT  *,C       41 CB 2 2
BIT  *,D       42 CB 2 2
BIT  *,E       43 CB 2 2
BIT  *,H       44 CB 2 2
BIT  *,L       45 CB 2 2
   
CALL C,*       DC    3 0
CALL M,*       FC    3 0
CALL NC,*      D4    3 0
CALL NZ,*      C4    3 0
CALL P,*       F4    3 0
CALL PE,*      EC    3 0
CALL PO,*      E4    3 0
CALL Z,*       CC    3 0
CALL *         CD    3 0
   
CCF            3F    1 0
   
CP   (HL)      BE    1 0
CP   (IX*)     BE DD 3 1
CP   (IY*)     BE FD 3 1
CP   A         BF    1 0
CP   B         B8    1 0
CP   C         B9    1 0
CP   D         BA    1 0
CP   E         BB    1 0
CP   H         BC    1 0
CP   IXH       BC DD 2 0
CP   IXL       BD DD 2 0
CP   IYH       BC FD 2 0
CP   IYL       BD FD 2 0
CP   L         BD    1 0
CP   *         FE    2 0
CPD            A9 ED 2 0
CPDR           B9 ED 2 0
CPIR           B1 ED 2 0
CPI            A1 ED 2 0
CPL            2F    1 0
   
DAA            27    1 0
   
DEC  (HL)      35    1 0
DEC  (IX*)     35 DD 3 1
DEC  (IY*)     35 FD 3 1
DEC  A         3D    1 0
DEC  B         05    1 0
DEC  BC        0B    1 0
DEC  C         0D    1 0
DEC  D         15    1 0
DEC  DE        1B    1 0
DEC  E         1D    1 0
DEC  H         25    1 0
DEC  HL        2B    1 0
DEC  IX        2B DD 2 0
DEC  IXH       25 DD 2 0
DEC  IXL       2D DD 2 0
DEC  IY        2B FD 2 0
DEC  IYH       24 FD 2 0
DEC  IYL       2D FD 2 0
DEC  L         2D    1 0
DEC  SP        3B    1 0
   
DI             F3    1 0
DJNZ *         10    2 3 
   
EI             FB    1 0
EX   (SP),HL   E3    1 0
EX   (SP),IX   E3 DD 2 0
EX   (SP),IY   E3 FD 2 0
EX   AF,AF'    08    1 0
EX   DE,HL     EB    1 0
EXX            D9    1 0
HALT           76    1 0
   
IM   0         46 ED 2 0
IM   1         56 ED 2 0
IM   2         5E ED 2 0
   
IM0            46 ED 2 0
IM1            56 ED 2 0
IM2            5E ED 2 0
   
IN   A,(C)     78 ED 2 0
IN   B,(C)     40 ED 2 0
IN   C,(C)     48 ED 2 0
IN   D,(C)     50 ED 2 0
IN   E,(C)     58 ED 2 0
IN   F,(C)     70 ED 2 0
IN   H,(C)     60 ED 2 0
IN   L,(C)     68 ED 2 0
   
IN   A,(*)     DB    2 0
   
INC  (HL)      34    1 0
INC  (IX*)     34 DD 3 1
INC  (IY*)     34 FD 3 1
INC  A         3C    1 0
INC  B         04    1 0
INC  BC        03    1 0
INC  C         0C    1 0
INC  D         14    1 0
INC  DE        13    1 0
INC  E         1C    1 0
INC  H         24    1 0
INC  HL        23    1 0
INC  IX        23 DD 2 0
INC  IXH       24 DD 2 0
INC  IXL       2C DD 2 0
INC  IY        23 FD 2 0
INC  IYH       24 FD 2 0
INC  IYL       2C FD 2 0
INC  L         2C    1 0
INC  SP        33    1 0
      
IND            AA ED 2 0
INDR           BA ED 2 0
INI            A2 ED 2 0
INIR           B2 ED 2 0
   
JP   (HL)      E9    1 0
JP   (IX)      E9 DD 2 0
JP   (IY)      E9 FD 2 0
JP   C,*       DA    3 0
JP   M,*       FA    3 0
JP   NC,*      D2    3 0
JP   NZ,*      C2    3 0
JP   P,*       F2    3 0
JP   PE,*      EA    3 0
JP   PO,*      E2    3 0
JP   Z,*       CA    3 0
JP   *         C3    3 0
   
JR   C,*       38    2 3 
JR   NC,*      30    2 3 
JR   NZ,*      20    2 3 
JR   Z,*       28    2 3 
JR   *         18    2 3 
   
LD   (BC),A    02    1 0
LD   (DE),A    12    1 0
LD   (HL),A    77    1 0
LD   (HL),B    70    1 0
LD   (HL),C    71    1 0
LD   (HL),D    72    1 0
LD   (HL),E    73    1 0
LD   (HL),H    74    1 0
LD   (HL),L    75    1 0
LD   (HL),*    36    2 0
LD   (IX*),A   77 DD 3 1
LD   (IX*),B   70 DD 3 1
LD   (IX*),C   71 DD 3 1
LD   (IX*),D   72 DD 3 1
LD   (IX*),E   73 DD 3 1
LD   (IX*),H   74 DD 3 1
LD   (IX*),L   75 DD 3 1
LD   (IX*),*   36 DD 4 1
LD   (IY*),A   77 FD 3 1
LD   (IY*),B   70 FD 3 1
LD   (IY*),C   71 FD 3 1
LD   (IY*),D   72 FD 3 1
LD   (IY*),E   73 FD 3 1
LD   (IY*),H   74 FD 3 1
LD   (IY*),L   75 FD 3 1
LD   (IY*),*   36 FD 4 1
LD   (*),A     32    3 0
LD   (*),BC    43 ED 4 0
LD   (*),DE    53 ED 4 0
LD   (*),HL    22    3 0
LD   (*),IX    22 DD 4 0
LD   (*),IY    22 FD 4 0
LD   (*),SP    73 ED 4 0
LD   A,(BC)    0A    1 0
LD   A,(DE)    1A    1 0
LD   A,(HL)    7E    1 0
LD   A,(IX*)   7E DD 3 1
LD   A,(IY*)   7E FD 3 1
LD   A,A       7F    1 0
LD   A,B       78    1 0
LD   A,C       79    1 0
LD   A,D       7A    1 0
LD   A,E       7B    1 0
LD   A,H       7C    1 0
LD   A,I       57 ED 2 0
LD   A,IXH     7C DD 2 0
LD   A,IXL     7D DD 2 0
LD   A,IYH     7C FD 2 0
LD   A,IYL     7D FD 2 0
LD   A,L       7D    1 0
LD   A,R       5F ED 2 0
LD   A,(*)     3A    3 0
LD   A,*       3E    2 0
LD   B,(HL)    46    1 0
LD   B,(IX*)   46 DD 3 1
LD   B,(IY*)   46 FD 3 1
LD   B,A       47    1 0
LD   B,B       40    1 0
LD   B,C       41    1 0
LD   B,D       42    1 0
LD   B,E       43    1 0
LD   B,H       44    1 0
LD   B,IXH     44 DD 2 0
LD   B,IXL     45 DD 2 0
LD   B,IYH     44 FD 2 0
LD   B,IYL     45 FD 2 0
LD   B,L       45    1 0
LD   B,*       06    2 0
LD   BC,(*)    4B ED 4 0
LD   BC,DE     4B 42 2 0
LD   BC,HL     4D 44 2 0
LD   BC,*      01    3 0
LD   C,(HL)    4E    1 0
LD   C,(IX*)   4E DD 3 1
LD   C,(IY*)   4E FD 3 1
LD   C,A       4F    1 0
LD   C,B       48    1 0
LD   C,C       49    1 0
LD   C,D       4A    1 0
LD   C,E       4B    1 0
LD   C,H       4C    1 0
LD   C,IXH     4C DD 2 0
LD   C,IXL     4D DD 2 0
LD   C,IYH     4C FD 2 0
LD   C,IYL     4D FD 2 0
LD   C,L       4D    1 0
LD   C,*       0E    2 0
LD   D,(HL)    56    1 0
LD   D,(IX*)   56 DD 3 1
LD   D,(IY*)   56 FD 3 1
LD   D,A       57    1 0
LD   D,B       50    1 0
LD   D,C       51    1 0
LD   D,D       52    1 0
LD   D,E       53    1 0
LD   D,H       54    1 0
LD   D,IXH     54 DD 2 0
LD   D,IXL     55 DD 2 0
LD   D,IYH     54 FD 2 0
LD   D,IYL     55 FD 2 0
LD   D,L       55    1 0
LD   D,*       16    2 0
LD   DE,(*)    5B ED 4 0
LD   DE,BC     59 50 2 0
LD   DE,HL     5D 54 2 0
LD   DE,*      11    3 0
LD   E,(HL)    5E    1 0
LD   E,(IX*)   5E DD 3 1
LD   E,(IY*)   5E FD 3 1
LD   E,A       5F    1 0
LD   E,B       58    1 0
LD   E,C       59    1 0
LD   E,D       5A    1 0
LD   E,E       5B    1 0
LD   E,H       5C    1 0
LD   E,IXH     5C DD 2 0
LD   E,IXL     5D DD 2 0
LD   E,IYH     5C FD 2 0
LD   E,IYL     5D FD 2 0
LD   E,L       5D    1 0
LD   E,*       1E    2 0
LD   H,(HL)    66    1 0
LD   H,(IX*)   66 DD 3 1
LD   H,(IY*)   66 FD 3 1
LD   H,A       67    1 0
LD   H,B       60    1 0
LD   H,C       61    1 0
LD   H,D       62    1 0
LD   H,E       63    1 0
LD   H,H       64    1 0
LD   H,L       65    1 0
LD   H,*       26    2 0
LD   HL,(*)    2A    3 0
LD   HL,BC     69 60 2 0
LD   HL,DE     6B 62 2 0
LD   HL,*      21    3 0
LD   I,A       47 ED 2 0
LD   IX,(*)    2A DD 4 0
LD   IX,*      21 DD 4 0
LD   IXH,A     67 DD 2 0
LD   IXH,B     60 DD 2 0
LD   IXH,C     61 DD 2 0
LD   IXH,D     62 DD 2 0
LD   IXH,E     63 DD 2 0
LD   IXH,IXH   64 DD 2 0
LD   IXH,IXL   65 DD 2 0
LD   IXH,*     26 DD 3 0
LD   IXL,A     6F DD 2 0
LD   IXL,B     68 DD 2 0
LD   IXL,C     69 DD 2 0
LD   IXL,D     6A DD 2 0
LD   IXL,E     6B DD 2 0
LD   IXL,IXH   6C DD 2 0
LD   IXL,IXL   6D DD 2 0
LD   IXL,*     2E DD 3 0
LD   IY,(*)    2A FD 4 0
LD   IY,*      21 FD 4 0
LD   IYH,A     67 FD 2 0
LD   IYH,B     60 FD 2 0
LD   IYH,C     61 FD 2 0
LD   IYH,D     62 FD 2 0
LD   IYH,E     63 FD 2 0
LD   IYH,IYH   64 FD 2 0
LD   IYH,IYL   65 FD 2 0
LD   IYH,*     26 FD 3 0
LD   IYL,A     6F FD 2 0
LD   IYL,B     68 FD 2 0
LD   IYL,C     69 FD 2 0
LD   IYL,D     6A FD 2 0
LD   IYL,E     6B FD 2 0
LD   IYL,IYH   6C FD 2 0
LD   IYL,IYL   6D FD 2 0
LD   IYL,*     2E FD 3 0
LD   L,(HL)    6E    1 0
LD   L,(IX*)   6E DD 3 1
LD   L,(IY*)   6E FD 3 1
LD   L,A       6F    1 0
LD   L,B       68    1 0
LD   L,C       69    1 0
LD   L,D       6A    1 0
LD   L,E       6B    1 0
LD   L,H       6C    1 0
LD   L,L       6D    1 0
LD   L,*       2E    2 0
LD   R,A       4F ED 2 0
LD   SP,(*)    7B ED 4 0
LD   SP,HL     F9    1 0
LD   SP,IX     F9 DD 2 0
LD   SP,IY     F9 FD 2 0
LD   SP,*      31    3 0
LDD            A8 ED 2 0
LDDR           B8 ED 2 0
LDI            A0 ED 2 0
LDIR           B0 ED 2 0
NEG            44 ED 2 0
NOP            00    1 0
   
OR   (HL)      B6    1 0
OR   (IX*)     B6 DD 3 1
OR   (IY*)     B6 FD 3 1
OR   A         B7    1 0
OR   B         B0    1 0
OR   C         B1    1 0
OR   D         B2    1 0
OR   E         B3    1 0
OR   H         B4    1 0
OR   IXH       B4 DD 2 0
OR   IXL       B5 DD 2 0
OR   IYH       B4 FD 2 0
OR   IYL       B5 FD 2 0
OR   L         B5    1 0
OR   *         F6    2 0
   
OTDR           BB ED 2 0
OTIR           B3 ED 2 0
   
OUT  (C),A     79 ED 2 0
OUT  (C),B     41 ED 2 0
OUT  (C),C     49 ED 2 0
OUT  (C),D     51 ED 2 0
OUT  (C),E     59 ED 2 0
OUT  (C),F     71 ED 2 0
OUT  (C),0     71 ED 2 0
OUT  (C),H     61 ED 2 0
OUT  (C),L     69 ED 2 0
OUT  (*),A     D3    2 0
   
OUTD           AB ED 2 0
OUTI           A3 ED 2 0
   
POP  AF        F1    1 0
POP  BC        C1    1 0
POP  DE        D1    1 0
POP  HL        E1    1 0
POP  IX        E1 DD 2 0
POP  IY        E1 FD 2 0
   
PUSH AF        F5    1 0
PUSH BC        C5    1 0
PUSH DE        D5    1 0
PUSH HL        E5    1 0
PUSH IX        E5 DD 2 0
PUSH IY        E5 FD 2 0
   
RES  *,(HL)    86 CB 2 2
RES  *,(IX*)   CB DD 4 2 86
RES  *,(IY*)   CB FD 4 2 86
RES  *,A       87 CB 2 2
RES  *,B       80 CB 2 2
RES  *,C       81 CB 2 2
RES  *,D       82 CB 2 2
RES  *,E       83 CB 2 2
RES  *,H       84 CB 2 2
RES  *,L       85 CB 2 2
RES A,*,(IX*)  CB DD 4 2 87
RES A,*,(IY*)  CB FD 4 2 87
RES B,*,(IX*)  CB DD 4 2 80
RES B,*,(IY*)  CB FD 4 2 80
RES C,*,(IX*)  CB DD 4 2 81
RES C,*,(IY*)  CB FD 4 2 81
RES D,*,(IX*)  CB DD 4 2 82
RES D,*,(IY*)  CB FD 4 2 82
RES E,*,(IX*)  CB DD 4 2 83
RES E,*,(IY*)  CB FD 4 2 83
RES H,*,(IX*)  CB DD 4 2 84
RES H,*,(IY*)  CB FD 4 2 84
RES L,*,(IX*)  CB DD 4 2 85
RES L,*,(IY*)  CB FD 4 2 85
 
RET            C9    1 0
RET  C         D8    1 0
RET  M         F8    1 0
RET  NC        D0    1 0
RET  NZ        C0    1 0
RET  P         F0    1 0
RET  PE        E8    1 0
RET  PO        E0    1 0
RET  Z         C8    1 0
RETI           4D ED 2 0
RETN           45 ED 2 0
   
RL   (HL)      16 CB 2 0
RL   (IX*)     CB DD 4 1 16
RL   (IY*)     CB FD 4 1 16
RL   A         17 CB 2 0
RL   B         10 CB 2 0
RL   C         11 CB 2 0
RL   D         12 CB 2 0
RL   E         13 CB 2 0
RL   H         14 CB 2 0
RL   L         15 CB 2 0
RLA            17    1 0
RL   A,(IX*)   CB DD 4 1 17
RL   A,(IY*)   CB FD 4 1 17
RL   B,(IX*)   CB DD 4 1 10
RL   B,(IY*)   CB FD 4 1 10
RL   C,(IX*)   CB DD 4 1 11
RL   C,(IY*)   CB FD 4 1 11
RL   D,(IX*)   CB DD 4 1 12
RL   D,(IY*)   CB FD 4 1 12
RL   E,(IX*)   CB DD 4 1 13
RL   E,(IY*)   CB FD 4 1 13
RL   H,(IX*)   CB DD 4 1 14
RL   H,(IY*)   CB FD 4 1 14
RL   L,(IX*)   CB DD 4 1 15
RL   L,(IY*)   CB FD 4 1 15
   
RLC  (HL)      06 CB 2 0
RLC  (IX*)     CB DD 4 1 06
RLC  (IY*)     CB FD 4 1 06
RLC  A         07 CB 2 0
RLC  B         00 CB 2 0
RLC  C         01 CB 2 0
RLC  D         02 CB 2 0
RLC  E         03 CB 2 0
RLC  H         04 CB 2 0
RLC  L         05 CB 2 0
RLCA           07    1 0
RLC  A,(IX*)   CB DD 4 1 07
RLC  A,(IY*)   CB FD 4 1 07
RLC  B,(IX*)   CB DD 4 1 00
RLC  B,(IY*)   CB FD 4 1 00
RLC  C,(IX*)   CB DD 4 1 01
RLC  C,(IY*)   CB FD 4 1 01
RLC  D,(IX*)   CB DD 4 1 02
RLC  D,(IY*)   CB FD 4 1 02
RLC  E,(IX*)   CB DD 4 1 03
RLC  E,(IY*)   CB FD 4 1 03
RLC  H,(IX*)   CB DD 4 1 04
RLC  H,(IY*)   CB FD 4 1 04
RLC  L,(IX*)   CB DD 4 1 05
RLC  L,(IY*)   CB FD 4 1 05
RLD            6F ED 2 0
   
RR   (HL)      1E CB 2 0
RR   (IX*)     CB DD 4 1 1E
RR   (IY*)     CB FD 4 1 1E
RR   A         1F CB 2 0
RR   B         18 CB 2 0
RR   C         19 CB 2 0
RR   D         1A CB 2 0
RR   E         1B CB 2 0
RR   H         1C CB 2 0
RR   L         1D CB 2 0
RRA            1F    1 0
RR   A,(IX*)   CB DD 4 1 1F
RR   A,(IY*)   CB FD 4 1 1F
RR   B,(IX*)   CB DD 4 1 18
RR   B,(IY*)   CB FD 4 1 18
RR   C,(IX*)   CB DD 4 1 19
RR   C,(IY*)   CB FD 4 1 19
RR   D,(IX*)   CB DD 4 1 1A
RR   D,(IY*)   CB FD 4 1 1A
RR   E,(IX*)   CB DD 4 1 1B
RR   E,(IY*)   CB FD 4 1 1B
RR   H,(IX*)   CB DD 4 1 1C
RR   H,(IY*)   CB FD 4 1 1C
RR   L,(IX*)   CB DD 4 1 1D
RR   L,(IY*)   CB FD 4 1 1D
   
RRC  (HL)      0E CB 2 0
RRC  (IX*)     CB DD 4 1 0E
RRC  (IY*)     CB FD 4 1 0E
RRC  A         0F CB 2 0
RRC  B         08 CB 2 0
RRC  C         09 CB 2 0
RRC  D         0A CB 2 0
RRC  E         0B CB 2 0
RRC  H         0C CB 2 0
RRC  L         0D CB 2 0
RRCA           0F    1 0
RRC  A,(IX*)   CB DD 4 1 0F
RRC  A,(IY*)   CB FD 4 1 0F
RRC  B,(IX*)   CB DD 4 1 08
RRC  B,(IY*)   CB FD 4 1 08
RRC  C,(IX*)   CB DD 4 1 09
RRC  C,(IY*)   CB FD 4 1 09
RRC  D,(IX*)   CB DD 4 1 0A
RRC  D,(IY*)   CB FD 4 1 0A
RRC  E,(IX*)   CB DD 4 1 0B
RRC  E,(IY*)   CB FD 4 1 0B
RRC  H,(IX*)   CB DD 4 1 0C
RRC  H,(IY*)   CB FD 4 1 0C
RRC  L,(IX*)   CB DD 4 1 0D
RRC  L,(IY*)   CB FD 4 1 0D
RRD            67 ED 2 0
   
RST  00        C7    1 0
RST  08        CF    1 0
RST  10        D7    1 0
RST  18        DF    1 0
RST  20        E7    1 0
RST  28        EF    1 0
RST  30        F7    1 0
RST  38        FF    1 0
   
SBC  A,(HL)    9E    1 0
SBC  A,(IX*)   9E DD 3 1
SBC  A,(IY*)   9E FD 3 1
SBC  A,A       9F    1 0
SBC  A,B       98    1 0
SBC  A,C       99    1 0
SBC  A,D       9A    1 0
SBC  A,E       9B    1 0
SBC  A,H       9C    1 0
SBC  A,IXH     9C DD 2 0
SBC  A,IXL     9D DD 2 0
SBC  A,IYH     9C FD 2 0
SBC  A,IYL     9D FD 2 0
SBC  A,L       9D    1 0
SBC  HL,BC     42 ED 2 0
SBC  HL,DE     52 ED 2 0
SBC  HL,HL     62 ED 2 0
SBC  HL,SP     72 ED 2 0
SBC  A,*       DE    2 0
SCF            37    1 0
   
SET  *,(HL)    C6 CB 2 2
SET  *,(IX*)   CB DD 4 2 C6
SET  *,(IY*)   CB FD 4 2 C6
SET  *,A       C7 CB 2 2
SET  *,B       C0 CB 2 2
SET  *,C       C1 CB 2 2
SET  *,D       C2 CB 2 2
SET  *,E       C3 CB 2 2
SET  *,H       C4 CB 2 2
SET  *,L       C5 CB 2 2
SET  A,*,(IY*) CB FD 4 2 C7
SET  B,*,(IY*) CB FD 4 2 C0
SET  C,*,(IY*) CB FD 4 2 C1
SET  D,*,(IY*) CB FD 4 2 C2
SET  E,*,(IY*) CB FD 4 2 C3
SET  H,*,(IY*) CB FD 4 2 C4
SET  L,*,(IY*) CB FD 4 2 C5
SET  A,*,(IX*) CB DD 4 2 C7
SET  B,*,(IX*) CB DD 4 2 C0
SET  C,*,(IX*) CB DD 4 2 C1
SET  D,*,(IX*) CB DD 4 2 C2
SET  E,*,(IX*) CB DD 4 2 C3
SET  H,*,(IX*) CB DD 4 2 C4
SET  L,*,(IX*) CB DD 4 2 C5
 
SLA  (HL)      26 CB 2 0
SLA  (IX*)     CB DD 4 1 26
SLA  (IY*)     CB FD 4 1 26
SLA  A         27 CB 2 0
SLA  B         20 CB 2 0
SLA  C         21 CB 2 0
SLA  D         22 CB 2 0
SLA  E         23 CB 2 0
SLA  H         24 CB 2 0
SLA  L         25 CB 2 0
SLA  A,(IX*)   CB DD 4 1 27
SLA  A,(IY*)   CB FD 4 1 27
SLA  B,(IX*)   CB DD 4 1 20
SLA  B,(IY*)   CB FD 4 1 20
SLA  C,(IX*)   CB DD 4 1 21
SLA  C,(IY*)   CB FD 4 1 21
SLA  D,(IX*)   CB DD 4 1 22
SLA  D,(IY*)   CB FD 4 1 22
SLA  E,(IX*)   CB DD 4 1 23
SLA  E,(IY*)   CB FD 4 1 23
SLA  H,(IX*)   CB DD 4 1 24
SLA  H,(IY*)   CB FD 4 1 24
SLA  L,(IX*)   CB DD 4 1 25
SLA  L,(IY*)   CB FD 4 1 25
   
SL1  B         30 CB 2 0
SL1  C         31 CB 2 0
SL1  D         32 CB 2 0
SL1  E         33 CB 2 0
SL1  H         34 CB 2 0
SL1  L         35 CB 2 0
SL1  (HL)      36 CB 2 0
SL1  A         37 CB 2 0
SL1  (IX*)     CB DD 4 1 36
SL1  (IY*)     CB FD 4 1 36
SL1  A,(IX*)   CB DD 4 1 37
SL1  A,(IY*)   CB FD 4 1 37
SL1  B,(IX*)   CB DD 4 1 30
SL1  B,(IY*)   CB FD 4 1 30
SL1  C,(IX*)   CB DD 4 1 31
SL1  C,(IY*)   CB FD 4 1 31
SL1  D,(IX*)   CB DD 4 1 32
SL1  D,(IY*)   CB FD 4 1 32
SL1  E,(IX*)   CB DD 4 1 33
SL1  E,(IY*)   CB FD 4 1 33
SL1  H,(IX*)   CB DD 4 1 34
SL1  H,(IY*)   CB FD 4 1 34
SL1  L,(IX*)   CB DD 4 1 35
SL1  L,(IY*)   CB FD 4 1 35
   
SLL  (HL)      36 CB 2 0
SLL  (IX*)     CB DD 4 1 36
SLL  (IY*)     CB FD 4 1 36
SLL  A         37 CB 2 0
SLL  B         30 CB 2 0
SLL  C         31 CB 2 0
SLL  D         32 CB 2 0
SLL  E         33 CB 2 0
SLL  H         34 CB 2 0
SLL  L         35 CB 2 0
SLL  A,(IX*)   CB DD 4 1 37
SLL  A,(IY*)   CB FD 4 1 37
SLL  B,(IX*)   CB DD 4 1 30
SLL  B,(IY*)   CB FD 4 1 30
SLL  C,(IX*)   CB DD 4 1 31
SLL  C,(IY*)   CB FD 4 1 31
SLL  D,(IX*)   CB DD 4 1 32
SLL  D,(IY*)   CB FD 4 1 32
SLL  E,(IX*)   CB DD 4 1 33
SLL  E,(IY*)   CB FD 4 1 33
SLL  H,(IX*)   CB DD 4 1 34
SLL  H,(IY*)   CB FD 4 1 34
SLL  L,(IX*)   CB DD 4 1 35
SLL  L,(IY*)   CB FD 4 1 35
   
SRA  (HL)      2E CB 2 0
SRA  (IX*)     CB DD 4 1 2E
SRA  (IY*)     CB FD 4 1 2E
SRA  A         2F CB 2 0
SRA  B         28 CB 2 0
SRA  C         29 CB 2 0
SRA  D         2A CB 2 0
SRA  E         2B CB 2 0
SRA  H         2C CB 2 0
SRA  L         2D CB 2 0
SRA  A,(IX*)   CB DD 4 1 2F
SRA  A,(IY*)   CB FD 4 1 2F
SRA  B,(IX*)   CB DD 4 1 28
SRA  B,(IY*)   CB FD 4 1 28
SRA  C,(IX*)   CB DD 4 1 29
SRA  C,(IY*)   CB FD 4 1 29
SRA  D,(IX*)   CB DD 4 1 2A
SRA  D,(IY*)   CB FD 4 1 2A
SRA  E,(IX*)   CB DD 4 1 2B
SRA  E,(IY*)   CB FD 4 1 2B
SRA  H,(IX*)   CB DD 4 1 2C
SRA  H,(IY*)   CB FD 4 1 2C
SRA  L,(IX*)   CB DD 4 1 2D
SRA  L,(IY*)   CB FD 4 1 2D
   
SRL  (HL)      3E CB 2 0
SRL  (IX*)     CB DD 4 1 3E
SRL  (IY*)     CB FD 4 1 3E
SRL  A         3F CB 2 0
SRL  B         38 CB 2 0
SRL  C         39 CB 2 0
SRL  D         3A CB 2 0
SRL  E         3B CB 2 0
SRL  H         3C CB 2 0
SRL  L         3D CB 2 0
SRL  A,(IX*)   CB DD 4 1 3F
SRL  A,(IY*)   CB FD 4 1 3F
SRL  B,(IX*)   CB DD 4 1 38
SRL  B,(IY*)   CB FD 4 1 38
SRL  C,(IX*)   CB DD 4 1 39
SRL  C,(IY*)   CB FD 4 1 39
SRL  D,(IX*)   CB DD 4 1 3A
SRL  D,(IY*)   CB FD 4 1 3A
SRL  E,(IX*)   CB DD 4 1 3B
SRL  E,(IY*)   CB FD 4 1 3B
SRL  H,(IX*)   CB DD 4 1 3C
SRL  H,(IY*)   CB FD 4 1 3C
SRL  L,(IX*)   CB DD 4 1 3D
SRL  L,(IY*)   CB FD 4 1 3D
   
SUB  (HL)      96    1 0
SUB  (IX*)     96 DD 3 1
SUB  (IY*)     96 FD 3 1
SUB  A         97    1 0
SUB  B         90    1 0
SUB  C         91    1 0
SUB  D         92    1 0
SUB  E         93    1 0
SUB  H         94    1 0
SUB  IXH       94 DD 2 0
SUB  IXL       95 DD 2 0
SUB  IYH       94 FD 2 0
SUB  IYL       95 FD 2 0
SUB  L         95    1 0
SUB  *         D6    2 0
   
XOR  (HL)      AE    1 0
XOR  (IX*)     AE DD 3 1
XOR  (IY*)     AE FD 3 1
XOR  A         AF    1 0
XOR  B         A8    1 0
XOR  C         A9    1 0
XOR  D         AA    1 0
XOR  E         AB    1 0
XOR  H         AC    1 0
XOR  IXH       AC DD 2 0
XOR  IXL       AD DD 2 0
XOR  IYH       AC FD 2 0
XOR  IYL       AD FD 2 0
XOR  L         AD    1 0
XOR  *         EE    2 0