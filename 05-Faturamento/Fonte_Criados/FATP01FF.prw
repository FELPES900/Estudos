#INCLUDE "TOTVS.CH"

Function U_FATP01FF(aBodyDA1,aCampoDA1)

	Local aDA1 := {}
	Local nX := 0
	Local cMessage := ""
	Local oModel := Nil
	Local oModDA1 := Nil

	// Chamando a model da tabela de preco
	oModel := FWLoadModel("OMSA010")

	// Setando qual o tipo de operação
	oModel:SetOperation(3)

	// Ativando a model
	oModel:Activate()

	// Chamando o item da model de tabela de preco
	oModDA1 := oModel:GetModel( "DA1DETAIL" )

	// Pegando todos os campos da DA1
	aDA1 := FWSX3Util():GetAllFields( "DA1" , .T. )

	// Selecionando a tabela de preco
	DBSelectArea("DA0")

	// Indicado qual o indice vai ser usado
	DA0->(dbSetOrder(1))

	For nX := 1 to Len(aBodyDA1)
		IIF(aBodyDA1[nX] $ "Ativo" ,jBody["tabela_preco"]["Ativo"] := "1",)
		IIF(aBodyDA1[nX] $ "Preco_Venda" ,(aBodyDA1[nX] := "Preco Venda"),)
		IIF(aBodyDA1[nX] $ "Tipo_Operac" ,(jBody["tabela_preco"]["Tipo_Operac"] := TipoOperador(jBody["tabela_preco"]["Tipo_Operac"]),aBodyDA1[nX] := "Tipo Operac."),)
		IIF(aBodyDA1[nX] $ "Tipo_Preco" ,(jBody["tabela_preco"]["Tipo_Preco"] := Tipo(jBody["tabela_preco"]["Tipo_Preco"]), aBodyDA1[nX] := "Tipo Preco"),)
	Next

	cTituloDA1 := Arrtokstr(aBodyDA1)

	// Pocisiona no registro
	IF DA0->(DbSeek(xFilial("DA0") + jBody["tabela_preco"]["tabela_preco"]))

		// Chamando o item da model de tabela de preco
		oModDA1 := oModel:GetModel( "DA1DETAIL" )

		// Adicionando um novo item
		oModDA1:AddLine()

		For nX := 1 to Len(aDA1)
			If ALLTRIM(GetSX3Cache(aDA1[nX], 'X3_TITULO')) $ cTituloDA1
				nPosFild := aScan(aBodyDA1, ALLTRIM(GetSX3Cache(aDA1[nX], 'X3_TITULO')))
				oModDA1:SetValue(Alltrim(GetSX3Cache(aDA1[nX], 'X3_CAMPO')),jBody["tabela_preco"][aCampoDA1[nPosFild]])
			EndIf
		Next

		oRest:setStatusCode(200)
		jResponse['Registro'] := "Produto registrado com sucesso e gravado na tabela de preco"

		//Se conseguir validar as informações
		If oModel:VldData() .And. oModel:CommitData()

			//Tenta realizar o Commit
			lOk := .T.
			cMessage := "OK"

		Else //Se não conseguir validar as informações, altera a variável para false
			lOk := .F.
		EndIf

		//Se não deu certo a inclusão, mostra a mensagem de erro
		If ! lOk
			//Busca o Erro do Modelo de Dados
			aErro := oModel:GetErrorMessage()
			//Monta o Texto que será mostrado na tela
			cMessage :=	"Mensagem do erro: "   + " [" + cValToChar(aErro[06]) + "] " + "  Mensagem da solução: "+ "[" + cValToChar(aErro[07]) + "]"
		EndIf

		//Desativa o modelo de dados
		oModel:DeActivate()

	ENDIF

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
