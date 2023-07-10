#INCLUDE"TOTVS.CH"
#INCLUDE"TBICONN.CH"

/*/{Protheus.doc} U_CRMA02FF
    Retorna uma lista
    @type function
    @version 33
    @author felip
    @since 28/10/2022
/*/

Function U_CRMA02FF()

	local oFile
	local oRest
	local cGet    := ""
	local cJson  := ""
	local cLinAtu := ""
	Local aHeader := {}
	Local cIpLocal := 'http://192.168.1.6:8081/rest'
	Local cPathRest := '/postcli/insert/clientes'

	if SELECT("SX2") == 0 //Para ser executado pelo usuario
		PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01"
	endif

	cGet := SuperGetMV("MV_XRTOTXT",.F.)

	oFile := FWFileReader():New(cGet + "\json.txt")

	//Se o arquivo pode ser aberto
	If (oFile:Open())

		//Se não for fim do arquivo
		If ! (oFile:EoF())

			//Enquanto houver linhas a serem lidas
			While (oFile:HasLine())

				//Buscando o texto da linha atual
				cLinAtu := oFile:GetLine()
				cJson+=cLinAtu

			EndDo

		Endif

	Endif

	AAdd(aHeader, "Accept: application/json")
	aAdd(aHeader,"Accept-Encoding: UTF-8")
	aAdd(aHeader, "Content-Type: application/json; charset=UTF-8")
	oRest := FWRest():New(cIpLocal)
	oRest:setPath(cPathRest)
	oRest:SetPostParams(cJson)
	if (oRest:POST(aHeader))
		FWLogMsg("INFO", /*cTransactionId*/, ProcName(), /*cCategory*/, /*cStep*/, /*cMsgId*/, "Sucesso ao integrar: "+oRest:GetResult() , /*nMensure*/, /*nElapseTime*/, /*aMessage*/)
	else
		FWLogMsg("ERROR", /*cTransactionId*/, ProcName(), /*cCategory*/, /*cStep*/, /*cMsgId*/,"Não foi possivel integrar: "+oRest:GetResult() ,/*nMensure*/, /*nElapseTime*/, /*aMessage*/)
	endif
	
	if SELECT("SX2") > 0
		RESET ENVIRONMENT
	endif
	
Return
