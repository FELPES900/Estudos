#include "totvs.ch"

/*
+===========================================+
| Programa: Tipos de Variaveis              |
| Autor : Felipe Fraga de Assis             |
| Data : 16 de setembro de 2022             |
+===========================================+
*/

user function ativid5()
    Local cRetorno := ""

    cRetorno := FWInputBox("Linguagem de programação usada no Protheus?", "")

    if(UPPER(cRetorno) == "ADVPL")

        MsgInfo("Parabéns! Você acertou! **" + cRetorno + "**", "CORRETO")
    Else
        MsgAlert("Não foi desta vez :(", "SAIR")
    EndIf

return
