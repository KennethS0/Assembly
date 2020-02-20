section .data
    msjPrimerNum db "Digite el primer numero:", 10 ;25 caracteres

    msjSegundoNum db "Digite el segundo numero:", 10 ;26 caracteres

    msjSuma db "La suma equivale a: " ;20 caracteres

    msjDif db "La diferencia equivale a: "; 26 caracteres 

    msjError db "ERROR" ;5 caracteres

section .bss
    primerNum resb 8
    segundoNum resb 8

section .text

    global _start

_start:
    
    call _getNum1
    call _getNum2
    call _aRegistros
    call _validar
    ; ; call _suma
    ; ; call _diferencia
    
    ; cmp ;Compara la diferencia para ver si es negativa
    ; jp _aPositivo

    ; call _mostrarResultados

_getNum1: ;Obtiene el primer numero
    mov rax, 1
    mov rdi, 1
    mov rsi, msjPrimerNum
    mov rdx, 25
    syscall ; Muestra el primer mensaje en pantalla

    mov rax, 0
    mov rdi, 0
    mov rsi, primerNum
    mov rdx, 16
    syscall ; Obtiene el primer numero

    ret

_getNum2: ;Obtiene el segundo numero
    mov rax, 1
    mov rdi, 1
    mov rsi, msjSegundoNum
    mov rdx, 26
    syscall ; Muestra el segundo mensaje en pantalla

    mov rax, 0
    mov rdi, 0
    mov rsi, primerNum
    mov rdx, 8
    syscall ; Obtiene el segundo numero

    ret

_aRegistros: ;Mueve ambos "numeros" a los registros
    mov r8, QWORD[primerNum] ;r8 reservado para el primer numero
    mov r9, QWORD[segundoNum] ;r9 reservado para el segundo numero

_validar: ;Valida que ambas sean numeros
    loop:
        cmp r8
