#Include 'Protheus.ch'
#Include 'RwMake.ch'
#Define CR chr(13) + chr(10)

/*====================================================================================\
|Programa  | STPESQESTRU      | Autor | GIOVANI.ZAGO             | Data | 10/07/2014  |
|=====================================================================================|
|Descrição |  STPESQESTRU  Pesquisa Estrutura	                                      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STPESQESTRU                                                              |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STPESQESTRU()   //  u_STPESQESTRU()

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
Private _a01Header 	:= {}
Private _aCols01   	:= {}
Private _a02Header 	:= {}
Private _aCols02   	:= {}
Private _a03Header 	:= {}
Private _aCols03   	:= {}
Private oLbx
Private aVetor     	:= {}
Private oOk			:= LoadBitmap( GetResources(), "LBOK" )
Private oNo	   		:= LoadBitmap( GetResources(), "LBNO" )
Private _cPesq	   	:= Space(15)
Private _oPesq
Private _cVetor		:= ''
Define FONT oFontN  NAME "Arial"
Define FONT oFontB  NAME "Arial" BOLD
Private oFontN  	:= TFont():New("Arial",9,25,.T.,.T.,5,.T.,5,.T.,.F.)
Private oFontB 	    := TFont():New("Arial",9,50,.T.,.T.,5,.T.,5,.T.,.F.)
ST_a01Header()
ST_a02Header()
ST_a03Header()

aAdd(aVetor,{.F.,' ',' ',' ',' ',' '})

Define MSDialog oDlg Title cCadastro From aSize[7],000 To aSize[6],aSize[5] of GetWndDefault() Pixel
@ aPosObj[1,3]/2-13,1 To aPosObj[1,3]/2-12,aPosObj[1,4]
@ 1,1 To aPosObj[1,3]+2,aPosObj[1,4]+2
@ 035,(aPosObj[1,4]/2)+20 Button "&Pesquisar"   size 50,15  action carrAcols02() Pixel of oDlg
@ 035,(aPosObj[1,4]/2)+75 Button "&Limpar"      size 50,15  action LimpSt() Pixel of oDlg
@ 035,005  SAY 'Componentes'	 PIXEL FONT oFontN OF  oDlg
oGetDados1 := MsNewGetDados():New(aPosObj[1,1]+15	,aPosObj[1,2]+5	,aPosObj[1,3]/2-15	,aPosObj[1,4]/2	,nStyle	,"AllWaysTrue","AllWaysTrue","+XX_ITEM",acpos,/*freeze*/,999,/*fieldok*/,/*superdel*/,/*delok*/,oDlg,_a01Header,_aCols01)
@ aPosObj[1,3]/2-09,006  SAY 'Codigo Pai'	PIXEL FONT oFontN OF  oDlg
@ aPosObj[1,3]/2-09,80  MSGet _oPesq Var _cPesq  F3 'SB1' Picture '@!'  VALID ( Empty(alltrim(_cPesq)) .Or. (EXISTCPO("SB1",_cPesq),edlista('2')) ) SIZE 50,10  PIXEL OF oDlg When .T.
@ aPosObj[1,3]/2+6,aPosObj[1,2]+5 listbox oLbx fields header " ", "Item",'Codigo',"Descrição",'Desenho'  size  aPosObj[1,4]/2 , aPosObj[1,3]/2-6  pixel of oDlg on dbLclick(edlista('1'))
oLbx:SetArray( aVetor )
oLbx:bLine := {|| {Iif(	aVetor[oLbx:nAt,1],oOk,oNo),;
						aVetor[oLbx:nAt,2],;
						aVetor[oLbx:nAt,3],;
						aVetor[oLbx:nAt,4],;
						aVetor[oLbx:nAt,5];
						}}
@ aPosObj[1,3]/2-09,(aPosObj[1,4]/2)+15  SAY 'Estrutura'	PIXEL FONT oFontN OF  oDlg
oGetDados3 := MsNewGetDados():New(aPosObj[1,3]/2+6,aPosObj[1,4]/2+15	,aPosObj[1,3]	,aPosObj[1,4]-5	,0		,"AllWaysTrue","AllWaysTrue","",,/*freeze*/,999,/*fieldok*/,/*superdel*/,/*delok*/,oDlg,_a03Header,_aCols03)
ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| nOpca := 1,oDlg:End() },{||oDlg:End()},,aButtons)

// se a opcao for encerrar executa a rotina.
If nOpca == 1
	
EndIf

Return

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

Static Function ST_a01Header()

aAdd(_a01Header,{"Item",			"XX_ITEM"	,"@!",TamSx3("D2_ITEMPV")[1],0,"","€€€€€€€€€€€€€€€","C","","","","",".T."})
aAdd(_a01Header,{"Produto",			"XX_COD"	,"@!",TamSx3("D2_COD")[1]	,0,"U_xGATPROD()","€€€€€€€€€€€€€€€","C","SB1","","","",".T."})
aAdd(_a01Header,{"Descricao",		"XX_DESC"	,"@!",TamSx3("B1_DESC")[1]	,0,"","€€€€€€€€€€€€€€€","C","","","","",".T."})
aAdd(_a01Header,{"Qtd.",	   		"XX_QTDD2"	,"@E 999,999.99",TamSx3("D2_QUANT")[1],TamSx3("D2_QUANT")[2],"","€€€€€€€€€€€€€€€","N","","","","",".T."})

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

