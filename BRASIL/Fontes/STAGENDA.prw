#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"
#include "rwmake.ch"
#include "ap5mail.ch"
#include "TOTVS.CH"
//#INCLUDE "STR.CH"
#INCLUDE "FWMVCDEF.CH"
#Define CR chr(13)+ chr(10)

/*====================================================================================\
|Programa  | STAGENDA          | Autor | GIOVANI.ZAGO.             | Dat | 17/04/2015  |
|=====================================================================================|
|Descrição |  STAGENDA          				                                      |
|          |                                                                          |
|          |                                                                        |
|=====================================================================================|
|Sintaxe   | STAGENDA                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\==========================	==========================================================*/

*-----------------------------*
User Function STAGENDA()
	*-----------------------------*

	//-- Dimensoes padroes.
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

	If !IsInCallSteck("U_STFTA001")
		aAdd(aButtons,{"PMSSETAUP"  	,{|| CarrEstru()}			,"Carrega Estrutura"		,"Carrega Estrutura"})
		aAdd(aButtons,{"PMSSETAUP"  	,{|| FiltraData()}			,"Filtrar Data"			,"Filtrar Data"})
		aAdd(aButtons,{"PMSSETAUP"  	,{|| VisualSUA()}			,"Visualizar Cotação"	,"Visualizar Cotação"})
		aAdd(aButtons,{"PMSSETAUP"  	,{|| SUAExcel()}			,"Exportar Cotação"		,"Exportar Cotação"})
		aAdd(aButtons,{"PMSSETAUP"  	,{|| GravaDados()}			,"Gravar interação"		,"Gravar interação"})
		aAdd(aButtons,{"PMSSETAUP"  	,{|| FiltraCot()}			,"Filtrar cotação"		,"Filtrar cotação"})
	EndIf

	Private cCadastro := "Agenda Operador"
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
	Private	oBranco	   := LoadBitmap( GetResources(), "BR_BRANCO")
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
	Private _cUltFil	:= ""


	DbSelectArea("SA3")
	SA3->(DbSetOrder(7))
	SA3->(DbGoTop())
	If SA3->(DbSeek(xFilial("SA3")+__cUserId))
		If SubStr(SA3->A3_COD,1,1)=="R"
			//If !SA3->A3_COD $ "R00104#R00105#R00408#R00224#R00051#R00682#R00268#R00269#R00492#R00184#R00181#R00271#R00143#R00027#R00194#R00382#R00386#R00124#R00234#R00262#R00571#R00165#R00267#R00485#R00585#R00477#R00577#R00479"
			If !SA3->A3_COD $ AllTrim(SuperGetMv("ST_AGENREP",.F.,"")) .And. !SA3->A3_COD $ AllTrim(SuperGetMv("ST_AGENRE2",.F.,""))
				MsgAlert("Atenção, representante não autorizado para utilizar a rotina!")
				Return
			EndIf
		EndIf
	Else
		MsgAlert("Atenção, seu usuário não está cadastrado como vendedor, verifique!")
		Return
	EndIf

	aadd(aVetor,{.F.,oBranco,' ',' ',' ',' ',' ',' ',' '})

	AADD(_aParamBox,{1,"Cotação:",Space(6),"","","SUA","",50,.F.})

	//If __cUserId $ GetMv("ST_FILAGEN")  
	If MsgYesNo("Deseja filtrar uma cotação específica?")
		If ParamBox(_aParamBox,"Cotação",@_aRet,,,.T.,,500)
			_cCotacao := MV_PAR01
		EndIf
	EndIf
	//EndIf

	If !Empty(_cCotacao)
		_cUltFil := "C"
	EndIf

	Processa( {|| ST_aVetor(,,,_cCotacao,.T.)},"Explorando Orçamentos", "")
	ST_a01Header()
	//aadd(_aCols01,{' ',' ',' ',0,0,' ',.f.})
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

	_aCamposEdit := {"ZZY_MOTIVO","ZZY_CODCON","ZZY_OBS","ZZY_RETORN"}

	oGetDados1 := MsNewGetDados():New( 35 					, aPosObj[1,4]/2+10		, aPosObj[1,3]/2	, aPosObj[1,4]-5		, GD_INSERT+GD_DELETE+GD_UPDATE					,"AllWaysTrue","AllWaysTrue",""			,	 			 ,/*freeze*/,999,/*fieldok*/,/*superdel*/,/*delok*/,oDlg,_a01Header,_aCols01)
	oGetDados2 := MsNewGetDados():New( aPosObj[1,3]/2+10 	, 05					, aPosObj[1,3]		, aPosObj[1,4]-5		, GD_INSERT+GD_DELETE+GD_UPDATE					,"AllWaysTrue","AllWaysTrue",""			,	_aCamposEdit ,/*freeze*/,999,/*fieldok*/,/*superdel*/,/*delok*/,oDlg,_a02Header,_aCols02)

	MsNewGetDados():SetEditLine (.T.)

	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| nOpca := 1,oDlg:End() },{||oDlg:End()},,aButtons)

