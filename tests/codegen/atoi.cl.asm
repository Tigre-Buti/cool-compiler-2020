.data
StringAbort: .asciiz "Abort called from class String\n"
st0: .asciiz "Object"
st1: .asciiz "A2I"
st2: .asciiz "0"
st3: .asciiz "1"
st4: .asciiz "2"
st5: .asciiz "3"
st6: .asciiz "4"
st7: .asciiz "5"
st8: .asciiz "6"
st9: .asciiz "7"
st10: .asciiz "8"
st11: .asciiz "9"
st12: .asciiz "0"
st13: .asciiz "1"
st14: .asciiz "2"
st15: .asciiz "3"
st16: .asciiz "4"
st17: .asciiz "5"
st18: .asciiz "6"
st19: .asciiz "7"
st20: .asciiz "8"
st21: .asciiz "9"
st22: .asciiz ""
st23: .asciiz "-"
st24: .asciiz "+"
st25: .asciiz "0"
st26: .asciiz "-"
st27: .asciiz ""
st28: .asciiz "IO"
st29: .asciiz "String"
st30: .asciiz "Bool"
st31: .asciiz "Main"
st32: .asciiz "678987"
st33: .asciiz " == "
st34: .asciiz "\n"
Objectclase: .word 0,f0,f3,f2,f4
A2Iclase: .word Objectclase,f5,f6,f2,f4,f7,f8,f9,f10,f11,f12
IOclase: .word Objectclase,f13,f14,f2,f4,f15,f16,f17,f18
Stringclase: .word Objectclase,f19,f20,f2,f4,f21,f22,f23
Boolclase: .word Objectclase,f24,f25,f2,f4
Mainclase: .word IOclase,f26,f27,f2,f4,f15,f16,f17,f18,f28
.text
.globl main
main:
addi $sp ,$sp, -4
sw $ra, 0($sp)
jal Main.Special
lw $ra, 0($sp)
addi $sp ,$sp, 4
jr $ra
li $v0, 10
syscall
     #$a0 debe ser el string
     .IO.out_string:
     li $v0, 4
     syscall
     jr $ra

     #$a0 debe ser el string
     .IO.out_int:
     li $v0, 1
     syscall
     jr $ra

     .IO.in_int:
     li $v0, 5
     syscall
     jr $ra

     .IO.in_string:
     li $v0, 9
     move $s0, $a0
     li $a0, 1024
     syscall
     move $t1, $v0
     move $a0, $v0
     li $a1, 1024
     li $v0, 8
     syscall
     move $v0, $t1
     #Buscando y arreglando posible salto de linea
     move $t0, $v0
     move $t1, $zero
     li $t2, 10
     Iniciochequeofinlinea:
     lb $t1, 0($t0)
     beq $t1, $t2, Cambiafinlinea
     addi $t0, $t0, 1
     bne $t1, $zero, Iniciochequeofinlinea
     jr $ra
     Cambiafinlinea:
     sb $zero, 0($t0)
     jr $ra

     #Los numeros como argumentos $a0 y $a1, y $a2 como donde guardar el resultado
     .Int.suma:
     lw $t1, 0($a0)
     lw $t2, 0($a1)
     add $v0, $t1, $t2
     sw $v0, 0($a2)
     jr $ra

     .Int.resta:
     lw $t1, 0($a0)
     lw $t2, 0($a1)
     sub $v0, $t1, $t2
     sw $v0, 0($a2)
     jr $ra

     .Int.multiplicacion:
     lw $t1, 0($a0)
     lw $t2, 0($a1)
     mult $t1, $t2
     mflo $v0
     sw $v0, 0($a2)
     jr $ra

     .Int.division:
     lw $t1, 0($a0)
     lw $t2, 0($a1)
     div $t1, $t2
     mflo $v0
     sw $v0, 0($a2)
     jr $ra

     .Int.lesser:
     lw $t1, 0($a0)
     lw $t2, 0($a1)
     blt $t1, $t2, LesserTrue
     move $v0, $zero
     b LesserEnd
     LesserTrue:
     li $v0, 1
     LesserEnd:
     sw $v0, 0($a2)
     jr $ra

     .Int.lesserequal:
     lw $t1, 0($a0)
     lw $t2, 0($a1)
     ble $t1, $t2, LesserEqualTrue
     li $v0, 0
     b LesserEqualEnd
     LesserEqualTrue:
     li $v0, 1
     LesserEqualEnd:
     sw $v0, 0($a2)
     jr $ra

     .Int.not:
     lw $t1, 0($a0)
     move $t2, $zero
     beq $t1, $t2, FalseBool
     li $v0, 0
     b NotBool
     FalseBool:
     li $v0, 1
     NotBool:
     sw $v0, 0($a1)
     jr $ra

     .Int.igual:
     move $t1, $a0
     move $t2, $a1
     beq $t1, $t2, Iguales
     li $v0, 0
     b FinalIgual
     Iguales:
     li $v0, 1
     FinalIgual:
     sw $v0, 0($a2)
     jr $ra

     .Str.stringlength:
     move $t1, $a0
     move $v0, $zero
     move $t2, $zero

     InicioStrLen:
     add $t0, $t1, $v0
     lb $t2, 0($t0)
     beq $t2, $zero, FinStrLen
     addi $v0, $v0, 1
     b InicioStrLen

     FinStrLen:
     #sw $v0, 0($a1) El protocolo cambi�
     jr $ra

     .Object.abort:
     li $v0, 4
     la $a0, StringAbort
     syscall
     li $v0, 10
     syscall
     jr $ra

     .Str.stringcomparison:
     move $t1, $a0
     move $t2, $a1
     move $v0, $zero
     move $t3, $zero
     move $t4, $zero
     move $v0, $zero

     StrCompCiclo:
     add $t0, $t1, $v0
     lb $t3, 0($t0)
     add $t0, $t2, $v0
     lb $t4, 0($t0)
     addi $v0, $v0, 1
     bne $t3, $t4, StrDiferentes
     beq $t3, $zero, StrIguales
     b StrCompCiclo

     StrDiferentes:
     move $v0, $zero
     jr $ra
     StrIguales:
     li $v0, 1
     jr $ra

     .Str.stringconcat:
     addi $sp, $sp, -20

     sw  $s0, 0($sp)
     sw  $s1, 4($sp)
     sw  $s2, 8($sp)
     sw  $s3, 12($sp)
     sw  $s4, 16($sp)

     move $s0, $a0
     move $s1, $a1
     move $s2, $a2
     move $s3, $ra

     jal .Str.stringlength
     move $s4, $v0
     move $a0, $s1
     jal .Str.stringlength
     add $s4, $s4, $v0
     addi $s4, $s4, 1

     #Reservando memoria
     move $a0, $s4 
     li $v0, 9
     syscall

     move $t0, $v0
     move $t1, $zero
     move $t2, $s0
     move $t3, $s1

     InicioCicloCopia:
     lb $t1, 0($t2)
     beq $t1, $zero, SegundoString
     sb $t1, 0($t0)
     addi $t0, $t0, 1
     addi $t2, $t2, 1
     b InicioCicloCopia

     SegundoString:
     lb $t1, 0($t3)
     beq $t1, $zero, FinalCopia
     sb $t1, 0($t0)
     addi $t0, $t0, 1
     addi $t3, $t3, 1
     b SegundoString

     FinalCopia:
     sb $zero, 0($t0)


     move $a0, $s0
     move $a1, $s1
     move $a2, $s2
     move $ra, $s3

     lw $s0, 0($sp)
     lw $s1, 4($sp)
     lw $s2, 8($sp)
     lw $s3, 12($sp)
     lw $s4, 16($sp)

     addi $sp, $sp, 20

     jr $ra

     #Old.Str.stringconcat:
     #Salvando registros
     addi $sp, $sp, -20
     
     sw  $s0, 4($sp)
     sw  $s1, 8($sp)
     sw  $s2, 12($sp)
     sw  $s3, 16($sp)

     move $s0, $a0
     move $s1, $a1
     move $s2, $a2
     move $s3, $ra
     
     #sw $a0, 0($sp)

     #Obteniendo el lenght de la nueva cadena
     jal .Str.stringlength
     move $s4, $v0
     move $a0, $s1
     #move $a1, $sp
     jal .Str.stringlength
     add $s4, $s4, $v0
     addi $sp, $sp, 4
     addi $s4, $s4, 1

     #Reservando memoria
     move $a0, $s4 
     li $v0, 9
     syscall

     move $t0, $v0
     move $t1, $s0
     move $t2, $zero
     move $t3, $zero
     
     StrCicloCopia:
     lb $t2, 0($t1)
     addi $t1, 1
     addi $t0, 1
     
     bne $t2, $zero, StrCicloCopia
     sb $t2, 0($t0)

     bne $t3, $zero, StrFinCopia
     move $t1, $s1

     b StrCicloCopia

     StrFinCopia:
     sb $zero, 0($t0)

     #sw $v0, 0($s2)

     move $a0, $s0
     move $a1, $s1
     move $a2, $s2
     move $ra, $s3

     lw $s0, 4($sp)
     lw $s1, 8($sp)
     lw $s2, 12($sp)
     lw $s3, 16($sp)

     addi $sp, $sp, 20

     jr $ra

     .Str.substring:
     addi $sp, $sp, -16
     
     sw  $s0 4($sp)
     sw  $s1 8($sp)
     sw  $s2 12($sp)

     move $s0, $a0
     move $s1, $a1
     move $s2, $a2

     addi $a0, $a2, 1 
     li $v0, 9
     syscall

     add $t0, $s0, $s1
     move $t1, $zero
     move $t2, $zero

     iniciocopianuevosubstr:

     add $t3, $v0, $t1
     lb $t2, 0($t0)
     sb $t2, 0($t3)

     addi $t0, $t0, 1
     addi $t1, $t1, 1

     blt $t1, $s2, iniciocopianuevosubstr
     add $t3, $v0, $t1
     sb $zero, 0($t3)

     move $a0, $s0
     move $a1, $s1
     move $a2, $s2

     lw $s0, 4($sp)
     lw $s1, 8($sp)
     lw $s2, 12($sp)

     addi $sp, $sp, 16

     jr $ra



     .Str.substringOld:
     blt $a1, $zero, SubStrWrongIndex

     addi $sp, $sp, -20
     
     sw  $s0 4($sp)
     sw  $s1 8($sp)
     sw  $s2 12($sp)
     sw  $s3 16($sp)

     move $s0, $a0
     move $s1, $a1
     move $s2, $a2
     move $s3, $ra

      
     jal .Str.stringlength

     blt $v0, $s1, SubStrWrongIndex

     addi $v0, $v0, 1

     #Reservando memoria
     move $a0, $v0 
     li $v0, 9
     syscall

     move $t0, $v0
     move $t1, $s0
     move $t2, $zero

     StrInicioCopiaSubStr:
     lb $t3, 0($t1)
     sb $t3, 0($t0)
     addi $t0, $t0, 1
     addi $t1, $t0, 1
     addi $t2, $t2, 1
     ble $t2, $s1, StrInicioCopiaSubStr

     sb $zero, 0($t0)
     
     sw $v0, 0($s2)

     move $ra, $s3

     move $a0, $s0
     move $a1, $s1
     move $a2, $s2

     lw $s0, 4($sp)
     lw $s1, 8($sp)
     lw $s2, 12($sp)
     lw $s3, 16($sp)

     addi $sp, $sp, 20

     jr $ra

     SubStrWrongIndex:
     la $a0, index_error
     li $v0, 4
     syscall
     li $v0, 10
     syscall
     
     #En este m�todo viol� la regla usual de que los par�metros van en los registros a, y se encuentran en los t.
     #Esto se realiz� ya que este m�todo solo se usa en un lugar y atendiendo a la estructura del conversor a MIPS
     .Object.Copy:
     addi $sp, $sp, -8

     sw $s0, 0($sp)
     sw $s1, 4($sp)
     move $s0, $t0
     move $s1, $t1
     addi $s1, 1
     move $a0, $s1
     li $v0, 9
     syscall
     move $t1, $v0
     $ciclocopia:
     beq $s1, $zero, $finciclocopia
     lw $t0, 0($s0)
     sw $t0, 0($t1)
     addi $s0, 4
     addi $t1, 4
     addi $s1, -1
     b $ciclocopia
     $finciclocopia:
     lw $s0, 0($sp)
     lw $s1, 4($sp)
     addi $sp, 8
     jr $ra

     .TypeCheck:
     #lw $t0, 0($t0)
     InicioChequeo:
     lw $t0, 0($t0)
     beq $t0, $zero, ChequeoFalse
     beq $t0, $t1, ChequeoTrue
     b InicioChequeo
     ChequeoFalse:
     move $v0, $zero
     jr $ra
     ChequeoTrue:
     li $v0, 1
     jr $ra
