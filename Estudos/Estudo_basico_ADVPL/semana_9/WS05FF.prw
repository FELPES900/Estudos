#INCLUDE 'TOTVS.CH'
#INCLUDE "RESTFUL.CH"

WSRESTFUL GETVISION DESCRIPTION "A Classe WS para envio de arquivo" FORMAT APPLICATION_JSON

	WSMETHOD GET DESCRIPTION "Mostrar itens relacionados a mais de uma tabela" PATH "/itens/relacionadosz"

END WSRESTFUL

WSMETHOD GET WSRECEIVE WSSERVICE GETVISION

	local lRet    := .T.            as Logical
	local oJson   := Nil            as Object
	Local cJson   := self:GetContent() as Character
	Local aArea   := GetArea()      as Array
	Local cAlias  := GetNextAlias() as Character
	Local nLoop   := 0              as Numeric
	Local aTDP    := {}             as Array // Tabela de Preço
	Local cCodigo := ""             as Character

	self:SetContentType("application/json")
	oJson   := JsonObject():New()
	cError  := oJson:FromJson(cJson)
	cCodigo := self:aURLParms[3]
	if Empty(cError)
		if(cCodigo <> Nil)
			BeginSQL Alias cAlias
                SELECT
                    DA0_DESCRI,
                    DA0_CODTAB,
                    DA1_PRCVEN,
                    DA1_QTDLOT
                FROM
                    %Table:DA1% DA1
                    LEFT JOIN %Table:DA0% DA0 ON DA1_FILIAL = DA0_FILIAL
                    AND DA1_CODTAB = DA0_CODTAB
                WHERE
                    DA1_CODPRO = %exp:cCodigo%
                    AND %notdel%
                    AND DA1.D_E_L_E_T_ = ''
                    AND DA0_ATIVO = '1'
			ENDSQL
			while !(cAlias)->(Eof())
				nLoop++
				aAdd(aTDP,JsonObject():New())
				aTDP[nloop]["Descrição"]      := AllTrim((cAlias)->DA0_DESCRI)
				aTDP[nloop]["Cod. Tabela"]    := AllTrim((cAlias)->DA0_CODTAB)
				aTDP[nloop]["Preço de venda"] := (cAlias)->DA1_PRCVEN
				aTDP[nloop]["Faixa"]          := (cAlias)->DA1_QTDLOT
				(cAlias)->(dbSkip())
			end
		else
			SetRestFault(404,EncodeUTF8("Por favor informar o codigo do produto // EX: 'codigo : '000000000000010''"))
			lRet := .F.
		endif
	endif
	oJson['Tabela de Preços'] := aTDP
	self:SetResponse(oJson:toJson()) // retorno de um objeto JSON
	RestArea(aArea)
Return lRet
