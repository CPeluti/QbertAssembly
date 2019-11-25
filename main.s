.data
.include "tabuleiro.data"
.include "qbert-lateral.data"
MATRIZ: .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
NUMERO_DE_LINHAS: .word 7
.text
MAIN:
	la s0,MATRIZ
	
	mv a1, s0#a1 = matriz
	li a2,1
	lw a3,NUMERO_DE_LINHAS
	call PREENCHE_MATRIZ_TRINGULO
	li t0,2
	sw t0,0(s0)
	
	la a0,tabuleiro
	li t0,0xFF000000
	add a1,zero,t0
	call imprimeCoisas
	
	la a0,qbertlateral
	li t0,0xFF000958
	add a1,zero,t0
	call imprimeCoisas

	li a7,10	# syscall de exit - duda
	ecall
	
	
imprimeCoisas:                        # Funcao pra printar a imagem, recebe (a0 = origem da imagem, a1 = onde começa imagem, a2=altura, a3 = largura)
    lw a2, 4(a0)                 # altura
    lw a3, 0(a0)                 # largura
    addi a0, a0, 8                # vetor de bytes origem 
    for_linhas:	blez a2, fim_print # enquanto a2 > 0, print qbert
        mv t0, a1            # endereço do inicio linha atual
        mv t1, a3            # t1 = largura
        for_colunas:	blez t1, fim_da_largura # enquanto t1 > 0
            lw t2, 0(a0)        # le uma word do vetor
            sw t2, 0(t0)        # Salva no display a word lida do vetor 
            addi a0,a0,4        # a0 += 4
            addi t0,t0,4        # t0 += 4
            addi t1,t1,-4        # t1 -=4
            j for_colunas
        fim_da_largura:
            addi a1,a1,320         # desceu uma linha
            addi a2,a2,-1        # a2--
            j for_linhas
fim_print:    ret	

	
PREENCHE_MATRIZ_TRINGULO: #A1 = MATRIZ, A2=VALOR PARA PREENCHER, A3= NUMERO DE LINHAS
	mv t0,a1
	mv t1,zero#contador de linhas
	mv t2,a3#t2=numero de linhas
	mv t3,zero#tamanho da coluna atual//comeca em 1
	li t5,0
	WHILE_LINHAS: beq t1,t2,FIM_WHILE_LINHAS
		mv t4,zero#contador de colunas
		WHILE_COLUNAS:bgt t4,t3,FIM_WHILE_COLUNAS
			sw a2,0(t0)
			addi t4,t4,1#t4++
			addi t0,t0,4#t4++
			j WHILE_COLUNAS
		FIM_WHILE_COLUNAS:
		addi t5,t5,28
		mv t0,a1
		add t0,t0,t5
		addi t3,t3,1#t3++
		addi t1,t1,1#t1++
		j WHILE_LINHAS
	FIM_WHILE_LINHAS:
	ret