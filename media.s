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
longlista:	.int (.-lista)/4
#resultado:	.int -1 #Antiguo suma.s
media:		.int 0x89ABCDEF
resto:		.int 0x01234567

# Rusultado 64 bits
# resultado: .quad 0x8877665544332211
formato:   #.string "i:%lli / u:%llu / 0x%llx\n"
	.ascii "media= %8d \t resto= %8d \n"
	.ascii "hexadecimal= 0x%08x \t resto= 0x%08x \n\0"


.section .text
	.extern printf
#Main para facilitarlo
main:	.global main

	mov    $lista, %ebx
	mov longlista, %ecx
	call suma
	mov %eax, media # Media
	mov %edx, resto # Resto

	call printf2

	# Todo lo siguiente es para salir
	mov $1, %eax
	mov $0, %ebx
	int $0x80 

printf2:
	# Para printf de 64
	push resto
	push media
	push resto
	push media
	push $formato
	call printf
	add $20, %esp
	ret

suma:
	mov $0, %edi
	mov $0, %ebp
	mov $0, %esi

bucle:
	mov (%ebx,%esi,4), %eax
	cltd 
	add  %eax,%edi
	adc  %edx,%ebp
	inc %esi
	cmp %esi,%ecx
	jne bucle
	mov %edi,%eax
	mov %ebp, %edx

	idiv %ecx # Media
	ret 
