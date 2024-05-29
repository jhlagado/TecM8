### type

0 - regular
1 - index
2 - bit
3 - relative

### Unsorted

| mnemonic | args | opcode | prefix | size | type | or  |
| -------- | ---- | ------ | ------ | ---- | ---- | --- |
| IM0      |      | 46     | ED     | 2    | 0    |     |
| IM1      |      | 56     | ED     | 2    | 0    |     |
| IM2      |      | 5E     | ED     | 2    | 0    |     |
| DI       |      | F3     |        | 1    | 0    |     |
| EI       |      | FB     |        | 1    | 0    |     |
| NEG      |      | 44     | ED     | 2    | 0    |     |
| NOP      |      | 00     |        | 1    | 0    |     |
| SCF      |      | 37     |        | 1    | 0    |     |
| CCF      |      | 3F     |        | 1    | 0    |     |
| CPL      |      | 2F     |        | 1    | 0    |     |
| DAA      |      | 27     |        | 1    | 0    |     |
| HALT     |      | 76     |        | 1    | 0    |     |
| RLCA     |      | 07     |        | 1    | 0    |     |
| RLA      |      | 17     |        | 1    | 0    |     |
| RRA      |      | 1F     |        | 1    | 0    |     |
| RRCA     |      | 0F     |        | 1    | 0    |     |
| RLD      |      | 6F     | ED     | 2    | 0    |     |
| RRD      |      | 67     | ED     | 2    | 0    |     |
| IND      |      | AA     | ED     | 2    | 0    |     |
| INDR     |      | BA     | ED     | 2    | 0    |     |
| INI      |      | A2     | ED     | 2    | 0    |     |
| INIR     |      | B2     | ED     | 2    | 0    |     |
| OUTD     |      | AB     | ED     | 2    | 0    |     |
| OTDR     |      | BB     | ED     | 2    | 0    |     |
| OUTI     |      | A3     | ED     | 2    | 0    |     |
| OTIR     |      | B3     | ED     | 2    | 0    |     |
| LDD      |      | A8     | ED     | 2    | 0    |     |
| LDDR     |      | B8     | ED     | 2    | 0    |     |
| LDI      |      | A0     | ED     | 2    | 0    |     |
| LDIR     |      | B0     | ED     | 2    | 0    |     |
| CPD      |      | A9     | ED     | 2    | 0    |     |
| CPDR     |      | B9     | ED     | 2    | 0    |     |
| CPI      |      | A1     | ED     | 2    | 0    |     |
| CPIR     |      | B1     | ED     | 2    | 0    |     |
| RET      |      | C9     |        | 1    | 0    |     |
| RETI     |      | 4D     | ED     | 2    | 0    |     |
| RETN     |      | 45     | ED     | 2    | 0    |     |
| EXX      |      | D9     |        | 1    | 0    |     |

| mnemonic | args | opcode | prefix | size | type | or  |
| -------- | ---- | ------ | ------ | ---- | ---- | --- |
| CALL     | expr | CD     |        | 3    | 0    |     |
| JP       | expr | C3     |        | 3    | 0    |     |
| DJNZ     | expr | 10     |        | 2    | 3    |     |
| JR       | expr | 18     |        | 2    | 3    |     |

| mnemonic | args   | opcode | prefix | size | type | or  |
| -------- | ------ | ------ | ------ | ---- | ---- | --- |
| EX       | AF,AF' | 08     |        | 1    | 0    |     |
| EX       | DE,HL  | EB     |        | 1    | 0    |     |

| mnemonic | args     | opcode | prefix | size | type | or  |
| -------- | -------- | ------ | ------ | ---- | ---- | --- |
| LD       | (BC),A   | 02     |        | 1    | 0    |     |
| LD       | (DE),A   | 12     |        | 1    | 0    |     |
| LD       | (expr),A | 32     |        | 3    | 0    |     |
| LD       | A,(BC)   | 0A     |        | 1    | 0    |     |
| LD       | A,(DE)   | 1A     |        | 1    | 0    |     |
| LD       | A,(expr) | 3A     |        | 3    | 0    |     |
| LD       | I,A      | 47     | ED     | 2    | 0    |     |
| LD       | R,A      | 4F     | ED     | 2    | 0    |     |
| LD       | A,I      | 57     | ED     | 2    | 0    |     |
| LD       | A,R      | 5F     | ED     | 2    | 0    |     |

### Shorthand instructions

| mnemonic | args  | opcode | prefix | size | type | or  |
| -------- | ----- | ------ | ------ | ---- | ---- | --- |
| LD       | DE,BC | 59     | 50     | 2    | 0    |     |
| LD       | HL,BC | 69     | 60     | 2    | 0    |     |
| LD       | BC,DE | 4B     | 42     | 2    | 0    |     |
| LD       | HL,DE | 6B     | 62     | 2    | 0    |     |
| LD       | BC,HL | 4D     | 44     | 2    | 0    |     |
| LD       | DE,HL | 5D     | 54     | 2    | 0    |     |

| mnemonic | args   | opcode | prefix | size | type | or  |
| -------- | ------ | ------ | ------ | ---- | ---- | --- |
| ADC      | A,B    | 88     |        | 1    | 0    |     |
| ADC      | A,C    | 89     |        | 1    | 0    |     |
| ADC      | A,D    | 8A     |        | 1    | 0    |     |
| ADC      | A,E    | 8B     |        | 1    | 0    |     |
| ADC      | A,H    | 8C     |        | 1    | 0    |     |
| ADC      | A,L    | 8D     |        | 1    | 0    |     |
| ADC      | A,(HL) | 8E     |        | 1    | 0    |     |
| ADC      | A,A    | 8F     |        | 1    | 0    |     |
| ADC      | A,expr | CE     |        | 2    | 0    |     |

| mnemonic | args   | opcode | prefix | size | type | or  |
| -------- | ------ | ------ | ------ | ---- | ---- | --- |
| ADD      | A,B    | 80     |        | 1    | 0    |     |
| ADD      | A,C    | 81     |        | 1    | 0    |     |
| ADD      | A,D    | 82     |        | 1    | 0    |     |
| ADD      | A,E    | 83     |        | 1    | 0    |     |
| ADD      | A,H    | 84     |        | 1    | 0    |     |
| ADD      | A,L    | 85     |        | 1    | 0    |     |
| ADD      | A,(HL) | 86     |        | 1    | 0    |     |
| ADD      | A,A    | 87     |        | 1    | 0    |     |
| ADD      | A,expr | C6     |        | 2    | 0    |     |

