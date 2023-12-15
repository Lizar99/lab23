;инициализация регистров
MOV R1, #0B		;для массива
MOV R2, #0B		;для положительных
MOV R3, #0B		;для отрицательных
;ввод массива
MOV 80, #11111110B ;-1
MOV 81, #00000010B ;2
MOV 82, #00000110B ;6
MOV 83, #00000111B ;7
MOV 84, #11111100B ;-3
MOV 85, #00000100B ;4
MOV 86, #11111000B ;-7
MOV 87, #00001000B ;8
MOV 88, #00001001B ;9
MOV 89, #11110101B ;-10
MOV 90, #11111010B ;-5
MOV 91, #00000011B ;3

;словарь индикаторов
MOV 96, #11000000b ;0
MOV 97, #11111001b ;1


MOV R1, #80

main:

 	MOV A, @R1               ; Записываем элемент массива в аккумулятор
    ANL A, #10000000B		; Логическое И аккумулятора и константу (-1)
	JZ SUM_POL   ; Проверяем на отрицательное число (если аккум = 0 то переход)
	MOV A, @R1				; Записываем элемент массива в аккумулятор
	CPL A					;инверсия акк
	ADD A, R3                ; Складываем значение акк и регистра 3
	MOV R3, A                ; Записываем сумму из аккумулятора в 3 регистр
	SJMP CLEAN_CHECK 		 ; Переход

SUM_POL:
    MOV A, @R1				; Записываем элемент массива в аккумулято
	ADD A, R2                ; Складываем значение акк и регистра 2
    MOV R2, A				 ; Записывается сумма во 2 регистр из аккумулятора
    SJMP CLEAN_CHECK		 ; Переход

BIT_CHECK:					 ; Проверяем 7-й бит суммы отрицательных чисел
    MOV A, R3
	CPL A            		;инверсия акк   
	ANL A, #01000000B         ; Убираем все биты, кроме 7
    JZ BIT_ZERO            ; Переходим если 7-й бит 0
    MOV R1, #1B
	MOV R5, #11B
	call dictionary
	MOV R1, #0B
	MOV R5, #10B
	call dictionary
	MOV R1, #0B
	MOV R5, #1B
	call dictionary
	MOV R1, #0B
	MOV R5, #0B
	call dictionary
	SJMP END

BIT_ZERO:
    MOV R1, #0B
	MOV R5, #11B
	call dictionary
	MOV R1, #0B
	MOV R5, #10B
	call dictionary
	MOV R1, #0B
	MOV R5, #1B
	call dictionary
	MOV R1, #1B
	MOV R5, #0B
	call dictionary
	SJMP END

CLEAN_CHECK:
    INC R1                   ; делаем +1 к номеру ячейки   
	clr A					; сброс аккумулятора
	CJNE R1, #92, main    ; Переходим к следующей итерации, если не прошли все элементы
	JMP BIT_CHECK

dictionary:
	MOV A, R1
	ADD A,#96
	MOV R1,A
	call DISP
ret

DISP:
	SETB P0.7 ; активировать дешифратор
	CJNE R5, #11B, D2
	SETB P3.3 ; |
	SETB P3.4 ; | активировать DISP3
	MOV P1, @R1  ; записать в порт код цифры «0»
	MOV P1, #0FFH ; очистить порт
D2:
	CJNE R5, #10B, D1
	CLR P3.3 ; | активировать DISP2
	SETB P3.4
	MOV P1, @R1 ; записать в порт код цифры «0»
	MOV P1, #0FFH ; очистить порт
D1:
	CJNE R5, #1B, D0
	CLR P3.4 ; |
	SETB P3.3 ; | активировать DISP1
	MOV P1, @R1 ; записать в порт код цифры «0»
	MOV P1, #0FFh ; очистить порт
D0:
	CJNE R5, #0B, out
	CLR P3.4
	CLR P3.3 ; | активировать DISP0
	MOV P1, @R1 ; записать в порт код цифры «1»
	MOV P1, #0FFH ; очистить порт
out:
ret
 
END:
