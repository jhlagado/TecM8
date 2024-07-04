; *****************************************************************************
; Test variables
; *****************************************************************************

tbDesc:
    dw 0                ; Address of the description
tbText:
    dw 0                ; Address of the test text
tbPtr:
    dw 0                ; Pointer to the current position in the test text

; *****************************************************************************
; Routine: describe
; 
; Purpose:
;    Stores the address of a description string in tbDesc and then skips the string.
; 
; Inputs:
;    HL - Address of the description string
; 
; Outputs:
;    None
; 
; Registers Destroyed:
;    HL
; *****************************************************************************

describe:
    pop hl                    ; Retrieve the return address (address of the description string)
    ld (tbDesc),hl           ; Store the address in tbDesc
    call skipZStr             ; Skip the description string
    inc hl                    ; Move to the next byte after the null terminator
    jp (hl)                   ; Jump to the address specified by the next byte

; *****************************************************************************
; Routine: test
; 
; Purpose:
;    Stores the address of a test text in tbText and tbPtr,and then skips the string.
; 
; Inputs:
;    HL - Address of the test text
; 
; Outputs:
;    None
; 
; Registers Destroyed:
;    HL
; *****************************************************************************

test:
    pop hl                    ; Retrieve the return address (address of the test text)
    ld (tbText),hl           ; Store the address in tbText
    ld (tbPtr),hl            ; Initialize tbPtr with the address of the test text
    call skipZStr             ; Skip the test text string
    inc hl                    ; Move to the next byte after the null terminator
    push hl                   ; push new return address    
    call init                 ; Initialize the environment
    ld hl,testGetCharImpl    ; Load the address of testGetCharImpl
    ld (GETCVEC),hl          ; Set the GETCVEC to point to testGetCharImpl
    jp statementList        

; *****************************************************************************
; Routine: expect
; 
; Purpose:
;    Initializes the environment,sets up the testGetCharImpl,executes the statementList,
;    and compares the result with the expected output.
; 
; Inputs:
;    None
; 
; Outputs:
;    None
; 
; Registers Destroyed:
;    HL,DE
; *****************************************************************************

expect:
    pop hl                    ; Retrieve the return address
    ld de,ASSEMBLY           ; Load the expected output address into DE
    call compareStr           ; Compare the result with the expected output
    jr nz,expect1            ; If comparison fails,jump to expect1
    jp (hl)                   ; If comparison succeeds,jump to the return address

expect1:
    call print                ; Print the failure message
    .cstr "Failed!"
    ld hl,(tbText)           ; Load the address of the test text
    call printZStr            ; Print the test text
    halt                      ; Halt the program

; *****************************************************************************
; Routine: expectOpData
; 
; Purpose:
;    Validate the sequence of opcode and operands against expected values.
;    Print error messages if any mismatch occurs and jump to the next handler.
; 
; Inputs:
;    DE - Points to the expected op data
;    HL - Points to the actual op data
; 
; Outputs:
;    Updates DE and HL as it processes each byte in the sequences.
; 
; Registers Destroyed:
;    A,DE,HL
; *****************************************************************************

expectOpData:
    call crlf
    pop de                           ; Load DE with the return address pointing to the actual opcode/operand sequence
    ld hl,vOpcode                    ; Load HL with the address of the expected opcode/operand sequence
    
    call expectOpItem                ; Compare actual and expected opcode
    .cstr "Wrong opcode"             ; Error message if the opcode does not match
    
    call expectOpItem                ; Compare actual and expected first operand
    .cstr "Wrong operand type 1"          ; Error message if the first operand does not match
    
    call expectOpItem                ; Compare actual and expected first operand
    .cstr "Wrong operand value 1"          ; Error message if the first operand does not match
    
    call expectOpItem                ; Compare actual and expected second operand
    .cstr "Wrong operand type 2"          ; Error message if the second operand does not match
    
    call expectOpItem                ; Compare actual and expected first operand
    .cstr "Wrong operand value 2"          ; Error message if the first operand does not match

    ex de,hl
    jp (hl)                          ; Jump to the address after expected op data

; *****************************************************************************
; Routine: expectOpItem
; 
; Purpose:
;    Compare the actual and expected opcode/operand byte and handle mismatches.
; 
; Inputs:
;    DE - Points to the expected byte.
;    HL - Points to the actual byte.
; 
; Outputs:
;    Increments DE and HL to the next byte in the sequences.
;    Prints error messages if any mismatch occurs.
; 
; Registers Destroyed:
;    A,DE,HL
; *****************************************************************************

