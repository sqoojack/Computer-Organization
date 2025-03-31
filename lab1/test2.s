.data
    input_msg1: .asciiz "Please enter option (1: triangle, 2: inverted triangle): "  # 輸入選項提示
    input_msg2: .asciiz "Please input a triangle size: "                             # 輸入三角形大小提示
    space: .asciiz " "                                                               # 空格字元
    star: .asciiz "*"                                                                # 星號字元
    newline: .asciiz "\n"                                                            # 換行字元
.text
.globl main

main:
    # 提示輸入選項
    li $v0, 4
    la $a0, input_msg1
    syscall

    # 接收選項輸入
    li $v0, 5
    syscall
    move $s0, $v0

    # 提示輸入三角形大小
    li $v0, 4
    la $a0, input_msg2
    syscall

    # 接收三角形大小輸入
    li $v0, 5
    syscall
    move $s1, $v0

    # 初始化層數
    li $t0, 0   # initialize t0 = 0 (目前的layer層)

loop_start:
    slt $t1, $t0, $s1   
    beq $t1, $zero, end # if $t1 = 0 -> jump to end (layer >= n)

    li $t2, 1
    bne $s0, $t2, inverted_tri   # check option 是否為1    
    move $s2, $s1 # define n($s2), i($s3)
    move $s3, $t0
    addi $t0, $t0, 1
    jal print_layer
    j loop_start

inverted_tri:
    move $s2, $s1
    sub $s3, $s1, $t0
    addi $s3, $s3, -1
    addi $t0, $t0, 1    # i++
    jal print_layer
    j loop_start

print_layer:
    li $s4, 0           # initialize j = 0
print_space:
    sub $s5, $s2, $s3   # $s5 = n - l
    slt $t1, $s4, $s5
    beq $t1, $zero, print_stars # if j >= n - l, jump to print_stars
    li $v0, 4
    la $a0, space
    syscall
    addi $s4, $s4, 1    # j++
    j print_space

print_stars:
    sub $s4, $s3, $zero # $s4 = l (reset j to l)
print_star:
    slt $t1, $zero, $s4 # if j < l
    beq $t1, $zero, print_newline # if j >= l, jump to print_newline
    li $v0, 4
    la $a0, star
    syscall
    addi $s4, $s4, -1    # j--
    j print_star

print_newline:
    li $v0, 4
    la $a0, newline
    syscall
    jr $ra

end:
    li $v0, 10
    syscall