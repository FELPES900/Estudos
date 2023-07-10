#include "totvs.ch"

/*
+===========================================+
| Programa: Tipos de Variaveis              |
| Autor : Felipe Fraga de Assis             |
| Data : 16 de setembro de 2022             |
+===========================================+
*/

// A variavel do tipo private ela e enxergada pelo o codigo todo
// ou seja mesmo ela sendo declarada fora da function principla
// o codigo em si consiguira enchegar a variavel senao nao a enxergara

User Function Pai_2()
    Filho_2()
    If Type("cNome") == "C"
        conOut(cNome)
    Else
        conOut("Variável não definida")
    EndIf
Return

Static Function Filho_2()
    Private cNome := "Paulo"
    Neto_2()
    conOut("Filho")
    conOut(cNome)
Return

Static Function Neto_2()
    conOut("Neto")
    If Type("cNome") == "C"
        conOut(cNome)
    EndIf
Return
