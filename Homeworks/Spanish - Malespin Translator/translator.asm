%include 'data.inc'
%include 'macros.inc'

section .data

section .bss
    ; --- FILE MANAGEMENT
    descriptor resb 4
    buffer resb MAX_FILE_LEN

    ; --- USER INTERACTION
    translationChoice resb CHOICE_SIZE
    readingChoice resb CHOICE_SIZE

    FILE_NAME resb FILE_PATH_SIZE

section .text


; ============================
; ===    MAIN   PROGRAM    ===
; ============================
global _start

_start:

    ; --- USER INTERACTION ---
    print msgTranslationChoice, msgTranslationChoiceLen
    getInput translationChoice, CHOICE_SIZE

    cmp BYTE[translationChoice + 1], 10 ; INPUT VALIDATION
    jne _setUpError

    print msgReadingChoice, msgReadingChoiceLen
    getInput readingChoice, CHOICE_SIZE
    
    cmp BYTE[readingChoice + 1], 10 ; INPUT VALIDATION
    jne _setUpError

    ; --- JUMP TO RESPECTIVE CHOICE
    cmp BYTE[readingChoice], 48
    jl _setUpError           ; FIRST BYTE < '0'
    je _readPrompt                            

    cmp BYTE[readingChoice], 49
    jg _setUpError           ; FIRST BYTE > '1'
    je _readFile


_readFile:
    print msgFileName, msgFileNameLen  ; Prints file input message

    getInput FILE_NAME, FILE_PATH_SIZE ; Gets the file name
    replaceFinal FILE_NAME, 0          ; Changes 10 to 0 at the end of the string
    openFile FILE_NAME, O_RDONLY       ; Opens the file as 'read-only'
    readFile                           ; Puts information from file

    print buffer, MAX_FILE_LEN

    closeFile                          ; Closes the file

    exit

_readPrompt:
    print msgFlag2, msgFlag2Len
    exit


; --- ERROR FLAGS
_setUpError:
    print msgSetUpError, msgSetUpErrorLen    
    exit