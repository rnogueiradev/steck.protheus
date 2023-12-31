#include 'Protheus.ch'
#include 'RwMake.ch'
#Define CR chr(13)+chr(10)
/*====================================================================================\
|Programa  | STPESQORC        | Autor | GIOVANI.ZAGO             | Data | 30/09/2014  |
|=====================================================================================|
|Descri��o |  STPESQORC    Pesquisa OR�AMENTO	                                      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STPESQORC                                                                |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Hist�rico....................................|
\====================================================================================*/
*-----------------------------*
User Function STPESQORC()   //  u_STPESQORC()
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
	Private cCadastro := "Pesquisa Or�amentos"
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
	Private lSaida   := .f.
	Private _nOpcao  := 0
	
	
	
	
	
	Define msDialog _oDxlg Title "Pedido/Or�amento" From 10,10 TO 100,120 Pixel
	
	@ 005,005 Button "&Pedido"   size 40,14  action ((lSaida:=.T.,_nOpcao:=2,_oDxlg:End())) Of _oDxlg Pixel
	
	
	@ 021,005 Button "&Or�amento" size 40,14  action ((lSaida:=.T.,_nOpcao:=1,_oDxlg:End())) Of _oDxlg Pixel
	
	Activate dialog _oDxlg centered
	
	If _nOpcao = 0
		return()
	EndIf
	
	
	
	If _nOpcao = 2
		u_STPESQFAT()
		return()
	EndIf
	
	ST_a01Header()
	ST_a02Header()
	ST_a03Header()
	_nPosTel:= 60
	aadd(aVetor,{.f.,' ',' ',space(30),space(10),space(10) })
	
	Define MSDialog oDlg Title cCadastro From aSize[7],000 To aSize[6],aSize[5] of GetWndDefault() Pixel
	
	@ aPosObj[1,3]/2-19,1 To aPosObj[1,3]/2-18,aPosObj[1,4]
	
	@ 1,1 To aPosObj[1,3]+2,aPosObj[1,4]+2
	@ 005+_nPosTel,(aPosObj[1,4]/2)+20 Button "&Pesquisar"   size 50,15  action 	Processa({|| 	carrAcols02()},'Aguarde...!!!!')   Pixel of oDlg
	@ 005+_nPosTel,(aPosObj[1,4]/2)+75 Button "&Limpar"      size 50,15  action LimpSt() Pixel of oDlg
	
	@ 28+_nPosTel,(aPosObj[1,4]/2)+20 Say "Emissao de" PIXEL of oDlg
	@ 34+_nPosTel,(aPosObj[1,4]/2)+20 MsGet oEmisIni Var dEmisIni Picture "@D" PIXEL of oDlg SIZE 50,09
	
	@ 28+_nPosTel,(aPosObj[1,4]/2)+75 Say "Emissao ate" PIXEL of oDlg
	@ 34+_nPosTel,(aPosObj[1,4]/2)+75 MsGet oEmisFim Var dEmisFim Picture "@D" PIXEL of oDlg SIZE 50,09
	
	@ 59+_nPosTel,(aPosObj[1,4]/2)+20 Say "Area de" PIXEL of oDlg
	@ 65+_nPosTel,(aPosObj[1,4]/2)+20 MsGet oAreade Var cAreade Picture "@!" PIXEL of oDlg SIZE 50,09
	
	@ 59+_nPosTel,(aPosObj[1,4]/2)+75 Say "Area ate" PIXEL of oDlg
	@ 65+_nPosTel,(aPosObj[1,4]/2)+75 MsGet oAreaate Var cAreaate Picture "@!" PIXEL of oDlg SIZE 50,09
	
	@ 90+_nPosTel,(aPosObj[1,4]/2)+20 Say "Cliente" PIXEL of oDlg
	@ 96+_nPosTel,(aPosObj[1,4]/2)+20 MsGet oCli Var cCli Picture "@!"  F3 "SA1" PIXEL of oDlg SIZE 50,09
	
	@ 90+_nPosTel,(aPosObj[1,4]/2)+75 Say "Loja" PIXEL of oDlg
	@ 96+_nPosTel,(aPosObj[1,4]/2)+75 MsGet oLoj Var cLoj Picture "@!"   PIXEL of oDlg SIZE 50,09
	
	
	Private oAreaate
	
	@ 005+_nPosTel,005  SAY 'Produtos'	 PIXEL FONT oFontN OF  oDlg
	oGetDados1 := MsNewGetDados():New(aPosObj[1,1]+15	,aPosObj[1,2]+5	,aPosObj[1,3]/2-25	,aPosObj[1,4]/2	,nStyle	,"AllWaysTrue","AllWaysTrue","+XX_ITEM",acpos,/*freeze*/,999,/*fieldok*/,/*superdel*/,/*delok*/,oDlg,_a01Header,_aCols01)
	
	@ aPosObj[1,3]/2-16+_nPosTel,006  SAY 'Or�amentos'	PIXEL FONT oFontN OF  oDlg
	//@ aPosObj[1,3]/2-16,80  MSGet _oPesq Var _cPesq  F3 'SB1' Picture '@!'  VALID ( Empty(alltrim(_cPesq)) .Or. (EXISTCPO("SB1",_cPesq),edlista('2')) ) SIZE 50,10  PIXEL OF oDlg When .T.
	
	@ aPosObj[1,3]/2+_nPosTel,aPosObj[1,2]+5 listbox oLbx fields header " ", "Item",'Numero','Cliente',"Emissao",'Area','.'  size  aPosObj[1,4]/2 , aPosObj[1,3]/2  pixel of oDlg on dbLclick(edlista('1'))
	
	oLbx:SetArray( aVetor )
	
	oLbx:bLine := {|| {Iif(	aVetor[oLbx:nAt,1],oOk,oNo),;
		aVetor[oLbx:nAt,2],;
		aVetor[oLbx:nAt,3],;
		aVetor[oLbx:nAt,4],;
		aVetor[oLbx:nAt,5],;
		aVetor[oLbx:nAt,6],;
		' '}}
	
	
	
	//@ aPosObj[1,3]/2-16,(aPosObj[1,4]/2)+15  SAY 'Estrutura'	PIXEL FONT oFontN OF  oDlg
	oGetDados3 := MsNewGetDados():New(aPosObj[1,3]/2+_nPosTel,aPosObj[1,4]/2+15	,aPosObj[1,3]	,aPosObj[1,4]-5	,0		,"AllWaysTrue","AllWaysTrue","",,/*freeze*/,999,/*fieldok*/,/*superdel*/,/*delok*/,oDlg,_a03Header,_aCols03)
	
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| nOpca := 1,oDlg:End() },{||oDlg:End()},,aButtons)
	
	// se a opcao for encerrar executa a rotina.
	If nOpca == 1
		
	EndIf
	
Return

/*====================================================================================\
|Programa  | ST_a01Header     | Autor | GIOVANI.ZAGO             | Data | 10/07/2014  |
|=====================================================================================|
|Descri��o |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | ST_a01Header                                                             |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Hist�rico....................................|
\====================================================================================*/
*-----------------------------*
Static Function ST_a01Header()
	*-----------------------------*
	aAdd(_a01Header,{"Item",			"XX_ITEM"	,"@!",TamSx3("D2_ITEMPV")[1],0,"","���������������","C","","","","",".T."})
	aAdd(_a01Header,{"Produto",			"XX_COD"	,"@!",TamSx3("D2_COD")[1]	,0,"U_zGATPROD()","���������������","C","SB1","","","",".T."})
	aAdd(_a01Header,{"Descricao",		"XX_DESC"	,"@!",TamSx3("B1_DESC")[1]	,0,"","���������������","C","","","","",".T."})
	aAdd(_a01Header,{"Qtd.",	   		"XX_QTDD2"	,"@E 999,999.99",TamSx3("D2_QUANT")[1],TamSx3("D2_QUANT")[2],"","���������������","N","","","","",".T."})
	
Return()

/*====================================================================================\
|Programa  | ST_a02Header     | Autor | GIOVANI.ZAGO             | Data | 10/07/2014  |
|=====================================================================================|
|Descri��o |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | ST_a02Header                                                             |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Hist�rico....................................|
\====================================================================================*/
*-----------------------------*
Static Function ST_a02Header()
	*-----------------------------*
	aAdd(_a02Header,{"Item",			"XX_ITEM"	,"@!",TamSx3("D2_ITEMPV")[1],0,"","���������������","C","","","","",".T."})
	aAdd(_a02Header,{"Produto",			"XX_COD"	,"@!",TamSx3("D2_COD")[1]	,0,"","���������������","C","","","","",".T."})
	aAdd(_a02Header,{"Descricao",		"XX_DESC"	,"@!",TamSx3("B1_DESC")[1]	,0,"","���������������","C","","","","",".T."})
	//aAdd(_a02Header,{"Qtd. Nota",		"XX_QTDD2"	,"@E 999,999.99",TamSx3("D2_QUANT")[1],TamSx3("D2_QUANT")[2],"","���������������","N","","","","",".T."})
	
