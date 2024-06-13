# Classic 8-bit instructions

| instruction | generated (gc)          |
| ----------- | ----------------------- |
| LD r1,r2    | x=1 y=rc1 z=rc2         |
| INC r       | x=0 y=rc z=4            |
| DEC r       | x=0 y=rc z=5            |
| LD r,expr   | x=0 y=rc z=6 nn         |
| alu A,r     | x=1 y=alu z=rc          |
| OUT nn      | x=3 y=2 z=3 nn          |
| IN nn       | x=3 y=3 z=3 nn          |

Notes:

alu is an enum
0: ADD A,	1: ADC A,	2: SUB	3: SBC A,	4: AND	5: XOR	6: OR	7: CP

- to use (IX+dd) to address memory, generate DD gc(r=(HL)) dd
- to use (IY+dd) to address memory, generate FD gc(r=(HL)) dd
- to use IXH, generate DD gc(r=H)
- to use IXL, generate DD gc(r=L)
- to use IYH, generate FD gc(r=H)
- to use IYL, generate FD gc(r=L)
- r1 and r2 cannot both address memory like (HL),(IX+dd),(IY+dd)

Notes:

- to use (IX+dd) to address memory, generate DD gc(r=(HL)) dd nn
- to use (IY+dd) to address memory, generate FD gc(r=(HL)) dd nn

# Restart instructions

| instruction | generated (gc)  |
| ----------- | --------------- |
| RST n       | x=3 y=n/8 z=7   |

# I/O instructions

| instruction | generated (gc)     |
| ----------- | ------------------ |
| IN r#,(C)   | ED 40 \| y=rc      |
| OUT (C),r#  | ED 41 \| y=rc      |

# Z80 8-bit shift and bit instructions

| instruction | generated (gc)         |
| ----------- | ---------------------- |
| rot r       | CB 00 \| x=0 y=rot z=rc |
| BIT n,r     | CB 40 \| x=1 y=b z=rc        |
| RES n,r     | CB 80 \| x=2 y=b z=rc        |
| SET n,r     | CB C0 \| x=3 y=b z=rc        |

Note:

rot is an enum
0: RLC 1: RRC 2: RL 3: RR 4: SLA 5: SRA 6: SLL 7: SRL 

Notes:

- to use (IX+dd) to address memory, generate DD CB dd gc(r=(HL))
- to use (IY+dd) to address memory, generate FD CB dd gc(r=(HL))

# Z80 16-bit operations

| instruction | generated (gc)  |
| ----------- | --------------- |
| ADC HL,rp   | 42 \| q=1 p=rc  |
| SBC HL,rp   | 42 \| q=0 p=rc  |

| instruction   | generated (gc)        |
| ------------- | --------------------- |
| LD rp,expr    | 01 \| (rc << 4) nn nn |
| INC rp        | 03 \| (rc << 4)       |
| ADD HL,rp     | 09 \| (rc << 4)       |
| DEC rp        | 0B \| (rc << 4)       |
| PUSH rp#      | C5 \| (rc << 4)       |
| POP rp#       | C1 \| (rc << 4)       |
| LD (expr),rp  | ED 43 nn nn           |
| LD rp,(expr)  | ED 4B nn nn           |

- to use IX as receiver, generate DD gc(r=(HL))
- to use IY as receiver, generate FD gc(r=(HL))

| instruction  | generated (gc) |
| ------------ | -------------- |
| JP (HL)      | E9             |
| LD SP,HL     | F9             |
| EX (SP),HL   | E3             |
| LD HL,(expr) | 2A nn nn       |
| LD (expr),HL | 22 nn nn       |

- to use IX as receiver, generate DD gc(r=(HL))
- to use IY as receiver, generate FD gc(r=(HL))

# Branching

| instruction   | generated (gc)      |
| ------------- | ------------------- |
| RET f         | C0 \| (fc << 3)       |
| JP f,(expr)   | C2 \| (fc << 3) nn nn |
| CALL f,(expr) | C4 \| (fc << 3) nn nn |
| JR f#,(expr)  | 20 \| (fc << 4) nn    |

# Special handling

| instruction  | generated (gc) |
| ------------ | -------------- |
| IN A,(expr)  | DB nn          |
| OUT (expr),A | D3 nn          |
| LD (expr),A  | 32 nn nn       |
| LD A,(expr)  | 3A nn nn       |

| instruction | generated (gc) | notes      |
| ----------- | -------------- | ---------- |
| CALL expr   | CD nn nn       |            |
| JP expr     | C3 nn nn       |            |
| DJNZ expr   | 10 nn          |            |
| JR expr     | 18 nn          |            |
| EX AF,AF'   | 08             | EX rp,rp   |
| EX DE,HL    | EB             |            |
| LD (BC),A   | 02             | LD r1,r2   |
| LD (DE),A   | 12             |            |
| LD A,(BC)   | 0A             |            |
| LD A,(DE)   | 1A             |            |
| LD I,A      | ED 47          |            |
| LD R,A      | ED 4F          |            |
| LD A,I      | ED 57          |            |
| LD A,R      | ED 5F          |            |
| LD DE,BC    | 59 50          | LD rp1,rp2 |
| LD HL,BC    | 69 60          |            |
| LD BC,DE    | 4B 42          |            |
| LD HL,DE    | 6B 62          |            |
| LD BC,HL    | 4D 44          |            |
| LD DE,HL    | 5D 54          |            |
| IM 0        | ED 46          | IM n       |
| IM 1        | ED 56          |            |
| IM 2        | ED 5E          |            |

# Block

| instruction | generated (gc) |
| ----------- | -------------- |
| LDI         | ED A0          | 
| CPI         | ED A1          |
| INI         | ED A2          |
| OUTI        | ED A3          |
| LDD         | ED A8          |
| CPD         | ED A9          |
| IND         | ED AA          |
| OUTD        | ED AB          |
| LDIR        | ED B0          |
| CPIR        | ED B1          |
| INIR        | ED B2          |
| OTIR        | ED B3          |
| LDDR        | ED B8          |
| CPDR        | ED B9          |
| INDR        | ED BA          |
| OTDR        | ED BB          |

Notes:
- 0:LD 1:CP 2: IN 3: OUT/OT
- 0:I  1:D  2: IR 3: ID

# Unsorted 1

| instruction | generated (gc) |
| ----------- | -------------- |
| NOP         | 00             |
| RLCA        | 07             |
| DAA         | 27             |
| CPL         | 2F             |
| SCF         | 37             |
| CCF         | 3F             |
| HALT        | 76             |
| DI          | F3             |
| EI          | FB             |

# Unsorted 2

| instruction | generated (gc) |
| ----------- | -------------- |
| RRCA        | ED 0F          |
| RLA         | ED 17          |
| RRA         | ED 1F          |
| RRD         | ED 67          |
| RLD         | ED 6F          |
| NEG         | ED 44          |
| RETN        | ED 45          |
| RETI        | ED 4D          |
| RET         | ED C9          |
| EXX         | ED D9          |

---

# Appendix

- expr: expression
- n: a numeric expression

- nn: 8-bit data
- nn nn: 16-bit data
- dd: 8-bit displacement

# Bit naming in opcode

7   6   5   4   3   2   1   0 
x   x   y   y   y   z   z   z
        p   p   q
            a   a       b   b
            
## Register mapping

| r$       | rc  |
| -------- | --- |
| B        | 0   |
| C        | 1   |
| D        | 2   |
| E        | 3   |
| H        | 4   |
| L        | 5   |
| (HL)     | 6   |
| A        | 7   |
| I        | 8   |
| R        | 9   |
| (IXexpr) | 8   |
| (IYexpr) | 9   |
| (BC)     | 10  |
| (DE)     | 11  |

Notes:

- r - except (IX*),(IY*),(BC),(DE),I,R
- r# - except (HL),(IX*),(IY*),(BC),(DE),I,R

## Register pair mapping

| rp$ | rc  |
| --- | --- |
| BC  | 0   |
| DE  | 1   |
| HL  | 2   |
| SP  | 3   |
| AF  | 3   |
| AF' | 4   |

Notes:

- rp - except AF, AF'
- rp# - except SP, AF', the rc for AF is 3 (same as SP)

## Flag mapping

| f   | fc  |
| --- | --- |
| NZ  | 0   |
| Z   | 1   |
| NC  | 2   |
| C   | 3   |
| PO  | 4   |
| PE  | 5   |
| P   | 6   |
| M   | 7   |

Notes:

- f# - except PO,PE,P,M
- need to handle ambiguity between C for carry and the C register 
  in the operand position
