.data
.include "tabuleiro.data"
.include "qbert-lateral.data"
MATRIZ: .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
MATRIZ_POSICOES: .word 0xff000a98,0,0,0,0,0,0,0xff002d84,0xff002dac,0,0,0,0,0,0xff005074,0xff005098,0xff0050c0,0,0,0,0,0xff007360,0xff007384,0xff0073a8,0xff0073d0,0,0,0,0xff00964c,0xff009670,0xff009698,0xff0096bc,0xff0096e4,0,0,0xff00b938,0xff00b960,0xff00b984,0xff00b9ac,0xff00b9d0,0xff00b9f8,0,0xff00dc28,0xff00dc4c,0xff00dc74,0xff00dc98,0xff00dcc0,0xff00dce4,0xff00dd08
TECLA_w: .word 0x77
TECLA_a: .word 0x61
TECLA_s: .word 0x73
TECLA_d: .word 0x64
NUMERO_DE_LINHAS: .word 7
.text

	la s0,MATRIZ
	la s1,MATRIZ_POSICOES
	
	mv a1, s0#a1 = matriz
	li a2,1
	lw a3,NUMERO_DE_LINHAS
	call PREENCHE_MATRIZ_TRINGULO
	li t0,2
	sw t0,0(s0)
	
MAIN:	
	
	la a0,tabuleiro
	li t0,0xFF000000
	add a1,zero,t0
	call imprimeCoisas
	
	la a0,qbertlateral
	lw t0,84(s1)
	add a1,zero,t0
	call imprimeCoisas
	
	call LE_TECLA

	j MAIN
FIM_JOGO: li a7,10	# syscall de exit - duda
	ecall
	
	
imprimeCoisas:                        # Funcao pra printar a imagem, recebe (a0 = origem da imagem, a1 = onde comeca imagem, a2=altura, a3 = largura)
    lw a2, 4(a0)                 # altura
    lw a3, 0(a0)                 # largura
    addi a0, a0, 8                # vetor de bytes origem 
    for_linhas:	blez a2, fim_print # enquanto a2 > 0, print qbert
        mv t0, a1            # endere�o do inicio linha atual
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

LE_TECLA:
		
	### Apenas verifica se h� tecla pressionada
	li t1,0xFF200000
	KEY2:			# carrega o endere�o de controle do KDMMIO
		lw t0,0(t1)			# Le bit de Controle Teclado
		andi t0,t0,0x0001		# mascara o bit menos significativo
	   	beq t0,zero,KEY2   	   	# Se n�o h� tecla pressionada ent�o vai para FIM
  		lw t2,4(t1)  			# le o valor da tecla tecla
  		mv a0,t2
	FIM:	ret				# retorna
	
PROCESSA_TECLA:
	
