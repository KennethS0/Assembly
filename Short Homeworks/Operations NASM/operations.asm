section .data

lookUp db '0123456789ABCDEF'

msgChoice db "Choose one from the following choices: ", 10
msgChoiceLen equ $-msgChoice

msgSum db "-Sum (1) ", 10
msgSumLen equ $-msgSum

msgDifference db "-Difference (2) ", 10
msgDiffereceLen equ $-msgDifference

msgMult db "-Multiplication (3) ", 10
msgMultLen equ $-msgMult

msgDiv db "-Division (4) ", 10
msgDivLen equ $-msgDiv

msgNum1 db "Type the first number (Positive): ", 10
msgNum1Len equ $-msgNum1

msgNum2 db "Type the second number (Positive): ", 10
msgNum2Len equ $-msgNum2

msgOverFlow db "The result generates Overflow... ", 10
msgOverFlowLen equ $-msgOverFlow

msgBin db "The binary result is: ", 10
msgBinLen equ $-msgBin

msgOct db "The octal result is: ", 10
msgOctLen equ $-msgOct

msgDec db "The decimal result is: ", 10
msgDecLen equ $-msgDec

msgHex db "The hexadecimal result is: ", 10
msgHexLen equ $-msgHex


msgError db "- ERROR - Type 1 to restart the program. Anything else will exit the program.", 10
msgErrorLen equ $-msgError

msgOverRAX db "- The product surpasses 64-Bit capacity. Only Hexadecimal result will be displayed.", 10
msgOverRAXLen equ $-msgOverRAX

msgLabel db "Base "
msgLabelLen equ $-msgLabel
;;;;;;;;;;;;;;;;;;;;;
flag db "Im here flag "
flaglen equ $-flag
;;;;;;;;;;;;;;;;;;;;;;;;
%define numberSize 21
%define resultSize 100

section .bss

num1 resb numberSize
num2 resb numberSize

baseNum resb 3
choice resb 10
restart resb 2

result resb numberSize

section .text


; %1 String
; %2 Number of bytes
%macro print 2
    mov rax, 1
    mov rdi, 1
    mov rsi, %1
    mov rdx, %2
    syscall
%endmacro


; %1 Reserved memory 
; %2 Number of bytes 
%macro getInput 2
    mov rax, 0
    mov rdi, 0
    mov rsi, %1
    mov rdx, %2
    syscall
%endmacro


; %1 Reserved memory from .bss
; %2 Storage (Register)
%macro saveNumber 2
    xor rcx, rcx  ; Cleans counter register
    xor %2, %2    ; Cleans storage register
    xor r12, r12  ; Amount of digits in the number

    xor r10, r10  
    mov r10, 1    ; Cleans and sets decimal position

    mov rbx, 10

    %%_vloop:
        mov al, BYTE[%1 + rcx] ; Moves one character to AL
        inc rcx

        cmp al, 10
        je %%_sloop   ; Validates end of line

        cmp al, 48    ; Validates if it is a number
        jl _error 

        cmp al, 57
        jg _error

        inc r12       ; Increments amount of digits
        jmp %%_vloop

    %%_sloop:
        xor rax, rax

        dec r12
        mov al, BYTE[%1 + r12]
        sub rax, 48   ; Converts to decimal

        mul r10       ; Multiplies for position

        add %2, rax   ; Adds to storage register

        cmp r12, 0
        je %%_end      ; No more digits

        xor rax, rax 
        mov rax, r10
        mul rbx
        xor r10, r10
        mov r10, rax ; Increments position
        
        jmp %%_sloop
    
    %%_end:
%endmacro


; %1 First number as register
; %2 Second number as register
; %3 Storage Register
%macro sum 3
    xor %3, %3  ; Cleans storage
    add %3, %1  
    add %3, %2
    jo _overflow
%endmacro


; %1 First number as register
; %2 Second number as register
; %3 Storage Register
%macro difference 3
    xor %3, %3  ; Cleans storage

    mov %3, %1
    sub %3, %2

    cmp %3, 0
    jl %%_negate ; Checks if its negative

    jg %%_end

    %%_negate:
    neg %3

    %%_end:
%endmacro

; %1 First number as register
; %2 Second number as register
; %3 Storage register
; %4 High end storage register
%macro multiplication 4
    xor %3, %3 ; cleans storage

    mov rax, %1
    mov rcx, %2
    imul rcx
    mov %3, rax
    mov %4, rdx
%endmacro
; %1 First number as register
; %2 Second number as register
; %3 Storage register
%macro division 3
    xor %3, %3 ; cleans storage
    cmp %1, %2
    jbe %%secondGfirst

    %%firstGsecond:
        mov rax, %1
        mov rdx, 0
        mov rcx, %2
        div rcx
        mov %3, rax
        jmp %%_end

    %%secondGfirst:
        mov rax, %2
        mov rdx, 0
        mov rcx, %1
        div rcx
        mov %3, rax
        jmp %%_end

    %%_end:


%endmacro

; %1 Register holding a number
; %2 Reserved memory
%macro printDigit 2
    mov rax, %1

    mov r8, 10 
    xor rcx, rcx ; Contador
    push 10 

    %%rloop:
        xor rdx, rdx
        div r8
        add rdx, 48 ; Conversion a caracter
        push rdx

        cmp rax, 0
        je %%sloop ; RAX vacio 
    
        jmp %%rloop

    %%sloop:
        xor r9, r9 ; Holder temporal
        pop r9
        mov [%2 + rcx], r9
        inc rcx

        cmp r9, 10
        je %%_end

        jmp %%sloop
    %%_end:
    print baseNum, 3
%endmacro


; %1 Number in register
; %2 Base to convert
%macro convert 2
    xor rax, rax
    xor rdx, rdx
    xor rbx, rbx
    xor rcx, rcx
 
    mov rax, %1
    push 10
 
    mov rcx, %2
    %%_division:
        div rcx
        
        mov bl, BYTE[lookUp + rdx]
        xor rdx, rdx

        push rbx

        cmp rax, 0
        je %%_toMemory
        
        jmp %%_division

    %%_toMemory:

        pop rbx
        mov BYTE[result + rcx], bl
        inc rcx

        cmp rbx, 10
        je %%_end

        jmp %%_toMemory
    %%_end:
%endmacro

; %1 Reserved memory
; %2 Character that needs to change
; %3 Character to replace %2 with
%macro changeCharacter 3
    xor rcx, rcx

    %%_loop:
        cmp BYTE[%1 + rcx], %2
        je %%_end

        inc rcx
        jmp %%_loop

    %%_end:
        mov BYTE[%1 + rcx], %3
%endmacro

; %1 Reserved memory to clean
%macro clean 1
    mov rdi, %1
    mov rcx, 100
    xor rax, rax
    rep stosb
%endmacro

global _start

_start:
; Initial prints with the operation choices for the user
    print msgChoice, msgChoiceLen
    print msgSum, msgSumLen
    print msgDifference, msgDiffereceLen
    print msgMult, msgMultLen
    print msgDiv, msgDivLen

; Choice stores the operation ID, whether it's 1,2,3,4
; Here it validates if 1<= choice <= 4
    getInput choice, 10
    cmp BYTE[choice], 49
    jb _error
    cmp BYTE[choice], 52
    jg _error
    cmp BYTE[choice + 1], 10
    jne _error

; r8 stores the first number of the operation
    print msgNum1, msgNum1Len
    getInput num1, numberSize
    saveNumber num1, r8

; r9 stores the first number of the operation
    print msgNum2, msgNum2Len
    getInput num2, numberSize
    saveNumber num2, r9

; Set of comparisons between the user choice and the operation ID
    xor rdx, rdx
    cmp BYTE[choice], 49
    je _sum
    cmp BYTE[choice], 50
    je _dif
    cmp BYTE[choice], 51
    je _mult
    cmp BYTE[choice], 52
    je _div

_sum:
    sum r8, r9, r13
    jmp _displayResultAll
_dif:
    difference r8, r9, r13
    jmp _displayResultAll
_mult:
    multiplication r8, r9, r13, r14
    cmp rdx, 0 ; Checks if the product is bigger than 64 bits 
    je _displayResultAll
    
    jmp _displayHexResult

_div:
    division r8, r9, r13
    jmp _displayResultAll

_displayHexResult:
; Prints a max of 128 bits
    print msgOverRAX, msgOverRAXLen
    print msgHex, msgHexLen

    convert r14, 16
    changeCharacter result, 10, 0
    print result, resultSize

    clean result

    convert r13, 16
    print result, resultSize

    jmp _exit

_displayResultAll:
;   Set of instructions that print the result (r13) in binary, octal, decimal and hexadecimal base 
    print msgBin, msgBinLen
    convert r13, 2
    print result, resultSize
    clean result

    print msgOct, msgOctLen
    convert r13, 8
    print result, resultSize
    clean result

    print msgDec, msgDecLen
    convert r13, 10
    print result, resultSize
    clean result

    print msgHex, msgHexLen
    convert r13, 16
    print result, resultSize
    clean result
    jmp _exit


_overflow:
; Alerts the user that the result of the operation generates overflow
    print msgOverFlow, msgOverFlowLen
    jmp _error

_error:
    print msgError, msgErrorLen
    
    getInput restart, 2
    cmp BYTE[restart], 49
    je _start

    jmp _exit

_exit:
    mov rax, 60
    mov rdi, 0
    syscall