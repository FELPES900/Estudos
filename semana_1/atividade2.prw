#include "totvs.ch"
/*
+===========================================+
| Programa: Cálculo do Fatorial             |
| Autor : Felipe Fraga de Assis             |
| Data : 14 de setembro de 2022             |
+===========================================+
*/
User Function ativid2()
Local nCnt
Local nResultado := 1 // Resultado do fatorial
Local nFator := 5 // Número para o cálculo
// Cálculo o valor fatorial
For nCnt := nFator To 1 Step -1
nResultado *= nCnt
Next
// Exibe o resultado na tela, através da função alert
MsgAlert("O fatorial de " + cValToChar(nFator) + "é" + cValToChar(nResultado))
// Termina o programa
Return( NIL )
