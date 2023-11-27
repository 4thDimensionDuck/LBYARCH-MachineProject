%include "io.inc"

segment .data
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
in_index dd 0
out_index dd 0

; Sample Matrix Indices
sm_x dd 0
sm_y dd 0

segment .text
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
            
            mov edx, 0
            
            lea eax, [input]
            ;lea ebx, [output]
            
            ; Calculates offset for index
            mov ecx, [img_w]    ;input[ ( img_w * i + j ) * 4 ]
            imul ecx, esi       ;img_w * i
            add ecx, edi        ;img_w * i + j
            imul ecx, 4         ;( (img_w * i) + j ) * 4
            add eax, ecx
            ;add ebx, ecx
            
            ; Both input and output are no pointing at the same index
            mov [in_index], eax
            ;mov [out_index], ebx
            
            xor eax, eax
            xor ebx, ebx
            
            start_if:
            ; if x <= border - 1
            mov eax, [sample_sh]
            dec eax
            cmp edi, eax
            jle if_false
            
            ; if x >= img_w - border - 1 
            mov eax, [img_w]
            ;dec eax
            sub eax, [sample_sh]
            cmp edi, eax
            jge if_false
            
            ; if y <= border - 1
            mov eax, [sample_sh]
            dec eax
            cmp esi, eax
            jle if_false
            
            ; if y >= img_h - border - 1
            mov eax, [img_h]
            ;dec eax
            sub eax, [sample_sh]
            cmp esi, eax
            jge if_false
            
            jmp if_true
            
            if_true:                
                
                mov [in_x], edi
                mov [in_y], esi

                ; Sample Window Iteration and Summation
                mov ebx, [sample_sh]
                neg ebx
                mov esi, ebx ;sm_y
                s_col_loop:
                    mov ebx, [sample_sh]
                    neg ebx
                    mov edi, ebx ; sm_x
                    s_row_loop:
                        mov eax, [in_index]
                    
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
                    
                        inc edi
                        mov ebx, [sample_s]
                        dec ebx
                        cmp edi, ebx
                        jl s_row_loop
                        
                    s_row_loop_end:
                    
                    inc esi
                    mov ebx, [sample_s]
                    dec ebx
                    cmp esi, ebx
                    jl s_col_loop
                    
                s_col_loop_end:
                
                mov edi, [in_x]
                mov esi, [in_y]
                
                xor eax, eax
                
                mov eax, edx
                xor edx, edx
                
                mov ebx, [sample_s]
                imul ebx, ebx
                mov ecx, ebx
                sar ecx, 1
                
                add eax, ecx
                
                div ebx
                
                ; EAX has Averaged Value
                
                ;mov ebx, [out_index]
                ;mov [ebx], eax
                
                ; TODO: Instead of Printing, Place the Averaged Value in the Output Matrix
                PRINT_DEC 4, eax
                PRINT_STRING " "
            
                jmp end_if_true
            
            if_false:
                
                ; TODO: Copy input to output
                
                mov eax, [in_index]
                ;mov ebx, [out_index]
                ;mov ecx, [eax]    ; Move the value in input index
                ;mov [ebx], ecx    ; to the output index
                
                ; Clear eax, ebx
                ;xor eax, eax
                ;xor ebx, ebx
                
                ; Debug
                PRINT_DEC 4, [eax]
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
        
        ; TODO: Remove Debug
        NEWLINE
        
        inc esi
        mov [in_y], esi
        
        mov ecx, [img_h]
        cmp esi, ecx
        jl m_row_loop

    m_col_loop_end:

    xor eax, eax
    ret