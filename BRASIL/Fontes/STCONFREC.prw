#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "Rwmake.ch"
#INCLUDE "TopConn.ch"


/*/{Protheus.doc} STINSCR
(Função para gravar incrição no arquivo SISPAG financeiro)

@author cristiano.pereira
@since 25/09/2017
@version 1.0
@return ${return}, ${return_description}

/*/

User Function STCONFREC()

	Local aArea    := GetArea()
	Local aRet     := {}
	Local aParam   := {}
	Local aCabec   := {"FILIAL","CODIGO FORN","NOME FORN","NOTA FISCAL","PRODUTO","DESCRICAO","CENTRO DE CUSTO","DESCRICAO CC","QUANTIDADE"}
	Local aDados   := {}
	Private aParR2 := {}


	Processa( {|| aDados := getProcess() }, "Aguarde, Filtrando registros")

	if Len(aDados) > 0
		MsgRun("Por favor Aguarde.....", "Exportando os Registros para o Excel",{||  ExpotMsExcel(aCabec, aDados)})
	Endif

return

/*/{Protheus.doc} getProcess
(long_description)
Retorna array com os dados a serem apresentados
@author user
Cristiano Pereira - SigaMat
@since date
21/03/2020
@example
(examples)
/*/
Static Function getProcess()

	Local cQry      := GetQryProc()
	Local aRET      := {}
	Local nTotal    := 0
	Local cTipo     := ""
	Local cAlias    := GetNextAlias()
	Local _cSitFol  := " "
	Local _cDeFun   := " "
	Local _cDeCC    := " "
	Local _cVinE    := " "
	Local _cChefIm  := " "



	IF Select(cAlias) > 0
		(cAlias)->( dbCloseArea() )
	Endif

	cQry := ChangeQuery( cQry )
	TcQuery cQry New Alias (cAlias)

	dbSelectArea(cAlias)
	dbGotop()
	COUNT TO nTotal

	ProcRegua(nTotal)

	dbSelectArea(cAlias)
	dbGotop()



	While (cAlias)->(!Eof() )


		DbSelectArea("SB1")
		DbSetOrder(1)
		If DbSeek(xFilial("SB1")+(cAlias)->COD)


			DbSelectArea("SA2")
			DbSetOrder(1)
			If DbSeek(xFilial("SA2")+(cAlias)->FORN+(cAlias)->LOJA)

				DbSelectArea("CTT")
				DbSetOrder(1)
				If DbSeek(xFilial("CTT")+(cAlias)->CC)



					IncProc()

					aAdd(aRET, {;
						(cAlias)->FIL,;
						(cAlias)->FORN+" "+(cAlias)->LOJA,;
						SA2->A2_NOME,;
						(cAlias)->NF,;
						(cAlias)->COD,;
						SB1->B1_DESC,;
						(cAlias)->CC,;
						CTT->CTT_DESC01,;
						(cAlias)->QUANT})

				Else

					IncProc()


					aAdd(aRET, {;
						(cAlias)->FIL,;
						(cAlias)->FORN+" "+(cAlias)->LOJA,;
						SA2->A2_NOME,;
						(cAlias)->NF,;
						(cAlias)->COD,;
						SB1->B1_DESC,;
						(cAlias)->CC,;
						'',;
						(cAlias)->QUANT})
				Endif
			Endif

		Endif

		(cAlias)->( dbSkip())
	EndDo

	IF Select(cAlias) > 0
		(cAlias)->( dbCloseArea() )
	Endif

Return aRET

