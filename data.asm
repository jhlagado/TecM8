
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

gen_opcodes:

.pstr "BIT"
.pstr "CALL"
.pstr "CCF"
.pstr "CPD"
.pstr "CPDR"
.pstr "CPI"
.pstr "CPIR"
.pstr "CPL"
.pstr "DAA"
.pstr "DEC"
.pstr "DI"
.pstr "DJNZ"
.pstr "EI"
.pstr "EX"
.pstr "EXX"
.pstr "HALT"
.pstr "IM"
.pstr "IN"
.pstr "INC"
.pstr "IND"
.pstr "INDR"
.pstr "INI"
.pstr "INIR"
.pstr "JP"
.pstr "JR"
.pstr "LD"
.pstr "LDD"
.pstr "LDDR"
.pstr "LDI"
.pstr "LDIR"
.pstr "NEG"
.pstr "NOP"
.pstr "OTDR"
.pstr "OTIR"
.pstr "OUT"
.pstr "OUTD"
.pstr "OUTI"
.pstr "POP"
.pstr "PUSH"
.pstr "RES"
.pstr "RET"
.pstr "RETI"
.pstr "RETN"
.pstr "RLA"
.pstr "RLCA"
.pstr "RLD"
.pstr "RRA"
.pstr "RRCA"
.pstr "RRD"
.pstr "RST"
.pstr "SCF"
.pstr "SET"
.pstr ""                    ; terminate list with a string of zero length

registers:

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

reg_pairs:

.pstr "BC"
.pstr "DE"
.pstr "HL"
.pstr "SP"
.pstr "AF"                  ; NOTE: AF has the same code as SP in some instructions
.pstr "IX"
.pstr "IY"
.pstr "AF'"
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
