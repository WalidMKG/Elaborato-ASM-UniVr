.section .data

.section .text
.global Sorter
.type Sorter,@function
Sorter:
    #I
    movl (%ebp, %eax, 4), %ecx # c = a
    movl (%ebp, %ebx, 4), %edx # d = b
    leal (%ebp, %eax, 4), %esi # s = &a
    movl %edx, (%esi)          # *s = d
    leal (%ebp, %ebx, 4), %esi # s = &b
    movl %ecx, (%esi)          # *s = c
    decl %eax
    decl %ebx
    #DURATA
    movl (%ebp, %eax, 4), %ecx
    movl (%ebp, %ebx, 4), %edx
    leal (%ebp, %eax, 4), %esi
    movl %edx, (%esi)
    leal (%ebp, %ebx, 4), %esi
    movl %ecx, (%esi)
    decl %eax
    decl %ebx
    #SCADENZA
    movl (%ebp, %eax, 4), %ecx
    movl (%ebp, %ebx, 4), %edx
    leal (%ebp, %eax, 4), %esi
    movl %edx, (%esi)
    leal (%ebp, %ebx, 4), %esi
    movl %ecx, (%esi)
    decl %eax
    decl %ebx
    #PRIORITA
    movl (%ebp, %eax, 4), %ecx
    movl (%ebp, %ebx, 4), %edx
    leal (%ebp, %eax, 4), %esi
    movl %edx, (%esi)
    leal (%ebp, %ebx, 4), %esi
    movl %ecx, (%esi)
    decl %eax
    decl %ebx    
    ret