| mnemonic | args | opcode | prefix | size | type | or  |
| -------- | ---- | ------ | ------ | ---- | ---- | --- |
| AND      | B    | A0     |        | 1    | 0    |     |
| AND      | C    | A1     |        | 1    | 0    |     |
| AND      | D    | A2     |        | 1    | 0    |     |
| AND      | E    | A3     |        | 1    | 0    |     |
| AND      | H    | A4     |        | 1    | 0    |     |
| AND      | L    | A5     |        | 1    | 0    |     |
| AND      | (HL) | A6     |        | 1    | 0    |     |
| AND      | A    | A7     |        | 1    | 0    |     |
| AND      | expr | E6     |        | 2    | 0    |     |

| mnemonic | args | opcode | prefix | size | type | or  |
| -------- | ---- | ------ | ------ | ---- | ---- | --- |
| CP       | B    | B8     |        | 1    | 0    |     |
| CP       | C    | B9     |        | 1    | 0    |     |
| CP       | D    | BA     |        | 1    | 0    |     |
| CP       | E    | BB     |        | 1    | 0    |     |
| CP       | H    | BC     |        | 1    | 0    |     |
| CP       | L    | BD     |        | 1    | 0    |     |
| CP       | (HL) | BE     |        | 1    | 0    |     |
| CP       | A    | BF     |        | 1    | 0    |     |
| CP       | expr | FE     |        | 2    | 0    |     |

| mnemonic | args | opcode | prefix | size | type | or  |
| -------- | ---- | ------ | ------ | ---- | ---- | --- |
| DEC      | B    | 05     |        | 1    | 0    |     |
| DEC      | C    | 0D     |        | 1    | 0    |     |
| DEC      | D    | 15     |        | 1    | 0    |     |
| DEC      | E    | 1D     |        | 1    | 0    |     |
| DEC      | H    | 25     |        | 1    | 0    |     |
| DEC      | L    | 2D     |        | 1    | 0    |     |
| DEC      | (HL) | 35     |        | 1    | 0    |     |
| DEC      | A    | 3D     |        | 1    | 0    |     |

| mnemonic | args | opcode | prefix | size | type | or  |
| -------- | ---- | ------ | ------ | ---- | ---- | --- |
| INC      | B    | 04     |        | 1    | 0    |     |
| INC      | C    | 0C     |        | 1    | 0    |     |
| INC      | D    | 14     |        | 1    | 0    |     |
| INC      | E    | 1C     |        | 1    | 0    |     |
| INC      | H    | 24     |        | 1    | 0    |     |
| INC      | L    | 2C     |        | 1    | 0    |     |
| INC      | (HL) | 34     |        | 1    | 0    |     |
| INC      | A    | 3C     |        | 1    | 0    |     |

| mnemonic | args  | opcode | prefix | size | type | or  |
| -------- | ----- | ------ | ------ | ---- | ---- | --- |
| IN       | B,(C) | 40     | ED     | 2    | 0    |     |
| IN       | C,(C) | 48     | ED     | 2    | 0    |     |
| IN       | D,(C) | 50     | ED     | 2    | 0    |     |
| IN       | E,(C) | 58     | ED     | 2    | 0    |     |
| IN       | F,(C) | 70     | ED     | 2    | 0    |     |
| IN       | H,(C) | 60     | ED     | 2    | 0    |     |
| IN       | L,(C) | 68     | ED     | 2    | 0    |     |
| IN       | A,(C) | 78     | ED     | 2    | 0    |     |

| mnemonic | args      | opcode | prefix | size | type | or  |
| -------- | --------- | ------ | ------ | ---- | ---- | --- |
| LD       | (HL),B    | 70     |        | 1    | 0    |     |
| LD       | (HL),C    | 71     |        | 1    | 0    |     |
| LD       | (HL),D    | 72     |        | 1    | 0    |     |
| LD       | (HL),E    | 73     |        | 1    | 0    |     |
| LD       | (HL),H    | 74     |        | 1    | 0    |     |
| LD       | (HL),L    | 75     |        | 1    | 0    |     |
| LD       | (HL),A    | 77     |        | 1    | 0    |     |
| LD       | (HL),expr | 36     |        | 2    | 0    |     |

| mnemonic | args   | opcode | prefix | size | type | or  |
| -------- | ------ | ------ | ------ | ---- | ---- | --- |
| LD       | A,B    | 78     |        | 1    | 0    |     |
| LD       | A,C    | 79     |        | 1    | 0    |     |
| LD       | A,D    | 7A     |        | 1    | 0    |     |
| LD       | A,E    | 7B     |        | 1    | 0    |     |
| LD       | A,H    | 7C     |        | 1    | 0    |     |
| LD       | A,L    | 7D     |        | 1    | 0    |     |
| LD       | A,(HL) | 7E     |        | 1    | 0    |     |
| LD       | A,A    | 7F     |        | 1    | 0    |     |
| LD       | A,expr | 3E     |        | 2    | 0    |     |

| mnemonic | args   | opcode | prefix | size | type | or  |
| -------- | ------ | ------ | ------ | ---- | ---- | --- |
| LD       | B,B    | 40     |        | 1    | 0    |     |
| LD       | B,C    | 41     |        | 1    | 0    |     |
| LD       | B,D    | 42     |        | 1    | 0    |     |
| LD       | B,E    | 43     |        | 1    | 0    |     |
| LD       | B,H    | 44     |        | 1    | 0    |     |
| LD       | B,L    | 45     |        | 1    | 0    |     |
| LD       | B,(HL) | 46     |        | 1    | 0    |     |
| LD       | B,A    | 47     |        | 1    | 0    |     |
| LD       | B,expr | 06     |        | 2    | 0    |     |

| mnemonic | args   | opcode | prefix | size | type | or  |
| -------- | ------ | ------ | ------ | ---- | ---- | --- |
| LD       | C,B    | 48     |        | 1    | 0    |     |
| LD       | C,C    | 49     |        | 1    | 0    |     |
| LD       | C,D    | 4A     |        | 1    | 0    |     |
| LD       | C,E    | 4B     |        | 1    | 0    |     |
| LD       | C,H    | 4C     |        | 1    | 0    |     |
| LD       | C,L    | 4D     |        | 1    | 0    |     |
| LD       | C,(HL) | 4E     |        | 1    | 0    |     |
| LD       | C,A    | 4F     |        | 1    | 0    |     |
| LD       | C,expr | 0E     |        | 2    | 0    |     |

| mnemonic | args   | opcode | prefix | size | type | or  |
| -------- | ------ | ------ | ------ | ---- | ---- | --- |
| LD       | D,B    | 50     |        | 1    | 0    |     |
| LD       | D,C    | 51     |        | 1    | 0    |     |
| LD       | D,D    | 52     |        | 1    | 0    |     |
| LD       | D,E    | 53     |        | 1    | 0    |     |
| LD       | D,H    | 54     |        | 1    | 0    |     |
| LD       | D,L    | 55     |        | 1    | 0    |     |
| LD       | D,(HL) | 56     |        | 1    | 0    |     |
| LD       | D,A    | 57     |        | 1    | 0    |     |
| LD       | D,expr | 16     |        | 2    | 0    |     |

