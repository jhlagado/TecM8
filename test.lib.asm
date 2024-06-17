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
    ld (tbDesc), hl           ; Store the address in tbDesc
    call skipZStr             ; Skip the description string
    inc hl                    ; Move to the next byte after the null terminator
    jp (hl)                   ; Jump to the address specified by the next byte

; *****************************************************************************
; Routine: test
; 
; Purpose:
;    Stores the address of a test text in tbText and tbPtr, and then skips the string.
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
    ld (tbText), hl           ; Store the address in tbText
    ld (tbPtr), hl            ; Initialize tbPtr with the address of the test text
    call skipZStr             ; Skip the test text string
    inc hl                    ; Move to the next byte after the null terminator
    jp (hl)                   ; Jump to the address specified by the next byte

; *****************************************************************************
; Routine: expect
; 
; Purpose:
;    Initializes the environment, sets up the testGetCharImpl, executes the statementList, 
;    and compares the result with the expected output.
; 
; Inputs:
;    None
; 
; Outputs:
;    None
; 
; Registers Destroyed:
;    HL, DE
; *****************************************************************************

expect:
    call init                 ; Initialize the environment
    ld hl, testGetCharImpl    ; Load the address of testGetCharImpl
    ld (GETCVEC), hl          ; Set the GETCVEC to point to testGetCharImpl
    call statementList        ; Execute the statementList
    pop hl                    ; Retrieve the return address
    ld de, ASSEMBLY           ; Load the expected output address into DE
    call compareStr           ; Compare the result with the expected output
    jr nz, expect1            ; If comparison fails, jump to expect1
    jp (hl)                   ; If comparison succeeds, jump to the return address

expect1:
    call print                ; Print the failure message
    .cstr "Failed!"
    ld hl, (tbText)           ; Load the address of the test text
    call printZStr            ; Print the test text
    halt                      ; Halt the program

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
;    A, HL
; *****************************************************************************

testGetCharImpl:
    push hl                   ; Save HL register
    ld hl, (tbPtr)            ; Load the current pointer from tbPtr
    ld a, (hl)                ; Load the next character from the test text
    inc hl                    ; Move to the next character
    ld (tbPtr), hl            ; Update tbPtr with the new pointer
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
;    A, C
; *****************************************************************************

printHex:
    push bc                         ; Preserve the BC register pair
    ld a, h                         ; Load the high byte of HL into A
    call printHex2                  ; Print the high byte as hex
    ld a, l                         ; Load the low byte of HL into A
    call printHex2                  ; Print the low byte as hex
    pop bc                          ; Restore the BC register pair
    ret                             ; Return from the routine

printHex2:
    ld c, a                         ; Copy the value in A to C
    rra                             ; Shift the high nibble to the low nibble
    rra
    rra
    rra
    call printHex3                  ; Print the high nibble as hex
    ld a, c                         ; Restore the original value to A

printHex3:
    and 0x0F                        ; Mask out the upper nibble
    add a, 0x90                     ; Add 0x90 to adjust for the ASCII range
    daa                             ; Decimal adjust A to get the correct ASCII value
    adc a, 0x40                     ; Add 0x40 to get the ASCII character for 0-9/A-F
    daa                             ; Decimal adjust A to get the correct ASCII value
    jp putchar                      ; Jump to the putchar routine to display the character
	
; *****************************************************************************
; Routine: skipZStr
; 
; Purpose:
;    Skips over a null-terminated string in memory, advancing the HL register
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
    ld a, (hl)                  ; Load the current character
    or a                        ; Check if the character is null
    jr nz, skipZStr1            ; If not null, continue to the next character
    ret                         ; Return when a null character is found
