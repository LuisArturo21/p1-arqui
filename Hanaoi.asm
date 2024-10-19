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



