#INCLUDE "RWMAKE.CH"
#Include "Colors.ch"
#Include "TOPCONN.CH"
#include 'Protheus.ch'

/*====================================================================================\
|Programa  | STCONSPROD       | Autor | GIOVANI.ZAGO             | Data | 06/06/2014  |
|=====================================================================================|
|Descrição | STCONSPROD                                                               |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STCONSPROD                                                               |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function STCONSPROD()
	*-----------------------------*
	Local aArea 		:= GetArea()
	Local aTitles	  	:= {}
	Local _cUseCust     := GetMv("ST_CUSUSER",,"000000")
	Local _cGrpExt      := GetMv("ST_GRPEXT",,"000000")
	Local cUsrMemCal := GetMV("ST_MEMCAL",,"000019;001616")

	Private aAcresM := {}
	
	Private cAliasLif   := ' '
	Private _lFull  	:= .T.
	Private	oDlg,;
	oGetProd ,;
	oGetEst,oGetPre,;
	oGetEst1,oGetPre1,;
	oGetEst2,oGetPre2,;
	oGetEst3,oGetPre3,;
	oGetEst4,oGetEst5,oGetPre4 ,oGetPre5 ,oGetPre6,oGetPre7,oGetPre8,oGetPre9,oGetPre10,oGetPre11,odUlt,oGetPre12,oGetPre13,oGetPre14
	Private bOk 		:= {||(	oDlg:End()) }
	Private bCancel 	:= {||( oDlg:End()) }
	Private aButtons	:= {}
	Private _cProd    	:= space(15)
	Private _nEst := _nEst1  := _nEst2 := _nEst3 := _nEst4 := _nEst5 := 	_nPre5 := _nPre6 := _nPre7 := _nPre8 := _nPre9 := _nPre10 := _nPre11 := _nLin	:= 0
	Private _cPre := _cPre1  := _cPre2 := _cPre3 := _cPre4 := _cPre5 := _cPre6 := _cPre7 := ' '
	Private _dUlt := cTod('  /  /    ')
	_cPre := space(06)
	_cPre1  :=space(2)
	_cPre2 := space(20)
	_cPre3 := space(3)
	_cPre5 := Space(TamSx3("ZM_REF")[1])

	PswOrder(1)
	If PswSeek(__cUserId,.T.)
		_aGrupos	:= PswRet()
	EndIf

	//Nome dos Folders
	aAdd(aTitles,'Estoque')

	If !_aGrupos[1][10][1] $ _cGrpExt //Chamado 000846
		aAdd(aTitles,'Valores')
	Else
		aAdd(aTitles,'Valores')
	EndIF

	aAdd(aTitles,'Similaridade Streka')

	DEFINE MSDIALOG oDlg TITLE OemToAnsi('Consulta de Produto') FROM 09,00 TO 38,80
	oFolder := TFolder():New(050,001,aTitles,{"HEADER"},oDlg,,,, .T., .F.,315,140)
	_nLin	:= 0
	@ 35,005 SAY 'Produto:' 	SIZE 40,10 PIXEL OF oDlg
	@ 35,035 MSGet oGetProd Var _cProd  F3 'SB1' Picture '@!'  VALID (EXISTCPO("SB1",_cProd),STCARPROD()) SIZE 50,10  PIXEL OF oDlg When .T.
	@ 35,105  SAY SUBSTR(Alltrim(Posicione("SB1",1,xFilial("SB1")+_cProd,"B1_DESC")),1,40)		SIZE 150,10 PIXEL OF  oDlg
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Folder 1                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//coluna 01
	If !_aGrupos[1][10][1] $ _cGrpExt //Chamado 000846
		@ 005+_nLin,005  SAY 'Estoque'		SIZE 40,10 PIXEL OF oFolder:aDialogs[1]
		@ 005+_nLin,045  MSGet oGetEst Var _nEst  Picture '@E 999,999,999' SIZE 50,10  PIXEL OF oFolder:aDialogs[1] When .F.
	EndIf
	_nLin+=10
	@ 005+_nLin,005  SAY 'Disponível'		SIZE 40,10 PIXEL OF oFolder:aDialogs[1]
	@ 005+_nLin,045  MSGet oGetEst1 Var _nEst1  Picture '@E 999,999,999' SIZE 50,10  PIXEL OF oFolder:aDialogs[1] When .F.
	_nLin+=10
	If !_aGrupos[1][10][1] $ _cGrpExt //Chamado 000846
		@ 005+_nLin,005  SAY 'Falta'		SIZE 40,10 PIXEL OF oFolder:aDialogs[1]
		@ 005+_nLin,045  MSGet oGetEst2 Var _nEst2  Picture '@E 999,999,999' SIZE 50,10  PIXEL OF oFolder:aDialogs[1] When .F.
		/*   DESABILITADO TEMPORARIAMENTE
		_nLin+=10
		@ 005+_nLin,005  SAY 'Transito'		SIZE 40,10 PIXEL OF oFolder:aDialogs[1]
		@ 005+_nLin,045  MSGet oGetEst3 Var _nEst3  Picture '@E 999,999,999' SIZE 50,10  PIXEL OF oFolder:aDialogs[1] When .F.
		*/
		_nLin+=10
		@ 005+_nLin,005  SAY 'Qtd. P.V.'		SIZE 40,10 PIXEL OF oFolder:aDialogs[1]
		@ 005+_nLin,045  MSGet oGetEst4 Var _nEst4  Picture '@E 999,999,999' SIZE 50,10  PIXEL OF oFolder:aDialogs[1] When .F.
		_nLin+=10
		@ 005+_nLin,005  SAY 'À Classificar'		SIZE 40,10 PIXEL OF oFolder:aDialogs[1]
		@ 005+_nLin,045  MSGet oGetEst5 Var _nEst5  Picture '@E 999,999,999' SIZE 50,10  PIXEL OF oFolder:aDialogs[1] When .F.
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Folder 2                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !_aGrupos[1][10][1] $ _cGrpExt //Chamado 000846
		_nLin	:= 0
		@ 005+_nLin,005  SAY 'Cliente'		SIZE 40,10 PIXEL OF oFolder:aDialogs[2]
		@ 005+_nLin,045  MSGet oGetPre Var _cPre F3 'SA1' Picture '@!' SIZE 60,10  PIXEL OF oFolder:aDialogs[2]  Valid (EXISTCPO("SA1",_cPre),STCLI('1'))  When Empty(Alltrim(_cPre2))
		@ 005+_nLin,105  SAY SUBSTR(Alltrim(Posicione("SA1",1,xFilial("SA1")+_cPre+_cPre1,"A1_NOME")),1,40)		SIZE 150,10 PIXEL OF oFolder:aDialogs[2]
		_nLin+=10
		@ 005+_nLin,005  SAY 'Loja'		SIZE 40,10 PIXEL OF oFolder:aDialogs[2]
		@ 005+_nLin,045  MSGet oGetPre1 Var _cPre1  Picture '@!' SIZE 60,10  PIXEL OF oFolder:aDialogs[2] When .F.
		_nLin+=10
		@ 005+_nLin,005  SAY 'CNPJ/CPF'		SIZE 40,10 PIXEL OF oFolder:aDialogs[2]
		@ 005+_nLin,045  MSGet oGetPre2  Var _cPre2  Picture '@R 99.999.999/9999-99' SIZE 60,10  PIXEL OF oFolder:aDialogs[2] Valid (EXISTCPO("SA1",_cPre2),STCLI('2')) When Empty(Alltrim(_cPre))
		_nLin+=10
		@ 005+_nLin,005  SAY 'Cond.Pag.'		SIZE 40,10 PIXEL OF oFolder:aDialogs[2]
		@ 005+_nLin,045  MSGet oGetPre3 Var _cPre3 F3 'SE4_01' Picture '@!' SIZE 60,10  PIXEL OF oFolder:aDialogs[2] When Empty(Alltrim(_cPre3)) VALID EXISTCPO("SE4",_cPre3)
		@ 005+_nLin,110  SAY SUBSTR(Alltrim(Posicione("SE4",1,xFilial("SE4")+_cPre3,"E4_DESCRI")),1,40)		SIZE 150,10 PIXEL OF oFolder:aDialogs[2]
		_nLin+=10
		@ 005+_nLin,005  SAY 'Prc.Venda'		SIZE 40,10 PIXEL OF oFolder:aDialogs[2]
		@ 005+_nLin,045  MSGet oGetPre5 Var _nPre5  Picture '@E 999,999,999.99' SIZE 60,10  PIXEL OF oFolder:aDialogs[2] When .F.

		If __cUserId $ GetMv("ST_PRCBAS")
			@ 005+_nLin,150  SAY 'Prc.Base'		SIZE 40,10 PIXEL OF oFolder:aDialogs[2]
			@ 005+_nLin,195  MSGet oGetPre11 Var _nPre11  Picture '@E 999,999,999.99' SIZE 60,10  PIXEL OF oFolder:aDialogs[2] When .F.
		EndIf

		_nLin+=10
		@ 005+_nLin,005  SAY 'IPI'		SIZE 40,10 PIXEL OF oFolder:aDialogs[2]
		@ 005+_nLin,045  MSGet oGetPre7 Var _nPre7  Picture '@E 999,999,999.99' SIZE 60,10  PIXEL OF oFolder:aDialogs[2] When .F.

		_nLin+=10
		@ 005+_nLin,005  SAY 'ICMS/ST'		SIZE 40,10 PIXEL OF oFolder:aDialogs[2]
		@ 005+_nLin,045  MSGet oGetPre8 Var _nPre8  Picture '@E 999,999,999.99' SIZE 60,10  PIXEL OF oFolder:aDialogs[2] When .F.

		_nLin+=10
		@ 005+_nLin,005  SAY 'Preço NF'		 SIZE 40,10 PIXEL OF oFolder:aDialogs[2]
		@ 005+_nLin,045  MSGet oGetPre9 Var _nPre9  Picture '@E 999,999,999.99' SIZE 60,10  PIXEL OF oFolder:aDialogs[2] When .F.

		If __cUserId $ _cUseCust
			_nLin+=10
			@ 005+_nLin,005  SAY 'Custo'		SIZE 40,10 PIXEL OF oFolder:aDialogs[2]
			@ 005+_nLin,045  MSGet oGetPre6 Var _nPre6  Picture '@E 999,999,999.99' SIZE 60,10  PIXEL OF oFolder:aDialogs[2] When .F.
		EndIf

		_nLin+=10
		@ 005+_nLin,005  SAY 'Último preço' SIZE 40,10 PIXEL OF oFolder:aDialogs[2]
		@ 005+_nLin,045  MSGet oGetPre10 Var _nPre10  Picture '@E 999,999,999.99' SIZE 60,10  PIXEL OF oFolder:aDialogs[2] When .F.

		If __cUserId $ _cUseCust
			@ 005+_nLin,150  SAY 'Data Últ.Preço' SIZE 40,10 PIXEL OF oFolder:aDialogs[2]
			@ 005+_nLin,195  MSGet odUlt Var _dUlt  Picture '@!' SIZE 60,10  PIXEL OF oFolder:aDialogs[2] When .F.
		EndIf


		_nLin+=15

		If __cUserId $ cUsrMemCal
			@ 005+_nLin,085 Button "&Mem.Calculo"   size 40,10  action STMEMCALC()  Pixel of oFolder:aDialogs[2]
		EndIf

		@ 005+_nLin,045 Button "&Calcular"   size 40,10  action STCALC()  Pixel of oFolder:aDialogs[2]
		//_nLin+=15
		@ 005+_nLin,005 Button "&Limpar"   size 40,10  action STLIMP()  Pixel of oFolder:aDialogs[2]
	EndIf

	//Aba similaridade
	_nLin := 0
	@ 005+_nLin,005 Button "&Consultar" size 40,10  action STSTREKA()  Pixel of oFolder:aDialogs[3]

	ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,bOk,bCancel,,aButtons)

	Return ()

	/*====================================================================================\
	|Programa  | STCARPROD        | Autor | GIOVANI.ZAGO             | Data | 06/06/2014  |
	|=====================================================================================|
	|Descrição | STCARPROD                                                                |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | STCARPROD                                                                |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/
	*-----------------------------*
Static Function STCARPROD ()
	*-----------------------------*
	Dbselectarea('SB1')
	SB1->(dbsetorder(1))
	If 	SB1->(Dbseek(xfilial("SB1") + _cProd ))
		Dbselectarea('SB2')
		SB2->(DbSetOrder(1))
		If	SB2->(DbSeek(xfilial("SB2") + SB1->B1_COD +'03'))
			_nEst:= SB2->B2_QATU
			_nEst2:= VALESTO()
			_nEst1:= _nEst - (U_STResSDC(SB2->B2_COD) + u_STSldPV(SB2->B2_COD,cFilAnt))-SB2->B2_QACLASS  //If(_nEst-_nEst2 >0 ,_nEst-_nEst2,0)
			_nEst3:= 0
			_nEst4:= VALESTO1()
			_nEst5:= SB2->B2_QACLASS
		EndIf
		If	SB2->(DbSeek(xfilial("SB2") + SB1->B1_COD +'01'))
			If SB2->B2_QATU>0
				_nEst+= SB2->B2_QATU
				//_nEst2+= VALESTO()
				_nEst1+= _nEst - (U_STResSDC(SB2->B2_COD))-SB2->B2_QACLASS  //If(_nEst-_nEst2 >0 ,_nEst-_nEst2,0)
				//_nEst3+= 0
				//_nEst4+= VALESTO1()
				_nEst5+= SB2->B2_QACLASS
			EndIf
		EndIf
		SB2->(DbSeek(xfilial("SB2") + SB1->B1_COD +'03'))

	EndIf
	_nPre5:= 0
	_nPre6:= u_STCUSTO(_cProd)
	_nPre7:= 0
	_nPre8:= 0
	_nPre9:= 0
	_nPre10:= 0
	_nPre11:= 0

	Return (.T.)

	/*====================================================================================\
	|Programa  | VALESTO          | Autor | GIOVANI.ZAGO             | Data | 06/06/2014  |
	|=====================================================================================|
	|Descrição | VALESTO                                                                  |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | VALESTO                                                                  |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/
	*-----------------------------*
Static Function VALESTO ()
	*-----------------------------*
	Local _nRet 	 := 0
	Local cQuery     := ' '
	cAliasLif   	 := 'VALESTO'

	cQuery += " SELECT SUM(PA1.PA1_QUANT)
	cQuery += ' "QUANT"
	cQuery += "  FROM "+RetSqlName("PA1")+"  PA1 "
	cQuery += " WHERE PA1.D_E_L_E_T_ = ' '
	cQuery += " AND PA1.PA1_FILIAL =  '"+xFilial("PA1")+"'
	cQuery += " AND PA1.PA1_CODPRO  = '"+_cProd+"'
	cQuery += " AND PA1.PA1_TIPO = '1'

	cQuery := ChangeQuery(cQuery)

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
	dbSelectArea(cAliasLif)
	If  Select(cAliasLif) > 0
		(cAliasLif)->(dbgotop())

		_nRet 	 := 	(cAliasLif)->QUANT
	EndIf

	Return(_nRet)

	/*====================================================================================\
	|Programa  | VALESTO1         | Autor | GIOVANI.ZAGO             | Data | 06/06/2014  |
	|=====================================================================================|
	|Descrição | VALESTO1                                                                 |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | VALESTO1                                                                 |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/
	*-----------------------------*
Static Function VALESTO1 ()
	*-----------------------------*
	Local _nRet 	 := 0
	Local cQuery     := ' '
	cAliasLif   	 := 'VALESTO1'

	cQuery += " SELECT SUM(SC6.C6_QTDVEN-SC6.C6_QTDENT)
	cQuery += ' "QUANT"
	cQuery += "  FROM "+RetSqlName("SC6")+"  SC6 "
	cQuery += " WHERE SC6.D_E_L_E_T_ = ' '
	cQuery += " AND SC6.C6_FILIAL =  '"+xFilial("SC6")+"'
	cQuery += " AND SC6.C6_PRODUTO  = '"+_cProd+"'
	cQuery += " AND SC6.C6_BLQ <> 'R'
	cQuery += " AND SC6.C6_QTDVEN - SC6.C6_QTDENT > 0

	cQuery := ChangeQuery(cQuery)

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
	dbSelectArea(cAliasLif)
	If  Select(cAliasLif) > 0
		(cAliasLif)->(dbgotop())
		_nRet 	 := 	(cAliasLif)->QUANT
	EndIf
	(cAliasLif)->(dbCloseArea())
	Return(_nRet)
	/*====================================================================================\
	|Programa  | STLIMP           | Autor | GIOVANI.ZAGO             | Data | 06/06/2014  |
	|=====================================================================================|
	|Descrição | STLIMP                                                                   |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | STLIMP                                                                   |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/
	*-----------------------------*
Static Function STLIMP()
	*-----------------------------*

	_cPre  := space(06)
	_cPre1 := space(2)
	_cPre2 := space(20)
	_cPre3 := space(3)
	_nPre5 := 0
	_nPre11 := 0
	_dUlt := cTod('  /  /    ')

	Return()
	/*====================================================================================\
	|Programa  | STCALC           | Autor | GIOVANI.ZAGO             | Data | 06/06/2014  |
	|=====================================================================================|
	|Descrição | STCALC                                                                   |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | STCALC                                                                   |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/
	*-----------------------------*
Static Function STCALC()
	*-----------------------------*
	Local _cTabela:= U_STXZ2B(_cPre,_cPre1)

	If !Empty(Alltrim(_cPre)) .And. !Empty(Alltrim(_cPre1)) .And. !Empty(Alltrim(_cPre3)) .And. !Empty(Alltrim(_cProd))

/*
		_nPre5	:= U_STRETSST('01',_cPre , _cPre1,_cProd,_cPre3,'PRECO',.F.,,,_cTabela)
		_nPre5	:= Iif(valtype(_nPre5)<> 'N', 0 ,_nPre5 )
		_nPre6	:= u_STCUSTO(_cProd)
		_nPre6	:= Iif(valtype(_nPre6)<> 'N', 0 ,_nPre6 )
		_nPre7	:= U_STRETSST('01',_cPre , _cPre1,_cProd,_cPre3,'IPI')
		_nPre7	:= Iif(valtype(_nPre7)<> 'N', 0 ,_nPre7 )
		_nPre8	:= U_STRETSST('01',_cPre , _cPre1,_cProd,_cPre3,'ST')
		_nPre8	:= Iif(valtype(_nPre8)<> 'N', 0 ,_nPre8 )
		_nPre9	:= _nPre5+_nPre8+_nPre7
		_nPre10	:= U_STGETUPR(_cPre,_cPre1,_cProd,'1')
		_dUlt	:= U_STGETUPR(_cPre,_cPre1,_cProd,'2')
		_nPre11	:= Posicione("DA1",1,xFilial("DA1")+_cTabela+_cProd,"DA1_PRCVEN")
*/

