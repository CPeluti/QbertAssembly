#########################################################
#		0=FORA DO TABULEIRO			#
#		1=PLATAFORMA				#
#		2=QBERT					#
#		3=INIMIGO				#
#########################################################

.data
CONTRABARRAene: .string "\n"
MATRIZ: .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
NUMERO_DE_LINHAS: .word 7

.text
	la s0,MATRIZ
	
	#PREENCHE_MATRIZ(S0,S1,S2)
	mv a1, s0#a1 = matriz
	li a2,1#valor para preencher a matriz
	lw a3,NUMERO_DE_LINHAS
	call PREENCHE_MATRIZ_TRINGULO
	
	mv a1, s0#a1 = matriz
	lw a3,NUMERO_DE_LINHAS
	call PRINTA_MATRIZ
	
	li a7, 10#return 0;
	ecall
	
	
PREENCHE_MATRIZ_TRINGULO: #funcao para preencher a matriz a1 de razão a3 de maneira triangular com o argumento a2
	mv t0,a1
	mv t1,zero#contador de linhas
	mv t2,a3#t2=numero de linhas
	mv t3,zero#tamanho da coluna atual//comeca em 1
	addi t5,zero,28
	WHILE_LINHAS: beq t1,t2,FIM_WHILE_LINHAS
		mv t4,zero#contador de colunas
		WHILE_COLUNAS:bgt t4,t3,FIM_WHILE_COLUNAS
			sw a2,0(t0)
			addi t4,t4,1#t4++
			addi t0,t0,4#t4++
			j WHILE_COLUNAS
		FIM_WHILE_COLUNAS:		
		addi t3,t3,1#t3++
		addi t1,t1,1#t1++
		mv t0,a1#reseta t0
		mul t6,t5,t1#t6=28*numero da linha
		add t0,t0,t6#t0+=t6
		j WHILE_LINHAS
	FIM_WHILE_LINHAS:
	ret


PRINTA_MATRIZ: #funcao para printar a matriz a1 de razao a3
	mv t0,zero#t0 = contador linhas
	mv t2,a3#tamanho da matriz para o loop
	mv t3,a1#t3=matriz
	WHILE_LINHAS1: beq t0,t2,FIM_WHILE_LINHAS1
		mv t1,zero#t1 = contador colunas
		WHILE_COLUNAS1:beq t1,t2,FIM_WHILE_COLUNAS1
			li a7,1
			lw a0, 0(t3) #a0=matriz[t0][t1]
			ecall#printf a0
			addi t1,t1,1#t1++
			addi t3,t3,4
			j WHILE_COLUNAS1
		FIM_WHILE_COLUNAS1:
		li a7,4
		la a0, CONTRABARRAene
		ecall#printf("\n")
		addi t0,t0,1#t0++
		j WHILE_LINHAS1
	FIM_WHILE_LINHAS1:
	ret
