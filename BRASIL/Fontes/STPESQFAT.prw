#include 'Protheus.ch'
#include 'RwMake.ch'
#Define CR chr(13)+chr(10)
/*====================================================================================\
|Programa  | STPESQFAT        | Autor | GIOVANI.ZAGO             | Data | 30/09/2014  |
|=====================================================================================|
|Descrição |  STPESQFAT    Pesquisa PEDIDO		                                      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STPESQORC                                                                |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function STPESQFAT()   //  u_STPESQFAT()
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
//If !IsInCallSteck("U_STFTA001")
//	aAdd(aButtons,{"PMSSETAUP"  	,{|| CarrEstru()}		,"Carrega Estrutura"		,"Carrega Estrutura"})
//EndIf
Private cCadastro := "Pesquisa Pedidos"
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

Private _cPesq	   := Space(15)
Private _oPesq
Private _cVetor	   := ''
Define FONT oFontN  NAME "Arial"
Define FONT oFontB  NAME "Arial" BOLD
Private oFontN     := TFont():New("Arial",9,25,.T.,.T.,5,.T.,5,.T.,.F.)
Private oFontB 	   := TFont():New("Arial",9,50,.T.,.T.,5,.T.,5,.T.,.F.)
Private dEmisIni   := ctod('01/01/2013')
Private dEmisfim   := ddatabase
Private oEmisIni
Private oEmisfim
Private cAreade  := '      '
Private cAreaate := 'zzzzzz'
Private oAreade
Private oAreaate
Private oLoj
Private oCli
Private cLoj	:= '  '
Private cCli	:= '      '
ST_a01Header()
ST_a02Header()
ST_a03Header()

aadd(aVetor,{.f.,' ',' ',space(30),space(10),space(10) })

Define MSDialog oDlg Title cCadastro From aSize[7],000 To aSize[6],aSize[5] of GetWndDefault() Pixel

@ aPosObj[1,3]/2-19,1 To aPosObj[1,3]/2-18,aPosObj[1,4]

@ 1,1 To aPosObj[1,3]+2,aPosObj[1,4]+2
@ 035,(aPosObj[1,4]/2)+170 Button "&Pesquisar"   size 50,15  action 	Processa({|| 	carrAcols02()},'Aguarde...!!!!')   Pixel of oDlg
@ 035,(aPosObj[1,4]/2)+225 Button "&Limpar"      size 50,15  action LimpSt() Pixel of oDlg

@ 38,(aPosObj[1,4]/2)+20 Say "Emissao de" PIXEL of oDlg
@ 45,(aPosObj[1,4]/2)+20 MsGet oEmisIni Var dEmisIni Picture "@D" PIXEL of oDlg SIZE 50,09

@ 38,(aPosObj[1,4]/2)+75 Say "Emissao ate" PIXEL of oDlg
@ 45,(aPosObj[1,4]/2)+75 MsGet oEmisFim Var dEmisFim Picture "@D" PIXEL of oDlg SIZE 50,09

@ 69,(aPosObj[1,4]/2)+20 Say "Area de" PIXEL of oDlg
@ 76,(aPosObj[1,4]/2)+20 MsGet oAreade Var cAreade Picture "@D" PIXEL of oDlg SIZE 50,09

@ 69,(aPosObj[1,4]/2)+75 Say "Area ate" PIXEL of oDlg
@ 76,(aPosObj[1,4]/2)+75 MsGet oAreaate Var cAreaate Picture "@D" PIXEL of oDlg SIZE 50,09

@ 100,(aPosObj[1,4]/2)+20 Say "Cliente" PIXEL of oDlg
@ 107,(aPosObj[1,4]/2)+20 MsGet oCli Var cCli Picture "@!"  F3 "SA1" PIXEL of oDlg SIZE 50,09

@ 100,(aPosObj[1,4]/2)+75 Say "Loja" PIXEL of oDlg
@ 107,(aPosObj[1,4]/2)+75 MsGet oLoj Var cLoj Picture "@!"   PIXEL of oDlg SIZE 50,09

Private oAreade
Private oAreaate

@ 035,005  SAY 'Produtos'	 PIXEL FONT oFontN OF  oDlg
oGetDados1 := MsNewGetDados():New(aPosObj[1,1]+15	,aPosObj[1,2]+5	,aPosObj[1,3]/2-25	,aPosObj[1,4]/2	,nStyle	,"AllWaysTrue","AllWaysTrue","+XX_ITEM",acpos,/*freeze*/,999,/*fieldok*/,/*superdel*/,/*delok*/,oDlg,_a01Header,_aCols01)