//		STCalcPrc({SA1->(Recno()),SB1->(Recno())},nPrecoX,cTabelaX,nPrcCamX,cOperX,cTESX,lPrcCond)
/*
		_cPre  //cliente
		_cPre1 //loja
		_cPre2 //cgc
		_cPre3 //condpag
		_cPre5 //praço
		_cPre11 //preço base st_prcbas
		_cPre7 //ipi
		_cPre8 //icms-st
		_cPre9 //preço nf
		_cPre6 //custo
		_cPre10 //últ preço
		_dUlt //dt últ preço
*/
/*
	aAdd(aAcresM, {"PRODUTO", nX1})
	aAdd(aAcresM, {"PREÇO TABELA", nX2})
	aAdd(aAcresM, {"% IPI", nIPIX})
	aAdd(aAcresM, {"VL IPI", nVLIPIX})
	aAdd(aAcresM, {"VL ICMS-ST", nICMSSTX})
	aAdd(aAcresM, {"% MARGEM (Inflação)", nFatMarX})
	aAdd(aAcresM, {"% INFLAÇÃO", nFatInflX})
	aAdd(aAcresM, {"% DESCONTO", nDescX})
	aAdd(aAcresM, {"VL PREÇO FINAL", nPrecoX})
*/
		DbSelectArea("SA1")
		SA1->(DbSetOrder(1))
		SA1->(DbSeek(FWxFilial("SA1") + _cPre + _cPre1))
		DbSelectArea("SB1")
		SB1->(DbSetOrder(1))
		SB1->(DbSeek(FWxFilial("SB1") + _cProd))
		
		_nPre5 := U_STRETSST("01",SA1->A1_COD,SA1->A1_LOJA,SB1->B1_COD,_cPre3,'PRECO',.F.,SA1->A1_TIPO,         ,"001",)
		_nPre5	:= Iif(valtype(_nPre5)<> 'N', 0 ,_nPre5 )
		_nPre6	:= u_STCUSTO(_cProd)
		_nPre6	:= Iif(valtype(_nPre6)<> 'N', 0 ,_nPre6 )
		_nPre7	:= U_STRETSST("01",SA1->A1_COD,SA1->A1_LOJA,SB1->B1_COD,_cPre3,'IPI',.F.,SA1->A1_TIPO,         ,"001",)
		_nPre7	:= Iif(valtype(_nPre7)<> 'N', 0 ,_nPre7 )
		_nPre8	:= U_STRETSST("01",SA1->A1_COD,SA1->A1_LOJA,SB1->B1_COD,_cPre3,'ST',.F.,SA1->A1_TIPO,         ,"001",)
		_nPre8	:= Iif(valtype(_nPre8)<> 'N', 0 ,_nPre8 )
		_nPre9	:= _nPre5+_nPre8+_nPre7
		_nPre10	:= U_STGETUPR(_cPre,_cPre1,_cProd,'1')
		_dUlt	:= U_STGETUPR(_cPre,_cPre1,_cProd,'2')
		_nPre11	:= Posicione("DA1",1,xFilial("DA1")+_cTabela+_cProd,"DA1_PRCVEN")
		
	Else
		msgInfo("Preencha os Campos Cliente,Cnpj,Cond.Pag. !!!!!!!")
	EndIf

	Return()
