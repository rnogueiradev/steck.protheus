#INCLUDE "PROTHEUS.CH"
#INCLUDE 'RWMAKE.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ STCOM001     บAutor  ณJoao Rinaldi    บ Data ณ  29/02/2016 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Tela para a realiza็ใo de consulta padrใo especํfica de    บฑฑ
ฑฑบ          ณ produtos para a Rotina de Solicita็ใo de Compras do m๓dulo บฑฑ
ฑฑบ          ณ Compras (02) executada via query e chamada pela consulta   บฑฑ
ฑฑบ          ณ (SXB) SB1COM                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck Industria Eletrica Ltda.                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบChamado   ณ 002612 - Automatizar Solicita็ใo de Compras                บฑฑ
ฑฑบSolic.    ณ Juliana Queiroz - Depto. Compras                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function STCOM001()
	
	Local aArea1    := GetArea()
	Local aArea2    := SC1->(GetArea())
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณVariแveis para montagem da Tela - MsNewGetDados
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	Local _cTitulo     := "Pesquisa de Produtos"
	Local aSize        := MsAdvSize(, .F., 400)
	Local aInfo 	     := {aSize[1],aSize[2],aSize[3],aSize[4]-12, 1, 1 }
	Local aObjects     := {{100, 100,.T.,.T. }}
	Local aPosObj      := MsObjSize( aInfo, aObjects,.T. )
	Local nStyle       := GD_INSERT+GD_DELETE+GD_UPDATE
	Local _aCamposEdit := {}
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณVariแveis de A็ใo da MsNewGetDados
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	Private _oDlg2
	Private _lSaida     := .F.
	Private _cVariavel  := Upper( Alltrim( ReadVar() ) )
	Private _bOk        := {|| If(STCOM007(),(_lSaida:=.T.,_cPrd:=(_aCols01[_oLbx2:nAt,2]),_oDlg2:End()),_oDlg2:End())}
	Private _bCancel    := {|| _oDlg2:End() }
	Private _aButtons   := {}
	Private _cExpressao := Space(30)
	Private _cOpcPesq   := ""
	Private _cFiltro    := ""
	Private _nCount     := 0
	Private _cPrd       := ""
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณVariแveis de Objeto e Flag da MsNewGetDados
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	Private _oGet2
	Private oAmarelo   := LoadBitmap( GetResources(), "BR_AMARELO" )
	Private oVermelho  := LoadBitmap( GetResources(), "BR_VERMELHO" )
	Private oVerde     := LoadBitmap( GetResources(), "BR_VERDE")
	Private oPreto     := LoadBitmap( GetResources(), "BR_PRETO")
	Private oStatus
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณVariแvies do Cabe็alho e Itens da MsNewGetDados
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	Private _aCols01   := {}
	Private _aHeader2  := {}
	Private _aCols02   := {}
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณMontagem da Tela MsNewGetDados
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	aadd(_aCols02,{'XX','XX',0,0,0,0,0,0,0,0,.f.})
	aadd(_aCols01,{;
		oPreto,;
		SPACE(TamSx3("B1_COD")[1]+TamSx3("B1_COD")[2]),;
		SPACE(TamSx3("B1_DESC")[1]+TamSx3("B1_DESC")[2]),;
		SPACE(TamSx3("BM_DESC")[1]+TamSx3("BM_DESC")[2]),;
		SPACE(TamSx3("B1_TIPO")[1]+TamSx3("B1_TIPO")[2]),;
		SPACE(TamSx3("B1_UM")[1]+TamSx3("B1_UM")[2]),;
		SPACE(TamSx3("B1_CLAPROD")[1]+TamSx3("B1_CLAPROD")[2]),;
		SPACE(TamSx3("B1_APROPRI")[1]+TamSx3("B1_APROPRI")[2]),;
		SPACE(TamSx3("B1_LOCPAD")[1]+TamSx3("B1_LOCPAD")[2]),;
		SPACE(TamSx3("B1_QE")[1]+TamSx3("B1_QE")[2]),;
		SPACE(TamSx3("B1_LE")[1]+TamSx3("B1_LE")[2]),;
		SPACE(TamSx3("B1_UREV")[1]+TamSx3("B1_UREV")[2]),;
		SPACE(TamSx3("B1_UCOM")[1]+TamSx3("B1_UCOM")[2]),;
		0,;
		_aCols02})
	box2aHeader()
	
	Define MSDialog _oDlg2 Title cCadastro From aSize[7],000 To aSize[6],aSize[5] of GetWndDefault() Pixel

	@ 050,100 MSGET _cExpressao     SIZE 100,07 Of _oDlg2 Pixel PICTURE '@!'

	@ 040,215 SAY "Qtde. de Produtos Pesquisados:" Of _oDlg2 Pixel
	@ 050,215 GET _nCount  WHEN .f. SIZE 060,08  Of _oDlg2 Pixel

	@ 050,300 Button "Pesquisar"    SIZE 35,12 Action STCOM005(@_oLbx2,@_aCols01,@_oGet2,@_cExpressao) Of _oDlg2 Pixel
	@ 050,340 Button "Visualizar"   SIZE 35,12 Action STCOM004(@_oLbx2,@_aCols01,@_oGet2,@_cExpressao) Of _oDlg2 Pixel

	@ 040,010 SAY   "Tipo de Pesquisa: "                                           SIZE 100,07 Of _oDlg2 Pixel
	@ 050,010 COMBOBOX _cOpcPesq ITEMS {"Descri็ใo de Produto","C๓digo de Produto"} SIZE 070,10 Of _oDlg2 Pixel
	@ 040,100 SAY   "Informe a Expressใo da Pesquisa: "                            SIZE 100,07  COLOR CLR_BLUE Of _oDlg2 Pixel

	@ 030,420 To 070,530 Label OemToAnsi('Legenda') Of _oDlg2 Pixel
	oBtn1     := TBtnBmp2():New( 065,900,26,26,'BR_AMARELO' ,,,,{||ApMsgInfo("Produto Desativado")},_oDlg2,"Produto Desativado",,.T. )
	oBtn2     := TBtnBmp2():New( 090,900,26,26,'BR_VERMELHO',,,,{||ApMsgInfo("Produto Bloqueado")} ,_oDlg2,"Produto Bloqueado" ,,.T. )
	oBtn3     := TBtnBmp2():New( 115,900,26,26,'BR_VERDE'   ,,,,{||ApMsgInfo("Produto Liberado")}  ,_oDlg2,"Produto Liberado"  ,,.T. )

	@ 035,460 SAY   " - Produto Desativado"  SIZE 100,07 Of _oDlg2 Pixel
	@ 047,460 SAY   " - Produto Bloqueado"   SIZE 100,07 Of _oDlg2 Pixel
	@ 060,460 SAY   " - Produto Liberado"    SIZE 100,07 Of _oDlg2 Pixel

	@ 075,005 listbox _oLbx2 fields header ;
		"Status",;
		RetTitle("B1_COD"),;
		RetTitle("B1_DESC"),;
		RetTitle("BM_DESC"),;
		RetTitle("B1_TIPO"),;
		RetTitle("B1_UM"),;
		RetTitle("B1_CLAPROD"),;
		RetTitle("B1_APROPRI"),;
		RetTitle("B1_LOCPAD"),;
		RetTitle("B1_QE"),;
		RetTitle("B1_LE"),;
		RetTitle("B1_UREV"),;
		RetTitle("B1_UCOM"),;
		"Recno";
		size  aPosObj[1,4] , aPosObj[1,3]/2-30  pixel of _oDlg2

	_oLbx2:SetArray( _aCols01 )
	_oLbx2:bChange := {|| ChangeLine(@_oLbx2,@_aCols01,@_oGet2) }
	_oLbx2:bLine := {|| {_aCols01[_oLbx2:nAt,1],;
		_aCols01[_oLbx2:nAt,2],;
		_aCols01[_oLbx2:nAt,3],;
		_aCols01[_oLbx2:nAt,4],;
		_aCols01[_oLbx2:nAt,5],;
		_aCols01[_oLbx2:nAt,6],;
		_aCols01[_oLbx2:nAt,7],;
		_aCols01[_oLbx2:nAt,8],;
		_aCols01[_oLbx2:nAt,9],;
		_aCols01[_oLbx2:nAt,10],;
		_aCols01[_oLbx2:nAt,11],;
		_aCols01[_oLbx2:nAt,12],;
		_aCols01[_oLbx2:nAt,13],;
		_aCols01[_oLbx2:nAt,14];
		}}
	_oLbx2:Refresh()
	_oLbx2:bLDblClick := { ||Eval(_bOk), _oDlg2:End()}
	
	_oGet2 := MsNewGetDados():New( aPosObj[1,3]/2+10+45 , 05                 , aPosObj[1,3]   , aPosObj[1,4]     ,                  ,"AllWaysTrue","AllWaysTrue",""        ,  _aCamposEdit ,/*freeze*/,999,/*fieldok*/,/*superdel*/,/*delok*/,_oDlg2,_aHeader2,_aCols02)
	_oGet2 :lEditLine := .F.
	
	ACTIVATE MSDIALOG _oDlg2 ON INIT EnchoiceBar(_oDlg2, _bOk, _bCancel,,_aButtons)
	
	If _lSaida
		&_cVariavel := _cPrd
		//M->C1_PRODUTO := _cPrd
	Else
		Aviso("Sele็ใo de Produto"; //01 - cTitulo - Tํtulo da janela
		,"Nenhum produto foi selecionado para marca็ใo."+ Chr(10) + Chr(13) +;
			CHR(10)+CHR(13)+;
			"",; //02 - cMsg - Texto a ser apresentado na janela.
		{"OK"};                          //03 - aBotoes - Array com as op็๕es dos bot๕es.
		,2;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
		,;                               //05 - cText - Titulo da Descri็ใo (Dentro da Janela)
		,;                               //06 - nRotAutDefault - Op็ใo padrใo usada pela rotina automแtica
		,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
		,.F.;                            //08 - lEdit - Determina se permite a edi็ใo do campo memo
		,2;                               //09 - nTimer - Tempo para exibi็ใo da mensagem em segundos.
		,;                               //10 - nOpcPadrao - Op็ใo padrใo apresentada na mensagem.
		)
	Endif
	
	RestArea(aArea2)
	RestArea(aArea1)
	
