#include 'protheus.ch'
#include 'parmtype.ch'

User Function ARPOSEST()

	/*
	Declaracao de variaveis
	*/
	Private _oReport := Nil
	Private _oSecCab := Nil
	Private _cPergx 	 := PadR ("ARPOSEST", Len (SX1->X1_GRUPO))
	Private _cTipo	 := ""
	Private _cTitulo := ""
	Private _cTop01		:=	"SQL01"

	/*
	Definicoes/preparacao para impressao
	*/
	ReportDef()
	_oReport:PrintDialog()

	U_ARPutSx1( _cPergx, "01","Produto de:	"	,"MV_PAR01","mv_ch1","C",TamSX3("B1_COD")[1]		,0,"G",,"SB1","")
	U_ARPutSx1( _cPergx, "02","Produto ate:	"	,"MV_PAR02","mv_ch2","C",TamSX3("B1_COD")[1]		,0,"G",,"SB1","")
	U_ARPutSx1( _cPergx, "03","Grupo de:	"		,"MV_PAR03","mv_ch3","C",TamSX3("B1_GRUPO")[1]	,0,"G",,"SBM","")
	U_ARPutSx1( _cPergx, "04","Grupo ate:	"	,"MV_PAR04","mv_ch4","C",TamSX3("B1_GRUPO")[1]	,0,"G",,"SBM","")

Return()

Static Function ReportDef()
		
	_cTitulo := "INFORME ESPECIAL DE STOCK Y COMPRAS"

	_oReport := TReport():New("ARPOSEST",_cTitulo,_cPergx,{|_oReport| PrintReport(_oReport)},_cTitulo)
	
	_oSecCab := TRSection():New( _oReport , "INFORME ESPECIAL DE STOCK Y COMPRAS", {"_cTop01"} )

	//CODIGO	DETALLE	ALM01	ALM04	ALM06	QTDDISP	QTDATU	PEDVEN	RESERVA	PREVISAO	ESTSEG	GRUPO	DESCRIPION	ORIGEM	ABC	FMR	PROVEDOR

	TRCell():New( _oSecCab, "B1_COD"		,,"Codigo 		" ,PesqPict('SB1',"B1_COD")		,TamSX3("B1_COD")[1],.F.,)
	TRCell():New( _oSecCab, "B1_DESC"		,,"Detalhe 		" ,PesqPict('SB1',"B1_DESC")	,TamSX3("B1_DESC")[1],.F.,)
	TRCell():New( _oSecCab, "B2_ALM01"		,,"Local 01		" ,PesqPict('SB2',"B2_QATU")	,TamSX3("B2_QATU")[1],.F.,)
	TRCell():New( _oSecCab, "B2_ALM04" 		,,"Local 04     " ,PesqPict('SB2',"B2_QATU")	,TamSX3("B2_QATU")[1]	,.F.,)
	TRCell():New( _oSecCab, "B2_ALM06"    	,,"Local 06     " ,PesqPict('SB2',"B2_QATU")	,TamSX3("B2_QATU")[1],.F.,)
	TRCell():New( _oSecCab, "B2_QTDDISP"   	,,"Qtd Disp     " ,PesqPict('SB2',"B2_QATU")	,TamSX3("B2_QATU")[1]	,.F.,)
	TRCell():New( _oSecCab, "B2_QTDATU"   	,,"Qtd Atu  	" ,PesqPict('SB2',"B2_QATU")	,TamSX3("B2_QATU")[1]	,.F.,)		
	TRCell():New( _oSecCab, "B2_PEDVEN"   	,,"Ped Ven     	" ,PesqPict('SB2',"B2_QATU")	,TamSX3("B2_QATU")[1]	,.F.,)
	TRCell():New( _oSecCab, "B2_QTDRES"   	,,"Reserva  	" ,PesqPict('SB2',"B2_QATU")	,TamSX3("B2_QATU")[1]	,.F.,)
	TRCell():New( _oSecCab, "B2_QTDPREV"   	,,"Previsão     " ,PesqPict('SB2',"B2_QATU")	,TamSX3("B2_QATU")[1]	,.F.,)
	TRCell():New( _oSecCab, "B2_ESTNEG"		,,"Est Neg      " ,PesqPict('SB2',"B2_QATU")	,TamSX3("B2_QATU")[1]	,.F.,)
	TRCell():New( _oSecCab, "BM_GRUPO"    	,,"Grupo    	" ,PesqPict('SBM',"BM_GRUPO")	,TamSX3("BM_GRUPO")[1]	,.F.,)
	TRCell():New( _oSecCab, "BM_DESC"    	,,"Descrição    " ,PesqPict('SBM',"BM_DESC")	,TamSX3("BM_DESC")[1]	,.F.,)
	TRCell():New( _oSecCab, "B1_XPAIS"     	,,"Origem     	" ,PesqPict('SB1',"B1_XPAIS")	,TamSX3("B1_XPAIS")[1]	,.F.,)
	TRCell():New( _oSecCab, "B1_XABC"     	,,"ABC     		" ,PesqPict('SB1',"B1_XABC")	,TamSX3("B1_XABC")[1]	,.F.,)
	TRCell():New( _oSecCab, "B1_XFMR"    	,,"FBR   		" ,PesqPict('SB1',"B1_XFMR")	,TamSX3("B1_XFMR")[1]	,.F.,)
	TRCell():New( _oSecCab, "A2_NREDUZ"		,,"Provedor   	" ,PesqPict('SA2',"A2_NREDUZ")	,TamSX3("A2_NREDUZ")[1]	,.F.,)

