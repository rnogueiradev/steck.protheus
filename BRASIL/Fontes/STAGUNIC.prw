#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"
#include "rwmake.ch"
#include "ap5mail.ch"
#include "TOTVS.CH"
#INCLUDE "STR.CH"
#INCLUDE "FWMVCDEF.CH"
#Include "TOPCONN.CH"
#Define CR chr(13)+ chr(10)
/*====================================================================================\
|Programa  | STAGUNIC          | Autor | GIOVANI.ZAGO             | Dat | 17/04/2015  |
|=====================================================================================|
|Descrição |  STAGUNIC          				                                      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STAGUNIC                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function STAGUNIC()
	*-----------------------------*

	//-- Dimensoes padroes
	Local aSize     := MsAdvSize(, .F., 400)
	Local aInfo 	:= {aSize[1],aSize[2],aSize[3],aSize[4]-12, 1, 1 }
	Local aObjects 	:= {{100, 100,.T.,.T. }}
	Local aPosObj 	:= MsObjSize( aInfo, aObjects,.T. )
	Local nStyle 	:= GD_INSERT+GD_DELETE+GD_UPDATE
	Local nOpca		:= 0
	Local acpos		:= {"XX_QTDD2","XX_COD"}
	Local aButtons	:= {}
	Local _aRet 		:= {}
	Local _aParamBox 	:= {}

	aAdd(aButtons,{"PMSSETAUP"  	,{|| GravaDados()}			,"Gravar interação"		,"Gravar interação"})
	aAdd(aButtons,{"PMSSETAUP"  	,{|| FiltraData()}			,"Filtrar Data"			,"Filtrar Data"})
	aAdd(aButtons,{"PMSSETAUP"  	,{|| FiltraCot()}			,"Filtrar cotação"		,"Filtrar cotação"})

	Private cCadastro := "Agenda Operador - UNICOM"
	Private oDlg
	Private oGetDados1
	Private oGetDados2
	Private oGetDados3
	Private _a01Header := {}
	Private _aCols01   := {}
	Private _a02Header := {}
	Private _aCols02   := {}
	Private _a03Header := {}
	Private _aCols03   := {}
	Private oLbx
	Private aVetor     := {}
	Private oOk	   	   := LoadBitmap( GetResources(), "LBOK" )
	Private oNo	   	   := LoadBitmap( GetResources(), "LBNO" )
	Private	oAmarelo   := LoadBitmap( GetResources(), "BR_AMARELO" )
	Private	oVermelho  := LoadBitmap( GetResources(), "BR_VERMELHO" )
	Private	oVerde	   := LoadBitmap( GetResources(), "BR_VERDE")
	Private	oAzul	   := LoadBitmap( GetResources(), "BR_AZUL")
	Private _cPesq	   := Space(15)
	Private _oPesq
	Private _cVetor	   		:= ''
	Define FONT oFontN  NAME "Arial"
	Define FONT oFontB  NAME "Arial" BOLD
	Private oFontN  	:= TFont():New("Arial",9,25,.T.,.T.,5,.T.,5,.T.,.F.)
	Private oFontB 	    := TFont():New("Arial",9,50,.T.,.T.,5,.T.,5,.T.,.F.)
	Private cAliasLif := 'ST_aVetor'
	Private _aCamposEdit	:= {}
	Private _cCotacao	:= ""

	////U_STZ1B(Upper(cCadastro))//Giovani Zago Log de Acesso 27/03/2017

	DbSelectArea("SA3")
	SA3->(DbSetOrder(7))
	SA3->(DbGoTop())
	If SA3->(DbSeek(xFilial("SA3")+__cUserId))
		If SubStr(SA3->A3_COD,1,1)=="R"
			If !SA3->A3_COD $ "R00104#R00105#R00408#R00224#R00051#R00682#R00268#R00269#R00492#R00184#R00181#R00271#R00143#R00027#R00194#R00382#R00386#R00124#R00234#R00262#R00571#R00165#R00267#R00485#R00585#R00477#R00577#R00479#R00583#R00481#R00268#R00269"
				MsgAlert("Atenção, representante não autorizado para utilizar a rotina!")
				Return
			EndIf
		EndIf
	Else
		MsgAlert("Atenção, seu usuário não está cadastrado como vendedor, verifique!")
		Return
	EndIf

	aadd(aVetor,{.F.,' ',' ',' ',' ',' ',' ',' ',' '})

	AADD(_aParamBox,{1,"Cotação:",Space(6),"","","PP7","",50,.F.})

	If __cUserId $ GetMv("ST_FILAGEN")
		If MsgYesNo("Deseja filtrar uma cotação específica?")
			If ParamBox(_aParamBox,"Cotação",@_aRet,,,.T.,,500)
				_cCotacao := MV_PAR01
			EndIf
		EndIf
	EndIf

	Processa( {|| ST_aVetor()},"Explorando Orçamentos", "")
	ST_a01Header()
	aadd(_aCols01,{' ',' ',' ',0,0,' ',.f.})
	ST_a02Header()
	//aadd(_aCols02,{'01',' ',' ',' ',' ',' ', ctod('  /  /    '),.f.})


	Define MSDialog oDlg Title cCadastro From aSize[7],000 To aSize[6],aSize[5] of GetWndDefault() Pixel

	//	@ 1,1 To aPosObj[1,3]+2,aPosObj[1,4]+2

	@ 035,005 listbox oLbx fields header " ", "Status",'Numero',"Cliente/Loja",'Nome','Data','Vend.01','Vend.02'  size  aPosObj[1,4]/2 , aPosObj[1,3]/2-35  pixel of oDlg on dbLclick(edlista())

	oLbx:SetArray( aVetor )

	oLbx:bLine := {|| {Iif(	aVetor[oLbx:nAt,1],oOk,oNo),;
	aVetor[oLbx:nAt,2],;
	aVetor[oLbx:nAt,3],;
	aVetor[oLbx:nAt,4],;
	aVetor[oLbx:nAt,5],;
	aVetor[oLbx:nAt,6],;
	aVetor[oLbx:nAt,7],;
	aVetor[oLbx:nAt,8],;
	aVetor[oLbx:nAt,9];
	}}

	_aCamposEdit := {"Z1Y_MOTIVO","Z1Y_OBS","Z1Y_RETORN"}

	oGetDados1 := MsNewGetDados():New( 35 					, aPosObj[1,4]/2+10		, aPosObj[1,3]/2	, aPosObj[1,4]-5		, GD_INSERT+GD_DELETE+GD_UPDATE					,"AllWaysTrue","AllWaysTrue",""			,	 			 ,/*freeze*/,999,/*fieldok*/,/*superdel*/,/*delok*/,oDlg,_a01Header,_aCols01)
	oGetDados2 := MsNewGetDados():New( aPosObj[1,3]/2+10 	, 05					, aPosObj[1,3]		, aPosObj[1,4]-5		, GD_INSERT+GD_DELETE+GD_UPDATE					,"AllWaysTrue","AllWaysTrue",""			,	_aCamposEdit ,/*freeze*/,999,/*fieldok*/,/*superdel*/,/*delok*/,oDlg,_a02Header,_aCols02)

	MsNewGetDados():SetEditLine (.T.)

	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| nOpca := 1,oDlg:End() },{||oDlg:End()},,aButtons)

