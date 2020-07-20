; --- Constants
%define MAX_VAR_LEN 10
%define MAX_VAL_LEN 10
%define MAX_EXP_LEN 1024

section .data
; --- User interaction
msgEquation db 'Please type the equation you want evaluated (variables are allowed), end the expression with a ",":', 10, '(Anything after the "," will be ignored):', 10
msgEquationLen equ $-msgEquation

msgInputExpression db 'Given expression: '
msgInputExpressionLen equ $-msgInputExpression

; --- User errors
msgExpressionError db 'Invalid expression format, enter the corresponding number to continue:', 10
msgExpressionErrorLen equ $-msgExpressionError

msgZeroDivError db 'Invalid expression, division by zero is not defined. Enter the corresponding number to continue:', 10
msgZeroDivErrorLen equ $-msgZeroDivError

msgFractionError db 'Invalid expression, please check the values on any decimal point (The system can only handle double digits). Enter the corresponding number to continue:', 10
msgFractionErrorLen equ $-msgFractionError

msgOptions db  '(1) Restart', 10, '(?) Anything else will end the program', 10
msgOptionsLen equ $-msgOptions

; --- Special
newLine db 10
newLineLen equ $-newLine
section .bss

; --- Reserved space for variables
vars resb MAX_VAR_LEN
var1 resb MAX_VAR_LEN
var2 resb MAX_VAR_LEN
var3 resb MAX_VAR_LEN
var4 resb MAX_VAR_LEN
var5 resb MAX_VAR_LEN
var6 resb MAX_VAR_LEN
var7 resb MAX_VAR_LEN
var8 resb MAX_VAR_LEN
var9 resb MAX_VAR_LEN
var10 resb MAX_VAR_LEN

; --- Reserved space for values
value1 resb MAX_VAL_LEN
value2 resb MAX_VAL_LEN
value3 resb MAX_VAL_LEN
value4 resb MAX_VAL_LEN
value5 resb MAX_VAL_LEN
value6 resb MAX_VAL_LEN
value7 resb MAX_VAL_LEN
value8 resb MAX_VAL_LEN
value9 resb MAX_VAL_LEN
value10 resb MAX_VAL_LEN

; --- Resereved space for expression
userExpression resb MAX_EXP_LEN
tempExpression resb MAX_EXP_LEN
verifiedExpression resb MAX_EXP_LEN
correctedExpression resb MAX_EXP_LEN