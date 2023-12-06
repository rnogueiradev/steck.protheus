#INCLUDE "Topconn.ch"
#INCLUDE "Protheus.ch"

/*/{Protheus.doc} u_STFTR005()

UNICOM não Atendidas 

@type function
@author Everson Santana
@since 06/03/2020
@version Protheus 12 - SigaFat

@history ,Ticket 20200214000533 ,

/*/

User Function STFTR005()
	/*
	Declaracao de variaveis
	*/
	Private _oReport := Nil
	Private _oSecCab := Nil
	Private _cPerg 	 := " " //PadR ("STESTR06", Len (SX1->X1_GRUPO))
	Private _cTipo	 := ""
	Private _cTitulo := ""
	Private _oBreak

	//ValidPerg()

	/*
	Definicoes/preparacao para impressao
	*/
	ReportDef()
	_oReport:PrintDialog()

Return
/*
Definição da estrutura do relatório.
*/
Static Function ReportDef()

	_cTitulo := "UNICOM não Atendidas"

	_oReport := TReport():New("STFTR005"+Alltrim(StrTran(time(),":","")),_cTitulo,_cPerg,{|_oReport| PrintReport(_oReport)},_cTitulo)

	//Pergunte("STESTR06",.F.)

	_oSecCab := TRSection():New( _oReport , _cTitulo, {"QRY"} )

	TRCell():New( _oSecCab, "C6_NUM"		,,"PEDIDO"				,PesqPict('SC6',"C6_NUM")		,TamSX3("C6_NUM")[1]		,.F.,)//01
	TRCell():New( _oSecCab, "C5_XNOME"		,,"CLIENTE"				,PesqPict('SC6',"C6_PRODUTO")	,TamSX3("C6_PRODUTO")[1]	,.F.,)//02
	TRCell():New( _oSecCab, "C5_EMISSAO"    ,,"EMISSAO"				,PesqPict('SC5',"C5_EMISSAO")	,TamSX3("C5_EMISSAO")[1]	,.F.,)//03
	TRCell():New( _oSecCab, "PROGRAMACAO"   ,,"PROGRAMACAO"			,PesqPict('SC5',"C5_EMISSAO")	,TamSX3("C5_EMISSAO")[1]	,.F.,)//03
	TRCell():New( _oSecCab, "C6_PRODUTO"    ,,"CODIGO"				,PesqPict('SC6',"C6_PRODUTO")	,TamSX3("C6_PRODUTO")[1]	,.F.,)//03
	TRCell():New( _oSecCab, "B1_DESC"    	,,"PRODUTO"				,PesqPict('SB1',"B1_DESC")		,TamSX3("B1_DESC")[1]		,.F.,)//03
	TRCell():New( _oSecCab, "B1_GRUPO"    	,,"GRUPO"				,PesqPict('SB1',"B1_GRUPO")		,TamSX3("B1_GRUPO")[1]		,.F.,)//03
	TRCell():New( _oSecCab, "B1_XLIBDES"    ,,"LIBERAÇAO DESENHO"	,PesqPict('SB1',"B1_XLIBDES")	,TamSX3("B1_XLIBDES")[1]	,.F.,)//03
	TRCell():New( _oSecCab, "PA1_QUANT"    	,,"FALTA"				,PesqPict('PA1',"PA1_QUANT")	,TamSX3("PA1_QUANT")[1]		,.F.,)//03
	TRCell():New( _oSecCab, "ORDERX"    	,,"COMPROMISSO"			,PesqPict('SC5',"C5_EMISSAO")	,TamSX3("C5_EMISSAO")[1]	,.F.,)//03
	TRCell():New( _oSecCab, "VALOR"    		,,"VALOR"				,PesqPict('SC6',"C6_ZVALLIQ")	,TamSX3("C6_ZVALLIQ")[1]	,.F.,)//03	
	TRCell():New( _oSecCab, "OBS"    		,,"OBS"					,PesqPict('SC6',"C6_XOBSUNI")	,TamSX3("C6_XOBSUNI")[1]	,.F.,)//03
	TRCell():New( _oSecCab, "STATUS"    	,,"MOTIVO"				,PesqPict('PP8',"PP8_XSTATU")	,TamSX3("PP8_XSTATU")[1]	,.F.,)//03
		
Return Nil