Return

Static Function ST_aVetor(_dDtDe,_dDtAte,_lFitro,_cCot)

	Local cQuery    := ' '
	Default _lFitro := .F.
	Default _cCot	:= ""
	ProcRegua(10)

	IncProc()

	aVetor     := {}

	cQuery := " SELECT
	cQuery += " PP7_CODIGO
	cQuery += ' "NUM", PP7_EMISSA "EMISSAO",
	cQuery += " PP7_CLIENT||'-'||PP7_LOJA
	cQuery += ' "CLIENTE",
	cQuery += " PP7_NOME
	cQuery += ' "NOME",

	cQuery += " PP7_REPRES||' - '||  NVL((SELECT A3_NREDUZ FROM "+RetSqlName("SA3")+" SA3 "
	cQuery += "   WHERE SA3.D_E_L_E_T_ = ' '
	cQuery += "   AND SA3.A3_COD = PP7_REPRES
	cQuery += "   AND SA3.A3_FILIAL = ' ' ),' ')
	cQuery += '   "VEND1",
	cQuery += " PP7_VEND||' - '||  NVL((SELECT A3_NREDUZ FROM "+RetSqlName("SA3")+" SA3 "
	cQuery += "   WHERE SA3.D_E_L_E_T_ = ' '
	cQuery += "   AND SA3.A3_COD = PP7_VEND
	cQuery += "   AND SA3.A3_FILIAL = ' ' ),' ')
	cQuery += '   "VEND2"

	cQuery += "  FROM "+RetSqlName("PP7")+" PP7 "
	cQuery += " WHERE PP7.D_E_L_E_T_ = ' '
	cQuery += " AND   PP7.PP7_FILIAL = '"+cFilAnt+"'
	cQuery += " AND   PP7.PP7_PEDIDO = ' '
	//cQuery += " AND   PP7.PP7_CANC = ' '
	//cQuery += " AND   PP7.PP7_CODCANC = ' '
	cQuery += " AND   PP7.PP7_ZBLOQ<>'3'

	If !Empty(_cCot)
		cQuery += " AND PP7.PP7_CODIGO='"+_cCot+"' "
	EndIf

	If Empty(_cCotacao)
		DbSelectArea("SA3")
		SA3->(DbSetOrder(7))
		SA3->(DbGoTop())
		If SA3->(DbSeek(xFilial("SA3")+__cUserId))
			//cQuery += " AND   PP7.PP7_REPRES='"+SA3->A3_COD+"'
			If __cUserId = '000000'
				cQuery += " and (SUBSTR(PP7.PP7_REPRES,1,1)='R' OR SUBSTR(PP7.PP7_VEND,1,1)='R' ) "
			ElseIf SubStr(SA3->A3_COD,1,1)=="R"
				cQuery += " AND ( PP7.PP7_REPRES='"+SA3->A3_COD+"' OR PP7.PP7_VEND='"+SA3->A3_COD+"' ) "
			ElseIf SubStr(SA3->A3_COD,1,1)=="I"
				cQuery += " AND ( PP7.PP7_REPRES='"+SA3->A3_COD+"' OR PP7.PP7_VEND='"+SA3->A3_COD+"' OR "
				//Chamado 003720 - Solicitado acesso as cotações dos representates para os vendedores internos
				cQuery += " SUBSTR(PP7.PP7_REPRES,1,1)='R' OR SUBSTR(PP7.PP7_VEND,1,1)='R' OR "
				//Chamado 005905 - Solicitado acesso as cotações dos vendedores internos para as cotações de externos.
				cQuery += " SUBSTR(PP7.PP7_REPRES,1,1)='E' OR SUBSTR(PP7.PP7_VEND,1,1)='E' ) "

			Else
				cQuery += " AND ( PP7.PP7_REPRES='"+SA3->A3_COD+"' OR PP7.PP7_VEND='"+SA3->A3_COD+"' ) "
			EndIf
		Else
			aadd(aVetor,{.f.,' ',' ',' ',' ',' ',' '})
			Return
		EndIf
	Else
		cQuery += " AND PP7.PP7_CODIGO='"+_cCotacao+"' "
	EndIf

	If _lFitro
		cQuery += " AND PP7.PP7_EMISSA BETWEEN '"+DTOS(_dDtDe)+"' AND '"+DTOS(_dDtAte)+"'
	EndIf

	If __cuserid = '000000'
		cQuery += " AND PP7.PP7_EMISSA > '20151010'
	EndIf
	cQuery += " ORDER BY   PP7.PP7_CODIGO

	cQuery := ChangeQuery(cQuery)

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
	IncProc()
	dbSelectArea(cAliasLif)
	dbSelectArea('Z1Y')
	Z1Y->(DbSetOrder(1))
	If  Select(cAliasLif) > 0
		(cAliasLif)->(dbgotop())

		While !(cAliasLif)->(Eof())
			IncProc()
			aadd(aVetor ,{ .F. 	 ,; //01
			STRETLEG(cFilAnt,(cAliasLif)->NUM)/*IIf( Z1Y->(dbseek(cFilAnt+(cAliasLif)->NUM)), oAmarelo	,oVermelho)*/ 		 ,;	//02   item
			(cAliasLif)->NUM	 ,;	//03   produto
			(cAliasLif)->CLIENTE ,;	//04   descrição
			(cAliasLif)->NOME	 ,;	//05 desenho
			DTOC(STOD((cAliasLif)->EMISSAO)),;
			(cAliasLif)->VEND1	 ,;
			(cAliasLif)->VEND2	 ,;
			' '	})

			(cAliasLif)->(dbSkip())
		End
	EndIf

	If Len(aVetor) = 0
		aadd(aVetor,{.F.,' ',' ',' ',' ',' ',' ',' ',' '})
	EndIf

	Return()

	/*====================================================================================\
	|Programa  | EdLista          | Autor | GIOVANI.ZAGO             | Data | 10/07/2014  |
	|=====================================================================================|
	|Descrição |                                                                          |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | EdLista                                                                  |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/
	*-----------------------------*
Static Function EdLista(_cEdit)
	*-----------------------------*
	Local b  		:= 0

	for b:= 1 to Len(aVetor)

		aVetor[b,1]	:= .f.

	next b

	aVetor[oLbx:nAt,1]	:= .t.
	STACOLS01(aVetor[oLbx:nAt,3])
	STACOLS02(aVetor[oLbx:nAt,3])
	oGetDados1:acols:=_aCols01

	If Len(aVetor) = 0
		aadd(aVetor,{.f.,oAzul,' ',' ',' ',' ',' '})
	EndIf

	oLbx:SetArray( aVetor )

	oLbx:bLine := {|| {Iif(	aVetor[oLbx:nAt,1],oOk,oNo),;
	aVetor[oLbx:nAt,2],;
	aVetor[oLbx:nAt,3],;
	aVetor[oLbx:nAt,4],;
	aVetor[oLbx:nAt,5],;
	aVetor[oLbx:nAt,6],;
	aVetor[oLbx:nAt,7],;
	aVetor[oLbx:nAt,8];
	}}
	oGetDados1:Refresh()
	oGetDados2:Refresh()
	oLbx:Refresh()
	oDlg:Refresh()

Return (.T.)

/*====================================================================================\
|Programa  | STACOLS01        | Autor | GIOVANI.ZAGO             | Data | 10/07/2014  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STACOLS01                                                                |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

Static Function STACOLS01(_cUb)

	Local cAliasCol := 'STACOLS01'
	Local cQuery    := ' '
	ProcRegua(10)

	IncProc()

	cQuery := " SELECT *
	cQuery += "  FROM "+RetSqlName("PP8")+" PP8 "
	cQuery += " WHERE PP8.D_E_L_E_T_ = ' '
	cQuery += " AND   PP8.PP8_FILIAL  = '"+cFilAnt+"'
	cQuery += " AND   PP8.PP8_CODIGO     = '"+_cUb+"'"
	cQuery += " ORDER BY   PP8.PP8_ITEM

	cQuery := ChangeQuery(cQuery)

	If Select(cAliasCol) > 0
		(cAliasCol)->(dbCloseArea())
	EndIf
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasCol)
	IncProc()
	_aCols01:= {}
	dbSelectArea(cAliasCol)
	If  Select(cAliasCol) > 0
		(cAliasCol)->(dbgotop())

		While !(cAliasCol)->(Eof())
			IncProc()
			aadd(_aCols01 ,{ (cAliasCol)->PP8_ITEM	 ,; //01
			(cAliasCol)->PP8_PROD		 ,;	//02   item
			(cAliasCol)->PP8_DESCR	  			 ,;	//03   produto
			(cAliasCol)->PP8_QUANT		 ,;	//04   descrição
			(cAliasCol)->PP8_PRORC	 ,;
			(cAliasCol)->PP8_CODIGO	 ,;
			.f.})

			(cAliasCol)->(dbSkip())
		End
	EndIf

	If Len(_aCols01) = 0
		aadd(_aCols01,{' ',' ',' ',0,0,' ',.f.})
	EndIf

	Return()
	/*====================================================================================\
	|Programa  | ST_a01Header     | Autor | GIOVANI.ZAGO             | Data | 10/07/2014  |
	|=====================================================================================|
	|Descrição |                                                                          |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | ST_a01Header                                                             |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/
	*-----------------------------*
Static Function ST_a01Header()
	*-----------------------------*
	aAdd(_a01Header,{"Item",			"XX_ITEM"	,"@!",TamSx3("D2_ITEMPV")[1],0,"","€€€€€€€€€€€€€€€","C","","","","",".T."})
	aAdd(_a01Header,{"Produto",			"XX_COD"	,"@!",TamSx3("D2_COD")[1]	,0,"U_xGATPROD()","€€€€€€€€€€€€€€€","C","SB1","","","",".T."})
	aAdd(_a01Header,{"Descricao",		"XX_DESC"	,"@!",TamSx3("B1_DESC")[1]	,0,"","€€€€€€€€€€€€€€€","C","","","","",".T."})
	aAdd(_a01Header,{"Qtd.",	   		"XX_QTDD2"	,"@E 999,999.99",TamSx3("D2_QUANT")[1],TamSx3("D2_QUANT")[2],"","€€€€€€€€€€€€€€€","N","","","","",".T."})
	//aAdd(_a01Header,{"Prc.Ven",	   		"XX_PRC"	,"@E 999,999.99",TamSx3("C6_PRCVEN")[1],TamSx3("C6_PRCVEN")[2],"","€€€€€€€€€€€€€€€","N","","","","",".T."})
	aAdd(_a01Header,{"Prc.Ven.",		"XX_QTDD3"	,"@E 999,999.99",TamSx3("D2_QUANT")[1],TamSx3("D2_QUANT")[2],"","€€€€€€€€€€€€€€€","N","","","","",".T."})
	aAdd(_a01Header,{"Numero",			"XX_NUM"	,"@!",TamSx3("UB_NUM")[1],0,"","€€€€€€€€€€€€€€€","C","","","","",".T."})

	Return()


	/*====================================================================================\
	|Programa  | STACOLS01        | Autor | GIOVANI.ZAGO             | Data | 10/07/2014  |
	|=====================================================================================|
	|Descrição |                                                                          |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | STACOLS01                                                                |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/
	*-----------------------------*
Static Function STACOLS02(_cUb)
	*-----------------------------*

	Local cAliasCol := 'STACOLS02'
	Local cQuery    := ' '
	ProcRegua(10)

	IncProc()

	cQuery := " SELECT *
	cQuery += "  FROM "+RetSqlName("Z1Y")+" Z1Y "
	cQuery += " WHERE Z1Y.D_E_L_E_T_  = ' '
	cQuery += " AND   Z1Y.Z1Y_FILIAL  = '"+cFilAnt+"'
	cQuery += " AND   Z1Y.Z1Y_NUM     = '"+_cUb+"'"

	cQuery += " ORDER BY   Z1Y.Z1Y_ITEM

	cQuery := ChangeQuery(cQuery)

	If Select(cAliasCol) > 0
		(cAliasCol)->(dbCloseArea())
	EndIf
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasCol)
	IncProc()
	_aCols02:= {}
	oGetDados2:aCols	:= {}
	dbSelectArea(cAliasCol)
	If  Select(cAliasCol) > 0
		(cAliasCol)->(dbgotop())

		While !(cAliasCol)->(Eof())
			IncProc()
			aadd(oGetDados2:aCols ,{ (cAliasCol)->Z1Y_ITEM	 ,; //01
			(cAliasCol)->Z1Y_MOTIVO		 ,;	//02   item
			(cAliasCol)->Z1Y_OBS	 ,;
			STOD((cAliasCol)->Z1Y_RETORN)	 ,;
			STOD((cAliasCol)->Z1Y_DTINCL)	 ,;
			.f.})

			(cAliasCol)->(dbSkip())
		End

	EndIf


	If Len(oGetDados2:aCols) = 0
		aadd(oGetDados2:aCols,{'01',Space(6),Space(100),ctod('  /  /    '),ctod('  /  /    '),.f.})
	EndIf

	oGetDados1:Refresh()
	oGetDados2:Refresh()
	oLbx:Refresh()
	oDlg:Refresh()

	Return()

	/*====================================================================================\
	|Programa  | ST_a01Header     | Autor | GIOVANI.ZAGO             | Data | 10/07/2014  |
	|=====================================================================================|
	|Descrição |                                                                          |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | ST_a01Header                                                             |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/
	*-----------------------------*
Static Function ST_a02Header()
	*-----------------------------*
	aAdd(_a02Header,{"Item",			"Z1Y_ITEM"		,"@!",02	,0,,,"C","","R",})
	aAdd(_a02Header,{"Motivo",			"Z1Y_MOTIVO"	,"@!",06	,0,,,"C","","R",})
	//aAdd(_a02Header,{"Descricao",		"Z1Y_DESMOT"	,"@!",50	,0,,,"C","","R",})
	//aAdd(_a02Header,{"Ação",			"Z1Y_ACAO"		,"@!",01	,0,,,"C","","R",})
	aAdd(_a02Header,{"Obs",				"Z1Y_OBS"		,"@!",100	,0,,,"C","","R",})
	//	aAdd(_a02Header,{"Num",				"Z1Y_NUM"		,"@!",06	,0,,,"C","","R",})
	aAdd(_a02Header,{"Dt.Retorno",		"Z1Y_RETORN"	,"  ",08	,0,,,"D","","R",})
	aAdd(_a02Header,{"Data",			"Z1Y_DTINCL"	,"  ",08	,0,,,"D","","R",})

Return()

/*====================================================================================\
|Programa  | STAGENDA          | Autor | GIOVANI.ZAGO             | Dat | 17/04/2015  |
|=====================================================================================|
|Descrição |  STAGENDA          				                                      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STAGENDA                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\==========================	==========================================================*/

