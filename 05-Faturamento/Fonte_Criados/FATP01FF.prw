#INCLUDE "TOTVS.CH"

Function U_FATP01FF(aBodyDA1,aCampoDA1)

	Local aDA1 := {}
	Local nX := 0
	Local cMessage := ""

	// Pegando todos os campos da DA1
	aDA1 := FWSX3Util():GetAllFields( "DA1" , .T. )

	For nX := 1 to Len(aBodyDA1)
		IIF(aBodyDA1[nX] $ "Ativo" ,jBody["tabela_preco"]["Ativo"] := "1",)
		IIF(aBodyDA1[nX] $ "Preco_Venda" ,(aBodyDA1[nX] := "Preco Venda"),)
		IIF(aBodyDA1[nX] $ "Tipo_Operac" ,(jBody["tabela_preco"]["Tipo_Operac"] := TipoOperador(jBody["tabela_preco"]["Tipo_Operac"]),aBodyDA1[nX] := "Tipo Operac."),)
		IIF(aBodyDA1[nX] $ "Tipo_Preco" ,(jBody["tabela_preco"]["Tipo_Preco"] := Tipo(jBody["tabela_preco"]["Tipo_Preco"]), aBodyDA1[nX] := "Tipo Preco"),)
	Next

	cTituloDA1 := Arrtokstr(aBodyDA1)

	// Gerando os campos da tabela de itens do pedido de venda
	aadd(aDadosDA1,{})
	For nX := 1 to Len(aDA1)
		If ALLTRIM(GetSX3Cache(aDA1[nX], 'X3_TITULO')) $ cTituloDA1
			nPosFild := aScan(aBodyDA1, ALLTRIM(GetSX3Cache(aDA1[nX], 'X3_TITULO')))
			aadd(aDadosDA1[1], {Alltrim(GetSX3Cache(aDA1[nX], 'X3_CAMPO')),jBody["tabela_preco"][aCampoDA1[nPosFild]], Nil})
		EndIf
	Next

	// Passando uma tabela de preço ja existente
	aadd(aDadosDA0, {"DA0_CODTAB",cPedido, Nil})

	// Pocisiona no registro
	if DA0->(MsSeek(xFilial("DA0") + cPedido))

		IF DA0->(DbSeek(xFilial("DA0") + cPedido))

			oRest:setStatusCode(200)
			jResponse['Registro'] := "Produto registrado com sucesso e gravado na tabela de preco"

		ENDIF
	endif

Return cMessage


Static Function TipoOperador(Operador)

	Local cTipoOperador

	IIF(Operador == "Estadual",cTipoOperador := "1",)
	IIF(Operador == "InterEstadual",cTipoOperador := "2",)
	IIF(Operador == "Norte/Nordeste",cTipoOperador := "3",)
	IIF(Operador == "Todos",cTipoOperador := "4",)

Return cTipoOperador

Static Function Tipo(cTipo)

	Local cAtivo := ""

	IIF(cTipo == "Sim",cAtivo := "1",)
	IIF(cTipo == "Nao",cAtivo := "2",)

Return cAtivo