@ aPosObj[1,3]/2-14,006  SAY 'Pedidos'	PIXEL FONT oFontN OF  oDlg
//@ aPosObj[1,3]/2-16,80  MSGet _oPesq Var _cPesq  F3 'SB1' Picture '@!'  VALID ( Empty(alltrim(_cPesq)) .Or. (EXISTCPO("SB1",_cPesq),edlista('2')) ) SIZE 50,10  PIXEL OF oDlg When .T.

@ aPosObj[1,3]/2,aPosObj[1,2]+5 listbox oLbx fields header " ", "Item",'Numero','Cliente',"Emissao",'Area','.'  size  aPosObj[1,4]/2 , aPosObj[1,3]/2  pixel of oDlg on dbLclick(edlista('1'))

oLbx:SetArray( aVetor )

oLbx:bLine := {|| {Iif(	aVetor[oLbx:nAt,1],oOk,oNo),;
aVetor[oLbx:nAt,2],;
aVetor[oLbx:nAt,3],;
aVetor[oLbx:nAt,4],;
aVetor[oLbx:nAt,5],;
aVetor[oLbx:nAt,6],;
' '}}



//@ aPosObj[1,3]/2-16,(aPosObj[1,4]/2)+15  SAY 'Estrutura'	PIXEL FONT oFontN OF  oDlg
oGetDados3 := MsNewGetDados():New(aPosObj[1,3]/2,aPosObj[1,4]/2+15	,aPosObj[1,3]	,aPosObj[1,4]-5	,0		,"AllWaysTrue","AllWaysTrue","",,/*freeze*/,999,/*fieldok*/,/*superdel*/,/*delok*/,oDlg,_a03Header,_aCols03)

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
*-----------------------------*
Static Function ST_a01Header()
*-----------------------------*
aAdd(_a01Header,{"Item",			"XX_ITEM"	,"@!",TamSx3("D2_ITEMPV")[1],0,"","€€€€€€€€€€€€€€€","C","","","","",".T."})
aAdd(_a01Header,{"Produto",			"XX_COD"	,"@!",TamSx3("D2_COD")[1]	,0,"U_IGATPROD()","€€€€€€€€€€€€€€€","C","SB1","","","",".T."})
aAdd(_a01Header,{"Descricao",		"XX_DESC"	,"@!",TamSx3("B1_DESC")[1]	,0,"","€€€€€€€€€€€€€€€","C","","","","",".T."})
aAdd(_a01Header,{"Qtd.",	   		"XX_QTDD2"	,"@E 999,999.99",TamSx3("D2_QUANT")[1],TamSx3("D2_QUANT")[2],"","€€€€€€€€€€€€€€€","N","","","","",".T."})

Return()

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
aAdd(_a02Header,{"Item",			"XX_ITEM"	,"@!",TamSx3("D2_ITEMPV")[1],0,"","€€€€€€€€€€€€€€€","C","","","","",".T."})
aAdd(_a02Header,{"Produto",			"XX_COD"	,"@!",TamSx3("D2_COD")[1]	,0,"","€€€€€€€€€€€€€€€","C","","","","",".T."})
aAdd(_a02Header,{"Descricao",		"XX_DESC"	,"@!",TamSx3("B1_DESC")[1]	,0,"","€€€€€€€€€€€€€€€","C","","","","",".T."})
//aAdd(_a02Header,{"Qtd. Nota",		"XX_QTDD2"	,"@E 999,999.99",TamSx3("D2_QUANT")[1],TamSx3("D2_QUANT")[2],"","€€€€€€€€€€€€€€€","N","","","","",".T."})

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
aAdd(_a03Header,{"Prc.Ven.",		"XX_QTDD3"	,"@E 999,999.99",TamSx3("D2_QUANT")[1],TamSx3("D2_QUANT")[2],"","€€€€€€€€€€€€€€€","N","","","","",".T."})
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
Local _cOrcNum  := ' '
oGetDados3:acols:= {}
//aadd(aVetor,{.f.,' ',' ',space(50),space(10) })
aVetor:={}
_cPesq	   		:= Space(15)
If Len(oGetDados1:acols) > 0
	
	For _n02:= 1 To Len(oGetDados1:acols)
		If !(oGetDados1:acols[_n02,Len(_a01Header)+1])
			DbSelectArea("SB1")
			SB1->(DbSetOrder(1))
			If SB1->(DbSeek(xFilial("SB1")+oGetDados1:acols[_n02,2]))
				
				
				_cAdd+="  AND EXISTS (SELECT * FROM  "+RetSqlName("SC6")+" TC6 "
				_cAdd+="  WHERE TC6.D_E_L_E_T_ =  ' '
				_cAdd+="  AND TC6.C6_PRODUTO = '"+SB1->B1_COD+"'"
				If oGetDados1:acols[_n02,4] > 0
					_cAdd+="  AND TC6.C6_QTDVEN = "+cvaltochar(oGetDados1:acols[_n02,4])
				EndIf
				_cAdd+=" AND TC6.C6_FILIAL = SC6.C6_FILIAL
				_cAdd+=" AND TC6.C6_NUM = SC6.C6_NUM )
				
				
			EndIf
		EndIf
	Next _n02
	
	If !Empty(Alltrim(_cAdd))
		
		cQuery := " SELECT
		cQuery += " DISTINCT
		cQuery += ' SC6.C6_NUM AS "COD",
		cQuery += ' SC5.C5_VEND1 "VEND",
		cQuery += ' SC5.C5_CLIENTE
		cQuery += '   "CLIENTE"	,
		cQuery += ' SC5.C5_LOJACLI
		cQuery += '  "LOJA"	,
		cQuery += ' SC5.C5_XNOME "NOME",
		cQuery += "   SUBSTR(SC5.C5_EMISSAO,7,2)||'/'|| SUBSTR(SC5.C5_EMISSAO,5,2)||'/'|| SUBSTR(SC5.C5_EMISSAO,1,4)
		cQuery += ' AS "XDESC"
		cQuery += " FROM  "+RetSqlName("SC6")+" SC6 "
		cQuery += " INNER JOIN( SELECT * FROM "+RetSqlName("SC5")+") SC5 "
		cQuery += " ON SC5.D_E_L_E_T_ = ' '
		cQuery += " AND SC5.C5_NUM = SC6.C6_NUM
		cQuery += " AND SC5.C5_FILIAL = SC6.C6_FILIAL
		cQuery += " WHERE SC6.D_E_L_E_T_ = ' ' 
	   //	cQuery += " AND SC6.C6_BLQ <> 'R'
		//cQuery += " AND SC6.C6_QTDVEN <> SC6.C6_QTDENT
		cQuery += " AND SC6.C6_FILIAL = '"+xFilial("SC6")+"'
		cQuery += " AND SC5.C5_EMISSAO BETWEEN '"+DTOS(dEmisIni)+"' AND '"+DTOS(dEmisFIM)+"'
		cQuery += " AND SC5.C5_VEND1 BETWEEN '"+cAreade+"' AND '"+cAreaate+"'
		If !Empty(Alltrim(cCli))   .And. !Empty(Alltrim(cLoj))
			cQuery += " AND SC5.C5_CLIENTE = '"+cCli+"'
			cQuery += " AND SC5.C5_LOJACLI = '"+cLoj+"'
		EndIf
		DbSelectArea('SA3')
		SA3->(DbSetOrder(7))
		If SA3->(dbSeek(xFilial('SA3')+__cuserid))
			If SA3->A3_TPVEND <> 'I'
				
				cQuery += " AND (SC5.C5_VEND1 = '"+SA3->A3_COD+"' OR SC5.C5_VEND2 = '"+SA3->A3_COD+"')
				
			EndIf
		EndIf
		
		cQuery += _cAdd
		cQuery += " ORDER BY   SC6.C6_NUM   DESC
		
		
		cQuery := ChangeQuery(cQuery)
		
		If Select(cAliasLif) > 0
			(cAliasLif)->(dbCloseArea())
		EndIf
		dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
		dbSelectArea(cAliasLif)
		ProcRegua(RecCount()) // Numero de registros a processar
		IncProc()
		If  Select(cAliasLif) > 0
			(cAliasLif)->(dbgotop())
			
			While !(cAliasLif)->(Eof())
				IncProc("Lendo Pedido: "+(cAliasLif)->COD)
				If _cOrcNum  <> 	(cAliasLif)->COD
					aadd(aVetor ,{ lMark ,; //01
					_cSoma		 		 ,;	//02   item
					(cAliasLif)->COD	 ,;	//03   produto
					(cAliasLif)->CLIENTE+'/'+	(cAliasLif)->LOJA+' - '+   SUBSTR(	(cAliasLif)->NOME,1,15)	 ,;	//04   descrição
					(cAliasLif)->XDESC   ,;
					(cAliasLif)->VEND+' - '+Posicione("SA3",1,xFilial("SA3") + (cAliasLif)->VEND ,"A3_NOME")	 	})
					_cSoma:=	Soma1(_cSoma)
					_cOrcNum :=	(cAliasLif)->COD
				EndIf
				(cAliasLif)->(dbSkip())
			End
		EndIf
	EndIf
