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

	//Adiciona um campo a estrutura.
	oStruSC7:AddField( 'C7_EMISSAO' , 'C7_EMISSAO' , 'C7_EMISSAO' , 'D' , 8 )
	oStruSC7:AddField( 'C7_FORNECE' , 'C7_FORNECE' , 'C7_FORNECE' , 'C' , 6 )
	oStruSC7:AddField( 'C7_LOJA'    , 'C7_LOJA'    , 'C7_LOJA'    , 'C' , 2 )
	oStruSC7:AddField(;
		"C7_XFORNE",;                                                           // [01]  C   Titulo do campo //"Cod. Revisão"
	"C7_XFORNE",;                                                               // [02]  C   ToolTip do campo //"Cod. Revisão"
	"C7_XFORNE",;                                                               // [03]  C   Id do Field
	"C",;                                                                       // [04]  C   Tipo do campo
	40,;                                                                        // [05]  N   Tamanho do campo
	0,;                                                                         // [06]  N   Decimal do campo
	Nil,;                                                                       // [07]  B   Code-block de validação do campo
	Nil,;                                                                       // [08]  B   Code-block de validação When do campo
	{},;                                                                        // [09]  A   Lista de valores permitido do campo
	.F.,;                                                                       // [10]  L   Indica se o campo tem preenchimento obrigatório
	{|oModel| Posicione("SA2",1,FWxFilial("SA2");
		+ SC7->C7_FORNECE;
		+ SC7->C7_LOJA,"A2_NOME")},;        // [11]  B   Code-block de inicializacao do campo
	.F.,;                                                                       // [12]  L   Indica se trata-se de um campo chave
	.F.,;                                                                       // [13]  L   Indica se o campo pode receber valor em uma operação de update.
	.T.)                                                                        // [14]  L   Indica se o campo é virtual

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
		IIF(aSC7[nX] $ "C7_ITEM|C7_PRODUTO|C7_FORNECE|C7_UM|C7_XFORNE|C7_QUANT|C7_PRECO|C7_TOTAL|C7_EMISSAO|C7_LOJA|C7_COND|C7_NUM",,oStruSC7:RemoveField(aSC7[nX]))
	Next

	oStruSC7:AddField(;
		"C7_FORNECE",;        // [01]  C   Nome do Campo
	"6",;                      // [02]  C   Ordem
	"Fornecedor  ",;            // [03]  C   Titulo do campo //"Tip. Doc."
	"Fornecedor  ",;            // [04]  C   Descricao do campo //"Tip. Doc."
	Nil,;                     // [05]  A   Array com Help
	"C",;                     // [06]  C   Tipo do campo
	"",;                      // [07]  C   Picture
	Nil,;                     // [08]  B   Bloco de PictTre Var
	Nil,;                     // [09]  C   Consulta F3
	.F.,;                     // [10]  L   Indica se o campo é alteravel
	Nil,;                     // [11]  C   Pasta do campo
	Nil,;                	  // [12]  C   Agrupamento do campo
	Nil,;                     // [13]  A   Lista de valores permitido do campo (Combo)
	Nil,;                     // [14]  N   Tamanho maximo da maior opção do combo
	Nil,;                     // [15]  C   Inicializador de Browse
	Nil,;                     // [16]  L   Indica se o campo é virtual
	Nil,;                     // [17]  C   Picture Variavel
	Nil)                      // [18]  L   Indica pulo de linha após o campo

	oStruSC7:AddField(;
		"C7_XFORNE",;        // [01]  C   Nome do Campo
	"7",;                      // [02]  C   Ordem
	"Nome Forne  ",;            // [03]  C   Titulo do campo //"Tip. Doc."
	"Nome Forne  ",;            // [04]  C   Descricao do campo //"Tip. Doc."
	Nil,;                     // [05]  A   Array com Help
	"C",;                     // [06]  C   Tipo do campo
	"",;                      // [07]  C   Picture
	Nil,;                     // [08]  B   Bloco de PictTre Var
	Nil,;                     // [09]  C   Consulta F3
	.F.,;                     // [10]  L   Indica se o campo é alteravel
	Nil,;                     // [11]  C   Pasta do campo
	Nil,;                	  // [12]  C   Agrupamento do campo
	Nil,;                     // [13]  A   Lista de valores permitido do campo (Combo)
	Nil,;                     // [14]  N   Tamanho maximo da maior opção do combo
	Nil,;                     // [15]  C   Inicializador de Browse
	.T.,;                     // [16]  L   Indica se o campo é virtual
	Nil,;                     // [17]  C   Picture Variavel
	Nil)                      // [18]  L   Indica pulo de linha após o campo

	oStruSC7:AddField(;
		"C7_LOJA",;        // [01]  C   Nome do Campo
	"8",;                      // [02]  C   Ordem
	"Loja  ",;          // [03]  C   Titulo do campo //"Tip. Doc."
	"Loja  ",;          // [04]  C   Descricao do campo //"Tip. Doc."
	Nil,;                     // [05]  A   Array com Help
	"C",;                     // [06]  C   Tipo do campo
	"",;                      // [07]  C   Picture
	Nil,;                     // [08]  B   Bloco de PictTre Var
	Nil,;                     // [09]  C   Consulta F3
	.F.,;                     // [10]  L   Indica se o campo é alteravel
	Nil,;                     // [11]  C   Pasta do campo
	Nil,;                	  // [12]  C   Agrupamento do campo
	Nil,;                     // [13]  A   Lista de valores permitido do campo (Combo)
	Nil,;                     // [14]  N   Tamanho maximo da maior opção do combo
	Nil,;                     // [15]  C   Inicializador de Browse
	Nil,;                     // [16]  L   Indica se o campo é virtual
	Nil,;                     // [17]  C   Picture Variavel
	Nil)                      // [18]  L   Indica pulo de linha após o campo

	oStruSC7:AddField(;
		"C7_EMISSAO",;        // [01]  C   Nome do Campo
	"9",;                      // [02]  C   Ordem
	"Dt. Emissao  ",;          // [03]  C   Titulo do campo //"Tip. Doc."
	"Dt. Emissao  ",;          // [04]  C   Descricao do campo //"Tip. Doc."
	Nil,;                     // [05]  A   Array com Help
	"C",;                     // [06]  C   Tipo do campo
	"",;                      // [07]  C   Picture
	Nil,;                     // [08]  B   Bloco de PictTre Var
	Nil,;                     // [09]  C   Consulta F3
	.F.,;                     // [10]  L   Indica se o campo é alteravel
	Nil,;                     // [11]  C   Pasta do campo
	Nil,;                	  // [12]  C   Agrupamento do campo
	Nil,;                     // [13]  A   Lista de valores permitido do campo (Combo)
	Nil,;                     // [14]  N   Tamanho maximo da maior opção do combo
	Nil,;                     // [15]  C   Inicializador de Browse
	Nil,;                     // [16]  L   Indica se o campo é virtual
	Nil,;                     // [17]  C   Picture Variavel
	Nil)                      // [18]  L   Indica pulo de linha após o campo

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
