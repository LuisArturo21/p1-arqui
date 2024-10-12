# p1-arqui

Introducción

El problema de las Torres de Hanói consiste en desplazar una columna hecha a base de discos concéntricos de diferentes diámetros, apilados del de mayor diámetro al de menor diámetro, desde su posición original A hasta su posición destino C,
teniendo el punto B disponible para movimientos intermedios. Dicho desplazamiento cuenta con la restricción de que solo se puede mover un disco a la vez, y que en ningún momento puede un disco de mayor diámetro estar sobre un disco de menor diámetro.

Existen varios algoritmos para su solución, pero uno de los más eficientes es el algoritmo recursivo. Este consiste en lo
siguiente:

Para mover una torre de N discos de A a C:

Mover los N-1 discos superiores de la torre de A a B, siendo B la posición que no corresponde ni al origen ni al destino.
Mover el disco restante (el más grande) de A a C.
Mover los N-1 discos de B a C, colocándolos encima del disco de mayor diámetro.
Como no se pueden mover N-1 en un solo movimiento, a menos que N-1 sea igual a 1, entonces se repiten los pasos
anteriores para mover los N-1 discos de A a B, y luego de B a C.

Generalmente se construye una función que recibe como parámetros el número de discos a mover (N), y las posiciones
origen y destino para ese movimiento. Si el número de discos a mover no es 1, entonces se llama recursivamente la misma
función para mover N-1 discos.
