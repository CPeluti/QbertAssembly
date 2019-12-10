.data
.include "tabuleiro.data"
.include "qbert-lateral.data"
.include "menustart.data"
.include "youwin.data"
.include "you-died.data"
.include "quadrado0.data"
.include "quadrado1.data"
.include "quadrado2.data"
.include "quadrado3.data"
.include "quadrado4.data"
.include "quadrado5.data"
.include "quadrado6.data"
.include "quadrado7.data"
.include "quadrado8.data"
.include "quadrado9.data"
.include "quadrado10.data"
.include "quadrado11.data"
.include "quadrado12.data"
.include "quadrado13.data"
.include "quadrado14.data"
.include "quadrado15.data"
.include "quadrado16.data"
.include "quadrado17.data"
.include "quadrado18.data"
.include "quadrado19.data"
.include "quadrado20.data"
.include "quadrado21.data"
.include "quadrado22.data"
.include "quadrado23.data"
.include "quadrado24.data"
.include "quadrado25.data"
.include "quadrado26.data"
.include "quadrado27.data"
.include "quadrado28.data"


.macro escolheQuadrado(%numero,%label)
	li t6,%numero
	beq a5,t6,%label
.end_macro

# Numero de Notas a tocar
NUM: .word 13
# lista de nota,duração,nota,duração,nota,duração,...
NOTAS: 76,250,72,250,76,250,72,250,76,250,72,300,81,400,72,300,74,400,81,400,72,300,74,400,72,400

NUM2: .word 4
# lista de nota,duração,nota,duração,nota,duração,...
NOTAS2: 65,600,64,600,63,600,62,1000

MATRIZ: .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
MATRIZ_POSICOES: .word 0xff000a98,0,0,0,0,0,0,0xff002d84,0xff002dac,0,0,0,0,0,0xff005074,0xff005098,0xff0050c0,0,0,0,0,0xff007360,0xff007384,0xff0073a8,0xff0073d0,0,0,0,0xff00964c,0xff009670,0xff009698,0xff0096bc,0xff0096e4,0,0,0xff00b938,0xff00b960,0xff00b984,0xff00b9ac,0xff00b9d0,0xff00b9f8,0,0xff00dc28,0xff00dc4c,0xff00dc74,0xff00dc98,0xff00dcc0,0xff00dce4,0xff00dd08
MATRIZ_MORTE_DIREITA: .word 0,32,64,96,128,160,192
MATRIZ_MORTE_ESQUERDA: .word 0,28,56,84,112,140,168
MATRIZ_MORTE_BAIXO: .word 168,172,176,180,184,188,192

MATRIZ_COLORIDA: .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

TECLA_w: .word 0x77
TECLA_a: .word 0x61
TECLA_s: .word 0x73
TECLA_d: .word 0x64
TECLA_c: .word 0x63
TECLA_e: .word 0x65
NUMERO_DE_LINHAS: .word 7

.text
	
	la s0,MATRIZ 					#matriz de movimentação
	la s1,MATRIZ_POSICOES 				#matriz dos endereços do bitmap
	li s2,0 					#posicao do qbert
	li s3,0 					#flag de morto
	li s5,28 					#contador de espacos coloridos
	mv a1, s0					#a1 = matriz
	li a2,1						#a2 = 1
	lw a3,NUMERO_DE_LINHAS				#a3=7
	call PREENCHE_MATRIZ_TRINGULO			
	li t0,2						#t0=2
	sw t0,0(s0)					#s0[0]=2
	li s4,1						#s4=1 para a primeira execucao do programa
	
	la a0,menustart
	li t0,0xFF000000
	add a1,zero,t0
	call imprimeCoisas
	
	lw a3,TECLA_e
	li a1,0
	
STARTMENU: 	beq a1,a3,MAIN
	call LE_TECLA
	j STARTMENU
