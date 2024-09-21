.section .data
FileI: .int 0
FileO: .int 0
NoParam: .ascii "Parametro non fornito\n"
NoParam_len: .long . - NoParam
FileI_err: .ascii "File non aperto correttamente"
FIleI_err_len:
.long . - FileI_err
Menu_msg:
.ascii "Seleziona un algoritmo, o esci:\n1) EDF\n2) HPF\n3) Esci\n\0"
Menu_msg_len:
.long .-Menu_msg
ph:
.ascii "placeholder\n\0"

scelta_err_msg:
.ascii "Scelta non valida\n"

.section .bss
input: .space 1

.section .text

.global  _start

_start:
#Faccio pop per arrivare al parametro
    popl %esi
    popl %esi

#ottengo il parametro del FileI input e controllo che sia stato inserito correttamente
    popl %esi
    testl %esi,%esi
    jz Errore_Par

#Se inserito correttamente apro il FileI con la syscall 5
    movl $5,%eax
    movl %esi,%ebx
    movl $0,%ecx
    int $0x80
#Controllo apertura FileI
    cmp $0,%eax
    jle Errore_FileI
#Se si salva corretamente ho il FileI descr. in eax
    movl %eax, FileI

#Ora prendo il valore del FileI output
/*Qui nel testo scrive SE viene inserito, 
quindi serve anche il caso in cui non c'è*/
    popl %esi
    testl %esi,%esi
    jz Chiamata_menu

#Se il FileI output è dato lo apro
    movl $5, %eax
    movl %esi, %ebx
    movl $1, %ecx  
    int $0x80

    cmp $0, %eax
    jl Errore_FileI

    movl %eax, FileO
    jmp Chiamata_menu

Errore_Par: 
#Messaggio di errore in caso non venga inserito il primo parametro
    movl $4,%eax
    movl $1,%ebx
    leal NoParam,%ecx
    movl NoParam_len,%edx
    int $0x80
    jmp exit

Errore_FileI:
#Messaggio di errore apertura di uno dei FileI
    movl $4,%eax
    movl $1,%ebx
    leal NoParam,%ecx
    movl NoParam_len,%edx
    int $0x80
    jmp exit

Chiamata_menu:
    movl FileI, %ebx
    jmp menu
    jmp exit

exit:
#Chiudo FileI input
    movl $6,%eax
    movl FileI,%ecx
    int $0x80

    movl $6,%eax
    movl FileO,%ecx
    int $0x80

    movl $1, %eax
    movl $0, %ebx
    int $0x80

menu:
    movl $4,%eax
    movl $1,%ebx
    leal Menu_msg,%ecx
    movl Menu_msg_len,%edx
    int $0x80

lettura_input:
	movl $3, %eax     
	movl $0, %ebx     
	leal input, %ecx  
	movl $1, %edx    
	int $0x80         

    movb input,%al

    
    cmpb $49,%al
    je scelta_1

    cmpb $50,%al
    je scelta_2

    cmpb $51,%al
    je scelta_3

    cmpb $10,%al
    jmp lettura_input

    jmp scelta_err

    scelta_1: #EDF
    /*movl $4,%eax
    movl $1,%ebx
    leal ph,%ecx
    movl $13,%edx
    int $0x80*/
    movb $0,input
    movl FileI,%eax
    movl FileO,%ebx
    call EDF
    jmp menu

    scelta_2:
    movb $0,input
    movl FileI,%eax
    movl FileO,%ebx
    call HPF
    jmp menu

    scelta_3:
    movl $6,%eax
    movl FileI,%ebx
    int $0x80

    movl $6,%eax
    movl FileO,%ebx
    int $0x80

    movl $1,%eax
    movl $0,%ebx
    int $0x80

    scelta_err:
    movl $4,%eax
    movl $1,%ebx
    leal scelta_err_msg,%ecx
    movl $18,%edx
    int $0x80
    jmp menu



