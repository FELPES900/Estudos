#INCLUDE "TOTVS.CH"

/*
Class da lanchonete
    Propriedade
        mesa
        talheres
        cardapio -> filho da classe cardapio
    metod:
        arrumar mesa
        agendar a mesa
        colocar talher na mesa
        tirar a mesa
        cardapio do dia
*/

Function u_MinhaLanchonete()
	local oLanchonete    := Nil as Object
	Local cMesaEscolhida := ""  as Character
	Local nOpc := 1             as Numeric // 1 - Verifica, 2 - Agenda

	oLanchonete := Lanchonete():new()
	oLanchonete:arrumarMesa(cMesaEscolhida,nOpc)
Return nil

	CLASS LANCHONETE FROM LONGCLASSNAME
		DATA aMesa      as Array
		DATA cTralheres as Character
		DATA aCardapio  as Array

		METHOD new() CONSTRUCTOR
		METHOD arrumarMesa()
		METHOD agendarMesa()
		METHOD talherNaMesa()
		METHOD tirarMesa()
		METHOD cardapioDoDia()
	ENDCLASS

Method new() Class Lanchonete
	self:aMesa      := {{"1",.T.},{"2",.F.},{"3",.T.},{"4",.T.}}
	self:cTralheres := ""
	self:aCardapio  := {"lanche","refri","cachaca"}
Return

Method arrumarMesa(cMesaEscolhida, nOpc) Class Lanchonete

	Local lRet := .F. as Logical

	If (self:agendarMesa(cMesaEscolhida,nOpc))

	Endif

Return lRet

Method agendarMesa(cMesaEscolhida,nOpc) Class Lanchonete

	Local lRet := .F. as Logicals

	if (AScan(self:aMesa,{|x| lRet := Iif(x[1] == cMesaEscolhida,x[02],.F.)})) .and. nOpc == 1
		ConOut("Mesa Disponivel " + cMesaEscolhida)
	elseif self:aMesa[aScan(self:aMesa,{|x| x[1] == cMesaEscolhida})][02] := .F. .and. nOpc ==  2
		ConOut("Mesa Disponivel " + cMesaEscolhida)
		aEval(self:aMesa,{|y|{|x| x[1] == cMesaEscolhida}, y[02] := .F.})
		lRet := .T.
	endif

Return lRet

/*
Class do cardapio
    propriedade:
        ingredientes
        acompanhamento
    method:
        ingredientes do prato
        acompanhamento do prato
*/
