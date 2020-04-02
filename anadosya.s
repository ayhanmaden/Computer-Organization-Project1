	AREA ornek,CODE,READONLY
boyut EQU 12	
	ENTRY
	;Dizi içerisindeki en büyük elemani bulan ARM assembly programini yaziniz.
	;Dizinin baslangic R6
	LDR r6,=dizi
	;Dizinin boyutu R7
	LDR r7,=boyut
	;en buyuk R3
	LDR r3,[r6]  ; dizinin ilk elemani en buyuk
	MOV r1,#0; dizinin indisi
	
bas	ADD r1,R1,#4
	LDR r4,[r6,r1]; Bir sonraki elemani r4
	cmp r3,r4
	BGT islem
	MOV r3,r4

islem	sub r7,r7,#1
	cmp r7,#0
	BNE bas
	
	
	;int[] count = new int[max + 1]; 
    ; for
    ;	(int i = 0; 
	; i < max; 
	;  ++i)
    ;	{
    ;  count[i] = 0;
    ;}	 
      MOV r4,#0 ; i 
	  MOV R5,#0 ; DIZI ICIN
	  MOV R8,#0
	  ; max  r3
	  ;0x40000000, 0x47FFFFFF
	  ldr r2,=0x40000000
forcount 
	CMP R4,R3  ; i < max
	BGT FINISH_FOR_COUNT
	STR R8,[R2,R5]
	ADD R5,R5,#4
	ADD R4,R4,#1
	B forcount
FINISH_FOR_COUNT	
dizi DCD 3 ,0 ,2 ,2 ,0 ,0 ,4 ,5 ,3 ,3 ,2, 2 ,4
	END