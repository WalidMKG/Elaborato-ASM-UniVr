.section .data
msg_EDF: .ascii "Pianificazione EDF:\n"
conclusione_msg: .ascii "Conclusione: "
penalty_msg: .ascii "Penalty: "
valori: .int 0
lines: .int 0
penalty: .int 0
due_punti: .byte ':'
newline: .byte '\n'
.section .text

.global task
.type task,@function

#edi = righe
#edx = valori
#ecx = unita tempo
task:
    pushl %ebp
    movl %esp,%ebp
    addl $8,%ebp


    movl $0,%ecx  #tempo
    movl %edx,valori

    movl $0,%edi
    movl $0,penalty
    
task_loop:

    cmpl $0,%edx
    je fine
    decl %edx
    
    #numero deve essere in eax
    movl (%ebp,%edx,4),%eax
    pushl %edx
    pushl %ecx
    call printInt
    
    
    #stampa ':'
	movl $4, %eax             
	movl $1, %ebx             
	movl $due_punti, %ecx     
    movl $1,%edx    
	int $0x80

    #STAMPA INIZIO     
    popl %ecx
    movl %ecx,%eax
    pushl %ecx
    call printInt

    #STAMPA NEWLINE
    movl $4, %eax             
	movl $1, %ebx             
	movl $newline, %ecx     
    movl $1,%edx    
	int $0x80

    popl %ecx
    popl %edx

    #Incremento tempo di durata ciclo
    decl %edx
    addl (%ebp,%edx,4),%ecx

    #sposto scadenza prodotto in %ebx
    decl %edx
    movl (%ebp,%edx,4),%ebx

    #Se sono sopra la scadenza modifico penalita
    cmpl %ebx,%ecx
    jg ritardo
    decl %edx
    jmp task_loop
ritardo:
    pushl %ecx
    pushl %edx
    subl %ebx,%ecx
    movl %ecx,%eax #ritardo scadenza
    
    movl (%ebp,%edx,4),%ebx #priotita
    
    mul %ebx #100*5 = 500 max ris->%eax parte bassa

    addl %eax,penalty

    popl %edx
    popl %ecx #resetto ecx
    cmpl $0, %edx
    je fine

    decl %edx
    
    jmp task_loop

fine:
    pushl %ecx
    movl $4, %eax             
	movl $1, %ebx             
	movl $conclusione_msg, %ecx     
    movl $13,%edx    
	int $0x80
    popl %eax
    call printInt #CONCLUSIONE: 

    movl $4, %eax             
	movl $1, %ebx             
	movl $newline, %ecx     
    movl $1,%edx    
	int $0x80

    movl $4, %eax             
	movl $1, %ebx             
	movl $penalty_msg, %ecx     
    movl $9,%edx    
	int $0x80

    movl penalty,%eax
    call printInt


    movl $4, %eax             
	movl $1, %ebx             
	movl $newline, %ecx     
    movl $1,%edx    
	int $0x80


    popl %ebp

    ret
    