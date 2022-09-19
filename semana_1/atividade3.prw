#include "totvs.ch"
/*
+===========================================+
| Programa: Atribuições a variaveis         |
| Autor : Felipe Fraga de Assis             |
| Data : 14 de setembro de 2022             |
+===========================================+
*/
User Function ativid3()

    // Tipo Array
    Local aArray := {}

    // Tipo Bloco de código
    Local bBloco := {|| .T.}

    // Tipo Caractere
    Local cCaractere := "Caractere", cMensagem := ""

    // Tipo Data
    Local dData := Date()

    // Tipo Lógico
    Local lLogico := .T.

    // Tipo Numérico
    Local nNumerico := 1024.2048

    // Tipo Objeto
    Local oObjeto := MSDialog():Create()

    // Tipo Não definido
    Local uUndefined := Nil

    cMensagem += "[" + ValType(aArray)     + "] Array"
    cMensagem += "[" + ValType(bBloco)     + "] Bloco de código"
    cMensagem += "[" + ValType(cCaractere) + "] Caractere"
    cMensagem += "[" + ValType(dData)      + "] Data"
    cMensagem += "[" + ValType(lLogico)    + "] Lógico"
    cMensagem += "[" + ValType(nNumerico)  + "] Numérico"
    cMensagem += "[" + ValType(oObjeto)    + "] Objeto"
    cMensagem += "[" + ValType(uUndefined) + "] Undefined"

    // quando estiver debugando quando jogar a variavel cMensagem
    // mostrara os tipos de variaveis nos encontramos

Return()
