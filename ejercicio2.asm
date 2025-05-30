section .data
    msg db "El resultado de la multiplicacion es: "          ; Mensaje principal a mostrar
    len_msg equ $ - msg                                       ; Longitud del mensaje

    numero_buf db "          ", 10, 0                         ; Buffer para el resultado ASCII
                                                              ; Una multiplicación de 8 bits (AL * BL) produce resultado en AX (16 bits)
                                                              ; El máximo es 255 * 255 = 65025 (5 dígitos)
                                                              ; "          " son 10 espacios para asegurar que el número no se desborde
                                                              ; 10 es el carácter de salto de línea (LF), 0 es terminador nulo
    LEN_NUM_BUFFER_DIGITS equ ($ - numero_buf) - 2          ; Constante para el tamaño del área de dígitos

section .text
    global _start

_start:
    ; --- 1. Realizar la Multiplicación con Registros de 8 bits ---

    mov al, 10                                                ; Primer número (multiplicando)
    mov bl, 5                                                 ; Segundo número (multiplicador)

    mul bl                                                    ; Multiplicar AL por BL
                                                              ; El resultado (AL * BL) se almacena en AX (AH:AL)
                                                              ; En este caso: AX = 10 * 5 = 50

    ; --- 2. Preparar el Resultado para Conversión a ASCII ---

    movzx rax, ax                                             
                                                              

    lea rsi, [numero_buf + LEN_NUM_BUFFER_DIGITS - 1]        ; Puntero RSI: apunta al ÚLTIMO espacio para un dígito
                                                            
    
    ; --- 3. Convertir el Número (en RAX) a Cadena ASCII ---
    mov rbx, 10                                               ; Divisor para obtener los dígitos (base 10)

    cmp rax, 0                                                ; Comprobamos si el número es cero
    je .es_cero                                               ; Si es cero, saltamos al manejo especial

.convierte_loop:
    xor rdx, rdx                                              ; Limpiamos RDX. Crucial para DIV (RDX:RAX / RBX)
    div rbx                                                   ; Divide RDX:RAX por RBX. Cociente en RAX, Resto en RDX
    add dl, '0'                                               ; Convierte el dígito (en DL) a su carácter ASCII
    mov byte [rsi], dl                                        ; Guarda el carácter ASCII en la posición actual de RSI
    dec rsi                                                   ; Retrocede RSI para el siguiente dígito
    cmp rax, 0                                                ; ¿Hemos procesado todos los dígitos?
    jne .convierte_loop                                       ; Si RAX no es cero, continuamos el bucle

    inc rsi                                                   ; IMPORTANTE: Ajustamos RSI para que apunte al PRIMER DÍGITO
    jmp .imprimir_paso1                                       ; Saltamos a la sección de impresión

.es_cero:
    mov byte [rsi], '0'                                       ; Coloca el carácter '0'
    inc rsi                                                   ; Ajusta RSI para que apunte al '0'

.imprimir_paso1:

    ; --- 4. Imprimir el Mensaje ("El resultado de la multiplicacion es: ") ---

    mov rax, 1                                                ; syscall: write
    mov rdi, 1                                                ; File descriptor (1 = STDOUT)
    mov rsi, msg                                              ; Puntero al mensaje
    mov rdx, len_msg                                          ; Longitud del mensaje
    syscall                                                   ; Ejecuta la llamada al sistema

    ; --- 5. Imprimir el Resultado Numérico (ASCII) y el Salto de Línea ---

    mov rax, 1                                                
    mov rdi, 1                                                
    mov rsi, rsi                                              ; RSI ya apunta al primer dígito del número

    mov rdx, numero_buf + LEN_NUM_BUFFER_DIGITS + 2          ; Apunta al BYTE DEL NULL TERMINATOR
    sub rdx, rsi                                              ; La resta nos da la longitud exacta desde RSI hasta el NULL
    syscall                                                   ; Ejecuta la llamada al sistema
    
    ; --- 6. Salir del Programa ---

    mov rax, 60                                               ; syscall: exit
    xor rdi, rdi                                              ; Código de salida 0 
    syscall