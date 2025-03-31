.data
    input_msg1: .asciiz "Please enter option (1: triangle, 2: inverted triangle): "
    input_msg2: .asciiz "Please input a triangle size: "
    space: .asciiz " "
    star: .asciiz "*"
    newline: .asciiz "\n"
.text
.globl main

main:
    # 保存 $ra 和 $s 寄存器
    addi $sp, $sp, -12
    sw $ra, 8($sp)
    sw $s0, 4($sp)
    sw $s1, 0($sp)

    li $v0, 4
    la $a0, input_msg1
    syscall

    li $v0, 5
    syscall
    move $s0, $v0

    li $v0, 4
    la $a0, input_msg2
    syscall

    li $v0, 5
    syscall
    move $s1, $v0

    li $t0, 0   # initialize t0 = 0 (目前的layer層)

# $s0: option, $s1: triangle size
loop_start:
    slt $t1, $t0, $s1
    beq $t1, $zero, end # if $t1 = 0 -> jump to end (layer >= n)
    li $t2, 1
    bne $s0, $t2, inverted_tri   # check option 是否為1
    move $s2, $s1
    move $s3, $t0
    addi $t0, $t0, 1
    j print_layer

inverted_tri:
    move $s2, $s1
    sub $s3, $s1, $t0
    addi $s3, $s3, -1
    addi $t0, $t0, 1
    j print_layer

print_layer:
    li $s4, 0
    jal num_space
    move $s4, $t0
    jal num_star
    jal print_newline
    j loop_start

num_space:
    sub $s5, $s2, $s3
    addi $s5, $s5, -1
    slt $t1, $s4, $s5
    beq $t1, $zero, return_num_space
print_space:
    li $v0, 4
    la $a0, space
    syscall
    addi $s4, $s4, 1
    j num_space

return_num_space:
    jr $ra

# $s2 = n, $s3 = l (current layer)
num_star:
    add $s5, $s3, $s3   # $s5 = 2l
    addi $s5, $s5, 1    # $s5 = 2l + 1 (星星總數)
    li $s4, 0           # j = 0 (星星計數器)

print_star_loop:
    slt $t1, $s4, $s5   # 檢查是否 j < 2l + 1
    beq $t1, $zero, return_num_star  # 如果 j >= 2l + 1，結束星星打印
print_star:
    li $v0, 4
    la $a0, star
    syscall
    addi $s4, $s4, 1    # j++
    j print_star_loop

return_num_star:
    jr $ra

print_newline:
    li $v0, 4
    la $a0, newline
    syscall

    jr $ra

end:
    li $v0, 10
    syscall