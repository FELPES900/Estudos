#INCLUDE 'TOTVS.CH'
#INCLUDE "RESTFUL.CH"   // com issa include comseguiremos criar uma API simples

WSRESTFUL FILIAIS DESCRIPTION "A Classe WS para testes" FORMAT APPLICATION_JSON SECURITY BASIC

	// Propriedade que serão chamdas
	WSDATA ID AS STRING

	WSMETHOD GET DESCRIPTION "Consulta de um unico cliente" WSSYNTAX "/filiais/{id}" PATH "/{id}"

END WSRESTFUL

WSMETHOD GET PATHPARAM ID WSSERVICE FILIAIS

	Local cAlias := GetNextAlias() //Pega o próximo alias disponível
	Local cJson := ::GetContent() // Pega a string do JSON
	Local aClient := {}
	Local oJson
	Local lRet := .T.
	Local cError

	::SetContentType("application/json") // Pega o conteudo JSON da transação Rest
	oJson := JsonObject():New()          // Monta Objeto JSON de retorno
	cError  := oJson:FromJson(cJson)

	if Empty(Self:id) // Aqui vereficamos se foi passado os ID na route
		SetRestFault(404,"Cliente Não Existe ou ID incorreto")
		lRet := .T.
	else
		cColId := Self:id // Recebi o ID para realizar a consulta sem erro

		// Consulta SQL puxando somente os campos especificos
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
				// Vendo qual cliente que será mostrado
		ENDSQL

		DbSelectArea(cAlias) // Selecionando a tabela
		aClient := JsonObject():New() // representa um objeto JSON

		// Os valores que serão apresentado no JSON
		aClient["FILIAL"]    := AllTrim((cAlias)->Z1_FILIAL)
		aClient["ID"]        := AllTrim((cAlias)->Z1_IDCLI )
		aClient["NOME"]      := AllTrim((cAlias)->Z1_PRNOME)
		aClient["SOBRONOME"] := AllTrim((cAlias)->Z1_UTNOME)
		aClient["EMAIL"]     := AllTrim((cAlias)->Z1_EMAIL )
		aClient["GENERO"]    := AllTrim((cAlias)->Z1_GENERO)
		aClient["PAIS"]      := AllTrim((cAlias)->Z1_PAIS  )
		aClient["IPREDE"]    := AllTrim((cAlias)->Z1_IPREDE)

		oJson:set(aClient) // seta o valor ao objeto
		::SetResponse(oJson:toJson()) // retorno de um objeto JSON

	endif

Return lRet
