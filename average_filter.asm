%include "io.inc"

section .data

; Input Image
input dd 1, 4, 0, 1, 3, 1, 2, 2, 4, 2, 2, 3, 1, 0, 1, 0, 1, 0, 1, 2, 1, 0, 2, 2, 2, 5, 3, 1, 2, 5, 1, 1, 4, 2, 3, 0

; Image Dimensions
img_h dd 6
img_w dd 6

; Sample Window Size
sample_s dd 3
; Half of sample window size
; Used for borders and iteration through sample window
sample_sh dd 0 

; Input Matrix Indices
in_x dd 0
in_y dd 0

; Current Element
cur_element dd 0

; Sample Matrix Indices
sm_x dd 0
sm_y dd 0

section .text
global main
main:
    mov ebp, esp; for correct debugging
    ; precalcs half of sample window
    mov eax, [sample_s]
    sar eax, 1 ; Divides sample_s by 2
    mov [sample_sh], eax
    
    ; clears eax
    xor eax, eax

    mov esi, 0 ;in_y/row counter
    m_row_loop:
        mov edi, 0 ;in_x/column counter    
        m_col_loop:    
            
            start_if:
            ; if x <= border - 1
            mov eax, [sample_sh]
            dec eax
            cmp edi, eax
            jle end_if_true
            
            ; if x >= img_w - border - 1 
            mov eax, [img_w]
            sub eax, [sample_sh]
            cmp edi, eax
            jge end_if_true
            
            ; if y <= border - 1
            mov eax, [sample_sh]
            dec eax
            cmp esi, eax
            jle end_if_true
            
            ; if y >= img_h - border - 1
            mov eax, [img_h]
            dec eax
            sub eax, [sample_sh]
            cmp esi, eax
            jge end_if_true
            
            jmp if_true
            
            if_true:                
                mov eax, input
                
                ; Calculates offset for index
                mov ebx, edi    ; j
                imul ebx, 4     ; j * 4
                add eax, ebx    ; input[j*4]
                
                mov ebx, esi    ; i
                imul ebx, ecx   ; i * img_w
                imul ebx, 4     ; i * img_w * 4
                add eax, ebx    ; input[j + i * img_w * 4]
                
                mov [in_x], edi
                mov [in_y], esi
                mov [cur_element], eax
                
                ; Sum is EDX
                mov edx, 0
                
                ; TODO ITERATE THROUGH SAMPLE WINDOW
                mov ebx, [sample_sh]
                neg ebx
                mov esi, ebx ;sm_y
                s_col_loop:
                    mov ebx, [sample_sh]
                    neg ebx
                    mov edi, ebx ; sm_x
                    s_row_loop:
                        mov eax, [cur_element]
                    
                        ; input_image[(in_x + sm_x * 4) + (in_y + sm_y * img_w * 4)]
                    
                        ; sm_x * 4
                        mov ebx, edi
                        imul ebx, 4
                        add eax, ebx
                        
                        mov ebx, esi
                        imul ebx, [img_w]
                        imul ebx, 4
                        add eax, ebx
                        
                        
                        add edx, [eax]
                        ;PRINT_DEC 4, [eax]
                        ;PRINT_STRING " "
                    
                        inc edi
                        mov ebx, [sample_s]
                        dec ebx
                        cmp edi, ebx
                        jl s_row_loop
                        
                    s_row_loop_end:
                    
                    ;NEWLINE
                    
                    inc esi
                    mov ebx, [sample_s]
                    dec ebx
                    cmp esi, ebx
                    jl s_col_loop
                    
                s_col_loop_end:
                
                mov edi, [in_x]
                mov esi, [in_y]
                
                mov eax, edx
                mov edx, 0
  
                PRINT_DEC 4, eax
                
                ; Debug
                ;PRINT_DEC 4, [eax]
                PRINT_STRING " "
            
                jmp end_if_true
            end_if_true:
            
            ; Increment in_x
            inc edi
            mov [in_x], edi
            
            mov ecx, [img_w]
            cmp edi, ecx
            jl m_col_loop
        
        m_row_loop_end:
        
        ; Debug
        NEWLINE
        
        inc esi
        mov [in_y], esi
        
        mov ecx, [img_h]
        cmp esi, ecx
        jl m_row_loop

    m_col_loop_end:

    xor eax, eax
    ret