| mnemonic | args   | opcode | prefix | size | type | or  |
| -------- | ------ | ------ | ------ | ---- | ---- | --- |
| LD       | E,B    | 58     |        | 1    | 0    |     |
| LD       | E,C    | 59     |        | 1    | 0    |     |
| LD       | E,D    | 5A     |        | 1    | 0    |     |
| LD       | E,E    | 5B     |        | 1    | 0    |     |
| LD       | E,H    | 5C     |        | 1    | 0    |     |
| LD       | E,L    | 5D     |        | 1    | 0    |     |
| LD       | E,(HL) | 5E     |        | 1    | 0    |     |
| LD       | E,A    | 5F     |        | 1    | 0    |     |
| LD       | E,expr | 1E     |        | 2    | 0    |     |

| mnemonic | args   | opcode | prefix | size | type | or  |
| -------- | ------ | ------ | ------ | ---- | ---- | --- |
| LD       | H,B    | 60     |        | 1    | 0    |     |
| LD       | H,C    | 61     |        | 1    | 0    |     |
| LD       | H,D    | 62     |        | 1    | 0    |     |
| LD       | H,E    | 63     |        | 1    | 0    |     |
| LD       | H,H    | 64     |        | 1    | 0    |     |
| LD       | H,L    | 65     |        | 1    | 0    |     |
| LD       | H,(HL) | 66     |        | 1    | 0    |     |
| LD       | H,A    | 67     |        | 1    | 0    |     |
| LD       | H,expr | 26     |        | 2    | 0    |     |

| mnemonic | args   | opcode | prefix | size | type | or  |
| -------- | ------ | ------ | ------ | ---- | ---- | --- |
| LD       | L,B    | 68     |        | 1    | 0    |     |
| LD       | L,C    | 69     |        | 1    | 0    |     |
| LD       | L,D    | 6A     |        | 1    | 0    |     |
| LD       | L,E    | 6B     |        | 1    | 0    |     |
| LD       | L,H    | 6C     |        | 1    | 0    |     |
| LD       | L,L    | 6D     |        | 1    | 0    |     |
| LD       | L,(HL) | 6E     |        | 1    | 0    |     |
| LD       | L,A    | 6F     |        | 1    | 0    |     |
| LD       | L,expr | 2E     |        | 2    | 0    |     |

| mnemonic | args | opcode | prefix | size | type | or  |
| -------- | ---- | ------ | ------ | ---- | ---- | --- |
| RL       | B    | 10     | CB     | 2    | 0    |     |
| RL       | C    | 11     | CB     | 2    | 0    |     |
| RL       | D    | 12     | CB     | 2    | 0    |     |
| RL       | E    | 13     | CB     | 2    | 0    |     |
| RL       | H    | 14     | CB     | 2    | 0    |     |
| RL       | L    | 15     | CB     | 2    | 0    |     |
| RL       | (HL) | 16     | CB     | 2    | 0    |     |
| RL       | A    | 17     | CB     | 2    | 0    |     |

| mnemonic | args   | opcode | prefix | size | type | or  |
| -------- | ------ | ------ | ------ | ---- | ---- | --- |
| SBC      | A,B    | 98     |        | 1    | 0    |     |
| SBC      | A,C    | 99     |        | 1    | 0    |     |
| SBC      | A,D    | 9A     |        | 1    | 0    |     |
| SBC      | A,E    | 9B     |        | 1    | 0    |     |
| SBC      | A,H    | 9C     |        | 1    | 0    |     |
| SBC      | A,L    | 9D     |        | 1    | 0    |     |
| SBC      | A,(HL) | 9E     |        | 1    | 0    |     |
| SBC      | A,A    | 9F     |        | 1    | 0    |     |
| SBC      | A,expr | DE     |        | 2    | 0    |     |

| mnemonic | args | opcode | prefix | size | type | or  |
| -------- | ---- | ------ | ------ | ---- | ---- | --- |
| SUB      | B    | 90     |        | 1    | 0    |     |
| SUB      | C    | 91     |        | 1    | 0    |     |
| SUB      | D    | 92     |        | 1    | 0    |     |
| SUB      | E    | 93     |        | 1    | 0    |     |
| SUB      | H    | 94     |        | 1    | 0    |     |
| SUB      | L    | 95     |        | 1    | 0    |     |
| SUB      | (HL) | 96     |        | 1    | 0    |     |
| SUB      | A    | 97     |        | 1    | 0    |     |
| SUB      | expr | D6     |        | 2    | 0    |     |

| mnemonic | args | opcode | prefix | size | type | or  |
| -------- | ---- | ------ | ------ | ---- | ---- | --- |
| OR       | B    | B0     |        | 1    | 0    |     |
| OR       | C    | B1     |        | 1    | 0    |     |
| OR       | D    | B2     |        | 1    | 0    |     |
| OR       | E    | B3     |        | 1    | 0    |     |
| OR       | H    | B4     |        | 1    | 0    |     |
| OR       | L    | B5     |        | 1    | 0    |     |
| OR       | (HL) | B6     |        | 1    | 0    |     |
| OR       | A    | B7     |        | 1    | 0    |     |
| OR       | expr | F6     |        | 2    | 0    |     |

| mnemonic | args  | opcode | prefix | size | type | or  |
| -------- | ----- | ------ | ------ | ---- | ---- | --- |
| OUT      | (C),B | 41     | ED     | 2    | 0    |     |
| OUT      | (C),C | 49     | ED     | 2    | 0    |     |
| OUT      | (C),D | 51     | ED     | 2    | 0    |     |
| OUT      | (C),E | 59     | ED     | 2    | 0    |     |
| OUT      | (C),F | 71     | ED     | 2    | 0    |     |
| OUT      | (C),0 | 71     | ED     | 2    | 0    |     |
| OUT      | (C),H | 61     | ED     | 2    | 0    |     |
| OUT      | (C),L | 69     | ED     | 2    | 0    |     |
| OUT      | (C),A | 79     | ED     | 2    | 0    |     |

| mnemonic | args | opcode | prefix | size | type | or  |
| -------- | ---- | ------ | ------ | ---- | ---- | --- |
| SLA      | B    | 20     | CB     | 2    | 0    |     |
| SLA      | C    | 21     | CB     | 2    | 0    |     |
| SLA      | D    | 22     | CB     | 2    | 0    |     |
| SLA      | E    | 23     | CB     | 2    | 0    |     |
| SLA      | H    | 24     | CB     | 2    | 0    |     |
| SLA      | L    | 25     | CB     | 2    | 0    |     |
| SLA      | (HL) | 26     | CB     | 2    | 0    |     |
| SLA      | A    | 27     | CB     | 2    | 0    |     |