Return

Static Function ST_aVetor(_dDtDe,_dDtAte,_lFitro,_cCot,_lPrim)

	Local cQuery    := ' '
	Default _lFitro := .F.
	Default _cCot	:= ""
	Default _lPrim  := .F.
	ProcRegua(10)

	If _lPrim .And. Empty(_cCot) .And. !(SubStr(SA3->A3_COD,1,1)$"E#R")
		Return
	EndIf

	IncProc()

	aVetor     := {}

	cQuery := " SELECT
	cQuery += " UA_NUM
	cQuery += ' "NUM", UA_EMISSAO "EMISSAO",
	cQuery += " UA_CLIENTE||'-'||UA_LOJA
	cQuery += ' "CLIENTE",
	cQuery += " UA_XNOME
	cQuery += ' "NOME",

	cQuery += " UA_VEND||' - '||  NVL((SELECT A3_NREDUZ FROM "+RetSqlName("SA3")+" SA3 "
	cQuery += "   WHERE SA3.D_E_L_E_T_ = ' '
	cQuery += "   AND SA3.A3_COD = UA_VEND
	cQuery += "   AND SA3.A3_FILIAL = ' ' ),' ')
	cQuery += '   "VEND1",
	cQuery += " UA_VEND2||' - '||  NVL((SELECT A3_NREDUZ FROM "+RetSqlName("SA3")+" SA3 "
	cQuery += "   WHERE SA3.D_E_L_E_T_ = ' '
	cQuery += "   AND SA3.A3_COD = UA_VEND2
	cQuery += "   AND SA3.A3_FILIAL = ' ' ),' ')
	cQuery += '   "VEND2"

	cQuery += "  FROM "+RetSqlName("SUA")+" SUA "
	cQuery += " WHERE SUA.D_E_L_E_T_ = ' '
	cQuery += " AND   SUA.UA_FILIAL = '"+cFilAnt+"'
	cQuery += " AND   SUA.UA_NUMSC5 = ' '
	cQuery += " AND   SUA.UA_CANC = ' '
	cQuery += " AND   SUA.UA_CODCANC = ' '
	cQuery += " AND   SUA.UA_XBLOQ<>'3'

	If !Empty(_cCot)
		cQuery += " AND SUA.UA_NUM='"+_cCot+"' "
	EndIf

	//If Empty(_cCotacao)
	DbSelectArea("SA3")
	SA3->(DbSetOrder(7))
	SA3->(DbGoTop())
	If SA3->(DbSeek(xFilial("SA3")+__cUserId))
		//cQuery += " AND   SUA.UA_VEND2='"+SA3->A3_COD+"'
		If __cUserId $ GetMv("ST_AGTOT",,"000380") //Todas as cotações
			cQuery += ""
		ElseIf SubStr(SA3->A3_COD,1,1)=="R"
			cQuery += " AND ( SUA.UA_VEND2='"+SA3->A3_COD+"' OR SUA.UA_VEND='"+SA3->A3_COD+"' ) "
		ElseIf SubStr(SA3->A3_COD,1,1)=="I"
			cQuery += " AND ( SUA.UA_VEND2='"+SA3->A3_COD+"' OR SUA.UA_VEND='"+SA3->A3_COD+"'
			//Chamado 003720 - Solicitado acesso as cotações dos representates para os vendedores internos
			//If !MsgYesNo("Deseja filtrar somente as suas cotações?")
			cQuery += " OR SUBSTR(SUA.UA_VEND2,1,1)='R' OR SUBSTR(SUA.UA_VEND,1,1)='R'
			//Chamado 005905 - Solicitado acesso as cotações dos vendedores internos para as cotações de externos.
			cQuery += " OR SUBSTR(SUA.UA_VEND2,1,1)='E' OR SUBSTR(SUA.UA_VEND,1,1)='E'"
			//EndIf
			cQuery += " )
		Else
			cQuery += " AND ( SUA.UA_VEND2='"+SA3->A3_COD+"' OR SUA.UA_VEND='"+SA3->A3_COD+"' ) "
		EndIf

	Else
		aadd(aVetor,{.F.,' ',' ',' ',' ',' ',' ',' ',' '})
		Return
	EndIf
	//Else
	//	cQuery += " AND SUA.UA_NUM='"+_cCotacao+"' "
	//EndIf

	If _lFitro
		cQuery += " AND SUA.UA_EMISSAO BETWEEN '"+DTOS(_dDtDe)+"' AND '"+DTOS(_dDtAte)+"'
	EndIf

	cQuery += " ORDER BY   SUA.UA_NUM

	cQuery := ChangeQuery(cQuery)

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
	IncProc()
	dbSelectArea(cAliasLif)
	dbSelectArea('ZZY')
	ZZY->(DbSetOrder(1))
	If  Select(cAliasLif) > 0
		(cAliasLif)->(dbgotop())

		While !(cAliasLif)->(Eof())
			IncProc()
			aadd(aVetor ,{ .F. 	 ,; //01
			STRETLEG(cFilAnt,(cAliasLif)->NUM)/*IIf( ZZY->(dbseek(cFilAnt+(cAliasLif)->NUM)), oAmarelo	,oVermelho)*/ 		 ,;	//02   item
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

	If !_lPrim

		oLbx:SetArray(aVetor)

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
		aadd(aVetor,{.f.,oAzul,' ',' ',' ',' ',' ',' '})
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
	cQuery += "  FROM "+RetSqlName("SUB")+" SUB "
	cQuery += " WHERE SUB.D_E_L_E_T_ = ' '
	cQuery += " AND   SUB.UB_FILIAL  = '"+cFilAnt+"'
	cQuery += " AND   SUB.UB_NUM     = '"+_cUb+"'"
	cQuery += " ORDER BY   SUB.UB_ITEM

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
			aadd(_aCols01 ,{ (cAliasCol)->UB_ITEM	 ,; //01
			(cAliasCol)->UB_PRODUTO		 ,;	//02   item
			SUBSTR(Alltrim(Posicione("SB1",1,xFilial("SB1")+(cAliasCol)->UB_PRODUTO,"B1_DESC")),1,40)	  			 ,;	//03   produto
			(cAliasCol)->UB_QUANT		 ,;	//04   descrição
			(cAliasCol)->UB_VRUNIT	 ,;
			(cAliasCol)->UB_NUM	 ,;
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
	cQuery += "  FROM "+RetSqlName("ZZY")+" ZZY "
	cQuery += " WHERE ZZY.D_E_L_E_T_  = ' '
	cQuery += " AND   ZZY.ZZY_FILIAL  = '"+cFilAnt+"'
	cQuery += " AND   ZZY.ZZY_NUM     = '"+_cUb+"'"

	cQuery += " ORDER BY   ZZY.ZZY_ITEM

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
			aadd(oGetDados2:aCols ,{ (cAliasCol)->ZZY_ITEM	 ,; //01
			(cAliasCol)->ZZY_MOTIVO		 ,;	//02   item
			(cAliasCol)->ZZY_CODCON		 ,;					// Valdemir Rabelo 23/10/2020 Ticket 20201022009332
			(cAliasCol)->ZZY_NOMCON		 ,;					// Valdemir Rabelo 23/10/2020 Ticket 20201022009332
			(cAliasCol)->ZZY_OBS	 ,;
			STOD((cAliasCol)->ZZY_RETORN)	 ,;
			STOD((cAliasCol)->ZZY_DTINCL)	 ,;
			.f.})

			(cAliasCol)->(dbSkip())
		End

	EndIf


	If Len(oGetDados2:aCols) = 0
		aadd(oGetDados2:aCols,{'01',Space(6),space(4),Space(40),Space(250),ctod('  /  /    '),ctod('  /  /    '),.f.})
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
	aAdd(_a02Header,{"Item",			"ZZY_ITEM"		,"@!",02	,0,,,"C","","R",})
	aAdd(_a02Header,{"Motivo",			"ZZY_MOTIVO"	,"@!",06	,0,,,"C","","R",})
	aAdd(_a02Header,{"Cod.Conc",		"ZZY_CODCON"	,"@!",03	,0,,,"C","","R",})			// Valdemir Rabelo 23/10/2020 Ticket 20201022009332
	aAdd(_a02Header,{"Nome.Conc",		"ZZY_NOMCON"	,"@!",40	,0,,,"C","","R",})			// Valdemir Rabelo 23/10/2020 Ticket 20201022009332
	//aAdd(_a02Header,{"Descricao",		"ZZY_DESMOT"	,"@!",50	,0,,,"C","","R",})
	//aAdd(_a02Header,{"Ação",			"ZZY_ACAO"		,"@!",01	,0,,,"C","","R",})
	aAdd(_a02Header,{"Obs",				"ZZY_OBS"		,"@!",250	,0,,,"C","","R",})
	//	aAdd(_a02Header,{"Num",				"ZZY_NUM"		,"@!",06	,0,,,"C","","R",})
	aAdd(_a02Header,{"Dt.Retorno",		"ZZY_RETORN"	,"  ",08	,0,,,"D","","R",})
	aAdd(_a02Header,{"Data",			"ZZY_DTINCL"	,"  ",08	,0,,,"D","","R",})

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

		_cCotacao := ""

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

	_cUltFil := "D"

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

Static Function VisualSUA()

	Local aArea		:= GetArea()

	DbSelectArea("SUA")
	SUA->(DbSetOrder(1))
	SUA->(DbGoTop())
	If SUA->(DbSeek(xFilial("SUA")+aVetor[oLbx:nAt,3]))
		TK271CallCenter('SUA',SUA->(Recno()),2)
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

Static Function SUAExcel()

	Local aArea		:= GetArea()
	Local aCabec		:= {}
	Local aDados		:= {}

	If !ApOleClient("MSExcel")
		MsgAlert("Microsoft Excel não instalado!")
		Return
	EndIf

	aCabec := {"Filial","Item","Num","Produto","Quant","Valor","Total"}

	DbSelectArea("SUA")
	SUA->(DbSetOrder(1))
	SUA->(DbGoTop())
	If SUA->(DbSeek(xFilial("SUA")+aVetor[oLbx:nAt,3]))

		DbSelectArea("SUB")
		SUB->(DbSetOrder(1))
		SUB->(DbGoTop())
		SUB->(DbSeek(SUA->(UA_FILIAL+UA_NUM)))
		While SUB->(!Eof()) .And. SUA->(UA_FILIAL+UA_NUM)==SUB->(UB_FILIAL+UB_NUM)
			AAdd(aDados, {SUB->UB_FILIAL,SUB->UB_ITEM,SUB->UB_NUM,SUB->UB_PRODUTO,CVALTOCHAR(SUB->UB_QUANT),CVALTOCHAR(SUB->UB_VRUNIT),CVALTOCHAR(SUB->UB_VLRITEM)})
			SUB->(DbSkip())
		EndDo

	Else
		MsgAlert("Orçamento não encontrado!")
	EndIf

	DlgToExcel({ {"ARRAY", "ORÇAMENTO", aCabec, aDados} })

	RestArea(aArea)

Return()

User Function STNXTZZY()

	Local _cItem

	If ValType(oGetDados2)=="U"
		_cItem	:= "01"
	Else
		_cItem	:= PADL(Len(oGetDados2:aCols),2,"0")
	EndIf

Return(_cItem)

Static Function GravaDados()

	Local _nPosMotivo	:= aScan(_a02Header,{|x| Upper(AllTrim(x[2])) == "ZZY_MOTIVO"})
	Local _nPosObs		:= aScan(_a02Header,{|x| Upper(AllTrim(x[2])) == "ZZY_OBS"})
	Local _nPosDtRet	:= aScan(_a02Header,{|x| Upper(AllTrim(x[2])) == "ZZY_RETORN"})
	Local _nPosItem		:= aScan(_a02Header,{|x| Upper(AllTrim(x[2])) == "ZZY_ITEM"})
	Local _nPosCodCo	:= aScan(_a02Header,{|x| Upper(AllTrim(x[2])) == "ZZY_CODCON"})				// Valdemir Rabelo 23/10/2020 Ticket 20201022009332
	Local _nPosNomCo	:= aScan(_a02Header,{|x| Upper(AllTrim(x[2])) == "ZZY_NOMCON"})				// Valdemir Rabelo 23/10/2020 Ticket 20201022009332
	Local _lContinua	:= .T.
	Local _nX			:= 0
	Local _cEmail   := ""
	Local _cCopia   := ""
	Local _cAssunto := 'Novo chamado ERP'
	Local cMsg	    := ""
	Local cAttach   := ''
	Local _aAttach  := {}
	Local _cCaminho := ''
	Local _cSpur    := ''

	For _nx := 1 To Len(oGetDados2:aCols)

		If (AllTrim(oGetDados2:aCols[_nx][_nPosMotivo])=="5") .And. (Empty(oGetDados2:aCols[_nx][_nPosCodCo]))   // Valdemir Rabelo 06/11/2020 - ticket:  20201022009332
			MsgAlert("Atenção, Obrigatório informar código do concorrente.")
			_lContinua	:=	.F.
		EndIf
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

		DbSelectArea("ZZY")
		ZZY->(DbSetOrder(1))
		ZZY->(DbGoTop())
		If ZZY->(DbSeek(cFilAnt+aVetor[oLbx:nAt,3]+oGetDados2:aCols[_nx][_nPosItem]))

			ZZY->(RecLock("ZZY",.F.))
			ZZY->ZZY_MOTIVO	:= oGetDados2:aCols[_nx][_nPosMotivo]

			DbSelectArea("SA3")
			SA3->(DbSetOrder(7))
			If SA3->(dbSeek(xFilial("SA3")+__cUserId))
				ZZY->ZZY_VEND 		:= SA3->A3_COD
				ZZY->ZZY_NVEND 		:= SA3->A3_NOME
			EndIf

			ZZY->ZZY_DTINCL	:= Date()
			ZZY->ZZY_HORA	:= SubStr(TIME(), 1, 5)
			ZZY->ZZY_CUSERI	:= __cUserId
			ZZY->ZZY_CODCON	:= oGetDados2:aCols[_nx][_nPosCodCo]				// Valdemir Rabelo 23/10/2020 Ticket 20201022009332
			ZZY->ZZY_NOMCON	:= oGetDados2:aCols[_nx][_nPosNomCo]				// Valdemir Rabelo 23/10/2020 Ticket 20201022009332
			ZZY->ZZY_OBS	:= oGetDados2:aCols[_nx][_nPosObs]
			If !Empty(oGetDados2:aCols[_nx][_nPosDtRet])
				ZZY->ZZY_RETORN	:= oGetDados2:aCols[_nx][_nPosDtRet]
			EndIf

			ZZY->(MsUnLock())

		Else

			ZZY->(RecLock("ZZY",.T.))
			ZZY->ZZY_FILIAL	:= cFilAnt
			ZZY->ZZY_NUM	:= oLbx:aArray[oLbx:nAt,3]
			ZZY->ZZY_ITEM	:= oGetDados2:aCols[_nx][_nPosItem]
			ZZY->ZZY_MOTIVO	:= oGetDados2:aCols[_nx][_nPosMotivo]

			DbSelectArea("SA3")
			SA3->(DbSetOrder(7))
			If SA3->(dbSeek(xFilial("SA3")+__cUserId))
				ZZY->ZZY_VEND 		:= SA3->A3_COD
				ZZY->ZZY_NVEND 		:= SA3->A3_NOME
			EndIf

			ZZY->ZZY_DTINCL	:= Date()
			ZZY->ZZY_HORA	:= SubStr(TIME(), 1, 5)
			ZZY->ZZY_CUSERI	:= __cUserId
			ZZY->ZZY_CODCON	:= oGetDados2:aCols[_nx][_nPosCodCo]				// Valdemir Rabelo 23/10/2020 Ticket 20201022009332
			ZZY->ZZY_NOMCON	:= oGetDados2:aCols[_nx][_nPosNomCo]				// Valdemir Rabelo 23/10/2020 Ticket 20201022009332
			ZZY->ZZY_OBS	:= oGetDados2:aCols[_nx][_nPosObs]
			If !Empty(oGetDados2:aCols[_nx][_nPosDtRet])
				ZZY->ZZY_RETORN	:= oGetDados2:aCols[_nx][_nPosDtRet]
			EndIf
			ZZY->(MsUnLock())

		EndIf

		If Len(oGetDados2:aCols)==_nx .And. AllTrim(oGetDados2:aCols[Len(oGetDados2:aCols)][_nPosMotivo])=="8"
			_cAssunto	:= "[WFPROTHEUS] - Orçamento: "+ZZY->ZZY_NUM+" alterado para data de retorno: "+DTOC(ZZY->ZZY_RETORN)
			_cOrc:=ZZY->ZZY_NUM
			If getmv("ST_AGZZI",,.T.)
				cMsg	:= 	STASSUNT(_cOrc)
			EndIf

			DbSelectArea("SUA")
			SUA->(DbSetOrder(1))
			SUA->(DbGoTop())
			If SUA->(DbSeek(xFilial("SUA")+_cOrc))

				DbSelectArea('SA3')
				SA3->(DbSetOrder(1))
				If SA3->(dbSeek(xFilial('SA3')+SUA->UA_VEND))
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

		DbSelectArea("SUA")
		SUA->(DbSetOrder(1))
		SUA->(DbGoTop())
		If SUA->(DbSeek(xFilial("SUA")+aVetor[oLbx:nAt,3]))
			SUA->(RecLock("SUA",.F.))
			SUA->UA_XBLOQ	:= "3"
			_cMsgCan 		:=	"Solicitante: " + cUserName+CRLF+;
			"Solicitação em " + DtoC(dDatabase) + " às " + Time() + CRLF +;
			"Motivo do Cancelamento: "+ Upper(PADL(Alltrim(oGetDados2:aCols[Len(oGetDados2:aCols)][_nPosMotivo]),6,"0"))+CRLF+;
			"Descrição da Solicitação: " + CRLF + Upper(Alltrim(oGetDados2:aCols[Len(oGetDados2:aCols)][_nPosObs]))
			SUA->UA_XCODMCA := PADL(Alltrim(oGetDados2:aCols[Len(oGetDados2:aCols)][_nPosMotivo]),6,"0")
			SUA->(MsUnLock())
			SUA->(RecLock("SUA",.F.))
			MSMM(SUA->UA_XCODCAN,,,_cMsgCan,1,,,"SUA", "UA_XCODCAN",,.T.)
			SUA->(MsUnLock())


			DbSelectArea('ZZI')
			ZZI->(DbGoTop())
			ZZI->(DbSetOrder(3))
			If ZZI->(DbSeek(xFilial("ZZI")+SUA->UA_NUM))
				If ZZI->ZZI_BLQ = '2'
					ZZI->(RecLock('ZZI',.F.))
					ZZI->(DbDelete())
					ZZI->(MsUnlock())
					ZZI->( DbCommit() )
				Endif
			Endif


		EndIf

		//Chamado 003486
		_cAssunto	:= "[WFPROTHEUS] - Orçamento: "+SUA->UA_NUM+" baixado, motivo: "+AllTrim(Posicione("PA3",1,xFilial("PA3")+Upper(PADL(Alltrim(oGetDados2:aCols[Len(oGetDados2:aCols)][_nPosMotivo]),6,"0")),"PA3_DESCRI"))+" "+Upper(Alltrim(oGetDados2:aCols[Len(oGetDados2:aCols)][_nPosObs]))
		_cOrc:=SUA->UA_VEND
		If getmv("ST_AGZZI",,.T.)
			cMsg	:= 	STASSUNT(SUA->UA_NUM)
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

	If _cUltFil=="C"
		Processa( {|| ST_aVetor(,,,MV_PAR01)},"Explorando Orçamentos", "")
	ElseIf _cUltFil=="D"
		Processa( {|| ST_aVetor(MV_PAR01,MV_PAR02,.T.)},"Explorando Orçamentos", "")
	Else
		Processa( {|| ST_aVetor()},"Explorando Orçamentos", "")
	EndIf

	oGetDados1:Refresh()
	oGetDados2:Refresh()
	oLbx:Refresh()
	oDlg:Refresh()

Return()

Static Function STRETLEG(_cFilial,_cNum)

	Local _cQuery		:= ""
	Local _cAlias		:= "QRYTEMP"

	_cQuery  := " SELECT * "
	_cQuery  += " FROM "+RetSqlName("ZZY")+" ZY "
	_cQuery  += " WHERE ZY.D_E_L_E_T_=' ' AND ZZY_FILIAL='"+_cFilial+"' AND ZZY_NUM='"+_cNum+"' AND ZZY_RETORN<>' ' "
	_cQuery  += " ORDER BY ZZY_RETORN DESC "

	If !Empty(Select(_cAlias))
		DbSelectArea(_cAlias)
		(_cAlias)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.T.,.T.)

	dbSelectArea(_cAlias)
	(_cAlias)->(dbGoTop())

	If (_cAlias)->(!Eof())
		Do case
			Case STOD((_cAlias)->ZZY_RETORN)<Date()
			Return(oVermelho)
			Case STOD((_cAlias)->ZZY_RETORN)>Date()
			Return(oAzul)
			Case STOD((_cAlias)->ZZY_RETORN)=Date()
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
	Local _aDelPeds		:= {}

	AADD(_aParamBox,{1,"Cotação" ,Space(6),"","EXISTCPO('SUA')","SUA","",50,.F.})

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

	_cUltFil := "C"

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

	If __cuserid = '000000'
		_cAssunto:=_cAssunto+ " TESTE DE ENVIO DE EMAIL FAVOR DESCONSIDERAR"
	EndIf

	DbSelectArea("SUA")
	SUA->(DbSetOrder(1))
	SUA->(DbGoTop())
	If SUA->(DbSeek(xFilial("SUA")+_cOrc))

		Aadd( _aMsg , { "Posicionado: "     , cusername } )
		Aadd( _aMsg , { "Cliente: "    		, SUA->UA_XNOME } )
		Aadd( _aMsg , { "Vendedor1: "    		, SUA->UA_VEND+' - '+ Alltrim(Posicione("SA3",1,xFilial("SA3")+SUA->UA_VEND,"A3_NOME")) } )
		Aadd( _aMsg , { "Vendedor2: "    		, SUA->UA_VEND2+' - '+ Alltrim(Posicione("SA3",1,xFilial("SA3")+SUA->UA_VEND2,"A3_NOME")) } )
		Aadd( _aMsg , { "Valor: "    		,TRANSFORM(SUA->UA_ZVALLIQ ,"@E 99,999,999,999.99")	  } )
		Aadd( _aMsg , { "Emissão: "    		,	dtoc(SUA->UA_EMISSAO)  } )
		DbSelectArea("ZZY")
		ZZY->(DbSetOrder(1))
		ZZY->(DbGoTop())
		If ZZY->(DbSeek(cFilAnt+_cOrc))
			While !(ZZY->(Eof())) .And. ZZY->ZZY_NUM = _cOrc
				_cMtzzy:= ' '
				If ZZY->ZZY_MOTIVO ='1'
					_cMtzzy:= 'SOMENTE CUSTO'
				ElseIf ZZY->ZZY_MOTIVO ='2'
					_cMtzzy:= 'OUTRO COMPROU'
				ElseIf ZZY->ZZY_MOTIVO ='3'
					_cMtzzy:= 'ITENS INCL. PEDIDO'
				ElseIf ZZY->ZZY_MOTIVO ='4'
					_cMtzzy:= 'COMPROU NO DISTRIBUIDOR'
				ElseIf ZZY->ZZY_MOTIVO ='5'
					_cMtzzy:= 'PERDEU CONCORRENTE'
				ElseIf ZZY->ZZY_MOTIVO ='6'
					_cMtzzy:= 'PERDEU COTAÇÃO'
				ElseIf ZZY->ZZY_MOTIVO ='7'
					_cMtzzy:= 'CANC MASSA'
				ElseIf ZZY->ZZY_MOTIVO ='8'
					_cMtzzy:= 'COBRAR NOVAMENTE'
				EndIf

				Aadd( _aMsg , { "Nº Alteração: " +ZZY->ZZY_ITEM   		, 	_cMtzzy } )

				ZZY->(dbSkip())
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
		cMsg += '</body>'
		cMsg += '</html>'


	EndIf
	RestArea(aArea)



Return(cMsg)


/*/{Protheus.doc} VldCDZZY
description
Verifica se existe o registro na tabela
@type function
@version 
@author Valdemir Jose
@since 03/11/2020
@param pCodigo, param_type, param_description
@return return_type, return_description
/*/
User Function VldCDZZY(pCodigo)
	Local aArea := GetArea()
	Local lRET  := .T.

	dbSelectArea("ZA1")
	dbSetOrder(1)
	lRET := dbSeek(xFilial('ZA1')+pCodigo)

	if !lRET 
	   FWMsgRun({|| sleep(4000)},"Informação","Concorrente não encontrado na tabela: ZA1")
	Endif 

	RestArea( aArea )

Return lRET	