//	aAcresM := aClone(aDadosM) //para poder trabalhar no STCONSPROD
//	aAdd(aAcresM, {"PREÇO", nPrecoM})
//	aAdd(aAcresM, {"% PIS", nPISX})
//	aAdd(aAcresM, {"% COFINS", nCOFX})
//	aAdd(aAcresM, {"% ICM", nICMX})
/*
	aAdd(aAcresM, {"% IPI", nIPIX})
	aAdd(aAcresM, {"ICMS-ST", nICMSSTX})
	aAdd(aAcresM, {"% MARGEM (Inflação)", nFatMarX})
	aAdd(aAcresM, {"% INFLAÇÃO", nFatInflX})
	aAdd(aAcresM, {"% DESCONTO", nDescX})
	aAdd(aAcresM, {"PREÇO FINAL", nPrecoX})
*/

	/*====================================================================================\
	|Programa  | STCLI            | Autor | GIOVANI.ZAGO             | Data | 06/06/2014  |
	|=====================================================================================|
	|Descrição | STCLI                                                                    |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | STCLI                                                                    |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/
	*-----------------------------*
Static Function STCLI(_cCli)
	*-----------------------------*
	Local _lCliRet:= .T.
	If _cCli = '1'
		dbSelectArea("SA1")
		SA1->(dbSetOrder(1))
		If SA1->(DbSeek(xFilial("SA1")+_cPre+_cPre1))
			_cPre2:= SA1->A1_CGC

			If !(__cUserId $ GetMv("ST_SUPCORV",,"000380#000088#000391#000366#000378#000641"))
				DbSelectArea('SA3')
				SA3->(DbSetOrder(7))
				If SA3->(dbSeek(xFilial('SA3')+__cUserId))
					If SA1->A1_XMATRIZ <> ' ' .And. SA3->A3_COD <> SA1->A1_XMATRIZ .And. SA3->A3_COD <> SA1->A1_VEND
						MsgInfo("Cliente Bloqueado...Procure um Supervisor de Vendas.....!!!!!")
						_lCliRet:= .F.
					EndIf
				EndIf
			EndIf
		EndIf
	ElseIf _cCli ='2'
		dbSelectArea("SA1")
		SA1->(dbSetOrder(3))
		If SA1->(DbSeek(xFilial("SA1")+_cPre2))
			_cPre := SA1->A1_COD
			_cPre1:=SA1->A1_LOJA
		EndIf
	EndIf
	Return(_lCliRet)

	/*====================================================================================\
	|Programa  | GETULTPR            | Autor | GIOVANI.ZAGO          | Data | 06/06/2014  |
	|=====================================================================================|
	|Descrição | GETULTPR                                                                 |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | GETULTPR                                                                 |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/

	*-----------------------------*
User Function STGETUPR(_cCli,_cLoja,_cProduto,_cTP)
	*-----------------------------*

	Local _nPreco
	Local cPerg 		:= "STGETUPR"
	Local cTime         := Time()
	Local cHora         := SUBSTR(cTime, 1, 2)
	Local cMinutos    	:= SUBSTR(cTime, 4, 2)
	Local cSegundos   	:= SUBSTR(cTime, 7, 2)
	Local cXAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Default _cTP:= '1'

	cQuery := " SELECT C6_PRCVEN, C5_EMISSAO FROM "+RetSqlName("SC6")+" SC6
	cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SC5")+") SC5
	cQuery += " ON SC5.D_E_L_E_T_ = ' '
	cQuery += " AND C5_NUM = C6_NUM
	cQuery += " AND C5_FILIAL = C6_FILIAL
	cQuery += " WHERE SC6.D_E_L_E_T_ = ' '
	cQuery += " AND C6_PRODUTO = '"+_cProduto+"'"
	cQuery += " AND C6_CLI = '"+_cCli+"'"
	cQuery += " AND C6_LOJA = '"+_cLoja+"'"
	cQuery += " AND C6_FILIAL  = '"+xFilial("SC6")+"'
	cQuery += " ORDER BY SC6.R_E_C_N_O_ DESC

	If Select(cXAliasLif) > 0
		(cXAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cXAliasLif)
	dbSelectArea(cXAliasLif)
	If  Select(cXAliasLif) > 0
		(cXAliasLif)->(dbgotop())

		If _cTP = '1'
			_nPreco  := (cXAliasLif)->C6_PRCVEN
		Else
			_nPreco  := sTod((cXAliasLif)->C5_EMISSAO)
		EndIf

	EndIf
	(cXAliasLif)->(dbCloseArea())

	Return(_nPreco)

	/*====================================================================================\
	|Programa  | GETULTPR            | Autor | GIOVANI.ZAGO          | Data | 06/06/2014  |
	|=====================================================================================|
	|Descrição | GETULTPR                                                                 |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | GETULTPR                                                                 |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/

	*-----------------------------*
User Function STGETUDT(_cCli,_cLoja,_cProduto)
	*-----------------------------*

	Local _cData
	Local _aAreaSC6	:= SC6->(GetArea())

	DbSelectArea("SC6")
	SC6->(DbSetOrder(5))
	If SC6->(DbSeek(xFilial("SC6")+_cCli+_cLoja+_cProduto))
		While SC6->(!Eof()) .and.  _cCli = SC6->C6_CLI .And. _cLoja = SC6->C6_LOJA  .And. _cProduto = SC6->C6_PRODUTO
			DbSelectArea("SC5")
			SC5->(DbSetOrder(1))
			SC5->(DbGoTop())
			If SC5->(DbSeek(xFilial("SC5")+SC6->C6_NUM))
				_cData 	:= SC5->C5_EMISSAO
			EndIf
			SC6->(DbSkip())
		End
	EndIf

	If Empty(_cData)
		_cData	:= CTOD("01/01/1990")
	EndIf

	RestArea(_aAreaSC6)

Return(_cData)

/*/{Protheus.doc} STGETREF
@name STGETREF
@type Static Function
@desc carregar código baseado na referencia
@author Renato Nogueira
@since 17/05/2018
/*/

Static Function STGETREF()

	Local _cQuery1 := ""
	Local _cAlias1 := GetNextAlias()

	_cQuery1 += " SELECT ZM_REF,ZM_REFDESC
	_cQuery1 += " FROM "+RetSqlName("SZM")+" ZM
	_cQuery1 += " WHERE ZM.D_E_L_E_T_=' ' AND ZM_SETUP||ZM_GRUPO IN (
	_cQuery1 += " SELECT ZM_SETUP||ZM_GRUPO
	_cQuery1 += " FROM "+RetSqlName("SZM")+" ZM
	_cQuery1 += " WHERE ZM.D_E_L_E_T_=' ' AND ZM_REF='"+_cPre5+"'
	_cQuery1 += " )
	_cQuery1 += " AND ZM_EMPRESA='STECK'

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	If (_cAlias1)->(!Eof())
		_cPre6 := (_cAlias1)->ZM_REF
		_cPre7 := (_cAlias1)->ZM_REFDESC

		DbSelectArea("SB1")
		SB1->(DbSetOrder(1))
		SB1->(DbGoTop())
		If SB1->(DbSeek(xFilial("SB1")+_cPre6))
			_cProd := SB1->B1_COD
			STCARPROD()
		Else
			MsgAlert("Código "+Alltrim(_cPre6)+" não encontrado na tabela de produtos.")
		EndIf

	Else
		MsgAlert("Atenção, referência não encontrada, verifique!")
	EndIf

Return()

/*====================================================================================\
|Programa  | STSTREKA         | Autor | Renato Nogueira            | Data | 15/07/2019|
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 			                                                              |
|=====================================================================================|
|Uso       | Especifico Steck                                                     	  |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

Static Function STSTREKA()

	Private cCadastro := "Tabela de similaridade Streka"

	U_STFAT160()

Return()


/*/{Protheus.doc} GeraMemoX
Gera informações - calculo do Preço
@type function
@version  12.1.33
@author Ricardo Munhoz
@since 23/02/2023
@param aProdX, numeric, Produto
/*/
Static Function STMEMCALC
Local aArea := GetArea()
Local cMensagem := ""
Local nX := 0

If !Empty(aAcresM)
	cMensagem := "Memória de calculo para o Produto: " + aAcresM[1][2] + CRLF + CRLF
	For nX := 2 To Len(aAcresM)
		cMensagem += aAcresM[nX][1] + " = " + cValToChar(aAcresM[nX][2]) + CRLF
//		If nX == Len(aAcresM)
//			cMensagem += CRLF + aAcresM[nX][1] + " = " + cValToChar(aAcresM[nX][2]) + CRLF
//		End If
	Next nX
	FWAlertInfo(cMensagem)
Else
	FWAlertInfo("Favor efetuar o calculo (botão calcular)")
End If

RestArea(aArea)
Return
