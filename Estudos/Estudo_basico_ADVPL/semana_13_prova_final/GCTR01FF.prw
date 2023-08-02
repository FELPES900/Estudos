/*/                                                                                                                                                                                {Protheus.doc} u_GCTR01FF
Relatorio dos contratos
@type function
@version 33
@author felip
@since 12/12/2022
/*/

Function u_GCTR01FF()

	Local oRelato
	Private cAlias1 := GetNextAlias()
	Private cAlias2 := GetNextAlias()
	Private cPerg  := PadR( 'GCTR01FF' ,10)
	Private oBreak
	Private oSection1
	Private oSection2

	// Browse de perguntas no relatorio
	Pergunte(cPerg, .T.)

	// Interface de impressão
	oRelato := ReportDef(cAlias1,cPerg)

	// Tela de impressão do relatorio
	oRelato:PrintDialog()

	if(SELECT(cAlias1) > 0)
		(cAlias1)->(dbCloseArea())
	Endif


Return

Static Function ReportDef(cAlias1, cPerg)

	Local oReport

	oReport := TReport():New(cPerg, 'Relatório de Contratos', cPerg, {|oReport| ReportPrint(oReport,cAlias1)}, '',)

	// Define orientação de página do relatório como retrato
	oReport:SetPortrait()

	// Define se os totalizadores serão impressos em linha ou coluna
	oReport:SetTotalInLine(.F.)
	oReport:oPage:SetPaperSize(9)

	// Criando um cabaeçalho de como o relatorio será gerado
	oSection1 := TRSection():New(oReport, "Contrato", {cAlias1})
	// Contato
	oSection1:SetTotalInLine(.F.)
	TRCell():New(oSection1, "Z2_CODCON" , cAlias1, "Cod Contrato", "@!", 10 , .F.)
	TRCell():New(oSection1, "Z2_DINICIO", cAlias1, "Data Inicio" , "@!", 8  , .F.)
	TRCell():New(oSection1, "Z2_DFINAL" , cAlias1, "Data Final"  , "@!", 8  , .F.)
	TRCell():New(oSection1, "Z2_CFISCAL", cAlias1, "Client "     , "@!", 6  , .F.)
	TRCell():New(oSection1, "Z2_LFISICO", cAlias1, "Loja "       , "@!", 2  , .F.)
	TRCell():New(oSection1, "Z2_NCFISCA", cAlias1, "Nome Cliente", "@!", 50 , .F.)

	// Produto relacionados ao contrato
	oSection2 := TRSection():New(oReport, "Contrato", {cAlias2})
	oSection2:SetTotalInLine(.F.)
	TRCell():New(oSection2, "Z3_CODPROD", cAlias2, "Cod Produto"   , "@!"           , 20 , .F.)
	TRCell():New(oSection2, "Z3_NOME"   , cAlias2, "Nome"          , "@!"           , 50 , .F.)
	TRCell():New(oSection2, "Z3_QORIGIN", cAlias2, "Quant Original", "@E 999,999.99", 11 , .F.)
	TRCell():New(oSection2, "Z3_QSAIDA" , cAlias2, "Quant Saida"   , "@E 999,999.99", 11 , .F.)
	TRCell():New(oSection2, "Z3_QSALDO" , cAlias2, "Quant Saldo"   , "@E 999,999.99", 11 , .F.)

	// Totalizador por contrato
	// oBreak := TRBreak():New(oSection1,oSection1:Cell("Z2_CODCON"),"Sub Total",.f.)
	TRFunction():New(oSection2:Cell("Z3_QORIGIN"), "", "SUM",, "Total", "@E 999,999.99",, .T., .T.)
	TRFunction():New(oSection2:Cell("Z3_QSAIDA") , "", "SUM",, "Total", "@E 999,999.99",, .T., .T.)
	TRFunction():New(oSection2:Cell("Z3_QSALDO") , "", "SUM",, "Total", "@E 999,999.99",, .T., .T.)

Return oReport

