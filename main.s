.data
.include "tabuleiro.data"



.text


# ANA



.text

IMPRIME_TABULEIRO:
FORA1:	li t1,0xFF000000	# endereco inicial da Memoria VGA - Frame 1
	li t2,0xFF012C00	# endereco final 
	la s1,tabuleiro		# endereço dos dados da tela na memoria
	addi s1,s1,8		# primeiro pixels depois das informações de nlin ncol
LOOP2: 	beq t1,t2,FIM		# Se for o último endereço então sai do loop
	lw t3,0(s1)		# le um conjunto de 4 pixels : word
	sw t3,0(t1)		# escreve a word na memória VGA
	addi t1,t1,4		# soma 4 ao endereço
	addi s1,s1,4
	j LOOP2			# volta a verificar
	
# devolve o controle ao sistema operacional
FIM:	li a7,10		# syscall de exit - duda
	ecall
	
