#INCLUDE "TOTVS.CH"
#include "fwmvcdef.ch"

/*/{Protheus.doc} Function U_FFS003FF
Fonte MVC que vai relocionar o pedido de venda
com documento de entrada e com titulos a pagar
@type  Function
@author user
@since 09/08/2023
@version 12.1.2210
/*/
Function U_FFS003FF()

	FWExecView( 'Operadora', "VIEWDEF.FFS003FF", 1, , { || .T. }, ,)

Return

Static Function ModelDef()

	Local aSD1Relacion := {}
	Local aSE1Relacion := {}
	Local oModel
	local oStrField
	Local oStruSC7     := FWFormStruct( 1, 'SC7' )
	Local oStruSD1     := FWFormStruct( 1, 'SD1' )
	Local oStruSE2     := FWFormStruct( 1, 'SE2' )

	oStrField := FWFormModelStruct():New()

	oStrField:addTable("", {"C_STRING1"}, "Grid MVC sem cabeçalho", {|| ""})
	oStrField:addField("String 01", "Campo de texto", "C_STRING1", "C", 15)

	// Cria o objeto do Modelo de Dados
	oModel := MPFormModel():New( 'FFA003FF')

	oModel:addFields("CABID", /*cOwner*/, oStrField, /*bPre*/, /*bPost*/, {|oModel| loadHidFld()})

	// Pedido de Compra
	oModel:AddGrid("SC7MASTER", "CABID", oStruSC7 ,/*bLinePre*/, /*blinepost*/, /*bPre*/, /*bPost*/, {|oModel| loadGridSC7(oModel)})

	// Documentos amarrado com Pedido
	oModel:AddGrid("SD1DETAIL", "SC7MASTER", oStruSD1)

	// Titulos amarrados com o Documento em especifico
	oModel:AddGrid("SE2DETAIL", "SD1DETAIL", oStruSE2)

	aAdd(aSD1Relacion,{'D1_FILIAL',"FWxFilial('SC7')"})
	aAdd(aSD1Relacion,{'D1_PEDIDO',"C7_NUM"})

	aAdd(aSE1Relacion,{'E2_FILIAL','FWxFilial("SD1")'})
	aAdd(aSE1Relacion,{'E2_PREFIXO','D1_SERIE'})
	aAdd(aSE1Relacion,{'E2_NUM','D1_DOC'})
	aAdd(aSE1Relacion,{'E2_FORNECE','D1_FORNECE'})
	aAdd(aSE1Relacion,{'E2_LOJA','D1_LOJA'})

	oModel:SetRelation('SD1DETAIL',aSD1Relacion,SD1->( IndexKey(1)))
	oModel:SetRelation('SE2DETAIL',aSE1Relacion,SE2->( IndexKey(1)))

	oModel:SetDescription( 'Pedido/Documento/Titulo' )

	oModel:GetModel( 'SC7MASTER' ):SetDescription( 'Pedido de Compra' )
	oModel:GetModel( 'SD1DETAIL' ):SetDescription( 'Documento de Entrada'  )
	oModel:GetModel( 'SE2DETAIL' ):SetDescription( 'Titulos a Pagar'  )

	oModel:SetPrimaryKey({})

Return oModel

