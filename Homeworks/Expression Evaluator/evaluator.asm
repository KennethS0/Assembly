%include 'data.inc'
%include 'macros.inc'


; ============================
; ===    MAIN   PROGRAM    ===
; ============================

section .text
global _start:

_start:
    ; Obtains the expression from the user
    print msgEquation, msgEquationLen
    getExpression userExpression, MAX_EXP_LEN

    verifyExpression userExpression, verifiedExpression
    correctExpression verifiedExpression, correctedExpression
    getVariables correctedExpression, vars
    infix2postfix correctedExpression, postfixExpression

    ; Shows the given expression to the user
    print msgInputExpression, msgInputExpressionLen 
    print verifiedExpression, MAX_EXP_LEN

    ; Shows the corrected expression to the user
    print msgCorrectedExpression, msgCorrectedExpressionLen 
    print correctedExpression, MAX_EXP_LEN

    ; Shows the postfix expression to the user
    print msgPostfixExpression, msgPostfixExpressionLen
    print postfixExpression, MAX_EXP_LEN
    
    ; Shows detected variables and gets their data
    getVarData

    ; Get 

    ; Print result
    ; printDigit

    jmp _exit

_expressionError:
    print msgExpressionError, msgExpressionErrorLen
    jmp _options

_zeroDivError:
    print msgZeroDivError, msgZeroDivErrorLen
    jmp _options

_fractionError:
    print msgFractionError, msgFractionErrorLen
    jmp _options

_variableError:
    print msgVariableError, msgVariableErrorLen
    jmp _options

_valueError:
    print msgValueError, msgValueErrorLen
    jmp _options

_options:
    print msgOptions, msgOptionsLen
    jmp _exit

_exit:
    end