EndIf
If Len(aVetor) = 0
	aadd(aVetor,{.f.,' ',' ',space(30),space(10),space(10) })
EndIf
oLbx:SetArray( aVetor )
oLbx:bLine := {|| {Iif(	aVetor[oLbx:nAt,1],oOk,oNo),;
aVetor[oLbx:nAt,2],;
aVetor[oLbx:nAt,3],;
aVetor[oLbx:nAt,4],;
aVetor[oLbx:nAt,5],;
aVetor[oLbx:nAt,6],;
' ' }}
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
	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))
	If SB1->(DbSeek(xFilial("SB1")+_cPesq))
		
		aVetor     := {}
		aadd(aVetor,{.T.,'01',SB1->B1_COD,SB1->B1_DESC})
		
		oLbx:SetArray( aVetor )
		oLbx:bLine := {|| {Iif(	aVetor[oLbx:nAt,1],oOk,oNo),;
		aVetor[oLbx:nAt,2],;
		aVetor[oLbx:nAt,3],;
		aVetor[oLbx:nAt,4] ;
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

cQuery := " SELECT   *

cQuery += " FROM  "+RetSqlName("SC6")+" SC6 "

cQuery += " WHERE SC6.D_E_L_E_T_ = ' '
cQuery += " AND SC6.C6_FILIAL = '"+xFilial("SC6")+"'
cQuery += " AND SC6.C6_NUM = '"+aVetor[oLbx:nAt,3]+"'
cQuery += " ORDER BY   SC6.C6_ITEM


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
		If SB1->(DbSeek(xFilial("SB1")+	(cAliasLif)->C6_PRODUTO))
			aadd(_aCols03 ,{ 	(cAliasLif)->C6_ITEM ,; //01
			SB1->B1_COD		 		 ,;	//02   item
			substr(SB1->B1_DESC,1,30)	 ,;	//03   produto
			(cAliasLif)->C6_QTDVEN	 ,;	//04   descrição
			(cAliasLif)->C6_PRCVEN	 ,;
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
User Function IGATPROD()
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
aadd(aVetor,{.F.,'','','','',''})
oLbx:nAt:=1
oLbx:SetArray( aVetor )
oLbx:bLine := {|| {Iif(	aVetor[oLbx:nAt,1],oOk,oNo),;
aVetor[oLbx:nAt,2],;
aVetor[oLbx:nAt,3],;
aVetor[oLbx:nAt,4],;
aVetor[oLbx:nAt,5], ;
aVetor[oLbx:nAt,6] ;
}}

_cPesq	   		:= Space(15)
_aCols01:={}
aadd(_aCols01,{'01',Space(15),Space(30),0,.F.})
oGetDados1:Acols:=_aCols01

_aCols03:={}
aadd(_aCols03,{'01',Space(15),Space(30),0,0,.F.})
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
	MsgInfo("Orçamenrto Liberado p/ Vendas...!!!!")
EndIf

Return()



                    