MAIN:	
	li a5,1						#se qbert morrer finaliza o jogo
	call LE_TECLA
	call PROCESSA_TECLA
	call CRIA_MATRIZ_COLORIDA
	bnez s3,FIM_JOGO_MORTE
	
	beq s4,s2,FIM_LACO_PRINT			#se a posicao continua a mesma, nao printa nada
	LACO_PRINT:
		
		la a0,tabuleiro
		li t0,0xFF000000
		add a1,zero,t0
		call imprimeCoisas			#printa tabuleiro
		
		li t4,49
		la t5,MATRIZ_COLORIDA
		WHILE_PRINTA_QUADRADOS: beqz t4,FIM_WHILE_PRINTA_QUADRADOS
			addi t4,t4,-1
			lw t6,0(t5)
			addi t5,t5,4
			beqz t6,WHILE_PRINTA_QUADRADOS
			mv a0,t6
			li a1,0xFF000000
			call imprimeCoisas

			j WHILE_PRINTA_QUADRADOS	
		
		FIM_WHILE_PRINTA_QUADRADOS:
		la a0,qbertlateral
		lw t0,0(s1)
		add a1,zero,t0
		call imprimeCoisas			#printa qbert
	FIM_LACO_PRINT:
	mv s4,s2					#s4 = s2
	blez s5,FIM_JOGO_VITORIA
	j MAIN
FIM_JOGO_MORTE: 
	
	
	
	la s0,NUM2		# define o endereço do número de notas
	lw s1,0(s0)		# le o numero de notas
	la s0,NOTAS2		# define o endereço das notas
	li t0,0			# zera o contador de notas
	li a2,97		# define o instrumento
	li a3,127		# define o volume

LOOP1:	beq t0,s1, FIM1		# contador chegou no final? então  vá para FIM
	lw a0,0(s0)		# le o valor da nota
	lw a1,4(s0)		# le a duracao da nota
	li a7,31		# define a chamada de syscall
	ecall			# toca a nota
	mv a0,a1		# passa a duração da nota para a pausa
	li a7,32		# define a chamada de syscal 
	ecall			# realiza uma pausa de a0 ms
	addi s0,s0,8		# incrementa para o endereço da próxima nota
	addi t0,t0,1		# incrementa o contador de notas
	j LOOP1			# volta ao loop
	
FIM1:	
	la a0,youdied
	li t0,0xFF000000
	add a1,zero,t0
	call imprimeCoisas
	
	li a0,40		# define a nota
	li a1,1500		# define a duração da nota em ms
	li a2,127		# define o instrumento
	li a3,127		# define o volume
	li a7,33		# define o syscall
	ecall			# toca a nota
	li a7,10		# define o syscall Exit
	ecall			# exit
	
FIM_JOGO_VITORIA:
	
	
	
	la s0,NUM		# define o endereço do número de notas
	lw s1,0(s0)		# le o numero de notas
	la s0,NOTAS		# define o endereço das notas
	li t0,0			# zera o contador de notas
	li a2,60		# define o instrumento
	li a3,127		# define o volume

LOOP2:	beq t0,s1, FIM2		# contador chegou no final? então  vá para FIM
	lw a0,0(s0)		# le o valor da nota
	lw a1,4(s0)		# le a duracao da nota
	li a7,31		# define a chamada de syscall
	ecall			# toca a nota
	mv a0,a1		# passa a duração da nota para a pausa
	li a7,32		# define a chamada de syscal 
	ecall			# realiza uma pausa de a0 ms
	addi s0,s0,8		# incrementa para o endereço da próxima nota
	addi t0,t0,1		# incrementa o contador de notas
	j LOOP2			# volta ao loop
	
	
	
FIM2:	
	la a0,youwin
	li t0,0xFF000000
	add a1,zero,t0
	call imprimeCoisas
	li a0,40		# define a nota
	li a1,1500		# define a duração da nota em ms
	li a2,127		# define o instrumento
	li a3,127		# define o volume
	li a7,33		# define o syscall
	ecall			# toca a nota
	
	li a7,10		# define o syscall Exit
	ecall			# exit
	
	
