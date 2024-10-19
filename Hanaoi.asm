.data

    tower_storage: # Memoria de las torres

    # s0 Numero de discos
    # s1 Torre Origen
    # s2 Torre Auxiliar
    # s3 Torre Destino

.text

    #Declaracion de los registros
    _start:
        addi s0 , zero , 3 # Numeros de discos (Se puede cambiar el valor por N cantidad)

        #Calculo de direcciones de cada Torre
        addi t0 , zero , 4
        mul t1 , s0 , t0 # Direcciones a reservar (N*4)
        addi t1 , t1 , 4
        lui s1 , %hi(tower_storage)
        addi s1 , s1 , %lo(tower_storage) # Origen
        add s2 , s1 , t1 # Auxiliar 
        add s3 , s2 ,t1 # Destino

    main:

        create_disc: # Torre origen
            sw s2 ,0(s1) # Designamos la direccion como disco
            addi s1 , s1 , 4 # Recorremos al a sig direccion y guardamos el disco
            addi t2 , t2 , -1 # Restamos en 1 el valor de conteo
            bgt t2 , zero , create_disc # Si el conteo es mayor a 0 se crean mas discos
            lui s1 , %hi(tower_storage) # Cargamos la parte mas sognificativa

            # Apuntador a cada registro
            add a0 , zero , s0 # Numero de discos
            add a1 , zero , s1 # Torre origen
            add a2 , zero , s2 # Torre auxiliar
            add a3 , zero , s3 # Torre destino

            jal ra , hanoi # Llamamos a la funcion hanoi
            jal zero , exit # Terminamos el programa

        hanoi:
        # Reserva y asginacion del stack
            addi sp , sp ,-20
            sw ra , 0(sp)
            sw a0 , 4(sp) # N
            sw a1 , 8(sp) # Origen
            sw a2 , 12(sp) # Auxiliar
            sw a3 , 16(sp) # Destino

            addi t0 , zero , 1 # Valor comparativo
            beq a0 , t0 , hanoi_base
            jal ra , hanoi_rec_1 # Primera llamada recursiva con parámetros establecidos en función
            jal ra , hanoi_get_original_values # Recobrar posiciones originales de registros apuntadores a torres
            jal ra , hanoi_move_disk # Mover disco conforme a primera llamada recursiva
            jal ra , hanoi_rec_2 # Segunda llamada recursiva con parámetros establecidos en función
            jal zero , hanoi_ret # Representación final de cambios en las torres y limpieza del stack frame

        hanoi_base: # Un disco
            jal ra , hanoi_move_disk # Mover disco a destino
            jal zero , hanoi_ret # Representar movimiento y limpiar stack