Return _lSaida


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ STCOM002     บAutor  ณJoao Rinaldi    บ Data ณ  29/02/2016 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo utilizada para a execu็ใo da Query 1 da tela        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck Industria Eletrica Ltda.                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบChamado   ณ 002612 - Automatizar Solicita็ใo de Compras                บฑฑ
ฑฑบSolic.    ณ Juliana Queiroz - Depto. Compras                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function STCOM002(_cFiltro)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณVariแveis para execu็ใo da Query 1
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	Local cPerg        := "STCOM002"
	Local cTime        := Time()
	Local cHora        := SUBSTR(cTime, 1, 2)
	Local cMinutos     := SUBSTR(cTime, 4, 2)
	Local cSegundos    := SUBSTR(cTime, 7, 2)
	Local cAliasLif    := cPerg+cHora+cMinutos+cSegundos
	Local _cAlias1     := cAliasLif
	Local _cQuery1     := ""
	
	_nCount   := 0
	
	If !Empty(_cFiltro)	
		_cQuery1 := " SELECT   "
		_cQuery1 += " B1_COD  "
		_cQuery1 += " ,CASE WHEN B1_MSBLQL = '1'  THEN 'BLOQUEADO'  ELSE
		_cQuery1 += "  CASE WHEN B1_XDESAT = '2'  THEN 'DESATIVADO' ELSE
		_cQuery1 += " 'LIBERADO' END END AS A1_STATUS_PROD
		_cQuery1 += " ,B1_COD  AS A2_COD
		_cQuery1 += " ,B1_DESC AS A3_DESCPRD
		_cQuery1 += " ,BM_DESC AS A4_DESCGRP
		_cQuery1 += " ,B1_TIPO AS A5_TIPO
		_cQuery1 += " ,B1_UM   AS A6_UM
		_cQuery1 += " ,CASE WHEN B1_CLAPROD = 'C'  THEN 'COMPRADO'  ELSE
		_cQuery1 += "  CASE WHEN B1_CLAPROD = 'F'  THEN 'FABRICADO' ELSE
		_cQuery1 += "  CASE WHEN B1_CLAPROD = 'I'  THEN 'IMPORTADO' ELSE
		_cQuery1 += " 'NรO INFORMADO' END END END AS A7_CLAPROD
		_cQuery1 += " ,CASE WHEN B1_APROPRI = 'D'  THEN 'DIRETA'  ELSE
		_cQuery1 += "  CASE WHEN B1_APROPRI = 'I'  THEN 'INDIRETA' ELSE
		_cQuery1 += " 'NรO INFORMADO' END END AS A8_APROPRI
		
		_cQuery1 += " ,B1_LOCPAD  AS A9_LOCPAD
		_cQuery1 += " ,B1_QE      AS A10_QE
		_cQuery1 += " ,B1_LE      AS A11_LE
		_cQuery1 += " ,SUBSTR( B1_UREV,7,2)||'/'|| SUBSTR( B1_UREV,5,2)||'/'|| SUBSTR( B1_UREV,1,4) AS A12_DTUREV
		_cQuery1 += " ,SUBSTR( B1_UCOM,7,2)||'/'|| SUBSTR( B1_UCOM,5,2)||'/'|| SUBSTR( B1_UCOM,1,4) AS A13_DTUCOM
		_cQuery1 += " ,SB1.R_E_C_N_O_ AS A14_RECNO
		
		_cQuery1 += " FROM " + RetSqlName("SB1") +" SB1 "
		
		_cQuery1 += " LEFT JOIN " + RetSqlName("SBM") +" SBM "
		_cQuery1 += " ON  B1_GRUPO         = BM_GRUPO
		_cQuery1 += " AND BM_FILIAL        = '" + xFilial("SBM") + "'"
		_cQuery1 += " AND SBM.D_E_L_E_T_  <> '*'
		
		_cQuery1 += " WHERE SB1.D_E_L_E_T_ = ' '
		_cQuery1 += " AND B1_FILIAL      = '" + xFilial("SB1") + "'"
		
		_cQuery1 +=  _cFiltro
		_cQuery1 += "   AND ROWNUM        <= 100"
		
		_cQuery1 += " ORDER BY B1_DESC "
		
		_cQuery1 := ChangeQuery(_cQuery1)
		DbUseArea(.T., "TOPCONN", TCGENQRY( , , _cQuery1), _cAlias1, .F., .T.)
		
		dbSelectArea(_cAlias1)
		(_cAlias1)->(DbGoTop())
		dbeval({||_nCount++})
		DbSelectArea(_cAlias1)
		(_cAlias1)->(DbGoTop())
		If  Select(_cAlias1) > 0
			ProcRegua(_nCount)
			While !(_cAlias1)->(Eof())
				IncProc("Pesquisando Produto: "+(_cAlias1)->A2_COD)
				If Alltrim((_cAlias1)->A1_STATUS_PROD) == 'BLOQUEADO'
					oStatus := oVermelho
				ElseIf Alltrim((_cAlias1)->A1_STATUS_PROD) == 'DESATIVADO'
					oStatus := oAmarelo
				ElseIf Alltrim((_cAlias1)->A1_STATUS_PROD) == 'LIBERADO'
					oStatus := oVerde
				Endif
				_aCols02 := STCOM003((_cAlias1)->A2_COD)
				Aadd(_aCols01,{;
					oStatus,;
					(_cAlias1)->A2_COD,;
					(_cAlias1)->A3_DESCPRD,;
					(_cAlias1)->A4_DESCGRP,;
					(_cAlias1)->A5_TIPO,;
					(_cAlias1)->A6_UM,;
					(_cAlias1)->A7_CLAPROD,;
					(_cAlias1)->A8_APROPRI,;
					(_cAlias1)->A9_LOCPAD,;
					(_cAlias1)->A10_QE,;
					(_cAlias1)->A11_LE,;
					(_cAlias1)->A12_DTUREV,;
					(_cAlias1)->A13_DTUCOM,;
					(_cAlias1)->A14_RECNO,;
					_aCols02;
					})
				//Sleep(1000)
				(_cAlias1)->(dbSkip())
			End
		Endif
		(_cAlias1)->(DbCloseArea())
	Endif