imprimeCoisas:                       		 	# Funcao pra printar a imagem, recebe (a0 = origem da imagem, a1 = onde comeca imagem, a2=altura, a3 = largura)
    lw a2, 4(a0)                 			# altura
    lw a3, 0(a0)                 			# largura
    addi a0, a0, 8                			# vetor de bytes origem 
    for_linhas:	blez a2, fim_print 			# enquanto a2 > 0, print qbert
        mv t0, a1            				# endere?o do inicio linha atual
        mv t1, a3            				# t1 = largura
        for_colunas:	blez t1, fim_da_largura 	# enquanto t1 > 0
            lw t2, 0(a0)        			# le uma word do vetor
            sw t2, 0(t0)        			# Salva no display a word lida do vetor 
            addi a0,a0,4        			# a0 += 4
            addi t0,t0,4        			# t0 += 4
            addi t1,t1,-4        			# t1 -=4
            j for_colunas
        fim_da_largura:
            addi a1,a1,320         			# desceu uma linha
            addi a2,a2,-1        			# a2--
            j for_linhas
fim_print:    ret	

	
PREENCHE_MATRIZ_TRINGULO: #A1 = MATRIZ, A2=VALOR PARA PREENCHER, A3= NUMERO DE LINHAS
	mv t0,a1
	mv t1,zero					#contador de linhas
	mv t2,a3					#t2=numero de linhas
	mv t3,zero					#tamanho da coluna atual//comeca em 1
	li t5,0
	WHILE_LINHAS: beq t1,t2,FIM_WHILE_LINHAS
		mv t4,zero				#contador de colunas
		WHILE_COLUNAS:bgt t4,t3,FIM_WHILE_COLUNAS
			sw a2,0(t0)
			addi t4,t4,1			#t4++
			addi t0,t0,4			#t0+=4
			j WHILE_COLUNAS
		FIM_WHILE_COLUNAS:
		addi t5,t5,28
		mv t0,a1
		add t0,t0,t5
		addi t3,t3,1				#t3++
		addi t1,t1,1				#t1++
		j WHILE_LINHAS
	FIM_WHILE_LINHAS:
	ret

LE_TECLA:
		
	### Apenas verifica se ha tecla pressionada
	li t1,0xFF200000				# carrega o endereco de controle do KDMMIO
	lw t0,0(t1)					# Le bit de Controle Teclado
	andi t0,t0,0x0001				# mascara o bit menos significativo
	mv a1,zero
   	beq t0,zero,FIM   	   			# Se nao tem tecla pressionada entao vai para FIM
  	lw t2,4(t1)  					# le o valor da tecla tecla
  	mv a1,t2
  	
FIM:	ret						# retorna

