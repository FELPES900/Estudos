#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'

Function u_GCTA01FF()

	Local oBrowse as Object

	// Instancia da classe do browse
	oBrowse := FWmBrowse():New()

	// Definição da tabela
	oBrowse:SetAlias( 'SZ2' )

	// Titulo do Browse
	oBrowse:SetDescription( 'Contratos' )

	oBrowse:SetMenuDef("GCTA01FF")

	oBrowse:AddLegend( "Z2_STATUS=='1'", "GREEN"  , "Aberto"    )
	oBrowse:AddLegend( "Z2_STATUS=='2'", "YELLOW" , "Andamento" )
	oBrowse:AddLegend( "Z2_STATUS=='3'", "RED"    , "Finalizado")

	oBrowse:Activate()

Return NIL

Static Function MenuDef()

	Local aRotina := {} as Array

	ADD OPTION aRotina Title 'Visualizar'  Action 'VIEWDEF.GCTA01FF' OPERATION 2 ACCESS 0
	ADD OPTION aRotina Title 'Incluir'     Action 'VIEWDEF.GCTA01FF' OPERATION 3 ACCESS 0
	ADD OPTION aRotina Title 'Alterar'     Action 'VIEWDEF.GCTA01FF' OPERATION 4 ACCESS 0
	ADD OPTION aRotina Title 'Excluir'     Action 'VIEWDEF.GCTA01FF' OPERATION 5 ACCESS 0

Return aRotina

Static Function ModelDef()

	// Cria a estrutura a ser usada no Modelo de Dados
	Local oStruSZ2 := FWFormStruct( 1, 'SZ2' , /*bAvalCampo*/, /*lViewUsado*/ ) as Object
	Local oStruSZ3 := FWFormStruct( 1, 'SZ3' , /*bAvalCampo*/, /*lViewUsado*/ ) as Object
	Local oModel                                                                as Object

	// Cria o objeto do Modelo de Dados
	oModel := MPFormModel():New( 'GCTM01FF', /*bPreValidacao*/, /*bPosValidacao*/, /*bCommit*/, /*bCancel*/ )

	// Adiciona ao modelo uma estrutura de formulÃ¡rio de ediÃ§Ã£o por campo
	oModel:AddFields( 'SZ2MASTER', /*cOwner*/, oStruSZ2 )

	// Adiciona ao modelo uma estrutura de formulÃ¡rio de ediÃ§Ã£o por grid
	oModel:AddGrid( 'SZ3DETAIL', 'SZ2MASTER', oStruSZ3, /*bLinePre*/, /*bLinePost*/, /*bPreVal*/, /*bPosVal*/, /*BLoad*/ )

	// Faz relaciomaneto entre os compomentes do model
	oModel:SetRelation( 'SZ3DETAIL', { { 'Z3_FILIAL', 'xFilial( "SZ2" )' }, { 'Z3_CODCON', 'Z2_CODCON' } }, SZ3->( IndexKey( 1 ) ) )

	// Liga o controle de nao repeticao de linha
	oModel:GetModel( 'SZ3DETAIL' ):SetUniqueLine( { 'Z3_CODPROD' } )

	// Adiciona a descricao do Modelo de Dados
	oModel:SetDescription( 'Contratos' )

	// Adiciona a descricao do Componente do Modelo de Dados
	oModel:GetModel( 'SZ2MASTER' ):SetDescription( 'Contato' )
	oModel:GetModel( 'SZ3DETAIL' ):SetDescription( 'Produtos do contrato'  )

	// Campos travados ou nao travados --> validando com o tipo de contrato
	oStruSZ2:SetProperty("Z2_LFISICO",MODEL_FIELD_WHEN,{|oModel| valida(oModel,1)})
	oStruSZ2:SetProperty("Z2_CLIFISI",MODEL_FIELD_WHEN,{|oModel| valida(oModel,1)})
	oStruSZ2:SetProperty("Z2_LFISCA" ,MODEL_FIELD_WHEN,{|oModel| valida(oModel,2)})
	oStruSZ2:SetProperty("Z2_CFISCAL",MODEL_FIELD_WHEN,{|oModel| valida(oModel,2)})

	// calcula quanto de saldo tem disponivel
	oStruSZ3:AddTrigger( 'Z3_QORIGIN', 'Z3_QSALDO', {||.T. }, {||u_AttSaldo(oModel)} )
	oStruSZ3:AddTrigger( 'Z3_QSAIDA', 'Z3_QSALDO', {||.T. }, {||u_AttSaldo(oModel)} )

	// Define a chave primaria
	oModel:SetPrimaryKey({"Z2_FILIAL","Z2_CODCON"})

Return oModel

//-------------------------------------------------------------------
Static Function ViewDef()

	// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
	Local oStruSZ2 := FWFormStruct( 2, 'SZ2' )  as Object
	Local oStruSZ3 := FWFormStruct( 2, 'SZ3' )  as Object
	// Cria a estrutura a ser usada na View
	Local oModel   := FWLoadModel( 'GCTA01FF' ) as Object
	Local oView                                 as Object

	// Remove o campo da grid
	oStruSZ3:RemoveField('Z3_CODCON')

	// Cria o objeto de View
	oView := FWFormView():New()

	// Define qual o Modelo de dados serão utilizado
	oView:SetModel( oModel )

	//Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
	oView:AddField( 'VIEW_SZ2', oStruSZ2, 'SZ2MASTER' )

	//Adiciona no nosso View um controle do tipo FormGrid(antiga newgetdados)
	oView:AddGrid(  'VIEW_SZ3', oStruSZ3, 'SZ3DETAIL' )

	// Criar um "box" horizontal para receber algum elemento da view
	oView:CreateHorizontalBox( 'SUPERIOR', 45 )
	oView:CreateHorizontalBox( 'INFERIOR', 55 )

	// Relaciona o ID da View com o "box" para exibicao
	oView:SetOwnerView( 'VIEW_SZ2', 'SUPERIOR' )
	oView:SetOwnerView( 'VIEW_SZ3', 'INFERIOR' )

Return oView

Static Function valida(oModel, nValor)
	Local lRet  := .F.  as Logical
	
	If((oModel:GetValue("Z2_TIPOCON") == "1" .and. nValor == 1) .or. (oModel:GetValue("Z2_TIPOCON") == "2" .and. nValor == 2))
		lRet := .T.
	endif

Return lRet

Function u_attsaldo(oModel)

	Local nValor := 0               
	Local oMdlSZ3 := oModel:GetModel('SZ3DETAIL')

	nValor := oMdlSZ3:GetValue("Z3_QORIGIN") - oMdlSZ3:GetValue("Z3_QSAIDA")

	if(nValor < 0)
		Help("",1,,ProcName(),"A quantidade de saldo não pode ser menor do que Zero",1,0)
		nValor := 0
	Endif

Return nValor
