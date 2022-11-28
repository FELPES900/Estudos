#INCLUDE 'TOTVS.CH'
#INCLUDE "RESTFUL.CH"

WSRESTFUL GETDOWNLOAD DESCRIPTION "A Classe WS para envio de arquivo" FORMAT APPLICATION_JSON

	WSMETHOD GET DESCRIPTION "Consulta para retorna o arquivo de apresentação" PATH "/arquivos/visulizar/{arquivo}"

END WSRESTFUL

WSMETHOD GET WSRECEIVE WSSERVICE GETDOWNLOAD

	Local lRet     := .T.                              as Logical
	local oJson    := Nil                              as Object
	Local oFIle    := Nil                              as Object
	Local cFile    := ""                               as Character
	Local cArquivo := ""
	Local cRoute   := "..\protheus_data\temp\Semana_8" as Character
	Local cTipo := "" as Character
	Local cTipVali := "pdf|doc|txt|csv|xls|png|jpg|gif|mp3|mp4|wmv|prw" as Character
	// Local aContTyp := {"application","audio","font","example","image","message","model","multipart","text","video"} as Array

	cArquivo := self:aURLParms[3]
	cTipo := Right(cArquivo, 3)
	oJson := JsonObject():New()
	if (cTipo $ cTipVali)
		oFile := FWFileReader():New(cRoute + "\" + cArquivo)
		If (oFile:Open())
			cFile := oFile:FullRead() // EFETUA A LEITURA DO ARQUIVO
			self:SetHeader('Content-Type', validaTIpo(cTipo))
			self:SetHeader("Content-Disposition", "attachment; filename=" + AllTrim(cArquivo))
			self:SetResponse(cFile)
			lRet := .T.
		else
			SetRestFault(002, "can't load file")
			lRet := .F.
		endif
	else
		lRet := .F.
		SetRestFault(422, EncodeUTF8("Este tipo de arquivo nao existe ou tipo não aceito"))
	endif
Return lRet

Static function validaTipo(cTipo)

	Local cConteudo
	
	Do Case
	Case cTipo == "pdf"
		cConteudo := "application/pdf" // ok 
	Case cTipo == "doc"
		cConteudo := "application/msword" // ok
	Case cTipo == "xls"
		cConteudo := "application/vnd.ms-excel"
	Case cTipo == "txt" .or. cTipo == "prw"
		cConteudo := "text/plain"
	Case cTipo == "csv"
		cConteudo := "text/csv"
	Case cTipo == "png"
		cConteudo := "image/png"
	Case cTipo == "jpg"
		cConteudo := "image/jpeg"
	Case cTipo == "gif"
		cConteudo := "image/gif"
	Case cTipo == "mp3"
		cConteudo := "audio/mpeg"
	Case cTipo == "mp4"
		cConteudo := "video/mp4"
	Case cTipo == "wmv"
		cConteudo := "video/x-ms-wmv"
	EndCase
RETURN cConteudo