//Return(_aCols01)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ STCOM003     บAutor  ณJoao Rinaldi    บ Data ณ  29/02/2016 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo utilizada para a execu็ใo da Query 2 da tela com os บฑฑ
ฑฑบDesc.     ณ dados de estoque                                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck Industria Eletrica Ltda.                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบChamado   ณ 002612 - Automatizar Solicita็ใo de Compras                บฑฑ
ฑฑบSolic.    ณ Juliana Queiroz - Depto. Compras                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function STCOM003(_cProd)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณVariแveis para execu็ใo da Query 2
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	Local cPerg        := "STCOM003"
	Local cTime        := Time()
	Local cHora        := SUBSTR(cTime, 1, 2)
	Local cMinutos     := SUBSTR(cTime, 4, 2)
	Local cSegundos    := SUBSTR(cTime, 7, 2)
	Local cAliasLif    := cPerg+cHora+cMinutos+cSegundos
	Local _cAlias2     := cAliasLif
	Local _cQuery2     := ""
	
	_cQuery2 := "  SELECT "
	_cQuery2 += "  B2_FILIAL AS A1_FILIAL "
	_cQuery2 += " ,B2_COD   AS A2_COD "
	_cQuery2 += " ,B2_LOCAL AS A3_LOCAL "
	_cQuery2 += " ,B2_QATU  AS A4_SLD_TOT "
	
	_cQuery2 += " ,NVL((SELECT SUM(SDC.DC_QUANT) "
	_cQuery2 += " FROM  " + RetSqlName("SDC") +" SDC "
	_cQuery2 += " WHERE SDC.D_E_L_E_T_ = ' ' "
	_cQuery2 += " AND   SDC.DC_PRODUTO = SB2.B2_COD "
	_cQuery2 += " AND   SDC.DC_FILIAL  = SB2.B2_FILIAL "
	_cQuery2 += " AND   SDC.DC_LOCAL   = SB2.B2_LOCAL "
	_cQuery2 += " ),0)  AS A5_EMPENHO "
	
	_cQuery2 += " ,NVL((SELECT SUM(PA2.PA2_QUANT) "
	_cQuery2 += " FROM  " + RetSqlName("PA2") +" PA2 "
	_cQuery2 += " WHERE PA2.D_E_L_E_T_ = ' ' "
	_cQuery2 += " AND   PA2.PA2_CODPRO = SB2.B2_COD "
	_cQuery2 += " AND   PA2.PA2_FILRES = SB2.B2_FILIAL "
	_cQuery2 += " AND   SB1.B1_LOCPAD  = SB2.B2_LOCAL "
	_cQuery2 += " ),0)  AS A6_RESERVA "
	
	_cQuery2 += " ,0 AS A7_SLD_DISP "
	
	_cQuery2 += " ,NVL((SELECT SUM(SDA.DA_SALDO) "
	_cQuery2 += " FROM  " + RetSqlName("SDA") +" SDA "
	_cQuery2 += " WHERE SDA.D_E_L_E_T_ = ' ' "
	_cQuery2 += " AND   SDA.DA_PRODUTO = SB2.B2_COD "
	_cQuery2 += " AND   SDA.DA_FILIAL  = SB2.B2_FILIAL "
	_cQuery2 += " AND   SDA.DA_LOCAL   = SB2.B2_LOCAL "
	_cQuery2 += " ),0)  AS A8_SLD_END "
	
	_cQuery2 += " ,NVL((SELECT SUM(SD1.D1_QUANT) "
	_cQuery2 += " FROM  " + RetSqlName("SD1") +" SD1 "
	_cQuery2 += " WHERE SD1.D_E_L_E_T_ = ' ' "
	_cQuery2 += " AND   SD1.D1_COD     = SB2.B2_COD "
	_cQuery2 += " AND   SD1.D1_FILIAL  = SB2.B2_FILIAL "
	_cQuery2 += " AND   SD1.D1_LOCAL   = SB2.B2_LOCAL "
	_cQuery2 += " AND   SD1.D1_TES     = ' ' "
	_cQuery2 += " ),0)  AS A9_SLD_PRE_NF "
	
	_cQuery2 += " ,NVL((SELECT SUM(SC7.C7_QUANT-SC7.C7_QUJE) "
	_cQuery2 += " FROM  " + RetSqlName("SC7") +" SC7 "
	_cQuery2 += " WHERE SC7.D_E_L_E_T_ = ' ' "
	_cQuery2 += " AND   SC7.C7_PRODUTO = SB2.B2_COD "
	_cQuery2 += " AND   SC7.C7_FILIAL  = SB2.B2_FILIAL "
	_cQuery2 += " AND   SC7.C7_LOCAL   = SB2.B2_LOCAL "
	_cQuery2 += " AND   SC7.C7_QUANT   > SC7.C7_QUJE "
	_cQuery2 += " AND   SC7.C7_RESIDUO = ' ' "
	_cQuery2 += " ),0)  AS A10_SLD_PC "
	
	_cQuery2 += " ,NVL((SELECT SUM(SC1.C1_QUANT-SC1.C1_QUJE) "
	_cQuery2 += " FROM  " + RetSqlName("SC1") +" SC1 "
	_cQuery2 += " WHERE SC1.D_E_L_E_T_ = ' ' "
	_cQuery2 += " AND   SC1.C1_PRODUTO = SB2.B2_COD "
	_cQuery2 += " AND   SC1.C1_FILIAL  = SB2.B2_FILIAL "
	_cQuery2 += " AND   SC1.C1_LOCAL   = SB2.B2_LOCAL "
	_cQuery2 += " AND   SC1.C1_QUANT   > SC1.C1_QUJE "
	_cQuery2 += " AND   SC1.C1_RESIDUO = ' ' "
	_cQuery2 += " ),0)  AS A11_SLD_SC "
	
	_cQuery2 += " FROM " + RetSqlName("SB2") +" SB2 "
	
	_cQuery2 += " INNER JOIN " + RetSqlName("SB1") +" SB1 "
	_cQuery2 += " ON SB1.D_E_L_E_T_ = ' ' "
	_cQuery2 += " AND B1_COD = B2_COD "
	
	_cQuery2 += " WHERE SB2.D_E_L_E_T_ = ' ' "
	_cQuery2 += " AND B2_COD = '"+_cProd+"'"
	
	_cQuery2 += " ORDER BY B2_COD, B2_FILIAL, B2_LOCAL "
	
	_cQuery2 := ChangeQuery(_cQuery2)
	
	If Select(_cAlias2) > 0
		(_cAlias2)->(dbCloseArea())
	EndIf
	
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,_cQuery2),_cAlias2)
	
	_aCols02 := {}
	
	dbSelectArea(_cAlias2)
	(_cAlias2)->(dbgotop())
	If  Select(_cAlias2) > 0
		
		While !(_cAlias2)->(Eof())
			aadd(_aCols02 ,{;
				(_cAlias2)->A1_FILIAL,;
				(_cAlias2)->A3_LOCAL,;
				(_cAlias2)->A4_SLD_TOT,;
				(_cAlias2)->A5_EMPENHO,;
				(_cAlias2)->A6_RESERVA,;
				(_cAlias2)->A4_SLD_TOT-(_cAlias2)->A5_EMPENHO-(_cAlias2)->A6_RESERVA,;
				(_cAlias2)->A8_SLD_END,;
				(_cAlias2)->A9_SLD_PRE_NF,;
				(_cAlias2)->A10_SLD_PC,;
				(_cAlias2)->A11_SLD_SC,;
				.F.})
			(_cAlias2)->(dbSkip())
		End
	EndIf
	(_cAlias2)->(DbCloseArea())
	If Len(_aCols02) = 0
		aadd(_aCols02,{'XX','XX',0,0,0,0,0,0,0,0,.f.})
	EndIf
	
