.data
    msjInput: .ascii "Digite un string: \n"
    msjError: .ascii "ERROR - FIN DE PROGRAMA \n"

.bss
    mensajeInput: .space 100 #99 para caracteres del msj, 1 para "Enter"  
    mensajeCambio: .space 100

.text
    .global _start

_start:
    call _getMensaje
    call _validar
    call _cambiarCaracteres
    call _end

_getMensaje: #Obtiene el al cual se le cambiaran los caracteres
    movq $1, %rax
    movq $1, %rdi
    movq $msjInput, %rsi
    movq $19, %rdx
    syscall #Imprime el mensaje

    movq $0, %rax
    movq $0, %rdi
    movq $mensajeInput, %rsi
    movq $100, %rdx
    syscall #Pone el mensaje en memoria

    ret


_validar:
    xorq %rbx, %rbx #Limpia RBX para que funcione como contador

.vloop: #Va por cada caracter validando (Subrutina de _validar) 
    xorb %cl, %cl
    
    mov mensajeInput(%rbx, 1), %cl #Mueve un byte a CL
    incq %rbx 

    cmpb $10, %cl
    je .end # Enter

    cmpb $32, %cl
    je .vloop # Espacio

    cmpb $'A', %cl
    jl .mostrarError # Menor a 'A'

    cmpb $'z', %cl
    jg .mostrarError #Mayor a 'z'

    cmpb $'a', %cl
    jge .vloop # Mayor o igual a 'a'

    cmpb $'Z', %cl
    jle .vloop # Menor o igual a 'Z'

.mostrarError:
    movq $1, %rax
    movq $1, %rdi
    movq $msjError, %rsi
    movq $25, %rdx
    
    syscall

    call _end

.end:
    ret


_cambiarCaracteres: # Despliega el mensaje de error en caso de un caracter invalido
    xorq %rbx, %rbx # Limpia para que sea el contador

.cloop:
    xor %cl, %cl
    movb mensajeInput(%rbx, 1), %cl

    cmpb $10, %cl
    je .mostrarString # Fin de string

    cmpb $32, %cl
    je .esEspacio # Espacio

    xorb $32, %cl # Cambio mayus <-> minus

    movb %cl, mensajeCambio(%rbx, 1)
    incq %rbx # Se aumenta al final para poder guardarlo

    jmp .cloop

.esEspacio:
    movb %cl, mensajeCambio(%rbx, 1)
    inc %rbx

    jmp .cloop

.mostrarString:
    movb $10, mensajeCambio(%rbx, 1)

    movq $1, %rax
    movq $1, %rdi
    movq $mensajeCambio, %rsi
    movq $100, %rdx
    syscall

    ret

_end:
    movq $60, %rax
    movq $0, %rdi # Termina el programa
    syscall 