Static Function FiltraData()

	Local _aRet 		:= {}
	Local _aParamBox 	:= {}
	Local _nX			:= 1
	Local _aDelPeds	:= {}

	AADD(_aParamBox,{1,"Emissão de:" ,DDATABASE,"99/99/9999","","","",50,.F.})
	AADD(_aParamBox,{1,"Emissão até:",DDATABASE,"99/99/9999","","","",50,.F.})

	If ParamBox(_aParamBox,"Filtrar por emissão",@_aRet,,,.T.,,500)

		Processa( {|| ST_aVetor(MV_PAR01,MV_PAR02,.T.)},"Explorando Orçamentos", "")

	EndIf

	oLbx:SetArray( aVetor )

	oLbx:bLine := {|| {Iif(	aVetor[oLbx:nAt,1],oOk,oNo),;
	aVetor[oLbx:nAt,2],;
	aVetor[oLbx:nAt,3],;
	aVetor[oLbx:nAt,4],;
	aVetor[oLbx:nAt,5],;
	aVetor[oLbx:nAt,6],;
	aVetor[oLbx:nAt,7],;
	aVetor[oLbx:nAt,8],;
	aVetor[oLbx:nAt,9];
	}}

	oGetDados1:Refresh()
	oGetDados2:Refresh()
	oLbx:Refresh()
	oDlg:Refresh()

