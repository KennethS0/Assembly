section .data
    msjInput db "Digite un string: ", 10

    msjError db "ERROR - FIN DEL PROGRAMA", 10

section .bss
    mensajeInput resb 100 ; 99 para caracteres del msj, 1 para "Enter"  
    mensajeCambio resb 100

section .text

    global _start

_start:
    call _getMensaje
    call _validar
    call _cambiarCaracteres
    call _end

_getMensaje: ;Obtiene el al cual se le cambiaran los caracteres
    mov rax, 1
    mov rdi, 1
    mov rsi, msjInput
    mov rdx, 19
    syscall ;Imprime el mensaje

    mov rax, 0
    mov rdi, 0
    mov rsi, mensajeInput
    mov rdx, 100
    syscall ;Pone el mensaje en memoria

    ret


_validar:
    xor rbx, rbx; Limpia RBX para que funcione como contador

.vloop: ;Va por cada caracter validando (Subrutina de _validar) 
    xor cl, cl 
    mov cl, BYTE[mensajeInput + rbx] 
    inc rbx 

    cmp cl, 10
    je .end ; Enter

    cmp cl, 32  
    je .vloop ; Espacio

    cmp cl, 'A'
    jl .mostrarError ; Menor a 'A'

    cmp cl, 'z'
    jg .mostrarError ; Mayor a 'A'

    cmp cl, 'a'
    jge .vloop ; Mayor o igual a 'a' 

    cmp cl, 'Z'
    jle .vloop ; Menor o igual a 'Z' 

.mostrarError: ; Despliega el mensaje de error en caso de un caracter invalido
    mov rax, 1
    mov rdi, 1
    mov rsi, msjError
    mov rdx, 25
    syscall

    call _end

.end:
    ret


_cambiarCaracteres: ; Se cambian por medio de XOR con 32, espacio se omite
    xor rbx, rbx ;Limpiar para que sea el contador 

.cloop:
    xor cl, cl   
    mov cl, BYTE[mensajeInput + rbx]    

    cmp cl, 10
    je .mostrarString ; Fin de linea    

    cmp cl, 32
    je .esEspacio ; Espacio

    xor cl, 32 ; Cambio de caracter

    mov BYTE[mensajeCambio + rbx], cl
    inc rbx ;Se aumenta al final para poder guardarlo

    jmp .cloop

.esEspacio:
    mov BYTE[mensajeCambio + rbx], cl
    inc rbx

    jmp .cloop

.mostrarString:
    mov BYTE[mensajeCambio + rbx], 10

    mov rax, 1
    mov rdi, 1
    mov rsi, mensajeCambio
    mov rdx, 100

    syscall
    ret

_end:
    mov rax, 60
    mov rdi, 0
    syscall ; sys_exit(0)