#include "totvs.ch"

/*
+===========================================+
| Programa: Tipos de Variaveis              |
| Autor : Felipe Fraga de Assis             |
| Data : 16 de setembro de 2022             |
+===========================================+
*/

// A variavel do tipo static quando executada se ela for declarada
// dentro das function ela ira funcionar como uma variavel do tipo 
// local mas se fir declarada fora ela sera enxergada pelo o codigo
// todo mas sempre verificar e resetar seu valor apos a sua execução
// em uma função

Static nVar := 0

User Function Pai_3()
    nVar += 10
    conOut("Pai")
    conOut(nVar)
    Filho_3()

    nVar := 0
Return

Static Function Filho_3()
    nVar += 10
    conOut("Filho")
    conOut(nVar)
    Neto_3()
Return

Static Function Neto_3()
    nVar += 10
    conOut("Neto")
    conOut(nVar)
Return