Return()

/*====================================================================================\
|Programa  | STAGENDA          | Autor | GIOVANI.ZAGO             | Dat | 17/04/2015  |
|=====================================================================================|
|Descrição |  STAGENDA          				                                      	  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STAGENDA                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\==========================	==========================================================*/

Static Function ViPP7lPP7()

	Local aArea		:= GetArea()

	DbSelectArea("PP7")
	PP7->(DbSetOrder(1))
	PP7->(DbGoTop())
	If PP7->(DbSeek(xFilial("PP7")+aVetor[oLbx:nAt,3]))
		TK271CallCenter('PP7',PP7->(Recno()),2)
	Else
		MsgAlert("Orçamento não encontrado!")
	EndIf

	RestArea(aArea)

Return()

/*====================================================================================\
|Programa  | STAGENDA          | Autor | GIOVANI.ZAGO             | Dat | 17/04/2015  |
|=====================================================================================|
|Descrição |  STAGENDA          				                                      	  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STAGENDA                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\==========================	==========================================================*/

Static Function PP7Excel()

	Local aArea		:= GetArea()
	Local aCabec		:= {}
	Local aDados		:= {}

	If !ApOleClient("MSExcel")
		MsgAlert("Microsoft Excel não instalado!")
		Return
	EndIf

	aCabec := {"Filial","Item","Num","Produto","Quant","Valor","Total"}

	DbSelectArea("PP7")
	PP7->(DbSetOrder(1))
	PP7->(DbGoTop())
	If PP7->(DbSeek(xFilial("PP7")+aVetor[oLbx:nAt,3]))

		DbSelectArea("PP8")
		PP8->(DbSetOrder(1))
		PP8->(DbGoTop())
		PP8->(DbSeek(PP7->(PP7_FILIAL+PP7_CODIGO)))
		While PP8->(!Eof()) .And. PP7->(PP7_FILIAL+PP7_CODIGO)==PP8->(PP8_FILIAL+PP8_NUM)
			AAdd(aDados, {PP8->PP8_FILIAL,PP8->PP8_ITEM,PP8->PP8_CODIGO,PP8->PP8_PROD,CVALTOCHAR(PP8->PP8_QUANT),CVALTOCHAR(PP8->PP8_PRORC),CVALTOCHAR(PP8->PP8_PRORC)})
			PP8->(DbSkip())
		EndDo

	Else
		MsgAlert("Orçamento não encontrado!")
	EndIf

	DlgToExcel({ {"ARRAY", "ORÇAMENTO", aCabec, aDados} })

	RestArea(aArea)

Return()
/*
User Function STNXTZ1Y()

Local _cItem

If ValType(oGetDados2)=="U"
_cItem	:= "01"
Else
_cItem	:= PADL(Len(oGetDados2:aCols),2,"0")
EndIf

Return(_cItem)
*/
Static Function GravaDados()

	Local _nPosMotivo	:= aScan(_a02Header,{|x| Upper(AllTrim(x[2])) == "Z1Y_MOTIVO"})
	Local _nPosObs		:= aScan(_a02Header,{|x| Upper(AllTrim(x[2])) == "Z1Y_OBS"})
	Local _nPosDtRet	:= aScan(_a02Header,{|x| Upper(AllTrim(x[2])) == "Z1Y_RETORN"})
	Local _nPosItem		:= aScan(_a02Header,{|x| Upper(AllTrim(x[2])) == "Z1Y_ITEM"})
	Local _lContinua	:= .T.
	Local _nX			:= 0
	Local _cEmail   := " "
	Local _cCopia   := ""
	Local _cAssunto := 'Novo chamado ERP'
	Local cMsg	    := ""
	Local cAttach   := ''
	Local _aAttach  := {}
	Local _cCaminho := ''
	Local _cSpur    := ''

	For _nx := 1 To Len(oGetDados2:aCols)

		If !(AllTrim(oGetDados2:aCols[_nx][_nPosMotivo])=="8") .And. !Empty(oGetDados2:aCols[_nx][_nPosDtRet])
			MsgAlert("Atenção, motivo diferente de 8 e data de retorno preenchida (ITEM: "+oGetDados2:aCols[_nx][_nPosItem]+")")
			_lContinua	:=	.F.
		EndIf
		If AllTrim(oGetDados2:aCols[_nx][_nPosMotivo])=="8" .And. Empty(oGetDados2:aCols[_nx][_nPosDtRet])
			MsgAlert("Atenção, motivo 8 e data de retorno não preenchida (ITEM: "+oGetDados2:aCols[_nx][_nPosItem]+")")
			_lContinua	:=	.F.
		EndIf
		If Empty(oGetDados2:aCols[_nx][_nPosMotivo]) .Or. Empty(oGetDados2:aCols[_nx][_nPosObs])
			MsgAlert("Atenção, motivo ou observação não preenchidos (ITEM: "+oGetDados2:aCols[_nx][_nPosItem]+")")
			_lContinua	:=	.F.
		EndIf
		If Empty(oLbx:aArray[oLbx:nAt,3])
			MsgAlert("Atenção, nenhuma cotação foi selecionada, verifique!")
			_lContinua	:=	.F.
		EndIf

	Next

	If !_lContinua
		Return
	EndIf

	For _nx := 1 To Len(oGetDados2:aCols)

		DbSelectArea("Z1Y")
		Z1Y->(DbSetOrder(1))
		Z1Y->(DbGoTop())
		If Z1Y->(DbSeek(cFilAnt+aVetor[oLbx:nAt,3]+oGetDados2:aCols[_nx][_nPosItem]))

			Z1Y->(RecLock("Z1Y",.F.))
			Z1Y->Z1Y_MOTIVO	:= oGetDados2:aCols[_nx][_nPosMotivo]

			DbSelectArea("SA3")
			SA3->(DbSetOrder(7))
			If SA3->(dbSeek(xFilial("SA3")+__cUserId))
				Z1Y->Z1Y_VEND 		:= SA3->A3_COD
				Z1Y->Z1Y_NVEND 		:= SA3->A3_NOME
			EndIf

			Z1Y->Z1Y_DTINCL	:= Date()
			Z1Y->Z1Y_HORA	:= SubStr(TIME(), 1, 5)
			Z1Y->Z1Y_CUSERI	:= __cUserId
			Z1Y->Z1Y_OBS	:= oGetDados2:aCols[_nx][_nPosObs]
			If !Empty(oGetDados2:aCols[_nx][_nPosDtRet])
				Z1Y->Z1Y_RETORN	:= oGetDados2:aCols[_nx][_nPosDtRet]
			EndIf

			Z1Y->(MsUnLock())

		Else

			Z1Y->(RecLock("Z1Y",.T.))
			Z1Y->Z1Y_FILIAL	:= cFilAnt
			Z1Y->Z1Y_NUM	:= oLbx:aArray[oLbx:nAt,3]
			Z1Y->Z1Y_ITEM	:= oGetDados2:aCols[_nx][_nPosItem]
			Z1Y->Z1Y_MOTIVO	:= oGetDados2:aCols[_nx][_nPosMotivo]

			DbSelectArea("SA3")
			SA3->(DbSetOrder(7))
			If SA3->(dbSeek(xFilial("SA3")+__cUserId))
				Z1Y->Z1Y_VEND 		:= SA3->A3_COD
				Z1Y->Z1Y_NVEND 		:= SA3->A3_NOME
			EndIf

			Z1Y->Z1Y_DTINCL	:= Date()
			Z1Y->Z1Y_HORA	:= SubStr(TIME(), 1, 5)
			Z1Y->Z1Y_CUSERI	:= __cUserId
			Z1Y->Z1Y_OBS	:= oGetDados2:aCols[_nx][_nPosObs]
			If !Empty(oGetDados2:aCols[_nx][_nPosDtRet])
				Z1Y->Z1Y_RETORN	:= oGetDados2:aCols[_nx][_nPosDtRet]
			EndIf
			Z1Y->(MsUnLock())

		EndIf

		If Len(oGetDados2:aCols)==_nx .And. AllTrim(oGetDados2:aCols[Len(oGetDados2:aCols)][_nPosMotivo])=="8"
			_cAssunto	:= "[WFPROTHEUS] - Orçamento Unicon: "+Z1Y->Z1Y_NUM+" alterado para data de retorno: "+DTOC(Z1Y->Z1Y_RETORN)
			_cOrc:=Z1Y->Z1Y_NUM
			If getmv("ST_AGZZI",,.T.)
				cMsg	:= 	STASSUNT(_cOrc)
			EndIf

			DbSelectArea("PP7")
			PP7->(DbSetOrder(1))
			PP7->(DbGoTop())
			If PP7->(DbSeek(xFilial("PP7")+_cOrc))

				DbSelectArea('SA3')
				SA3->(DbSetOrder(1))
				If SA3->(dbSeek(xFilial('SA3')+PP7->PP7_REPRES))
					_cSpur:=SA3->A3_SUPER
					DbSelectArea('SA3')
					SA3->(DbSetOrder(1))
					If SA3->(dbSeek(xFilial('SA3')+_cSpur))

						_cEmail+= " ;  "+SA3->A3_EMAIL

					EndIf

				EndIf

			EndIf

			U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)

		EndIf

	Next

	If AllTrim(oGetDados2:aCols[Len(oGetDados2:aCols)][_nPosMotivo])<>"8" //Cancelar orçamento automáticamente e tirar da lista

		DbSelectArea("PP7")
		PP7->(DbSetOrder(1))
		PP7->(DbGoTop())
		If PP7->(DbSeek(xFilial("PP7")+aVetor[oLbx:nAt,3]))
			PP7->(RecLock("PP7",.F.))
			PP7->PP7_ZBLOQ	:= "3"
			_cMsgCan 		:=	"Solicitante: " + cUserName+CRLF+;
			"Solicitação em " + DtoC(dDatabase) + " às " + Time() + CRLF +;
			"Motivo do Cancelamento: "+ Upper(PADL(Alltrim(oGetDados2:aCols[Len(oGetDados2:aCols)][_nPosMotivo]),6,"0"))+CRLF+;
			"Descrição da Solicitação: " + CRLF + Upper(Alltrim(oGetDados2:aCols[Len(oGetDados2:aCols)][_nPosObs]))
			PP7->PP7_XCODMC := PADL(Alltrim(oGetDados2:aCols[Len(oGetDados2:aCols)][_nPosMotivo]),6,"0")
			PP7->PP7_STATUS := "7"
			PP7->(MsUnLock())
			PP7->(RecLock("PP7",.F.))
			MSMM(PP7->PP7_XCODCA,,,_cMsgCan,1,,,"PP7", "PP7_XCODCA",,.T.)
			PP7->(MsUnLock())
		EndIf

		//Chamado 003486
		_cAssunto	:= "[WFPROTHEUS] - Orçamento Unicon: "+PP7->PP7_CODIGO+" baixado, motivo: "+AllTrim(Posicione("PA3",1,xFilial("PA3")+Upper(PADL(Alltrim(oGetDados2:aCols[Len(oGetDados2:aCols)][_nPosMotivo]),6,"0")),"PA3_DESCRI"))+" "+Upper(Alltrim(oGetDados2:aCols[Len(oGetDados2:aCols)][_nPosObs]))
		_cOrc:=PP7->PP7_REPRES
		If getmv("ST_AGZZI",,.T.)
			cMsg	:= 	STASSUNT(PP7->PP7_CODIGO)
		EndIf

		DbSelectArea('SA3')
		SA3->(DbSetOrder(1))
		If SA3->(dbSeek(xFilial('SA3')+_cOrc))
			_cSpur:=SA3->A3_SUPER
			DbSelectArea('SA3')
			SA3->(DbSetOrder(1))
			If SA3->(dbSeek(xFilial('SA3')+_cSpur))

				_cEmail+= " ;  "+SA3->A3_EMAIL

			EndIf

		EndIf

		U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)


		oGetDados2:aCols	:= {}

	EndIf

	MsgAlert("Gravação efetuada com sucesso!")

	Processa( {|| ST_aVetor()},"Explorando Orçamentos", "")

	oGetDados1:Refresh()
	oGetDados2:Refresh()
	oLbx:Refresh()
	oDlg:Refresh()