Return(_aCols02)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ STCOM004     บAutor  ณJoao Rinaldi    บ Data ณ  29/02/2016 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo utilizada para visualizar o cadastro do Produto     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck Industria Eletrica Ltda.                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบChamado   ณ 002612 - Automatizar Solicita็ใo de Compras                บฑฑ
ฑฑบSolic.    ณ Juliana Queiroz - Depto. Compras                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function STCOM004(_oLbx2,_aCols01,_oGet2,_cExpressao)
	
	Local aArea1    := GetArea()
	Local aArea2    := SC1->(GetArea())
	Local aArea3    := SB1->(GetArea())
	
	If Len(_aCols01) > 0
		If (_aCols01[_oLbx2:nAt][14]) > 0
			DbSelectarea("SB1")
			//SB1->(DbSetOrder(1))//B1_FILIAL+B1_COD
			//SB1->(DbGoTop())
			SB1->(DbGoto((_aCols01[_oLbx2:nAt][14])))
			A010Visul("SB1",(_aCols01[_oLbx2:nAt][14]),3)
			//SB1->(DbCloseArea())
		Else
			Aviso("Visualizar Cadastro de Produto"; //01 - cTitulo - Tํtulo da janela
			,"Favor selecionar um cadastro de produto vแlido para visualiza็ใo."+ Chr(10) + Chr(13) +;
				CHR(10)+CHR(13)+;
				"A็ใo nใo permitida.",; //02 - cMsg - Texto a ser apresentado na janela.
			{"OK"};                          //03 - aBotoes - Array com as op็๕es dos bot๕es.
			,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
			,;                               //05 - cText - Titulo da Descri็ใo (Dentro da Janela)
			,;                               //06 - nRotAutDefault - Op็ใo padrใo usada pela rotina automแtica
			,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
			,.F.;                            //08 - lEdit - Determina se permite a edi็ใo do campo memo
			,;                               //09 - nTimer - Tempo para exibi็ใo da mensagem em segundos.
			,;                               //10 - nOpcPadrao - Op็ใo padrใo apresentada na mensagem.
			)
		Endif
	Endif
	
	_oLbx2:Refresh()
	_oGet2:aCols := aClone(_aCols01[_oLbx2:nAt][15])
	_oGet2:oBrowse:Refresh()
	
	RestArea(aArea3)
	RestArea(aArea2)
	RestArea(aArea1)
	
	_oLbx2:Refresh()
	_oGet2:aCols := aClone(_aCols01[_oLbx2:nAt][15])
	_oGet2:oBrowse:Refresh()
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ STCOM005     บAutor  ณJoao Rinaldi    บ Data ณ  29/02/2016 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo utilizada para atualizar a tela de acordo com a     บฑฑ
ฑฑบ          ณ expressใo digitada                                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck Industria Eletrica Ltda.                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบChamado   ณ 002612 - Automatizar Solicita็ใo de Compras                บฑฑ
ฑฑบSolic.    ณ Juliana Queiroz - Depto. Compras                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function STCOM005(_oLbx2,_aCols01,_oGet2,_cExpressao)
	
	Local lRet 	:= .T.
	
	If !(Empty(_cExpressao))
		_aCols01 := {}
		_aCols02 := {}
		_cFiltro  := STCOM006(_cExpressao)
		Processa( {|| STCOM002(_cFiltro) }, "Aguarde.", ,.F.)
		
		If Len(_aCols01) > 0
			_oLbx2:SetArray( _aCols01 )
			_oLbx2:bLine := {|| { _aCols01[_oLbx2:nAt,1]    ,;
				_aCols01[_oLbx2:nAt,2],;
				_aCols01[_oLbx2:nAt,3],;
				_aCols01[_oLbx2:nAt,4],;
				_aCols01[_oLbx2:nAt,5],;
				_aCols01[_oLbx2:nAt,6],;
				_aCols01[_oLbx2:nAt,7],;
				_aCols01[_oLbx2:nAt,8],;
				_aCols01[_oLbx2:nAt,9],;
				_aCols01[_oLbx2:nAt,10],;
				_aCols01[_oLbx2:nAt,11],;
				_aCols01[_oLbx2:nAt,12],;
				_aCols01[_oLbx2:nAt,13],;
				_aCols01[_oLbx2:nAt,14];
				}}
			_oLbx2:Refresh()
			If 	len(_aCols01) > 0
				_oGet2:aCols := aClone(_aCols01[_oLbx2:nAt][15])
				_oGet2:oBrowse:Refresh()
			Endif
		Else
			lRet := .F.
			aadd(_aCols02,{'XX','XX',0,0,0,0,0,0,0,0,.f.})
			aadd(_aCols01,{;
				oPreto,;
				SPACE(TamSx3("B1_COD")[1]+TamSx3("B1_COD")[2]),;
				SPACE(TamSx3("B1_DESC")[1]+TamSx3("B1_DESC")[2]),;
				SPACE(TamSx3("BM_DESC")[1]+TamSx3("BM_DESC")[2]),;
				SPACE(TamSx3("B1_TIPO")[1]+TamSx3("B1_TIPO")[2]),;
				SPACE(TamSx3("B1_UM")[1]+TamSx3("B1_UM")[2]),;
				SPACE(TamSx3("B1_CLAPROD")[1]+TamSx3("B1_CLAPROD")[2]),;
				SPACE(TamSx3("B1_APROPRI")[1]+TamSx3("B1_APROPRI")[2]),;
				SPACE(TamSx3("B1_LOCPAD")[1]+TamSx3("B1_LOCPAD")[2]),;
				SPACE(TamSx3("B1_QE")[1]+TamSx3("B1_QE")[2]),;
				SPACE(TamSx3("B1_LE")[1]+TamSx3("B1_LE")[2]),;
				SPACE(TamSx3("B1_UREV")[1]+TamSx3("B1_UREV")[2]),;
				SPACE(TamSx3("B1_UCOM")[1]+TamSx3("B1_UCOM")[2]),;
				0,;
				_aCols02})
			_oLbx2:aarray := aClone(_aCols01)
			_oGet2:aCols := aClone(_aCols02)
			_oLbx2:Refresh()
			_oGet2:oBrowse:Refresh()
			Aviso("Pesquisa de Produtos"; //01 - cTitulo - Tํtulo da janela
			,"Nใo foi encontrado nenhum Produto com a expressใo digitada."+ Chr(10) + Chr(13) +;
				CHR(10)+CHR(13)+;
				"Favor Verificar.",; //02 - cMsg - Texto a ser apresentado na janela.
			{"OK"};                          //03 - aBotoes - Array com as op็๕es dos bot๕es.
			,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
			,;                               //05 - cText - Titulo da Descri็ใo (Dentro da Janela)
			,;                               //06 - nRotAutDefault - Op็ใo padrใo usada pela rotina automแtica
			,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
			,.F.;                            //08 - lEdit - Determina se permite a edi็ใo do campo memo
			,;                               //09 - nTimer - Tempo para exibi็ใo da mensagem em segundos.
			,;                               //10 - nOpcPadrao - Op็ใo padrใo apresentada na mensagem.
			)
		EndIf
		
	Else
		Aviso("Pesquisa de Produtos"; //01 - cTitulo - Tํtulo da janela
		,"Favor informar uma expressใo vแlida a ser pesquisada."+ Chr(10) + Chr(13) +;
			CHR(10)+CHR(13)+;
			"A pesquisa de produtos nใo serแ realizada.",; //02 - cMsg - Texto a ser apresentado na janela.
		{"OK"};                          //03 - aBotoes - Array com as op็๕es dos bot๕es.
		,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
		,;                               //05 - cText - Titulo da Descri็ใo (Dentro da Janela)
		,;                               //06 - nRotAutDefault - Op็ใo padrใo usada pela rotina automแtica
		,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
		,.F.;                            //08 - lEdit - Determina se permite a edi็ใo do campo memo
		,;                               //09 - nTimer - Tempo para exibi็ใo da mensagem em segundos.
		,;                               //10 - nOpcPadrao - Op็ใo padrใo apresentada na mensagem.
		)
		lRet       := .F.
		_oLbx2:Refresh()
	Endif
	
