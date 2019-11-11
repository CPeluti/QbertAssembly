.data

CONTRABARRAene: .string "\n"
MATRIZ: .word 7,7
NUMERO_DE_LINHAS: .word 7

.text
	la s0,MATRIZ
	
	#PREENCHE_MATRIZ(S0,S1,S2)
	mv a1, s0#a1 = matriz
	li a2,1#valor para preencher a matriz
	lw a3,NUMERO_DE_LINHAS
	call PREENCHE_MATRIZ
	
	mv a1, s0#a1 = matriz
	li a2,2#valor para preencher a matriz

	call PREENCHE_MATRIZ_TRINGULO
	
	mv a1, s0#a1 = matriz

	call PRINTA_MATRIZ
	
	li a7, 10#return 0;
	ecall
	
	
PREENCHE_MATRIZ_TRINGULO:
	mv t0,a1
	mv t1,zero#contador de linhas
	mv t2,a3#t2=numero de linhas
	mv t3,zero#tamanho da coluna atual//comeca em 1
	WHILE_LINHAS: beq t1,t2,FIM_WHILE_LINHAS
		mv t4,zero#contador de colunas
		WHILE_COLUNAS:bgt t4,t3,FIM_WHILE_COLUNAS
			sw a2,0(t0)
			addi t4,t4,1#t4++
			addi t0,t0,4#t4++
			j WHILE_COLUNAS
		FIM_WHILE_COLUNAS:
		slli t5 ,t2,2
		add t0,t0,t5

		
		addi t3,t3,1#t3++
		addi t1,t1,1#t1++
		j WHILE_LINHAS
	FIM_WHILE_LINHAS:
	ret
	
PREENCHE_MATRIZ:#(S0//MATRIZ,S1//VALOR DE PREENCHIMENTO,S2//TAMANHO DA MATRIZ,s3//NUMERO DE LINHAS){
	
	mul t1,a3,a3#tamanho da matriz para o loop
	mv t0,zero# t0 = contador = 0
	WHILE:	bgt t0, t1, FIM#while t0!=t1{
		sw a2,0(a1)#matriz[contador] = s1
		addi t0, t0, 1#contador++
		addi a1, a1, 4
		j WHILE
	FIM:	#}
	ret 
#}

PRINTA_MATRIZ:
	mv t0,zero#t0 = contador linhas
	mv t2,a3#tamanho da matriz para o loop
	mv t3,a1
	WHILE_LINHAS1: bgt t0,t2,FIM_WHILE_LINHAS1
		mv t1,zero#t1 = contador colunas
		WHILE_COLUNAS1:beq t1,t2,FIM_WHILE_COLUNAS1
			li a7,1
			lw a0, 0(t3) 
			ecall
			addi t1,t1,1
			addi t3,t3,4
			j WHILE_COLUNAS1
		FIM_WHILE_COLUNAS1:
		li a7,4
		la a0, CONTRABARRAene
		ecall
		addi t1,t1,1
		j WHILE_LINHAS1
	FIM_WHILE_LINHAS1:
	ret
