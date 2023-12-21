.data

   msg: .asciiz "\nDigite o número da sua conta : "
   divisor : .word 11
   verificador : .space 2
   verificador_dez: .asciiz "X"
   minha_string: .space 6
   hifen: .asciiz "-"
   string_resultante: .space 6
   
.text
   .globl digito_verificador

   digito_verificador:
     li $v0, 4
     la $a0, msg
     syscall
     
   #converter valor da conta para string
   convert_string: 
     
        la $a0, minha_string  # Endereço da string
        li $v0, 5              # Código do sistema para ler um inteiro
        syscall
        move $t0, $v0          # Armazena o valor lido em $t0

        # Converte o inteiro para uma string de caracteres ASCII
        li $t1, 10             # Divisor para obter dígitos
        li $t2, 5             # Número de dígitos
        add $a0, $a0, $t2      # Avança para o final da string
        
        # Adiciona o caractere nulo '\0' no final da string
        li $t3, 0
        sb $t3, ($a0)
        
        #converter cada dígito da conta para string
        converte_digitos:
        div $t0, $t1           # Divide o inteiro por 10
        mfhi $t3               # Obtém o dígito menos significativo
        add $t3, $t3, 48       # Converte para ASCII
        sb $t3, -1($a0)        # Armazena o caractere na string
        subi $a0, $a0, 1       # Avança para o próximo caractere na string
        sub $t2, $t2, 1        # Decrementa o contador de dígitos
        div $t0,$t0,10
        bnez $t2, converte_digitos  # Repete até converter todos os dígitos
    #funcao que executará o calculo para definição do dígito 
       calculo_digito_verificador:
        move $t0, $v0          # Carrega o valor de entrada inserido inicialmente pelo usuário
        li $t1, 0              # Inicializa o acumulador
        li $t2, 6            # Inicializa o multiplicador
     
        loop:
     
        beq $t2,1,saida  #verifica se o multiplicador é menor que 2 
        rem $t3, $t0, 10       # Obtém o dígito atual
        mul $t3, $t3, $t2      # Multiplica o dígito pelo multiplicador atual
        add $t1, $t1, $t3      # Acumula o resultado
        subi $t2,$t2,1         #diminui -1 do multiplicador
        div $t0, $t0, 10       #remove o ultimo digito menos significativo
        j loop
        
   
       saida:
       lw $t4, divisor     #carrega o divisor(11) em $t4
       divu $t1, $t1, $t4  # divide o valor acumulado por $t4(11)
       mfhi $t1            # pega o resto da divisão anterior 
      
       la  $a0, verificador
       add $t3, $t1, 48       # Converte para ASCII
       sb $t3, 0($a0) 
          
       beq $t1, 10, dez 
       # move $a0, $t3 # Endereço da string
       j concatenacao
      
       dez:
       la $a0, verificador_dez  # Carrega o endereço da string "verificador_dez" em $a0
       la $a1, verificador      # Carrega o endereço da string "verificador" em $a1

      # Loop para copiar cada byte de verificador_dez para verificador
      copia_loop:
        lb $t2, 0($a0)  # Carrega o byte atual de verificador_dez
        beqz $t2, concatenacao  # Se o byte for nulo, termina o loop
        sb $t2, 0($a1)  # Armazena o byte em verificador
        addi $a0, $a0, 1  # Avança para o próximo byte em verificador_dez
        addi $a1, $a1, 1  # Avança para o próximo byte em verificador
        j copia_loop
      
  concatenacao:
       
       # Aloca espaço para a string resultante
        la $a0, string_resultante
    
        
        # Inicializa registradores
        la $t0, minha_string  # Endereço da primeira string
        la $t3,  string_resultante  # Endereço da string resultante
        
        #concatena o nº da conta
         concat_loop_str1:
         lb $t4, 0($t0)  # Carrega o caractere atual de str1
         beqz $t4, concat_loop_str2  # Se o caractere for nulo, vá para a próxima string
         sb $t4, ($t3)  # Armazena o caractere na string resultante
         addi $t0, $t0, 1  # Avança para o próximo caractere em str1
         addi $t3, $t3, 1  # Avança para a próxima posição em result_string
         j concat_loop_str1
        
        
         concat_loop_str2:
         # Reinicializa registradores
         la $t0, hifen  # Endereço da segunda string
         #la $t3, string_resultante  # Volta ao final da string resultante
        
         concat_loop_str2_copy:
         lb $t4, ($t0)  # Carrega o caractere atual de str2
         beqz $t4, concat_loop_str3  # Se o caractere for nulo, vá para a próxima string
         sb $t4, ($t3)  # Armazena o caractere na string resultante
         addi $t0, $t0, 1  # Avança para o próximo caractere em str2
         addi $t3, $t3, 1  # Avança para a próxima posição em result_string
         j concat_loop_str2_copy
         
          concat_loop_str3:
         # Reinicializa registradores
         la $t0, verificador  # Endereço da terceira string
         #la $t3, string_resultante  # Volta ao final da string resultante

        concat_loop_str3_copy:
        lb $t4, ($t0)  # Carrega o caractere atual de str3
        beqz $t4, concat_end  # Se o caractere for nulo, termina
        sb $t4, ($t3)  # Armazena o caractere na string resultante
        addi $t0, $t0, 1  # Avança para o próximo caractere em str3
        addi $t3, $t3, 1  # Avança para a próxima posição em result_string
        j concat_loop_str3_copy

        concat_end:
        # Imprime a string resultante
        #li $v0, 4
        #la $a0,string_resultante
        #syscall
        
	la $a0, string_resultante
        move $v0, $a0
        jr $ra


        # Termina o programa
        #li $v0, 10
        #syscall
 
         
       
     
      	
      	
      
      
      
                
      
      
       
