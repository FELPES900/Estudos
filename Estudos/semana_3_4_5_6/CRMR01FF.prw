#INCLUDE "TOTVS.CH"


/*/{Protheus.doc} CRMR01FF
    Relatorio de Clientes Auxiliar
    @type function
    @version 33
    @author felip
    @since 15/10/2022
/*/

User Function CRMR01FF()

	Local oRelato
	Private cPerg := PadR('CRMR01FF',10)
	//Retorna um alias para ser utilizado no record set definido em PadR()
	Private cAlias := GetNextAlias()
	Private oSection1

	oRelato := ReportDef()

	// Tela de impressão do relatório
	oRelato:PrintDialog()

Return

/*/{Protheus.doc} ReportDef
    ReportDef
    @type Function
    @author Felipe
    @since 15/10/2022
    @version 33
/*/
Static Function ReportDef()

	Local oReport

	// Primeiros abriremos um browse para fazer as perguntas
	Pergunte(cPerg, .T.)

	oReport := TReport():New(cPerg,'Relação de clientes',cPerg,{||ReportPrint()},,.T.)

	// Define a orientação de página do relatório como Paisagem
	oReport:SetLandScape(.T.)

	// Define se será permitida a alteração dos parâmetros do relatório
	oReport:HideParamPage()

	oSection1 := TRSection():New(oReport,"????? ??? ???? ??? ???? ?????", {cAlias})
	IF(MV_PAR05 <> 1)
		TRCell():New(oSection1, 'Z1_FILIAL', cAlias)
		TRCell():New(oSection1, 'Z1_IDCLI' , cAlias)
		TRCell():New(oSection1, 'Z1_EMAIL' , cAlias)
		TRCell():New(oSection1, 'Z1_PRNOME', cAlias)
		TRCell():New(oSection1, 'Z1_UTNOME', cAlias)
		TRCell():New(oSection1, 'Z1_PAIS'  , cAlias)
		TRCell():New(oSection1, 'Z1_GENERO', cAlias)
		TRCell():New(oSection1, 'Z1_IPREDE', cAlias)
	ELSE
		TRCell():New(oSection1, 'Z1_FILIAL', cAlias)
		TRCell():New(oSection1, 'Z1_IDCLI' , cAlias)
		TRCell():New(oSection1, 'Z1_PAIS'  , cAlias)
	ENDIF

Return oReport

/*/{Protheus.doc} ReportPrint
    Consulta SQL
    @type function
    @version 33
    @author felip
    @since 18/10/2022
/*/
static function ReportPrint()

	// 1- primeiro valida como vai ser inprimido os dados
	IF(MV_PAR05 <> 1)

		BeginSql Alias cAlias
                SELECT
                    Z1_FILIAL,
                    Z1_IDCLI,
                    CONVERT(varchar(5000),Z1_EMAIL) Z1_EMAIL,
                    Z1_PRNOME,
                    Z1_UTNOME,
                    Z1_PAIS,
                    Z1_GENERO,
                    Z1_IPREDE
                FROM
                    %Table:SZ1% SZ1
                WHERE Z1_FILIAL BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
                AND   Z1_PAIS BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
                AND SZ1.%NotDel%

		ENDSQL

	ELSE

		BeginSql Alias cAlias
                SELECT
                    Z1_FILIAL,
                    COUNT(Z1_IDCLI) Z1_IDCLI,
                    Z1_PAIS
                FROM
                    %Table:SZ1% SZ1
                WHERE Z1_FILIAL BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
                AND   Z1_PAIS BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
                AND SZ1.%NotDel%
                GROUP BY Z1_FILIAL,
                        Z1_PAIS
                ORDER BY Z1_PAIS

		ENDSQL

	ENDIF


	// 2 - impressão do relatório
	oSection1:Print()
return
