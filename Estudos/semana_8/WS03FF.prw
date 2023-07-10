#INCLUDE 'TOTVS.CH'
#INCLUDE "RESTFUL.CH"


/*{Protheus.doc} WSRESTFUL
API que retorna o nome dos arquivos da routa C:\TOTVS\Protheus\protheus_data\temp\Semana_8
@type class
@version 1.0
@author Jerfferson Menezes
@since 28/03/2022
*/
WSRESTFUL GETARQUIVO DESCRIPTION "A Classe WS para testes" FORMAT APPLICATION_JSON

	WSMETHOD GET DESCRIPTION "Consulta retronando todos os arquivos dentro da pastas semana_8" WSSYNTAX "/arquivos/visulizar" PATH "/{arquivo}"

END WSRESTFUL

WSMETHOD GET WSRECEIVE WSSERVICE GETARQUIVO
	
	// 
	Local nSecond := Seconds()
	local lRet     := .T.                                                                        as Logical
	local aArquivo := {}                                                                         as Array
	Local nX       := 0                                                                          as Numeric
	Local aFiles   := {}                                                                         as Array
	local oJson    := Nil                                                                        as Object
	Local cRoute   := "..\protheus_data\temp\Semana_8"                                           as Character
	local jParams  := JsonObject():New()                                                         as Object
	Local cTipVali := "pdf|doc|docx|txt|csv|xls|xlsx|png|jpg|jpeg|tiff|gif|mp3|mp4|wmv|webm|prw" as Character
	jParams := oRest:getQueryRequest()
	// self:arquivo
	IIF(EMPTY(jParams['tipoArquivo']), jParams['tipoArquivo']:="*",Nil)
	if (jParams['tipoArquivo'] $ cTipVali .or. jParams['tipoArquivo'] == "*")
		ADir( cRoute + "\*." + jParams['tipoArquivo'], @aFiles)
		oJson := JsonObject():New()          // Monta Objeto JSON de retorno
		nCount := Len(aFiles)
		if (nCount <> 0)
			for nX := 1 to nCount
				Aadd(aArquivo, aFiles[nX])
			next
			Aadd(aArquivo, Seconds() - nSecond)
			oJson:set(aArquivo)
			self:SetResponse(oJson:toJson())
		else
			lRet := .F.
			SetRestFault(404, EncodeUTF8("Nenhum aquivo nessa pasta"))
		endif
	else
		lRet := .F.
		SetRestFault(422, EncodeUTF8("Este tipo de arquivo nao é aceito"))
	endif
Return lRet
