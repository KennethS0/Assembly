section .data
    ; --- USER INTERACTION
    msgTranslationChoice db "Digite el numero correspondiente: ", 10, "(0) Espanol -> Malespin", 10, "(1) Malespin -> Espanol", 10
    msgTranslationChoiceLen equ $-msgTranslationChoice

    msgReadingChoice db "Digite el numero correspondiente:", 10, "(0) Leer de terminal.", 10, "(1) Leer de archivo.", 10
    msgReadingChoiceLen equ $-msgReadingChoice

    msgFileName db 'Ingrese el nombre del archivo:',0xA,0xD
    msgFileNameLen equ $-msgFileName

    ; --- USER INPUT ERROR
    msgSetUpError db "Hubo un error con su input. Desea salir del programa o reiniciarlo. Digite el numero correspondiente:", 10, "(0) Salir.", 10, "(1) Reiniciar.", 10
    msgSetUpErrorLen equ $-msgSetUpError

    ; --- LOOK UP TABLES
    spanishLookUp db "aibfpAIBFP"
    malespinLookUp db "eotgmEOTGM"

    ; --- DEBUGGING
    msgFlag1 db "IM HERE 1", 10
    msgFlag1Len equ $-msgFlag1

    msgFlag2 db "IM HERE 2", 10
    msgFlag2Len equ $-msgFlag2

    ; --- OUTPUT
    OUTPUT_FILE_NAME db "translation.txt", 0


    ; --- CONSTANTS 
    %define CHOICE_SIZE 2
    %define FILE_PATH_SIZE 20
    %define LOOK_UP_LEN 10
    %define MAX_FILE_LEN 2048

    ; --- STANDARD IO
    STDIN equ 0
    STDOUT equ 1
    STDERR equ 2

    ; --- FILE OPENING INSTRUCTIONS
    O_RDONLY equ 0
    O_WRONLY equ 1
    O_RDWR equ 2

    ; --- SYSTEM CALLS
    SYS_READ equ 0
    SYS_WRITE equ 1
    SYS_OPEN equ 2
    SYS_CLOSE equ 3
    SYS_CREATE equ 65
    SYS_EXIT equ 60