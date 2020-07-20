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

    ; Shows the given expression to the user
    print msgInputExpression, msgInputExpressionLen 
    print verifiedExpression, MAX_EXP_LEN
    print newLine, newLineLen

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

_options:
    print msgOptions, msgOptionsLen
    jmp _exit

_exit:
    end