Return()

/*====================================================================================\
|Programa  | ST_a03Header     | Autor | GIOVANI.ZAGO             | Data | 10/07/2014  |
|=====================================================================================|
|Descri��o |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | ST_a03Header                                                             |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Hist�rico....................................|
\====================================================================================*/
*-----------------------------*
Static Function ST_a03Header()
	*-----------------------------*
	aAdd(_a03Header,{"Item",			"XX_ITEM"	,"@!",TamSx3("D2_ITEMPV")[1],0,"","���������������","C","","","","",".T."})
	aAdd(_a03Header,{"Produto",			"XX_COD"	,"@!",TamSx3("D2_COD")[1]	,0,"","���������������","C","","","","",".T."})
	aAdd(_a03Header,{"Descricao",		"XX_DESC"	,"@!",TamSx3("B1_DESC")[1]	,0,"","���������������","C","","","","",".T."})
	aAdd(_a03Header,{"Qtd.    ",		"XX_QTDD2"	,"@E 999,999.99",TamSx3("D2_QUANT")[1],TamSx3("D2_QUANT")[2],"","���������������","N","","","","",".T."})
	aAdd(_a03Header,{"Prc.Ven.",		"XX_QTDD3"	,"@E 999,999.99",TamSx3("D2_QUANT")[1],TamSx3("D2_QUANT")[2],"","���������������","N","","","","",".T."})
Return()



