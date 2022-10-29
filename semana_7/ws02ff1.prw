#line 1 "c:/totvs/protheus/protheus/include\TOTVS.CH"
#line 1 "c:/totvs/protheus/protheus/include\protheus.ch"
#line 1 "c:/totvs/protheus/protheus/include\dialog.ch"
#line 29 "protheus.ch"
#line 1 "c:/totvs/protheus/protheus/include\font.ch"
#line 30 "protheus.ch"
#line 1 "c:/totvs/protheus/protheus/include\ptmenu.ch"
#line 32 "protheus.ch"
#line 1 "c:/totvs/protheus/protheus/include\print.ch"
#line 34 "protheus.ch"
#line 1 "c:/totvs/protheus/protheus/include\colors.ch"
#line 36 "protheus.ch"
#line 1 "c:/totvs/protheus/protheus/include\folder.ch"
#line 38 "protheus.ch"
#line 1 "c:/totvs/protheus/protheus/include\msobject.ch"
#line 39 "protheus.ch"
#line 1 "c:/totvs/protheus/protheus/include\vkey.ch"
#line 43 "protheus.ch"
#line 1 "c:/totvs/protheus/protheus/include\winapi.ch"
#line 45 "protheus.ch"
#line 1 "c:/totvs/protheus/protheus/include\fwcommand.ch"
#line 48 "protheus.ch"
#line 1 "c:/totvs/protheus/protheus/include\fwcss.ch"
#line 51 "protheus.ch"
#line 2 "c:\totvs\estrudos_advpl\estudos_advpl\semana_7\\c:/totvs/estrudos_advpl/estudos_advpl/semana_7/ws02ff.prw"
#line 1 "c:/totvs/protheus/protheus/include\RESTFUL.CH"
#line 4 "c:\totvs\estrudos_advpl\estudos_advpl\semana_7\\c:/totvs/estrudos_advpl/estudos_advpl/semana_7/ws02ff.prw"
_ObjNewClass( REST_POSTCLI , WSRESTFUL ); _ObjClassData( DESCRIPTION__ , string, , "A Classe WS para testes" ); _ObjClassData( DESCRIPTION_FORMAT , string , , "application/json"); _ObjClassData( DESCRIPTION_SECURITY , string , , ); _ObjClassData( DESCRIPTION_SSL , string, , ".F." )

	_ObjClassMethod( POST, , ); _ObjClassData( DESCRIPTION_POST , string, , "Consulta de um unico cliente" ); _ObjClassData( DESCRIPTION_SYNTAX_POST, string, ,"/insert/clientes" ); _ObjClassData( DESCRIPTION_INFO_POST, string, , '{"id":"create","name":"POST"}' )

_ObjEndClass()

Function ___REST_POSTCLI____POST(_QUERYPARAM,WSNOSEND)

	Local cJson    := Self:GetContent() as  Character
	local lRet     := .T.  as  Logical
	local oJson    := Nil as  Object
	local cError   := "" as  Character
	local nX       := 0 as  Numeric
	local aClient  := {} as  Array
	Local nOpcAuto := 3 as  Numeric
	Local cLoja    := PadR("01",TamSx3("A1_LOJA")[1])
	Private lMsErroAuto := .F. 
	Private lMSHelpAuto     := .T. 
	Private lAutoErrNoFile := .T. 

	Self:SetContentType("application/json")
	oJson := JsonObject():New()
	cError  := oJson:FromJson(cJson)

	DbSelectArea("SA1")

	if Empty(cError)

		for nX := 1 to Len(oJson:GetJsonObject("CLIENTES"))

			if !SA1->(MsSeek( PadR(xFilial("SA1",oJson:GetJsonObject( "CLIENTES" )[nX][ "FILIAL" ]),TamSx3("A1_FILIAL")[1]) + PadL(oJson:GetJsonObject( "CLIENTES" )[nX][ "ID" ],TamSx3("A1_COD")[1],"0")   +  cLoja))
				aClient := {}
				aadd(aClient, {"A1_FILIAL" , xFilial("SA1",oJson:GetJsonObject( "CLIENTES" )[nX][ "FILIAL" ])                                            , NIL})
				aadd(aClient, {"A1_COD"    , PadL(oJson:GetJsonObject( "CLIENTES" )[nX][ "ID" ],TamSx3( "A1_COD" )[1], "0" )                             , NIL})
				aadd(aClient, {"A1_LOJA"   , cLoja                                                                                                       , NIL})
				aadd(aClient, {"A1_NOME"   , oJson:GetJsonObject( "CLIENTES" )[nX][ "NOME" ] + " " + oJson:GetJsonObject( "CLIENTES" )[nX][ "SOBRONOME" ], NIL})
				aadd(aClient, {"A1_EMAIL"  , oJson:GetJsonObject( "CLIENTES" )[nX][ "EMAIL" ]                                                            , NIL})
				aadd(aClient, {"A1_PAIS"   , "105"                                                                                                       , NIL})
				aadd(aClient, {"A1_XIPREDE", oJson:GetJsonObject( "CLIENTES" )[nX][ "IPREDE" ]                                                           , NIL})
				aadd(aClient, {"A1_XGENERO", oJson:GetJsonObject( "CLIENTES" )[nX][ "GENERO" ]                                                           , NIL})
				aadd(aClient, {"A1_END"    , "Av. do CPA"                                                                                                , Nil})
				aadd(aClient, {"A1_NREDUZ" , oJson:GetJsonObject( "CLIENTES" )[nX][ "NOME" ]                                                             , Nil})
				aadd(aClient, {"A1_TIPO"   , "F"                                                                                                         , Nil})
				aadd(aClient, {"A1_PESSOA" , "F"                                                                                                         , Nil})
				aadd(aClient, {"A1_EST"    , "MT"                                                                                                        , Nil})
				aadd(aClient, {"A1_MUN"    , "Cuiaba"                                                                                                    , NIL})
				aClient := FwVetByDic(aClient)
				MSExecAuto({|a,b| CRMA980(a,b)}, aClient, nOpcAuto)

				If lMsErroAuto
					lRet := !lMsErroAuto
					SetRestFault(400,VarInfo("",GetAutoGrLog()))
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
