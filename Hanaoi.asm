.data
        #Almacena la posicion de los discos (3 en este ejemplo)
        discos: .word 0 , 0 , 0
        mensaje: .asciiz "Mover disco de la torre "  # Mensaje que se imprimirá al mover un disco
	    salto:   .asciiz "\n"                        # Salto de línea para formatear la salida
.text
    main:

        #Inicializamos el numero de discos
        li s0 , 3

        #Inicializamos las Torres
        li s1 , 1 #Torre origen(A)
        li s2 , 3 #Torre destino(C)
        li s3 , 2 #Torre auxiliar(B)

        addi a0 , s0 , 0  # a0 = numero de discos    
        addi a1 , s1 , 0  # a1 = torre origen
        addi a2 , s2 , 0  # a2 = torre destino
        addi a3 , s3 , 0  # a3 = torre auxiliar
        jal ra , hanoi # Funcion recursiva

        # Finaliza el programa
        li a7, 10 # Syscall de fin de programa
        ecall

        hanoi:

            addi sp , sp , -16 # Reservamos 4 espacios del stack
            sw ra , 12(sp) # Guardamos ra
            sw a0 , 8(sp) #Guardamos los numeros de discos
            sw a1 , 4(sp) #Guardamos torre origen
            sw a2 , 0(sp) #Guardamos torre destino

            li t0 , 1 # t0 = 1
            beq a0 , t0 , mover_disco

            #Movemos N-1 de origen a auxiliar
            addi a0 , a0 , -1 # a0 = n - 1
            addi a2 , a3 , 0 # Intercambiamos la torre destino con la auxiliar
            jal ra , hanoi # Llamada recursiva

            #Movemos el disco mas grande a Torre Origen
            addi a0 , a0 , 1 #Restauramos el valor de N
            jal ra , mover_disco # Mover disco grande

            #Movemos los N - 1 discos de auxiliar a destino
            addi a0 , a0 , -1 # a0 = n - 1
            addi a2 , a3 , 0 # Intercambiamos la torre origen con la auxiliar
            jal ra , hanoi # Llamada recursiva

            # Restauramos el stack
            lw ra , 12(sp) # Leemos el valor del ra
            lw a0 , 8(sp) # Leemos el numero de discos
            lw a1 , 4(sp) # Leemos la torre origen
            lw a2 , 0(sp) # Leemos la torre destino
            addi sp , sp , 16 # Liberamos el stack
            ret
        

        mover_disco:
            la a0, mensaje    # Cargar el mensaje "Mover disco de la torre "
            li a7, 4          # syscall de imprimir string
            ecall

            addi a0, a1, 0     # Cargamos la torre origen en a0
            li a7, 1          # syscall de imprimir integer
            ecall

            li a0, 'a'
            li a7, 11         # syscall de imprimir char
            ecall

            addi a0, a2, 0     # Cargamos la torre destino en a0
            li a7, 1          # syscall de imprimir integer
            ecall

            la a0, salto      # Cargar el salto de línea
            li a7, 4          # syscall de imprimir string
            ecall
            
            jr ra             # Retornar a la función recursiva