Return (lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ STCOM006     บAutor  ณJoao Rinaldi    บ Data ณ  29/02/2016 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo utilizada para retornar o filtro da expressใo a ser บฑฑ
ฑฑบ          ณ pesquisada                                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck Industria Eletrica Ltda.                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบChamado   ณ 002612 - Automatizar Solicita็ใo de Compras                บฑฑ
ฑฑบSolic.    ณ Juliana Queiroz - Depto. Compras                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function STCOM006(_cExpressao)
	
	Local cLike     := ""
	Local _cPesq    := ""
	Local aMatriz   := {}
	Local _ni		:= 0
	cLike   := Alltrim(_cExpressao)
	aMatriz := Strtokarr(cLike,cHR(asc(Space(1))))
	_cFiltro := ''
	
	If _cOpcPesq = "Descri็ใo de Produto"
		_cPesq := 	"B1_DESC"
	ElseIf _cOpcPesq = "C๓digo de Produto"
		_cPesq := 	"B1_COD"
	Endif
	
	For _nI := 1 to Len(aMatriz)
		_cFiltro += " AND "+_cPesq+" LIKE '%" + aMatriz[_nI] + "%'"
	Next _nI
	
	
Return (_cFiltro)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ STCOM007     บAutor  ณJoao Rinaldi    บ Data ณ  29/02/2016 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo utilizada para retornar o filtro da expressใo a ser บฑฑ
ฑฑบ          ณ pesquisada                                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck Industria Eletrica Ltda.                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบChamado   ณ 002612 - Automatizar Solicita็ใo de Compras                บฑฑ
ฑฑบSolic.    ณ Juliana Queiroz - Depto. Compras                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function STCOM007()
	
	Local _lRet := .T.
	
	If !(Empty(_aCols01[_oLbx2:nAt,2]))
		_cPrd := (_aCols01[_oLbx2:nAt,2])
		_lRet     := .T.
		//Return (_oDlg2:End())
	Else
		Aviso("Marca็ใo de Produto"; //01 - cTitulo - Tํtulo da janela
		,"Favor selecionar um cadastro de produto vแlido para marca็ใo."+ Chr(10) + Chr(13) +;
			CHR(10)+CHR(13)+;
			"A็ใo nใo permitida.",; //02 - cMsg - Texto a ser apresentado na janela.
		{"OK"};                          //03 - aBotoes - Array com as op็๕es dos bot๕es.
		,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
		,;                               //05 - cText - Titulo da Descri็ใo (Dentro da Janela)
		,;                               //06 - nRotAutDefault - Op็ใo padrใo usada pela rotina automแtica
		,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
		,.F.;                            //08 - lEdit - Determina se permite a edi็ใo do campo memo
		,;                               //09 - nTimer - Tempo para exibi็ใo da mensagem em segundos.
		,;                               //10 - nOpcPadrao - Op็ใo padrใo apresentada na mensagem.
		)
		_lRet     := .F.
		_cPrd := (_aCols01[_oLbx2:nAt,2])
	Endif
	
Return (_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ChangeLine   บAutor  ณJoao Rinaldi    บ Data ณ  29/02/2016 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo utilizada para a atualizar _oGet2 ap๓s a troca  บฑฑ
ฑฑบ          ณ da linha                                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck Industria Eletrica Ltda.                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบChamado   ณ 002612 - Automatizar Solicita็ใo de Compras                บฑฑ
ฑฑบSolic.    ณ Juliana Queiroz - Depto. Compras                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ChangeLine(_oLbx2,_aCols01,_oGet2)
	
	If 	Len(_aCols01) > 0
		_oGet2:aCols := aClone(_aCols01[_oLbx2:nAt][15])
		_oGet2:oBrowse:Refresh()
	Endif
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ box2aHeader  บAutor  ณJoao Rinaldi    บ Data ณ  29/02/2016 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo utilizada para a montagem do aHeader do _oGet2  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck Industria Eletrica Ltda.                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบChamado   ณ 002612 - Automatizar Solicita็ใo de Compras                บฑฑ
ฑฑบSolic.    ณ Juliana Queiroz - Depto. Compras                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function box2aHeader()
	
	//aAdd(_aHeader,{Tํtulo                 ,Campo          ,Picture                      ,Tamanho                  ,Decimal                   ,Valida็ใo,Reservado        ,Tipo                    ,Reservado,Reservado})
	aAdd(_aHeader2,{RetTitle("B2_FILIAL")    ,"A1_FILIAL"    ,PesqPict("SB2","B2_FILIAL")  ,TamSx3("B2_FILIAL")[1]   ,TamSx3("B2_FILIAL")[2]    ,""       ,"€€€€€€€€€€€€€€€",TamSx3("B2_FILIAL")[3]  ,"","","","",".T."})
	aAdd(_aHeader2,{RetTitle("B2_LOCAL")     ,"A3_LOCAL"     ,PesqPict("SB2","B2_LOCAL")   ,TamSx3("B2_LOCAL")[1]    ,TamSx3("B2_LOCAL")[2]     ,""       ,"€€€€€€€€€€€€€€€",TamSx3("B2_LOCAL")[3]   ,"","","","",".T."})
	aAdd(_aHeader2,{RetTitle("B2_QATU")      ,"A4_SLD_TOT"   ,PesqPict("SB2","B2_QATU")    ,TamSx3("B2_QATU")[1]     ,TamSx3("B2_QATU")[2]      ,""       ,"€€€€€€€€€€€€€€€",TamSx3("B2_QATU")[3]    ,"","","","",".T."})
	aAdd(_aHeader2,{RetTitle("B2_QEMP")      ,"A5_EMPENHO"   ,PesqPict("SB2","B2_QATU")    ,TamSx3("B2_QATU")[1]     ,TamSx3("B2_QATU")[2]      ,""       ,"€€€€€€€€€€€€€€€",TamSx3("B2_QATU")[3]    ,"","","","",".T."})
	aAdd(_aHeader2,{RetTitle("B2_RESERVA")   ,"A6_RESERVA"   ,PesqPict("SB2","B2_QATU")    ,TamSx3("B2_QATU")[1]     ,TamSx3("B2_QATU")[2]      ,""       ,"€€€€€€€€€€€€€€€",TamSx3("B2_QATU")[3]    ,"","","","",".T."})
	aAdd(_aHeader2,{"Saldo Disponํvel"       ,"A7_SLD_DISP"  ,PesqPict("SB2","B2_QATU")    ,TamSx3("B2_QATU")[1]     ,TamSx3("B2_QATU")[2]      ,""       ,"€€€€€€€€€€€€€€€",TamSx3("B2_QATU")[3]    ,"","","","",".T."})
	aAdd(_aHeader2,{RetTitle("B2_QACLASS")   ,"A8_SLD_END"   ,PesqPict("SB2","B2_QATU")    ,TamSx3("B2_QATU")[1]     ,TamSx3("B2_QATU")[2]      ,""       ,"€€€€€€€€€€€€€€€",TamSx3("B2_QATU")[3]    ,"","","","",".T."})
	aAdd(_aHeader2,{"Saldo Pr้ Nota"         ,"A9_SLD_PRE_NF",PesqPict("SB2","B2_QATU")    ,TamSx3("B2_QATU")[1]     ,TamSx3("B2_QATU")[2]      ,""       ,"€€€€€€€€€€€€€€€",TamSx3("B2_QATU")[3]    ,"","","","",".T."})
	aAdd(_aHeader2,{"Saldo Pedido de Compra" ,"A10_SLD_PC"   ,PesqPict("SB2","B2_QATU")    ,TamSx3("B2_QATU")[1]     ,TamSx3("B2_QATU")[2]      ,""       ,"€€€€€€€€€€€€€€€",TamSx3("B2_QATU")[3]    ,"","","","",".T."})
	aAdd(_aHeader2,{"Saldo Solic. de Compra" ,"A11_SLD_SC"   ,PesqPict("SB2","B2_QATU")    ,TamSx3("B2_QATU")[1]     ,TamSx3("B2_QATU")[2]      ,""       ,"€€€€€€€€€€€€€€€",TamSx3("B2_QATU")[3]    ,"","","","",".T."})
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ STCOM002     บAutor  ณJoao Rinaldi    บ Data ณ  29/02/2016 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo utilizada para retornar o campo que estแ sendo      บฑฑ
ฑฑบ          ณ utilizado na consulta padrใo especํfica de produtos para   บฑฑ
ฑฑบ          ณ a Rotina de Solicita็ใo de Compras do m๓dulo Compras (02)  บฑฑ
ฑฑบ          ณ executada via query e chamada pela consulta (SXB) SB1COM   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck Industria Eletrica Ltda.                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบChamado   ณ 002612 - Automatizar Solicita็ใo de Compras                บฑฑ
ฑฑบSolic.    ณ Juliana Queiroz - Depto. Compras                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function STCOM002()
	
	//Private _cVariavel2       := Upper( Alltrim( ReadVar() ) )
	
	//Return (&_cVariavel2)
Return (M->C1_PRODUTO)
