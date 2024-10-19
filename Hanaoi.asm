.data
towers_storage: # Almacenamiento para las torres de hanoi

# s0 -> Número de discos
# s1 -> Torre origen
# s2 -> Torre auxiliar
# s3 -> Torre destino
.text

_start:
    # Inicializar registros
    addi s0, zero, 5  # Número de discos
    # Calcular direcciones para cada torre
    addi t0, zero, 4
    mul t1, s0, t0 # Total de direcciones a reservar (4*3)
    addi t1, t1, 4
    lui s1, %hi(towers_storage)
    addi s1, s1, %lo(towers_storage) # Torre origen
    add s2, s1, t1 # Torre auxiliar
    add s3, s2, t1 # Torre destino
    add t2, zero, s0 # Contador para crear discos
    
main:
    
    create_disks: # Crear discos en torre origen (s1)
        sw t2, 0(s1) # Almacenar disco
        addi s1, s1, 4 # Pasar a la siguiente posición
        addi t2, t2, -1 # Decrementar contador
        bgt t2, zero, create_disks # Si quedan discos, continuar
        lui s1, %hi(towers_storage) # Apuntar a la base de la torre 1
    
    # Inicializar parámetros para la función de torres de hanoi
    add a0, zero, s0 # Número de discos
    add a1, zero, s1 # Torre origen
    add a2, zero, s2 # Torre auxiliar
    add a3, zero, s3 # Torre destino

    jal ra, hanoi_towers # Iniciar proceso de torres de hanoi
    jal zero, exit # Terminar programa         
    
hanoi_towers:
    # Reservar espacio en el stack
    addi sp, sp, -20 # 5*4 = 20
    sw ra, 0(sp)  # Guardar retorno
    sw a0, 4(sp)  # Guardar N
    sw a1, 8(sp)  # Guardar torre origen 
    sw a2, 12(sp) # Guardar torre auxiliar
    sw a3, 16(sp) # Guardar torre destino
    
    # Llamadas principales de hanoi_towers
    addi t0, zero, 1 # Valor para base
    beq a0, t0, hanoi_base # Si N es 1, ir a hanoi_base
    jal ra, hanoi_rec_1 # Llamada recursiva 1
    jal ra, hanoi_get_original_values # Recuperar registros originales
    jal ra, hanoi_move_disk # Mover disco
    jal ra, hanoi_rec_2 # Llamada recursiva 2
    jal zero, hanoi_ret # Terminar y limpiar stack
    
hanoi_base: # Caso base: un disco
    jal ra, hanoi_move_disk # Mover disco a destino
    jal zero, hanoi_ret # Terminar y limpiar stack
    
hanoi_get_original_values: # Recuperar valores originales
    lw a0, 4(sp)    # Cargar N
    lw a1, 8(sp)    # Cargar torre origen
    lw a2, 12(sp)   # Cargar torre auxiliar
    lw a3, 16(sp)   # Cargar torre destino
    jalr zero, ra, 0 # Volver a la llamada 

hanoi_rec_1: # hanoi(n - 1, origen, destino, auxiliar)
    addi a0, a0, -1 # Reducir N
    # Intercambiar auxiliar y destino
    add t0, zero, a2 # Guardar auxiliar
    add a2, zero, a3 # Auxiliar ahora es destino
    add a3, zero, t0 # Destino ahora es auxiliar
    jal zero, hanoi_towers # Llamada recursiva

hanoi_rec_2: # hanoi(n - 1, auxiliar, origen, destino)
    addi a0, a0, -1 # Reducir N
    # Intercambiar origen y auxiliar
    add t0, zero, a1 # Guardar origen
    add a1, zero, a2 # Origen ahora es auxiliar
    add a2, zero, t0 # Auxiliar ahora es origen
    jal zero, hanoi_towers # Llamada recursiva

hanoi_ret:
    jal ra, hanoi_get_original_values # Restaurar registros
    lw ra, 0(sp) # Recuperar retorno
    addi sp, sp, 20 # Limpiar stack
    jalr zero, ra, 0 # Volver a la llamada
    
# Mover disco entre torres
hanoi_move_disk:
    # Extraer disco
    add t0, zero, a1 # Base de la torre origen

    while_1:
        lw t1, 0(a1) # Cargar disco en torre origen
        addi a1, a1, 4 # Mover hacia arriba en la torre
        bne t1, zero, while_1 # Continuar hasta encontrar el disco
    addi a1, a1, -8  # Ir al último disco de la torre origen
    lw t2, 0(a1)  # Disco a mover
    sw zero, 0(a1) # Eliminar disco de la torre origen
    add a1, zero, t0 # Restablecer torre origen
    
    # Colocar disco en destino  
    add t0, a3, zero # Base de la torre destino
    while_2:
        lw t1, 0(a3) # Cargar disco en torre destino
        addi a3, a3, 4 # Mover hacia arriba en la torre
        bne t1, zero, while_2 # Continuar hasta encontrar espacio
        addi a3, a3, -4 # Ir a la última posición
    sw t2, 0(a3) # Guardar disco en la torre destino    
    add a3, zero, t0 # Restablecer torre destino

    jalr zero, ra, 0 # Volver a la llamada
    
exit:
    addi zero, zero, 0 # Terminar ejecución
