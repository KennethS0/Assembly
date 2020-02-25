.data

    obtenerNumsMsj: .ascii "Digite dos numeros positivos de maximo 16 digitos \n"
    obtenerNumMsjLen = .-obtenerNumsMsj

    num1_msj: .ascii "Numero 1: "
    num1_msjLen = .-num1_msj

    num2_msj: .ascii "Numero 2: "
    num2_msjLen = .-num2_msj

    msjError: .ascii "ERROR - Numero invalido \n"
    msjErrorLen = .-msjError

    msjSuma: .ascii "Suma: "
    msjSumaLen = .-msjSuma

    msjDif: .ascii "Diferencia: "
    msjDifLen = .-msjDif

.bss
    num1: .space 17
    num2: .space 17

    result: .space 25

.text
    .global _start

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

_getNum1: # Obtiene los numeros y muestra los respectivos mensajes
    movq $1 , %rax
    movq $1, %rdi
    movq $obtenerNumsMsj, %rsi
    movq $obtenerNumMsjLen, %rdx
    syscall  # Muestra Mensaje

    movq $1, %rax
    movq $1, %rdi
    movq $num1_msj, %rsi
    movq $num1_msjLen, %rdx
    syscall  # Muestra mensaje

    movq $0, %rax
    movq $0, %rdi
    movq $num1, %rsi
    movq $17, %rdx
    syscall  # Obtiene el primer numero

    ret

_getNum2:
    movq $1, %rax
    movq $1, %rdi
    movq $num2_msj, %rsi
    movq $num2_msjLen, %rdx
    syscall # Muestra mensaje

    movq $0, %rax
    movq $0, %rdi
    movq $num2, %rsi
    movq $17, %rdx
    syscall  # Obtiene el segundo numero

    ret

_validarNum1: # Valida el primer numero
    xorq %rcx, %rcx # Contador
    xorq %r8, %r8 # Numero 1
    xorq %r12, %r12  # Cantidad digitos

    xorq %r10, %r10
    movq $1, %r10 # Posicion decimal 

    movq $10, %r11

    xorq %rax, %rax

.vloop: # Validacion   
    movb num1(%rcx, 1), %al # AL comparar caracteres
    incq %rcx
    
    cmpb $10, %al
    je .sloop # Fin de linea

    # No es digito
    cmpb $48, %al   
    jl _mostrarError 
  
    cmpb $57, %al
    jg _mostrarError

    #Vuelve al loop
    incq %r12
    jmp .vloop 
    
.sloop: # Inserta num1 en rdx
    xorq %rax, %rax

    decq %r12
    movb num1(%r12, 1), %al
    subq $48, %rax  # Convierte a decimal

    mulq %r10

    addq %rax, %r8 # Suma el digito

    cmpq $0, %r12
    je .end      #No hay mas digitos

    xorq %rax, %rax 
    movq %r10, %rax
    mulq %r11
    xorq %r10, %r10
    movq %rax, %r10 # Incrementa posicion
    
    jmp .sloop

.end:
    ret


_validarNum2: # Valida el segundo numero
    xorq %rdx, %rdx # Contador
    xorq %r9, %r9 # Numero 2
    xorq %r12, %r12

    xorq %r10, %r10
    movq $1, %r10

    movq $10, %r11

    xorq %rax, %rax

.vloop2: # Validacion   
    movb num2(%rdx, 1), %al # AL comparar caracteres
    incq %rdx
    
    cmpb $10, %al
    je .sloop2

    # No es digito
    cmpb $48, %al   
    jl _mostrarError 
  
    cmpb $57, %al
    jg _mostrarError

    # Vuelve al loop
    incq %r12
    jmp .vloop2 
    
.sloop2: # Inserta num2 en R9
    xorq %rax, %rax
    
    decq %r12
    movb num2(%r12, 1), %al
    subq $48, %rax # Convierte a decimal

    mulq %r10 

    addq %rax, %r9 # Suma el digito

    cmpq $0, %r12
    je .end2 # No hay mas digitos

    xorq %rax, %rax 
    movq %r10, %rax
    mulq %r11
    xorq %r10, %r10
    movq %rax, %r10 # Incrementa posicion
    
    jmp .sloop2

.end2:
    ret


_suma: # R8 = num1, R9 = num2, R10 = resultado
    xorq %r10, %r10
    addq %r8, %r10
    addq %r9, %r10
    ret

_resta: # R8 = Resultado
    subq %r9, %r8
    cmpq $0, %r8 
    jl .negar
    jge .end3

.negar: # Menor a 0
    neg %r8 

.end3:
    ret    


_mostrarSuma: # Suma esta en R10
    movq $1, %rax
    movq $1, %rdi
    movq $msjSuma, %rsi
    movq $msjSumaLen, %rdx
    syscall # Muestra mensaje

    movq %r10, %rax  # Mueve la suma
 
    call _mostrarRAX
    ret


_mostrarResta: # Diferencia esta en R11
    movq $1, %rax
    movq $1, %rdi
    movq $msjDif, %rsi
    movq $msjDifLen, %rdx
    syscall # Muestra mensaje
    
    movq %r8, %rax # Mueve diferencia

    call _mostrarRAX
    ret


_mostrarRAX: # Muestra el contenido de RAX
    movq $10, %r8 
    xorq %rcx, %rcx # Contador
    pushq $10

.rloop:
    xorq %rdx, %rdx
    divq %r8
    addq $48, %rdx # Conversion a caracter
    pushq %rdx

    cmpq $0, %rax
    je .hloop # RAX vacio 
    
    jmp .rloop

.hloop:
    xorq %r9, %r9 # Holder temporal
    popq %r9
    movq %r9, result(%rcx, 1)
    incq %rcx

    cmpq $10, %r9
    je .printStr

    jmp .hloop

.printStr:
    movq $1, %rax
    movq $1, %rdi
    movq $result, %rsi
    movq $25, %rdx
    syscall # Muestra el resultado

    movq $25, %rdi

.clean:
    movq $result, %rdi 
    movq $25, %rcx
    xor %rax, %rax
    rep stosb
    ret 
    

_mostrarError:
    movq $1, %rax
    movq $1, %rdi
    movq $msjError, %rsi
    movq $msjErrorLen, %rdx
    syscall # Muestra el mensaje

    call _end

_end: # Finaliza el programa
    movq $60, %rax 
    movq $0, %rdi
    syscall
