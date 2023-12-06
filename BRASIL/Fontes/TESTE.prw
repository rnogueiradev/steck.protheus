#include 'Protheus.ch'
#include 'RwMake.ch'
#Define CR chr(13)+chr(10)
/*====================================================================================\
|Programa  | TESTE			  | Autor | GIOVANI.ZAGO             | Data | 18/03/2017  |
|=====================================================================================|
|Descrição |  TESTE	                                      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | TESTE		                                                              |
|=====================================================================================|
|Uso       | Especifico                                                          |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function STTESTEPJ()   //  u_STTESTEPJ()
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
	If !IsInCallSteck("U_STFTA001")
		aAdd(aButtons,{"PMSSETAUP"  	,{|| CarrEstru()}		,"Carrega Estrutura"		,"Carrega Estrutura"})
	EndIf
	Private cCadastro := "Pesquisa Estruturas"
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
	Private oOk	   		:= LoadBitmap( GetResources(), "LBOK" )
	Private oNo	   		:= LoadBitmap( GetResources(), "LBNO" )
	
	Private _cPesq	   		:= Space(15)
	Private _oPesq
	Private _cVetor	   		:= ''
	Define FONT oFontN  NAME "Arial"
	Define FONT oFontB  NAME "Arial" BOLD
	Private oFontN  	:= TFont():New("Arial",9,25,.T.,.T.,5,.T.,5,.T.,.F.)
	Private oFontB 	    := TFont():New("Arial",9,50,.T.,.T.,5,.T.,5,.T.,.F.)
	/*
	ST_a01Header()
	*/
	ST_a02Header()
	//ST_a03Header()
	
	aadd(aVetor,{.f.,' ',' ',' ',' ',' '})
	
	Define MSDialog oDlg Title cCadastro From aSize[7],000 To aSize[6],aSize[5] of GetWndDefault() Pixel
	
	@ aPosObj[1,3]/2-19,1 To aPosObj[1,3]/2-18,aPosObj[1,4]
	
	@ 1,1 To aPosObj[1,3]+2,aPosObj[1,4]+2
	@ 005,(aPosObj[1,4]/2)+20 Button "&Buscar Fornecedor"   size 50,15  action carrAcols02() Pixel of oDlg
	//@ 005,(aPosObj[1,4]/2)+75 Button "&Limpar"      size 50,15  action LimpSt() Pixel of oDlg
	
	//@ 005,005  SAY 'Componentes'	 PIXEL FONT oFontN OF  oDlg
	//oGetDados1 := MsNewGetDados():New(aPosObj[1,1]+15	,aPosObj[1,2]+5	,aPosObj[1,3]/2-25	,aPosObj[1,4]/2	,nStyle	,"AllWaysTrue","AllWaysTrue","+XX_ITEM",acpos,/*freeze*/,999,/*fieldok*/,/*superdel*/,/*delok*/,oDlg,_a01Header,_aCols01)
	
	@ aPosObj[1,3]/2-16,006  SAY 'Fornecedores'	PIXEL FONT oFontN OF  oDlg
	
	@ 005,006  SAY 'Codigo Produto'	PIXEL FONT oFontN OF  oDlg
	@ 005,80  MSGet _oPesq Var _cPesq  F3 'SB1' Picture '@!'  VALID ( !Empty( alltrim(_cPesq)) .Or. (EXISTCPO("SB1",_cPesq)) ) SIZE 50,10  PIXEL OF oDlg When .T.
	
	
	
	
	@ aPosObj[1,3]/2,aPosObj[1,2]+5 listbox oLbx fields header " ", 'Codigo',"Descrição",'Fornecedor'  size  aPosObj[1,4]/2 , aPosObj[1,3]/2  pixel of oDlg on dbLclick(edlista('1'))
	
	oLbx:SetArray( aVetor )
	
	oLbx:bLine := {|| {Iif(	aVetor[oLbx:nAt,1],oOk,oNo),;
		aVetor[oLbx:nAt,2],;//Codigo
	aVetor[oLbx:nAt,3],;//Descrição
	aVetor[oLbx:nAt,4],;//Fornecedor
	}}
	
	
	
	@ aPosObj[1,3]/2-16,(aPosObj[1,4]/2)+15  SAY 'Fornecedor x Produto'	PIXEL FONT oFontN OF  oDlg
	oGetDados3 := MsNewGetDados():New(aPosObj[1,3]/2,aPosObj[1,4]/2+15	,aPosObj[1,3]	,aPosObj[1,4]-5	,0		,"AllWaysTrue","AllWaysTrue","",,/*freeze*/,999,/*fieldok*/,/*superdel*/,/*delok*/,oDlg,_a03Header,_aCols03)
	
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| nOpca := 1,oDlg:End() },{||oDlg:End()},,aButtons)
	
	// se a opcao for encerrar executa a rotina.
	If nOpca == 1
		
	EndIf
	
