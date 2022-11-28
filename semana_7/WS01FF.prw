#INCLUDE 'TOTVS.CH'
#INCLUDE "RESTFUL.CH"   // com issa include comseguiremos criar uma API simples

WSRESTFUL FILIAIS DESCRIPTION "A Classe WS para testes" FORMAT APPLICATION_JSON

	WSMETHOD GET DESCRIPTION "Consulta de um unico cliente" WSSYNTAX "/clientes"
	// Passando o PATH como um parametro que quando for inserido a rota precisa ser informado o valor

END WSRESTFUL

// WSMETHOD GET PATHPARAM ID WSSERVICE FILIAIS
WSMETHOD GET WSSERVICE FILIAIS

	Local cAlias   := GetNextAlias()                          as Character //Pega o próximo alias disponível
	Local cJson    := self:GetContent()                          as Character // Pega a string do JSON
	Local aClient  := {}                                      as Array
	Local oJson    := Nil                                     as Object
	Local lRet     := .T.                                     as Logical
	Local cError   := ""                                      as Character
	local nLoop    := 0                                       as Numeric
	local cArquivo := "\temp\json.txt"                        as Character // Somente inseri os dados quando estiver na pasta protheus_data

	self:SetContentType("application/json") // Pega o conteudo JSON da transação Rest
	oJson := JsonObject():New()          // Monta Objeto JSON de retorno
	cError  := oJson:FromJson(cJson)

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
			%notdel%
	ENDSQL

	while !(cAlias)->(Eof())

		nLoop++

		aAdd(aClient,JsonObject():New())

		// Os valores que serão apresentado no JSON
		aClient[nLoop]["FILIAL"]    := AllTrim((cAlias)->Z1_FILIAL)
		aClient[nLoop]["ID"]        := AllTrim((cAlias)->Z1_IDCLI )
		aClient[nLoop]["NOME"]      := AllTrim((cAlias)->Z1_PRNOME)
		aClient[nLoop]["SOBRONOME"] := AllTrim((cAlias)->Z1_UTNOME)
		aClient[nLoop]["EMAIL"]     := AllTrim((cAlias)->Z1_EMAIL )
		aClient[nLoop]["GENERO"]    := AllTrim((cAlias)->Z1_GENERO)
		aClient[nLoop]["PAIS"]      := AllTrim((cAlias)->Z1_PAIS  )
		aClient[nLoop]["IPREDE"]    := AllTrim((cAlias)->Z1_IPREDE)

		(cAlias)->(dbSkip())
	end
	oJson['CLIENTES'] := aClient
	If MEMOWRITE(cArquivo, oJson:toJson())
		ConOut("Gravou")
	EndIf
	//oJson:set(aClient) // seta o valor ao objeto
	self:SetResponse(oJson:toJson()) // retorno de um objeto JSON

Return lRet
