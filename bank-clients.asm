.data
	# Espa�o reservado para armazenar os clientes:
	# ------------------------------------------------
	# DISTRIBUI��O DOS DADOS DOS CLIENTES NA MEM�RIA:
	# ------------------------------------------------
	# CPF = 11 bytes
	# n� da conta = 8 bytes
	# nome = 27 bytes 
	# saldo = 6 bytes (com centavos)
	# limite = 6 bytes (com centavos)
	# fatura = 6 bytes (com centavos)
	
	nome_cliente:
		.space 2500 # valor para armazenar 50 nomes
		.asciiz "CLIENT BANCO ARQUITETURA"
		
	cpf_cliente: 
		.space 550
		.asciiz "12345678910"
	
	limite_cliente: .space 400 # optei por escolher 8 bytes para cada cliente
	#conta_cliente: .space 400 .asciiz "XXXXXX"
	

	# MENSAGENS UTILIZADAS NOS MENUS
	options: .asciiz "Selecione opera��o:\n[1] - Cadastrar Cliente\n[2] - Pagamento de Contas\n[3] - Alterar Limite do Cliente\n[4] - Gerar Extrato\n[5] - Depositar/Sacar\n[6] - Encerrar Conta\n\nDigite a op��o desejada: "
	options_error: .asciiz "\nOp��o selecionada inv�lida! Tente novamente!\n\n"
	
	request_client: .asciiz "TESTE: Insira o �ndice do cliente desejado: "
	msg_name_request: .asciiz "\nDigite o nome do cliente: "
	msg_cpf_request: .asciiz "\nDigite o CPF do cliente: "
	msg_acc_request: .asciiz "\nDigite o n�mero da conta do cliente: "
	quebra_de_linha: .asciiz "\n"
	
	msg_reg_success: .asciiz "Cliente cadastrado com sucesso. N�mero da conta: "
	
	cpf_error: .asciiz "J� existe conta neste CPF"
	
	# Macros
	.macro print_string(%string)
		addi $sp, $sp, -4
		sw $a0, 0($sp) #Salvando o valor de $a0 para poder voltar a funcao
		
		addi $v0, $0, 4
		la $a0, %string
		syscall
	
		lw $a0, 0($sp)	#Recuperando o $a0 antigo
		addi $sp, $sp, 4 #voltando a pilha pro lugar original
	.end_macro	

.text
	.globl main
	main:
		li $t0, 0 # �ndice do nome dos usu�rios	
		li $t1, 0 # �ndice do cpf dos usu�rios
		li $t2, 0 # �ndice da conta dos usu�rios
		
		li $s0, 1500
		
		menu:
			print_string(options)
		
			# INPUT DE OPTIONS
			li $v0, 5
			syscall
		
			beq $v0, 1, cadastrar_clientes
			beq $v0, 2, pagar_conta
			beq $v0, 3, alterar_limite_cliente
			beq $v0, 4, extrato
			beq $v0, 5, saque_deposito
			beq $v0, 6, encerrar_conta
			
			# desvios de casos inexistentes
			bgt $v0, 6, invalid_option
			blt $v0, 1, invalid_option
			
			invalid_option:
				print_string(options_error)
				j menu
			
		cadastrar_clientes:
		
			# -----------------------------------------------
			# REGISTRADORES TEMPOR�RIOS QUE SER�O UTILIZADOS:
			# -----------------------------------------------
			# $t0 - �ndice dos usu�rios
			# $t1 - �ndice cpf
			# $t2 - �ndice conta
			# $
			
			# -----------------------------------------------
			# REGISTRADORES PERENES QUE SER�O UTILIZADOS:
			# -----------------------------------------------
			# $s0 - limite padr�o

			
			# solicita��o do nome:
			print_string(msg_name_request) # imprime a mensagem de solicita��o do nome
			li $v0, 8 
			la $a0, nome_cliente($t0)			
			li $a1, 51 # n� m�x. de char | n_max = n - 1
			syscall
			
			# solicita��o do cpf:
			print_string(msg_cpf_request)
			li $v0, 8
			la $a0, cpf_cliente($t1)
			li $a1, 12
			syscall
			
			#jal verificar_cpf
			
			sb $s0, limite_cliente($t2)
			
			print_string(quebra_de_linha)
			print_string(msg_reg_success)
			print_string(quebra_de_linha)
			
			addi $t0, $t0, 50 # prox index nome
			addi $t1, $t1, 11 # prox index cpf
			addi $t2, $t2, 8 # prox index conta
			
			j menu
			
		pagar_conta:
		
		alterar_limite_cliente:
			# TESTE
			print_string(request_client)
			li $v0, 5
			syscall
			
			add $t3, $0, $v0
			li $s1, 50
			multu $t3, $s1
			mflo $t3
			
			# TESTE: imprimindo cliente que foi recuperado
			li $v0, 4
			la $a0, nome_cliente($t3)
			syscall
			
			j menu
			
		extrato:
		
		saque_deposito:
		
		encerrar_conta:
		
		verificar_cpf:
			#addi $sp, $sp, -4
			#sw $t0, 0($sp) #Salvando o valor de $a0 para poder voltar a funcao
			
			#move $a0, $t0
			
			#loop:
				
			
			
			
			#lw $t0, 0($sp)	#Recuperando o $a0 antigo
			#addi $sp, $sp, 4 #voltando a pilha pro lugar 			
	