| mnemonic | args | opcode | prefix | size | type | or  |
| -------- | ---- | ------ | ------ | ---- | ---- | --- |
| SRA      | B    | 28     | CB     | 2    | 0    |     |
| SRA      | C    | 29     | CB     | 2    | 0    |     |
| SRA      | D    | 2A     | CB     | 2    | 0    |     |
| SRA      | E    | 2B     | CB     | 2    | 0    |     |
| SRA      | H    | 2C     | CB     | 2    | 0    |     |
| SRA      | L    | 2D     | CB     | 2    | 0    |     |
| SRA      | (HL) | 2E     | CB     | 2    | 0    |     |
| SRA      | A    | 2F     | CB     | 2    | 0    |     |

| mnemonic | args | opcode | prefix | size | type | or  |
| -------- | ---- | ------ | ------ | ---- | ---- | --- |
| SRL      | B    | 38     | CB     | 2    | 0    |     |
| SRL      | C    | 39     | CB     | 2    | 0    |     |
| SRL      | D    | 3A     | CB     | 2    | 0    |     |
| SRL      | E    | 3B     | CB     | 2    | 0    |     |
| SRL      | H    | 3C     | CB     | 2    | 0    |     |
| SRL      | L    | 3D     | CB     | 2    | 0    |     |
| SRL      | (HL) | 3E     | CB     | 2    | 0    |     |
| SRL      | A    | 3F     | CB     | 2    | 0    |     |

| mnemonic | args      | opcode | prefix | size | type | or  |
| -------- | --------- | ------ | ------ | ---- | ---- | --- |
| BIT      | expr,B    | 40     | CB     | 2    | 2    |     |
| BIT      | expr,C    | 41     | CB     | 2    | 2    |     |
| BIT      | expr,D    | 42     | CB     | 2    | 2    |     |
| BIT      | expr,E    | 43     | CB     | 2    | 2    |     |
| BIT      | expr,H    | 44     | CB     | 2    | 2    |     |
| BIT      | expr,L    | 45     | CB     | 2    | 2    |     |
| BIT      | expr,(HL) | 46     | CB     | 2    | 2    |     |
| BIT      | expr,A    | 47     | CB     | 2    | 2    |     |

| mnemonic | args   | opcode | prefix | size | type | or  |
| -------- | ------ | ------ | ------ | ---- | ---- | --- |
| SET      | expr,B | C0     | CB     | 2    | 2    |     |
| SET      | expr,C | C1     | CB     | 2    | 2    |     |
| SET      | expr,D | C2     | CB     | 2    | 2    |     |
| SET      | expr,E | C3     | CB     | 2    | 2    |     |
| SET      | expr,H | C4     | CB     | 2    | 2    |     |
| SET      | expr,L | C5     | CB     | 2    | 2    |     |
| SET      | expr,A | C7     | CB     | 2    | 2    |     |

| mnemonic | args      | opcode | prefix | size | type | or  |
| -------- | --------- | ------ | ------ | ---- | ---- | --- |
| RES      | expr,B    | 80     | CB     | 2    | 2    |     |
| RES      | expr,C    | 81     | CB     | 2    | 2    |     |
| RES      | expr,D    | 82     | CB     | 2    | 2    |     |
| RES      | expr,E    | 83     | CB     | 2    | 2    |     |
| RES      | expr,H    | 84     | CB     | 2    | 2    |     |
| RES      | expr,L    | 85     | CB     | 2    | 2    |     |
| RES      | expr,(HL) | 86     | CB     | 2    | 2    |     |
| RES      | expr,A    | 87     | CB     | 2    | 2    |     |

| mnemonic | args | opcode | prefix | size | type | or  |
| -------- | ---- | ------ | ------ | ---- | ---- | --- |
| RLC      | B    | 00     | CB     | 2    | 0    |     |
| RLC      | C    | 01     | CB     | 2    | 0    |     |
| RLC      | D    | 02     | CB     | 2    | 0    |     |
| RLC      | E    | 03     | CB     | 2    | 0    |     |
| RLC      | H    | 04     | CB     | 2    | 0    |     |
| RLC      | L    | 05     | CB     | 2    | 0    |     |
| RLC      | (HL) | 06     | CB     | 2    | 0    |     |
| RLC      | A    | 07     | CB     | 2    | 0    |     |

| mnemonic | args | opcode | prefix | size | type | or  |
| -------- | ---- | ------ | ------ | ---- | ---- | --- |
| RR       | B    | 18     | CB     | 2    | 0    |     |
| RR       | C    | 19     | CB     | 2    | 0    |     |
| RR       | D    | 1A     | CB     | 2    | 0    |     |
| RR       | E    | 1B     | CB     | 2    | 0    |     |
| RR       | H    | 1C     | CB     | 2    | 0    |     |
| RR       | L    | 1D     | CB     | 2    | 0    |     |
| RR       | (HL) | 1E     | CB     | 2    | 0    |     |
| RR       | A    | 1F     | CB     | 2    | 0    |     |

| mnemonic | args | opcode | prefix | size | type | or  |
| -------- | ---- | ------ | ------ | ---- | ---- | --- |
| RRC      | B    | 08     | CB     | 2    | 0    |     |
| RRC      | C    | 09     | CB     | 2    | 0    |     |
| RRC      | D    | 0A     | CB     | 2    | 0    |     |
| RRC      | E    | 0B     | CB     | 2    | 0    |     |
| RRC      | H    | 0C     | CB     | 2    | 0    |     |
| RRC      | L    | 0D     | CB     | 2    | 0    |     |
| RRC      | (HL) | 0E     | CB     | 2    | 0    |
| RRC      | A    | 0F     | CB     | 2    | 0    |     |

| mnemonic | args | opcode | prefix | size | type | or  |
| -------- | ---- | ------ | ------ | ---- | ---- | --- |
| XOR      | B    | A8     |        | 1    | 0    |     |
| XOR      | C    | A9     |        | 1    | 0    |     |
| XOR      | D    | AA     |        | 1    | 0    |     |
| XOR      | E    | AB     |        | 1    | 0    |     |
| XOR      | H    | AC     |        | 1    | 0    |     |
| XOR      | L    | AD     |        | 1    | 0    |     |
| XOR      | (HL) | AE     |        | 1    | 0    |     |
| XOR      | A    | AF     |        | 1    | 0    |     |
| XOR      | expr | EE     |        | 2    | 0    |     |

| mnemonic | args       | opcode | prefix | size | type | or  |
| -------- | ---------- | ------ | ------ | ---- | ---- | --- |
| ADC      | A,(IXexpr) | 8E     | DD     | 3    | 1    |     |
| ADC      | A,(IYexpr) | 8E     | FD     | 3    | 1    |     |
| ADC      | A,IXH      | 8C     | DD     | 2    | 0    |     |
| ADC      | A,IYH      | 8C     | FD     | 2    | 0    |     |
| ADC      | A,IXL      | 8D     | DD     | 2    | 0    |     |
| ADC      | A,IYL      | 8D     | FD     | 2    | 0    |     |

