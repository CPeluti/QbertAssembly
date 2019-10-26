.data

CONTRABARRAene: .string "\n"
MATRIZ: .word 9, 9

.text
	la s0, MATRIZ
	li t0, 0
	li t1, 324
	li s1,1
WHILE:	beq t0, t1, FIM
	sw s1,0(s0)
	addi t0, t0, 4
	addi s0, s0, 4
	j WHILE
FIM:	
	li t1,9
	li t0,0
	la s0,MATRIZ
WHILE1: beq t0, t1, FIM1
	li a7,1
	li t2, 0
	WHILE2:	beq t2, t1, FIM2
		lw a0, 0(s0)
		addi s0,s0,4
		addi t2, t2, 1
		ecall
		j WHILE2
	FIM2:	addi t0, t0, 1
		li a7,4
		la a0, CONTRABARRAene
		ecall
		j WHILE1
FIM1:	li a7, 10
	ecall
