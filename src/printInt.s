.section .data
fd2: .int 0
numstr: .ascii "0000"     

numtmp: .ascii "0000"     
.section .text
.global printInt

.type printInt,@function

printInt:
	movl %ebx, fd2
	movl $10, %ebx            
	movl $0, %ecx             

	leal numtmp, %esi         


continua_a_dividere:

	movl $0, %edx             
	divl %ebx                 

	addb $48, %dl             
	movb %dl, (%ecx,%esi,1)   

	inc %ecx                  

	cmp $0, %eax              

	jne continua_a_dividere


	movl $0, %ebx             

	leal numstr, %edx         

ribalta:

	movb -1(%ecx,%esi,1), %al 
	movb %al, (%ebx,%edx,1)   

	inc %ebx                  

	loop ribalta


stampa:

	movl %ebx, %edx           
	movl $4, %eax             
	movl $1, %ebx             
	leal numstr, %ecx         
	int $0x80        
	movl $4,%eax
    movl fd2,%ebx
	cmpl $0,%ebx
	je nf
    leal numstr,%ecx
    int $0x80         
nf:
	ret

	