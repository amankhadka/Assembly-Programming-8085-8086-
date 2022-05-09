;######################################################
;# 8086 Program to find all the  Prime numbers less   #
;#             than given number                      #
;#           Author: Er. Sitaram Khadka               #
;#             in help with kingspp                   #
;###################################################### 

; Limitation:
; This program only finds prime number up to 255 (decimal), as 8-bit register can hold maximum of 255 value
; But still values greater than 99 will be not as predicted as, only two digit BCD is managed yet.


;NUM is assigned to the Number to Find all the primes less than
;AL is used as the default no
;BL is used as Dividing Variable. It is Incremented in each loop
;CL is used to hold number to check if it is prime

; Dearation Part
.MODEL SMALL
.DATA
MSG DB "The Prime numbers less than $" 
MSG1 DB "Enter the number up to which you need to find PRIME numbers (Less than 99): $"
NUM DB 127      ;Enter the required no. up to which you need to find all the prime numbers.
.CODE   

                                                   
;This macro prints space " " 
SPACE MACRO
    MOV DL,32                             
    MOV AH,2      ; Used to print a string
    INT 21H  
ENDM
               
;This Macro converts 8-bit value in AL to corresponding BCD
; and finally to ASCII then displays it with space                
BCD_Display MACRO 
    ;Decimal BCD adjust the hex value in AL 
    MOV AH,00H  ; To avoid divide overflow
    MOV CH,0AH
    DIV CH      ; The two digit value aquired: Tens value in AL and ones in AH
                         
    ;Adjust the character ASCII value for BCD data (we know ASCII Hex value for numbers are from 30H)
    ADD AX,3030H              
    
    MOV CH,AH   ; Save Ones value for display in next step
    
    MOV DL,AL   ; prepare to display tens                        
    MOV AH,2    ; Used to print a value
    INT 21H       
        
    MOV DL,CH   ;prepare to display ones
    INT 21H          
    SPACE       ;print space 
ENDM 
       
; This Macro defines new line as "\n\r" to display data in next starting of the line       
New_line MACRO
    MOV DL,10     ; ASCII value for Line feed "\n"                       
    MOV AH,2      ; Used to print a charecter
    INT 21H 
    MOV DL,13     ; ASCII value for Carriage return "\r"                        
    INT 21H  
ENDM  

; This Macro inputs number up to 255 from user and converts it to equivalent hex in AL
Input_no MACRO
    MOV CH,10
    MOV AH,01                                         
    INT 21H       ; Input first digit of a number
    SUB AL,48     ; Convert input number into HEX value
    MUL CH        ; Multiply first digit with 10 to make it tens
    MOV CL,AL
    MOV AH,01
    INT 21H       ; Input second digit of a number
    SUB AL,48     ; Convert input number into HEX value
    ADD AL,CL
ENDM    

; Main Program starts from here

START: MOV AX,@DATA
MOV DS,AX   

LEA DX,MSG1      ; Display message 
MOV AH,09H      ; Used to print a string
INT 21H    
        
Input_no
MOV NUM,AL      ; Input number and save it to NUM for prime calculations
New_line                
        
LEA DX,MSG      ; Display message 
MOV AH,09H      ; Used to print a string
INT 21H 

MOV AL,NUM      ; Display the number up to which prime numbers are required to find
BCD_Display

New_line        ; Go to new line

MOV AL,02H      ; First display 02 as first prime number
BCD_Display     
          
MOV CL, 3       ; Start to find prime number from 03

Check:MOV BL,02H; Start checking with division from 2

;Loop to check for Prime No
Prime_check:
MOV AL,CL                                        
MOV DX,0000H    ; To avoid Divide overflow error
MOV AH,00H      ; To avoid Divide overflow error
DIV BL     
CMP AH,00H      ; Remainder is compared with 00H (AH)
JE FALSE
INC BL          ; Increment BL
CMP BL,CL       ; Run the loop until BL matches Number. i.e, Run loop x no of times, where x is the Number given
JNE Prime_check ; Jump to check again with incremented value of BL

;Display the Prime number in BCD
MOV AL,CL
BCD_Display


FALSE: INC CL   ; Define next number to check
CMP CL,NUM      ; Check if number as defined has reached.                            
JLE Check

EXIT:
MOV AH,4CH
INT 21H
END START