| mnemonic | args       | opcode | prefix | size | type | or  |
| -------- | ---------- | ------ | ------ | ---- | ---- | --- |
| ADD      | A,(IXexpr) | 86     | DD     | 3    | 1    |     |
| ADD      | A,(IYexpr) | 86     | FD     | 3    | 1    |     |
| ADD      | A,IXH      | 84     | DD     | 2    | 0    |     |
| ADD      | A,IYH      | 84     | FD     | 2    | 0    |     |
| ADD      | A,IXL      | 85     | DD     | 2    | 0    |     |
| ADD      | A,IYL      | 85     | FD     | 2    | 0    |     |

| mnemonic | args     | opcode | prefix | size | type | or  |
| -------- | -------- | ------ | ------ | ---- | ---- | --- |
| AND      | (IXexpr) | A6     | DD     | 3    | 1    |     |
| AND      | (IYexpr) | A6     | FD     | 3    | 1    |     |
| AND      | IXH      | A4     | DD     | 2    | 0    |     |
| AND      | IYH      | A4     | FD     | 2    | 0    |     |
| AND      | IXL      | A5     | DD     | 2    | 0    |     |
| AND      | IYL      | A5     | FD     | 2    | 0    |     |

| mnemonic | args          | opcode | prefix | size | type | or  |
| -------- | ------------- | ------ | ------ | ---- | ---- | --- |
| BIT      | expr,(IXexpr) | CB     | DD     | 4    | 2    | 46  |
| BIT      | expr,(IYexpr) | CB     | FD     | 4    | 2    | 46  |

| mnemonic | args     | opcode | prefix | size | type | or  |
| -------- | -------- | ------ | ------ | ---- | ---- | --- |
| CP       | (IXexpr) | BE     | DD     | 3    | 1    |     |
| CP       | (IYexpr) | BE     | FD     | 3    | 1    |     |
| CP       | IXH      | BC     | DD     | 2    | 0    |     |
| CP       | IYH      | BC     | FD     | 2    | 0    |     |
| CP       | IXL      | BD     | DD     | 2    | 0    |     |
| CP       | IYL      | BD     | FD     | 2    | 0    |     |

| mnemonic | args     | opcode | prefix | size | type | or  |
| -------- | -------- | ------ | ------ | ---- | ---- | --- |
| DEC      | (IXexpr) | 35     | DD     | 3    | 1    |     |
| DEC      | (IYexpr) | 35     | FD     | 3    | 1    |     |
| DEC      | IXH      | 25     | DD     | 2    | 0    |     |
| DEC      | IYH      | 24     | FD     | 2    | 0    |     |
| DEC      | IXL      | 2D     | DD     | 2    | 0    |     |
| DEC      | IYL      | 2D     | FD     | 2    | 0    |     |

| mnemonic | args     | opcode | prefix | size | type | or  |
| -------- | -------- | ------ | ------ | ---- | ---- | --- |
| INC      | (IXexpr) | 34     | DD     | 3    | 1    |     |
| INC      | (IYexpr) | 34     | FD     | 3    | 1    |     |
| INC      | IXH      | 24     | DD     | 2    | 0    |     |
| INC      | IYH      | 24     | FD     | 2    | 0    |     |
| INC      | IXL      | 2C     | DD     | 2    | 0    |     |
| INC      | IYL      | 2C     | FD     | 2    | 0    |     |

| mnemonic | args          | opcode | prefix | size | type | or  |
| -------- | ------------- | ------ | ------ | ---- | ---- | --- |
| LD       | (IXexpr),A    | 77     | DD     | 3    | 1    |     |
| LD       | (IXexpr),B    | 70     | DD     | 3    | 1    |     |
| LD       | (IXexpr),C    | 71     | DD     | 3    | 1    |     |
| LD       | (IXexpr),D    | 72     | DD     | 3    | 1    |     |
| LD       | (IXexpr),E    | 73     | DD     | 3    | 1    |     |
| LD       | (IXexpr),H    | 74     | DD     | 3    | 1    |     |
| LD       | (IXexpr),L    | 75     | DD     | 3    | 1    |     |
| LD       | (IXexpr),expr | 36     | DD     | 4    | 1    |     |

| mnemonic | args          | opcode | prefix | size | type | or  |
| -------- | ------------- | ------ | ------ | ---- | ---- | --- |
| LD       | (IYexpr),A    | 77     | FD     | 3    | 1    |     |
| LD       | (IYexpr),B    | 70     | FD     | 3    | 1    |     |
| LD       | (IYexpr),C    | 71     | FD     | 3    | 1    |     |
| LD       | (IYexpr),D    | 72     | FD     | 3    | 1    |     |
| LD       | (IYexpr),E    | 73     | FD     | 3    | 1    |     |
| LD       | (IYexpr),H    | 74     | FD     | 3    | 1    |     |
| LD       | (IYexpr),L    | 75     | FD     | 3    | 1    |     |
| LD       | (IYexpr),expr | 36     | FD     | 4    | 1    |     |

| mnemonic | args       | opcode | prefix | size | type | or  |
| -------- | ---------- | ------ | ------ | ---- | ---- | --- |
| LD       | A,(IXexpr) | 7E     | DD     | 3    | 1    |     |
| LD       | A,(IYexpr) | 7E     | FD     | 3    | 1    |     |
| LD       | A,IXH      | 7C     | DD     | 2    | 0    |     |
| LD       | A,IYH      | 7C     | FD     | 2    | 0    |     |
| LD       | A,IXL      | 7D     | DD     | 2    | 0    |     |
| LD       | A,IYL      | 7D     | FD     | 2    | 0    |     |

| mnemonic | args       | opcode | prefix | size | type | or  |
| -------- | ---------- | ------ | ------ | ---- | ---- | --- |
| LD       | B,(IXexpr) | 46     | DD     | 3    | 1    |     |
| LD       | B,(IYexpr) | 46     | FD     | 3    | 1    |     |
| LD       | B,IXH      | 44     | DD     | 2    | 0    |     |
| LD       | B,IYH      | 44     | FD     | 2    | 0    |     |
| LD       | B,IXL      | 45     | DD     | 2    | 0    |     |
| LD       | B,IYL      | 45     | FD     | 2    | 0    |     |

| mnemonic | args       | opcode | prefix | size | type | or  |
| -------- | ---------- | ------ | ------ | ---- | ---- | --- |
| LD       | C,(IXexpr) | 4E     | DD     | 3    | 1    |     |
| LD       | C,(IYexpr) | 4E     | FD     | 3    | 1    |     |
| LD       | C,IXH      | 4C     | DD     | 2    | 0    |     |
| LD       | C,IYH      | 4C     | FD     | 2    | 0    |     |
| LD       | C,IXL      | 4D     | DD     | 2    | 0    |     |
| LD       | C,IYL      | 4D     | FD     | 2    | 0    |     |

| mnemonic | args       | opcode | prefix | size | type | or  |
| -------- | ---------- | ------ | ------ | ---- | ---- | --- |
| LD       | D,(IXexpr) | 56     | DD     | 3    | 1    |     |
| LD       | D,(IYexpr) | 56     | FD     | 3    | 1    |     |
| LD       | D,IXH      | 54     | DD     | 2    | 0    |     |
| LD       | D,IYH      | 54     | FD     | 2    | 0    |     |
| LD       | D,IXL      | 55     | DD     | 2    | 0    |     |
| LD       | D,IYL      | 55     | FD     | 2    | 0    |     |

| mnemonic | args       | opcode | prefix | size | type | or  |
| -------- | ---------- | ------ | ------ | ---- | ---- | --- |
| LD       | E,(IXexpr) | 5E     | DD     | 3    | 1    |     |
| LD       | E,(IYexpr) | 5E     | FD     | 3    | 1    |     |
| LD       | E,IXH      | 5C     | DD     | 2    | 0    |     |
| LD       | E,IYH      | 5C     | FD     | 2    | 0    |     |
| LD       | E,IXL      | 5D     | DD     | 2    | 0    |     |
| LD       | E,IYL      | 5D     | FD     | 2    | 0    |     |

| mnemonic | args       | opcode | prefix | size | type | or  |
| -------- | ---------- | ------ | ------ | ---- | ---- | --- |
| LD       | H,(IXexpr) | 66     | DD     | 3    | 1    |     |
| LD       | H,(IYexpr) | 66     | FD     | 3    | 1    |     |

| mnemonic | args     | opcode | prefix | size | type | or  |
| -------- | -------- | ------ | ------ | ---- | ---- | --- |
| LD       | IXH,A    | 67     | DD     | 2    | 0    |     |
| LD       | IXH,B    | 60     | DD     | 2    | 0    |     |
| LD       | IXH,C    | 61     | DD     | 2    | 0    |     |
| LD       | IXH,D    | 62     | DD     | 2    | 0    |     |
| LD       | IXH,E    | 63     | DD     | 2    | 0    |     |
| LD       | IXH,IXH  | 64     | DD     | 2    | 0    |     |
| LD       | IXH,IXL  | 65     | DD     | 2    | 0    |     |
| LD       | IXH,expr | 26     | DD     | 3    | 0    |     |

| mnemonic | args     | opcode | prefix | size | type | or  |
| -------- | -------- | ------ | ------ | ---- | ---- | --- |
| LD       | IXL,A    | 6F     | DD     | 2    | 0    |     |
| LD       | IXL,B    | 68     | DD     | 2    | 0    |     |
| LD       | IXL,C    | 69     | DD     | 2    | 0    |     |
| LD       | IXL,D    | 6A     | DD     | 2    | 0    |     |
| LD       | IXL,E    | 6B     | DD     | 2    | 0    |     |
| LD       | IXL,IXH  | 6C     | DD     | 2    | 0    |     |
| LD       | IXL,IXL  | 6D     | DD     | 2    | 0    |     |
| LD       | IXL,expr | 2E     | DD     | 3    | 0    |     |

| mnemonic | args     | opcode | prefix | size | type | or  |
| -------- | -------- | ------ | ------ | ---- | ---- | --- |
| LD       | IYH,A    | 67     | FD     | 2    | 0    |     |
| LD       | IYH,B    | 60     | FD     | 2    | 0    |     |
| LD       | IYH,C    | 61     | FD     | 2    | 0    |     |
| LD       | IYH,D    | 62     | FD     | 2    | 0    |     |
| LD       | IYH,E    | 63     | FD     | 2    | 0    |     |
| LD       | IYH,IYH  | 64     | FD     | 2    | 0    |     |
| LD       | IYH,IYL  | 65     | FD     | 2    | 0    |     |
| LD       | IYH,expr | 26     | FD     | 3    | 0    |     |

| mnemonic | args     | opcode | prefix | size | type | or  |
| -------- | -------- | ------ | ------ | ---- | ---- | --- |
| LD       | IYL,A    | 6F     | FD     | 2    | 0    |     |
| LD       | IYL,B    | 68     | FD     | 2    | 0    |     |
| LD       | IYL,C    | 69     | FD     | 2    | 0    |     |
| LD       | IYL,D    | 6A     | FD     | 2    | 0    |     |
| LD       | IYL,E    | 6B     | FD     | 2    | 0    |     |
| LD       | IYL,IYH  | 6C     | FD     | 2    | 0    |     |
| LD       | IYL,IYL  | 6D     | FD     | 2    | 0    |     |
| LD       | IYL,expr | 2E     | FD     | 3    | 0    |     |

| mnemonic | args       | opcode | prefix | size | type | or  |
| -------- | ---------- | ------ | ------ | ---- | ---- | --- |
| LD       | L,(IXexpr) | 6E     | DD     | 3    | 1    |     |
| LD       | L,(IYexpr) | 6E     | FD     | 3    | 1    |     |

| mnemonic | args     | opcode | prefix | size | type | or  |
| -------- | -------- | ------ | ------ | ---- | ---- | --- |
| OR       | (IXexpr) | B6     | DD     | 3    | 1    |     |
| OR       | (IYexpr) | B6     | FD     | 3    | 1    |     |
| OR       | IXH      | B4     | DD     | 2    | 0    |     |
| OR       | IYH      | B4     | FD     | 2    | 0    |     |
| OR       | IXL      | B5     | DD     | 2    | 0    |     |
| OR       | IYL      | B5     | FD     | 2    | 0    |     |

| mnemonic | args          | opcode | prefix | size | type | or  |
| -------- | ------------- | ------ | ------ | ---- | ---- | --- |
| RES      | expr,(IXexpr) | CB     | DD     | 4    | 2    | 86  |
| RES      | expr,(IYexpr) | CB     | FD     | 4    | 2    | 86  |

| mnemonic | args     | opcode | prefix | size | type | or  |
| -------- | -------- | ------ | ------ | ---- | ---- | --- |
| RL       | (IXexpr) | CB     | DD     | 4    | 1    | 16  |
| RLC      | (IXexpr) | CB     | DD     | 4    | 1    | 06  |
| RR       | (IXexpr) | CB     | DD     | 4    | 1    | 1E  |
| RRC      | (IXexpr) | CB     | DD     | 4    | 1    | 0E  |
| RR       | (IYexpr) | CB     | FD     | 4    | 1    | 1E  |
| RRC      | (IYexpr) | CB     | FD     | 4    | 1    | 0E  |
| RL       | (IYexpr) | CB     | FD     | 4    | 1    | 16  |
| RLC      | (IYexpr) | CB     | FD     | 4    | 1    | 06  |

| mnemonic | args     | opcode | prefix | size | type | or  |
| -------- | -------- | ------ | ------ | ---- | ---- | --- |
| SLA      | (IXexpr) | CB     | DD     | 4    | 1    | 26  |
| SLA      | (IYexpr) | CB     | FD     | 4    | 1    | 26  |
| SRA      | (IXexpr) | CB     | DD     | 4    | 1    | 2E  |
| SRA      | (IYexpr) | CB     | FD     | 4    | 1    | 2E  |
| SRL      | (IXexpr) | CB     | DD     | 4    | 1    | 3E  |
| SRL      | (IYexpr) | CB     | FD     | 4    | 1    | 3E  |

| mnemonic | args       | opcode | prefix | size | type | or  |
| -------- | ---------- | ------ | ------ | ---- | ---- | --- |
| SBC      | A,(IXexpr) | 9E     | DD     | 3    | 1    |     |
| SBC      | A,(IYexpr) | 9E     | FD     | 3    | 1    |     |
| SBC      | A,IXH      | 9C     | DD     | 2    | 0    |     |
| SBC      | A,IYH      | 9C     | FD     | 2    | 0    |     |
| SBC      | A,IXL      | 9D     | DD     | 2    | 0    |     |
| SBC      | A,IYL      | 9D     | FD     | 2    | 0    |     |

| mnemonic | args     | opcode | prefix | size | type | or  |
| -------- | -------- | ------ | ------ | ---- | ---- | --- |
| SUB      | (IXexpr) | 96     | DD     | 3    | 1    |     |
| SUB      | (IYexpr) | 96     | FD     | 3    | 1    |     |
| SUB      | IXH      | 94     | DD     | 2    | 0    |     |
| SUB      | IYH      | 94     | FD     | 2    | 0    |     |
| SUB      | IXL      | 95     | DD     | 2    | 0    |     |
| SUB      | IYL      | 95     | FD     | 2    | 0    |     |

| mnemonic | args     | opcode | prefix | size | type | or  |
| -------- | -------- | ------ | ------ | ---- | ---- | --- |
| XOR      | (IXexpr) | AE     | DD     | 3    | 1    |     |
| XOR      | (IYexpr) | AE     | FD     | 3    | 1    |     |
| XOR      | IXH      | AC     | DD     | 2    | 0    |     |
| XOR      | IYH      | AC     | FD     | 2    | 0    |     |
| XOR      | IXL      | AD     | DD     | 2    | 0    |     |
| XOR      | IYL      | AD     | FD     | 2    | 0    |     |

### Enumerated operations

| mnemonic | args | opcode | prefix | size | type | or  |
| -------- | ---- | ------ | ------ | ---- | ---- | --- |
| RST      | 00   | C7     |        | 1    | 0    |     |
| RST      | 08   | CF     |        | 1    | 0    |     |
| RST      | 10   | D7     |        | 1    | 0    |     |
| RST      | 18   | DF     |        | 1    | 0    |     |
| RST      | 20   | E7     |        | 1    | 0    |     |
| RST      | 28   | EF     |        | 1    | 0    |     |
| RST      | 30   | F7     |        | 1    | 0    |     |
| RST      | 38   | FF     |        | 1    | 0    |     |

### 16-bit operations

| mnemonic | args  | opcode | prefix | size | type | or  |
| -------- | ----- | ------ | ------ | ---- | ---- | --- |
| ADC      | HL,BC | 4A     | ED     | 2    | 0    |     |
| ADC      | HL,DE | 5A     | ED     | 2    | 0    |     |
| ADC      | HL,HL | 6A     | ED     | 2    | 0    |     |
| ADC      | HL,SP | 7A     | ED     | 2    | 0    |     |

| mnemonic | args  | opcode | prefix | size | type | or  |
| -------- | ----- | ------ | ------ | ---- | ---- | --- |
| ADD      | HL,BC | 09     |        | 1    | 0    |     |
| ADD      | HL,DE | 19     |        | 1    | 0    |     |
| ADD      | HL,HL | 29     |        | 1    | 0    |     |
| ADD      | HL,SP | 39     |        | 1    | 0    |     |

| mnemonic | args  | opcode | prefix | size | type | or  |
| -------- | ----- | ------ | ------ | ---- | ---- | --- |
| ADD      | IX,BC | 09     | DD     | 2    | 0    |     |
| ADD      | IX,DE | 19     | DD     | 2    | 0    |     |
| ADD      | IX,IX | 29     | DD     | 2    | 0    |     |
| ADD      | IX,SP | 39     | DD     | 2    | 0    |     |

| mnemonic | args  | opcode | prefix | size | type | or  |
| -------- | ----- | ------ | ------ | ---- | ---- | --- |
| ADD      | IY,BC | 09     | FD     | 2    | 0    |     |
| ADD      | IY,DE | 19     | FD     | 2    | 0    |     |
| ADD      | IY,IY | 29     | FD     | 2    | 0    |     |
| ADD      | IY,SP | 39     | FD     | 2    | 0    |     |

| mnemonic | args | opcode | prefix | size | type | or  |
| -------- | ---- | ------ | ------ | ---- | ---- | --- |
| DEC      | BC   | 0B     |        | 1    | 0    |     |
| DEC      | DE   | 1B     |        | 1    | 0    |     |
| DEC      | HL   | 2B     |        | 1    | 0    |     |
| DEC      | SP   | 3B     |        | 1    | 0    |     |
| DEC      | IX   | 2B     | DD     | 2    | 0    |     |
| DEC      | IY   | 2B     | FD     | 2    | 0    |     |

| mnemonic | args | opcode | prefix | size | type | or  |
| -------- | ---- | ------ | ------ | ---- | ---- | --- |
| INC      | BC   | 03     |        | 1    | 0    |     |
| INC      | DE   | 13     |        | 1    | 0    |     |
| INC      | HL   | 23     |        | 1    | 0    |     |
| INC      | SP   | 33     |        | 1    | 0    |     |
| INC      | IX   | 23     | DD     | 2    | 0    |     |
| INC      | IY   | 23     | FD     | 2    | 0    |     |

| mnemonic | args  | opcode | prefix | size | type | or  |
| -------- | ----- | ------ | ------ | ---- | ---- | --- |
| SBC      | HL,BC | 42     | ED     | 2    | 0    |     |
| SBC      | HL,DE | 52     | ED     | 2    | 0    |     |
| SBC      | HL,HL | 62     | ED     | 2    | 0    |     |
| SBC      | HL,SP | 72     | ED     | 2    | 0    |     |

