.section .data
fd: .int 0
fd2: .int 0
lines: .int 0   #righe lette
valori: .int 0 #valori letti 4*lines

numero: .int 0
Err_info: .ascii "Dettagli prodotto non validi\n"
Err_ordini: .ascii "Numero ordini non valido\n"
msg_HPF: .ascii "Pianificazione HPF:\n"
.section .bss
buffer: .ascii ""
.section .text
.global HPF
.type HPF,@function

HPF:

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

    movl $0, valori
    movl $0, lines
    xorl %edi,%edi
read:
    mov $3, %eax        
    mov fd, %ebx        
    leal buffer(%edi, 1), %ecx
    mov $1, %edx        
    int $0x80     
    
#Ora ho un carattere in buffer
    #movb buffer(%edi,1),%al
    cmpb $44,buffer(%edi,1)
    je comma

    cmpb $10,buffer(%edi,1)
    je newline

    test %eax,%eax
    jz EOF

    incl %edi
    jmp read
newline:
#se ho una nuova linea
    movb $0,buffer(%edi,1)
    //decl %edi
    //movb $0,buffer(%edi,1)
    xorl %edi,%edi
    movl lines,%eax
    incl %eax
    movl %eax,lines
    movl valori,%eax
    incl %eax
    movl %eax,valori
    jmp push_fine_riga
push_fine_riga:
    leal buffer,%esi
    call atoi
    pushl %eax
    jmp controllo_riga
comma:
    movb $0,buffer(%edi,1)
    xorl %edi,%edi
    movl valori,%eax
    incl %eax
    movl %eax,valori
    jmp push_numero

push_numero:
    leal buffer,%esi
    call atoi
    
    pushl %eax
    jmp read


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
    cmpl $127,%eax
    jg ErroreInfo

    #DURATA
    movl (%ebp,%ecx,4),%eax
    decl %ecx
    cmpl $1,%eax
    jl ErroreInfo
    cmpl $10,%eax
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
    popl %ebp
    jmp return
EOF:
#Controllo di avere massimo 10 righe(prodotti)
    movl lines,%eax
    cmpl $10,%eax
    jg Troppi_ordini

    jmp Ordinamento


Ordinamento:
    pushl %ebp
    movl %esp,%ebp
    
    addl $4,%ebp


Ordinamento_loop_o:
#Sposto righe e n valori in due registri
    movl lines, %edi #righe 
    movl valori, %edx
    subl $4, %edx
    movl $0,%ecx
Ordinamento_loop:
    decl %edi

    cmpl $0, %edi
    je fine_ciclo

    movl (%ebp,%edx,4),%eax #r1
    subl $4,%edx
    movl (%ebp,%edx,4),%ebx #r2

    cmpl %ebx,%eax
#Se pari vado a priorita piu alta
    je pari_priorita
#Altrimenti vai avanti
    jg Ordinamento_loop

Scambia:
    pushl %edx
#Sposto edx su ID riga B
    addl $3,%edx
    movl %edx,%ebx
#Sposto edx su ID riga A
    addl $4,%edx
    movl %edx,%eax
    pushl %edi #push di lines
    movl $1,%ecx
    pushl %ecx

    call Sorter

    popl %ecx
    popl %edi
    popl %edx
    jmp Ordinamento_loop

pari_priorita:
#sposto su scadenza riga A ordino crescente
    pushl %edx
    addl $5, %edx
    movl (%ebp,%edx,4),%eax #r1
    subl $4,%edx
    movl (%ebp,%edx,4),%ebx #r2

    cmpl %ebx,%eax
    popl %edx
    jle Ordinamento_loop

earliest_deadline:
    pushl %edx
#Sposto edx su ID riga B
    addl $3,%edx
    movl %edx,%ebx
#Sposto edx su ID riga A
    addl $4,%edx
    movl %edx,%eax
    
    pushl %edi #push di lines

    call Sorter
    movl $1,%ecx
    popl %edi
    popl %edx
    jmp Ordinamento_loop

fine_ciclo:
    cmpl $1,%ecx
    jne task_call

    jmp Ordinamento_loop_o
Troppi_ordini:
    movl $4,%eax
    movl $1,%ebx
    leal Err_ordini,%ecx
    movl $25,%edx
    int $0x80
    jmp return

task_call:
    movl lines,%eax
    movl valori,%ebx
    popl %ebp

    movl $4,%eax
    movl $1,%ebx
    leal msg_HPF,%ecx
    movl $20,%edx
    int $0x80
    movl lines,%edi
    movl valori,%edx
    call task
    jmp return

return:
    movl valori,%ecx
empty_stack:
    popl %eax
    loop empty_stack
    ret
