;######################################################################################
;#################### TRABALHO 1 - ARQUITETURA DE COMPUTADORES ########################
;ALUNOS: Jordy Allyson de Sousa Lima   (11426758)
;        Jéssica Lana Ricardo da Silva Braga (20160142657) 
;
;######################################################################################

.386 

.model flat,stdcall 

option casemap:none 

include \masm32\include\windows.inc 
include \masm32\include\kernel32.inc 
include \masm32\include\masm32.inc 
includelib \masm32\lib\kernel32.lib  
includelib \masm32\lib\masm32.lib  
include \masm32\include\msvcrt.inc
include \masm32\macros\macros.asm
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib
includelib \masm32\lib\msvcrt.lib

.data
msgSaida1 db "Digite um numero: ",0h
msgSaida2 db 0ah, "Os primos sao: 2, ",0h

consoleInHandle dword ?
consoleOutHandle dword ?
stringEntrada db 10 dup(?)
entradaConvertida db 10 dup(?)
Primo db 10 dup(?)
readCount dword ?
writeCount dword ?
num dword ?

_x dword 2
_y dword ?
_eprimo dword 0
_aux dword ?
resto dword ?


.code 
start: 

invoke GetStdHandle, STD_OUTPUT_HANDLE
mov consoleOutHandle, eax
invoke WriteConsole, consoleOutHandle, addr msgSaida1, sizeof msgSaida1, addr writeCount, NULL

invoke GetStdHandle, STD_INPUT_HANDLE  ;esperando entrada do usuário para salvar em um endereço na memória
                                       ;que é o registrador EAX
;Neste exemplo utilizei a funcao ReadConsole sem o invoke, mas poderia tranquilamente ter utilizado o invoke
mov consoleInHandle, eax
push 0                      ; apontador para estrutura CONSOLE_READCONSOLE_CONTROL para especificar caracter de termino
push offset readCount       ; numero de caracteres efetivamente lidos
push sizeof stringEntrada   ; numero de caracteres a serem lidos no maximo
push offset stringEntrada   ; endereco de memoria onde devera comecar a gravacao da string
push consoleInHandle        ; handle de entrada da console
call ReadConsole

;A partir daqui começam os calculos

mov esi, offset stringEntrada  ;mov o ponteiro da primeira letra do String para ESI
prox:
mov al, [esi]
inc esi                     ;
cmp al, 48                  ; Menor que ASCII 48
jl  feito
cmp al, 58                  ; Menor que ASCII 58
jl  prox
feito:
dec esi
xor al, al
mov [esi], al

invoke atodw, addr stringEntrada            ;Converte a string para inteiro e salva em EAX
mov num, eax

;////////////////Primos começa aqui/////////////////////

invoke WriteConsole, consoleOutHandle, addr msgSaida2, sizeof msgSaida2, addr writeCount, NULL

for1:
    inc _x
    mov eax, num
    cmp _x, eax
    je FIM  
    mov _eprimo, 1
    mov _aux, 2
for2:
    mov eax, _x
    cmp _aux, eax
    jge _if
    mov edx, 0
    mov eax, _x
    mov ebx, _aux
    div ebx
    mov resto, edx
    cmp edx, 0
    je for1
    mov _eprimo, 0
    inc _aux
    jmp for2              ;falta testar a condição de saída do for2
    
_if:
    cmp _eprimo, 1
    je for1
    
    invoke dwtoa, _x, addr Primo   ;Converte o inteiro para string
    invoke WriteConsole, consoleOutHandle, addr Primo, sizeof Primo, addr writeCount, NULL
    jmp for1
FIM:
invoke ExitProcess, 0

end start
