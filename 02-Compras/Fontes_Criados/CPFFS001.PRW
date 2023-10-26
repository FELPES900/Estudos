#include "TOTVS.CH"
#include "FWMBROWSE.ch"
#INCLUDE "FWMVCDEF.CH"

/*/{Protheus.doc} CPFFS001
Limite dos Produtos
@type function
@version 12.1.2210
@author Felipe Fraga
@since 04/10/2023
@return variant, return
/*/
User Function CPFFS001()

	Local oBrowse

	oBrowse := FWMBrowse():New()

	oBrowse:SetAlias('SZ1')

	oBrowse:SetDescription("Limites dos Produtos")

	oBrowse:SetMenuDef("CPFFS001")

	oBrowse:ACTIVATE()

Return

Static Function MenuDef()

	Local aRotina := {}

	ADD OPTION aRotina TITLE 'Pesquisar'  ACTION 'PesqBrw'		   OPERATION 1 ACCESS 0
	ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.CPFFS001' OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.CPFFS001' OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.CPFFS001' OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.CPFFS001' OPERATION 5 ACCESS 0

Return aRotina

Static Function ModelDef()

	Local oModel := Nil
	Local oStSZ1 := Nil

	oModel := MPFormModel():New("CPFFS001M")

	oStSZ1 := FWFormStruct(1, "SZ1")

	oModel:AddFields("SZ1_MASTER",/*owner*/,oStSZ1)

	oModel:SetDescription("Inclui limite nos produtos")

	oModel:GetModel("SZ1_MASTER"):SetDescription("Limite do Produto")

	oModel:SetPrimaryKey({})

Return oModel

Static Function ViewDef()

	Local oView  := Nil
	Local oModel := Nil
	Local oStSZ1 := Nil

	oModel := FWLoadModel("CPFFS001")

	oStSZ1 := FWFormStruct(2, "SZ1")

	oView := FWFormView():New()

	oView:SetModel(oModel)

	oView:AddField("VIEW_SZ1", oStSZ1, "SZ1_MASTER")

	oView:CreateHorizontalBox( 'TELA' , 100 )

	oView:SetOwnerView("VIEW_SZ1", "TELA")

Return oView
