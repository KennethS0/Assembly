; --- Constants
%define MAX_EXP_LEN 1024
%define MAX_VAL_LEN 20

section .data
; --- User interaction
msgEquation db ' == Please type the equation you want evaluated (Up to 10 variables are allowed), end the expression with a ",":', 10
msgEquationLen equ $-msgEquation

msgInputExpression db ' == Given expression: '
msgInputExpressionLen equ $-msgInputExpression

msgCorrectedExpression db ' == Corrected expression: '
msgCorrectedExpressionLen equ $-msgCorrectedExpression

msgPostfixExpression db ' == Postfix Expression to evaluate: '
msgPostfixExpressionLen equ $-msgPostfixExpression

msgEnterValues db ' == Please enter the values for each one of the variables.', 10, '(Note that if a space character is detected the variable will not be considered as valid, also do not exceed 20 digits)', 10, 'End each variable with a ","', 10
msgEnterValuesLen equ $-msgEnterValues

msgLastVar db ' == This is the last variable found, do not end it with a comma, just press enter.', 10
msgLastVarLen equ $-msgLastVar

msgResult db ' == Result: '
msgResultLen equ $-msgResult

; --- User errors
msgExpressionError db 'Invalid expression format.', 10
msgExpressionErrorLen equ $-msgExpressionError

msgZeroDivError db 'Invalid expression, division by zero is not defined.', 10
msgZeroDivErrorLen equ $-msgZeroDivError

msgFractionError db 'Invalid expression, please check the values on any decimal point (The system can only handle double digits).', 10
msgFractionErrorLen equ $-msgFractionError

msgVariableError db 'Too many variables (The system can only handle from 0 to 10 variables).', 10
msgVariableErrorLen equ $-msgVariableError

msgValueError db 'Invalid value for variable.', 10
msgValueErrorLen equ $-msgValueError

msgOverflowError db ' === ERROR === ', 10, '    OVERFLOW', 10
msgOverflowErrorLen equ $-msgOverflowError

; --- Special
msgEqual db ' = '
msgEqualLen equ $-msgEqual

section .bss

; --- Reserved space for variables
vars resb MAX_EXP_LEN + 1
varPivot resb MAX_EXP_LEN

; --- Reserved space for values
values resb MAX_EXP_LEN
pivot resb MAX_VAL_LEN

; --- Reserved space for calculations
correspondingVar resb MAX_EXP_LEN
calcPivot resb MAX_VAL_LEN + 2
result resb MAX_VAL_LEN + 1

; --- Resereved space for expression
userExpression resb MAX_EXP_LEN
tempExpression resb MAX_EXP_LEN
verifiedExpression resb MAX_EXP_LEN
correctedExpression resb MAX_EXP_LEN
postfixExpression resb MAX_EXP_LEN