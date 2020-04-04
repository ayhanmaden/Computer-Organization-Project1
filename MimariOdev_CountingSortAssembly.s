;************************************************************************************************
;   Memory Map e 0x40000000, 0x47FFFFFF ve 0X80000000,0X800000FF eklememiz gerekmektedir.
;   Odev asagida belirtilen linkteki C koduna gore derlenmistir.
;   https://www.programiz.com/dsa/counting-sort
;************************************************************************************************

	AREA ornek,CODE,READONLY
boyut EQU 12	
	ENTRY
;------------------------------------------------------------------------------------------------
;   Verilen dizimizdeki en buyuk sayiyi buluyoruz

;int max = array[0];
;  for (int i = 1; i < size; i++)
;  {
;    if (array[i] > max)
;      max = array[i];
;  }
;------------------------------------------------------------------------------------------------
	
	
    LDR r6,=dizi                ; Dizinin baslangic R6
    LDR r7,=boyut               ; Dizinin boyutu R7
    LDR r3,[r6]                 ; Dizinin ilk elemani en buyuk
    MOV r1,#0                   ; Dizinin indisi
    
bas ADD r1,R1,#4
    LDR r4,[r6,r1]              ; Bir sonraki elemani r4
    CMP r3,r4                   ; Dizinin ilk elemani ile ikinci elemani karsilastiriliyor
    BGT islem                   ; R3 buyuk ise branch yapilarak dizi boyutu 1 azaltiliyor
    MOV r3,r4                   ; R4 buyuk ise R4 un degeri R3 e ataniyor

islem   sub r7,r7,#1            ; Dizi boyutu azaltiliyor
    CMP r7,#0
    BNE bas
;------------------------------------------------------------------------------------------------
;   Max sayimizin boyutu kadar yeni bir dizi olusturduk ve dizinin tüm elemanlarina 0 degerini atadik

;int count[10];
;  for (int i = 0; i <= max; ++i)
;  {
;    count[i] = 0;
;  }
;------------------------------------------------------------------------------------------------

      MOV r4,#0                 ; i=0
      MOV R5,#0                 ; DIZI ICIN
      MOV R8,#0
      
      ldr r2,=0x40000000        ;0x40000000, 0x47FFFFFF
FORBIR
    CMP R4,R3                   ; i < max    R3 max sayiyi belirtmektedir
    BGT FINISH_FORBIR           ; R4 Max sayidan buyuk oldugunda branch yapacak
    STR R8,[R2,R5]              ; Dizi elemanlarina 0 degeri ataniyor
    ADD R5,R5,#4                ; Dizimin decimal sayilardan olustugundan 4 er arttiriyoruz
    ADD R4,R4,#1                ; i degiskenimizi 1 arttiriyoruz
    B   FORBIR
FINISH_FORBIR


;------------------------------------------------------------------------------------------------
;   Verilen dizideki sayilarin kac kez tekrarlandigini buluyoruz ve
;       yeni olusturdugumuz diziye arttirarak yazdiriyoruz
;for (int i = 0; i < size; i++)
;  {
;    int k=array[i];
;    count[k]++;
;  }
;
; count array   ldr r2,=0x40000000
; array         LDR r6,=dizi
;------------------------------------------------------------------------------------------------

    MOV R4,#0                   ; int i = 0
    MOV R5,#0                   ; array ilerlemesi icin
    MOV R8,#0                   ; k
    MOV R10,#4                  ; 4
    LDR R7,=boyut               ; array size

FORIKI
    CMP R4,R7                   ; R4 ile R7 yi karsilastiriyoruz
    BGT FINISH_FORIKI           ; R4 dizi boyutuna ulastiginda branch yapiyoruz
    LDR R8,[R6,R5]              ; Verilen dizideki elemanlari sirayla R8 e aliyoruz.    k=array[i];
    MUL R8,R10,R8               ; R8 sayisini 4 ile carpiyoruz ve memory adresini buluyoruz
    LDR R9,[R2,R8]              ; Yeni dizinin memory adresini R8 kadar arttırıp R9 a yaziyoruz
    ADD R9,R9,#1                ; Yeni dizide sayinin degerini 1 arttiriyoruz.        count[k]++;
    STR R9,[R2,R8]              ; R2 yi R8 kadar arttirdiktan sonra R9 un degerini R2 memory adresine yaziyoruz
    ADD R5,R5,#4                ; Dizi indexini arttiriyoruz
    ADD R4,R4,#1                ; i degerini 1 arttiriyoruz
    B   FORIKI
FINISH_FORIKI
  