PROCESSA_TECLA:
	lw t0,TECLA_w					# t0='w'
	lw t1,TECLA_a					# t1='a'
	lw t2,TECLA_s					# t2='s'
	lw t3,TECLA_d 					# t3='d'
	lw t4,TECLA_c
	
	
	
	
	beq a1,t0,MOVIMENTO_W				#vai para a subrotina movimento_w se w foi pressionado
	beq a1,t1,MOVIMENTO_A				#vai para a subrotina movimento_a se a foi pressionado
	beq a1,t2,MOVIMENTO_S				#vai para a subrotina movimento_s se s foi pressionado
	beq a1,t3,MOVIMENTO_D				#vai para a subrotina movimento_d se d foi pressionado
	beq a1,t4,CHEAT
	ret
	CHEAT:
		li a5,1
		mv s5,zero
		ret
	MOVIMENTO_W:					#quando W for apertado				
		la t0,MATRIZ_MORTE_DIREITA		#Matriz com as posicoes que o qbert morre quando aperta W
		li t1,7					#Contador para checar a matriz
		addi t0,t0,24				#Matriz comeca na posicao 7	
		WHILE_MORTE_W: beqz t1,FIM_WHILE_MORTE_W				
			lw t2,0(t0)
			bne t2,s2,NAO_MORREU_W
			MORREU_W:
				li s3,1
				j FIM_MOVIMENTO_W
			NAO_MORREU_W:
			addi t0,t0,-4
			addi t1,t1,-1
			j WHILE_MORTE_W
		FIM_WHILE_MORTE_W:
		
		addi s0,s0,-28
		addi s1,s1,-28
		addi s2,s2,-28
		mv a5,s2
		
		
	FIM_MOVIMENTO_W:ret 
	MOVIMENTO_A:
		la t0,MATRIZ_MORTE_ESQUERDA		#Matriz com as posicoes que o qbert morre quando aperta W
		li t1,7					#Contador para checar a matriz
		addi t0,t0,24				#Matriz comeca na posicao 7	
		WHILE_MORTE_A: beqz t1,FIM_WHILE_MORTE_A				
			lw t2,0(t0)
			bne t2,s2,NAO_MORREU_A
			MORREU_A:
				li s3,1
				j FIM_MOVIMENTO_A
			NAO_MORREU_A:
			addi t0,t0,-4
			addi t1,t1,-1
			j WHILE_MORTE_A
		FIM_WHILE_MORTE_A:
		
		addi s0,s0,-32
		addi s1,s1,-32
		addi s2,s2,-32
		mv a5,s2
	FIM_MOVIMENTO_A:ret 
	MOVIMENTO_S:
		la t0,MATRIZ_MORTE_BAIXO		#Matriz com as posicoes que o qbert morre quando aperta W
		li t1,7					#Contador para checar a matriz
		addi t0,t0,24				#Matriz comeca na posicao 7	
		WHILE_MORTE_S: beqz t1,FIM_WHILE_MORTE_S				
			lw t2,0(t0)
			bne t2,s2,NAO_MORREU_S
			MORREU_S:
				li s3,1
				j FIM_MOVIMENTO_S
			NAO_MORREU_S:
			addi t0,t0,-4
			addi t1,t1,-1
			j WHILE_MORTE_S
		FIM_WHILE_MORTE_S:
		
		addi s0,s0,28
		addi s1,s1,28
		addi s2,s2,28
		mv a5,s2
	FIM_MOVIMENTO_S:ret 
	MOVIMENTO_D:
		la t0,MATRIZ_MORTE_BAIXO		#Matriz com as posicoes que o qbert morre quando aperta W
		li t1,7					#Contador para checar a matriz
		addi t0,t0,24				#Matriz comeca na posicao 7	
		WHILE_MORTE_D: beqz t1,FIM_WHILE_MORTE_D				
			lw t2,0(t0)
			bne t2,s2,NAO_MORREU_D
			MORREU_D:
				li s3,1
				j FIM_MOVIMENTO_D
			NAO_MORREU_D:
			addi t0,t0,-4
			addi t1,t1,-1
			j WHILE_MORTE_D
		FIM_WHILE_MORTE_D:
		
		addi s0,s0,32
		addi s1,s1,32
		addi s2,s2,32
		mv a5,s2
	FIM_MOVIMENTO_D:ret 
	
