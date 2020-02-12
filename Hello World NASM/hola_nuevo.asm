section .data
    holaMundo db "Hola Mundo!!", 10 ; 10 equivale a "\n"
    salir dd 0x0
    continuar dd 0x1
    opciones1 db "Digite 1 para un nuevo mensaje o 0 para salir", 10 
    opciones2 db "Digite 1 para el mensaje original o 0 para salir", 10 ;48

section .bss
    nuevoMensaje resb 32
    inputCmd resb 8

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
    mov rdx, 46
    syscall ; Muestra las opciones al usuario
    
    mov rax, 0
    mov rdi, 0
    mov rsi, inputCmd
    mov rdx, 8
    syscall ; Obtiene el input

    cmp 

_end:
    mov rax, 60
    mov rdi, 0
    syscall ; sys_exit(0)