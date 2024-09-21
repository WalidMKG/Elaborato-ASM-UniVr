.section .data
.section .text
.global atoi
.type atoi,@function
atoi:
  movl $0, %ecx            
  movl $0, %ebx            
ripeti:

  movb (%ecx,%esi,1), %bl

  cmp $10, %bl             
  je fine

  subb $48, %bl            
  movl $10, %edx
  mulb %dl               
  addl %ebx, %eax

  inc %ecx
  jmp ripeti

fine:
    ret