;------------------------------------------------------------------------------------------------
;   Dizi elemanlarini bir onceki indexdeki eleman ile toplayayip ayni indexe yazdiriyoruz
;for (int i = 1; i <= max; i++)
;  {
;    int k = count[i - 1]
;    int b = count[i]
;    b = b + k;
;  }
; max = R3
; count array   LDR r2,=0x40000000
;------------------------------------------------------------------------------------------------


    MOV R4,#1                   ; int i = 1
    MOV R5,#4                   ; array ilerlemesi icin
    MOV R8,#0                   ; k
    MOV R9,#0                   ; b

FORUC
    CMP R4,R3                   ; R4 ile R3 u karsilastiriyoruz
    BGT FINISH_FORUC
    MOV R11,R5                  ; R5 degerini kaybetmemek icin R11 registerine atiyoruz
    LDR R9,[R2,R5]              ; Buyuk olan index degerini R9 a aliyoruz
    SUB R5,R5,#4                ; Kucuk olan index degeri icin R5 den 4 cikariyoruz
    LDR R8,[R2,R5]              ; Kucuk olan index degerini R8 e aliyoruz
    ADD R10,R8,R9               ; Buyuk ve Kucuk index degerlerini topluyoruz ve R10 a atiyoruz
    STR R10,[R2,R11]            ; Buyuk ve kucuk indexin toplam degerini dizideki buyuk index yerine yukluyoruz
    ADD R11,R11,#4              ; R11 degerini 4 arttiriyoruz
    MOV R5,R11                  ; Dizinin bir sonraki indexe gecmesi icin dizi adresini arttiriyoruz
    ADD R4,R4,#1                ; Compare icin kullandigimiz R4 registerini arttiriyoruz
    B   FORUC
FINISH_FORUC
  

;------------------------------------------------------------------------------------------------
;   Dizi elemanlarini siralanmis sekilde yeni bir diziye atarak siralama islemini bitiriyoruz.
;int[] output = new int[12];
;for (int i = size - 1; i >= 0; i--)
;  {
;    int a= array[i]
;    int b= count[a] - 1
;    output[b] = a;
;    count[a]--;
;  }
; OUTPUT ARRAY =0X80000000,0X800000FF
; LDR R6,=dizi
; count array   LDR R2,=0x40000000
;------------------------------------------------------------------------------------------------


  LDR R1,=0X80000000            ; OUTPUT ARRAY 0X80000000,0X800000FF
  LDR R7,=boyut                 ; Ilk dizinin boyutu
  MOV R4,R7                     ; For isleminde kullanilmasi icin R7 yi R4 e atiyoruz
  MOV R5,#48                    ; Dizi boyutumuzu 4 ile carparak memory yerini buluyoruz
  MOV R8,#0                     ; a
  MOV R9,#0                     ; b
  MOV R12,#4

FORDORT
    CMP R4,#0                   ; i >= 0
    BLT FINISH_FORDORT          ; R4 0 dan kucuk oldugunda dizimiz siralanmis olacak
    LDR R8,[R6,R5]              ; a= array[i]
    MOV R11,R8                  ; R8 degerimizi R11 e atiyoruz
    MUL R11,R12,R11             ; R11 degerimizin memory adresini bulmak icin 4 degeri tasiyan R12 ile carpiyoruz
    LDR R9,[R2,R11]             ; b = count[a]
    MOV R11,#0                  ; R11 i tekrar kullanmak icin sifirliyoruz
    SUB R9,R9,#1                ; b = b - 1
    MOV R11,R9                  ; R9 degerimizi R11 e atiyoruz
    MUL R11,R12,R11             ; R11 degerimizin memory adresini bulmak icin 4 degeri tasiyan R12 ile carpiyoruz
    STR R8,[R1,R11]             ; output[b] = a;
    MOV R11,#0                  ; R11 i tekrar kullanmak icin sifirliyoruz
    MOV R11,R8                  ; R8 degerimizi R11 e atiyoruz
    MUL R11,R12,R11             ; R11 degerimizin memory adresini bulmak icin 4 degeri tasiyan R12 ile carpiyoruz
    LDR R10,[R2,R11]            ; R2 adresimizi R11 kadar arttirip R10 a atiyoruz
    SUB R10,R10,#1              ; Bir sayinin dizide kac kez gectigi bilgisini bir azaltiyoruz
    STR R10,[R2,R11]            ; R10 daki degerimizi R2 nin adresini R11 kadar arttirdiktan sonra R2 ye yaziyoruz
    MOV R11,#0                  ; R11 i tekrar kullanmak icin sifirliyoruz
    SUB R4,#1                   ; Compare icin kullandigimiz R4 registerini azaltiyoruz
    SUB R5,R5,#4                ; Dizinin indexini azaltiyoruz
    B FORDORT
FINISH_FORDORT

dizi DCD 3 ,0 ,2 ,2 ,0 ,0 ,4 ,5 ,3 ,3 ,2 ,2 ,4
    END