Static Function ST_a02Header()

aAdd(_a02Header,{"Item",			"XX_ITEM"	,"@!",TamSx3("D2_ITEMPV")[1],0,"","€€€€€€€€€€€€€€€","C","","","","",".T."})
aAdd(_a02Header,{"Produto",			"XX_COD"	,"@!",TamSx3("D2_COD")[1]	,0,"","€€€€€€€€€€€€€€€","C","","","","",".T."})
aAdd(_a02Header,{"Descricao",		"XX_DESC"	,"@!",TamSx3("B1_DESC")[1]	,0,"","€€€€€€€€€€€€€€€","C","","","","",".T."})
//aAdd(_a02Header,{"Qtd. Nota",		"XX_QTDD2"	,"@E 999,999.99",TamSx3("D2_QUANT")[1],TamSx3("D2_QUANT")[2],"","€€€€€€€€€€€€€€€","N","","","","",".T."})

Return

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

Static Function ST_a03Header()

aAdd(_a03Header,{"Item",			"XX_ITEM"	,"@!",TamSx3("D2_ITEMPV")[1],0,"","€€€€€€€€€€€€€€€","C","","","","",".T."})
aAdd(_a03Header,{"Produto",			"XX_COD"	,"@!",TamSx3("D2_COD")[1]	,0,"","€€€€€€€€€€€€€€€","C","","","","",".T."})
aAdd(_a03Header,{"Descricao",		"XX_DESC"	,"@!",TamSx3("B1_DESC")[1]	,0,"","€€€€€€€€€€€€€€€","C","","","","",".T."})
aAdd(_a03Header,{"Qtd.    ",		"XX_QTDD2"	,"@E 999,999.99",TamSx3("D2_QUANT")[1],TamSx3("D2_QUANT")[2],"","€€€€€€€€€€€€€€€","N","","","","",".T."})

Return

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

Static Function carrAcols02()

Local _n02  	:= 0
Local _cAdd 	:= ' '
Local cAliasLif := 'TMPB2'
Local cQuery    := ' '
Local lMark    	:= .F.
Local _cSoma  	:= '01'
oGetDados3:acols:= {}
aVetor	:= {}
_cPesq	:= Space(15)
If Len(oGetDados1:acols) > 0
	For _n02:= 1 To Len(oGetDados1:acols)
		If !(oGetDados1:acols[_n02,Len(_a01Header)+1])
			dbSelectArea("SB1")
			SB1->( dbSetOrder(1) )
			If SB1->( dbSeek(xFilial("SB1") + oGetDados1:acols[_n02,2]) )
				If oGetDados1:acols[_n02,4] > 0
					_cAdd+="  INNER JOIN(SELECT * FROM  " + RetSqlName("SG1") + ") SG1 "
					_cAdd+="  ON SG1.D_E_L_E_T_ =  ' '
					_cAdd+='  	AND SG1.G1_COD = SB1.B1_COD
					_cAdd+="  	AND SG1.G1_COMP = '" + SB1->B1_COD + "'
					_cAdd+="  	AND SG1.G1_QUANT = " + cvaltochar(oGetDados1:acols[_n02,4])
				EndIf
			EndIf
		EndIf
	Next _n02
	If !Empty(Alltrim(_cAdd))
		cQuery := " SELECT
		cQuery += " DISTINCT
		cQuery += ' SB1.B1_COD AS "COD",
		cQuery += ' SB1.B1_XDESENH AS "DESE",
		cQuery += ' SB1.B1_DESC AS "DESC"
		cQuery += " FROM  " + RetSqlName("SB1") + " SB1 "
		cQuery += _cAdd
		cQuery += " WHERE SB1.D_E_L_E_T_ = ' '
		cQuery += " ORDER BY   SB1.B1_COD
		cQuery := ChangeQuery(cQuery)
		If Select(cAliasLif) > 0
			(cAliasLif)->( dbCloseArea() )
		EndIf
		dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
		dbSelectArea(cAliasLif)
		If  Select(cAliasLif) > 0
			(cAliasLif)->( dbgotop() )
			While (cAliasLif)->( !Eof() )
				aAdd(aVetor ,{	lMark 				,; //01
								_cSoma		 		,;	//02   item
								(cAliasLif)->COD	,;	//03   produto
								(cAliasLif)->DESC	,;	//04   descrição
								(cAliasLif)->DESE	,;	//05 desenho
								' '					})
				_cSoma := Soma1(_cSoma)
				(cAliasLif)->( dbSkip() )
			End
		EndIf
	EndIf
EndIf

If Len(aVetor) = 0
	aadd(aVetor,{.f.,' ',' ',' ',' ',' '})
EndIf

oLbx:SetArray( aVetor )
oLbx:bLine := {|| {Iif(	aVetor[oLbx:nAt,1],oOk,oNo),;
						aVetor[oLbx:nAt,2],;
						aVetor[oLbx:nAt,3],;
						aVetor[oLbx:nAt,4],;
						aVetor[oLbx:nAt,5];
						}}
