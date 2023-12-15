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
	
	clientes: .space 3200
	
	# BUFFERS - CLIENTES
	cpf: .space 11
	acc: .space 8
	name: .space 50
	saldo: .space 6
	limite: .word 1500
	fatura: .word 0

	# MENSAGENS UTILIZADAS NOS MENUS
	options: .asciiz "Selecione operação:\n[1] - Cadastrar Cliente\n[2] - Pagamento de Contas\n[3] - Alterar Limite do Cliente\n[4] - Gerar Extrato\n[5] - Depositar/Sacar\n[6] - Encerrar Conta\n\nDigite a opção desejada: "
	options_error: .asciiz "\nOpção selecionada inválida! Tente novamente!\n\n"
	
	msg_name_request: .asciiz "\nDigite o nome do cliente:\n"
	msg_cpf_request: .asciiz "\nDigite o CPF do cliente:\n"
	msg_acc_request: .asciiz "\nDigite o número da conta do cliente:\n"
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
			
			bgt $v0, 6, invalid_option
			blt $v0, 1, invalid_option
			
			invalid_option:
				print_string(options_error)
				j menu
		
		cadastrar_clientes:
			# -----------------------------------------------
			# REGISTRADORES TEMPORÁRIOS QUE SERÃO UTILIZADOS:
			# -----------------------------------------------
			# $t0 - cpf
			# $t1 - nome
			# $t2 - conta
			# $t3 -
			# $t4 - 
			
			
			# solicitação do cpf:
			print_string(msg_cpf_request)
			li $v0, 8
			la $a0, cpf
			li $a1, 11
			
			
			
		pagar_conta:
		
		alterar_limite_cliente:
		
		extrato:
		
		saque_deposito:
		
		encerrar_conta:
		
			
	







