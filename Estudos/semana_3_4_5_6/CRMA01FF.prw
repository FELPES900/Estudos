#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'

/*/{Protheus.doc} CRMA01FF
MVC simples
@type function
@version 33  
@author felip
@since 10/10/2022
/*/


Function U_CRMA01FF()

	Local oBrowse

	// Instancia da classe do browse
	oBrowse := FWMBrowse():New()

	// Definição da tabela
	oBrowse:SetAlias('SZ1')

	// Titulo do Browse
	oBrowse:SetDescription('Clientes Auxiliars')

	oBrowse:SetMenuDef("CRMA01FF")

	// Status do cliente
	oBrowse:AddLegend( "Z1_STATUS=='1'" , "GREEN", "ativo"   )
	oBrowse:AddLegend( "Z1_STATUS=='2'", "RED"  , "Inativo" )

	oBrowse:Activate()

Return NIL

//-------------------------------------------------------------------
/*/{Protheus.doc} MenuDef
Model Somente para importação
@type function
@version 33 
@author felip
@since 13/10/2022
@return variant, return_aRotina
/*/

Static Function MenuDef()
	Local aRotina := {}

	ADD OPTION aRotina TITLE 'Importar'   ACTION 'U_IMPOR01F()'       OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.CRMA01FF'   OPERATION 2 ACCESS 0

Return aRotina

//-------------------------------------------------------------------
/*/{Protheus.doc} ModelDef
In terface simples
@type function
@version 33
@author felip
@since 13/10/2022
@return variant, return_oModel
/*/

Static Function ModelDef()

	// Cria a estrutura a ser usada no Modelo de Dados
	Local oStruSZ1
	Local oModel

	// Carregar as estruturas do dicionario de dados para o objetivo do modelo
	oStruSZ1 := FWFormStruct( 1, 'SZ1')

	// Cria o objeto do Modelo de Dados
	oModel := MPFormModel():New('CRMM01FF', /*bPreValidacao*/, /*bPosValidacao*/, /*bCommit*/, /*bCancel*/ )
	//oModel := MPFormModel():New('COMP011MODEL', /*bPreValidacao*/, { |oMdl| COMP011POS( oMdl ) }, /*bCommit*/, /*bCancel*/ )

	// // Adiciona ao modelo uma estrutura de formulário de edição por campo
	oModel:AddFields( 'SZ1MASTER', /*cOwner*/, oStruSZ1, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

	// Adiciona a descricao do Modelo de Dados
	oModel:SetDescription( 'Modelo de Dados de Autor/Interprete' )

	// // Adiciona a descricao do Componente do Modelo de Dados
	oModel:GetModel( 'SZ1MASTER' ):SetDescription( 'Dados de Autor/Interprete' )

	// Liga a validação da ativacao do Modelo de Dados
	//oModel:SetVldActivate( { |oModel| COMP011ACT( oModel ) } )

Return oModel


//-------------------------------------------------------------------
/*/{Protheus.doc} ViewDef
ViewDef
@type function
@version 33
@author felip
@since 13/10/2022
@return variant, return_oView
/*/

Static Function ViewDef()

	// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
		Local oModel   := FWLoadModel( 'CRMA01FF' )

	// Cria a estrutura a ser usada na View
		Local oStruSZ1 := FWFormStruct( 2, 'SZ1' )

	//Local oStruSZ1 := FWFormStruct( 2, 'SZ1', { |cCampo| COMP11STRU(cCampo) } )
		Local oView

	// Cria o objeto de View
		oView := FWFormView():New()

	// Define qual o Modelo de dados será utilizado
		oView:SetModel( oModel )

	//Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
		oView:AddField( 'VIEW_SZ1', oStruSZ1, 'SZ1MASTER' )

	// Criar um "box" horizontal para receber algum elemento da view
		oView:CreateHorizontalBox( 'TELA' , 100 )

	// Relaciona o ID da View com o "box" para exibicao
		oView:SetOwnerView( 'VIEW_SZ1', 'TELA' )


Return oView
