#INCLUDE "TOTVS.CH"

Function U_FAPD01FF(aBodySB1,aCampoSB1,aBodyDA1,aCampoDA1)

	Local oModSB1 := Nil
	Local oModel := Nil
	Local aSB1 := {}
	Local nX := 0
	Local lOk := .T.
	Private cMessage := ""
	// Chamando a model de produtos
	oModel := FWLoadModel("MATA010")

	// Setando qual o tipo de opera��o
	oModel:SetOperation(3)

	// Ativando a model
	oModel:Activate()

	// posicionando na model principal de produtos
	oModSB1 := oModel:GetModel("SB1MASTER")

	// Pega todos os campos da tabela de produtos
	aSB1 := FWSX3Util():GetAllFields( "SB1" , .T. )

	For nX := 1 to Len(aBodySB1)
		// Primeiro Json
		IIF(aBodySB1[nX] $ "Garantia"	,aBodySB1[nX] := "Garantia?"    ,)
		IIF(aBodySB1[nX] $ "Armazem_Pad",aBodySB1[nX] := "Armazem Pad." ,)
	Next

	// Pega o nome dos campos que foram informados no Json criando uma string unica que contem todos os campos que foram informados
	cTituloSB1 := Arrtokstr(aBodySB1)

	For nX := 1 to Len(aSB1)
		If ALLTRIM(GetSX3Cache(aSB1[nX], 'X3_TITULO')) $ cTituloSB1
			nPosFild := aScan(aBodySB1, ALLTRIM(GetSX3Cache(aSB1[nX], 'X3_TITULO')))
			oModSB1:SetValue(Alltrim(GetSX3Cache(aSB1[nX], 'X3_CAMPO')),jBody["produto"][aCampoSB1[nPosFild]])
		EndIf
	Next

	//Se conseguir validar as informa��es
	If oModel:VldData()

		//Tenta realizar o Commit
		If oModel:CommitData()

			lOk := .T.

			// U_FATP01FF(aBodyDA1,aCampoDA1,cMessage)

		Else //Se n�o deu certo, altera a vari�vel para false

			lOk := .F.
		EndIf

	Else //Se n�o conseguir validar as informa��es, altera a vari�vel para false

		lOk := .F.

	EndIf

	//Se n�o deu certo a inclus�o, mostra a mensagem de erro
	If ! lOk
		//Busca o Erro do Modelo de Dados
		aErro := oModel:GetErrorMessage()

		//Monta o Texto que ser� mostrado na tela
		cMessage := "Id do formul�rio de origem:"  + ' [' + cValToChar(aErro[01]) + '], '
		cMessage += "Id do campo de origem: "      + ' [' + cValToChar(aErro[02]) + '], '
		cMessage += "Id do formul�rio de erro: "   + ' [' + cValToChar(aErro[03]) + '], '
		cMessage += "Id do campo de erro: "        + ' [' + cValToChar(aErro[04]) + '], '
		cMessage += "Id do erro: "                 + ' [' + cValToChar(aErro[05]) + '], '
		cMessage += "Mensagem do erro: "           + ' [' + cValToChar(aErro[06]) + '], '
		cMessage += "Mensagem da solu��o: "        + ' [' + cValToChar(aErro[07]) + '], '
		cMessage += "Valor atribu�do: "            + ' [' + cValToChar(aErro[08]) + '], '
		cMessage += "Valor anterior: "             + ' [' + cValToChar(aErro[09]) + ']'

	Else
		cMessage := "Produto incluido com sucesso "
	EndIf

	//Desativa o modelo de dados
	oModel:DeActivate()

Return cMessage
