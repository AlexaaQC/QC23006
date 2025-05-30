section .data
    msg db "El resultado de resta es: "
    len_msg equ $ - msg
    newline db 10

section .bss
    numero_str resb 10       # Buffer para el número convertido

section .text
    global _start

_start:
    # --- 1. Realizar la Resta (usando registros de 16 bits) ---
    mov ax, 50               # Primer número
    mov bx, 30               # Segundo número  
    mov cx, 5                # Tercer número
    sub ax, bx               # 50 - 30 = 20
    sub ax, cx               # 20 - 5 = 15
    # Resultado (15) está en AX

    # --- 2. Imprimir el Mensaje ---
    mov rax, 1               # syscall: write
    mov rdi, 1               # STDOUT
    mov rsi, msg             # Puntero al mensaje
    mov rdx, len_msg         # Longitud del mensaje
    syscall

    # --- 3. Convertir Número a String ---
    movzx rax, ax            # Extender AX a RAX
    mov rsi, numero_str      # Puntero al buffer
    add rsi, 9               # Ir al final del buffer
    mov byte [rsi], 0        # Terminador nulo
    dec rsi

    mov rbx, 10              # Base 10

.convert_loop:
    xor rdx, rdx             # Limpiar RDX
    div rbx                  # RAX / 10, resto en RDX
    add dl, '0'              # Convertir dígito a ASCII
    mov [rsi], dl            # Guardar dígito
    dec rsi                  # Mover puntero hacia atrás
    test rax, rax            # ¿RAX = 0?
    jnz .convert_loop        # Continuar si no es cero

    inc rsi                  # RSI apunta al primer dígito

    # --- 4. Calcular longitud del número ---
    mov rdx, numero_str
    add rdx, 9               # Apuntar al final
    sub rdx, rsi             # Calcular longitud

    # --- 5. Imprimir el Número ---
    mov rax, 1               # syscall: write
    mov rdi, 1               # STDOUT
    # RSI ya apunta al número
    # RDX ya tiene la longitud
    syscall

    # --- 6. Imprimir Nueva Línea ---
    mov rax, 1               # syscall: write
    mov rdi, 1               # STDOUT
    mov rsi, newline         # Puntero al salto de línea
    mov rdx, 1               # 1 carácter
    syscall

    # --- 7. Salir del Programa ---
    mov rax, 60              # syscall: exit
    xor rdi, rdi             # Código de salida 0
    syscall