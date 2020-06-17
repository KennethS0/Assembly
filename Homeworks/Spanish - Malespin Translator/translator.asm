%include 'data.inc'
%include 'macros.inc'

section .data

section .bss
    outputmsg resb MAX_FILE_LEN
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

    cmp BYTE[translationChoice], 48      ; FIRST BYTE < 0
    jl _setUpError

    cmp BYTE[translationChoice], 49      ; FIRST BYTE > 0
    jg _setUpError

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
    getFileSize                        ; Puts size of file in rax
    mov r8, rax                         
    closeFile                          ; Closes the file

    openFile FILE_NAME, O_RDONLY
    readFile                           ; Puts information from file in 'buffer'
    closeFile

    jmp _translationChoice

_readPrompt:
    
    print msgMessage, msgMessageLen    ; Gets input from the command line
    getInput buffer, MAX_FILE_LEN
    
    getBufferLen buffer

    jmp _translationChoice


; --- TRANSLATION 
_translationChoice:
    cmp BYTE[translationChoice], 48
    je _spanishToMalespin

    cmp BYTE[translationChoice], 49
    je _malespinToSpanish

_spanishToMalespin:
    translate buffer, spanishLookUp, malespinLookUp, r8, outputmsg
    jmp _createOutPut

_malespinToSpanish:
    translate buffer, malespinLookUp, spanishLookUp, r8, outputmsg
    jmp _createOutPut

_createOutPut:
    mov rax, r15
    printRax

    openFile OUTPUT_FILE_NAME, O_CREAT+O_WRONLY ; Creates the output file and opens it as write only
    writeFile outputmsg, r8
    
    closeFile
    
    ; Shows statistic to user
    print msgOutputFile, msgOutputFileLen
    print OUTPUT_FILE_NAME, OUTPUT_FILE_NAME_LEN
    print msgTotalWords, msgTotalWordsLen
    
    mov rax, r14
    printRax

    print msgTotalLetters, msgTotalLettersLen
    
    mov rax, r12
    printRax

    print msgTotalChangedWords, msgTotalChangedWordsLen
    
    mov rax, r15
    printRax

    print msgTotalChangedLetters, msgTotalChangedLettersLen

    mov rax, r13
    printRax


    print msgChangedLettersRate, msgChangedWordsLettersLen

    getPercentage r13, r12
    printRax

    print msgChangedWordsRate, msgChangedWordsRateLen

    getPercentage r15, r14
    printRax

    jmp _exit

; --- ERROR FLAGS
_setUpError:
    print msgSetUpError, msgSetUpErrorLen
    getInput retryChoice, 2

    cmp BYTE[retryChoice], 48
    je _reset

    jmp _exit

_reset:
    clear retryChoice, CHOICE_SIZE
    clear readingChoice, CHOICE_SIZE
    clear translationChoice, CHOICE_SIZE

    jmp _start

_exit:
    exit