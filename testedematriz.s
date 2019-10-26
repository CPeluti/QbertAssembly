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
FIM:	li t0, 0
	li a7, 1
WHILE1: beq t2, 9, FIM1
	li t4, 0
	WHILE2:	beq t4, 9, FIM2
		slli t5, t3, 2
		add t5, t5, 4
		lw a0, t5(s0)
		addi t4, 4
		j WHILE2
	FIM2:	addi t3, t3, 4
		la a0, CONTRABARRAENE
		ecall
		j WHILE1
FIM1:	li a7, 10
	ecall