CRIA_MATRIZ_COLORIDA:
	la s6,MATRIZ_COLORIDA
	escolheQuadrado(0,QUADRADO1)
	escolheQuadrado(28,QUADRADO2)
	escolheQuadrado(32,QUADRADO3)
	escolheQuadrado(56,QUADRADO4)
	escolheQuadrado(60,QUADRADO5)
	escolheQuadrado(64,QUADRADO6)
	escolheQuadrado(84,QUADRADO7)
	escolheQuadrado(88,QUADRADO8)
	escolheQuadrado(92,QUADRADO9)
	escolheQuadrado(96,QUADRADO10)
	escolheQuadrado(112,QUADRADO11)
	escolheQuadrado(116,QUADRADO12)
	escolheQuadrado(120,QUADRADO13)
	escolheQuadrado(124,QUADRADO14)
	escolheQuadrado(128,QUADRADO15)
	escolheQuadrado(140,QUADRADO16)
	escolheQuadrado(144,QUADRADO17)
	escolheQuadrado(148,QUADRADO18)
	escolheQuadrado(152,QUADRADO19)
	escolheQuadrado(156,QUADRADO20)
	escolheQuadrado(160,QUADRADO21)
	escolheQuadrado(168,QUADRADO22)
	escolheQuadrado(172,QUADRADO23)
	escolheQuadrado(176,QUADRADO24)
	escolheQuadrado(180,QUADRADO25)
	escolheQuadrado(184,QUADRADO26)
	escolheQuadrado(188,QUADRADO27)
	escolheQuadrado(192,QUADRADO28)
	ret
	la s6,MATRIZ_COLORIDA
	QUADRADO1:
	lw t1,0(s6)
	bnez t1,JA_COLORIU1 
	addi s5,s5,-1
	JA_COLORIU1:
	la s6,MATRIZ_COLORIDA
	la t0,quadrado1
	sw t0,0(s6)
	ret
	QUADRADO2:
	lw t1,28(s6)
	bnez t1,JA_COLORIU2 
	addi s5,s5,-1
	JA_COLORIU2:
	la s6,MATRIZ_COLORIDA
	la t0,quadrado2
	sw t0,28(s6)
	ret
	QUADRADO3:
	lw t1,32(s6)
	bnez t1,JA_COLORIU3 
	addi s5,s5,-1
	JA_COLORIU3:
	la s6,MATRIZ_COLORIDA
	la t0,quadrado3
	sw t0,32(s6)
	ret
	QUADRADO4:
	lw t1,56(s6)
	bnez t1,JA_COLORIU4 
	addi s5,s5,-1
	JA_COLORIU4:
	la s6,MATRIZ_COLORIDA
	la t0,quadrado4
	sw t0,56(s6)
	ret
	QUADRADO5:
	lw t1,60(s6)
	bnez t1,JA_COLORIU5 
	addi s5,s5,-1
	JA_COLORIU5:
	la s6,MATRIZ_COLORIDA
	la t0,quadrado5
	sw t0,60(s6)
	ret
	QUADRADO6:
	lw t1,64(s6)
	bnez t1,JA_COLORIU6 
	addi s5,s5,-1
	JA_COLORIU6:
	la s6,MATRIZ_COLORIDA
	la t0,quadrado6
	sw t0,64(s6)
	ret
	QUADRADO7:
	lw t1,84(s6)
	bnez t1,JA_COLORIU7 
	addi s5,s5,-1
	JA_COLORIU7:
	la s6,MATRIZ_COLORIDA
	la t0,quadrado7
	sw t0,84(s6)
	ret
	QUADRADO8:
	la s6,MATRIZ_COLORIDA
	lw t1,88(s6)
	bnez t1,JA_COLORIU8 
	addi s5,s5,-1
	JA_COLORIU8:
	la t0,quadrado8
	sw t0,88(s6)
	ret
	QUADRADO9:
	lw t1,92(s6)
	bnez t1,JA_COLORIU9 
	addi s5,s5,-1
	JA_COLORIU9:
	la s6,MATRIZ_COLORIDA
	la t0,quadrado9
	sw t0,92(s6)
	ret
	QUADRADO10:
	lw t1,96(s6)
	bnez t1,JA_COLORIU10 
	addi s5,s5,-1
	JA_COLORIU10:
	la s6,MATRIZ_COLORIDA
	la t0,quadrado10
	sw t0,96(s6)
	ret
	QUADRADO11:
	lw t1,112(s6)
	bnez t1,JA_COLORIU11 
	addi s5,s5,-1
	JA_COLORIU11:
	la s6,MATRIZ_COLORIDA
	la t0,quadrado11
	sw t0,112(s6)
	ret
	QUADRADO12:
	lw t1,116(s6)
	bnez t1,JA_COLORIU12 
	addi s5,s5,-1
	JA_COLORIU12:
	la s6,MATRIZ_COLORIDA
	la t0,quadrado12
	sw t0,116(s6)
	ret
	QUADRADO13:
	lw t1,120(s6)
	bnez t1,JA_COLORIU13 
	addi s5,s5,-1
	JA_COLORIU13:
	la s6,MATRIZ_COLORIDA
	la t0,quadrado13
	sw t0,120(s6)
	ret
	QUADRADO14:
	lw t1,124(s6)
	bnez t1,JA_COLORIU14 
	addi s5,s5,-1
	JA_COLORIU14:
	la s6,MATRIZ_COLORIDA
	la t0,quadrado14
	sw t0,124(s6)
	ret
	QUADRADO15:
	lw t1,128(s6)
	bnez t1,JA_COLORIU15 
	addi s5,s5,-1
	JA_COLORIU15:
	la s6,MATRIZ_COLORIDA
	la t0,quadrado15
	sw t0,128(s6)
	ret
	QUADRADO16:
	lw t1,140(s6)
	bnez t1,JA_COLORIU16 
	addi s5,s5,-1
	JA_COLORIU16:
	la s6,MATRIZ_COLORIDA
	la t0,quadrado16
	sw t0,140(s6)
	ret
	QUADRADO17:
	lw t1,144(s6)
	bnez t1,JA_COLORIU17 
	addi s5,s5,-1
	JA_COLORIU17:
	la s6,MATRIZ_COLORIDA
	la t0,quadrado17
	sw t0,144(s6)
	ret
	QUADRADO18:
	lw t1,148(s6)
	bnez t1,JA_COLORIU18 
	addi s5,s5,-1
	JA_COLORIU18:
	la s6,MATRIZ_COLORIDA
	la t0,quadrado18
	sw t0,148(s6)
	ret
	QUADRADO19:
	lw t1,152(s6)
	bnez t1,JA_COLORIU19 
	addi s5,s5,-1
	JA_COLORIU19:
	la s6,MATRIZ_COLORIDA
	la t0,quadrado19
	sw t0,152(s6)
	ret
	QUADRADO20:
	lw t1,156(s6)
	bnez t1,JA_COLORIU20 
	addi s5,s5,-1
	JA_COLORIU20:
	la s6,MATRIZ_COLORIDA
	la t0,quadrado20
	sw t0,156(s6)
	ret
	QUADRADO21:
	lw t1,160(s6)
	bnez t1,JA_COLORIU21 
	addi s5,s5,-1
	JA_COLORIU21:
	la s6,MATRIZ_COLORIDA
	la t0,quadrado21
	sw t0,160(s6)
	ret
	QUADRADO22:
	lw t1,168(s6)
	bnez t1,JA_COLORIU22 
	addi s5,s5,-1
	JA_COLORIU22:
	la s6,MATRIZ_COLORIDA
	la t0,quadrado22
	sw t0,168(s6)
	ret
	QUADRADO23:
	lw t1,172(s6)
	bnez t1,JA_COLORIU23 
	addi s5,s5,-1
	JA_COLORIU23:
	la s6,MATRIZ_COLORIDA
	la t0,quadrado23
	sw t0,172(s6)
	ret
	QUADRADO24:
	lw t1,176(s6)
	bnez t1,JA_COLORIU24 
	addi s5,s5,-1
	JA_COLORIU24:
	la s6,MATRIZ_COLORIDA
	la t0,quadrado24
	sw t0,176(s6)
	ret
	QUADRADO25:
	lw t1,180(s6)
	bnez t1,JA_COLORIU25 
	addi s5,s5,-1
	JA_COLORIU25:
	la s6,MATRIZ_COLORIDA
	la t0,quadrado25
	sw t0,180(s6)
	ret
	QUADRADO26:
	lw t1,184(s6)
	bnez t1,JA_COLORIU26 
	addi s5,s5,-1
	JA_COLORIU26:
	la s6,MATRIZ_COLORIDA
	la t0,quadrado26
	sw t0,184(s6)
	ret
	QUADRADO27:
	lw t1,188(s6)
	bnez t1,JA_COLORIU27 
	addi s5,s5,-1
	JA_COLORIU27:
	la s6,MATRIZ_COLORIDA
	la t0,quadrado27
	sw t0,188(s6)
	ret
	QUADRADO28:
	lw t1,192(s6)
	bnez t1,JA_COLORIU28 
	addi s5,s5,-1
	JA_COLORIU28:
	la s6,MATRIZ_COLORIDA
	la t0,quadrado28
	sw t0,192(s6)
	ret
	
	
	
	
			
	
	
