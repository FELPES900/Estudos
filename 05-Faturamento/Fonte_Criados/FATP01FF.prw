#INCLUDE "TOTVS.CH"

Function U_FATP01FF()

	Local aDA1 := {}
	Local nX := 0 as Numeric

	aDA1 := FWSX3Util():GetAllFields( "DA1" , .T. )

	For nX := 1 to Len(aBodyDA1)
		// Segundo Json
		IIF(aBodyDA1[nX] $ "tabela_preco",cPedido      := jBody["tabela_preco"]["tabela_preco"]   ,)
		IIF(aBodyDA1[nX] $ "Tipo_Operac" ,(jBody["tabela_preco"]["Tipo_Operac"] := "1",aBodyDA1[nX] := "Tipo Operac.")            			  ,)
		IIF(aBodyDA1[nX] $ "Preco_Venda" ,(aBodyDA1[nX] := "Preco Venda"),)
		IIF(aBodyDA1[nX] $ "Tipo_Preco"  ,(jBody["tabela_preco"]["Tipo_Preco"]  := "1", aBodyDA1[nX] := "Tipo Preco"),)
		IIF(aBodyDA1[nX] $ "Ativo"  ,jBody["tabela_preco"]["Ativo"]  := "1",)
	Next

	cTituloDA1 := Arrtokstr(aBodyDA1)

	// Resetando o valor
	nX := 0

	// Gerando os campos da tabela de itens do pedido de venda
	aadd(aDadosDA1,{})
	For nX := 1 to Len(aDA1)
		If ALLTRIM(GetSX3Cache(aDA1[nX], 'X3_TITULO')) $ cTituloDA1
			nPosFild := aScan(aBodyDA1, ALLTRIM(GetSX3Cache(aDA1[nX], 'X3_TITULO')))
			aadd(aDadosDA1[1], {Alltrim(GetSX3Cache(aDA1[nX], 'X3_CAMPO')),jBody["tabela_preco"][aCampoDA1[nPosFild]], Nil})
		EndIf
	Next

	// Adicionando novo item na tabela preco
	aadd(aDadosDA1[1],{"DA1_ITEM",novoitem(cPedido),Nil})
	aadd(aDadosDA1[1],{"DA1_CODPRO",jBody["produto"]["Codigo"],Nil})
	aadd(aDadosDA1[1],{"DA1_TPOPER","4",Nil})

	// Passando uma tabela de preço ja existente
	aadd(aDadosDA0, {"DA0_CODTAB",cPedido, Nil})

	// Pocisiona no registro
	if DA0->(MsSeek(xFilial("DA0") + cPedido))

		IF DA0->(DbSeek(xFilial("DA0") + cPedido))

			oRest:setStatusCode(200)
			jResponse['Registro'] := "Produto registrado com sucesso e gravado na tabela de preco"

		ENDIF
	endif

Return


/*/{Protheus.doc} novoitem
Retorna  o novo codigo que sera gravada na
tabela DA1
@type function
@version 12..2210
@author felip
@since 28/06/2023
@param cPedido, character, param
@return variant, return_Character
/*/
Static function novoitem(cPedido)

	Local cAlias      := ""  as Character
	Local cQuery      := ""  as Character
	Local oQuery      := Nil as Object

	// Criando um novo Alias
	cAlias := GetNextAlias()

	// Query que será executada
	cQuery := "SELECT MAX(DA1_ITEM) DA1_ITEM FROM DA1990 DA1 WHERE DA1_FILIAL = ''  AND	DA1_CODTAB = ? AND D_E_L_E_T_  <> '*'"

	// Construtor da carga
	oQuery := FWPreparedStatement():New(cQuery)

	//Atribuindo as informações
	oQuery:SetString(1, cPedido)

	// Retorna a query com os parâmetros já tratados e substituídos
	cQuery := oQuery:GetFixQuery()

	// Abre um alias com a query informada
	cAlias := MPSysOpenQuery(cQuery)

	// Atribuindo a informação para adicionar o novo item
	cValItem := SOMA1((cAlias)->DA1_ITEM)

	cValItem := cValToChar(cValItem)

Return cValItem
