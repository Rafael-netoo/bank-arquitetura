.data
	# Espaço reservado para armazenar os clientes:
	# ------------------------------------------------
	# DISTRIBUIÇÃO DOS DADOS DOS CLIENTES NA MEMÓRIA:
	# ------------------------------------------------
	# CPF = 11 bytes
	# nº da conta = 8 bytes
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
	options: .asciiz "Selecione operação:\n[1] - Cadastrar Cliente\n[2] - Pagamento de Contas\n[3] - Alterar Limite do Cliente\n[4] - Gerar Extrato\n[5] - Depositar/Sacar\n[6] - Encerrar Conta\n\nDigite a opção desejada: "
	options_error: .asciiz "\nOpção selecionada inválida! Tente novamente!\n\n"
	
	request_client: .asciiz "TESTE: Insira o índice do cliente desejado: "
	msg_name_request: .asciiz "\nDigite o nome do cliente: "
	msg_cpf_request: .asciiz "\nDigite o CPF do cliente: "
	msg_acc_request: .asciiz "\nDigite o número da conta do cliente: "
	quebra_de_linha: .asciiz "\n"
	
	msg_reg_success: .asciiz "Cliente cadastrado com sucesso. Número da conta: "
	
	cpf_error: .asciiz "Já existe conta neste CPF"
	
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
		li $t0, 0 # índice do nome dos usuários	
		li $t1, 0 # índice do cpf dos usuários
		li $t2, 0 # índice da conta dos usuários
		
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
			# REGISTRADORES TEMPORÁRIOS QUE SERÃO UTILIZADOS:
			# -----------------------------------------------
			# $t0 - índice dos usuários
			# $t1 - índice cpf
			# $t2 - índice conta
			# $
			
			# -----------------------------------------------
			# REGISTRADORES PERENES QUE SERÃO UTILIZADOS:
			# -----------------------------------------------
			# $s0 - limite padrão

			
			# solicitação do nome:
			print_string(msg_name_request) # imprime a mensagem de solicitação do nome
			li $v0, 8 
			la $a0, nome_cliente($t0)			
			li $a1, 51 # nº máx. de char | n_max = n - 1
			syscall
			
			# solicitação do cpf:
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
	







