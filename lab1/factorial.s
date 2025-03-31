
# syscall: 使用 syscall 指令允許我們訪問和使用操作系統的功能，而不需要直接與硬件打交道

.data	# 定義資料段
    input_msg:  .asciiz "Please input a number: "  # 定義輸入提示訊息字串
    output_msg: .asciiz "The result of factorial(n) is "  # 定義輸出結果訊息字串
    newline:    .asciiz "\n"  # 定義換行字串

.text	# 定義程式段
.globl main
#------------------------- main -----------------------------
main:
# print input_msg on the console interface (控制台)
    li      $v0, 4              # 設置$v0為4 -> 告訴系統我們想要做 "打印字串" 的動作 (load immediate)
    la      $a0, input_msg      # 將input_msg的地址加載到$a0中	(load address)
    syscall                     # 執行系統呼叫

# read the input integer in $v0
    li      $v0, 5              # 設置$v0為5 -> 告訴系統我們想要做 "讀取整數" 的動作
    syscall                     # 執行系統呼叫
    move    $a0, $v0            # 將輸入的整數存入$a0（設置為函數factorial的參數）

# jump to procedure factorial
    jal     factorial           # 跳轉並鏈接到factorial程序
    move    $t0, $v0            # 將返回值保存在$t0中（因為$v0將被系統呼叫使用）

# print output_msg on the console interface
    li      $v0, 4              # print string
    la      $a0, output_msg     # 將output_msg的地址加載到$a0中
    syscall                     # 執行系統呼叫

# print the result of procedure factorial on the console interface
    li      $v0, 1              # print int
    move    $a0, $t0            # 將整數值移動到$a0
    syscall                     # 執行系統呼叫

# print a newline at the end
    li      $v0, 4              # print string
    la      $a0, newline        # 將newline的地址加載到$a0中
    syscall                     # 執行系統呼叫

# exit the program
    li      $v0, 10             # 告訴系統要exit了
    syscall                     # 執行系統呼叫

#------------------------- procedure factorial -----------------------------
# load argument n in $a0, return value in $v0.	(傳進來參數為$a0, 返回參數為$v0)
.text
factorial:  
    addi    $sp, $sp, -8        # stack pointer:指向堆疊頂端, 當我們需要存數據時, 會將sp向下移動(decrease value)
    sw      $ra, 4($sp)         # 保存返回地址
    sw      $a0, 0($sp)         # 保存參數n
    slti    $t0, $a0, 1         # if n < 1: t0 = 1, else: t0 = 0
    beq     $t0, $zero, L1      # if n >= 1: jump to L1 (做乘法動作)
    addi    $v0, $zero, 1       # 返回1 (set v0 = 1)
    addi    $sp, $sp, 8         # 彈出堆疊上的2個項目
    jr      $ra                 # 返回調用者
L1:     
    addi    $a0, $a0, -1        # n >= 1時, 將參數設置為(n-1)
    jal     factorial           # 調用factorial，參數為(n-1)
    lw      $a0, 0($sp)         # 返回時恢復參數n
    lw      $ra, 4($sp)         # 恢復返回地址
    addi    $sp, $sp, 8         # 調整堆疊指針，彈出2個項目
    mul     $v0, $a0, $v0       # 返回n * factorial(n-1)
    jr      $ra                 # 返回調用者