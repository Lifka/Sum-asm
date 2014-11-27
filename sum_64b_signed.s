#	
#	* Javier Izquierdo Vera
#	* javierizquierdovera@gmail.com
#	* UGR
#
.section .data

# Para facilitarlo
.macro linea 
	#	.int 1,1,1,1
	#	.int 2,2,2,2
	#	.int 1,2,3,4 
		.int -1,-1,-1,-1 
	#	.int 0xffffffff,0xffffffff,0xffffffff,0xffffffff
	#	.int 0x08000000,0x08000000,0x08000000,0x08000000
	#	.int 0x10000000,0x20000000,0x40000000,0x80000000
	.endm
	
 lista: .irpc i,12345678
		linea 
	.endr

#lista:		.int 1,2,10,  1,2,0b10,  1,2,0x10 #Lista antigua suma.s
longlista:	.int (.-lista)/4 # Posición - la pos d ela lista para saber el tamaño, entre 4 porque son 4 números
#resultado:	.int -1 #Antiguo suma.s

# Rusultado 64 bits
resultado: .quad 0x8877665544332211 # Formato de 64 bits, dos .int, la dirección es arbitraria pero esta viene bien
formato:   .string "i:%lli / u:%llu / 0x%llx\n"


.section .text
	.extern printf # printf es una función externa

#Main para facilitarlo
main:	.global main

	mov    $lista, %ebx  # Son para salvar, guardamos lista en ebx
	mov longlista, %ecx # Guardamos el tamaño de lista en ecx
	call suma
	mov %eax, resultado #EAX Parte menos significativa 32 bits
	mov %edx, resultado+4 #EDX Parte más significativa 32 bits
	
	call printf2 # Hemos guardado el printf en una subrutina que nos imprime el resultado
	
	# Salir del programa
	mov $1, %eax
	mov $0, %ebx
	int $0x80 

printf2:
	# Para printf de 64
	# Son tres formatos, de modo que tenemos que meterlo 3 veces en la pila para imprimirlo
	# Primera vez
	pushl resultado + 4 # Primero la parte significativa = 32 bits
	pushl resultado # Luego la menos significativa = 32 bits
	# Ya tenemos los 64 bits
	# Segunda
	pushl resultado + 4
	pushl resultado
	# Tercera
	pushl resultado + 4
	pushl resultado
	# Cargamos el formato
	pushl $formato
	# Imprimimos
	call printf
	# Corregimos la pila
	add $28, %esp # Sumamos 28 al puntero de pila (4 * 7 push) para saber donde estamos

	# Volvemos al main
	ret

suma:
	#push %edx
	#mov $0, %eax
	#mov $0, %edx

	#Nuevo
	# Ponemos los registros que vamos a usar a 0
	mov $0, %eax # Parte menos significativa de resultado
	mov $0, %edx # Parte más significativa

	pushl %esi

	mov $0, %esi # Para el índice, la iteración
bucle:
	#add (%ebx,%edx,4), %eax
	#inc       %edx
	#cmp  %edx,%ecx
	#jne bucle

	#pop %edx
	#ret

	#Nuevo
	mov (%ebx,%esi,4), %eax
	cltd # Convierte 32 bits en 64 bits, duplicando el signo

	add  %eax,%edi
	adc  %edx,%ebp

	inc %esi # Incrementar índice
	cmp %esi,%ecx # Comparar índice con tamaño
	jne bucle # Si el índice no e sigual al tamaño, saltamos al bucle

	mov %edi,%eax
	mov %ebp, %edx

	pop %esi
	ret 
