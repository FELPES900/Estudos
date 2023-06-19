#Include "TOTVS.CH"

Static cModelAct := ""

User Function OMSA010()

	Local aParam     := PARAMIXB
	Local xRet       := .T.
	Local oObj       := Nil
	Local cIdPonto   := ''
	Local cIdModel   := ''
	// Local nOper      := 0
	// Local cCampo     := ''
	// Local cTipo      := ''

	//Se tiver par�metros
	If aParam <> NIL
		ConOut("> "+aParam[2])

		//Pega informa��es dos par�metros
		oObj     := aParam[1]
		cIdPonto := aParam[2]
		cIdModel := aParam[3]

		//Valida a abertura da tela
		If cIdPonto == "MODELVLDACTIVE" .And. !(cModelAct $ cIdPonto)
			cModelAct += cIdPonto + '|'
		endif

		//Pr� configura��es do Modelo de Dados
		If cIdPonto == "MODELPRE" .And. !(cModelAct $ cIdPonto)
			cModelAct += cIdPonto + '|'
		endif

		//Pr� configura��es do Formul�rio de Dados
		If cIdPonto == "FORMPRE" .And. !(cModelAct $ cIdPonto)

			cModelAct += cIdPonto + '|'

			// cTipo  := aParam[4]
			// cCampo := aParam[5]

			// //Se for Altera��o e N�o permite altera��o dos campos chave
			// If nOper == 4 .And. cTipo == "CANSETVALUE" .And. Alltrim(cCampo) $ ("A6_COD.A6_AGENCIA.A6_NUMCON")
			// 	xRet := .F.
			// EndIf
		endif

		//Adi��o de op��es no A��es Relacionadas dentro da tela
		If cIdPonto == 'BUTTONBAR' .And. !(cModelAct $ cIdPonto)
			cModelAct += cIdPonto + '|'
		endif

		//P�s configura��es do Formul�rio
		If cIdPonto == 'FORMPOS' .And. !(cModelAct $ cIdPonto)
			cModelAct += cIdPonto + '|'
		endif

		//Valida��o ao clicar no Bot�o Confirmar
		If cIdPonto == 'MODELPOS' .And. !(cModelAct $ cIdPonto)
			cModelAct += cIdPonto + '|'
			// //Se o campo de contato estiver em branco, n�o permite prosseguir
			// If Empty(M->A6_CONTATO)
			// 	Aviso('Aten��o', 'Por favor, informe um Contato!', {'OK'}, 03)
			// 	xRet := .F.
			// EndIf
		endif

		//Pr� valida��es do Commit
		If cIdPonto == 'FORMCOMMITTTSPRE' .And. !(cModelAct $ cIdPonto)
			cModelAct += cIdPonto + '|'
		endif

		//P�s valida��es do Commit
		If cIdPonto == 'FORMCOMMITTTSPOS' .And. !(cModelAct $ cIdPonto)
			cModelAct += cIdPonto + '|'
		endif

		//Commit das opera��es (antes da grava��o)
		If cIdPonto == 'MODELCOMMITTTS' .And. !(cModelAct $ cIdPonto)
			cModelAct += cIdPonto + '|'
		endif

		//Commit das opera��es (ap�s a grava��o)
		If cIdPonto == 'MODELCOMMITNTTS' .And. !(cModelAct $ cIdPonto)

			cModelAct += cIdPonto

			FWLogMsg("INFO",/*cTransactionId*/, ProcName(),/*cCategory*/, /*cStep*/,;
			 /*cMsgId*/, "Os pontos de entradas em MVC que foram utilizados foram: " + cModelAct , /*nMensure*/, /*nElapseTime*/, /*aMessage*/)
			EndIf
	EndIf
Return xRet
