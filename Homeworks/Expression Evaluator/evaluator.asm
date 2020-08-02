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

    ; Evaluates the post fix expression
    evaluatePostfix postfixExpression, r8

    ; Shows the result to the user
    print msgResult, msgResultLen
    printDigit r8, result

    jmp _exit



_expressionError:
    print msgExpressionError, msgExpressionErrorLen
    jmp _exit

_zeroDivError:
    print msgZeroDivError, msgZeroDivErrorLen
    jmp _exit

_fractionError:
    print msgFractionError, msgFractionErrorLen
    jmp _exit

_variableError:
    print msgVariableError, msgVariableErrorLen
    jmp _exit

_valueError:
    print msgValueError, msgValueErrorLen
    jmp _exit

_overflowError:
    print msgOverflowError, msgOverflowErrorLen

_exit:
    end
