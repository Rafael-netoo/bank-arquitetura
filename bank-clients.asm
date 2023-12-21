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
	
	num_clientes: .space 50  # ou o n�mero desejado de clientes
	
	nome_cliente:
		.space 2500 # valor para armazenar 50 nomes
		.asciiz "CLIENT BANCO ARQUITETURA"
		
	cpf_cliente: 
		.space 550
		.asciiz "12345678910"
	
	limite_cliente: .space 400 # optei por escolher 8 bytes para cada cliente
	
	#conta_cliente: .space 400 
	
	saldo_cliente: .space 400
	
	# MENSAGENS UTILIZADAS NOS MENUS
	options: .asciiz "Selecione opera��o:\n[1] - Cadastrar Cliente\n[2] - Pagamento de Contas\n[3] - Alterar Limite do Cliente\n[4] - Gerar Extrato\n[5] - Depositar/Sacar\n[6] - Encerrar Conta\n\nDigite a op��o desejada: "
	options_error: .asciiz "\nOp��o selecionada inv�lida! Tente novamente!\n\n"
	
	request_client: .asciiz "TESTE: Insira o �ndice do cliente desejado: "
	msg_name_request: .asciiz "\nDigite o nome do cliente: "
	msg_cpf_request: .asciiz "\nDigite o CPF do cliente: "
	msg_acc_request: .asciiz "\nDigite o n�mero da conta do cliente: "
	quebra_de_linha: .asciiz "\n"
	msg_saque_deposito: .asciiz "Escolha a opera��o:\n [1] - Saque\n[2] - Dep�sito\nDigite a op��o desejada: "
	msg_reg_success: .asciiz "Cliente cadastrado com sucesso. N�mero da conta: "
	msg_saque_efetuado: .asciiz "Saque efetuado com sucesso.\n"
	msg_valor_saque: .asciiz "Digite o valor do saque: "
	msg_valor_deposito: .asciiz "Digite o valor do dep�sito: "
	msg_deposito_efetuado: .asciiz "Dep�sito efetuado com sucesso.\n"
	msg_saldo_insuficiente: .asciiz "Saldo insuficiente.\n"
	cpf_error: .asciiz "J� existe conta neste CPF"
	msg_saldo: .asciiz "Saldo: "
	msg_escolher_pagamento: .asciiz "Escolha como ser� efetuado seu pagamento: \n[1] - D�bito\n[2] - Cr�dito\n"
	msg_valor_pagamento: .asciiz "Digite o valor do pagamento: "
	msg_pagamento_debito_efetuado: .asciiz "Pagamento efetuado com sucesso!"
	msg_saldo_limite_insuficiente: .asciiz "Limite de cr�dito insuficiente.\n"
	msg_pagamento_credito_efetuado: .asciiz "Pagamento efetuado com sucesso em cr�dito!\n"
	msg_teste: .asciiz "TESTANDO"
	msg_debug_1: .asciiz "DEBUG: Limite de cr�dito antes da verifica��o: "
	msg_debug_2: .asciiz "DEBUG: Valor do pagamento: "
	msg_debug_3: .asciiz "DEBUG: Limite de cr�dito ap�s a verifica��o (falha): "
	msg_debug_4: .asciiz "DEBUG: Limite de cr�dito ap�s o pagamento bem-sucedido: "
	msg_debug_5: .asciiz "DEBUG: Valor Convertido"
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
			bgt $v0, 7, invalid_option
			blt $v0, 1, invalid_option
			
			invalid_option:
				print_string(options_error)
				j menu
				
			cliente_invalido:
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
			   
			sb $zero, saldo_cliente($t2)  # Inicializar saldo como zero
			li $s1, 1500  # Definir o limite de cr�dito padr�o
			sb $s1, limite_cliente($t2)  # Inicializar o limite de cr�dito do cliente

			
			print_string(quebra_de_linha)
			print_string(msg_reg_success)
			print_string(quebra_de_linha)
			
			addi $t0, $t0, 50 # prox index nome
			addi $t1, $t1, 11 # prox index cpf
			addi $t2, $t2, 8 # prox index conta
			
			j menu
			
		
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
		
		saque_deposito:
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

    		print_string(msg_saque_deposito)
    		li $v0, 5
    		syscall
    		move $t7, $v0  # Salvar o valor lido em $t7

    		beq $t7, 1, saque
    		beq $t7, 2, deposito

    		# Se a op��o n�o for 1 ou 2, exiba uma mensagem de op��o inv�lida
    		print_string(options_error)
    		j menu

		saque:
    		print_string(msg_valor_saque)
    		li $v0, 5
    		syscall

    		# Agora, $v0 cont�m o valor do saque
    		la $t4, saldo_cliente # Carregar o endere�o base de saldo_cliente
    		add $t4, $t4, $t3  # Adicionar o deslocamento para obter o endere�o espec�fico
    		andi $t4, $t4, -4  # M�scara para garantir que $t4 seja um m�ltiplo de 4
    		lw $t5, 0($t4)     # Carregar o saldo atual do cliente para $t5

    		# Verificar se h� saldo suficiente
    		bge $t5, $v0, saldo_suficiente  # Se o saldo for maior ou igual ao valor do saque, v� para saldo_suficiente
    		print_string(msg_saldo_insuficiente)  # Se o saldo for menor que o valor do saque, imprima a mensagem de saldo insuficiente
    		j menu  # Volte para o menu

		saldo_suficiente:
    		sub $t5, $t5, $v0  # Atualizar saldo (para saque)
    		sw $t5, 0($t4)  # Salvar saldo atualizado
    		print_string(msg_saque_efetuado)  # Mensagem de saque efetuado
    		j menu
    		

  		print_string(msg_saque_efetuado)  # Mensagem de saque efetuado
  		j menu

		deposito:
    		print_string(msg_valor_deposito)
    		li $v0, 5
    		syscall

    		# Agora, $v0 cont�m o valor do dep�sito
    		sll $t5, $t3, 2              # Multiplicar $t3 por 4 (shift left by 2)
    		la $t4, saldo_cliente        # Carregar o endere�o base de saldo_cliente
    		add $t4, $t4, $t5            # Adicionar o deslocamento para obter o endere�o espec�fico
    		andi $t4, $t4, -4            # M�scara para garantir que $t4 seja um m�ltiplo de 4
    		lw $t5, 0($t4)               # Carregar o saldo atual do cliente para $t5

    		add $t5, $t5, $v0            # Atualizar saldo (para dep�sito)
    		sw $t5, 0($t4)               # Salvar saldo atualizado

  		# Mensagem de dep�sito efetuado
  		print_string(msg_deposito_efetuado)
  		j menu
    		
    		pagar_conta:
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
    
    		print_string(msg_escolher_pagamento)  # Adiciona a op��o de escolher d�bito ou cr�dito
    		li $v0, 5
    		syscall
    		move $t6, $v0  # Salva a escolha de d�bito (1) ou cr�dito (2)

    		# Agora, dependendo da escolha, chama a fun��o correspondente
    		beq $t6, 1, pagar_conta_debito
    		beq $t6, 2, pagar_conta_credito
    		j menu  # Se a escolha n�o for 1 ou 2, volte para o menu principal

		# Fun��o para pagar contas em d�bito
		pagar_conta_debito:
    		print_string(msg_valor_pagamento)
    		li $v0, 5
    		syscall

    		# Agora, $v0 cont�m o valor do pagamento
    		la $t4, saldo_cliente  # Carrega o endere�o base de saldo_cliente
    		add $t4, $t4, $t3  # Adiciona o deslocamento para obter o endere�o espec�fico
    		andi $t4, $t4, -4  # M�scara para garantir que $t4 seja um m�ltiplo de 4
    		lw $t5, 0($t4)  # Carrega o saldo atual do cliente para $t5

    		# Verifica se h� saldo suficiente
    		blt $t5, $v0, saldo_insuficiente_debito  # Se o saldo for menor que o valor do pagamento, imprime a mensagem de saldo insuficiente
    		sub $t5, $t5, $v0  # Atualiza saldo (para d�bito)
    		sw $t5, 0($t4)  # Salva saldo atualizado

   		# Mensagem de pagamento efetuado com sucesso
  		print_string(msg_pagamento_debito_efetuado)
	  	j menu

		saldo_insuficiente_debito:
    		print_string(msg_saldo_insuficiente)  # Se o saldo for menor que o valor do pagamento, imprime a mensagem de saldo insuficiente
    		j menu  # Volta para o menu principal

		# Fun��o para pagar contas em cr�dito
		pagar_conta_credito:
    		print_string(msg_valor_pagamento)
    		li $v0, 5
    		syscall

    		# Agora, $v0 cont�m o valor do pagamento
    		la $t4, limite_cliente  # Carrega o endere�o base de limite_cliente
    		add $t4, $t4, $t3  # Adiciona o deslocamento para obter o endere�o espec�fico
    		andi $t4, $t4, -4  # M�scara para garantir que $t4 seja um m�ltiplo de 4
    		lw $t5, 0($t4)  # Carrega o limite de cr�dito atual do cliente para $t5

    		# Verifica se h� limite de cr�dito suficiente
    		bge $t5, $v0, limite_credito_suficiente  # Se o limite de cr�dito for maior ou igual ao valor do pagamento, v� para limite_credito_suficiente

    		print_string(msg_saldo_limite_insuficiente)  # Se o limite de cr�dito for menor que o valor do pagamento, imprime a mensagem de saldo insuficiente
    		j menu  # Volta para o menu principal

		limite_credito_suficiente:
    		sub $t5, $t5, $v0  # Atualiza limite de cr�dito (para cr�dito)
    		sw $t5, 0($t4)  # Salva limite de cr�dito atualizado

    		# Mensagem de pagamento efetuado com sucesso em cr�dito
  		print_string(msg_pagamento_credito_efetuado)
  		j menu
    		
    		
    		extrato:
		
		encerrar_conta:
		
		verificar_cpf:
			#addi $sp, $sp, -4
			#sw $t0, 0($sp) #Salvando o valor de $a0 para poder voltar a funcao
			
			#move $a0, $t0
			
			#loop:
				
			
			
			
			#lw $t0, 0($sp)	#Recuperando o $a0 antigo
			#addi $sp, $sp, 4 #voltando a pilha pro lugar 			
	







