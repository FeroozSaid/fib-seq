.data
prompt:     .asciz "Input: N = "
iter_msg:   .asciz "Iterative: "
rec_msg:    .asciz "Recursive: "
space:      .asciz " "
newline:    .asciz "\n"

.text
.globl main

main:
    # Print prompt and read N
    li a7, 4
    la a0, prompt
    ecall
    li a7, 5
    ecall
    mv s0, a0           # s0 = N

    # ---- Iterative Approach ----
    li a7, 4
    la a0, iter_msg
    ecall
    jal ra, print_iterative_sequence

    # ---- Recursive Approach ----
    li a7, 4
    la a0, rec_msg
    ecall
    jal ra, print_recursive_sequence

    # Exit
    li a7, 10
    ecall

# ===== ITERATIVE PRINT ===== (Fixed)
print_iterative_sequence:
    addi sp, sp, -16
    sw ra, 12(sp)
    sw s0, 8(sp)
    sw s1, 4(sp)
    sw s2, 0(sp)

    li s1, 0            # F(0) = 0
    li s2, 1            # F(1) = 1
    li t0, 0            # counter i

    # Print F(0)
    mv a0, s1
    li a7, 1
    ecall
    beqz s0, end_iter   # if N=0, exit

    # Print space and F(1)
    li a7, 4
    la a0, space
    ecall
    mv a0, s2
    li a7, 1
    ecall
    li t0, 2            # start from i=2

iter_loop:
    bgt t0, s0, end_iter  # while i <= N

    # Calculate next Fibonacci (F(i) = F(i-1) + F(i-2))
    add t1, s1, s2

    # Print space and F(i)
    li a7, 4
    la a0, space
    ecall
    mv a0, t1
    li a7, 1
    ecall

    # Update values
    mv s1, s2          # F(i-2) = old F(i-1)
    mv s2, t1          # F(i-1) = new F(i)

    addi t0, t0, 1     # i++
    j iter_loop

end_iter:
    li a7, 4
    la a0, newline
    ecall
    lw ra, 12(sp)
    lw s0, 8(sp)
    lw s1, 4(sp)
    lw s2, 0(sp)
    addi sp, sp, 16
    ret

# ===== RECURSIVE PRINT ===== (Fixed)
print_recursive_sequence:
    addi sp, sp, -12
    sw ra, 8(sp)
    sw s0, 4(sp)
    sw s1, 0(sp)

    li s1, 0            # counter i

recursive_loop:
    bgt s1, s0, end_recursive  # while i <= N

    # Calculate F(i)
    mv a0, s1
    jal ra, fib_recursive

    # Print result
    mv a0, a1
    li a7, 1
    ecall

    # Print space (except last number)
    bge s1, s0, skip_space
    li a7, 4
    la a0, space
    ecall
skip_space:

    addi s1, s1, 1
    j recursive_loop

end_recursive:
    li a7, 4
    la a0, newline
    ecall
    lw ra, 8(sp)
    lw s0, 4(sp)
    lw s1, 0(sp)
    addi sp, sp, 12
    ret

# ===== RECURSIVE FIBONACCI =====
fib_recursive:
    addi sp, sp, -12
    sw ra, 8(sp)
    sw a0, 4(sp)

    # Base cases
    beqz a0, return_0
    li t0, 1
    beq a0, t0, return_1

    # F(n-1)
    addi a0, a0, -1
    jal ra, fib_recursive
    sw a1, 0(sp)

    # F(n-2)
    lw a0, 4(sp)
    addi a0, a0, -2
    jal ra, fib_recursive

    # F(n) = F(n-1) + F(n-2)
    lw t0, 0(sp)
    add a1, t0, a1

    lw ra, 8(sp)
    addi sp, sp, 12
    ret

return_0:
    li a1, 0
    lw ra, 8(sp)
    addi sp, sp, 12
    ret

return_1:
    li a1, 1
    lw ra, 8(sp)
    addi sp, sp, 12
    ret