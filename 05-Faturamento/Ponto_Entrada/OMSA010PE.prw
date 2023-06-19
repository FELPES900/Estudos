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

	//Se tiver parâmetros
	If aParam <> NIL
		ConOut("> "+aParam[2])

		//Pega informações dos parâmetros
		oObj     := aParam[1]
		cIdPonto := aParam[2]
		cIdModel := aParam[3]

		//Valida a abertura da tela
		If cIdPonto == "MODELVLDACTIVE" .And. !(cModelAct $ cIdPonto)
			cModelAct += cIdPonto + '|'
		endif

		//Pré configurações do Modelo de Dados
		If cIdPonto == "MODELPRE" .And. !(cModelAct $ cIdPonto)
			cModelAct += cIdPonto + '|'
		endif

		//Pré configurações do Formulário de Dados
		If cIdPonto == "FORMPRE" .And. !(cModelAct $ cIdPonto)

			cModelAct += cIdPonto + '|'

			// cTipo  := aParam[4]
			// cCampo := aParam[5]

			// //Se for Alteração e Não permite alteração dos campos chave
			// If nOper == 4 .And. cTipo == "CANSETVALUE" .And. Alltrim(cCampo) $ ("A6_COD.A6_AGENCIA.A6_NUMCON")
			// 	xRet := .F.
			// EndIf
		endif

		//Adição de opções no Ações Relacionadas dentro da tela
		If cIdPonto == 'BUTTONBAR' .And. !(cModelAct $ cIdPonto)
			cModelAct += cIdPonto + '|'
		endif

		//Pós configurações do Formulário
		If cIdPonto == 'FORMPOS' .And. !(cModelAct $ cIdPonto)
			cModelAct += cIdPonto + '|'
		endif

		//Validação ao clicar no Botão Confirmar
		If cIdPonto == 'MODELPOS' .And. !(cModelAct $ cIdPonto)
			cModelAct += cIdPonto + '|'
			// //Se o campo de contato estiver em branco, não permite prosseguir
			// If Empty(M->A6_CONTATO)
			// 	Aviso('Atenção', 'Por favor, informe um Contato!', {'OK'}, 03)
			// 	xRet := .F.
			// EndIf
		endif

		//Pré validações do Commit
		If cIdPonto == 'FORMCOMMITTTSPRE' .And. !(cModelAct $ cIdPonto)
			cModelAct += cIdPonto + '|'
		endif

		//Pós validações do Commit
		If cIdPonto == 'FORMCOMMITTTSPOS' .And. !(cModelAct $ cIdPonto)
			cModelAct += cIdPonto + '|'
		endif

		//Commit das operações (antes da gravação)
		If cIdPonto == 'MODELCOMMITTTS' .And. !(cModelAct $ cIdPonto)
			cModelAct += cIdPonto + '|'
		endif

		//Commit das operações (após a gravação)
		If cIdPonto == 'MODELCOMMITNTTS' .And. !(cModelAct $ cIdPonto)

			cModelAct += cIdPonto

			FWLogMsg("INFO",/*cTransactionId*/, ProcName(),/*cCategory*/, /*cStep*/,;
			 /*cMsgId*/, "Os pontos de entradas em MVC que foram utilizados foram: " + cModelAct , /*nMensure*/, /*nElapseTime*/, /*aMessage*/)
			EndIf
	EndIf
Return xRet