/*/{Protheus.doc} GetQryProc
(long_description)
Retorna query montada
@author user
Cristiano Pereira - SigaMat
@since date
21/03/2020
@example
(examples)
/*/
Static Function GetQryProc()

	Local cRET   := ""


	cRET += " SELECT " + CRLF
	cRET += " SD1.D1_FILIAL AS FIL,SD1.D1_DOC AS NF,SD1.D1_FORNECE AS FORN,SD1.D1_LOJA AS LOJA,SD1.D1_COD AS COD,SD1.D1_CC AS CC,SUM(SD1.D1_QUANT) AS QUANT " + CRLF
	cRET += " FROM " + RETSQLNAME("SD1") + " SD1    " + CRLF
	cRET += " WHERE SD1.D_E_L_E_T_ = ' '     AND    " + CRLF
	cRET += "      SD1.D1_FILIAL ='"+xFilial("SF1")+"'         AND "+ CRLF
	cRET += "      SD1.D1_DOC = '"+SF1->F1_DOC+"'              AND "+ CRLF
	cRET += "      SD1.D1_FORNECE = '"+SF1->F1_FORNECE+"'      AND "+ CRLF
	cRET += "      SD1.D1_LOJA = '"+SF1->F1_LOJA+"'            AND "+ CRLF
	cRET += "      SD1.D1_SERIE = '"+SF1->F1_SERIE+"'              "+ CRLF


	cRET += " GROUP BY  SD1.D1_FILIAL,SD1.D1_DOC,SD1.D1_COD,SD1.D1_CC,SD1.D1_FORNECE,SD1.D1_LOJA          " + CRLF

Return cRET


// ---------+-------------------+--------------------------------------------------
// Projeto  : IF DO BRASIL
// Autor    : Valdemir Rabelo - SIGAMAT
// Modulo   : SIGAGPE
// Função   : ExpotMsExcel
// Descrição: Gera Planilha Excel.
// Retorno  : Nenhum.
// ---------+-------------------+--------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+--------------------------------------------------
// 19/03/20 | Valdemir Rabelo   | Desenvolvimento da rotina.
// ---------+-------------------+--------------------------------------------------
Static Function ExpotMsExcel(paCabec1, paItens1)
	Local cArq       := ""
	Local cDirTmp    := GetTempPath()
	Local cDir       := GetSrvProfString("Startpath","")
	Local cWorkSheet := ""
	Local cTable     := "PLANILHA DE GERENCIAMENTO - CONFERÊNCIA RECEBIMENTO"
	Local oFwMsEx    := FWMsExcel():New()
	Local nLin2      := 0
	Local nC
	Local nL
	Local nTot    := 0
	Local nReg    := 0
	Local nCol    := 0
	Local lEnd    := .F.
	Private aAlgn := {1,1,1,1,1,1,1,1,1}      // Alinhamento da coluna ( 1-Left,2-Center,3-Right )
	Private aForm := {1,1,1,1,1,1,1,1,1}      // Codigo de formatação ( 1-General,2-Number,3-Monetário,4-DateTime )

	cWorkSheet := "Registros Gerados"

	oFwMsEx:AddWorkSheet( cWorkSheet )
	oFwMsEx:SetTitleSizeFont(9)
	oFwMsEx:AddTable( cWorkSheet, cTable )

	oFwMsEx:SetTitleBold(.T.)

	For nC := 1 to Len(paCabec1)
		oFwMsEx:AddColumn( cWorkSheet, cTable , paCabec1[nC] , aAlgn[nC], aForm[nC] )
	Next

	For nL := 1 to Len(paItens1)
		oFwMsEx:AddRow(cWorkSheet,cTable, paItens1[nL] )
	Next

	oFwMsEx:Activate()

	cArq := CriaTrab( NIL, .F. ) + ".xml"

	LjMsgRun( "Gerando Planilha, aguarde...", cTable, {|| oFwMsEx:GetXMLFile( cArq ) } )

	If __CopyFile( cArq, cDirTmp + cArq )
		IncProc("Carregando planilha")
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open( cDirTmp + cArq )
		oExcelApp:SetVisible(.T.)
		oExcelApp:Destroy()
	Else
		MsgInfo( "Arquivo não copiado para o diretório dos arquivos temporários do usuário." )
	Endif

Return