/*
Processamento da Query
*/
Static Function PrintReport(_oReport)

	Local _cQuery     := ""
	Local _nLin		  := 0
    
    _cQuery += " SELECT c6_num, " 
    _cQuery += "   c5_xnome, " 
    _cQuery += "   c5_emissao, " 
    _cQuery += "   c5_xate ||'/' ||c5_xmate  ||'/' ||c5_xaano AS  PROGRAMACAO, " 
    _cQuery += "   c6_produto, " 
    _cQuery += "   c6_prcven, " 
    _cQuery += "   c6_qtdven, " 
    _cQuery += "   c6_zvalliq, " 
    _cQuery += "   b1_desc, " 
    _cQuery += "   b1_grupo, " 
    _cQuery += "   b1_xlibdes, " 
    _cQuery += "   pa1_quant, " 
    _cQuery += "   c6_zentre2, " 
    _cQuery += "   c5_xaano ||c5_xmate ||c5_xate AS ORDERX, " 
    _cQuery += "   Nvl(utl_raw.Cast_to_varchar2(dbms_lob.Substr(pp8_obs, 2000, 1)), ' ') OBS " 
    _cQuery += "   , " 
    _cQuery += "   Nvl(pp8_xstatu, ' ') STATUS " 
    _cQuery += " FROM   sc6010 SC6 " 
    _cQuery += "   inner join(SELECT * " 
    _cQuery += "              FROM   sb1010)SB1 " 
    _cQuery += "           ON SB1.d_e_l_e_t_ = ' ' " 
    _cQuery += "              AND b1_cod = c6_produto " 
    _cQuery += "              AND b1_grupo IN ( '041', '042', '122' ) " 
    _cQuery += "   inner join(SELECT * " 
    _cQuery += "              FROM   pa1010)PA1 " 
    _cQuery += "           ON PA1.d_e_l_e_t_ = ' ' " 
    _cQuery += "              AND pa1_filial = c6_filial " 
    _cQuery += "              AND pa1_doc = c6_num " 
    _cQuery += "                            ||c6_item " 
    _cQuery += "   inner join(SELECT * " 
    _cQuery += "              FROM   sc5010)SC5 " 
    _cQuery += "           ON SC5.d_e_l_e_t_ = ' ' " 
    _cQuery += "              AND c5_filial = c6_filial " 
    _cQuery += "              AND c5_num = c6_num " 
    _cQuery += "              AND SC5.c5_tipocli <> 'X' " 
    _cQuery += "   left join pp8010 PP8 " 
    _cQuery += "          ON pp8_filial = c6_filial " 
    _cQuery += "             AND pp8_pedven = c6_num " 
    _cQuery += "                              ||c6_item " 
    _cQuery += "             AND pp8_prod = c6_produto " 
    _cQuery += "             AND PP8.d_e_l_e_t_ = ' ' " 
    _cQuery += " WHERE  SC6.d_e_l_e_t_ = ' ' " 
    _cQuery += "   AND c6_qtdven > c6_qtdent " 
    _cQuery += "   AND c6_blq <> 'R' " 
    _cQuery += "   AND c6_filial = '02' " 
    _cQuery += " UNION " 
    _cQuery += " SELECT ' '                 AS C6_NUM, " 
    _cQuery += "   ' '                 AS C5_XNOME, " 
    _cQuery += "   ' '                 AS C5_EMISSAO, " 
    _cQuery += "   ' '                 AS PROGRAMACAO, " 
    _cQuery += "   ' '                 AS C6_PRODUTO, " 
    _cQuery += "   0                   AS C6_PRCVEN, " 
    _cQuery += "   0                   AS C6_QTDVEN, " 
    _cQuery += "   0                   AS C6_ZVALLIQ, " 
    _cQuery += "   'TOTAL PROGRAMADOS' AS B1_DESC, " 
    _cQuery += "   ' '                 AS B1_GRUPO, " 
    _cQuery += "   ' '                 AS B1_XLIBDES, " 
    _cQuery += "   SUM(pa1_quant), " 
    _cQuery += "   ' '                 AS C6_ZENTRE2, " 
    _cQuery += "   ' '                 AS ORDERX, " 
    _cQuery += "   ' '                 OBS, " 
    _cQuery += "   ' '                 STATUS " 
    _cQuery += " FROM   sc6010 SC6 " 
    _cQuery += "   inner join(SELECT * " 
    _cQuery += "              FROM   sb1010)SB1 " 
    _cQuery += "           ON SB1.d_e_l_e_t_ = ' ' " 
    _cQuery += "              AND b1_cod = c6_produto " 
    _cQuery += "              AND b1_grupo IN ( '041', '042', '122' ) " 
    _cQuery += "   inner join(SELECT * " 
    _cQuery += "              FROM   pa1010)PA1 " 
    _cQuery += "           ON PA1.d_e_l_e_t_ = ' ' " 
    _cQuery += "              AND pa1_filial = c6_filial " 
    _cQuery += "              AND pa1_doc = c6_num " 
    _cQuery += "                            ||c6_item " 
    _cQuery += "   inner join(SELECT * " 
    _cQuery += "              FROM   sc5010)SC5 " 
    _cQuery += "           ON SC5.d_e_l_e_t_ = ' ' " 
    _cQuery += "              AND c5_filial = c6_filial " 
    _cQuery += "              AND c5_num = c6_num " 
    _cQuery += "              AND SC5.c5_tipocli <> 'X' " 
    _cQuery += " WHERE  SC6.d_e_l_e_t_ = ' ' " 
    _cQuery += "   AND c6_qtdven > c6_qtdent " 
    _cQuery += "   AND c6_blq <> 'R' " 
    _cQuery += "   AND c6_filial = '02' " 
    _cQuery += "   AND c5_xaano " 
    _cQuery += "       ||c5_xmate " 
    _cQuery += "       ||c5_xate <> ' ' " 
    _cQuery += " UNION " 
    _cQuery += " SELECT ' '                      AS C6_NUM, " 
    _cQuery += "  ' '                      AS C5_XNOME, " 
    _cQuery += "   ' '                      AS C5_EMISSAO, " 
    _cQuery += "   ' '                      AS PROGRAMACAO, " 
    _cQuery += "   ' '                      AS C6_PRODUTO, " 
    _cQuery += "   0                        AS C6_PRCVEN, " 
    _cQuery += "   0                        AS C6_QTDVEN, " 
    _cQuery += "   0                        AS C6_ZVALLIQ, " 
    _cQuery += "   'TOTAL NÃO PROGRAMADOS' AS B1_DESC, " 
    _cQuery += "   ' '                      AS B1_GRUPO, " 
    _cQuery += "   ' '                      AS B1_XLIBDES, " 
    _cQuery += "  SUM(pa1_quant), " 
    _cQuery += "   ' '                      AS C6_ZENTRE2, " 
    _cQuery += "   ' '                      AS ORDERX, " 
    _cQuery += "   ' '                      OBS, " 
    _cQuery += "   ' '                      STATUS " 
    _cQuery += " FROM   sc6010 SC6 " 
    _cQuery += "   inner join(SELECT * " 
    _cQuery += "             FROM   sb1010)SB1 " 
    _cQuery += "           ON SB1.d_e_l_e_t_ = ' ' " 
    _cQuery += "              AND b1_cod = c6_produto " 
    _cQuery += "              AND b1_grupo IN ( '041', '042', '122' ) " 
    _cQuery += "   inner join(SELECT * " 
    _cQuery += "              FROM   pa1010)PA1 " 
    _cQuery += "           ON PA1.d_e_l_e_t_ = ' ' " 
    _cQuery += "              AND pa1_filial = c6_filial " 
    _cQuery += "              AND pa1_doc = c6_num " 
    _cQuery += "                           ||c6_item " 
    _cQuery += "   inner join(SELECT * " 
    _cQuery += "              FROM   sc5010)SC5 " 
    _cQuery += "           ON SC5.d_e_l_e_t_ = ' ' " 
    _cQuery += "              AND c5_filial = c6_filial " 
    _cQuery += "              AND c5_num = c6_num " 
    _cQuery += "              AND SC5.c5_tipocli <> 'X' " 
    _cQuery += " WHERE  SC6.d_e_l_e_t_ = ' ' " 
    _cQuery += "   AND c6_qtdven > c6_qtdent " 
    _cQuery += "   AND c6_blq <> 'R' " 
    _cQuery += "   AND c6_filial = '02' " 
    _cQuery += "   AND c5_xaano " 
    _cQuery += "       ||c5_xmate " 
    _cQuery += "       ||c5_xate = ' ' " 
    _cQuery += " UNION " 
    _cQuery += " SELECT ' '       AS C6_NUM, " 
    _cQuery += "   ' '       AS C5_XNOME, " 
    _cQuery += "   ' '       AS C5_EMISSAO, " 
    _cQuery += "   ' '       AS PROGRAMACAO, " 
    _cQuery += "   ' '       AS C6_PRODUTO, " 
    _cQuery += "   0         AS C6_PRCVEN, " 
    _cQuery += "   0         AS C6_QTDVEN, " 
    _cQuery += "   0         AS C6_ZVALLIQ, " 
    _cQuery += "   'TOTAL  ' AS B1_DESC, " 
    _cQuery += "   ' '       AS B1_GRUPO, " 
    _cQuery += "   ' '       AS B1_XLIBDES, " 
    _cQuery += "   SUM(pa1_quant)," 
    _cQuery += "   ' '       AS C6_ZENTRE2, " 
    _cQuery += "   ' '       AS ORDERX, " 
    _cQuery += "   ' '       OBS, " 
    _cQuery += "   ' '       STATUS " 
    _cQuery += " FROM   sc6010 SC6 " 
    _cQuery += "   inner join(SELECT * " 
    _cQuery += "              FROM   sb1010)SB1 " 
    _cQuery += "          ON SB1.d_e_l_e_t_ = ' ' " 
    _cQuery += "              AND b1_cod = c6_produto " 
    _cQuery += "              AND b1_grupo IN ( '041', '042', '122' ) " 
    _cQuery += "   inner join(SELECT * " 
    _cQuery += "              FROM   pa1010)PA1 "  
    _cQuery += "           ON PA1.d_e_l_e_t_ = ' ' " 
    _cQuery += "              AND pa1_filial = c6_filial " 
    _cQuery += "              AND pa1_doc = c6_num " 
    _cQuery += "                            ||c6_item " 
    _cQuery += "   inner join(SELECT * " 
    _cQuery += "              FROM   sc5010)SC5 " 
    _cQuery += "           ON SC5.d_e_l_e_t_ = ' ' " 
    _cQuery += "              AND c5_filial = c6_filial " 
    _cQuery += "              AND c5_num = c6_num " 
    _cQuery += "              AND SC5.c5_tipocli <> 'X' " 
    _cQuery += " WHERE  SC6.d_e_l_e_t_ = ' ' " 
    _cQuery += "   AND c6_qtdven > c6_qtdent " 
    _cQuery += "   AND c6_blq <> 'R' " 
    _cQuery += "   AND c6_filial = '02' " 
    _cQuery += " ORDER  BY orderx "

	If Select("QRY") > 0
		Dbselectarea("QRY")
		QRY->(DbClosearea())
	EndIf

	TcQuery _cQuery New Alias "QRY"

	dbSelectArea("QRY")
	QRY->(dbGoTop())

	While !QRY->(Eof())

		_oSecCab:Init()
		
		_nFalta := QRY->PA1_QUANT
		
		_oSecCab:Cell("C6_NUM"):SetValue(QRY->C6_NUM)
		_oSecCab:Cell("C5_XNOME"):SetValue(QRY->C5_XNOME)
		_oSecCab:Cell("C5_EMISSAO"):SetValue(QRY->C5_EMISSAO)
		_oSecCab:Cell("PROGRAMACAO"):SetValue(QRY->PROGRAMACAO)
		_oSecCab:Cell("C6_PRODUTO"):SetValue(QRY->C6_PRODUTO)
		_oSecCab:Cell("B1_DESC"):SetValue(QRY->B1_DESC)
		_oSecCab:Cell("B1_GRUPO"):SetValue(QRY->B1_GRUPO)
		_oSecCab:Cell("B1_XLIBDES"):SetValue(QRY->B1_XLIBDES)
		_oSecCab:Cell("PA1_QUANT"):SetValue(QRY->PA1_QUANT)
		_oSecCab:Cell("ORDERX"):SetValue(QRY->ORDERX)
		_oSecCab:Cell("VALOR"):SetValue(Round(_nFalta*QRY->(C6_ZVALLIQ/C6_QTDVEN),2)) 		
		_oSecCab:Cell("OBS"):SetValue(QRY->OBS)
		_oSecCab:Cell("STATUS"):SetValue(QRY->STATUS)
		
		
		_oSecCab:PrintLine()

		QRY->(DbSkip())

	EndDo

	_oReport:ThinLine()

	_oSecCab:Finish()

Return Nil
/*
Criacao e apresentacao das perguntas
*/
Static Function ValidPerg()
	Local _sAlias := GetArea()
	Local _aRegs  := {}
	Local i := 0
	Local j := 0
	_cPerg         := PADR(_cPerg,10)
	AADD(_aRegs,{_cPerg,"01","De Dt Emissao? "	,"De Dt Emissao "	,"De Dt Emissao  "	,"mv_ch1","D",08,0,0,"G","          ","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(_aRegs,{_cPerg,"02","Ate Dt Emissao? "	,"Ate Dt Emissao "	,"De Dt Emissao  "	,"mv_ch2","D",08,0,0,"G","          ","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	dbSelectArea("SX1")
	SX1->(dbSetOrder(1))
	for i := 1 to len(_aRegs)
		If !SX1->(dbSeek(_cPerg+_aRegs[i,2]))
			RecLock("SX1",.T.)
			for j := 1 to FCount()
				If j <= Len(_aRegs[i])
					FieldPut(j,_aRegs[i,j])
				Else
					Exit
				EndIf
			next
			MsUnlock()
		EndIf
	next
	RestArea(_sAlias)
Return