expectOpItem:
    ld a,(de)                       ; Load the expected byte into A from DE
    cp -1                           ; skip?
    jr z,expectOpItem1
    cp (hl)                         ; Compare expected with actual
    jr nz,expectOpItem2             ; If bytes match Return if the bytes match

expectOpItem1:
    inc de                          ; Move DE to point to next expected byte
    inc hl                          ; Move HL to point to next actual byte
    ex (sp),hl                      ; HL = expected string to skip (sp) = actual*
    call skipZStr                   ; Skip the message string
    inc hl                          ; Move to the next byte after the null terminator
    ex (sp),hl                      ; HL = actual* (SP) = expected string to skip 
    ret                             ; return after message string

expectOpItem2:
    ex (sp),hl                      ; save hl, hl = expected message
    push de                         ; save de
    push hl                         ; save message
    call crlf
    ld hl,(tbDesc)                  ; Load the address of the test text
    call printZStr                  ; Print the test description
    call crlf
    pop hl                          ; HL = expected message
    call printZStr                  ; Print the test description
    call crlf
    call crlf
    call print                      ; Print error messages if the bytes do not match
    .cstr "Expected: "              ; Print "Expected"
    pop hl
    ld a,(hl)                       ; Load the expected byte into A for printing
    call printHex2                  ; Print the expected byte in hexadecimal
    call crlf
    call print                      ; Print "Received"
    .cstr "Actual: "
    pop hl
    ld a,(hl)                       ; Load the actual byte into A for printing
    call printHex2                  ; Print the actual byte in hexadecimal
    call crlf
    halt                            ; Halt the program

; *****************************************************************************
; Routine: testGetCharImpl
; 
; Purpose:
;    Retrieves the next character from the test text.
; 
; Inputs:
;    tbPtr - Pointer to the current position in the test text
; 
; Outputs:
;    A - The next character from the test text
; 
; Registers Destroyed:
;    A,HL
; *****************************************************************************

testGetCharImpl:
    push hl                   ; Save HL register
    ld hl,(tbPtr)            ; Load the current pointer from tbPtr
    ld a,(hl)                ; Load the next character from the test text
    inc hl                    ; Move to the next character
    ld (tbPtr),hl            ; Update tbPtr with the new pointer
    pop hl                    ; Restore HL register
    ret                       ; Return with the character in A

; *****************************************************************************
; Routine: printHex
; 
; Purpose:
;    Displays the 16-bit value in the HL register as a hexadecimal number.
; 
; Inputs:
;    HL - The 16-bit value to be displayed.
; 
; Outputs:
;    None
; 
; Registers Destroyed:
;    A,C
; *****************************************************************************

printHex:
    push bc                         ; Preserve the BC register pair
    ld a,h                         ; Load the high byte of HL into A
    call printHex2                  ; Print the high byte as hex
    ld a,l                         ; Load the low byte of HL into A
    call printHex2                  ; Print the low byte as hex
    pop bc                          ; Restore the BC register pair
    ret                             ; Return from the routine

; *****************************************************************************
; Routine: printHex2
; 
; Purpose:
;    Prints a single byte in hexadecimal format by printing its high and low nibbles.
; 
; Inputs:
;    A - The byte to be printed.
; 
; Outputs:
;    None.
; 
; Registers Destroyed:
;    A,C
; *****************************************************************************

printHex2:
    ld c,a                          ; Copy the value in A to C
    rra                             ; Shift the high nibble to the low nibble
    rra
    rra
    rra
    call printHex3                  ; Print the high nibble as hex
    ld a,c                          ; Restore the original value to A

printHex3:
    and 0x0F                        ; Mask out the upper nibble
    add a,0x90                      ; Add 0x90 to adjust for the ASCII range
    daa                             ; Decimal adjust A to get the correct ASCII value
    adc a,0x40                      ; Add 0x40 to get the ASCII character for 0-9/A-F
    daa                             ; Decimal adjust A to get the correct ASCII value
    jp putchar                      ; Jump to the putchar routine to display the character
	
; *****************************************************************************
; Routine: skipZStr
; 
; Purpose:
;    Skips over a null-terminated string in memory,advancing the HL register
;    to the character following the null terminator.
; 
; Inputs:
;    HL - Points to the start of the string to skip.
; 
; Outputs:
;    HL - Points to the character immediately after the null terminator.
; 
; Registers Destroyed:
;    A
; *****************************************************************************

skipZStr:
    jr skipZStr2                ; Jump to the character loading step

skipZStr1:                            
    inc hl                      ; Move to the next character

skipZStr2:
    ld a,(hl)                  ; Load the current character
    or a                        ; Check if the character is null
    jr nz,skipZStr1            ; If not null,continue to the next character
    ret                         ; Return when a null character is found