Static Function ViewDef()

	Local aSC7     := {}
	Local nX       := 0
	Local oModel   := FwLoadModel("FFS003FF")
	local oStrCab  := FWFormViewStruct():New()
	Local oStruSC7 := FWFormStruct( 2, 'SC7' )
	Local oStruSD1 := FWFormStruct( 2, 'SD1' )
	Local oStruSE2 := FWFormStruct( 2, 'SE2' )
	Local oView    := FwFormView():New()

	aSC7 := FWSX3Util():GetAllFields( "SC7" , .T. )

	oStrCab:addField("C_STRING1", "01" , "String 01", "Campo de texto", , "C" )

	oView:SetModel(oModel)

	oView:AddField("CAB", oStrCab, "CABID")
	oView:AddGrid("VIEW_SC7", oStruSC7, "SC7MASTER")
	oView:AddGrid( "VIEW_SD1", oStruSD1, "SD1DETAIL")
	oView:AddGrid( "VIEW_SE2", oStruSE2, "SE2DETAIL")

	For nX := 1 to Len(aSC7)
		IIF(aSC7[nX] $ "C7_ITEM|C7_PRODUTO|C7_UM|C7_QUANT|C7_PRECO|C7_TOTAL|C7_LOJA|C7_COND|C7_NUM",,oStruSC7:RemoveField(aSC7[nX]))
	Next

	oStruTRB1:AddField(;
		"Data Envio",;                                                                                   // [01]  C   Titulo do campo //"Tip. Doc."
	"Data Envio",;                                                                                   // [02]  C   ToolTip do campo //"Tip. Doc."
	"DATAINF",;                                                                                  // [03]  C   Id do Field
	"D",;                                                                                       // [04]  C   Tipo do campo
	08,;                                                                                        // [05]  N   Tamanho do campo
	0,;                                                                                         // [06]  N   Decimal do campo
	Nil,;                                                                                       // [07]  B   Code-block de validação do campo
	Nil,;                                                                                       // [08]  B   Code-block de validação When do campo
	{},;                                                                                        // [09]  A   Lista de valores permitido do campo
	.F.,;                                                                                       // [10]  L   Indica se o campo tem preenchimento obrigatório
	Nil,;                                                                                       // [11]  B   Code-block de inicializacao do campo
	.F.,;                                                                                       // [12]  L   Indica se trata-se de um campo chave
	.F.,;                                                                                       // [13]  L   Indica se o campo pode receber valor em uma operação de update.
	.F.)


	oView:CreateFolder('ABAS')
	oView:AddSheet('ABAS', 'ABA_SC7', 'Pedido_de_Compra')
	oView:AddSheet('ABAS', 'ABA_SD1', 'Documentos_do_Pedido')
	oView:AddSheet('ABAS', 'ABA_SE2', 'Titulos_do_Documento')

	oView:createHorizontalBox( "TOHIDE"  ,0   ,/*owner*/, /*lUsePixel*/, 'ABAS', 'ABA_SC7')
	oView:createHorizontalBox( "TOSHOW"  ,100 ,/*owner*/, /*lUsePixel*/, 'ABAS', 'ABA_SC7')
	oView:CreateHorizontalBox( 'BOX_SD1' ,100, /*owner*/, /*lUsePixel*/, 'ABAS', 'ABA_SD1')
	oView:CreateHorizontalBox( 'BOX_SE2' ,100, /*owner*/, /*lUsePixel*/, 'ABAS', 'ABA_SE2')


	oView:setOwnerView("CAB", "TOHIDE" )
	oView:setOwnerView("VIEW_SC7", "TOSHOW")
	oView:SetOwnerView('VIEW_SD1','BOX_SD1')
	oView:SetOwnerView('VIEW_SE2','BOX_SE2')

Return oView

Static Function loadHidFld(oModel)
return {""}

Static Function loadGridSC7(oModel)

	local aData      := {}
	local cAlias     := ""
	local cTablename := ""
	local cWorkArea  := ""

	cWorkArea := Alias()
	cAlias := GetNextAlias()
	cTablename := "%" + RetSqlName("SC7") + "%"

	BeginSql Alias cAlias
		SELECT *, R_E_C_N_O_ RECNO FROM %exp:cTablename% WHERE D_E_L_E_T_ = ' ' ORDER BY C7_NUM
	EndSql

	aData := FwLoadByAlias(oModel, cAlias, "SC7", "RECNO", /*lCopy*/, .T.)

	(cAlias)->(DBCloseArea())

	if !Empty(cWorkArea) .And. Select(cWorkArea) > 0
		DBSelectArea(cWorkArea)
	endif

return aData
