INCLUDE Irvine32.inc
.data
    prompt1 BYTE "Enter first number : ", 0
    prompt2 BYTE "Enter second number : ", 0
    prompt3 BYTE "Enter the number : " , 0
    menuPrompt BYTE "Enter operation:", 0
    option1 BYTE "1: Addition", 0
    option2 BYTE "2: Subtraction", 0
    option3 BYTE "3: Multiplication", 0
    option4 BYTE "4: Division", 0
    option5 BYTE "5: Square", 0
    option6 BYTE "6: Square Root", 0
    option7 BYTE "7: Permutations (nPr)", 0
    option8 BYTE "8: Combinations (nCr)", 0
    option9 BYTE "9: Factorial", 0
    option10 BYTE "10: Exponentiation", 0
    option11 BYTE "11: Modulus", 0
    option12 BYTE "12: Exit ", 0
    option13 BYTE "13: Save last answer", 0

    useLastAns BYTE 0
    lastResult SDWORD ? 
    DivByZero BYTE "Error: Division by zero!", 0
    InvalidOperation BYTE "Error: Invalid operation!", 0
    InvalidInput BYTE "Error: Invalid input!", 0
    resultStr BYTE "The result is: ", 0
    exitingmsg BYTE "Thank you for using calculator " , 0

    num1 SDWORD ?
    num2 SDWORD ?
    num3 SWORD ?
    num4 SWORD ?
    result SDWORD ?
    op DWORD ?

.code
main PROC
    op_nxt:
    call clrscr
    ; Display menu options
    mov eax, 03h
    call setTextcolor
    mov edx, OFFSET menuPrompt
    call WriteString
    call Crlf
    mov edx, OFFSET option1
    call WriteString
    call Crlf
    mov edx, OFFSET option2
    call WriteString
    call Crlf
    mov edx, OFFSET option3
    call WriteString
    call Crlf
    mov edx, OFFSET option4
    call WriteString
    call Crlf
    mov edx, OFFSET option5
    call WriteString
    call Crlf
    mov edx, OFFSET option6
    call WriteString
    call Crlf
    mov edx, OFFSET option7
    call WriteString
    call Crlf
    mov edx, OFFSET option8
    call WriteString
    call Crlf
    mov edx, OFFSET option9
    call WriteString
    call Crlf
    mov edx, OFFSET option10
    call WriteString
    call Crlf
    mov edx, OFFSET option11
    call WriteString
    call Crlf
    mov edx, OFFSET option12
    call WriteString
    call Crlf
    mov edx, OFFSET option13
    call WriteString
    call Crlf

    ; Read operation
    call readchar
  
    cmp al, 27d         
    je RECALL_RESULT
    call ReadInt
    mov op, eax

    ; Perform selected operation
    cmp op, 1
    je ADDITION
    cmp op, 2
    je SUBTRACTION
    cmp op, 3
    je MULTIPLICATION
    cmp op, 4
    je DIVISION
    cmp op, 5
    je SQUARE
    cmp op, 6
    je SQRT
    cmp op, 7
    je PERMUTATION
    cmp op, 8
    je COMBINATION
    cmp op, 9
    je FACTORIAL
    cmp op, 10
    je EXPONENTIATION
    cmp op, 11
    je MODULUS
    cmp op , 12
    je END_PROGRAM 
    cmp op , 13
    je SAVE_RESULT
    jmp INVALID_OP



ADDITION:
    ; Check if we should use the saved result
    cmp useLastAns, 0
    je normal_addition
    
    ; Use saved result as first number
    mov eax, lastResult  ; Load saved result
    mov num1, eax        ; Store it in num1
    mov useLastAns, 0    ; Reset the flag
    jmp get_second_only

normal_addition:
    call GET_First_Num   ; Get both numbers normally
    
get_second_only:
    call GET_SECOND_NUMBER
    mov eax, num1
    add eax, num2
    mov result, eax
    jmp DISPLAY_RESULT


SUBTRACTION:
    cmp useLastAns, 0
    je normal_subtraction
    
    mov eax, lastResult
    mov num1, eax
    mov useLastAns, 0
    jmp get_second_sub

normal_subtraction:
    call GET_First_Num

get_second_sub:
    call GET_SECOND_NUMBER
    mov eax, num1
    sub eax, num2
    mov result, eax
    jmp DISPLAY_RESULT

MULTIPLICATION:
    cmp useLastAns, 0
    je normal_multiplication
    
    mov eax, lastResult
    mov num1, eax
    mov useLastAns, 0
    jmp get_second_mult

normal_multiplication:
    call GET_First_Num