Return()

Static Function STRETLEG(_cFilial,_cNum)

	Local _cQuery		:= ""
	Local _cAlias		:= "QRYTEMP"

	_cQuery  := " SELECT * "
	_cQuery  += " FROM "+RetSqlName("Z1Y")+" ZY "
	_cQuery  += " WHERE ZY.D_E_L_E_T_=' ' AND Z1Y_FILIAL='"+_cFilial+"' AND Z1Y_NUM='"+_cNum+"' AND Z1Y_RETORN<>' ' "
	_cQuery  += " ORDER BY Z1Y_RETORN DESC "

	If !Empty(Select(_cAlias))
		DbSelectArea(_cAlias)
		(_cAlias)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.T.,.T.)

	dbSelectArea(_cAlias)
	(_cAlias)->(dbGoTop())

	If (_cAlias)->(!Eof())
		Do case
			Case STOD((_cAlias)->Z1Y_RETORN)<Date()
			Return(oVermelho)
			Case STOD((_cAlias)->Z1Y_RETORN)>Date()
			Return(oAzul)
			Case STOD((_cAlias)->Z1Y_RETORN)=Date()
			Return(oVerde)
		EndCase
	Else
		Return(oAmarelo)
	EndIf

Return()

/*====================================================================================\
|Programa  | STAGENDA          | Autor | GIOVANI.ZAGO             | Dat | 17/04/2015  |
|=====================================================================================|
|Descrição |  STAGENDA          				                                      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STAGENDA                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\==========================	==========================================================*/

