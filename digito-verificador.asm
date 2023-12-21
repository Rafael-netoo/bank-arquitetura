.data

   msg: .asciiz "\nDigite o n�mero da sua conta : "
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
     
        la $a0, minha_string  # Endere�o da string
        li $v0, 5              # C�digo do sistema para ler um inteiro
        syscall
        move $t0, $v0          # Armazena o valor lido em $t0

        # Converte o inteiro para uma string de caracteres ASCII
        li $t1, 10             # Divisor para obter d�gitos
        li $t2, 5             # N�mero de d�gitos
        add $a0, $a0, $t2      # Avan�a para o final da string
        
        # Adiciona o caractere nulo '\0' no final da string
        li $t3, 0
        sb $t3, ($a0)
        
        #converter cada d�gito da conta para string
        converte_digitos:
        div $t0, $t1           # Divide o inteiro por 10
        mfhi $t3               # Obt�m o d�gito menos significativo
        add $t3, $t3, 48       # Converte para ASCII
        sb $t3, -1($a0)        # Armazena o caractere na string
        subi $a0, $a0, 1       # Avan�a para o pr�ximo caractere na string
        sub $t2, $t2, 1        # Decrementa o contador de d�gitos
        div $t0,$t0,10
        bnez $t2, converte_digitos  # Repete at� converter todos os d�gitos
    #funcao que executar� o calculo para defini��o do d�gito 
       calculo_digito_verificador:
        move $t0, $v0          # Carrega o valor de entrada inserido inicialmente pelo usu�rio
        li $t1, 0              # Inicializa o acumulador
        li $t2, 6            # Inicializa o multiplicador
     
        loop:
     
        beq $t2,1,saida  #verifica se o multiplicador � menor que 2 
        rem $t3, $t0, 10       # Obt�m o d�gito atual
        mul $t3, $t3, $t2      # Multiplica o d�gito pelo multiplicador atual
        add $t1, $t1, $t3      # Acumula o resultado
        subi $t2,$t2,1         #diminui -1 do multiplicador
        div $t0, $t0, 10       #remove o ultimo digito menos significativo
        j loop
        
   
       saida:
       lw $t4, divisor     #carrega o divisor(11) em $t4
       divu $t1, $t1, $t4  # divide o valor acumulado por $t4(11)
       mfhi $t1            # pega o resto da divis�o anterior 
      
       la  $a0, verificador
       add $t3, $t1, 48       # Converte para ASCII
       sb $t3, 0($a0) 
          
       beq $t1, 10, dez 
       # move $a0, $t3 # Endere�o da string
       j concatenacao
      
       dez:
       la $a0, verificador_dez  # Carrega o endere�o da string "verificador_dez" em $a0
       la $a1, verificador      # Carrega o endere�o da string "verificador" em $a1

      # Loop para copiar cada byte de verificador_dez para verificador
      copia_loop:
        lb $t2, 0($a0)  # Carrega o byte atual de verificador_dez
        beqz $t2, concatenacao  # Se o byte for nulo, termina o loop
        sb $t2, 0($a1)  # Armazena o byte em verificador
        addi $a0, $a0, 1  # Avan�a para o pr�ximo byte em verificador_dez
        addi $a1, $a1, 1  # Avan�a para o pr�ximo byte em verificador
        j copia_loop
      
  concatenacao:
       
       # Aloca espa�o para a string resultante
        la $a0, string_resultante
    
        
        # Inicializa registradores
        la $t0, minha_string  # Endere�o da primeira string
        la $t3,  string_resultante  # Endere�o da string resultante
        
        #concatena o n� da conta
         concat_loop_str1:
         lb $t4, 0($t0)  # Carrega o caractere atual de str1
         beqz $t4, concat_loop_str2  # Se o caractere for nulo, v� para a pr�xima string
         sb $t4, ($t3)  # Armazena o caractere na string resultante
         addi $t0, $t0, 1  # Avan�a para o pr�ximo caractere em str1
         addi $t3, $t3, 1  # Avan�a para a pr�xima posi��o em result_string
         j concat_loop_str1
        
        
         concat_loop_str2:
         # Reinicializa registradores
         la $t0, hifen  # Endere�o da segunda string
         #la $t3, string_resultante  # Volta ao final da string resultante
        
         concat_loop_str2_copy:
         lb $t4, ($t0)  # Carrega o caractere atual de str2
         beqz $t4, concat_loop_str3  # Se o caractere for nulo, v� para a pr�xima string
         sb $t4, ($t3)  # Armazena o caractere na string resultante
         addi $t0, $t0, 1  # Avan�a para o pr�ximo caractere em str2
         addi $t3, $t3, 1  # Avan�a para a pr�xima posi��o em result_string
         j concat_loop_str2_copy
         
          concat_loop_str3:
         # Reinicializa registradores
         la $t0, verificador  # Endere�o da terceira string
         #la $t3, string_resultante  # Volta ao final da string resultante

        concat_loop_str3_copy:
        lb $t4, ($t0)  # Carrega o caractere atual de str3
        beqz $t4, concat_end  # Se o caractere for nulo, termina
        sb $t4, ($t3)  # Armazena o caractere na string resultante
        addi $t0, $t0, 1  # Avan�a para o pr�ximo caractere em str3
        addi $t3, $t3, 1  # Avan�a para a pr�xima posi��o em result_string
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
 
         
       
     
      	
      	
      
      
      
                
      
      
       
