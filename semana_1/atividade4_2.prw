#include 'TOTVS.ch'

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

User Function Pai()
    Filho()
    If Type("cNome") == "C"
        conOut(cNome)
    Else
        conOut("Variável não definida")
    EndIf
Return

Static Function Filho()
    Private cNome := "Paulo"
    Neto()
    conOut("Filho")
    conOut(cNome)
Return

Static Function Neto()
    conOut("Neto")
    If Type("cNome") == "C"
        conOut(cNome)
    EndIf
Return
