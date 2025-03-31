.data
    prompt: .asciiz "Please input a number: "
    prime_msg: .asciiz "It's a prime\n"
    not_prime_msg: .asciiz "It's not a prime\n"
.text
.globl main

main:
    li $v0, 4                   # syscall to print string
    la $a0, prompt
    syscall

    li $v0, 5                   # syscall to read integer
    syscall
    move $a1, $v0               # Move read integer to $a1 for prime function

    jal prime                   # Call prime function
    move $t0, $v0               # Store the return value of prime in $t0

    li $v0, 4                   # Prepare for syscall to print result
    beq $t0, 1, print_prime     # Check if prime returned 1
    la $a0, not_prime_msg
    syscall
    j end                       # jump to end procedure

prime:
    li $v0, 1          # Assume n is prime, return 1 by default
    bne $a1, 1, loop   # If n is not 1, jump to loop
    li $v0, 0          # If n is 1 -> is not a prime -> set return to 0 (false)
    jr $ra             # Return from function

loop:
    li $t1, 2          # Start divisor i from 2
    mul $t2, $t1, $t1  # $t2 = i * i
loop_cond:
    ble $t2, $a1, check_divide  # Continue loop while i*i <= n
    jr $ra                      # Return if i*i > n, n is prime

check_divide:
    div $a1, $t1                # Divide n by i
    mfhi $t3                    # Move the remainder from HI to $t3
    bnez $t3, increment         # If remainder is not zero -> n is not divisible by i
    li $v0, 0                   # n is divisible by i -> not prime
    jr $ra                      # Return from function

increment:
    addi $t1, $t1, 1            # Increment i
    mul $t2, $t1, $t1           # Calculate i*i again
    j loop_cond                 # Jump back to loop condition

print_prime:
    la $a0, prime_msg
    syscall
    j end                       # jump to end after printing

end:
    li $v0, 10                  # syscall to exit
    syscall