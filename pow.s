!pow.s
!
!by Tim Martin
!
!
!Psuedocode (Ruby)
!def multiply(a, b)
  !if b == 0
    !return 0
  !elsif a == 0
    !return 0
  !elsif b == 1
    !return a
  !elsif a == 1
    !return b
  !else
    !b = b - 1
    !prod = a + multiply(a, b)
    !return prod
  !end
!end

!def power(base, exp)
  !if exp == 0
    !return 1
  !elsif base == 0
    !return 0
  !elsif exp == 1
    !return base
  !else
    !exp = exp - 1
    !decr_power = power(base, exp)
    !prod = multiply(base, decr_power)
    !return prod
  !end
!end


!!!!
!NOTE: due to errors, the frame pointer register is not $fp, but instead $s2
!!!!

!.org 0x3000 ! doesn't seem to tell the simulators to start at pc 0x3000, but
             ! works for storage

!Constants
!---------
la $t0, main
jalr $t0, $ra !just so we can have our constants at the top in nice plain view

base:
.word 2

exponent:
.word 4

stack:
.word 0xF000


!Main Routine
!------------
main:

la $sp, stack
lw $sp, 0x0($sp)      ! load address of stack into $sp

                      ! push params

                      ! these next 2 lines are saying $a0 <- mem[base]
la $a0, base          ! load address of base in $a0
lw $a0, 0x0($a0)      ! then load word at address into $a0
addi $sp, $sp, -1
sw $a0, 0x0($sp)      ! and place on stack

la $a0, exponent      ! same loading voodoo as before: $a0 <- mem[exponent]
lw $a0, 0x0($a0)
addi $sp, $sp, -1
sw $a0, 0x0($sp)      ! and place on stack

addi $sp, $sp, -1     ! allocate return val

addi $sp, $sp, -1     ! push return addr, being pedantic
sw $ra, 0x0($sp)

la $t0, pow           ! load address of pow into $at
jalr $t0, $ra         ! jump to pow, set $ra to return addr
halt                  ! when we return, just halt

!Multiply Routine
!----------------
mult:
                                  ! save old fp
addi $sp, $sp, -1
sw $s2, 0x0($sp)
                                  ! and set new one
addi $s2, $sp, 0

                                  ! allocate for locals (prod)
addi $sp, $sp, -1

                                  ! check if b == 0
add $v0, $zero, $zero             ! prep a zero return val
lw $t0, 0x3($s2)
beq $t0, $zero, mult_special_case

                                  ! check if a == 0
                                  ! zero is already prepped
lw $t0, 0x4($s2)
beq $t0, $zero, mult_special_case

                                  ! check if b == 1
lw $v0, 0x4($s2)                  ! prep a in ret val
lw $t0, 0x3($s2)
addi $t0, $t0, -1
beq $t0, $zero, mult_special_case

                                  ! check if a == 1
lw $v0, 0x3($s2)                  ! prep b in ret val
lw $t0, 0x4($s2)
addi $t0, $t0, -1
beq $t0, $zero, mult_special_case

beq $zero, $zero, mult_recurse

mult_special_case:
la $t0, mult_resolve
jalr $t0, $t1

                                  ! now the fun
mult_recurse:
                                  ! put a in prod
lw $t1, 0x4($s2)
sw $t1, -1($s2)

                                  ! and get ready to recursively call mult again
                                  ! push a
lw $t0, 0x4($s2)
addi $sp, $sp, -1
sw $t0, 0x0($sp)

                                  ! push decremented b
lw $t0, 0x3($s2)
addi $t0, $t0, -1
addi $sp, $sp, -1
sw $t0, 0x0($sp)

addi $sp, $sp, -1                 ! allocate return val

addi $sp, $sp, -1                 ! push ret addr
sw $ra, 0x0($sp)

                                  ! and make the jump
la $t0, mult
jalr $t0, $ra

                                  ! when we get back
                                  ! restore old ret addr
lw $ra, 0x0($sp)
addi $sp, $sp, 1

lw $t0, -1($s2)                   ! load up prod again
add $v0, $t0, $v0                 ! and add the returned val to it in $v0

                                  ! pop old ret val
addi $sp, $sp, 1

                                  ! pop parms
addi $sp, $sp, 2

mult_resolve:
                                  ! pop local
addi $sp, $sp, 1

                                  ! restore fp
lw $s2, 0x0($s2)
addi $sp, $sp, 1

                                  ! and jump back
jalr $ra, $t0


!Exponentiation Routine
!----------------------
pow:
                                   ! save old fp
addi $sp, $sp, -1
sw $s2, 0x0($sp)
                                   ! and set new one
addi $s2, $sp, 0

                                   ! allocate for locals (prod)
addi $sp, $sp, -2

                                   ! check if exponent == 0
addi $v0, $zero, 1                 ! prep a 1 return val
lw $t0, 0x3($s2)
beq $t0, $zero, pow_special_case

                                   ! check if base == 0
add $v0, $zero, $zero              ! prep a 0 return val
lw $t0, 0x4($s2)
beq $t0, $zero, pow_special_case

                                   ! check if exponent == 1
lw $v0, 0x4($s2)                   ! prep base in ret val
lw $t0, 0x3($s2)
addi $t0, $t0, -1
beq $t0, $zero, pow_special_case

beq $zero, $zero, pow_recurse

pow_special_case:
la $t0, pow_resolve
jalr $t0, $t1

                                   ! now the fun
pow_recurse:
                                   ! get ready to recursively call pow again
                                   ! push base
lw $t0, 0x4($s2)
addi $sp, $sp, -1
sw $t0, 0x0($sp)

                                   ! push decremented exponent
lw $t0, 0x3($s2)
addi $t0, $t0, -1
addi $sp, $sp, -1
sw $t0, 0x0($sp)

addi $sp, $sp, -1                  ! allocate return val

addi $sp, $sp, -1                  ! push ret addr
sw $ra, 0x0($sp)

                                   ! and make the jump
la $t0, pow
jalr $t0, $ra

                                   ! when we get back
                                   ! restore old ret addr
lw $ra, 0x0($sp)
addi $sp, $sp, 1

sw $v0, -2($s2)                    ! store this into decr_power

                                   ! pop old ret val
addi $sp, $sp, 1

                                   ! pop parms
addi $sp, $sp, 2

                                   ! now get ready to call mult
                                   ! push base
lw $t0, 0x4($s2)
addi $sp, $sp, -1
sw $t0, 0x0($sp)

                                   ! push decr_power
lw $t0, -2($s2)
addi $sp, $sp, -1
sw $t0, 0x0($sp)

addi $sp, $sp, -1                  ! allocate return val

addi $sp, $sp, -1                  ! push ret addr
sw $ra, 0x0($sp)

                                   ! and make the jump
la $t0, mult
jalr $t0, $ra

                                   ! when we get back
                                   ! restore old ret addr
lw $ra, 0x0($sp)
addi $sp, $sp, 1

                                   ! pop old ret val
addi $sp, $sp, 1

                                   ! pop parms
addi $sp, $sp, 2


pow_resolve:
                                   ! pop local
addi $sp, $sp, 2

                                   ! restore fp
lw $s2, 0x0($s2)
addi $sp, $sp, 1

                                   ! and jump back
jalr $ra, $t0
