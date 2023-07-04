#INCLUDE "TOTVS.Ch"

Static cModelAct := ""

User Function MATA410()

	Local aParam     := PARAMIXB
	Local xRet       := .T.
	Local cIdPonto   := ''

	//Se tiver parâmetros
	If aParam <> NIL
		ConOut("> "+aParam[2])

		//Pega informações dos parâmetros
		cIdPonto := aParam[2]

		// //Valida a abertura da tela
		// If cIdPonto == "MODELVLDACTIVE" .And. !(cModelAct $ cIdPonto)
		// 	cModelAct += cIdPonto + '|'
		// endif

		// //Pré configurações do Modelo de Dados
		// If cIdPonto == "MODELPRE" .And. !(cModelAct $ cIdPonto)
		// 	cModelAct += cIdPonto + '|'
		// endif

		// //Pré configurações do Formulário de Dados
		// If cIdPonto == "FORMPRE" .And. !(cModelAct $ cIdPonto)
		// 	cModelAct += cIdPonto + '|'
		// endif

		// //Adição de opções no Ações Relacionadas dentro da tela
		// If cIdPonto == 'BUTTONBAR' .And. !(cModelAct $ cIdPonto)
		// 	cModelAct += cIdPonto + '|'
		// endif

		// //Pós configurações do Formulário
		// If cIdPonto == 'FORMPOS' .And. !(cModelAct $ cIdPonto)
		// 	cModelAct += cIdPonto + '|'
		// endif

		// //Pré validações do Commit
		// If cIdPonto == 'FORMCOMMITTTSPRE' .And. !(cModelAct $ cIdPonto)
		// 	cModelAct += cIdPonto + '|'
		// endif

		// //Pós validações do Commit
		// If cIdPonto == 'FORMCOMMITTTSPOS' .And. !(cModelAct $ cIdPonto)
		// 	cModelAct += cIdPonto + '|'
		// endif

		// //Commit das operações (após a gravação)
		// If cIdPonto == 'MODELCOMMITNTTS' .And. !(cModelAct $ cIdPonto)

		// 	cModelAct += cIdPonto

		// 	FWLogMsg("INFO",/*cTransactionId*/, ProcName(),/*cCategory*/, /*cStep*/,;
			// 	 /*cMsgId*/, "Os pontos de entradas em MVC que foram utilizados foram: " + cModelAct , /*nMensure*/, /*nElapseTime*/, /*aMessage*/)
		// 	EndIf

		//Validação ao clicar no Botão Confirmar
		If cIdPonto == 'MODELPOS' .And. !(cModelAct $ cIdPonto)
			cModelAct += cIdPonto + '|'
			// Validar todos os campos como obrigatorios
		endif

		//Commit das operações (antes da gravação)
		If cIdPonto == 'MODELCOMMITTTS' .And. !(cModelAct $ cIdPonto)
			cModelAct += cIdPonto + '|'
			// Vazer a inclusao do produto
		endif

	EndIf
Return xRet
