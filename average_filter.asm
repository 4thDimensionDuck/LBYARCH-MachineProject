;%include "io.inc"

segment .bss
; Input Image
input resd 1

; Output Image
output resd 1

; Image Dimensions
img_h resd 1
img_w resd 1

; Sample Window Size
sample_s resd 1

segment .data
; Half of sample window size
; Used for borders and iteration through sample window
sample_sh dd 0 

; Input Matrix Indices
in_x dd 0
in_y dd 0

; Current Element
in_index dd 0
out_index dd 0

segment .text
global _average_filter
_average_filter:
    
    ; Parameter Initialization
    push ebp
    mov ebp, esp
    
    mov esi, [ebp+8] ; input
    mov dword [input], esi
    mov esi, [ebp+12] ; output
    mov dword [output], esi
    mov esi, [ebp+16] ; img_h
    mov dword [img_w], esi
    mov esi, [ebp+20] ; img_w
    mov dword [img_h], esi
    mov esi, [ebp+24] ; sample_s
    mov dword [sample_s], esi

    ; Precalc half of sample window
    mov eax, [sample_s]
    sar eax, 1 ; Divides sample_s by 2
    mov [sample_sh], eax
    
    ; clears eax
    xor eax, eax

    mov esi, 0 ;in_y/row counter
    m_row_loop:
        mov edi, 0 ;in_x/column counter    
        m_col_loop:    
            ; Reset Sum
            mov edx, 0            
            
            ; Calculates offset for index
            mov ecx, [img_w]    ;input[ ( img_w * i + j ) * 4 ]
            imul ecx, esi       ;img_w * i
            add ecx, edi        ;img_w * i + j
            sal ecx, 2         ;( (img_w * i) + j ) * 4
            
            mov eax, [input]
            add eax, ecx
            
            mov ebx, [output]
            add ebx, ecx
            
            ; EAX and EBX contain a address pointer to the start of each image
            mov [in_index], eax
            mov [out_index], ebx
            
            start_if:
            ; if x <= border - 1
            mov eax, [sample_sh]
            dec eax
            cmp edi, eax
            jle if_false
            
            ; if x >= img_w - border 
            mov eax, [img_w]
            sub eax, [sample_sh]
            cmp edi, eax
            jge if_false
            
            ; if y <= border - 1
            mov eax, [sample_sh]
            dec eax
            cmp esi, eax
            jle if_false
            
            ; if y >= img_h - border
            mov eax, [img_h]
            sub eax, [sample_sh]
            cmp esi, eax
            jge if_false
            
            jmp if_true
            
            ; If true handles calculation of average within borders
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
                mov ebx, [out_index]
                mov [ebx], eax
                
                ; TODO: Instead of Printing, Place the Averaged Value in the Output Matrix
                ;PRINT_DEC 4, eax
                ;PRINT_STRING " "
            
                jmp end_if_true
            
            if_false:
                
                ; TODO: Copy input to output
                
                mov eax, [in_index]
                mov ecx, [eax]
                
                mov ebx, [out_index]
                mov [ebx], ecx
                
                ; Clear eax, ebx
                xor eax, eax
                xor ebx, ebx
                
                ; Debug
                ;PRINT_DEC 4, [eax]
                ;PRINT_STRING " "
                
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
        ;NEWLINE
        
        inc esi
        mov [in_y], esi
        
        mov ecx, [img_h]
        cmp esi, ecx
        jl m_row_loop

    m_col_loop_end:

    xor eax, eax
    pop ebp
    ret