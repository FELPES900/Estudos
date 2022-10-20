#INCLUDE 'totvs.ch'
#INCLUDE "restful.ch"   // com issa include comseguiremos criar uma
// API simples

WSRESTFUL thewsclass DESCRIPTION "A Classe WS para testes" FORMAT APPLICATION_JSON SECURITY BASIC

	// Propriedade que serão chamdas
	// WSDATA sFilial

	WSMETHOD GET DESCRIPTION "Consulta de um unico cliente" WSSYNTAX "/cliente"

END WSRESTFUL

WSMETHOD GET WSSERVICE filiais

	Local cAlias := GetNextAlias() //Pega o próximo alias disponível
	Local cJson := ::GetContent() // Pega a string do JSON
	Local aClient := {}
	Local oJson
	Local lRet := .T.
	Local cError

	::SetContentType("application/json") // Pega o conteudo JSON da transação Rest
	oJson := JsonObject():New()          // Monta Objeto JSON de retorno
	cError  := oJson:FromJson(cJson)

	if Empty(cError)
		// setStatus e SetResponse
		SetRestFault(404,"Cliente Não Existe ou ID incorreto")
		lRet := .T.
	else
		cColId := oJson:GetJsonObject("ColId")

		BeginSQL Alias cAlias

			SELECT
				Z1_FILIAL,
				Z1_IDCLI,
				Z1_PRNOME,
				Z1_UTNOME,
				CONVERT(varchar(5000), Z1_EMAIL) Z1_EMAIL,
				Z1_GENERO,
				Z1_PAIS,
				Z1_IPREDE
			FROM
				%Table:SZ1%
			WHERE
				Z1_IDCLI = %Exp:cColId%

		ENDSQL
		DbSelectArea(cAlias)
		Aadd(aClient, JsonObject():New())

		aClient["FILIAL"]    := AllTrim((cAlias)->Z1_FILIAL)
		aClient["ID"]        := AllTrim((cAlias)->Z1_IDCLI )
		aClient["NOME"]      := AllTrim((cAlias)->Z1_PRNOME)
		aClient["SOBRONOME"] := AllTrim((cAlias)->Z1_UTNOME)
		aClient["EMAIL"]     := AllTrim((cAlias)->Z1_EMAIL )
		aClient["GENERO"]    := AllTrim((cAlias)->Z1_GENERO)
		aClient["PAIS"]      := AllTrim((cAlias)->Z1_PAIS  )
		aClient["IPREDE"]    := AllTrim((cAlias)->Z1_IPREDE)

		oJson:set(aClient) // seta o valor ao objeto
		::SetResponse(oJson:toJson())

	endif

Return lRet
