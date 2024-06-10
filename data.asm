opcodes:

.pstr "ADC"
.pstr "ADD"
.pstr "AND"
.pstr "BIT"
.pstr "CALL"
.pstr "CCF"
.pstr "CP"
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
.pstr "OR"
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
.pstr "RL"
.pstr "RLA"
.pstr "RLC"
.pstr "RLCA"
.pstr "RLD"
.pstr "RR"
.pstr "RRA"
.pstr "RRC"
.pstr "RRCA"
.pstr "RRD"
.pstr "RST"
.pstr "SBC"
.pstr "SCF"
.pstr "SET"
.pstr "SLA"
.pstr "SRA"
.pstr "SRL"
.pstr "SUB"
.pstr "XOR"
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
