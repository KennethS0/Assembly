section .data
    holaMundo db "Hola Mundo!!", 10 ; 10 equivale a "\n"
    opciones1 db "Digite 1 para un nuevo mensaje, cualquier otro para salir", 10 
    opciones2 db "Digite 1 para el mensaje original, cualquier otro para salir", 10 ;48

section .bss
    nuevoMensaje resb 32
    inputCmd resb 2

section .text
    global _start


_start:
    call _printHolaMundo
    call _opcionesCmd1


_printHolaMundo:
    mov rax, 1 ; Id de sys_write
    mov rdi, 1 ; Indica que es para output
    mov rsi, holaMundo 
    mov rdx, 13 ; largo del texto
    syscall ; sys_write(1, text, 13)
    ret


_opcionesCmd1:
    mov rax, 1
    mov rdi, 1 
    mov rsi, opciones1 
    mov rdx, 58
    syscall ; Muestra las opciones al usuario
    
    mov rax, 0
    mov rdi, 0
    mov rsi, inputCmd
    mov rdx, 2
    syscall ; Obtiene el input

    cmp BYTE[inputCmd], '1'    
    jne _end
    je _opcionesCmd2
    
_opcionesCmd2: 
    
    call _clearMsj
    call _getNuevo

    mov rax, 1
    mov rdi, 1
    mov rsi, nuevoMensaje
    mov rdx, 32
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, opciones2
    mov rdx, 61
    syscall ; Muestra el mensaje de opciones

    mov rax, 0
    mov rdi, 0
    mov rsi, inputCmd
    mov rdx, 2
    syscall ; Obtiene el input

    cmp BYTE[inputCmd], '1'
    jne _end
    je _start

_getNuevo:
    mov rax, 0
    mov rdi, 0
    mov rsi, nuevoMensaje
    mov rdx, 32
    syscall ; Obtiene el input
    ret

_clearMsj:
    mov edi, nuevoMensaje
    mov ecx, 32
    xor eax, eax
    rep stosb
    ret


_end:
    mov rax, 60
    mov rdi, 0
    syscall ; sys_exit(0)