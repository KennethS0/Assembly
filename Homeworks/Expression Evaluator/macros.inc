section .text


; --- Prints a message on the terminal
; %1: String
; %2: Length of the string
%macro print 2
    mov rax, 1
    mov rdi, 1
    mov rsi, %1
    mov rdx, %2
    syscall
%endmacro


; --- Gets user input
; %1 : Reserved memory
; %2 : Length in bytes
%macro getInput 2
    mov rax, 0
    mov rdi, 0
    mov rsi, %1
    mov rdx, %2
    syscall
%endmacro


; --- Stops the program from running
%macro end 0
    mov rax, 60
    mov rdi, 0
    syscall
%endmacro


; --- Clears a chunk of reserved memory
; %1 : Reserved memory
; %2 : Length in bytes
%macro clear 2
    mov rdi, %1
    mov rcx, %2
    xor rax, rax
    rep stosb
%endmacro


; --- Saves the expression to be evaluated
; %1 : String (expression)
; %2 : Length in bytes
%macro getExpression 2
    
    getInput tempExpression, %2

    ; Clears the counter
    xor rcx, rcx ; - String counter
    xor r15, r15 ; - Overall character counter

    %%_loop:
        ; If r15 surpasses %2, an error is shown
        cmp r15, %2
        jg _expressionError

        mov bl, BYTE[tempExpression + rcx]

        ; Finds the end of the expression
        cmp bl, ','
        je %%_stop
        
        ; ---- VALIDATIONS -----
        cmp bl, ' '
        je %%_valid

        cmp bl, 10
        je %%_enter

        cmp bl, '%'
        je %%_valid

        cmp bl, '*'
        jl _expressionError

        cmp bl, '9'
        jle %%_valid

        cmp bl, 'A'
        jl _expressionError

        cmp bl, 'Z'
        jle %%_valid

        cmp bl, 'a'
        jl _expressionError

        cmp bl, 'z'
        jg _expressionError 

    %%_valid:
        ; Copies information
        mov BYTE[%1 + r15], bl  
    
        inc rcx
        inc r15

    %%_enter:
        ; Checks for enter character (no need to save it)
        cmp BYTE[tempExpression + rcx], 10
        je %%_redo

        jmp %%_loop

    ; Restarts the loop
    %%_redo:
        clear tempExpression, %2
        getInput tempExpression, %2

        ; - Clear the string counter
        xor rcx, rcx
        jmp %%_loop

    %%_stop:

%endmacro


; --- Validates the expression and gets rid of spaces
; %1 : String (expression)
; %2 : String (Empty memory)
%macro verifyExpression 2
    ; Clears counter
    xor rcx, rcx ; Old string counter
    xor r15, r15 ; New string counter

    ; First loop to get rid of spaces
    %%_sloop:
        ; Copies the information
        mov al, BYTE[%1 + rcx]
        
        cmp al, 0
        je %%_verify
        
        ; Checks space characters to detect errors
        cmp al, ' '
        je %%_verifySpace

        mov BYTE[%2 + r15], al
        inc r15

        jmp %%_incrementS

    %%_verifySpace:
        
    ; =======     TO DO     =======
    ;    ABC * 23 45 + 1 -> INVALID
    ; 12   34 -> INVALID
    ; 12 + a b - 4 -> INVALID
    ; 411 + 2 bc % 2 -> VALID
    ; =============================

    %%_incrementS:
        inc rcx
        jmp %%_sloop

    %%_verify:
        xor rcx, rcx ; Character counter
        xor r15, r15 ; Special counter

        ; Checks if the first character is a valid number
        ; or variable
        cmp BYTE[%2 + rcx], '0'
        jl _expressionError

        inc rcx

    ; Second loop to verify the expression
    ; saved in %2
    %%_vloop:
        mov bl, BYTE[%2 + rcx]
        mov al, BYTE[%2 + rcx + 1]

        ; Reaches the end of the string
        cmp bl, 0
        je %%_stop

        ; Validations
        cmp bl, '+'
        je %%_sumVerify

        cmp bl, '-'
        je %%_sumVerify

        cmp bl, '/'
        je %%_divVerify

        cmp bl, '%'
        je %%_divVerify

        cmp bl, '*'
        je %%_mulVerify

        cmp bl, '.'
        je %%_dotVerify

        jmp %%_incrementV

        ; Verification of special characters
        ; Addition and subtraction
        %%_sumVerify: 

            cmp al, '0'
            jl _expressionError

            jmp %%_incrementV
    
        ; Division and modulo
        %%_divVerify: 

            cmp al, '0'
            je _zeroDivError
            jl _expressionError

            jmp %%_incrementV
        
        ; Multiplication and power
        %%_mulVerify:
                        
            cmp al, '*'
            je %%_checkStars
            
            ; Validations
            cmp al, '0'
            jl _expressionError

            cmp al, 'z'
            jle %%_incrementV

            ; Check amount of '*' (More than 2 -> Error)
            %%_checkStars:
                mov al, BYTE[%2 + rcx + 2]
                
                ; Goes into the last character
                cmp al, 0
                inc rcx
                je %%_incrementV 

                ; Checks if what follows isnt a number or variable
                cmp al, '0'
                jl _expressionError

        ; Decimal
        %%_dotVerify:
            cmp BYTE[%2 + rcx - 1], '9'
            jg _fractionError

            cmp al, '0'
            jl _expressionError

            cmp al, '9'
            jg _fractionError
            jle %%_dotDigits

            jmp %%_incrementV

            ; Loop to count amount of digits after decimal
            %%_dotDigits:
                cmp r15, 3
                jge _fractionError

                cmp BYTE[%2 + rcx + r15], 0
                je %%_break

                cmp BYTE[%2 + rcx + r15 + 1], '0'
                jl %%_break

                cmp BYTE[%2 + rcx + r15 + 1], '9'
                jg %%_break

                inc r15
                jmp %%_dotDigits

            %%_break:
            xor r15, r15 ; Clear special counter
            jmp %%_incrementV

        %%_incrementV:
            inc rcx
            jmp %%_vloop

    %%_stop:

%endmacro


; --- Corrects the expression and puts it in a better format
; --- (Changes '**' to '^' )
; --- (Adds zeroes to every fractionary part of a number)
; %1 : String (expression to correct)
; %2 : String (Empty memory)
%macro correctExpression 2
    xor rcx, rcx ; %1 Counter
    xor r15, r15 ; %2 Counter
    
    ; Copies the information and corrects it on the way
    %%_loop:
        mov bl, BYTE[%1 + rcx]

        cmp bl, '*'
        je %%_checkStar

        cmp bl, '.'
        je %%_checkDot

        cmp bl, '0'
        je %%_increment

        cmp bl, '9'
        je %%_checkNumber

    %%_checkStar:

    %%_checkDot:

    %%_increment:

    %%_checkNumber:     

%endmacro

; --- Gets all the variables in the expression
; %1 : String (expression to correct)
; %2 : String (Empty memory)
%macro getVariables 2

%endmacro
