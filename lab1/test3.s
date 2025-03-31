.data
input_msg: .asciiz "Please input a number: "      # 提示輸入
result_msg: .asciiz "The result of fibonacci(n) is "  # 結果訊息
newline: .asciiz "\n"                          # 換行字元

.text
.globl main

main:
    # 打印輸入提示
    li $v0, 4
    la $a0, input_msg
    syscall

    # 讀取輸入的數字
    li $v0, 5
    syscall
    move $a0, $v0            # 將輸入的數字放入 $a0

    # 調用 fibonacci 函數
    jal fibonacci

    # 保存結果到 $s0
    move $s0, $v0

    # 打印結果訊息
    li $v0, 4
    la $a0, result_msg
    syscall

    # 打印結果數字
    move $a0, $s0
    li $v0, 1
    syscall

    # 打印換行
    li $v0, 4
    la $a0, newline
    syscall

    # 結束程式
    li $v0, 10
    syscall

# fibonacci 函數
# 輸入: $a0 = n (input number)
# 輸出: $v0 = fibonacci(n)

fibonacci:
    addi $sp, $sp, -12
    sw $s0 , 8($sp)
    sw $ra , 4($sp)
    sw $a0 , 0($sp)

    addi $t0, $zero, 1
    beq $a0 , $zero , lab
    beq $t0 , $a0 , lab
    addi $a0 , $a0 , -1

    jal fibonacci 
    add $s0 , $zero , $v0
    lw $a0 ,0($sp)
    addi $a0 , $a0 , -2

    jal fibonacci
    add $v0 , $s0 , $v0
    lw $s0 , 8($sp)
    lw $ra , 4($sp)
    lw $a0 , 0($sp)

    add $sp , $sp , 12
    jr $ra
lab:
    add $v0 , $zero , $a0
    addi $sp, $sp, 12
    jr $ra 