.data
    msg_option: .asciiz "Please enter option (1: add, 2: sub, 3: mul): "
    msg_first_num: .asciiz "Please enter the first number: "
    msg_second_num: .asciiz "Please enter the second number: "
    msg_result: .asciiz "The calculation result is: "
    newline: .asciiz "\n"

.text
.globl main

main:
    # Print option message
    li $v0, 4
    la $a0, msg_option
    syscall

    # Read option
    li $v0, 5
    syscall
    move $t0, $v0         # Store the operation option in $t0

    # Print first number message
    li $v0, 4
    la $a0, msg_first_num
    syscall

    # Read first number
    li $v0, 5
    syscall
    move $t1, $v0         # Store the first number in $t1

    # Print second number message
    li $v0, 4
    la $a0, msg_second_num
    syscall

    # Read second number
    li $v0, 5
    syscall
    move $t2, $v0         # Store the second number in $t2

    # Compute based on operation
    bne $t0, 1, check_sub # Check if operation is not addition
    add $t3, $t1, $t2     # Perform addition
    j print_result

check_sub:
    bne $t0, 2, check_mul # Check if operation is not subtraction
    sub $t3, $t1, $t2     # Perform subtraction
    j print_result

check_mul:
    bne $t0, 3, print_result # Check if operation is not multiplication
    mul $t3, $t1, $t2        # Perform multiplication

print_result:
    # Print result message
    li $v0, 4
    la $a0, msg_result
    syscall

    # Print result
    li $v0, 1
    move $a0, $t3
    syscall

    # Print new line
    li $v0, 4
    la $a0, newline
    syscall

    # Exit program
    li $v0, 10
    syscall