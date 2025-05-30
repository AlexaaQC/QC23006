section .data
    msg1    db 'Dividendo: ', 0       ; Mensaje para solicitar dividendo
    msg2    db 'Divisor: ', 0         ; Mensaje para solicitar divisor
    msg3    db 'Cociente: ', 0        ; Mensaje para mostrar resultado
    msg4    db 'Residuo: ', 0         ; Mensaje para mostrar residuo
    error   db 'Error: División por cero', 10, 0  
    newline db 10, 0                  

section .bss
    num1    resd 1                    ; Variable para dividendo (32 bits)
    num2    resd 1                    ; Variable para divisor (32 bits)
    buffer  resb 10                   ; Buffer para entrada de datos

section .text
    global _start

_start:
    ; Leer dividendo
    call print_msg1                   ; Mostrar "Dividendo: "
    call read_num                     
    mov [num1], eax                   ; Guardar dividendo en memoria
    
    ; Leer divisor
    call print_msg2                   ; Mostrar "Divisor: "
    call read_num                     
    mov [num2], eax                   ; Guardar divisor en memoria
    
    ; Verificar división por cero
    cmp eax, 0                        ; ¿Divisor es cero?
    je show_error                     ; Si es cero, mostrar error
    
    ; Realizar división usando registros de 32 bits
    mov eax, [num1]                   ; Cargar dividendo en EAX (32 bits)
    xor edx, edx                      ; Limpiar EDX (parte alta del dividendo)
    div dword [num2]                  ; División: EAX = cociente, EDX = residuo
    
    ; Mostrar cociente
    push edx                          ; Guardar residuo en stack
    call print_msg3                   ; Mostrar "Cociente: "
    call print_num                    ; Imprimir valor de EAX
    call print_newline                
    
    ; Mostrar residuo
    pop eax                           ; Recuperar residuo del stack
    call print_msg4                   ; Mostrar "Residuo: "
    call print_num                    ; Imprimir residuo
    call print_newline                
    jmp exit                          ; Terminar programa

show_error:
    mov eax, 4                        ; Syscall write
    mov ebx, 1                        ; stdout
    mov ecx, error                    ; Mensaje de error
    mov edx, 23                       ; Longitud del mensaje
    int 0x80                          ; Llamada al sistema

exit:
    mov eax, 1                        ; Syscall exit
    xor ebx, ebx                      ; Código de salida 0
    int 0x80                          ; Terminar programa

; Funciones auxiliares
print_msg1:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg1
    mov edx, 11
    int 0x80
    ret

print_msg2:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg2
    mov edx, 9
    int 0x80
    ret

print_msg3:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg3
    mov edx, 10
    int 0x80
    ret

print_msg4:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg4
    mov edx, 9
    int 0x80
    ret

print_newline:
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80
    ret

read_num:
    ; Leer entrada del teclado
    mov eax, 3                        ; Syscall read
    mov ebx, 0                        ; stdin
    mov ecx, buffer                   ; Buffer para almacenar entrada
    mov edx, 10                       ; Máximo 10 caracteres
    int 0x80                          ; Llamada al sistema
    
    ; Convertir string a número entero
    mov esi, buffer                   ; Apuntar al inicio del buffer
    xor eax, eax                      ; Limpiar EAX (resultado)
    xor ebx, ebx                      ; Limpiar EBX (dígito temporal)
    
convert_loop:
    mov bl, [esi]                     ; Cargar carácter actual
    cmp bl, 10                        
    je convert_done                   
    cmp bl, '0'                       
    jl convert_done                   
    cmp bl, '9'                       
    jg convert_done                   
    
    sub bl, '0'                       ; Convertir ASCII a valor numérico
    imul eax, 10                      ; Multiplicar resultado por 10
    add eax, ebx                      ; Sumar nuevo dígito
    inc esi                           
    jmp convert_loop                  ; Repetir para siguiente dígito
    
convert_done:
    ret                               ; Retornar con número en EAX

print_num:
    ; Convertir número a string y mostrar
    mov ebx, 10                       ; Base decimal
    xor ecx, ecx                      ; Contador de dígitos
    
    cmp eax, 0                        
    jne divide_loop                   
    mov byte [buffer], '0'            
    mov byte [buffer+1], 0            
    jmp print_buffer                  ; Ir a imprimir
    
divide_loop:
    xor edx, edx                      ; Limpiar EDX para división
    div ebx                           ; EAX = EAX/10, EDX = dígito
    add edx, '0'                      ; Convertir dígito a ASCII
    push edx                          ; Guardar dígito en stack
    inc ecx                           ; Incrementar contador
    cmp eax, 0                        ; ¿Quedan más dígitos?
    jne divide_loop                   ; Si quedan, continuar dividiendo
    
    mov esi, buffer                   ; Apuntar al buffer
store_loop:
    pop edx                           ; Obtener dígito del stack
    mov [esi], dl                     ; Almacenar en buffer
    inc esi                           ; Avanzar posición
    dec ecx                           ; Decrementar contador
    jnz store_loop                    ; Repetir hasta procesar todos
    mov byte [esi], 0                 ; Terminar string con null
    
print_buffer:
    mov eax, 4                        ; Syscall write
    mov ebx, 1                        ; stdout
    mov ecx, buffer                   ; Buffer a imprimir
    mov edx, 10                       ; Longitud máxima
    int 0x80                          ; Llamada al sistema
    ret                               ; Retornar