get_second_mult:
    call GET_SECOND_NUMBER
    mov eax, num1
    imul  num2
    jo OVERFLOW_HANDLER  
    mov result, eax
    jmp DISPLAY_RESULt_mult

OVERFLOW_HANDLER:
    ; Handle overflow condition
    mov edx, OFFSET InvalidInput  
    call WriteString
    invoke sleep, 850
    jmp op_nxt
DIVISION:
    cmp useLastAns, 0
    je normal_division
    
    mov eax, lastResult
    mov num3, ax  ; Note: Converting SDWORD to SWORD for division
    mov useLastAns, 0
    jmp get_second_div

normal_division:
    call GET_First_Num_Div

get_second_div:
    call GET_Second_Num_Div
    cmp num4, 0
    je DIV_BY_ZERO
    mov eax, 0
    mov ax, num3
    xor edx, edx
    cwd
    idiv num4
    movsx eax, ax
    mov result, eax
    jmp DISPLAY_RESULT

SQUARE:
    cmp useLastAns, 0
    je normal_square
    
    mov eax, lastResult
    mov num1, eax
    mov useLastAns, 0
    jmp do_square

normal_square:
    call GET_First_Num

do_square:
    mov eax, num1
    imul eax, num1
    mov result, eax
    jmp DISPLAY_RESULT

SQRT:
    cmp useLastAns, 0
    je normal_sqrt
    
    mov eax, lastResult
    mov num1, eax
    mov useLastAns, 0
    jmp do_sqrt

normal_sqrt:
    call GET_First_Num

do_sqrt:
    call SQRTP
    jmp DISPLAY_RESULT

PERMUTATION:
    cmp useLastAns, 0
    je normal_perm
    
    mov eax, lastResult
    mov num1, eax
    mov useLastAns, 0
    jmp get_second_perm

normal_perm:
    call GET_First_Num

get_second_perm:
    call GET_SECOND_NUMBER
    mov eax , num2
    cmp eax, num1
    jg INVALID_INPUT  ; Jumping if num2 > num1

    mov eax, num1
    call ComputeFactorialComb
    ; eax = n!
    mov result, eax
    mov eax, num1
    mov ebx, num2
    sub eax, ebx ; eax = eax - ebx -> (n -r)
    call ComputeFactorialComb
    ;eax = (n-r)!
    mov ebx, eax
    mov eax, result
    xor edx, edx
    div ebx
    mov result, eax
    jmp DISPLAY_RESULT

COMBINATION:
    cmp useLastAns, 0
    je normal_comb
    
    mov eax, lastResult
    mov num1, eax
    mov useLastAns, 0
    jmp get_second_comb

normal_comb:
    call GET_First_Num
    

get_second_comb:
    call GET_SECOND_NUMBER
    mov eax , num2
    cmp eax, num1
    jg INVALID_INPUT  ; Jumping if num2 > num1
    ; n!
    mov eax, num1
    call ComputeFactorialComb
    mov result, eax ;n! saved
    mov eax, num1
    mov ebx, num2
    sub eax, ebx ; (n-r)! calculation
    call ComputeFactorialComb
    mov ebx, eax ;ebx = (n-r)! saved
    mov eax, num2 ; eax = r
    call ComputeFactorialComb
    ; eax = r!
    mul bx ; eax = (n-r)! * r!
    mov ebx, eax ; ebx = (n-r)! * r!
    mov eax, result ; eax = n!
    xor edx, edx
    idiv ebx
    mov result, eax
    jmp DISPLAY_RESULT

FACTORIAL:
    cmp useLastAns, 0
    je normal_fact
    
    mov eax, lastResult
    cmp eax, 0    ; Check if saved result is non-negative
    jl INVALID_INPUT
    mov num1, eax
    mov useLastAns, 0
    jmp do_factorial

normal_fact:
    call GET_First_Num_Fact

do_factorial:
    mov eax, num1
    call ComputeFactorial
    mov result, eax
    jmp DISPLAY_RESULT

EXPONENTIATION:
    cmp useLastAns, 0
    je normal_exp
    
    mov eax, lastResult
    mov num1, eax
    mov useLastAns, 0
    jmp get_second_exp

normal_exp:
    call GET_First_Num

get_second_exp:
    call GET_SECOND_NUMBER
    mov eax, num1
    mov ecx, num2
    call Power
    mov result, eax
    jmp DISPLAY_RESULT

MODULUS:
    cmp useLastAns, 0
    je normal_mod
    
    mov eax, lastResult
    mov num1, eax
    mov useLastAns, 0
    jmp get_second_mod

