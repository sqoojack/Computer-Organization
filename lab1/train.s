.data
    input_msg1: .asciiz "Please enter option (1: triangle, 2: inverted triangle): "  # 輸入選項提示
    input_msg2: .asciiz "Please input a triangle size: "                             # 輸入三角形大小提示
    space: .asciiz " "                                                           # 空格字元
    star: .asciiz "*"                                                        # 星號字元
    newline: .asciiz "\n"                                                        # 換行字元
.text
.globl main

main:
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
    move $s2, $s1 # define $s2(n), $s3(l)
    move $s3, $t0
    addi $t0, $t0, 1
    j print_layer

# $s2 = n, $s3 = l
print_layer:
    li $s4, 1 # initialize j = 1
    jal num_space
    sub $s4, $s2, $s3   # initialize j = n - l
    jal num_star
    jal print_newline 
    j loop_start

inverted_tri:
    # define n($s2), n-i-1($s3)
    move $s2, $s1
    sub $s3, $s1, $t0
    addi $s3, $s3, -1
    addi $t0, $t0, 1    # i++
    j print_layer

# $s4 = j
num_space:
    sub $s5, $s2, $s3   # $s5 = n - l
    slt $t1, $s4, $s5
    addi $s4, $s4, 1    # j++
    bne $t1, $zero, print_space    # if j < n - l, jump to print_space
    jr $ra

print_space:
    li $v0, 4
    la $a0, space
    syscall

    j num_space # 跳回num_space

num_star:
    sub $s4, $s2, $s3   # $s4 (j) = n - l
    add $s5, $s2, $s3   # $s5 = n + l
    slt $t1, $s5, $s4   # if n+l >= j -> t1 = 0
    addi $s4, $s4, 1    # j++
    beq $t1, $zero, print_star    # if n+l >= j, jump to print_star
    jr $ra

print_star:
    li $v0, 4
    la $a0, star
    syscall

    j num_star # 跳回num_star

print_newline:
    li $v0, 4
    la $a0, newline
    syscall

    jr $ra

end:
    li $v0, 10
    syscall
