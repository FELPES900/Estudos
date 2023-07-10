#INCLUDE "TOTVS.CH"
#INCLUDE"TBICONN.CH"

/*/{Protheus.doc} U_FENVREL
Envia um emial para o usuario detereminado no parametro
Informando quantos usuarios estao com o controle de penhor irao vencer
@type function
@version 12.1.33
@author Felipe Fraga
@since 31/03/2023
/*/
Function U_FENVREL()

	Local aCliente 	  := {}
	Local cAssunto    := ""
	Local cQuery   	  := ""
	Local cFROM       := ""
	Local cPara       := ""
	Local cSMTPPass   := ""
	Local cSMTPServer := ""
	Local cSMTPUser   := ""
	Local cAlias	  := ""
	Local cTexto      := ''
	Local lOk         := .T.
	Local lSSl        := .F.
	Local lTls        := .F.
	Local nErro       := 0
	Local nPort       := 0
	Local nX 		  := 0 
	Local oMail
	Local oMessage
	Local oQueryZZ1

	// Adicionando o assunto do envio de email
	cAssunto := "Controle de data de vecimento de penhor"

	if SELECT("SX2") == 0 //Para ser executado pelo usuario
		PREPARE ENVIRONMENT EMPRESA "01" FILIAL "010101"
	endif

	// Consuilta que verifica se algum contrato de penhor determinado na tabela ZZ1 está faltando 3 dias
	cAlias := GetNextAlias()
	cQuery := " SELECT * FROM ZZ1010 "

	cQuery := ChangeQuery(cQuery)
	oQueryZZ1 := FWPreparedStatement():New(cQuery)
	cQuery := oQueryZZ1:GetFixQuery()

	cAlias := MPSYSOpenQuery(cQuery)

	while(cAlias)->(!EOF())
		// Pegar a data dia menos a data de vencimento, caso seja igual 3 entra na cond
		if (DateDiffDay(STOD((cAlias)->ZZ1_B3VENC),DATE())) == 3 .And. (cAlias)->ZZ1_EMAILE <> "S"
			Aadd(aCliente,{;
			(cAlias)->ZZ1_CODPEN,;
			(cAlias)->ZZ1_CODFOR,;
			(cAlias)->ZZ1_NFORNE,;
			(cAlias)->ZZ1_LOJAFO,;
			(cAlias)->ZZ1_EMAILE,;
			(cAlias)->ZZ1_CODIGO;
			})
		endif 
		(cAlias)->(DbSkip())
	End

	if(Len(aCliente) <> 0)
		// Parametros que serao usados
		cFROM       := GetMV("MV_RELFROM")
		cPara       := GetMV("FS_EMAILEN")
		cSMTPPass   := GetMV("MV_RELPSW") 
		cSMTPServer := GetMV("MV_RELSERV")
		cSMTPUser   := GetMV("MV_RELACNT")
		lSSl        := GetMV("MV_RELSSL",,.F.)
		lTls        := GetMV("MV_RELTLS",,.F.)
		nPort       := GetMV("MV_GCPPORT",,587)

		cTexto := "Segue e-mail automático referente ao B3/Cartorio"
		cTexto += "<br/>"
		cTexto += "<br/>"
		// Falar quantos contratos de penhor esto pendentes
			for nX := 1 to Len(aCliente)
				cTexto += "O Codigo de penhor: " + aCliente[nX][1] + " ira vencer em 3 dias."
				cTexto += "<br/>"
				cTexto += "Do fornecedor " + aCliente[nX][2] + " / " + aCliente[nX][4] + " - " + aCliente[nX][3]
				cTexto += "<br/>"		
			next
			cTexto += "<br/>"
		nX := 0
		
		cTexto += "<br/>"
		cTexto += "<br/>"
		cTexto += "<br/>"
		cTexto += "Menssagem gerada automaticamente pelo ERP PROTHEUS"
		cTexto += "<br/>"
		cTexto += "Dia: " + StrZero(Day(dDataBase),2) + " de " + MesExtenso(Month(DATE())) + " de " + Str(Year(DATE()),4) + " as " + TIME()
		cTexto += "<br/>"
		cTexto += "Não responder este email!"

		oMail := TMailManager():New()

		If At(":",cSMTPServer) > 0
			//-- Retira a porta pois deve pegar pelo parametro MV_GCPPORT
			cSMTPServer := SubStr(cSMTPServer , 01 , At(":",cSMTPServer) - 1 )
		EndIf

		oMail:SetUseSSL(lSSl)
		oMail:SetUseTLS(lTls)
		oMail:Init( '', cSMTPServer , cSMTPUser, cSMTPPass, 0, nPort  )

		oMail:SetSmtpTimeOut( 120 )

		nErro := oMail:SmtpConnect()

		If nErro == 0 //-- Conseguiu Conectar.
			nErro := oMail:SmtpAuth(cSMTPUser ,cSMTPPass) //-- Autenticação do usuário
			If nErro == 0 //-- Autenticação correta
				oMessage := TMailMessage():New()
				oMessage:Clear()
				oMessage:cFrom	:= cFROM
				oMessage:cTo	:= cPara

				oMessage:cSubject	:= cAssunto
				oMessage:cBody		:= cTexto

				nErro := oMessage:Send( oMail )
				If nErro == 0
					DBSelectArea("ZZ1")
					ZZ1->(DbSetOrder(2))
					for nX := 1 to Len(aCliente)
						if(DBSeek(xFilial("ZZ1") + aCliente[nX][6] + aCliente[nX][2]))
							RecLock("ZZ1",.F.)
								ZZ1->ZZ1_EMAILE := "S"
							MSUNLOCK()
						endif
					next
					lOk := .T.
				Else
					cMAilError := oMail:GetErrorString(nErro)
					Alert(cMAilError+CRLF+cValToChar(nErro)+CRLF+"3","Envia")
					lOk := .F.
					oMail:SMTPDisconnect()
				Endif
			Else //-- Não Autenticou
				cMAilError := oMail:GetErrorString(nErro)
				Alert(cMAilError+CRLF+cValToChar(nErro)+CRLF+"2","Autenticacao")
				lOk := .F.
				oMail:SMTPDisconnect()
			EndIf
		Else //-- Não Conseguiu Conectar.
			cMAilError := oMail:GetErrorString(nErro)
			Alert(cMAilError+CRLF+cValToChar(nErro)+CRLF+"1","Connexao")
			lOk := .F.
			oMail:SMTPDisconnect()
		EndIf
	endif

	if SELECT("SX2") > 0
		RESET ENVIRONMENT
	endif

Return(lOk)
