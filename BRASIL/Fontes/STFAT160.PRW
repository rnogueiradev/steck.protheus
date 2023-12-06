#INCLUDE "PROTHEUS.CH"
#INCLUDE 'RWMAKE.CH'

/*====================================================================================\
|Programa  | STFAT160         | Autor | Renato Nogueira            | Data | 15/07/2019|
|=====================================================================================|
|Descri็ใo |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 			                                                              |
|=====================================================================================|
|Uso       | Especifico Steck                                                     	  |
|=====================================================================================|
|........................................Hist๓rico....................................|
\====================================================================================*/

User Function STFAT160()

	Local aArea1    := GetArea()
	Local aSize        := MsAdvSize(, .F., 400)
	Local aInfo 	     := {aSize[1],aSize[2],aSize[3],aSize[4]-12, 1, 1 }
	Local aObjects     := {{100, 100,.T.,.T. }}
	Local aPosObj      := MsObjSize( aInfo, aObjects,.T. )
	Local nStyle       := GD_INSERT+GD_DELETE+GD_UPDATE
	Local _aCamposEdit := {}
	Private _oDlg2
	Private _lSaida     := .F.
	Private _cVariavel  := Upper( Alltrim( ReadVar() ) )
	Private _bOk        := {|| _oDlg2:End()}
	Private _bCancel    := {|| _oDlg2:End()}
	Private _aButtons   := {}
	Private _cExpressao := Space(30)
	Private _cOpcPesq   := ""
	Private _cFiltro    := ""
	Private _nCount     := 0
	Private _cPrd       := ""
	Private _oGet2
	Private _aCols01   := {}
	Private _aHeader2  := {}
	aadd(_aCols01,{;
	SPACE(TamSx3("ZM_REF")[1]+TamSx3("ZM_REF")[2]),;
	SPACE(TamSx3("B1_COD")[1]+TamSx3("B1_COD")[2]),;
	SPACE(TamSx3("B1_DESC")[1]+TamSx3("B1_DESC")[2]),;
	SPACE(TamSx3("ZM_EMPRESA")[1]+TamSx3("ZM_EMPRESA")[2]);
	})

	Define MSDialog _oDlg2 Title cCadastro From aSize[7],000 To aSize[6],aSize[5] of GetWndDefault() Pixel

	@ 040,010 SAY   "Informe a Expressใo da Pesquisa: "                            SIZE 100,07  COLOR CLR_BLUE Of _oDlg2 Pixel
	@ 050,010 MSGET _cExpressao     SIZE 100,07 Of _oDlg2 Pixel PICTURE '@!'

	@ 050,100 Button "Pesquisar"    SIZE 35,12 Action STCOM005(@_oLbx2,@_aCols01,@_oGet2,@_cExpressao) Of _oDlg2 Pixel

	@ 075,005 listbox _oLbx2 fields header ;
	"Refer๊ncia",;
	"C๓digo Steck",;
	"Descri็ใo",;
	"Empresa";
	size  aPosObj[1,4] , aPosObj[1,3]-50  pixel of _oDlg2

	_oLbx2:SetArray( _aCols01 )
	_oLbx2:bLine := {|| {_aCols01[_oLbx2:nAt,1],;
	_aCols01[_oLbx2:nAt,2],;
	_aCols01[_oLbx2:nAt,3],;
	_aCols01[_oLbx2:nAt,4];
	}}
	_oLbx2:Refresh()
	_oLbx2:bLDblClick := { ||Eval(_bOk), _oDlg2:End()}

	ACTIVATE MSDIALOG _oDlg2 ON INIT EnchoiceBar(_oDlg2, _bOk, _bCancel,,_aButtons)

	RestArea(aArea1)

