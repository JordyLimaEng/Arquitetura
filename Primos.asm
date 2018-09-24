;UNIVERSIDADE FEDERAL DA PARAÍBA
;CURSO: ENGENHARIA DA COMPUTAÇÃO
;DISCIPLINA: ARQUITETURA DE COMPUTADORES
;PROFESSOR: EWERTON MONTEIRO SALVADOR
;EQUIPE: JÉSSICA LANA RICARDO DA SILVA BRAGA - 20160142657
;        JORDY ALLYSON DE SOUSA LIMA         - 11426758

.386 

.model flat,stdcall 

option casemap:none 

include \masm32\include\windows.inc 
include \masm32\include\kernel32.inc 
include \masm32\include\masm32.inc 
includelib \masm32\lib\kernel32.lib  
includelib \masm32\lib\masm32.lib  

.data
msgSaida1 db "Digite um numero: ",0h
msgSaida2 db "Os primos sao: 2    "

consoleInHandle dword ?
consoleOutHandle dword ?
stringEntrada db 5 dup(?)
Primo db 5 dup(?)
entradaConvertida db 5 dup(?)
readCount dword ?
writeCount dword ?
num dword ?

_x dword 2
_eprimo dword ?
_aux dword ?

.code 
start: 

invoke GetStdHandle, STD_OUTPUT_HANDLE
mov consoleOutHandle, eax
invoke WriteConsole, consoleOutHandle, addr msgSaida1, sizeof msgSaida1, addr writeCount, NULL

invoke GetStdHandle, STD_INPUT_HANDLE

;Neste exemplo utilizei a funcao ReadConsole sem o invoke, mas poderia tranquilamente ter utilizado o invoke
mov consoleInHandle, eax
push 0 ; apontador para estrutura CONSOLE_READCONSOLE_CONTROL para especificar caracter de termino
push offset readCount ; numero de caracteres efetivamente lidos
push sizeof stringEntrada ; numero de caracteres a serem lidos no maximo
push offset stringEntrada ; endereco de memoria onde devera comecar a gravacao da string
push consoleInHandle ; handle de entrada da console
call ReadConsole

mov esi, offset stringEntrada
prox:
     mov al, [esi]
     inc esi
     cmp al, 48 ; Menor que ASCII 48
     jl  feito
     cmp al, 58 ; Menor que ASCII 58
     jl  prox
feito:
     dec esi
     xor al, al
     mov [esi], al

invoke atodw, addr stringEntrada
mov num, eax
invoke WriteConsole, consoleOutHandle, addr msgSaida2, sizeof msgSaida2, addr writeCount, NULL

FOR1:
    inc _x
    mov eax,num
    cmp _x,eax
    jg FIM
    mov _eprimo,1
    mov _aux,2

FOR2:
    mov eax,_x
    cmp _aux,eax
    je _IF
    mov edx,0
    mov eax,_x
    mov ebx,_aux
    div ebx
    cmp edx,0
    je FOR1
    mov _eprimo,0
    inc _aux
    jmp FOR2

_IF:
    cmp _eprimo,1
    je FOR1

invoke dwtoa, _x, addr Primo
invoke WriteConsole, consoleOutHandle, addr Primo, sizeof Primo, addr writeCount, NULL
jmp FOR1

FIM:
    invoke ExitProcess, 0

end start