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

    ; Read operation
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
    jmp INVALID_OP

ADDITION:
    call GET_First_Num
    call GET_SECOND_NUMBER
    add eax, num1
    mov result, eax
    jmp DISPLAY_RESULT

SUBTRACTION:
    call GET_First_Num
    call GET_SECOND_NUMBER
    mov eax, num1
    sub eax, num2
    mov result, eax
    jmp DISPLAY_RESULT

MULTIPLICATION:
    call GET_First_Num
    call GET_SECOND_NUMBER
    mov eax, num1
    imul eax, num2

    jmp DISPLAY_RESULT_MULT

DIVISION:
    call GET_First_Num_Div
    call GET_Second_Num_Div
    cmp num4, 0
    je DIV_BY_ZERO
    mov eax , 0
    mov ax,  num3
    xor edx, edx
    cwd
    idiv num4
    movsx eax , ax
    mov result , eax
    jmp DISPLAY_RESULT

SQUARE:
    call GET_First_Num
    mov eax, num1
    imul eax, num1
    mov result, eax
    jmp DISPLAY_RESULT

SQRT:
    call GET_First_Num
    call SQRTP
    jmp DISPLAY_RESULT

PERMUTATION:
    call GET_First_Num
    call GET_SECOND_NUMBER
    mov eax, num1
    call ComputeFactorial
    mov result, eax
    mov eax, num1
    mov ebx, num2
    sub eax, ebx
    call ComputeFactorial
    mov ebx, eax
    mov eax, result
    xor edx, edx      ; Zero out edx to prevent overflow
    idiv ebx
    mov result, eax
    jmp DISPLAY_RESULT

COMBINATION:
    call GET_First_Num
    call GET_SECOND_NUMBER
    mov eax, num1
    call ComputeFactorial
    mov result, eax
    mov eax, num1
    mov ebx, num2
    sub eax, ebx
    call ComputeFactorial
    mov ebx, eax
    mov eax, num2
    call ComputeFactorial
    mul ebx
    mov ebx, eax
    mov eax, result
    xor edx, edx      ; Zero out edx to prevent overflow
    idiv ebx
    mov result, eax
    jmp DISPLAY_RESULT

FACTORIAL:
    call GET_First_Num_Fact
    mov num1 , eax
    call ComputeFactorial
    mov result, eax
    jmp DISPLAY_RESULT

EXPONENTIATION:
    call GET_First_Num
    call GET_SECOND_NUMBER
    mov eax, num1
    mov ecx, num2
    call Power
    mov result, eax
    jmp DISPLAY_RESULT

MODULUS:
    call GET_First_Num
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
    mov result , eax
    jno l1
    shl eax , 16
    shrd eax , edx , 16
    mov result , eax
    
    l1:
    mov eax, result
    call WriteInt
    invoke sleep , 1000
    call crlf
    call waitmsg
    jmp op_nxt

END_PROGRAM:
    Invoke sleep , 300
    call clrscr
    mov edx , offset exitingmsg
    call writestring
    call crlf
    call WaitMsg

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