oLbx:Refresh()
oDlg:Refresh()

Return

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

Static Function EdLista(_cEdit)

Local b  		:= 0
Local cAliasLif := 'TMPB3'
Local cQuery    := ' '
Local _cSoma  	:= '01'

_aCols03 := {}

If _cEdit = '2'
	dbSelectArea("SB1")
	SB1->( dbSetOrder(1) )
	If SB1->( dbSeek(xFilial("SB1") + _cPesq) )
		aVetor := {}
		aAdd(aVetor,{.T.,'01',SB1->B1_COD,SB1->B1_DESC,SB1->B1_XDESENH})
		oLbx:SetArray( aVetor )
		oLbx:bLine := {|| {Iif(	aVetor[oLbx:nAt,1],oOk,oNo),;
								aVetor[oLbx:nAt,2],;
								aVetor[oLbx:nAt,3],;
								aVetor[oLbx:nAt,4],;
								aVetor[oLbx:nAt,5] ;
								}}
		oLbx:nAt := 1
	EndIf
Else
	_cPesq := Space(15)
EndIf

For b := 1 to Len(aVetor)
	aVetor[b,1]	:= .F.
next b

aVetor[oLbx:nAt,1] := .T.
_cVetor  := aVetor[oLbx:nAt,3]
cQuery := ' SELECT SG1.G1_COMP AS "COMPONENTE", SG1.G1_QUANT AS "QUANT"
cQuery += " FROM  " + RetSqlName("SG1") + " SG1 "
cQuery += " WHERE SG1.D_E_L_E_T_ =  ' ' "
cQuery += " 	AND SG1.G1_COD = '" + aVetor[oLbx:nAt,3] + "' "
// Ticket 20210514007939 - Atualização Estrutura para Vendas - Eduardo Pereira Sigamat - 14.05.2021 - Inicio
cQuery += " 	AND SG1.G1_FILIAL = '05' "	// Alterei de Filial 04 para 05
// Ticket 20210514007939 - Atualização Estrutura para Vendas - Eduardo Pereira Sigamat - 14.05.2021 - Fim
cQuery += " 	ORDER BY   SG1.G1_COMP "
cQuery := ChangeQuery(cQuery)
If Select(cAliasLif) > 0
	(cAliasLif)->( dbCloseArea() )
EndIf
dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
dbSelectArea(cAliasLif)
If  Select(cAliasLif) > 0
	(cAliasLif)->( dbgotop() )
	While (cAliasLif)->( !Eof() )
		dbSelectArea("SB1")
		SB1->( dbSetOrder(1) )
		If SB1->( dbSeek(xFilial("SB1") + (cAliasLif)->COMPONENTE) )
			aAdd(_aCols03 ,{ _cSoma 					,; //01
							(cAliasLif)->COMPONENTE		,;	//02   item
							SB1->B1_DESC	 			,;	//03   produto
							(cAliasLif)->QUANT	 		,;	//04   descrição
							.F.							})
			_cSoma := Soma1(_cSoma)
		EndIf
		(cAliasLif)->( dbSkip() )
	End
EndIf

oGetDados3:acols := _aCols03
oGetDados3:Refresh()
oLbx:Refresh()
oDlg:Refresh()

Return .T.

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

User Function xGATPROD()

Local _lret := .F.

dbSelectArea("SB1")
SB1->( dbSetOrder(1) )
If SB1->( dbSeek(xFilial("SB1") + M->XX_COD) )	// oGetDados1:acols[n,2]))
	_lret:= .T.
	oGetDados1:acols[n,3] := Alltrim(SB1->B1_DESC)
Else
	MsgInfo("Produto não Localizado!!!!")
EndIf

oGetDados1:Refresh()
oLbx:Refresh()
oDlg:Refresh()

Return _lret

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

Static Function LimpSt()

aVetor     := {}
aAdd(aVetor,{.F.,'','','',''})
oLbx:nAt := 1
oLbx:SetArray( aVetor )
oLbx:bLine := {|| {Iif(	aVetor[oLbx:nAt,1],oOk,oNo),;
						aVetor[oLbx:nAt,2],;
						aVetor[oLbx:nAt,3],;
						aVetor[oLbx:nAt,4],;
						aVetor[oLbx:nAt,5] ;
						}}

_cPesq	 := Space(15)
_aCols01 := {}
aAdd(_aCols01,{'01',Space(15),Space(45),0,.F.})
oGetDados1:aCols :=_aCols01

_aCols03 := {}
oGetDados3:Acols:=_aCols03

oGetDados1:Refresh()
oGetDados3:Refresh()
oLbx:Refresh()
oDlg:Refresh()

Return

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

Static Function CarrEstru()

If !Empty(Alltrim(_cVetor)) .And. SCJ->CJ_STATUS <> 'X'
	U__fGrStru(_cVetor)
Elseif SCJ->CJ_STATUS = 'X'
	MsgInfo("Orçamento Liberado p/ Vendas...!!!!")
EndIf

Return
                    