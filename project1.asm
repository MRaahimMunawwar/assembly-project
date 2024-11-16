INCLUDE Irvine32.inc

.data
    prompt1 BYTE "Enter first number (n): ", 0
    prompt2 BYTE "Enter second number (r): ", 0
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
    DivByZero BYTE "Error: Division by zero!", 0
    InvalidOperation BYTE "Error: Invalid operation!", 0
    InvalidInput BYTE "Error: Invalid input!", 0
    resultStr BYTE "The result is: ", 0
    num1 SDWORD ?
    num2 SDWORD ?
    result SDWORD 10000 DUP(?)
    op DWORD ?

.code
main PROC
    ; Read first number
    mov edx, OFFSET prompt1
    call WriteString
    call ReadInt
    mov num1, eax

    ; Display menu options
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
    jmp INVALID_OP

ADDITION:
    call GET_SECOND_NUMBER
    add eax, num1
    mov result, eax
    jmp DISPLAY_RESULT

SUBTRACTION:
    call GET_SECOND_NUMBER
    mov eax, num1
    sub eax, num2
    mov result, eax
    jmp DISPLAY_RESULT

MULTIPLICATION:
    call GET_SECOND_NUMBER
    mov eax, num1
    imul eax, num2
    mov result, eax
    jmp DISPLAY_RESULT

DIVISION:
    call GET_SECOND_NUMBER
    cmp num2, 0
    je DIV_BY_ZERO
    mov eax, num1
    xor edx, edx
    idiv num2
    mov result, eax
    jmp DISPLAY_RESULT

SQUARE:
    mov eax, num1
    imul eax, num1
    mov result, eax
    jmp DISPLAY_RESULT

SQRT:
    call SQRTP
    jmp DISPLAY_RESULT

PERMUTATION:
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
    mov eax, num1
    call ComputeFactorial
    mov result, eax
    jmp DISPLAY_RESULT

EXPONENTIATION:
    call GET_SECOND_NUMBER
    mov eax, num1
    mov ecx, num2
    call Power
    mov result, eax
    jmp DISPLAY_RESULT

MODULUS:
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
    jmp END_PROGRAM

DIV_BY_ZERO:
    mov edx, OFFSET DivByZero
    call WriteString
    jmp END_PROGRAM

INVALID_INPUT:
    mov edx, OFFSET InvalidInput
    call WriteString
    jmp END_PROGRAM

DISPLAY_RESULT:
    mov edx, OFFSET resultStr
    call WriteString
    mov eax, result
    call WriteInt
    jmp END_PROGRAM

GET_SECOND_NUMBER PROC
    mov edx, OFFSET prompt2
    call WriteString
    call ReadInt
    mov num2, eax
    ret
GET_SECOND_NUMBER ENDP

ComputeFactorial PROC


    mov ecx, eax
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

SQRTP PROC
    finit
    fild num1
    fsqrt
    fistp result
    ret
SQRTP ENDP

END_PROGRAM:
    call Crlf
    call WaitMsg
    exit
main ENDP

END main