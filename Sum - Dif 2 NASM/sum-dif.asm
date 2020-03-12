section .data

lookUp db '0123456789ABCDEF'

msgNum1 db "Type the first number (Positive): ", 10
msgNum1Len equ $-msgNum1

msgNum2 db "Type the second number (Positive): ", 10
msgNum2Len equ $-msgNum2

msgError db "- ERROR - Type 1 to restart the program. Anything else will exit the program.", 10
msgErrorLen equ $-msgError

msgSuma db "   Sum: "
msgSumaLen equ $-msgSuma

msgDif db "   Difference: "
msgDifLen equ $-msgDif

msgLabel db "Base "
msgLabelLen equ $-msgLabel

%define numberSize 20
%define resultSize 100

section .bss

num1 resb numberSize
num2 resb numberSize

baseNum resb 3

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

; %1 Reserved memory to clean
%macro clean 1
    mov rdi, %1
    mov rcx, 32
    xor rax, rax
    rep stosb
%endmacro

global _start

_start:
    ; r8 Holds the first number
    ; r9 Holds the second number
    ; r10 Holds the sum
    ; r13 Holds the difference
    print msgNum1, msgNum1Len
    getInput num1, numberSize
    saveNumber num1, r8

    print msgNum2, msgNum2Len
    getInput num2, numberSize
    saveNumber num2, r9

    sum r8, r9, r10
    difference r8, r9, r13

    xor r15, r15
    mov r15, 2     ;Counter for all bases

_baseLoop:
    print msgLabel, msgLabelLen
    printDigit r15, baseNum
    clean baseNum

    convert r13, r15
    print msgDif, msgDifLen
    print result, resultSize

    clean result

    convert r10, r15
    print msgSuma, msgSumaLen
    print result, resultSize

    clean result

    cmp r15, 16
    je _exit

    inc r15
    jmp _baseLoop

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