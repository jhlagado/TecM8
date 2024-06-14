# Classic 8-bit instructions

| instruction | x   | y   | z   | data | index |
| ----------- | --- | --- | --- | ---- | ----- |
| LD r1,r2    | 1   | rc1 | rc2 |      | \*    |
| INC r       | 0   | rc  | 4   |      | \*    |
| DEC r       | 0   | rc  | 5   |      | \*    |
| LD r,expr   | 0   | rc  | 6   | n    | \*    |
| alu A,r     | 1   | alu | rc  |      | \*    |
| OUT nn      | 3   | 2   | 3   | n    | \*    |
| IN nn       | 3   | 3   | 3   | n    | \*    |

Notes:

enum: alu
0: ADD A, 1: ADC A, 2: SUB 3: SBC A, 4: AND 5: XOR 6: OR 7: CP

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

| instruction | x   | y   | z   |
| ----------- | --- | --- | --- |
| RST n       | 3   | n/8 | 7   |

# Z80 I/O instructions

| instruction | prefix | x   | y   | z   |
| ----------- | ------ | --- | --- | --- |
| IN r#,(C)   | ED     | 1   | rc  | 0   |
| OUT (C),r#  | ED     | 1   | rc  | 1   |

# Z80 8-bit shift and bit instructions

| instruction | prefix | x   | y   | z   | index |
| ----------- | ------ | --- | --- | --- | ----- |
| rot r       | CB     | 0   | rot | rc  | \*    |
| BIT n,r     | CB     | 1   | b   | rc  | \*    |
| RES n,r     | CB     | 2   | b   | rc  | \*    |
| SET n,r     | CB     | 3   | b   | rc  | \*    |

Notes:

- enum rot 0: RLC 1: RRC 2: RL 3: RR 4: SLA 5: SRA 6: SLL 7: SRL
- to use (IX+dd) to address memory, generate DD CB dd gc(r=(HL))
- to use (IY+dd) to address memory, generate FD CB dd gc(r=(HL))

# Z80 16-bit operations

| instruction  | prefix | x   | p   | q   | z   | data | index |
| ------------ | ------ | --- | --- | --- | --- | ---- | ----- |
| LD rp,expr   |        | 0   | rpc | 0   | 1   | nn   | \*    |
| ADD HL,rp    |        | 0   | rpc | 1   | 1   |      | \*    |
| INC rp       |        | 0   | rpc | 0   | 3   |      | \*    |
| DEC rp       |        | 0   | rpc | 1   | 3   |      | \*    |
| PUSH rp#     |        | 3   | rpc | 0   | 5   |      | \*    |
| POP rp#      |        | 3   | rpc | 0   | 1   |      | \*    |
| SBC HL,rp    | ED     | 1   | rc  | 0   | 2   |      | \*    |
| ADC HL,rp    | ED     | 1   | rc  | 1   | 2   |      | \*    |
| LD (expr),rp | ED     | 1   | rpc | 1   | 3   | nn   | \*    |
| LD rp,(expr) | ED     | 1   | rpc | 1   | 3   | nn   | \*    |

- to use IX, generate DD gc(r=(HL))
- to use IY, generate FD gc(r=(HL))

# Branching

| instruction | x   | y    | z   | data |
| ----------- | --- | ---- | --- | ---- |
| RET f       | 3   | fc   | 0   |      |
| JP f,expr   | 3   | fc   | 2   | nn   |
| CALL f,expr | 3   | fc   | 4   | nn   |
| JR f#,expr  | 0   | fc+4 | 0   | n    |

# Special handling with 8-bit data

| instruction  | gc  | data |
| ------------ | --- | ---- |
| OUT (expr),A | D3  | n    |
| IN A,(expr)  | DB  | n    |
| DJNZ expr    | 10  | n    |
| JR expr      | 18  | n    |

# Special handling with 16-bit data

| instruction  | gc  | data | index |
| ------------ | --- | ---- | ----- |
| LD (expr),HL | 22  | nn   | \*    |
| LD HL,(expr) | 2A  | nn   | \*    |
| LD (expr),A  | 32  | nn   |       |
| LD A,(expr)  | 3A  | nn   |       |
| JP expr      | C3  | nn   |       |
| CALL expr    | CD  | nn   |       |

# Special handling

| instruction | gc    | index |
| ----------- | ----- | ----- |
| JP (HL)     | E9    | \*    |
| LD SP,HL    | F9    | \*    |
| EX (SP),HL  | E3    | \*    |
| RET         | C9    |       |
| EX AF,AF'   | 08    |       |
| EX DE,HL    | EB    |       |
| LD (BC),A   | 02    |       |
| LD (DE),A   | 12    |       |
| LD A,(BC)   | 0A    |       |
| LD A,(DE)   | 1A    |       |
| LD I,A      | ED 47 |       |
| LD R,A      | ED 4F |       |
| LD A,I      | ED 57 |       |
| LD A,R      | ED 5F |       |
| IM 0        | ED 46 |       |
| IM 1        | ED 56 |       |
| IM 2        | ED 5E |       |

# Synthetic

| instruction | gc    |
| ----------- | ----- |
| LD DE,BC    | 59 50 |
| LD HL,BC    | 69 60 |
| LD BC,DE    | 4B 42 |
| LD HL,DE    | 6B 62 |
| LD BC,HL    | 4D 44 |
| LD DE,HL    | 5D 54 |

# Unsorted 1

| instruction | gc    |
| ----------- | ----- |
| NOP         | 00    |
| RLCA        | 07    |
| DAA         | 27    |
| CPL         | 2F    |
| SCF         | 37    |
| CCF         | 3F    |
| HALT        | 76    |
| DI          | F3    |
| EI          | FB    |
| RRCA        | ED 0F |
| RLA         | ED 17 |
| RRA         | ED 1F |
| NEG         | ED 44 |
| RETN        | ED 45 |
| RETI        | ED 4D |
| RRD         | ED 67 |
| RLD         | ED 6F |
| RET         | ED C9 |
| EXX         | ED D9 |
| LDI         | ED A0 |
| CPI         | ED A1 |
| INI         | ED A2 |
| OUTI        | ED A3 |
| LDD         | ED A8 |
| CPD         | ED A9 |
| IND         | ED AA |
| OUTD        | ED AB |
| LDIR        | ED B0 |
| CPIR        | ED B1 |
| INIR        | ED B2 |
| OTIR        | ED B3 |
| LDDR        | ED B8 |
| CPDR        | ED B9 |
| INDR        | ED BA |
| OTDR        | ED BB |

---

# Appendix

- expr: expression
- n: a numeric expression

- nn: 8-bit data
- nn nn: 16-bit data
- dd: 8-bit displacement

# Bit naming in opcode

7 6 5 4 3 2 1 0
x x y y y z z z
p p q
a a b b

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

| rp$ | rpc |
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
