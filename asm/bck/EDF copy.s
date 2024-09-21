.section .data
fd: .int 0
fd2: .int 0
lines: .int 0   #righe lette
valori: .int 0 #valori letti 4*lines
buffer: .string ""
numero: .int 0
Err_info: .ascii "Dettagli prodotto non validi\n"
.section .text
.global EDF
.type EDF,@function

EDF:

    movl %eax,fd
    movl %ebx,fd2


    mov $19, %eax 
    mov fd, %ebx  
    mov $0, %ecx  
    mov $0, %edx  
    int $0x80

    mov $19, %eax 
    mov fd2, %ebx 
    mov $0, %ecx  
    mov $0, %edx  
    int $0x80
read:
    mov $3, %eax        
    mov fd, %ebx        
    mov $buffer, %ecx   
    mov $1, %edx        
    int $0x80     

#Ora ho un carattere in buffer
    movb buffer,%al

    cmpb $10,%al
    je newline

    cmpb $44,%al
    je comma

    cmpb $0,%al
    je EOF

newline:
#se ho una nuova linea
    movl lines,%eax
    incl %eax
    movl %eax,lines
    jmp push_fine_riga
comma:
    movl valori,%eax
    incl %eax
    movl %eax,valori
    jmp push_numero

push_numero:
    call atoi
    pushl %eax
    jmp read
push_fine_riga:
    #SALVO NUMERO IN RIGA
    call atoi
    push %eax
    jmp controllo_riga

#Qui controllo i valori della riga per assicurarmi che rientrino nei limiti
controllo_riga:
    pushl %ebp
    movl %esp,%ebp
    movl $4,%ecx

controllo_loop:
    #ID
    movl (%ebp,%ecx,4),%eax
    decl %ecx
    cmpl $1,%eax
    jl ErroreInfo
    cmpl $10,%eax
    jg ErroreInfo

    #DURATA
    movl (%ebp,%ecx,4),%eax
    decl %ecx
    cmpl $1,%eax
    jl ErroreInfo
    cmpl $127,%eax
    jg ErroreInfo

    #SCADENZA
    movl (%ebp,%ecx,4),%eax
    decl %ecx
    cmpl $1,%eax
    jl ErroreInfo
    cmpl $100,%eax
    jg ErroreInfo

    #PRIORITA
    movl (%ebp,%ecx,4),%eax
    decl %ecx
    cmpl $1,%eax
    jl ErroreInfo
    cmpl $5,%eax
    jg ErroreInfo

    popl %ebp
    jmp read
ErroreInfo:
    movl $4,%eax
    movl $1,%ebx
    leal Err_info,%ecx
    movl $29,%edx
    int $0x80
    ret
EOF:
    movl valori,%eax
    incl %eax
    movl %eax,valori
    jmp push_numero
    ret
    