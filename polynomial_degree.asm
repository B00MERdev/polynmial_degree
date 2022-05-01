        global  polynomial_degree
section .text
;       rdi     value of int* arr
;       rsi     value of n - array length
polynomial_degree:
        mov     rcx, rsi                        ;value of n - array length
check_only_zeros:
        mov     edx, [rdi + (rcx - 1) * 4]      ;bringing in next element of the array to chceck it
        cmp     edx, 0                          ;to update zero flag
        jnz     check_only_one_elem
        loop    check_only_zeros
        mov     rax, -1                         ;const 0 polynomial
        ret
check_only_one_elem:
        cmp     rsi, 1                          ;value of n - array length
        jne     calculate_bigint_length
        mov     rax, 0                          ;const not 0 polynomial
        ret
calculate_bigint_length:
        mov     rax, rsi
        add     rax, 32                         ;to calculate then number of 64 bit segments of bigint
        mov     rcx, 64                         ;i want it to be divisible by register max length
        mov     rdx, 0                          ;for div purposes
        div     rcx
        xor     rcx, rcx
        mov     r8, 1
        cmp     edx, 0
        cmovnz  rcx, r8
        add     rax, rcx                        ;i want it to be the ceiling of (n + 32) / 64
        mov     r8, rax                         ;the number of 64 bit bigint segments, saved the number
push_input_elements:
        mov     rcx, rsi                        ;value of n - array length
push_next_element:
        mov     r9, r8                          ;r9 is the number of segments of 1 bigint to push
        xor     rax, rax                        ;in rax will be the value to put into the rest of the segments
        mov     edx, [rdi + (rcx - 1) * 4]      ;bringing in next element of the array to chceck it
        cmp     edx, 0
        jge     push_segment_loop
        mov     rax, 0xffffffff00000000         ;if it is negative, we need to extend it to 64 bits
        add     rdx, rax
        mov     rax, -1                         ;preparing 111..111 for negative numbers
push_segment_loop:
        dec     r9
        jz     push_last_segment
        push    rax                             ;pushing recurring segment
        jmp     push_segment_loop
push_last_segment:
        push    rdx                             ;pushing last segment
        loop    push_next_element
reduce_degree:
        mov     rdx, rsi                        ;value of n - array length, rdx will have the current number of elements
reduce_degree_loop:
        cmp     rdx, 1
        je      put_result_in_rax
        dec     rdx                             ;decrease the number of current elements, till it is 1
        mov     rcx, rdx
        mov     r9, rsp                         ;r9 will be used to shift the stack to the next element
reduce_degree_element_loop:
        xor     rax, rax                        ;rax is the counter from 0 to r8
reduce_degree_segment_loop:
        mov     r11, 8
shift_to_next_loop:
        add     r9, r8
        dec     r11
        jnz     shift_to_next_loop
        mov     r10, [r9 + rax * 8]
        mov     r11, 8
shift_to_previous_loop:
        sub     r9, r8
        dec     r11
        jnz     shift_to_previous_loop
        sub     r10, [r9 + rax * 8]
        mov     [r9 + rax * 8], r10
        jno     continue_no_carry
        mov     r10, rax
        inc     r10
        cmp     r10, r8
        jo      continue_no_carry
        add     qword [r9 + r10 * 8], 1
continue_no_carry:
        inc     rax
        cmp     rax, r8
        jne     reduce_degree_segment_loop
        mov     rax, 8
shift_to_next_element_loop:
        add     r9, r8
        dec     rax
        jnz     shift_to_next_element_loop
        loop    reduce_degree_element_loop
check_if_only_zeros:
        mov     r9, rsp                         ;r9 will be used to shift the stack to the next element
        mov     r10, r8
check_if_only_zeros_outer_loop:
        mov     rcx, rdx                        ;counting down all current elements
check_if_only_zeros_inner_loop:
        cmp     qword [r9 + (rcx - 1) * 8], 0   ;checking if next element is 0
        jnz     reduce_degree_loop
        loop    check_if_only_zeros_inner_loop
        mov     rax, 8
shift_to_next_element:
        add     r9, r8
        dec     rax
        jnz     shift_to_next_element
        dec     r10
        jnz     check_if_only_zeros_outer_loop
        inc     rdx
put_result_in_rax:   
        mov     rax, rsi                        ;the result is rsi - rdx
        sub     rax, rdx
fix_rsp:
        mov     r9, r8                          ;bigint number of segments
fix_rsp_outer_loop:
        mov     rcx, 8                          ;elements of array are 8 bytes each
fix_rsp_inner_loop:
        add     rsp, rsi
        loop    fix_rsp_inner_loop
        dec     r9
        jnz     fix_rsp_outer_loop
        ret