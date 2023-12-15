;������������� ���������
MOV R1, #0B		;��� �������
MOV R2, #0B		;��� �������������
MOV R3, #0B		;��� �������������
;���� �������
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

;������� �����������
MOV 96, #11000000b ;0
MOV 97, #11111001b ;1


MOV R1, #80

main:

 	MOV A, @R1               ; ���������� ������� ������� � �����������
    ANL A, #10000000B		; ���������� � ������������ � ��������� (-1)
	JZ SUM_POL   ; ��������� �� ������������� ����� (���� ����� = 0 �� �������)
	MOV A, @R1				; ���������� ������� ������� � �����������
	CPL A					;�������� ���
	ADD A, R3                ; ���������� �������� ��� � �������� 3
	MOV R3, A                ; ���������� ����� �� ������������ � 3 �������
	SJMP CLEAN_CHECK 		 ; �������

SUM_POL:
    MOV A, @R1				; ���������� ������� ������� � ����������
	ADD A, R2                ; ���������� �������� ��� � �������� 2
    MOV R2, A				 ; ������������ ����� �� 2 ������� �� ������������
    SJMP CLEAN_CHECK		 ; �������

BIT_CHECK:					 ; ��������� 7-� ��� ����� ������������� �����
    MOV A, R3
	CPL A            		;�������� ���   
	ANL A, #01000000B         ; ������� ��� ����, ����� 7
    JZ BIT_ZERO            ; ��������� ���� 7-� ��� 0
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
    INC R1                   ; ������ +1 � ������ ������   
	clr A					; ����� ������������
	CJNE R1, #92, main    ; ��������� � ��������� ��������, ���� �� ������ ��� ��������
	JMP BIT_CHECK

dictionary:
	MOV A, R1
	ADD A,#96
	MOV R1,A
	call DISP
ret

DISP:
	SETB P0.7 ; ������������ ����������
	CJNE R5, #11B, D2
	SETB P3.3 ; |
	SETB P3.4 ; | ������������ DISP3
	MOV P1, @R1  ; �������� � ���� ��� ����� �0�
	MOV P1, #0FFH ; �������� ����
D2:
	CJNE R5, #10B, D1
	CLR P3.3 ; | ������������ DISP2
	SETB P3.4
	MOV P1, @R1 ; �������� � ���� ��� ����� �0�
	MOV P1, #0FFH ; �������� ����
D1:
	CJNE R5, #1B, D0
	CLR P3.4 ; |
	SETB P3.3 ; | ������������ DISP1
	MOV P1, @R1 ; �������� � ���� ��� ����� �0�
	MOV P1, #0FFh ; �������� ����
D0:
	CJNE R5, #0B, out
	CLR P3.4
	CLR P3.3 ; | ������������ DISP0
	MOV P1, @R1 ; �������� � ���� ��� ����� �1�
	MOV P1, #0FFH ; �������� ����
out:
ret
 
END:
