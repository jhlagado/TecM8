# 8-bit register mapping

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
| (IXexpr) | 8   |
| (IYexpr) | 9   |
| (BC)     | 10  |
| (DE)     | 11  |
| I        | 12  |
| R        | 13  |

Notes:

- r - any "register" in r$ except (IX*),(IY*),(BC),(DE)
- r# - any "register" in r$ except (HL),(IX*),(IY*),(BC),(DE)
- r% - only (BC),(DE)
- r! - only I,R

# 16-bit register mapping

| rp$ | rc  |
| --- | --- |
| BC  | 0   |
| DE  | 1   |
| HL  | 2   |
| SP  | 3   |
| AF  | 3   |
| AF' | 4   |

Notes:

- rp - any register pair in rp$ except AF'
- rp# - any register pair in rp$ except HL,AF'

# Flags

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

- f# - any flaf except PO,PE,P,M

- expr: expression
- n: a numeric expression

- nn: 8-bit data
- nn nn: 16-bit data
- dd: 8-bit displacement

# Classic 8-bit instructions

| instruction | generated (gc)          |
| ----------- | ----------------------- |
| ADC A,r     | 88 \| rc                |
| ADD A,r     | 80 \| rc                |
| AND r       | A0 \| rc                |
| CP r        | 88 \| rc                |
| DEC r       | 05 \| (rc << 3)         |
| INC r       | 04 \| (rc << 3)         |
| LD r1,r2    | 40 \| (rc1 << 3) \| rc2 |
| XOR r       | A8 \| rc                |
| RL r        | 10 \| rc                |
| SBC A,r     | 98 \| rc                |
| SUB r       | 90 \| rc                |
| OR r        | B0 \| rc                |

Notes:

- to use (IX+dd) to address memory, generate DD gc(r=(HL)) dd
- to use (IY+dd) to address memory, generate FD gc(r=(HL)) dd
- to use IXH, generate DD gc(r=H)
- to use IXL, generate DD gc(r=L)
- to use IYH, generate FD gc(r=H)
- to use IYL, generate FD gc(r=L)
- r1 and r2 cannot both address memory like (HL),(IX+dd),(IY+dd)

# Classic 8-bit load immediate instructions

| instruction  | generated (gc) |
| ------------ | -------------- |
| LD r,expr    | 70 \| rc nn    |
| LD (HL),expr | 36 nn          |

Notes:

- to use (IX+dd) to address memory, generate DD gc(r=(HL)) dd nn
- to use (IY+dd) to address memory, generate FD gc(r=(HL)) dd nn

# Restart instructions

| instruction | generated (gc)  | notes                 |
| ----------- | --------------- | --------------------- |
| RST n       | C7 \| (rc << 1) | n is an enum (n += 8) |

# I/O instructions

| instruction | generated (gc)     |
| ----------- | ------------------ |
| IN r#,(C)   | ED 40 \| (rc << 3) |
| OUT (C),r#  | ED 41 \| (rc << 3) |

# Z80 8-bit shift and bit instructions

| instruction | generated (gc)         |
| ----------- | ---------------------- |
| RLC r       | CB 00 \|rc             |
| RRC r       | CB 08 \|rc             |
| RR r        | CB 18 \|rc             |
| SLA r       | CB 20 \|rc             |
| SRA r       | CB 28 \|rc             |
| SRL r       | CB 38 \|rc             |
| BIT n,r     | CB 40 \| (b << 3)\| rc |
| RES n,r     | CB 80 \| (b << 3)\| rc |
| SET n,r     | CB C0 \| (b << 3)\| rc |

Notes:

- to use (IX+dd) to address memory, generate DD CB dd gc(r=(HL))
- to use (IY+dd) to address memory, generate FD CB dd gc(r=(HL))

# Z80 16-bit operations

| instruction | generated (gc)  |
| ----------- | --------------- |
| ADC HL,rp   | 4A \| (rc << 4) |
| SBC HL,rp   | 42 \| (rc << 4) |

| instruction   | generated (gc)        |
| ------------- | --------------------- |
| LD rp,expr    | 01 \| (rc << 4) nn nn |
| INC rp        | 03 \| (rc << 4)       |
| ADD HL,rp     | 09 \| (rc << 4)       |
| DEC rp        | 0B \| (rc << 4)       |
| PUSH rp       | C5 \| (rc << 4)       |
| POP rp        | C1 \| (rc << 4)       |
| LD (expr),rp# | ED 43 nn nn           |
| LD rp#,(expr) | ED 4B nn nn           |

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
| RET f         | C0 \| (fc<<3)       |
| CALL f,(expr) | C4 \| (fc<<3) nn nn |
| JP f,(expr)   | C2 \| (fc<<3) nn nn |
| JR f#,(expr)  | 20 \| (fc<<4) nn    |

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

# Unsorted

| instruction | generated (gc) |
| ----------- | -------------- |
| CCF         | 3F             |
| CPD         | ED A9          |
| CPDR        | ED B9          |
| CPI         | ED A1          |
| CPIR        | ED B1          |
| CPL         | 2F             |
| DAA         | 27             |
| DI          | F3             |
| EI          | FB             |
| EXX         | ED D9          |
| HALT        | 76             |
| IND         | ED AA          |
| INDR        | ED BA          |
| INI         | ED A2          |
| INIR        | ED B2          |
| LDD         | ED A8          |
| LDDR        | ED B8          |
| LDI         | ED A0          |
| LDIR        | ED B0          |
| NEG         | ED 44          |
| NOP         | 00             |
| OTDR        | ED BB          |
| OTIR        | ED B3          |
| OUTD        | ED AB          |
| OUTI        | ED A3          |
| RET         | ED C9          |
| RETI        | ED 4D          |
| RETN        | ED 45          |
| RLA         | ED 17          |
| RLCA        | 07             |
| RLD         | ED 6F          |
| RRA         | ED 1F          |
| RRCA        | ED 0F          |
| RRD         | ED 67          |
| SCF         | 37             |