Return



/*====================================================================================\
|Programa  | ST_a02Header     | Autor | GIOVANI.ZAGO             | Data | 10/07/2014  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | ST_a02Header                                                             |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
Static Function ST_a02Header()
	*-----------------------------*
	//aAdd(_a02Header,{"Item",			"XX_ITEM"	,"@!",TamSx3("D2_ITEMPV")[1],0,"","€€€€€€€€€€€€€€€","C","","","","",".T."})
	aAdd(_a02Header,{"Produto",			"XX_COD"	,"@!",TamSx3("D2_COD")[1]	,0,"","€€€€€€€€€€€€€€€","C","","","","",".T."})
	aAdd(_a02Header,{"Descricao",		"XX_DESC"	,"@!",TamSx3("B1_DESC")[1]	,0,"","€€€€€€€€€€€€€€€","C","","","","",".T."})
	aAdd(_a02Header,{"Qtd. Nota",		"XX_QTDD2"	,"@E 999,999.99",TamSx3("D2_QUANT")[1],TamSx3("D2_QUANT")[2],"","€€€€€€€€€€€€€€€","N","","","","",".T."})
	
Return()

/*====================================================================================\
|Programa  | ST_a03Header     | Autor | GIOVANI.ZAGO             | Data | 10/07/2014  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | ST_a03Header                                                             |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
Static Function ST_a03Header()
	*-----------------------------*
	aAdd(_a03Header,{"Item",			"XX_ITEM"	,"@!",TamSx3("D2_ITEMPV")[1],0,"","€€€€€€€€€€€€€€€","C","","","","",".T."})
	aAdd(_a03Header,{"Produto",			"XX_COD"	,"@!",TamSx3("D2_COD")[1]	,0,"","€€€€€€€€€€€€€€€","C","","","","",".T."})
	aAdd(_a03Header,{"Descricao",		"XX_DESC"	,"@!",TamSx3("B1_DESC")[1]	,0,"","€€€€€€€€€€€€€€€","C","","","","",".T."})
	aAdd(_a03Header,{"Qtd.    ",		"XX_QTDD2"	,"@E 999,999.99",TamSx3("D2_QUANT")[1],TamSx3("D2_QUANT")[2],"","€€€€€€€€€€€€€€€","N","","","","",".T."})
	
Return()



/*====================================================================================\
|Programa  | carrAcols02      | Autor | GIOVANI.ZAGO             | Data | 10/07/2014  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | carrAcols02                                                              |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
Static Function carrAcols02()
	*-----------------------------*
	Local _n02  	:= 0
	Local _cAdd 	:= ' '
	Local cAliasLif := 'TMPB2'
	Local cQuery    := ' '
	Local lMark    	:= .F.
	Local _cSoma  	:= '01'
	oGetDados3:acols:= {}
	aVetor     := {}
 	
	cQuery := ' SELECT
	cQuery += " A5_PRODUTO,
	cQuery += " A5_NOMPROD,
	cQuery += " A5_NOMEFOR
	
	cQuery += " FROM "+RetSqlName("SA5")+" SA5 "
	cQuery += " WHERE A5_PRODUTO = '"+ _cPesq+"'
	
	
	
	//cQuery := ChangeQuery(cQuery)
	
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
	dbSelectArea(cAliasLif)
	If  Select(cAliasLif) > 0
		(cAliasLif)->(dbgotop())
		
		While !(cAliasLif)->(Eof())
			
			aadd(aVetor ,{ lMark ,; //01
			(cAliasLif)->A5_PRODUTO	 ,;	//02   item
			(cAliasLif)->A5_NOMPROD	 ,;	//03   produto
			(cAliasLif)->A5_NOMEFOR	 ,;	//04   descrição
			' '	})
		 
			(cAliasLif)->(dbSkip())
		End
	EndIf
	
	
	If Len(aVetor) = 0
		aadd(aVetor,{.f.,' ',' ',' ',' ',' '})
	EndIf
	oLbx:SetArray( aVetor )
	oLbx:bLine := {|| {Iif(	aVetor[oLbx:nAt,1],oOk,oNo),;
		aVetor[oLbx:nAt,2],;
		aVetor[oLbx:nAt,3],;
		aVetor[oLbx:nAt,4];
		}}
	oLbx:Refresh()
	oDlg:Refresh()
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
	Local _n02  	:= 0
	Local _cAdd 	:= ' '
	Local cAliasLif := 'TMPB3'
	Local cQuery    := ' '
	Local lMark    	:= .F.
	Local _cSoma  	:= '01'
	_aCols03:={}
	If _cEdit = '2'
		DbSelectArea("SA5")
		SA5->(DbSetOrder(2))
		If SA5->(DbSeek(xFilial("SA5")+_cPesq))
			
			aVetor     := {}
			aadd(aVetor,{.T.,,SA5->A5_PRODUTO,SA5->A5_NOMPROD,SA5->A5_NOMEFOR})
			
			oLbx:SetArray( aVetor )
			oLbx:bLine := {|| {Iif(	aVetor[oLbx:nAt,1],oOk,oNo),;
				aVetor[oLbx:nAt,2],;
				aVetor[oLbx:nAt,3],;
				aVetor[oLbx:nAt,4],;
				}}
			oLbx:nAt:=1
		EndIf
	Else
		_cPesq	   		:= Space(15)
		
	EndIf
	for b:= 1 to Len(aVetor)
		
		aVetor[b,1]	:= .f.
		
	next b
	
	aVetor[oLbx:nAt,1]	:= .t.
	_cVetor  := aVetor[oLbx:nAt,3]
	
	
	cQuery := ' SELECT
	cQuery += " A5_PRODUTO,
	cQuery += " A5_NOMPROD,
	cQuery += " A5_NOMEFOR
	
	cQuery += " FROM "+RetSqlName("SA5")+" SA5 "
	cQuery += " WHERE A5_PRODUTO = '"+aVetor[oLbx:nAt,3]+"'
	
	
	
	
	
	cQuery := ChangeQuery(cQuery)
	
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
	dbSelectArea(cAliasLif)
	If  Select(cAliasLif) > 0
		(cAliasLif)->(dbgotop())
		
		While !(cAliasLif)->(Eof())
			DbSelectArea("SB1")
			SB1->(DbSetOrder(1))
			If SB1->(DbSeek(xFilial("SB1")+	(cAliasLif)->COMPONENTE))
				aadd(_aCols03 ,{ _cSoma ,; //01
				(cAliasLif)->COMPONENTE		 		 ,;	//02   item
				SB1->B1_DESC	 ,;	//03   produto
				(cAliasLif)->QUANT	 ,;	//04   descrição
				.f.	})
				_cSoma:=	Soma1(_cSoma)
			EndIf
			(cAliasLif)->(dbSkip())
		End
	EndIf
	
	
	oGetDados3:acols:=_aCols03
	
	oGetDados3:Refresh()
	oLbx:Refresh()
	oDlg:Refresh()
Return (.T.)


/*====================================================================================\
|Programa  | xGATPROD         | Autor | GIOVANI.ZAGO             | Data | 10/07/2014  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | xGATPROD                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function bGATPROD()
	*-----------------------------*
	Local _lret := .F.
	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))
	If SB1->(DbSeek(xFilial("SB1")+M->XX_COD))//oGetDados1:acols[n,2]))
		_lret:= .T.
		
		oGetDados1:acols[n,3]:= Alltrim(SB1->B1_DESC)
	Else
		MsgInfo("Produto não Localizado!!!!")
	EndIf
	oGetDados1:Refresh()
	oLbx:Refresh()
	oDlg:Refresh()
Return(_lret)

/*====================================================================================\
|Programa  | LimpSt           | Autor | GIOVANI.ZAGO             | Data | 10/07/2014  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | LimpSt                                                                   |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
Static Function LimpSt()
	*-----------------------------*
	aVetor     := {}
	aadd(aVetor,{.F.,'','','',''})
	oLbx:nAt:=1
	oLbx:SetArray( aVetor )
	oLbx:bLine := {|| {Iif(	aVetor[oLbx:nAt,1],oOk,oNo),;
		aVetor[oLbx:nAt,2],;
		aVetor[oLbx:nAt,3],;
		aVetor[oLbx:nAt,4],;
		aVetor[oLbx:nAt,5] ;
		}}
	
	_cPesq	   		:= Space(15)
	_aCols01:={}
	aadd(_aCols01,{'01',Space(15),Space(45),0,.F.})
	oGetDados1:Acols:=_aCols01
	
	_aCols03:={}
	oGetDados3:Acols:=_aCols03
	
	oGetDados1:Refresh()
	oGetDados3:Refresh()
	oLbx:Refresh()
	oDlg:Refresh()
	
Return()

/*====================================================================================\
|Programa  | CarrEstru        | Autor | GIOVANI.ZAGO             | Data | 10/07/2014  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | CarrEstru                                                                |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
Static Function CarrEstru()
	*-----------------------------*
	Local b := 0
	
	
	If !Empty(Alltrim(_cVetor)) .And. SCJ->CJ_STATUS <> 'X'
		U__fGrStru(_cVetor)
	Elseif SCJ->CJ_STATUS = 'X'
		MsgInfo("Orçamento Liberado p/ Vendas...!!!!")
	EndIf
	
Return()