normal_mod:
    call GET_First_Num

get_second_mod:
    call GET_SECOND_NUMBER
    mov eax, num1
    mov ebx, num2
    xor edx, edx
    idiv ebx
    mov result, edx
    jmp DISPLAY_RESULT

INVALID_OP:
    mov edx, OFFSET InvalidOperation
    call WriteString
    Invoke sleep , 850
    jmp op_nxt
   

DIV_BY_ZERO:
    mov edx, OFFSET DivByZero
    call WriteString
    Invoke sleep , 850
    jmp op_nxt
    

INVALID_INPUT:
    mov edx, OFFSET InvalidInput
    call WriteString
    Invoke sleep , 850
    jmp op_nxt

RECALL_RESULT:
    mov eax, lastResult 
    mov result , eax
    call DISPLAY_RESULT
    jmp op_nxt
    

DISPLAY_RESULT:
    mov eax, 04h
    call setTextColor
    mov edx, OFFSET resultStr
    call WriteString
    mov eax, result
    call WriteInt
    Invoke sleep , 1100
    call crlf
    call waitmsg
    jmp op_nxt
DISPLAY_RESULT_MULT:
    mov eax, 40h
    call setTextColor
    mov edx, OFFSET resultStr
    call WriteString
    
    mov eax, result  ; Load the result into eax
    
    ; Check for overflow condition
    jno l1          
    
    shl eax, 16     
    mov edx, 0       
    shrd eax, edx, 16 
    
    mov result, eax  ; Storing the modified number after shifting operation
    
l1:
    mov eax, result  
    call WriteInt    
    
    invoke Sleep, 1200   ; Wait for 1 second
    call Crlf            
    call WaitMsg   

    mov eax, 07h
    call setTextColor
    
    jmp op_nxt           ; Jump to next operation

END_PROGRAM:
    Invoke sleep , 300
    call clrscr
    mov dh , 04h
    mov dl , 04h
    call gotoxy
    mov edx , offset exitingmsg
    call writestring
    call crlf
    mov dh , 05h
    mov dl , 05h
    call gotoxy
    call WaitMsg
    jmp nothing

SAVE_RESULT:
    mov eax, result
    mov lastResult, eax  
    mov useLastAns, 1    
    jmp op_nxt

nothing:

    exit
main ENDP

SQRTP PROC
    finit
    fild num1
    fsqrt
    fistp result
    ret
SQRTP ENDP

ComputeFactorial PROC
    mov ecx, num1
    mov eax, 1
    FactorialLoop:
        cmp ecx, 1
        jle FactorialDone
        imul eax, ecx
        dec ecx
        jmp FactorialLoop
    FactorialDone:
        ret
ComputeFactorial ENDP

ComputeFactorialComb PROC
    mov ecx, eax
    cmp ecx, 0
    jle FactorialDone
    mov eax, 1
    FactorialLoop:
        cmp ecx, 1
        jle FactorialDone
        imul eax, ecx
        dec ecx
        jmp FactorialLoop
    FactorialDone:
        ret
ComputeFactorialComb ENDP

Power PROC
    push ebx
    mov eax, 1       
    mov ebx, ecx     
PowerLoop:
    cmp ebx, 0       
    je PowerDone      
    imul eax, num1   
    dec ebx          
    jmp PowerLoop
PowerDone:
    pop ebx
    ret
Power ENDP

GET_First_Num_Div PROC
    mov eax, 02h
    call settextcolor
    mov edx, OFFSET prompt1
    call WriteString
    call ReadInt
    mov num3, ax
    ret
GET_First_Num_Div ENDP

GET_Second_Num_Div PROC
    mov eax, 02h
    call settextcolor
    mov edx, OFFSET prompt1
    call WriteString
    call ReadInt
    mov num4, ax
    ret
GET_Second_Num_Div ENDP

GET_First_Num PROC
    mov eax, 02h
    call settextcolor
    mov edx, OFFSET prompt1
    call WriteString
    call ReadInt
    mov num1, eax
    ret
GET_First_Num ENDP

GET_SECOND_NUMBER PROC
    mov eax, 02h
    call settextcolor
    mov edx, OFFSET prompt2
    call WriteString
    call ReadInt
    mov num2, eax
    ret
GET_SECOND_NUMBER ENDP

GET_First_Num_Fact PROC
    mov eax, 02h
    call settextcolor
    nxt_pt:
    mov edx, OFFSET prompt3
    call WriteString
    call ReadInt
    cmp eax , 0
    jl nxt_pt
    mov num1, eax
    ret
GET_First_Num_Fact ENDP
END main