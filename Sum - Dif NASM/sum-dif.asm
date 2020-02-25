section .data

    obtenerNumsMsj db "Digite dos numeros positivos de maximo 16 digitos", 10
    obtenerNumMsjLen equ $-obtenerNumsMsj

    num1_msj db "Numero 1: "
    num1_msjLen equ $-num1_msj

    num2_msj db "Numero 2: "
    num2_msjLen equ $-num2_msj

    msjError db "ERROR - Numero invalido", 10
    msjErrorLen equ $-msjError

    msjSuma db "Suma: "
    msjSumaLen equ $-msjSuma

    msjDif db "Diferencia: "
    msjDifLen equ $-msjDif

section .bss
    num1 resb 17
    num2 resb 17

    result resb 25

section .text

global _start

_start:
    call _getNum1
    call _validarNum1
    call _getNum2
    call _validarNum2
    call _suma
    call _resta
    call _mostrarResta
    call _mostrarSuma
    call _end

_getNum1: ; Obtiene los numeros y muestra los respectivos mensajes
    mov rax, 1
    mov rdi, 1
    mov rsi, obtenerNumsMsj
    mov rdx, obtenerNumMsjLen
    syscall  ; Muestra Mensaje

    mov rax, 1
    mov rdi, 1
    mov rsi, num1_msj
    mov rdx, num1_msjLen
    syscall  ; Muestra mensaje

    mov rax, 0
    mov rdi, 0
    mov rsi, num1
    mov rdx, 17
    syscall  ; Obtiene el primer numero

    ret

_getNum2:
    mov rax, 1
    mov rdi, 1
    mov rsi, num2_msj
    mov rdx, num2_msjLen
    syscall  ; Muestra mensaje

    mov rax, 0
    mov rdi, 0
    mov rsi, num2
    mov rdx, 17
    syscall  ; Obtiene el segundo numero

    ret

_validarNum1: ; Valida el primer numero
    xor rcx, rcx ; Contador
    xor r8, r8 ; Numero 1
    xor r12, r12   ; Cantidad digitos

    xor r10, r10
    mov r10, 1 ; Posicion decimal 

    mov r11, 10

    xor rax, rax

.vloop: ; Validacion   
    mov al, BYTE[num1 + rcx] ; AL comparar caracteres
    inc rcx
    
    cmp al, 10
    je .sloop ; Fin de linea

    ; No es digito
    cmp al, 48   
    jl _mostrarError 
  
    cmp al, 57
    jg _mostrarError

    ; Vuelve al loop
    inc r12
    jmp .vloop 
    
.sloop: ; Inserta num1 en rdx
    xor rax, rax

    dec r12
    mov al, BYTE[num1 + r12]
    sub rax, 48  ; Convierte a decimal

    mul r10

    add r8, rax ; Suma el digito

    cmp r12, 0
    je .end      ; No hay mas digitos

    xor rax, rax 
    mov rax, r10
    mul r11
    xor r10, r10
    mov r10, rax ; Incrementa posicion
    
    jmp .sloop

.end:
    ret


_validarNum2: ; Valida el segundo numero
    xor rdx, rdx ; Contador
    xor r9, r9 ; Numero 2
    xor r12, r12

    xor r10, r10
    mov r10, 1

    mov r11, 10

    xor rax, rax

.vloop: ; Validacion   
    mov al, BYTE[num2 + rdx] ; AL comparar caracteres
    inc rdx
    
    cmp al, 10
    je .sloop

    ; No es digito
    cmp al, 48   
    jl _mostrarError 
  
    cmp al, 57
    jg _mostrarError

    ; Vuelve al loop
    inc r12
    jmp .vloop 
    
.sloop: ; Inserta num2 en R9
    xor rax, rax
    
    dec r12
    mov al, BYTE[num2 + r12]
    sub rax, 48 ; Convierte a decimal

    mul r10 

    add r9, rax ; Suma el digito

    cmp r12, 0
    je .end ; No hay mas digitos

    xor rax, rax 
    mov rax, r10
    mul r11
    xor r10, r10
    mov r10, rax ; Incrementa posicion
    
    jmp .sloop

.end:
    ret


_suma: ; R8 = num1, R9 = num2, R10 = resultado
    xor r10, r10
    add r10, r8
    add r10, r9

    ret

_resta: ; R8 = Resultado
    sub r8, r9

    cmp r8, 0 
    jl .negar
    jge .end

.negar: ; Menor a 0
    neg r8 

.end:
    ret    


_mostrarSuma: ; Suma esta en R10
    mov rax, 1
    mov rdi, 1
    mov rsi, msjSuma
    mov rdx, msjSumaLen
    syscall ; Muestra mensaje

    mov rax, r10 ; Mueve la suma
 
    call _mostrarRAX
    ret


_mostrarResta: ; Diferencia esta en R11
    mov rax, 1
    mov rdi, 1
    mov rsi, msjDif
    mov rdx, msjDifLen
    syscall ; Muestra mensaje
    
    mov rax, r8 ; Mueve diferencia

    call _mostrarRAX
    ret


_mostrarRAX: ; Muestra el contenido de RAX
    mov r8, 10 
    xor rcx, rcx ; Contador
    push 10 

.rloop:
    xor rdx, rdx
    div r8
    add rdx, 48 ; Conversion a caracter
    push rdx

    cmp rax, 0
    je .sloop ; RAX vacio 
    
    jmp .rloop

.sloop:
    xor r9, r9 ; Holder temporal
    pop r9
    mov [result + rcx], r9
    inc rcx

    cmp r9, 10
    je .printStr

    jmp .sloop

.printStr:
    mov rax, 1
    mov rdi, 1
    mov rsi, result
    mov rdx, 25
    syscall ; Muestra el resultado

.clean:
    mov rdi, result
    mov rcx, 25
    xor rax, rax
    rep stosb
    ret 
    

_mostrarError:
    mov rax, 1
    mov rdi, 1
    mov rsi, msjError
    mov rdx, msjErrorLen
    syscall ; Muestra el mensaje

    call _end

_end: ; Finaliza el programa
    mov rax, 60
    mov rdi, 0
    syscall