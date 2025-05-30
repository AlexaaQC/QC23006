# QC23006
entrega del portafolio 

# Ejercicio 1

## Descripción
Este programa en ensamblador para GNU/Linux realiza una resta de tres números enteros positivos usando registros de 16 bits.
Lo más importante es que, además de la operación aritmética que se realiza, el programa muestra el resultado en la consola. Para lograr esto, el resultado numérico (que está en binario) se convierte a caracteres ASCII mediante divisiones repetidas por 10 y Finalmente, se usa la llamada al sistema sys_write para imprimir tanto un mensaje como el número convertido. 

# Ejercicio2

## Descripción
Este programa multiplica dos numeros de 8 bits (10x5=50) y muestra los resultados en la consola. utiliza la instruccion UML para la operacion aritmetica y convierte el resultado binario a ASCII mediante divisiones repetidas por 10, donde cada resto representa un digito decimal. los digitos se guardan de derecha a izquierda en un buffer y finalmrnte se imprimen usando syscalls del sistema. este metodo es necesario porque assembly no tiene funciones automaticas de conversion numerica como otros lenguajes de alto nivel. 

# Ejercicio3 

## Descripcion 
Este programa realiza una division de numeros enteros de 32 bits, solicitando al usuario el dividendo y divisor por teclado, luego muestra tanto el cociente como el residuo. incluye validacion para evitar division por cero. Utiliza la instruccion DIV que divide EDX:EAX por el operando especificado, devolviendo el cociente en EAX y el residuo en EDX. El programa implementa funciones de conversion bidireccional: string a entero para leer la entrada del usuario (multiplicacion por 10 y sumando cada digito), y entero a string para mostrar los resultados (dividiendo por 10 repetidamente y almacenando los digitos en un stack). 