Static Function FiltraCot()

	Local _aRet 		:= {}
	Local _aParamBox 	:= {}
	Local _nX			:= 1
	Local _aDelPeds	:= {}

	AADD(_aParamBox,{1,"Cotação" ,Space(6),"","EXISTCPO('PP7')","PP7","",50,.F.})

	If ParamBox(_aParamBox,"Filtrar cotação",@_aRet,,,.T.,,500)

		Processa( {|| ST_aVetor(,,,MV_PAR01)},"Explorando Orçamentos", "")

	EndIf

	oLbx:SetArray( aVetor )

	oLbx:bLine := {|| {Iif(	aVetor[oLbx:nAt,1],oOk,oNo),;
	aVetor[oLbx:nAt,2],;
	aVetor[oLbx:nAt,3],;
	aVetor[oLbx:nAt,4],;
	aVetor[oLbx:nAt,5],;
	aVetor[oLbx:nAt,6],;
	aVetor[oLbx:nAt,7],;
	aVetor[oLbx:nAt,8],;
	aVetor[oLbx:nAt,9];
	}}

	oGetDados1:Refresh()
	oGetDados2:Refresh()
	oLbx:Refresh()
	oDlg:Refresh()

Return()

Static Function STASSUNT(_cOrc)
	Local aArea 	:= GetArea()
	Local _cFrom   := "protheus@steck.com.br"
	Local _cAssunto:= ' '
	Local cFuncSent:= "STASSUNT"
	Local i        := 0
	Local cArq     := ""
	Local cMsg     := ""
	Local _nLin
	Local _cCopia  := ' '
	Local cAttach  := ''
	Local _aMsg := {}
	Local _cQry := ""

	If __cuserid = '000000'
		_cAssunto:=_cAssunto+ " TESTE DE ENVIO DE EMAIL FAVOR DESCONSIDERAR"
	EndIf

	DbSelectArea("PP7")
	PP7->(DbSetOrder(1))
	PP7->(DbGoTop())
	If PP7->(DbSeek(xFilial("PP7")+_cOrc))

		Aadd( _aMsg , { "Posicionado: "     , cusername } )
		Aadd( _aMsg , { "Cliente: "    		, PP7->PP7_NOME } )
		Aadd( _aMsg , { "Obra: "    		, PP7->PP7_OBRA } )
		Aadd( _aMsg , { "Vendedor1: "    	, PP7->PP7_REPRES+' - '+ Alltrim(Posicione("SA3",1,xFilial("SA3")+PP7->PP7_REPRES,"A3_NOME")) } )
		Aadd( _aMsg , { "Vendedor2: "    	, PP7->PP7_VEND+' - '+ Alltrim(Posicione("SA3",1,xFilial("SA3")+PP7->PP7_VEND,"A3_NOME")) } )
		Aadd( _aMsg , { "Emissão: "    		,	dtoc(PP7->PP7_EMISSA)  } )
		//>>Chamado 008169 - Everson Santana - 10.10.2018

		If Select("TRD") > 0
			TRD->(DbCloseArea())
		Endif

		_cQry := " "
		_cQry += " SELECT PP8_CODIGO, SUM(PP8_PRORC) PP8_PRORC, SUM(PP8_PRCOM) PP8_PRCOM FROM "+RetSqlName("PP8") "
		_cQry += " WHERE PP8_CODIGO = '" + PP7->PP7_CODIGO +"' "
		_cQry += " AND D_E_L_E_T_ = ' ' "
		_cQry += " GROUP BY PP8_CODIGO "

		TcQuery _cQry New Alias "TRD"

		Aadd( _aMsg , { "VLr Orcado   : "    		,TRANSFORM(TRD->PP8_PRORC ,"@E 99,999,999,999.99")	  } )
		Aadd( _aMsg , { "VLr Comercial : "    		,TRANSFORM(TRD->PP8_PRCOM ,"@E 99,999,999,999.99")	  } )

		//<<Chamado 008169

		DbSelectArea("Z1Y")
		Z1Y->(DbSetOrder(1))
		Z1Y->(DbGoTop())
		If Z1Y->(DbSeek(cFilAnt+_cOrc))
			While !(Z1Y->(Eof())) .And. Z1Y->Z1Y_NUM = _cOrc
				_cMtZ1Y:= ' '
				If Z1Y->Z1Y_MOTIVO ='1'
					_cMtZ1Y:= 'SOMENTE CUSTO'
				ElseIf Z1Y->Z1Y_MOTIVO ='2'
					_cMtZ1Y:= 'OUTRO COMPROU'
				ElseIf Z1Y->Z1Y_MOTIVO ='3'
					_cMtZ1Y:= 'ITENS INCL. PEDIDO'
				ElseIf Z1Y->Z1Y_MOTIVO ='4'
					_cMtZ1Y:= 'COMPROU NO DISTRIBUIDOR'
				ElseIf Z1Y->Z1Y_MOTIVO ='5'
					_cMtZ1Y:= 'PERDEU CONCORRENTE'
				ElseIf Z1Y->Z1Y_MOTIVO ='6'
					_cMtZ1Y:= 'PERDEU COTAÇÃO'
				ElseIf Z1Y->Z1Y_MOTIVO ='7'
					_cMtZ1Y:= 'CANC MASSA'
				ElseIf Z1Y->Z1Y_MOTIVO ='8'
					_cMtZ1Y:= 'COBRAR NOVAMENTE'
				EndIf

				Aadd( _aMsg , { "Nº Alteração: " +Z1Y->Z1Y_ITEM   		, 	_cMtZ1Y } )

				Z1Y->(dbSkip())
			End



		EndIf
	EndIf

	If ( Type("l410Auto") == "U" .OR. !l410Auto )


		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do cabecalho do email                                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cMsg := ""
		cMsg += '<html>'
		cMsg += '<head>'
		cMsg += '<title>' + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
		cMsg += '</head>'
		cMsg += '<body>'
		//cMsg += '<Img Src="C:/AP5/SIGAADV/LGRL01.BMP"><BR>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
		cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do texto/detalhe do email                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For _nLin := 1 to Len(_aMsg)
			IF (_nLin/2) == Int( _nLin/2 )
				cMsg += '<TR BgColor=#B0E2FF>'
			Else
				cMsg += '<TR BgColor=#FFFFFF>'
			EndIF
			cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
			cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
			cMsg += '</TR>'
		Next
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do rodape do email                                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cMsg += '</Table>'
		cMsg += '<P>'
		cMsg += '<Table align="center">'
		cMsg += '<tr>'
		cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">('+cFuncSent+')</td>'
		cMsg += '</tr>'
		cMsg += '</Table>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		//cMsg += '<B><Font Color=#000000 Size="2" Face="Arial"> Atenciosamente </Font></B><BR>'
		//cMsg += '<B><Font Color=#000000 Size="2" Face="Arial">' + SM0->M0_NOMECOM + '</Font></B><BR>'
		//cMsg += '<Img Src="C:/AP5/SIGAADV/LGRL01.BMP">'
		cMsg += '</body>'
		cMsg += '</html>'

	EndIf

	RestArea(aArea)



Return(cMsg)