Static Function ReportPrint(oReport,cAlias1)


	BeginSql Alias cAlias1

        SELECT
            Z2_FILIAL,
            Z2_CODCON,
            Z2_DINICIO,
            Z2_DFINAL,
            Z2_CLIFISI,
            Z2_LFISICO,
            Z2_NCFISIC,
            Z2_CFISCAL,
            Z2_LFISCA,
            Z2_NCFISCA
        FROM
            %Table:SZ2% SZ2
        WHERE
            SZ2.%NOTDEL%
			AND Z2_FILIAL = %exp:cFilant%
			AND Z2_DINICIO BETWEEN %exp:mv_par01% AND %exp:mv_par02%
            AND (
                   	Z2_CLIFISI BETWEEN %exp:mv_par03% AND %exp:mv_par04%
                OR Z2_CFISCAL BETWEEN %exp:mv_par03% AND %exp:mv_par04%
            )
            AND (
                	Z2_LFISICO BETWEEN %exp:mv_par05% AND %exp:mv_par06%
                OR Z2_LFISCA BETWEEN %exp:mv_par05% AND %exp:mv_par06%
            )
        ORDER BY
            Z2_CODCON
	EndSql

	While (cAlias1)->(!Eof())

		if(oReport:Cancel())
			MsgInfo("Operação cancelada pelo o usuário.","ATENÇÃO!")
			Exit
		endif

		if(!Empty((cAlias1)->Z2_CLIFISI))

			// Contrato
			oSection1:init()
			oSection2:init()
			oSection1:Cell("Z2_CFISCAL"):SetHeaderAlign("left")
			oSection1:Cell("Z2_CFISCAL"):SetAlign("right")
			oSection1:Cell("Z2_CFISCAL"):SetValue((cAlias1)->Z2_CLIFISI)

			oSection1:Cell("Z2_LFISICO"):SetHeaderAlign("left")
			oSection1:Cell("Z2_LFISICO"):SetAlign("right")
			oSection1:Cell("Z2_LFISICO"):SetValue((cAlias1)->Z2_LFISICO)

			oSection1:Cell("Z2_NCFISCA"):SetHeaderAlign("left")
			oSection1:Cell("Z2_NCFISCA"):SetAlign("right")
			oSection1:Cell("Z2_NCFISCA"):SetValue((cAlias1)->Z2_NCFISIC)
		else

			oSection1:init()
			oSection2:init()

			oSection1:Cell("Z2_CFISCAL"):SetHeaderAlign("left")
			oSection1:Cell("Z2_CFISCAL"):SetAlign("right")
			oSection1:Cell("Z2_CFISCAL"):SetValue((cAlias1)->Z2_CFISCAL)

			oSection1:Cell("Z2_LFISICO"):SetHeaderAlign("left")
			oSection1:Cell("Z2_LFISICO"):SetAlign("right")
			oSection1:Cell("Z2_LFISICO"):SetValue((cAlias1)->Z2_LFISCA)

			oSection1:Cell("Z2_NCFISCA"):SetHeaderAlign("left")
			oSection1:Cell("Z2_NCFISCA"):SetAlign("right")
			oSection1:Cell("Z2_NCFISCA"):SetValue((cAlias1)->Z2_NCFISCA)

		endif

		//Contrato
		oSection1:Cell("Z2_CODCON"):SetHeaderAlign("left")
		oSection1:Cell("Z2_CODCON"):SetAlign("right")
		oSection1:Cell("Z2_CODCON"):SetValue((cAlias1)->Z2_CODCON)

		oSection1:Cell("Z2_DINICIO"):SetHeaderAlign("left")
		oSection1:Cell("Z2_DINICIO"):SetAlign("right")
		oSection1:Cell("Z2_DINICIO"):SetValue((cAlias1)->Z2_DINICIO)

		oSection1:Cell("Z2_DFINAL"):SetHeaderAlign("left")
		oSection1:Cell("Z2_DFINAL"):SetAlign("right")
		oSection1:Cell("Z2_DFINAL"):SetValue((cAlias1)->Z2_DFINAL)
		oSection1:PrintLine()
		oSection1:Finish()

		if(SELECT(cAlias2) > 0)
			(cAlias2)->(dbCloseArea())
		Endif


		BeginSql Alias cAlias2
			SELECT
				Z3_CODPROD,
				Z3_NOME,
				Z3_QORIGIN,
				Z3_QSAIDA,
				Z3_QSALDO,
				Z3_CODCON
			FROM
				%Table:SZ2% SZ2
				LEFT JOIN %Table:SZ3% SZ3 ON Z2_FILIAL = Z3_FILIAL
				AND Z2_CODCON = Z3_CODCON
			WHERE
				SZ2.%NotDel%
				AND Z3_CODCON BETWEEN %exp:(cAlias1)->Z2_CODCON% AND %exp:(cAlias1)->Z2_CODCON%
				AND Z3_CODPROD BETWEEN %exp:mv_par07% AND %exp:mv_par08%
			ORDER BY
				Z3_QORIGIN
		EndSql

		While (cAlias2)->(!Eof())
			// Produto(s)
			oSection2:Cell("Z3_CODPROD"):SetHeaderAlign("RIGHT")
			oSection2:Cell("Z3_CODPROD"):SetAlign("RIGHT")
			oSection2:Cell("Z3_CODPROD"):SetValue((cAlias2)->Z3_CODPROD)

			oSection2:Cell("Z3_NOME"):SetHeaderAlign("RIGHT")
			oSection2:Cell("Z3_NOME"):SetAlign("RIGHT")
			oSection2:Cell("Z3_NOME"):SetValue((cAlias2)->Z3_NOME)

			oSection2:Cell("Z3_QORIGIN"):SetHeaderAlign("RIGHT")
			oSection2:Cell("Z3_QORIGIN"):SetAlign("RIGHT")
			oSection2:Cell("Z3_QORIGIN"):SetValue((cAlias2)->Z3_QORIGIN)

			oSection2:Cell("Z3_QSAIDA"):SetHeaderAlign("RIGHT")
			oSection2:Cell("Z3_QSAIDA"):SetAlign("RIGHT")
			oSection2:Cell("Z3_QSAIDA"):SetValue((cAlias2)->Z3_QSAIDA)

			oSection2:Cell("Z3_QSALDO"):SetHeaderAlign("RIGHT")
			oSection2:Cell("Z3_QSALDO"):SetAlign("RIGHT")
			oSection2:Cell("Z3_QSALDO"):SetValue((cAlias2)->Z3_QSALDO)
			oSection2:PrintLine()
			(cAlias2)->(DbSkip())
		Enddo
		oSection2:Finish()

		(cAlias1)->(DbSkip())

	Enddo

	oSection1:Finish()
Return
