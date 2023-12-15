.data
	total_clientes: .word 50 # Quantidade máxima de clientes a serem armazenados
	client1: .space 64                                                     
	client2: .space 64                                                     
	client3: .space 64                                                     
	client4: .space 64                                                     
	client5: .space 64                                                     
	client6: .space 64                                                     
	client7: .space 64                                                     
	client8: .space 64                                                     
	client9: .space 64                                                     
	client10: .space 64                                                    
	client11: .space 64                                                    
	client12: .space 64                                                    
	client13: .space 64                                                    
	client14: .space 64                                                    
	client15: .space 64                                                    
	client16: .space 64                                                    
	client17: .space 64                                                    
	client18: .space 64                                                    
	client19: .space 64                                                    
	client20: .space 64                                                    
	client21: .space 64                                                    
	client22: .space 64                                                    
	client23: .space 64                                                    
	client24: .space 64                                                    
	client25: .space 64                                                    
	client26: .space 64                                                    
	client27: .space 64                                                    
	client28: .space 64                                                    
	client29: .space 64                                                    
	client30: .space 64                                                    
	client31: .space 64                                                    
	client32: .space 64                                                    
	client33: .space 64                                                    
	client34: .space 64                                                    
	client35: .space 64                                                    
	client36: .space 64                                                    
	client37: .space 64                                                    
	client38: .space 64                                                    
	client39: .space 64                                                    
	client40: .space 64                                                    
	client41: .space 64                                                    
	client42: .space 64                                                    
	client43: .space 64                                                    
	client44: .space 64                                                    
	client45: .space 64                                                    
	client46: .space 64                                                    
	client47: .space 64                                                    
	client48: .space 64                                                    
	client49: .space 64                                                    
	client50: .space 64

	# MENSAGENS UTILIZADAS NOS MENUS
	options: .asciiz "Selecione operação:\n[1] - Cadastrar Cliente\n[2] - Pagamento de Contas\n[3] - Alterar Limite do Cliente\n[4] - Gerar Extrato\n[5] - Depositar/Sacar\n[6] - Encerrar Conta"
	msg_name_request: .asciiz "\nDigite o nome do cliente:\n"
	msg_cpf_request: .asciiz "\nDigite o CPF do cliente:\n"
	msg_acc_request: .asciiz "\nDigite o número da conta do cliente:\n"
	msg_reg_success: .asciiz "Cliente cadastrado com sucesso. Número da conta: "
	cpf_error: .asciiz "Já existe conta neste CPF"

	# BUFFERS - CLIENTES
	cpf: .space 11
	acc: .space 8
	name: .space 50
	saldo: .space 6
	limite: .word 1500
	fatura: .word 0
	
	#Macros
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
	main:
		print_string(options)
		
		# INPUT DE OPTIONS
		li $v0, 5
		
		beq $v0, 1, cadastrar_clientes
		beq $v0, 2, pagar_conta
		beq $v0, 3, alterar_limite_cliente
		beq $v0, 4, extrato
		beq $v0, 5, saque_deposito
		beq $v0, 6, encerrar_conta
		
		cadastrar_clientes:
		
		pagar_conta:
		
		alterar_limite_cliente:
		
		extrato:
		
		saque_deposito:
		
		encerrar_conta:
		
			
	