Main.Special: #Main.special.main
addi $sp, $sp, -12
addi $sp, $sp, -4
sw $a0, 0($sp)
li $a0,4
li $v0, 9
syscall
la $t0, Mainclase
sw $t0, 0($v0)
lw $a0, 0($sp)
addi $sp, $sp, 4
sw $v0,4($sp)
lw $t0,4($sp)
#Argument var.var309
addi $sp, $sp, -4
sw $a0, 0($sp)
move $a0,$t0
lw $t0, 0($a0)
lw $t0,4($t0)
addi $sp, $sp, -4
sw $ra, 0($sp)
jalr $ra,$t0 #var.var309<-['Main', '$init']
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $a0, 0($sp)
addi $sp, $sp, 4
sw $v0,4($sp)
lw $t0,4($sp)
#Argument var.var309
addi $sp, $sp, -4
sw $a0, 0($sp)
move $a0,$t0
lw $t0, 0($a0)
lw $t0,36($t0)
addi $sp, $sp, -4
sw $ra, 0($sp)
jalr $ra,$t0 #var.var310<-['Main', 'main']
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $a0, 0($sp)
addi $sp, $sp, 4
sw $v0,8($sp)
addi $sp, $sp, 12
jr $ra
f0: #Object.$init
addi $sp, $sp, -8
move $t0,$a0
move $v0, $t0
sw $v0,4($sp)
addi $sp, $sp, 8
jr $ra
f3: #Object.type_name
addi $sp, $sp, -12
la $v0, st0
sw $v0,8($sp)
addi $sp, $sp, 12
jr $ra
f4: #Object.Copy
addi $sp, $sp, -8
move $t0,$a0
li $t1,0
addi $sp ,$sp, -4
sw $ra, 0($sp)
jal .Object.Copy
lw $ra, 0($sp)
addi $sp ,$sp, 4
sw $v0,4($sp)
addi $sp, $sp, 8
jr $ra
f2: #Object.Abort
addi $sp, $sp, -8
jal .Object.abort
addi $sp, $sp, 8
jr $ra
f5: #A2I.$init
addi $sp, $sp, -12
move $t0,$a0
#Argument self
addi $sp, $sp, -4
sw $a0, 0($sp)
move $a0,$t0
la $t0,Objectclase
lw $t0,4($t0)
addi $sp, $sp, -4
sw $ra, 0($sp)
jal $t0 #var.var7<-['Object', '$init']
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $a0, 0($sp)
addi $sp, $sp, 4
sw $v0,4($sp)
move $t0,$a0
move $v0, $t0
sw $v0,8($sp)
addi $sp, $sp, 12
jr $ra
f6: #A2I.type_name
addi $sp, $sp, -12
la $v0, st1
sw $v0,8($sp)
addi $sp, $sp, 12
jr $ra
f7: #A2I.c2i
addi $sp, $sp, -336
move $t0,$a1
move $v0, $t0
sw $v0,4($sp)
la $v0, st2
sw $v0,12($sp)
lw $t0,4($sp)
lw $t1,12($sp)
addi $sp, $sp, -12
sw $a0, 0($sp)
sw $a1, 4($sp)
sw $ra, 8($sp)
move $a0, $t0
move $a1, $t1
jal .Str.stringcomparison
lw $a0, 0($sp)
lw $a1, 4($sp)
lw $ra, 8($sp)
addi $sp, $sp, 12
sw $v0,20($sp)
lw $t0,20($sp)
bgtz $t0, Lbl18
move $t0,$a1
move $v0, $t0
sw $v0,28($sp)
la $v0, st3
sw $v0,36($sp)
lw $t0,28($sp)
lw $t1,36($sp)
addi $sp, $sp, -12
sw $a0, 0($sp)
sw $a1, 4($sp)
sw $ra, 8($sp)
move $a0, $t0
move $a1, $t1
jal .Str.stringcomparison
lw $a0, 0($sp)
lw $a1, 4($sp)
lw $ra, 8($sp)
addi $sp, $sp, 12
sw $v0,44($sp)
lw $t0,44($sp)
bgtz $t0, Lbl16
move $t0,$a1
move $v0, $t0
sw $v0,52($sp)
la $v0, st4
sw $v0,60($sp)
lw $t0,52($sp)
lw $t1,60($sp)
addi $sp, $sp, -12
sw $a0, 0($sp)
sw $a1, 4($sp)
sw $ra, 8($sp)
move $a0, $t0
move $a1, $t1
jal .Str.stringcomparison
lw $a0, 0($sp)
lw $a1, 4($sp)
lw $ra, 8($sp)
addi $sp, $sp, 12
sw $v0,68($sp)
lw $t0,68($sp)
bgtz $t0, Lbl14
move $t0,$a1
move $v0, $t0
sw $v0,76($sp)
la $v0, st5
sw $v0,84($sp)
lw $t0,76($sp)
lw $t1,84($sp)
addi $sp, $sp, -12
sw $a0, 0($sp)
sw $a1, 4($sp)
sw $ra, 8($sp)
move $a0, $t0
move $a1, $t1
jal .Str.stringcomparison
lw $a0, 0($sp)
lw $a1, 4($sp)
lw $ra, 8($sp)
addi $sp, $sp, 12
sw $v0,92($sp)
lw $t0,92($sp)
bgtz $t0, Lbl12
move $t0,$a1
move $v0, $t0
sw $v0,100($sp)
la $v0, st6
sw $v0,108($sp)
lw $t0,100($sp)
lw $t1,108($sp)
addi $sp, $sp, -12
sw $a0, 0($sp)
sw $a1, 4($sp)
sw $ra, 8($sp)
move $a0, $t0
move $a1, $t1
jal .Str.stringcomparison
lw $a0, 0($sp)
lw $a1, 4($sp)
lw $ra, 8($sp)
addi $sp, $sp, 12
sw $v0,116($sp)
lw $t0,116($sp)
bgtz $t0, Lbl10
move $t0,$a1
move $v0, $t0
sw $v0,124($sp)
la $v0, st7
sw $v0,132($sp)
lw $t0,124($sp)
lw $t1,132($sp)
addi $sp, $sp, -12
sw $a0, 0($sp)
sw $a1, 4($sp)
sw $ra, 8($sp)
move $a0, $t0
move $a1, $t1
jal .Str.stringcomparison
lw $a0, 0($sp)
lw $a1, 4($sp)
lw $ra, 8($sp)
addi $sp, $sp, 12
sw $v0,140($sp)
lw $t0,140($sp)
bgtz $t0, Lbl8
move $t0,$a1
move $v0, $t0
sw $v0,148($sp)
la $v0, st8
sw $v0,156($sp)
lw $t0,148($sp)
lw $t1,156($sp)
addi $sp, $sp, -12
sw $a0, 0($sp)
sw $a1, 4($sp)
sw $ra, 8($sp)
move $a0, $t0
move $a1, $t1
jal .Str.stringcomparison
lw $a0, 0($sp)
lw $a1, 4($sp)
lw $ra, 8($sp)
addi $sp, $sp, 12
sw $v0,164($sp)
lw $t0,164($sp)
bgtz $t0, Lbl6
move $t0,$a1
move $v0, $t0
sw $v0,172($sp)
la $v0, st9
sw $v0,180($sp)
lw $t0,172($sp)
lw $t1,180($sp)
addi $sp, $sp, -12
sw $a0, 0($sp)
sw $a1, 4($sp)
sw $ra, 8($sp)
move $a0, $t0
move $a1, $t1
jal .Str.stringcomparison
lw $a0, 0($sp)
lw $a1, 4($sp)
lw $ra, 8($sp)
addi $sp, $sp, 12
sw $v0,188($sp)
lw $t0,188($sp)
bgtz $t0, Lbl4
move $t0,$a1
move $v0, $t0
sw $v0,196($sp)
la $v0, st10
sw $v0,204($sp)
lw $t0,196($sp)
lw $t1,204($sp)
addi $sp, $sp, -12
sw $a0, 0($sp)
sw $a1, 4($sp)
sw $ra, 8($sp)
move $a0, $t0
move $a1, $t1
jal .Str.stringcomparison
lw $a0, 0($sp)
lw $a1, 4($sp)
lw $ra, 8($sp)
addi $sp, $sp, 12
sw $v0,212($sp)
lw $t0,212($sp)
bgtz $t0, Lbl2
move $t0,$a1
move $v0, $t0
sw $v0,220($sp)
la $v0, st11
sw $v0,228($sp)
lw $t0,220($sp)
lw $t1,228($sp)
addi $sp, $sp, -12
sw $a0, 0($sp)
sw $a1, 4($sp)
sw $ra, 8($sp)
move $a0, $t0
move $a1, $t1
jal .Str.stringcomparison
lw $a0, 0($sp)
lw $a1, 4($sp)
lw $ra, 8($sp)
addi $sp, $sp, 12
sw $v0,236($sp)
lw $t0,236($sp)
bgtz $t0, Lbl0
move $t0,$a0
move $v0, $t0
sw $v0,244($sp)
lw $t0,244($sp)
#Argument var.var60
addi $sp, $sp, -4
sw $a0, 0($sp)
move $a0,$t0
lw $t0, 0($a0)
lw $t0,12($t0)
addi $sp, $sp, -4
sw $ra, 0($sp)
jalr $ra,$t0 #var.var61<-['A2I', 'abort']
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $a0, 0($sp)
addi $sp, $sp, 4
sw $v0,248($sp)
li $t0,0
move $v0, $t0
sw $v0,252($sp)
lw $t0,252($sp)
move $v0, $t0
sw $v0,256($sp)
b Lbl1
Lbl0:
li $t0,9
move $v0, $t0
sw $v0,240($sp)
lw $t0,240($sp)
move $v0, $t0
sw $v0,256($sp)
Lbl1:
lw $t0,256($sp)
move $v0, $t0
sw $v0,260($sp)
lw $t0,260($sp)
move $v0, $t0
sw $v0,264($sp)
b Lbl3
Lbl2:
li $t0,8
move $v0, $t0
sw $v0,216($sp)
lw $t0,216($sp)
move $v0, $t0
sw $v0,264($sp)
Lbl3:
lw $t0,264($sp)
move $v0, $t0
sw $v0,268($sp)
lw $t0,268($sp)
move $v0, $t0
sw $v0,272($sp)
b Lbl5
Lbl4:
li $t0,7
move $v0, $t0
sw $v0,192($sp)
lw $t0,192($sp)
move $v0, $t0
sw $v0,272($sp)
Lbl5:
lw $t0,272($sp)
move $v0, $t0
sw $v0,276($sp)
lw $t0,276($sp)
move $v0, $t0
sw $v0,280($sp)
b Lbl7
Lbl6:
li $t0,6
move $v0, $t0
sw $v0,168($sp)
lw $t0,168($sp)
move $v0, $t0
sw $v0,280($sp)
Lbl7:
lw $t0,280($sp)
move $v0, $t0
sw $v0,284($sp)
lw $t0,284($sp)
move $v0, $t0
sw $v0,288($sp)
b Lbl9
Lbl8:
li $t0,5
move $v0, $t0
sw $v0,144($sp)
lw $t0,144($sp)
move $v0, $t0
sw $v0,288($sp)
Lbl9:
lw $t0,288($sp)
move $v0, $t0
sw $v0,292($sp)
lw $t0,292($sp)
move $v0, $t0
sw $v0,296($sp)
b Lbl11
Lbl10:
li $t0,4
move $v0, $t0
sw $v0,120($sp)
lw $t0,120($sp)
move $v0, $t0
sw $v0,296($sp)
Lbl11:
lw $t0,296($sp)
move $v0, $t0
sw $v0,300($sp)
lw $t0,300($sp)
move $v0, $t0
sw $v0,304($sp)
b Lbl13
Lbl12:
li $t0,3
move $v0, $t0
sw $v0,96($sp)
lw $t0,96($sp)
move $v0, $t0
sw $v0,304($sp)
Lbl13:
lw $t0,304($sp)
move $v0, $t0
sw $v0,308($sp)
lw $t0,308($sp)
move $v0, $t0
sw $v0,312($sp)
b Lbl15
Lbl14:
li $t0,2
move $v0, $t0
sw $v0,72($sp)
lw $t0,72($sp)
move $v0, $t0
sw $v0,312($sp)
Lbl15:
lw $t0,312($sp)
move $v0, $t0
sw $v0,316($sp)
lw $t0,316($sp)
move $v0, $t0
sw $v0,320($sp)
b Lbl17
Lbl16:
li $t0,1
move $v0, $t0
sw $v0,48($sp)
lw $t0,48($sp)
move $v0, $t0
sw $v0,320($sp)
Lbl17:
lw $t0,320($sp)
move $v0, $t0
sw $v0,324($sp)
lw $t0,324($sp)
move $v0, $t0
sw $v0,328($sp)
b Lbl19
Lbl18:
li $t0,0
move $v0, $t0
sw $v0,24($sp)
lw $t0,24($sp)
move $v0, $t0
sw $v0,328($sp)
Lbl19:
lw $t0,328($sp)
move $v0, $t0
sw $v0,332($sp)
addi $sp, $sp, 336
jr $ra
f8: #A2I.i2c
addi $sp, $sp, -340
move $t0,$a1
move $v0, $t0
sw $v0,4($sp)
li $t0,0
move $v0, $t0
sw $v0,8($sp)
lw $t0,4($sp)
lw $t1,8($sp)
seq $v0 ,$t0, $t1
sw $v0,16($sp)
lw $t0,16($sp)
bgtz $t0, Lbl38
move $t0,$a1
move $v0, $t0
sw $v0,28($sp)
li $t0,1
move $v0, $t0
sw $v0,32($sp)
lw $t0,28($sp)
lw $t1,32($sp)
seq $v0 ,$t0, $t1
sw $v0,40($sp)
lw $t0,40($sp)
bgtz $t0, Lbl36
move $t0,$a1
move $v0, $t0
sw $v0,52($sp)
li $t0,2
move $v0, $t0
sw $v0,56($sp)
lw $t0,52($sp)
lw $t1,56($sp)
seq $v0 ,$t0, $t1
sw $v0,64($sp)
lw $t0,64($sp)
bgtz $t0, Lbl34
move $t0,$a1
move $v0, $t0
sw $v0,76($sp)
li $t0,3
move $v0, $t0
sw $v0,80($sp)
lw $t0,76($sp)
lw $t1,80($sp)
seq $v0 ,$t0, $t1
sw $v0,88($sp)
lw $t0,88($sp)
bgtz $t0, Lbl32
move $t0,$a1
move $v0, $t0
sw $v0,100($sp)
li $t0,4
move $v0, $t0
sw $v0,104($sp)
lw $t0,100($sp)
lw $t1,104($sp)
seq $v0 ,$t0, $t1
sw $v0,112($sp)
lw $t0,112($sp)
bgtz $t0, Lbl30
move $t0,$a1
move $v0, $t0
sw $v0,124($sp)
li $t0,5
move $v0, $t0
sw $v0,128($sp)
lw $t0,124($sp)
lw $t1,128($sp)
seq $v0 ,$t0, $t1
sw $v0,136($sp)
lw $t0,136($sp)
bgtz $t0, Lbl28
move $t0,$a1
move $v0, $t0
sw $v0,148($sp)
li $t0,6
move $v0, $t0
sw $v0,152($sp)
lw $t0,148($sp)
lw $t1,152($sp)
seq $v0 ,$t0, $t1
sw $v0,160($sp)
lw $t0,160($sp)
bgtz $t0, Lbl26
move $t0,$a1
move $v0, $t0
sw $v0,172($sp)
li $t0,7
move $v0, $t0
sw $v0,176($sp)
lw $t0,172($sp)
lw $t1,176($sp)
seq $v0 ,$t0, $t1
sw $v0,184($sp)
lw $t0,184($sp)
bgtz $t0, Lbl24
move $t0,$a1
move $v0, $t0
sw $v0,196($sp)
li $t0,8
move $v0, $t0
sw $v0,200($sp)
lw $t0,196($sp)
lw $t1,200($sp)
seq $v0 ,$t0, $t1
sw $v0,208($sp)
lw $t0,208($sp)
bgtz $t0, Lbl22
move $t0,$a1
move $v0, $t0
sw $v0,220($sp)
li $t0,9
move $v0, $t0
sw $v0,224($sp)
lw $t0,220($sp)
lw $t1,224($sp)
seq $v0 ,$t0, $t1
sw $v0,232($sp)
lw $t0,232($sp)
bgtz $t0, Lbl20
move $t0,$a0
move $v0, $t0
sw $v0,244($sp)
lw $t0,244($sp)
#Argument var.var133
addi $sp, $sp, -4
sw $a0, 0($sp)
move $a0,$t0
lw $t0, 0($a0)
lw $t0,12($t0)
addi $sp, $sp, -4
sw $ra, 0($sp)
jalr $ra,$t0 #var.var134<-['A2I', 'abort']
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $a0, 0($sp)
addi $sp, $sp, 4
sw $v0,248($sp)
la $v0, st22
sw $v0,256($sp)
lw $t0,256($sp)
move $v0, $t0
sw $v0,260($sp)
b Lbl21
Lbl20:
la $v0, st21
sw $v0,240($sp)
lw $t0,240($sp)
move $v0, $t0
sw $v0,260($sp)
Lbl21:
lw $t0,260($sp)
move $v0, $t0
sw $v0,264($sp)
lw $t0,264($sp)
move $v0, $t0
sw $v0,268($sp)
b Lbl23
Lbl22:
la $v0, st20
sw $v0,216($sp)
lw $t0,216($sp)
move $v0, $t0
sw $v0,268($sp)
Lbl23:
lw $t0,268($sp)
move $v0, $t0
sw $v0,272($sp)
lw $t0,272($sp)
move $v0, $t0
sw $v0,276($sp)
b Lbl25
Lbl24:
la $v0, st19
sw $v0,192($sp)
lw $t0,192($sp)
move $v0, $t0
sw $v0,276($sp)
Lbl25:
lw $t0,276($sp)
move $v0, $t0
sw $v0,280($sp)
lw $t0,280($sp)
move $v0, $t0
sw $v0,284($sp)
b Lbl27
Lbl26:
la $v0, st18
sw $v0,168($sp)
lw $t0,168($sp)
move $v0, $t0
sw $v0,284($sp)
Lbl27:
lw $t0,284($sp)
move $v0, $t0
sw $v0,288($sp)
lw $t0,288($sp)
move $v0, $t0
sw $v0,292($sp)
b Lbl29
Lbl28:
la $v0, st17
sw $v0,144($sp)
lw $t0,144($sp)
move $v0, $t0
sw $v0,292($sp)
Lbl29:
lw $t0,292($sp)
move $v0, $t0
sw $v0,296($sp)
lw $t0,296($sp)
move $v0, $t0
sw $v0,300($sp)
b Lbl31
Lbl30:
la $v0, st16
sw $v0,120($sp)
lw $t0,120($sp)
move $v0, $t0
sw $v0,300($sp)
Lbl31:
lw $t0,300($sp)
move $v0, $t0
sw $v0,304($sp)
lw $t0,304($sp)
move $v0, $t0
sw $v0,308($sp)
b Lbl33
Lbl32:
la $v0, st15
sw $v0,96($sp)
lw $t0,96($sp)
move $v0, $t0
sw $v0,308($sp)
Lbl33:
lw $t0,308($sp)
move $v0, $t0
sw $v0,312($sp)
lw $t0,312($sp)
move $v0, $t0
sw $v0,316($sp)
b Lbl35
Lbl34:
la $v0, st14
sw $v0,72($sp)
lw $t0,72($sp)
move $v0, $t0
sw $v0,316($sp)
Lbl35:
lw $t0,316($sp)
move $v0, $t0
sw $v0,320($sp)
lw $t0,320($sp)
move $v0, $t0
sw $v0,324($sp)
b Lbl37
Lbl36:
la $v0, st13
sw $v0,48($sp)
lw $t0,48($sp)
move $v0, $t0
sw $v0,324($sp)
Lbl37:
lw $t0,324($sp)
move $v0, $t0
sw $v0,328($sp)
lw $t0,328($sp)
move $v0, $t0
sw $v0,332($sp)
b Lbl39
Lbl38:
la $v0, st12
sw $v0,24($sp)
lw $t0,24($sp)
move $v0, $t0
sw $v0,332($sp)
Lbl39:
lw $t0,332($sp)
move $v0, $t0
sw $v0,336($sp)
addi $sp, $sp, 340
jr $ra
f9: #A2I.a2i
addi $sp, $sp, -216
move $t0,$a1
move $v0, $t0
sw $v0,4($sp)
lw $t0,4($sp)
#Argument var.var156
addi $sp, $sp, -4
sw $a0, 0($sp)
move $a0,$t0
la $t0,Stringclase
lw $t0,20($t0)
addi $sp, $sp, -4
sw $ra, 0($sp)
jal $t0 #var.var157<-['String', 'length']
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $a0, 0($sp)
addi $sp, $sp, 4
sw $v0,8($sp)
li $t0,0
move $v0, $t0
sw $v0,12($sp)
lw $t0,8($sp)
lw $t1,12($sp)
seq $v0 ,$t0, $t1
sw $v0,20($sp)
lw $t0,20($sp)
bgtz $t0, Lbl44
move $t0,$a1
move $v0, $t0
sw $v0,28($sp)
li $t0,0
move $v0, $t0
sw $v0,32($sp)
li $t0,1
move $v0, $t0
sw $v0,36($sp)
lw $t0,28($sp)
#Argument var.var162
addi $sp, $sp, -4
sw $a0, 0($sp)
move $a0,$t0
lw $t0,36($sp)
#Argument var.var163
addi $sp, $sp, -4
sw $a1, 0($sp)
move $a1,$t0
lw $t0,44($sp)
#Argument var.var164
addi $sp, $sp, -4
sw $a2, 0($sp)
move $a2,$t0
la $t0,Stringclase
lw $t0,28($t0)
addi $sp, $sp, -4
sw $ra, 0($sp)
jal $t0 #var.var165<-['String', 'substr']
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $a2, 0($sp)
lw $a1, 4($sp)
lw $a0, 8($sp)
addi $sp, $sp, 12
sw $v0,40($sp)
la $v0, st23
sw $v0,48($sp)
lw $t0,40($sp)
lw $t1,48($sp)
addi $sp, $sp, -12
sw $a0, 0($sp)
sw $a1, 4($sp)
sw $ra, 8($sp)
move $a0, $t0
move $a1, $t1
jal .Str.stringcomparison
lw $a0, 0($sp)
lw $a1, 4($sp)
lw $ra, 8($sp)
addi $sp, $sp, 12
sw $v0,56($sp)
lw $t0,56($sp)
bgtz $t0, Lbl42
move $t0,$a1
move $v0, $t0
sw $v0,108($sp)
li $t0,0
move $v0, $t0
sw $v0,112($sp)
li $t0,1
move $v0, $t0
sw $v0,116($sp)
lw $t0,108($sp)
#Argument var.var180
addi $sp, $sp, -4
sw $a0, 0($sp)
move $a0,$t0
lw $t0,116($sp)
#Argument var.var181
addi $sp, $sp, -4
sw $a1, 0($sp)
move $a1,$t0
lw $t0,124($sp)
#Argument var.var182
addi $sp, $sp, -4
sw $a2, 0($sp)
move $a2,$t0
la $t0,Stringclase
lw $t0,28($t0)
addi $sp, $sp, -4
sw $ra, 0($sp)
jal $t0 #var.var183<-['String', 'substr']
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $a2, 0($sp)
lw $a1, 4($sp)
lw $a0, 8($sp)
addi $sp, $sp, 12
sw $v0,120($sp)
la $v0, st24
sw $v0,128($sp)
lw $t0,120($sp)
lw $t1,128($sp)
addi $sp, $sp, -12
sw $a0, 0($sp)
sw $a1, 4($sp)
sw $ra, 8($sp)
move $a0, $t0
move $a1, $t1
jal .Str.stringcomparison
lw $a0, 0($sp)
lw $a1, 4($sp)
lw $ra, 8($sp)
addi $sp, $sp, 12
sw $v0,136($sp)
lw $t0,136($sp)
bgtz $t0, Lbl40
move $t0,$a0
move $v0, $t0
sw $v0,180($sp)
move $t0,$a1
move $v0, $t0
sw $v0,184($sp)
lw $t0,180($sp)
#Argument var.var197
addi $sp, $sp, -4
sw $a0, 0($sp)
move $a0,$t0
lw $t0,188($sp)
#Argument var.var198
addi $sp, $sp, -4
sw $a1, 0($sp)
move $a1,$t0
lw $t0, 0($a0)
lw $t0,32($t0)
addi $sp, $sp, -4
sw $ra, 0($sp)
jalr $ra,$t0 #var.var199<-['A2I', 'a2i_aux']
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $a1, 0($sp)
lw $a0, 4($sp)
addi $sp, $sp, 8
sw $v0,188($sp)
lw $t0,188($sp)
move $v0, $t0
sw $v0,192($sp)
b Lbl41
Lbl40:
move $t0,$a0
move $v0, $t0
sw $v0,140($sp)
move $t0,$a1
move $v0, $t0
sw $v0,144($sp)
li $t0,1
move $v0, $t0
sw $v0,148($sp)
move $t0,$a1
move $v0, $t0
sw $v0,152($sp)
lw $t0,152($sp)
#Argument var.var190
addi $sp, $sp, -4
sw $a0, 0($sp)
move $a0,$t0
la $t0,Stringclase
lw $t0,20($t0)
addi $sp, $sp, -4
sw $ra, 0($sp)
jal $t0 #var.var191<-['String', 'length']
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $a0, 0($sp)
addi $sp, $sp, 4
sw $v0,156($sp)
li $t0,1
move $v0, $t0
sw $v0,160($sp)
lw $t0,156($sp)
lw $t1,160($sp)
sub $v0, $t0, $t1
sw $v0,168($sp)
lw $t0,144($sp)
#Argument var.var188
addi $sp, $sp, -4
sw $a0, 0($sp)
move $a0,$t0
lw $t0,152($sp)
#Argument var.var189
addi $sp, $sp, -4
sw $a1, 0($sp)
move $a1,$t0
lw $t0,176($sp)
#Argument var.var193
addi $sp, $sp, -4
sw $a2, 0($sp)
move $a2,$t0
la $t0,Stringclase
lw $t0,28($t0)
addi $sp, $sp, -4
sw $ra, 0($sp)
jal $t0 #var.var195<-['String', 'substr']
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $a2, 0($sp)
lw $a1, 4($sp)
lw $a0, 8($sp)
addi $sp, $sp, 12
sw $v0,172($sp)
lw $t0,140($sp)
#Argument var.var187
addi $sp, $sp, -4
sw $a0, 0($sp)
move $a0,$t0
lw $t0,176($sp)
#Argument var.var195
addi $sp, $sp, -4
sw $a1, 0($sp)
move $a1,$t0
lw $t0, 0($a0)
lw $t0,32($t0)
addi $sp, $sp, -4
sw $ra, 0($sp)
jalr $ra,$t0 #var.var196<-['A2I', 'a2i_aux']
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $a1, 0($sp)
lw $a0, 4($sp)
addi $sp, $sp, 8
sw $v0,176($sp)
lw $t0,176($sp)
move $v0, $t0
sw $v0,192($sp)
Lbl41:
lw $t0,192($sp)
move $v0, $t0
sw $v0,196($sp)
lw $t0,196($sp)
move $v0, $t0
sw $v0,200($sp)
b Lbl43
Lbl42:
move $t0,$a0
move $v0, $t0
sw $v0,60($sp)
move $t0,$a1
move $v0, $t0
sw $v0,64($sp)
li $t0,1
move $v0, $t0
sw $v0,68($sp)
move $t0,$a1
move $v0, $t0
sw $v0,72($sp)
lw $t0,72($sp)
#Argument var.var172
addi $sp, $sp, -4
sw $a0, 0($sp)
move $a0,$t0
la $t0,Stringclase
lw $t0,20($t0)
addi $sp, $sp, -4
sw $ra, 0($sp)
jal $t0 #var.var173<-['String', 'length']
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $a0, 0($sp)
addi $sp, $sp, 4
sw $v0,76($sp)
li $t0,1
move $v0, $t0
sw $v0,80($sp)
lw $t0,76($sp)
lw $t1,80($sp)
sub $v0, $t0, $t1
sw $v0,88($sp)
lw $t0,64($sp)
#Argument var.var170
addi $sp, $sp, -4
sw $a0, 0($sp)
move $a0,$t0
lw $t0,72($sp)
#Argument var.var171
addi $sp, $sp, -4
sw $a1, 0($sp)
move $a1,$t0
lw $t0,96($sp)
#Argument var.var175
addi $sp, $sp, -4
sw $a2, 0($sp)
move $a2,$t0
la $t0,Stringclase
lw $t0,28($t0)
addi $sp, $sp, -4
sw $ra, 0($sp)
jal $t0 #var.var177<-['String', 'substr']
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $a2, 0($sp)
lw $a1, 4($sp)
lw $a0, 8($sp)
addi $sp, $sp, 12
sw $v0,92($sp)
lw $t0,60($sp)
#Argument var.var169
addi $sp, $sp, -4
sw $a0, 0($sp)
move $a0,$t0
lw $t0,96($sp)
#Argument var.var177
addi $sp, $sp, -4
sw $a1, 0($sp)
move $a1,$t0
lw $t0, 0($a0)
lw $t0,32($t0)
addi $sp, $sp, -4
sw $ra, 0($sp)
jalr $ra,$t0 #var.var178<-['A2I', 'a2i_aux']
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $a1, 0($sp)
lw $a0, 4($sp)
addi $sp, $sp, 8
sw $v0,96($sp)
lw $t0,96($sp)
neg $v0, $t0
sw $v0,104($sp)
lw $t0,104($sp)
move $v0, $t0
sw $v0,200($sp)
Lbl43:
lw $t0,200($sp)
move $v0, $t0
sw $v0,204($sp)
lw $t0,204($sp)
move $v0, $t0
sw $v0,208($sp)
b Lbl45
Lbl44:
li $t0,0
move $v0, $t0
sw $v0,24($sp)
lw $t0,24($sp)
move $v0, $t0
sw $v0,208($sp)
Lbl45:
lw $t0,208($sp)
move $v0, $t0
sw $v0,212($sp)
addi $sp, $sp, 216
jr $ra
f10: #A2I.a2i_aux
addi $sp, $sp, -168
li $t0,0
move $v0, $t0
sw $v0,8($sp)
lw $t0,4($sp)
move $v0, $t0
sw $v0,12($sp)
lw $t0,8($sp)
move $v0, $t0
sw $v0,4($sp)
move $t0,$a1
move $v0, $t0
sw $v0,20($sp)
lw $t0,20($sp)
#Argument var.var208
addi $sp, $sp, -4
sw $a0, 0($sp)
move $a0,$t0
la $t0,Stringclase
lw $t0,20($t0)
addi $sp, $sp, -4
sw $ra, 0($sp)
jal $t0 #var.var209<-['String', 'length']
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $a0, 0($sp)
addi $sp, $sp, 4
sw $v0,24($sp)
lw $t0,16($sp)
move $v0, $t0
sw $v0,28($sp)
lw $t0,24($sp)
move $v0, $t0
sw $v0,16($sp)
li $t0,0
move $v0, $t0
sw $v0,36($sp)
lw $t0,32($sp)
move $v0, $t0
sw $v0,40($sp)
lw $t0,36($sp)
move $v0, $t0
sw $v0,32($sp)
Lbl46:
lw $t0,32($sp)
move $v0, $t0
sw $v0,44($sp)
lw $t0,16($sp)
move $v0, $t0
sw $v0,48($sp)
lw $t0,44($sp)
lw $t1,48($sp)
slt $v0, $t0, $t1
sw $v0,56($sp)
lw $t0,56($sp)
seq $v0, $t0, $zero
sw $v0,64($sp)
lw $t0,64($sp)
bgtz $t0, Lbl47
lw $t0,4($sp)
move $v0, $t0
sw $v0,68($sp)
li $t0,10
move $v0, $t0
sw $v0,72($sp)
lw $t0,68($sp)
lw $t1,72($sp)
mult $t0, $t1
mflo $v0
sw $v0,80($sp)
move $t0,$a0
move $v0, $t0
sw $v0,84($sp)
move $t0,$a1
move $v0, $t0
sw $v0,88($sp)
lw $t0,32($sp)
move $v0, $t0
sw $v0,92($sp)
li $t0,1
move $v0, $t0
sw $v0,96($sp)
lw $t0,88($sp)
#Argument var.var223
addi $sp, $sp, -4
sw $a0, 0($sp)
move $a0,$t0
lw $t0,96($sp)
#Argument var.var224
addi $sp, $sp, -4
sw $a1, 0($sp)
move $a1,$t0
lw $t0,104($sp)
#Argument var.var225
addi $sp, $sp, -4
sw $a2, 0($sp)
move $a2,$t0
la $t0,Stringclase
lw $t0,28($t0)
addi $sp, $sp, -4
sw $ra, 0($sp)
jal $t0 #var.var226<-['String', 'substr']
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $a2, 0($sp)
lw $a1, 4($sp)
lw $a0, 8($sp)
addi $sp, $sp, 12
sw $v0,100($sp)
lw $t0,84($sp)
#Argument var.var222
addi $sp, $sp, -4
sw $a0, 0($sp)
move $a0,$t0
lw $t0,104($sp)
#Argument var.var226
addi $sp, $sp, -4
sw $a1, 0($sp)
move $a1,$t0
lw $t0, 0($a0)
lw $t0,20($t0)
addi $sp, $sp, -4
sw $ra, 0($sp)
jalr $ra,$t0 #var.var227<-['A2I', 'c2i']
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $a1, 0($sp)
lw $a0, 4($sp)
addi $sp, $sp, 8
sw $v0,104($sp)
lw $t0,80($sp)
lw $t1,104($sp)
add $v0, $t0, $t1
sw $v0,112($sp)
lw $t0,112($sp)
move $v0, $t0
sw $v0,4($sp)
lw $t0,32($sp)
move $v0, $t0
sw $v0,116($sp)
li $t0,1
move $v0, $t0
sw $v0,120($sp)
lw $t0,116($sp)
lw $t1,120($sp)
add $v0, $t0, $t1
sw $v0,128($sp)
lw $t0,128($sp)
move $v0, $t0
sw $v0,32($sp)
b Lbl46
Lbl47:
li $t0,0
move $v0, $t0
sw $v0,136($sp)
lw $t0,136($sp)
move $v0, $t0
sw $v0,140($sp)
lw $t0,40($sp)
move $v0, $t0
sw $v0,32($sp)
lw $t0,140($sp)
move $v0, $t0
sw $v0,144($sp)
lw $t0,144($sp)
move $v0, $t0
sw $v0,148($sp)
lw $t0,28($sp)
move $v0, $t0
sw $v0,16($sp)
lw $t0,148($sp)
move $v0, $t0
sw $v0,152($sp)
lw $t0,4($sp)
move $v0, $t0
sw $v0,156($sp)
lw $t0,156($sp)
move $v0, $t0
sw $v0,160($sp)
lw $t0,12($sp)
move $v0, $t0
sw $v0,4($sp)
lw $t0,160($sp)
move $v0, $t0
sw $v0,164($sp)
addi $sp, $sp, 168
jr $ra
f11: #A2I.i2a
addi $sp, $sp, -116
move $t0,$a1
move $v0, $t0
sw $v0,4($sp)
li $t0,0
move $v0, $t0
sw $v0,8($sp)
lw $t0,4($sp)
lw $t1,8($sp)
seq $v0 ,$t0, $t1
sw $v0,16($sp)
lw $t0,16($sp)
bgtz $t0, Lbl50
li $t0,0
move $v0, $t0
sw $v0,28($sp)
move $t0,$a1
move $v0, $t0
sw $v0,32($sp)
lw $t0,28($sp)
lw $t1,32($sp)
slt $v0, $t0, $t1
sw $v0,40($sp)
lw $t0,40($sp)
bgtz $t0, Lbl48
la $v0, st26
sw $v0,60($sp)
move $t0,$a0
move $v0, $t0
sw $v0,64($sp)
move $t0,$a1
move $v0, $t0
sw $v0,68($sp)
li $t0,1
move $v0, $t0
sw $v0,72($sp)
lw $t0,72($sp)
neg $v0, $t0
sw $v0,80($sp)
lw $t0,68($sp)
lw $t1,80($sp)
mult $t0, $t1
mflo $v0
sw $v0,88($sp)
lw $t0,64($sp)
#Argument var.var255
addi $sp, $sp, -4
sw $a0, 0($sp)
move $a0,$t0
lw $t0,92($sp)
#Argument var.var259
addi $sp, $sp, -4
sw $a1, 0($sp)
move $a1,$t0
lw $t0, 0($a0)
lw $t0,40($t0)
addi $sp, $sp, -4
sw $ra, 0($sp)
jalr $ra,$t0 #var.var261<-['A2I', 'i2a_aux']
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $a1, 0($sp)
lw $a0, 4($sp)
addi $sp, $sp, 8
sw $v0,92($sp)
lw $t0,60($sp)
#Argument var.var254
addi $sp, $sp, -4
sw $a0, 0($sp)
move $a0,$t0
lw $t0,96($sp)
#Argument var.var261
addi $sp, $sp, -4
sw $a1, 0($sp)
move $a1,$t0
la $t0,Stringclase
lw $t0,24($t0)
addi $sp, $sp, -4
sw $ra, 0($sp)
jal $t0 #var.var262<-['String', 'concat']
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $a1, 0($sp)
lw $a0, 4($sp)
addi $sp, $sp, 8
sw $v0,96($sp)
lw $t0,96($sp)
move $v0, $t0
sw $v0,100($sp)
b Lbl49
Lbl48:
move $t0,$a0
move $v0, $t0
sw $v0,44($sp)
move $t0,$a1
move $v0, $t0
sw $v0,48($sp)
lw $t0,44($sp)
#Argument var.var251
addi $sp, $sp, -4
sw $a0, 0($sp)
move $a0,$t0
lw $t0,52($sp)
#Argument var.var252
addi $sp, $sp, -4
sw $a1, 0($sp)
move $a1,$t0
lw $t0, 0($a0)
lw $t0,40($t0)
addi $sp, $sp, -4
sw $ra, 0($sp)
jalr $ra,$t0 #var.var253<-['A2I', 'i2a_aux']
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $a1, 0($sp)
lw $a0, 4($sp)
addi $sp, $sp, 8
sw $v0,52($sp)
lw $t0,52($sp)
move $v0, $t0
sw $v0,100($sp)
Lbl49:
lw $t0,100($sp)
move $v0, $t0
sw $v0,104($sp)
lw $t0,104($sp)
move $v0, $t0
sw $v0,108($sp)
b Lbl51
Lbl50:
la $v0, st25
sw $v0,24($sp)
lw $t0,24($sp)
move $v0, $t0
sw $v0,108($sp)
Lbl51:
lw $t0,108($sp)
move $v0, $t0
sw $v0,112($sp)
addi $sp, $sp, 116
jr $ra
f12: #A2I.i2a_aux
addi $sp, $sp, -120
move $t0,$a1
move $v0, $t0
sw $v0,4($sp)
li $t0,0
move $v0, $t0
sw $v0,8($sp)
lw $t0,4($sp)
lw $t1,8($sp)
seq $v0 ,$t0, $t1
sw $v0,16($sp)
lw $t0,16($sp)
bgtz $t0, Lbl52
move $t0,$a1
move $v0, $t0
sw $v0,32($sp)
li $t0,10
move $v0, $t0
sw $v0,36($sp)
lw $t0,32($sp)
lw $t1,36($sp)
div $t0, $t1
mflo $v0
sw $v0,44($sp)
lw $t0,28($sp)
move $v0, $t0
sw $v0,48($sp)
lw $t0,44($sp)
move $v0, $t0
sw $v0,28($sp)
move $t0,$a0
move $v0, $t0
sw $v0,52($sp)
lw $t0,28($sp)
move $v0, $t0
sw $v0,56($sp)
lw $t0,52($sp)
#Argument var.var277
addi $sp, $sp, -4
sw $a0, 0($sp)
move $a0,$t0
lw $t0,60($sp)
#Argument var.var278
addi $sp, $sp, -4
sw $a1, 0($sp)
move $a1,$t0
lw $t0, 0($a0)
lw $t0,40($t0)
addi $sp, $sp, -4
sw $ra, 0($sp)
jalr $ra,$t0 #var.var279<-['A2I', 'i2a_aux']
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $a1, 0($sp)
lw $a0, 4($sp)
addi $sp, $sp, 8
sw $v0,60($sp)
move $t0,$a0
move $v0, $t0
sw $v0,64($sp)
move $t0,$a1
move $v0, $t0
sw $v0,68($sp)
lw $t0,28($sp)
move $v0, $t0
sw $v0,72($sp)
li $t0,10
move $v0, $t0
sw $v0,76($sp)
lw $t0,72($sp)
lw $t1,76($sp)
mult $t0, $t1
mflo $v0
sw $v0,84($sp)
lw $t0,68($sp)
lw $t1,84($sp)
sub $v0, $t0, $t1
sw $v0,92($sp)
lw $t0,64($sp)
#Argument var.var280
addi $sp, $sp, -4
sw $a0, 0($sp)
move $a0,$t0
lw $t0,96($sp)
#Argument var.var286
addi $sp, $sp, -4
sw $a1, 0($sp)
move $a1,$t0
lw $t0, 0($a0)
lw $t0,24($t0)
addi $sp, $sp, -4
sw $ra, 0($sp)
jalr $ra,$t0 #var.var288<-['A2I', 'i2c']
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $a1, 0($sp)
lw $a0, 4($sp)
addi $sp, $sp, 8
sw $v0,96($sp)
lw $t0,60($sp)
#Argument var.var279
addi $sp, $sp, -4
sw $a0, 0($sp)
move $a0,$t0
lw $t0,100($sp)
#Argument var.var288
addi $sp, $sp, -4
sw $a1, 0($sp)
move $a1,$t0
la $t0,Stringclase
lw $t0,24($t0)
addi $sp, $sp, -4
sw $ra, 0($sp)
jal $t0 #var.var289<-['String', 'concat']
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $a1, 0($sp)
lw $a0, 4($sp)
addi $sp, $sp, 8
sw $v0,100($sp)
lw $t0,100($sp)
move $v0, $t0
sw $v0,104($sp)
lw $t0,48($sp)
move $v0, $t0
sw $v0,28($sp)
lw $t0,104($sp)
move $v0, $t0
sw $v0,108($sp)
lw $t0,108($sp)
move $v0, $t0
sw $v0,112($sp)
b Lbl53
Lbl52:
la $v0, st27
sw $v0,24($sp)
lw $t0,24($sp)
move $v0, $t0
sw $v0,112($sp)
Lbl53:
lw $t0,112($sp)
move $v0, $t0
sw $v0,116($sp)
addi $sp, $sp, 120
jr $ra
f13: #IO.$init
addi $sp, $sp, -12
move $t0,$a0
#Argument self
addi $sp, $sp, -4
sw $a0, 0($sp)
move $a0,$t0
la $t0,Objectclase
lw $t0,4($t0)
addi $sp, $sp, -4
sw $ra, 0($sp)
jal $t0 #var.var296<-['Object', '$init']
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $a0, 0($sp)
addi $sp, $sp, 4
sw $v0,4($sp)
move $t0,$a0
move $v0, $t0
sw $v0,8($sp)
addi $sp, $sp, 12
jr $ra
f14: #IO.type_name
addi $sp, $sp, -12
la $v0, st28
sw $v0,8($sp)
addi $sp, $sp, 12
jr $ra
f15: #IO.out_string
addi $sp, $sp, -8
addi $sp, $sp, -8
sw $a0, 0($sp)
sw $ra, 4($sp)
move $a0, $a1
jal .IO.out_string
lw $a0, 0($sp)
lw $ra, 4($sp)
addi $sp, $sp, 8
move $v0, $a0
move $a1,$t0
move $t0,$a0
move $v0, $t0
sw $v0,4($sp)
addi $sp, $sp, 8
jr $ra
f16: #IO.out_int
addi $sp, $sp, -8
addi $sp, $sp, -8
sw $a0, 0($sp)
sw $ra, 4($sp)
move $a0, $a1
jal .IO.out_int
lw $a0, 0($sp)
lw $ra, 4($sp)
addi $sp, $sp, 8
move $v0, $a0
move $a1,$t0
move $t0,$a0
move $v0, $t0
sw $v0,4($sp)
addi $sp, $sp, 8
jr $ra
f17: #IO.in_string
addi $sp, $sp, -8
addi $sp, $sp, -8
sw $a0, 0($sp)
sw $ra, 4($sp)
move $a0, $t0
jal .IO.in_string
lw $a0, 0($sp)
lw $ra, 4($sp)
addi $sp, $sp, 8
sw $v0,4($sp)
addi $sp, $sp, 8
jr $ra
f18: #IO.in_int
addi $sp, $sp, -8
addi $sp, $sp, -8
sw $a0, 0($sp)
sw $ra, 4($sp)
move $a0, $t0
jal .IO.in_int
lw $a0, 0($sp)
lw $ra, 4($sp)
addi $sp, $sp, 8
sw $v0,4($sp)
addi $sp, $sp, 8
jr $ra
f19: #String.$init
addi $sp, $sp, -12
move $t0,$a0
#Argument self
addi $sp, $sp, -4
sw $a0, 0($sp)
move $a0,$t0
la $t0,Objectclase
lw $t0,4($t0)
addi $sp, $sp, -4
sw $ra, 0($sp)
jal $t0 #var.var301<-['Object', '$init']
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $a0, 0($sp)
addi $sp, $sp, 4
sw $v0,4($sp)
move $t0,$a0
move $v0, $t0
sw $v0,8($sp)
addi $sp, $sp, 12
jr $ra
f20: #String.type_name
addi $sp, $sp, -12
la $v0, st29
sw $v0,8($sp)
addi $sp, $sp, 12
jr $ra
f21: #String.Length
addi $sp, $sp, -8
move $t0,$a0
addi $sp, $sp, -8
sw $a0, 0($sp)
sw $ra, 4($sp)
move $a0, $t0
jal .Str.stringlength
lw $a0, 0($sp)
lw $ra, 4($sp)
addi $sp, $sp, 8
sw $v0,4($sp)
addi $sp, $sp, 8
jr $ra
f22: #String.Concat
addi $sp, $sp, -8
move $t0,$a0
move $t1,$a1
addi $sp, $sp, -12
sw $a0, 0($sp)
sw $a1, 4($sp)
sw $ra, 8($sp)
move $a0, $t0
move $a1, $t1
jal .Str.stringconcat
lw $a0, 0($sp)
lw $a1, 4($sp)
lw $ra, 8($sp)
addi $sp, $sp, 12
sw $v0,4($sp)
addi $sp, $sp, 8
jr $ra
f23: #String.Substring
addi $sp, $sp, -8
move $t0,$a0
move $t1,$a1
move $t2,$a2
addi $sp, $sp, -16
sw $a0, 0($sp)
sw $a1, 4($sp)
sw $a2, 8($sp)
sw $ra, 12($sp)
move $a0, $t0
move $a1, $t1
move $a2, $t2
jal .Str.substring
lw $a0, 0($sp)
lw $a1, 4($sp)
lw $a2, 8($sp)
lw $ra, 12($sp)
addi $sp, $sp, 16
sw $v0,4($sp)
addi $sp, $sp, 8
jr $ra
f24: #Bool.$init
addi $sp, $sp, -12
move $t0,$a0
#Argument self
addi $sp, $sp, -4
sw $a0, 0($sp)
move $a0,$t0
la $t0,Objectclase
lw $t0,4($t0)
addi $sp, $sp, -4
sw $ra, 0($sp)
jal $t0 #var.var306<-['Object', '$init']
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $a0, 0($sp)
addi $sp, $sp, 4
sw $v0,4($sp)
move $t0,$a0
move $v0, $t0
sw $v0,8($sp)
addi $sp, $sp, 12
jr $ra
f25: #Bool.type_name
addi $sp, $sp, -12
la $v0, st30
sw $v0,8($sp)
addi $sp, $sp, 12
jr $ra
f26: #Main.$init
addi $sp, $sp, -12
move $t0,$a0
#Argument self
addi $sp, $sp, -4
sw $a0, 0($sp)
move $a0,$t0
la $t0,IOclase
lw $t0,4($t0)
addi $sp, $sp, -4
sw $ra, 0($sp)
jal $t0 #var.var311<-['IO', '$init']
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $a0, 0($sp)
addi $sp, $sp, 4
sw $v0,4($sp)
move $t0,$a0
move $v0, $t0
sw $v0,8($sp)
addi $sp, $sp, 12
jr $ra
f27: #Main.type_name
addi $sp, $sp, -12
la $v0, st31
sw $v0,8($sp)
addi $sp, $sp, 12
jr $ra
f28: #Main.main
addi $sp, $sp, -112
addi $sp, $sp, -4
sw $a0, 0($sp)
li $a0,4
li $v0, 9
syscall
la $t0, A2Iclase
sw $t0, 0($v0)
lw $a0, 0($sp)
addi $sp, $sp, 4
sw $v0,8($sp)
lw $t0,8($sp)
#Argument var.var314
addi $sp, $sp, -4
sw $a0, 0($sp)
move $a0,$t0
lw $t0, 0($a0)
lw $t0,4($t0)
addi $sp, $sp, -4
sw $ra, 0($sp)
jalr $ra,$t0 #var.var314<-['A2I', '$init']
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $a0, 0($sp)
addi $sp, $sp, 4
sw $v0,8($sp)
la $v0, st32
sw $v0,16($sp)
lw $t0,8($sp)
#Argument var.var314
addi $sp, $sp, -4
sw $a0, 0($sp)
move $a0,$t0
lw $t0,20($sp)
#Argument var.var315
addi $sp, $sp, -4
sw $a1, 0($sp)
move $a1,$t0
lw $t0, 0($a0)
lw $t0,28($t0)
addi $sp, $sp, -4
sw $ra, 0($sp)
jalr $ra,$t0 #var.var316<-['A2I', 'a2i']
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $a1, 0($sp)
lw $a0, 4($sp)
addi $sp, $sp, 8
sw $v0,20($sp)
lw $t0,4($sp)
move $v0, $t0
sw $v0,24($sp)
lw $t0,20($sp)
move $v0, $t0
sw $v0,4($sp)
addi $sp, $sp, -4
sw $a0, 0($sp)
li $a0,4
li $v0, 9
syscall
la $t0, A2Iclase
sw $t0, 0($v0)
lw $a0, 0($sp)
addi $sp, $sp, 4
sw $v0,32($sp)
lw $t0,32($sp)
#Argument var.var318
addi $sp, $sp, -4
sw $a0, 0($sp)
move $a0,$t0
lw $t0, 0($a0)
lw $t0,4($t0)
addi $sp, $sp, -4
sw $ra, 0($sp)
jalr $ra,$t0 #var.var318<-['A2I', '$init']
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $a0, 0($sp)
addi $sp, $sp, 4
sw $v0,32($sp)
li $t0,678987
move $v0, $t0
sw $v0,36($sp)
lw $t0,32($sp)
#Argument var.var318
addi $sp, $sp, -4
sw $a0, 0($sp)
move $a0,$t0
lw $t0,40($sp)
#Argument var.var319
addi $sp, $sp, -4
sw $a1, 0($sp)
move $a1,$t0
lw $t0, 0($a0)
lw $t0,36($t0)
addi $sp, $sp, -4
sw $ra, 0($sp)
jalr $ra,$t0 #var.var320<-['A2I', 'i2a']
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $a1, 0($sp)
lw $a0, 4($sp)
addi $sp, $sp, 8
sw $v0,40($sp)
lw $t0,28($sp)
move $v0, $t0
sw $v0,44($sp)
lw $t0,40($sp)
move $v0, $t0
sw $v0,28($sp)
move $t0,$a0
move $v0, $t0
sw $v0,48($sp)
lw $t0,4($sp)
move $v0, $t0
sw $v0,52($sp)
lw $t0,48($sp)
#Argument var.var322
addi $sp, $sp, -4
sw $a0, 0($sp)
move $a0,$t0
lw $t0,56($sp)
#Argument var.var323
addi $sp, $sp, -4
sw $a1, 0($sp)
move $a1,$t0
lw $t0, 0($a0)
lw $t0,24($t0)
addi $sp, $sp, -4
sw $ra, 0($sp)
jalr $ra,$t0 #var.var324<-['Main', 'out_int']
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $a1, 0($sp)
lw $a0, 4($sp)
addi $sp, $sp, 8
sw $v0,56($sp)
move $t0,$a0
move $v0, $t0
sw $v0,60($sp)
la $v0, st33
sw $v0,68($sp)
lw $t0,60($sp)
#Argument var.var325
addi $sp, $sp, -4
sw $a0, 0($sp)
move $a0,$t0
lw $t0,72($sp)
#Argument var.var326
addi $sp, $sp, -4
sw $a1, 0($sp)
move $a1,$t0
lw $t0, 0($a0)
lw $t0,20($t0)
addi $sp, $sp, -4
sw $ra, 0($sp)
jalr $ra,$t0 #var.var327<-['Main', 'out_string']
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $a1, 0($sp)
lw $a0, 4($sp)
addi $sp, $sp, 8
sw $v0,72($sp)
move $t0,$a0
move $v0, $t0
sw $v0,76($sp)
lw $t0,28($sp)
move $v0, $t0
sw $v0,80($sp)
lw $t0,76($sp)
#Argument var.var328
addi $sp, $sp, -4
sw $a0, 0($sp)
move $a0,$t0
lw $t0,84($sp)
#Argument var.var329
addi $sp, $sp, -4
sw $a1, 0($sp)
move $a1,$t0
lw $t0, 0($a0)
lw $t0,20($t0)
addi $sp, $sp, -4
sw $ra, 0($sp)
jalr $ra,$t0 #var.var330<-['Main', 'out_string']
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $a1, 0($sp)
lw $a0, 4($sp)
addi $sp, $sp, 8
sw $v0,84($sp)
move $t0,$a0
move $v0, $t0
sw $v0,88($sp)
la $v0, st34
sw $v0,96($sp)
lw $t0,88($sp)
#Argument var.var331
addi $sp, $sp, -4
sw $a0, 0($sp)
move $a0,$t0
lw $t0,100($sp)
#Argument var.var332
addi $sp, $sp, -4
sw $a1, 0($sp)
move $a1,$t0
lw $t0, 0($a0)
lw $t0,20($t0)
addi $sp, $sp, -4
sw $ra, 0($sp)
jalr $ra,$t0 #var.var333<-['Main', 'out_string']
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $a1, 0($sp)
lw $a0, 4($sp)
addi $sp, $sp, 8
sw $v0,100($sp)
lw $t0,100($sp)
move $v0, $t0
sw $v0,104($sp)
lw $t0,24($sp)
move $v0, $t0
sw $v0,4($sp)
lw $t0,44($sp)
move $v0, $t0
sw $v0,28($sp)
lw $t0,104($sp)
move $v0, $t0
sw $v0,108($sp)
addi $sp, $sp, 112
jr $ra