Return _lSaida

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

	_cQuery2 := "  SELECT
	_cQuery2 += "  B2_FILIAL AS A1_FILIAL
	_cQuery2 += " ,B2_COD   AS A2_COD
	_cQuery2 += " ,B2_LOCAL AS A3_LOCAL
	_cQuery2 += " ,B2_QATU  AS A4_SLD_TOT

	_cQuery2 += " ,NVL((SELECT SUM(SDC.DC_QUANT)
	_cQuery2 += " FROM  " + RetSqlName("SDC") +" SDC "
	_cQuery2 += " WHERE SDC.D_E_L_E_T_ = ' '
	_cQuery2 += " AND   SDC.DC_PRODUTO = SB2.B2_COD
	_cQuery2 += " AND   SDC.DC_FILIAL  = SB2.B2_FILIAL
	_cQuery2 += " AND   SDC.DC_LOCAL   = SB2.B2_LOCAL
	_cQuery2 += " ),0)  AS A5_EMPENHO

	_cQuery2 += " ,NVL((SELECT SUM(PA2.PA2_QUANT)
	_cQuery2 += " FROM  " + RetSqlName("PA2") +" PA2 "
	_cQuery2 += " WHERE PA2.D_E_L_E_T_ = ' '
	_cQuery2 += " AND   PA2.PA2_CODPRO = SB2.B2_COD
	_cQuery2 += " AND   PA2.PA2_FILRES = SB2.B2_FILIAL
	_cQuery2 += " AND   SB1.B1_LOCPAD  = SB2.B2_LOCAL
	_cQuery2 += " ),0)  AS A6_RESERVA

	_cQuery2 += " ,0 AS A7_SLD_DISP

	_cQuery2 += " ,NVL((SELECT SUM(SDA.DA_SALDO)
	_cQuery2 += " FROM  " + RetSqlName("SDA") +" SDA "
	_cQuery2 += " WHERE SDA.D_E_L_E_T_ = ' '
	_cQuery2 += " AND   SDA.DA_PRODUTO = SB2.B2_COD
	_cQuery2 += " AND   SDA.DA_FILIAL  = SB2.B2_FILIAL
	_cQuery2 += " AND   SDA.DA_LOCAL   = SB2.B2_LOCAL
	_cQuery2 += " ),0)  AS A8_SLD_END

	_cQuery2 += " ,NVL((SELECT SUM(SD1.D1_QUANT)
	_cQuery2 += " FROM  " + RetSqlName("SD1") +" SD1 "
	_cQuery2 += " WHERE SD1.D_E_L_E_T_ = ' '
	_cQuery2 += " AND   SD1.D1_COD     = SB2.B2_COD
	_cQuery2 += " AND   SD1.D1_FILIAL  = SB2.B2_FILIAL
	_cQuery2 += " AND   SD1.D1_LOCAL   = SB2.B2_LOCAL
	_cQuery2 += " AND   SD1.D1_TES     = ' '
	_cQuery2 += " ),0)  AS A9_SLD_PRE_NF

	_cQuery2 += " ,NVL((SELECT SUM(SC7.C7_QUANT-SC7.C7_QUJE)
	_cQuery2 += " FROM  " + RetSqlName("SC7") +" SC7 "
	_cQuery2 += " WHERE SC7.D_E_L_E_T_ = ' '
	_cQuery2 += " AND   SC7.C7_PRODUTO = SB2.B2_COD
	_cQuery2 += " AND   SC7.C7_FILIAL  = SB2.B2_FILIAL
	_cQuery2 += " AND   SC7.C7_LOCAL   = SB2.B2_LOCAL
	_cQuery2 += " AND   SC7.C7_QUANT   > SC7.C7_QUJE
	_cQuery2 += " AND   SC7.C7_RESIDUO = ' '
	_cQuery2 += " ),0)  AS A10_SLD_PC

	_cQuery2 += " ,NVL((SELECT SUM(SC1.C1_QUANT-SC1.C1_QUJE)
	_cQuery2 += " FROM  " + RetSqlName("SC1") +" SC1 "
	_cQuery2 += " WHERE SC1.D_E_L_E_T_ = ' '
	_cQuery2 += " AND   SC1.C1_PRODUTO = SB2.B2_COD
	_cQuery2 += " AND   SC1.C1_FILIAL  = SB2.B2_FILIAL
	_cQuery2 += " AND   SC1.C1_LOCAL   = SB2.B2_LOCAL
	_cQuery2 += " AND   SC1.C1_QUANT   > SC1.C1_QUJE
	_cQuery2 += " AND   SC1.C1_RESIDUO = ' '
	_cQuery2 += " ),0)  AS A11_SLD_SC

	_cQuery2 += " FROM " + RetSqlName("SB2") +" SB2 "

	_cQuery2 += " INNER JOIN SB1010 SB1
	_cQuery2 += " ON SB1.D_E_L_E_T_ = ' '
	_cQuery2 += " AND B1_COD = B2_COD

	_cQuery2 += " WHERE SB2.D_E_L_E_T_ = ' '
	_cQuery2 += " AND B2_COD = '"+_cProd+"'"

	_cQuery2 += " ORDER BY B2_COD, B2_FILIAL, B2_LOCAL

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

		If Len(_cExpressao)<3
			MsgAlert("Aten็ใo, digite pelo menos 3 caracteres para fazer a busca.")
			Return
		EndIf

		_aCols01 := {}

		Processa( {|| STCOM002(_cExpressao) }, "Aguarde.", ,.F.)

		_oLbx2:SetArray( _aCols01 )
		_oLbx2:bLine := {|| { _aCols01[_oLbx2:nAt,1]    ,;
		_aCols01[_oLbx2:nAt,2],;
		_aCols01[_oLbx2:nAt,3],;
		_aCols01[_oLbx2:nAt,4];
		}}
		_oLbx2:Refresh()

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

		_cFiltro := StrTran(_cFiltro," ")
		_cFiltro := StrTran(_cFiltro,"-")

		_cQuery1 := " SELECT B1_COD, B1_DESC, Z37_CONCO EMPRESA, Z37_CODCOC REFCONC
		_cQuery1 += " FROM "+RetSqlName("Z37")+" Z37
		_cQuery1 += " LEFT JOIN "+RetSqlName("SB1")+" B1
		_cQuery1 += " ON B1_COD=Z37_COD
		_cQuery1 += " WHERE Z37.D_E_L_E_T_=' ' AND B1.D_E_L_E_T_=' '
		//_cQuery1 += " AND Z37_CODCOC LIKE '%"+AllTrim(_cFiltro)+"%'
		_cQuery1 += " AND REPLACE(REPLACE(Z37_CODCOC,' ',''),'-','') LIKE '%"+AllTrim(UPPER(_cFiltro))+"%'

		DbUseArea(.T., "TOPCONN", TCGENQRY( , , _cQuery1), _cAlias1, .F., .T.)

		dbSelectArea(_cAlias1)
		(_cAlias1)->(DbGoTop())
		dbeval({||_nCount++})
		DbSelectArea(_cAlias1)
		(_cAlias1)->(DbGoTop())
		If  Select(_cAlias1) > 0
			ProcRegua(_nCount)
			While !(_cAlias1)->(Eof())
				IncProc("Pesquisando Produto, aguarde...")

				Aadd(_aCols01,{;
				(_cAlias1)->REFCONC,;
				(_cAlias1)->B1_COD,;
				(_cAlias1)->B1_DESC,;
				(_cAlias1)->EMPRESA;
				})

				(_cAlias1)->(dbSkip())
			End
		Endif
		(_cAlias1)->(DbCloseArea())
	Endif

Return