Return Nil	

Static Function PrintReport(_oReport)

	Local _cQuery     := ""
	Local _nLin		  := 0

	_cQuery	:=		" 	SELECT	CODIGO,MAX(DESCRI) DETALLE, " + CRLF
	_cQuery+= 	" 	NVL(SUM(ALM01),0)ALM01,NVL(SUM(ALM04),0)ALM04,NVL(SUM(ALM06),0)ALM06, " + CRLF
	_cQuery+= 	" 	NVL(SUM(ALM01),0)+NVL(SUM(ALM04),0)+NVL(SUM(ALM06),0) - CASE WHEN SUM(PEDVEN)<0 THEN SUM(PEDVEN)*-1 ELSE SUM(PEDVEN) END  QTDDISP, " + CRLF
	_cQuery+= 	" 	(NVL(SUM(ALM01),0)+NVL(SUM(ALM04),0)+NVL(SUM(ALM06),0)) QTDATU, " + CRLF
	_cQuery+= 	" 	SUM(PEDVEN)PEDVEN,SUM(RESERVA)RESERVA,SUM(PREVISAO)PREVISAO,SUM(ESTSEG)ESTSEG, " + CRLF
	_cQuery+= 	" 	NVL(MAX(CODGRP),' ')GRUPO,NVL(MAX(GRUPO),' ')DESCRIPION,MAX(ORIGEM)ORIGEM,MAX(ABC)ABC,MAX(FMR)FMR,NVL(MAX(NOMFOR),' ') PROVEDOR " + CRLF
	_cQuery+= 	" 	FROM (	SELECT *  " + CRLF
	_cQuery+= 	" 	FROM (	SELECT B2_COD CODIGO,B1_DESC DESCRI,B2_LOCAL ARMAZ,B2_QATU QATU,B2_QPEDVEN PEDVEN,B2_SALPEDI PREVISAO,B2_RESERVA RESERVA , " + CRLF
	_cQuery+= 	" 	B1_ESTSEG ESTSEG,B1_GRUPO CODGRP,BM_DESC GRUPO,B1_XPAIS ORIGEM,B1_XABC ABC,B1_XFMR FMR,TMP1.NOMFOR " + CRLF
	_cQuery+= 	" 	FROM "+RetSqlName("SB1")+" SB1 " + CRLF
	_cQuery+= 	" 	LEFT JOIN "+RetSqlName("SB2")+" SB2 ON B2_FILIAL='"+xFilial("SB2")+"' AND B1_COD=B2_COD AND SB2.D_E_L_E_T_!='*' " + CRLF 
	_cQuery+= 	" 	LEFT JOIN (	SELECT A2_COD CODFOR,MAX(A2_NREDUZ) NOMFOR  " + CRLF
	_cQuery+= 	" 	FROM "+RetSqlName("SA2")+" SA2  " + CRLF
	_cQuery+= 	" 	WHERE A2_FILIAL='"+xFilial("SA2")+"'  AND SA2.D_E_L_E_T_!='*' " + CRLF 
	_cQuery+= 	" 	GROUP BY A2_COD ) TMP1 ON TMP1.CODFOR=B1_PROC " + CRLF
	_cQuery+= 	" 	LEFT JOIN "+RetSqlName("SBM")+" SBM ON BM_FILIAL='"+xFilial("SBM")+"' AND BM_GRUPO=B1_GRUPO  AND SBM.D_E_L_E_T_!='*' " + CRLF
	_cQuery+= 	" 	WHERE B1_FILIAL='"+xFilial("SB1")+"' AND B1_COD BETWEEN '"+MV_PAR01+"'  AND '"+MV_PAR02+"' AND  SB1.D_E_L_E_T_!='*'	
	_cQuery+= 	"   AND B1_GRUPO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' )TMP2 " + CRLF
	_cQuery+= 	" 	PIVOT ( SUM(QATU) FOR ARMAZ IN ('01' ALM01,'04' ALM04,'06' ALM06) ) )TMP3 " + CRLF
	_cQuery+= 	" 	GROUP BY CODIGO " + CRLF
	_cQuery+= 	" 	ORDER BY 1 " + CRLF  

	If !Empty(Select(_cTop01))
		DbSelectArea(_cTop01)
		(_cTop01)->(dbCloseArea())
	Endif

	dbUseArea( .T.,"TOPCONN", TcGenQry( ,,_cQuery),_cTop01, .T., .T. )

	//CODIGO	DETALLE	ALM01	ALM04	ALM06	QTDDISP	QTDATU	PEDVEN	RESERVA	PREVISAO	ESTSEG	GRUPO	DESCRIPION	ORIGEM	ABC	FMR	PROVEDOR
	_nLin := 70
	
	While (_cTop01)->(!Eof())

	_oSecCab:Init()

				_oSecCab:Cell("B1_COD"):SetValue((_cTop01)->CODIGO)
				_oSecCab:Cell("B1_DESC"):SetValue((_cTop01)->DETALLE)
				_oSecCab:Cell("B2_ALM01"):SetValue((_cTop01)->ALM01)
				_oSecCab:Cell("B2_ALM04"):SetValue((_cTop01)->ALM04)
				_oSecCab:Cell("B2_ALM06"):SetValue((_cTop01)->ALM06)
				_oSecCab:Cell("B2_QTDDISP"):SetValue((_cTop01)->QTDDISP)
				_oSecCab:Cell("B2_QTDATU"):SetValue((_cTop01)->QTDATU)
				_oSecCab:Cell("B2_PEDVEN"):SetValue((_cTop01)->PEDVEN)
				_oSecCab:Cell("B2_QTDRES"):SetValue((_cTop01)->RESERVA)
				_oSecCab:Cell("B2_QTDPREV"):SetValue((_cTop01)->PREVISAO)
				_oSecCab:Cell("B2_ESTNEG"):SetValue(POSICIONE("SB1", 1, xFilial("SB1") + (_cTop01)->CODIGO, "B1_ESTSEG"))
				_oSecCab:Cell("BM_GRUPO"):SetValue((_cTop01)->GRUPO)
				_oSecCab:Cell("BM_DESC"):SetValue((_cTop01)->DESCRIPION)
				_oSecCab:Cell("B1_XPAIS"):SetValue((_cTop01)->ORIGEM)
				_oSecCab:Cell("B1_XABC"):SetValue((_cTop01)->ABC)
				_oSecCab:Cell("B1_XFMR"):SetValue((_cTop01)->FMR)
				_oSecCab:Cell("A2_NREDUZ"):SetValue((_cTop01)->PROVEDOR)
				
				_oSecCab:PrintLine()

				_nLin += 15
	

		(_cTop01)->(dbSkip())

	EndDo

		_oSecCab:Finish()

Return()