/*====================================================================================\
|Programa  | carrAcols02      | Autor | GIOVANI.ZAGO             | Data | 10/07/2014  |
|=====================================================================================|
|Descri��o |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | carrAcols02                                                              |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Hist�rico....................................|
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
	
	aVetor:={}
	_cPesq	   		:= Space(15)
	If Len(oGetDados1:acols) > 0
		
		For _n02:= 1 To Len(oGetDados1:acols)
			If !(oGetDados1:acols[_n02,Len(_a01Header)+1])
				DbSelectArea("SB1")
				SB1->(DbSetOrder(1))
				If SB1->(DbSeek(xFilial("SB1")+oGetDados1:acols[_n02,2]))
					
					
					_cAdd+="  AND EXISTS (SELECT * FROM  "+RetSqlName("SUB")+" TUB "
					_cAdd+="  WHERE TUB.D_E_L_E_T_ =  ' '
					_cAdd+="  AND TUB.UB_PRODUTO = '"+SB1->B1_COD+"'"
					If oGetDados1:acols[_n02,4] > 0
						_cAdd+="  AND TUB.UB_QUANT = "+cvaltochar(oGetDados1:acols[_n02,4])
					EndIf
					_cAdd+=" AND TUB.UB_FILIAL = SUB.UB_FILIAL
					_cAdd+=" AND TUB.UB_NUM = SUB.UB_NUM )
					
					
				EndIf
			EndIf
		Next _n02
		
		If !Empty(Alltrim(_cAdd))
			
			cQuery := " SELECT
			cQuery += " DISTINCT
			cQuery += ' SUB.UB_NUM AS "COD",
			cQuery += ' SUA.UA_VEND "VEND",
			cQuery += ' SUA.UA_CLIENTE
			cQuery += '   "CLIENTE"	,
			cQuery += ' SUA.UA_LOJA
			cQuery += '  "LOJA"	,
			cQuery += ' SUA.UA_XNOME "NOME",
			cQuery += "   SUBSTR(SUA.UA_EMISSAO,7,2)||'/'|| SUBSTR(SUA.UA_EMISSAO,5,2)||'/'|| SUBSTR(SUA.UA_EMISSAO,1,4)
			cQuery += ' AS "XDESC"
			cQuery += " FROM  "+RetSqlName("SUB")+" SUB "
			cQuery += " INNER JOIN( SELECT * FROM "+RetSqlName("SUA")+") SUA "
			cQuery += " ON SUA.D_E_L_E_T_ = ' '
			cQuery += " AND SUA.UA_NUM = SUB.UB_NUM
			cQuery += " AND SUA.UA_FILIAL = SUB.UB_FILIAL
			cQuery += " WHERE SUB.D_E_L_E_T_ = ' '
			cQuery += " AND SUB.UB_FILIAL = '"+xFilial("SUB")+"'
			cQuery += " AND SUA.UA_NUMSC5 = ' '
			cQuery += " AND SUA.UA_XCODMCA = ' '
			cQuery += " AND SUA.UA_EMISSAO BETWEEN '"+DTOS(dEmisIni)+"' AND '"+DTOS(dEmisFIM)+"'
			cQuery += " AND SUA.UA_VEND BETWEEN '"+cAreade+"' AND '"+cAreaate+"'
			If !Empty(Alltrim(cCli))   .And. !Empty(Alltrim(cLoj))
				cQuery += " AND SUA.UA_CLIENTE = '"+cCli+"'
				cQuery += " AND SUA.UA_LOJA = '"+cLoj+"'
			EndIf
			DbSelectArea('SA3')
			SA3->(DbSetOrder(7))
			If SA3->(dbSeek(xFilial('SA3')+__cuserid))
				If SA3->A3_TPVEND <> 'I'
					
					cQuery += " AND (SUA.UA_VEND = '"+SA3->A3_COD+"' OR SUA.UA_VEND2 = '"+SA3->A3_COD+"')
					
				EndIf
			EndIf
			cQuery += _cAdd
			cQuery += " ORDER BY   SUB.UB_NUM   DESC
			
			
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
					IncProc("Lendo Or�amento: "+(cAliasLif)->COD)
					If _cOrcNum  <> 	(cAliasLif)->COD
						aadd(aVetor ,{ lMark ,; //01
						_cSoma		 		 ,;	//02   item
						(cAliasLif)->COD	 ,;	//03   produto
						(cAliasLif)->CLIENTE+'/'+	(cAliasLif)->LOJA+' - '+   SUBSTR(	(cAliasLif)->NOME,1,15)	 ,;	//04   descri��o
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
|Descri��o |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | EdLista                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Hist�rico....................................|
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
	
	cQuery += " FROM  "+RetSqlName("SUB")+" SUB "
	
	cQuery += " WHERE SUB.D_E_L_E_T_ = ' '
	cQuery += " AND SUB.UB_FILIAL = '"+xFilial("SUB")+"'
	cQuery += " AND SUB.UB_NUM = '"+aVetor[oLbx:nAt,3]+"'
	cQuery += " ORDER BY   SUB.UB_ITEM
	
	
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
			If SB1->(DbSeek(xFilial("SB1")+	(cAliasLif)->UB_PRODUTO))
				aadd(_aCols03 ,{ 	(cAliasLif)->UB_ITEM ,; //01
				SB1->B1_COD		 		 ,;	//02   item
				substr(SB1->B1_DESC,1,30)	 ,;	//03   produto
				(cAliasLif)->UB_QUANT	 ,;	//04   descri��o
				(cAliasLif)->UB_VRUNIT	 ,;
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
|Descri��o |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | xGATPROD                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Hist�rico....................................|
\====================================================================================*/
*-----------------------------*
User Function zGATPROD()
	*-----------------------------*
	Local _lret := .F.
	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))
	If SB1->(DbSeek(xFilial("SB1")+M->XX_COD))//oGetDados1:acols[n,2]))
		_lret:= .T.
		
		oGetDados1:acols[n,3]:= Alltrim(SB1->B1_DESC)
	Else
		MsgInfo("Produto n�o Localizado!!!!")
	EndIf
	oGetDados1:Refresh()
	oLbx:Refresh()
	oDlg:Refresh()
Return(_lret)

/*====================================================================================\
|Programa  | LimpSt           | Autor | GIOVANI.ZAGO             | Data | 10/07/2014  |
|=====================================================================================|
|Descri��o |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | LimpSt                                                                   |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Hist�rico....................................|
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
|Descri��o |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | CarrEstru                                                                |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Hist�rico....................................|
\====================================================================================*/
*-----------------------------*
Static Function CarrEstru()
	*-----------------------------*
	Local b := 0
	
	
	If !Empty(Alltrim(_cVetor)) .And. SCJ->CJ_STATUS <> 'X'
		U__fGrStru(_cVetor)
	Elseif SCJ->CJ_STATUS = 'X'
		MsgInfo("Or�amenrto Liberado p/ Vendas...!!!!")
	EndIf
	
Return()





