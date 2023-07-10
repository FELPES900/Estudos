#INCLUDE 'TOTVS.CH'
#INCLUDE "RESTFUL.CH"

WSRESTFUL POSTCLI DESCRIPTION "A Classe WS para testes" FORMAT APPLICATION_JSON

	WSMETHOD POST DESCRIPTION "Consulta de um unico cliente" WSSYNTAX "/insert/clientes"

END WSRESTFUL

WSMETHOD POST WSSERVICE POSTCLI

	Local cJson    := self:GetContent() as Character
	local lRet     := .T.            as Logical
	local oJson    := Nil            as Object
	local cError   := ""             as Character
	local nX       := 0              as Numeric
	local aClient  := {}             as Array
	Local nOpcAuto := 3              as Numeric //MODEL_OPERATION_INSERT
	Local cLoja    := PadR("01",TamSx3('A1_LOJA')[1])
	Private lMsErroAuto := .F.
	Private lMSHelpAuto     := .T.
	Private lAutoErrNoFile := .T.

	self:SetContentType("application/json") // Pega o conteudo JSON da transação Rest
	oJson := JsonObject():New()          // Monta Objeto JSON de retorno
	cError  := oJson:FromJson(cJson)

	DbSelectArea("SA1") // selecionando qual a tabela nos iremos usar

	if Empty(cError)

		for nX := 1 to Len(oJson:GetJsonObject('CLIENTES'))

			if !SA1->(MsSeek( PadR(xFilial("SA1",oJson:GetJsonObject( 'CLIENTES' )[nX][ 'FILIAL' ]),TamSx3('A1_FILIAL')[1]);
					+ PadL(oJson:GetJsonObject( 'CLIENTES' )[nX][ 'ID' ],TamSx3('A1_COD')[1],'0')   ;
					+  cLoja))
				aClient := {}
				aadd(aClient, {"A1_FILIAL" , xFilial("SA1",oJson:GetJsonObject( 'CLIENTES' )[nX][ 'FILIAL' ])                                            , NIL})
				aadd(aClient, {"A1_COD"    , PadL(oJson:GetJsonObject( 'CLIENTES' )[nX][ 'ID' ],TamSx3( 'A1_COD' )[1], '0' )                             , NIL})
				aadd(aClient, {"A1_LOJA"   , cLoja                                                                                                       , NIL})
				aadd(aClient, {"A1_NOME"   , oJson:GetJsonObject( 'CLIENTES' )[nX][ 'NOME' ] + ' ' + oJson:GetJsonObject( 'CLIENTES' )[nX][ 'SOBRONOME' ], NIL})
				aadd(aClient, {"A1_EMAIL"  , oJson:GetJsonObject( 'CLIENTES' )[nX][ 'EMAIL' ]                                                            , NIL})
				aadd(aClient, {"A1_PAIS"   , "105"                                                                                                       , NIL})
				aadd(aClient, {"A1_XIPREDE", oJson:GetJsonObject( 'CLIENTES' )[nX][ 'IPREDE' ]                                                           , NIL})
				aadd(aClient, {"A1_XGENERO", oJson:GetJsonObject( 'CLIENTES' )[nX][ 'GENERO' ]                                                           , NIL})
				aadd(aClient, {"A1_END"    , "Av. do CPA"                                                                                                , Nil})
				aadd(aClient, {"A1_NREDUZ" , oJson:GetJsonObject( 'CLIENTES' )[nX][ 'NOME' ]                                                             , Nil})
				aadd(aClient, {"A1_TIPO"   , "F"                                                                                                         , Nil})
				aadd(aClient, {"A1_PESSOA" , "F"                                                                                                         , Nil})
				aadd(aClient, {"A1_EST"    , "MT"                                                                                                        , Nil})
				aadd(aClient, {"A1_MUN"    , "Cuiaba"                                                                                                    , NIL})
				aClient := FwVetByDic(aClient)
				MSExecAuto({|a,b| CRMA980(a,b)}, aClient, nOpcAuto)

				If lMsErroAuto
					lRet := !lMsErroAuto
					SetRestFault(400,VarInfo('',GetAutoGrLog()))
					Exit
				Else
					Conout("Cliente incluído com sucesso!")
				EndIf
			endif
		next
	else
		lRet := .F.
	endif

RETURN lRet
