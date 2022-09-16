#include "protheus.ch"

/*
+===========================================+
| Programa: Tipos de Variaveis              |
| Autor : Felipe Fraga de Assis             |
| Data : 16 de setembro de 2022             |
+===========================================+
*/

// A variavel do tipo Local so funciona na "User function" que foi declarada
// então ela so e visivel somente nesse codigo

User Function Pai()
    Local cVarNome := "Paulo"
    conOut(cVarNome)
    Filho()
Return
Static Function Filho()
    Local cVarNome := "Henrique"
    conOut(cVarNome)
Return
