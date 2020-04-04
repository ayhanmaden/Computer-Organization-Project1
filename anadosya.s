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

    ; count array   ldr r2,=0x40000000
	; array         LDR r6,=dizi
    ; for (int i = 0; 
	;i < size; 
	; i++) {
	; k=array[i];
    ; count[k]++;
    ;}
	 MOV r4,#0      ; int i = 0
    MOV r5,#0        ; array illermesi icin
    MOV r8,#0       ; k      
	MOV r10,#4       ; 4 	
	LDR r7,=boyut    ; array size 

foruc
    CMP  R4,r7
	BGT SON_FOR_uc
	LDR r8,[r6,r5] ;  k=array[i];  = 2
	MUL r8,r10,r8
 	LDR r9,[r2,r8] ; count[k]++;  count[0]++; 1 => 2  
	ADD r9,r9,#1   ; 
	STR R9,[R2,R8]  ; R2[R8]=R9
	ADD R5,R5,#4   ;array icin
	ADD R4,R4,#1
	B foruc
SON_FOR_uc	
    
	;for (
	;int i = 1; 
	;i <= max;
     ;i++) {
	 ; k= count[i - 1]
	 ;  b=count[i]
    ;  count[i] = b+k;
    ;}
	MOV r4,#1      ; int i = 1
    MOV r5,#4        ; array illermesi icin
    MOV r8,#0       ; k      
	MOV r9,#0       ; b
	; max = r3
	; count array   ldr r2,=0x40000000
	
fordort
    CMP  R4,r3
	BGT SON_FOR_dort
	MOV R11,R5             
	LDR R9,[R2,R5]        ; b
	SUB R5,R5,#4          ;i - 1
	LDR R8,[R2,R5]        ; k= count[i - 1]
	ADD R10,R8,R9         ; b+k
	STR R10,[R2,R11]      ;count[i] r2[r11]=r10
	ADD R11,R11,#4        ;
	MOV R5,R11            ;r5 = r11
	ADD R4,R4,#1
	B   fordort
SON_FOR_dort	
  
  ;int[] output = new int[12];
  ;for (
  ;int i = size - 1; 
  ; i >= 0; 
  ;i--) {
  ;   a= array[i]
  ;   b= count[a] - 1
  ;   output[b] = a;
  ;   count[a]--;
  ;}
  ; 0X80000000,0X800000FF
  LDR R1,=0X80000000 ; OUTPUT ARRAY
  LDR r7,=boyut      ;size
  MOV r4,r7          ; int i = size - 1
  MOV r5,#48          ; array illermesi icin
  MOV r8,#0          ; a    
  MOV r9,#0          ; b
 ;LDR r6,=dizi
 ; count array   ldr r2,=0x40000000

forson
    CMP r4,#0       ;i >= 0
    BGE son
    LDR R8,[R6,R5] ;a= array[i] R8=R6[R5]
	LDR R9,[R2,r8] ; b = count[a]
	SUB R9,R9,#4   ; b = b - 1
	
son	
dizi DCD 3 ,0 ,2 ,2 ,0 ,0 ,4 ,5  ,3 ,3 ,2, 2 ,4
	END