| mnemonic | args | opcode | prefix | size | type | or  |
| -------- | ---- | ------ | ------ | ---- | ---- | --- |
| POP      | AF   | F1     |        | 1    | 0    |     |
| POP      | BC   | C1     |        | 1    | 0    |     |
| POP      | DE   | D1     |        | 1    | 0    |     |
| POP      | HL   | E1     |        | 1    | 0    |     |
| POP      | IX   | E1     | DD     | 2    | 0    |     |
| POP      | IY   | E1     | FD     | 2    | 0    |     |

| mnemonic | args | opcode | prefix | size | type | or  |
| -------- | ---- | ------ | ------ | ---- | ---- | --- |
| PUSH     | AF   | F5     |        | 1    | 0    |     |
| PUSH     | BC   | C5     |        | 1    | 0    |     |
| PUSH     | DE   | D5     |        | 1    | 0    |     |
| PUSH     | HL   | E5     |        | 1    | 0    |     |
| PUSH     | IX   | E5     | DD     | 2    | 0    |     |
| PUSH     | IY   | E5     | FD     | 2    | 0    |     |

| mnemonic | args | opcode | prefix | size | type | or  |
| -------- | ---- | ------ | ------ | ---- | ---- | --- |
| JP       | (HL) | E9     |        | 1    | 0    |     |
| JP       | (IX) | E9     | DD     | 2    | 0    |     |
| JP       | (IY) | E9     | FD     | 2    | 0    |     |

| mnemonic | args    | opcode | prefix | size | type | or  |
| -------- | ------- | ------ | ------ | ---- | ---- | --- |
| LD       | SP,HL   | F9     |        | 1    | 0    |     |
| LD       | SP,expr | 31     |        | 3    | 0    |     |

| mnemonic | args  | opcode | prefix | size | type | or  |
| -------- | ----- | ------ | ------ | ---- | ---- | --- |
| LD       | SP,IX | F9     | DD     | 2    | 0    |     |
| LD       | SP,IY | F9     | FD     | 2    | 0    |     |

| mnemonic | args    | opcode | prefix | size | type | or  |
| -------- | ------- | ------ | ------ | ---- | ---- | --- |
| LD       | BC,expr | 01     |        | 3    | 0    |     |
| LD       | DE,expr | 11     |        | 3    | 0    |     |
| LD       | HL,expr | 21     |        | 3    | 0    |     |
| LD       | IY,expr | 21     | FD     | 4    | 0    |     |
| LD       | IX,expr | 21     | DD     | 4    | 0    |     |

| mnemonic | args      | opcode | prefix | size | type | or  |
| -------- | --------- | ------ | ------ | ---- | ---- | --- |
| LD       | BC,(expr) | 4B     | ED     | 4    | 0    |     |
| LD       | DE,(expr) | 5B     | ED     | 4    | 0    |     |
| LD       | SP,(expr) | 7B     | ED     | 4    | 0    |     |
| LD       | HL,(expr) | 2A     |        | 3    | 0    |     |
| LD       | IX,(expr) | 2A     | DD     | 4    | 0    |     |
| LD       | IY,(expr) | 2A     | FD     | 4    | 0    |     |

| mnemonic | args      | opcode | prefix | size | type | or  |
| -------- | --------- | ------ | ------ | ---- | ---- | --- |
| LD       | (expr),BC | 43     | ED     | 4    | 0    |     |
| LD       | (expr),DE | 53     | ED     | 4    | 0    |     |
| LD       | (expr),SP | 73     | ED     | 4    | 0    |     |
| LD       | (expr),HL | 22     |        | 3    | 0    |     |
| LD       | (expr),IX | 22     | DD     | 4    | 0    |     |
| LD       | (expr),IY | 22     | FD     | 4    | 0    |     |

| mnemonic | args    | opcode | prefix | size | type | or  |
| -------- | ------- | ------ | ------ | ---- | ---- | --- |
| EX       | (SP),HL | E3     |        | 1    | 0    |     |
| EX       | (SP),IX | E3     | DD     | 2    | 0    |     |
| EX       | (SP),IY | E3     | FD     | 2    | 0    |     |

### Flags-based

| mnemonic | args | opcode | prefix | size | type | or  |
| -------- | ---- | ------ | ------ | ---- | ---- | --- |
| RET      | NZ   | C0     |        | 1    | 0    |     |
| RET      | Z    | C8     |        | 1    | 0    |     |
| RET      | NC   | D0     |        | 1    | 0    |     |
| RET      | C    | D8     |        | 1    | 0    |     |
| RET      | PO   | E0     |        | 1    | 0    |     |
| RET      | PE   | E8     |        | 1    | 0    |     |
| RET      | P    | F0     |        | 1    | 0    |     |
| RET      | M    | F8     |        | 1    | 0    |     |

| mnemonic | args    | opcode | prefix | size | type | or  |
| -------- | ------- | ------ | ------ | ---- | ---- | --- |
| CALL     | NZ,expr | C4     |        | 3    | 0    |     |
| CALL     | Z,expr  | CC     |        | 3    | 0    |     |
| CALL     | NC,expr | D4     |        | 3    | 0    |     |
| CALL     | C,expr  | DC     |        | 3    | 0    |     |
| CALL     | PO,expr | E4     |        | 3    | 0    |     |
| CALL     | PE,expr | EC     |        | 3    | 0    |     |
| CALL     | P,expr  | F4     |        | 3    | 0    |     |
| CALL     | M,expr  | FC     |        | 3    | 0    |     |

| mnemonic | args    | opcode | prefix | size | type | or  |
| -------- | ------- | ------ | ------ | ---- | ---- | --- |
| JP       | NZ,expr | C2     |        | 3    | 0    |     |
| JP       | Z,expr  | CA     |        | 3    | 0    |     |
| JP       | NC,expr | D2     |        | 3    | 0    |     |
| JP       | C,expr  | DA     |        | 3    | 0    |     |
| JP       | PO,expr | E2     |        | 3    | 0    |     |
| JP       | PE,expr | EA     |        | 3    | 0    |     |
| JP       | P,expr  | F2     |        | 3    | 0    |     |
| JP       | M,expr  | FA     |        | 3    | 0    |     |

| mnemonic | args    | opcode | prefix | size | type | or  |
| -------- | ------- | ------ | ------ | ---- | ---- | --- |
| JR       | NZ,expr | 20     |        | 2    | 3    |     |
| JR       | Z,expr  | 28     |        | 2    | 3    |     |
| JR       | NC,expr | 30     |        | 2    | 3    |     |
| JR       | C,expr  | 38     |        | 2    | 3    |     |

| mnemonic | args     | opcode | prefix | size | type | or  |
| -------- | -------- | ------ | ------ | ---- | ---- | --- |
| IN       | A,(expr) | DB     |        | 2    | 0    |     |
| OUT      | (expr),A | D3     |        | 2    | 0    |     |
