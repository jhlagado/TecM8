rot_opcodes:

.pstr "RLC"
.pstr "RRC"
.pstr "RL"
.pstr "RR"
.pstr "SLA"
.pstr "SRA"
.pstr "SLL"
.pstr "SRL"
.pstr ""                    ; terminate list with a string of zero length

alu_opcodes:

.pstr "ADD"
.pstr "ADC"
.pstr "SUB"
.pstr "SBC"
.pstr "AND"
.pstr "XOR"
.pstr "OR"
.pstr "CP"
.pstr ""                    ; terminate list with a string of zero length

bli_opcodes:

.pstr "LDI"
.pstr "CPI"
.pstr "INI"
.pstr "OUTI"
.pstr "LDD"
.pstr "CPD"
.pstr "IND"
.pstr "OUTD"
.pstr "LDIR"
.pstr "CPIR"
.pstr "INIR"
.pstr "OTIR"
.pstr "LDDR"
.pstr "CPDR"
.pstr "INDR"
.pstr "OTDR"
.pstr ""                    ; terminate list with a string of zero length

gen1_opcodes:

.pstr "CCF"
.pstr "CPL"
.pstr "DAA"
.pstr "DI"
.pstr "EI"
.pstr "HALT"
.pstr "NOP"
.pstr "RLCA"
.pstr "RST"
.pstr "SCF"
.pstr ""                    ; terminate list with a string of zero length

gen2_opcodes:

.pstr "BIT"
.pstr "CALL"
.pstr "DEC"
.pstr "DJNZ"
.pstr "EX"
.pstr "EXX"
.pstr "IM"
.pstr "IN"
.pstr "INC"
.pstr "JP"
.pstr "JR"
.pstr "LD"
.pstr "NEG"
.pstr "OUT"
.pstr "POP"
.pstr "PUSH"
.pstr "RES"
.pstr "RET"
.pstr "RETI"
.pstr "RETN"
.pstr "RLA"
.pstr "RLD"
.pstr "RRA"
.pstr "RRCA"
.pstr "RRD"
.pstr "SET"
.pstr ""                    ; terminate list with a string of zero length

reg8:

.pstr "B"
.pstr "C"
.pstr "D"
.pstr "E"
.pstr "H"
.pstr "L"
.pstr " "                   ; don't match, stand-in for (HL)
.pstr "A"
.pstr "I"
.pstr "R"
.pstr ""                    ; terminate list with a string of zero length

reg16:

.pstr "BC"
.pstr "DE"
.pstr "HL"
.pstr "SP"
.pstr "IX"
.pstr "IY"
.pstr "AF'"
.pstr "AF"                  ; NOTE: AF has the same code as SP in some instructions
.pstr ""                    ; terminate list with a string of zero length

flags:

.pstr "NZ"
.pstr "Z"
.pstr "NC"
.pstr "C"
.pstr "PO"
.pstr "PE"
.pstr "P"
.pstr "M"
.pstr ""                    ; terminate list with a string of zero length

directives:

.pstr ".ALIGN"                    
.pstr ".DB"                    
.pstr ".ORG"                    
.pstr ".SET"                    
.pstr ""                    ; terminate list with a string of zero length

; *******************************************************************************
; *********  END OF DATA   ******************************************************
; *******************************************************************************
