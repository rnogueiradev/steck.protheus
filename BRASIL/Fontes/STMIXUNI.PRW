#include 'Protheus.ch'
#include 'RwMake.ch'
#Define CR chr(13)+chr(10)
/*====================================================================================\
|Programa  | STMIXUNI         | Autor | GIOVANI.ZAGO             | Data | 09/09/2014  |
|=====================================================================================|
|Descrição |   STMIXUNI    Pesquisa Estrutura	                                      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STMIXUNI                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function STMIXUNI()   //  u_STMIXUNI()
	*-----------------------------*
	//-- Dimensoes padroes
	Local aSize     := MsAdvSize(, .F., 400)
	Local aInfo 	:= {aSize[1],aSize[2],aSize[3],aSize[4]-12, 1, 1 }
	Local aObjects 	:= {{100, 100,.T.,.T. }}
	Local aPosObj 	:= MsObjSize( aInfo, aObjects,.T. )
	Local nStyle 	:= GD_UPDATE
	Local nOpca		:= 0
	Local acpos		:= {"PP8_PRORC"}
	Local acpos2		:= {"CJ_SEGURO"}
	Local aButtons	:= {}
	//If !IsInCallSteck("U_STFTA001")
	//	aAdd(aButtons,{"PMSSETAUP"  	,{|| CarrEstru()}		,"Carrega Estrutura"		,"Carrega Estrutura"})
	//EndIf
	Private cCadastro := "MIX UNICON"
	Private oDlg
	Private oGetDados1
	Private oGetDados2
	Private oGetDados3
	Private _a01Header := {}
	Private _aCols01   := {}
	Private _aColsX    := {}
	Private _aColsX2   := {}
	Private _a02Header := {}
	Private _aCols02   := {}
	Private _a03Header := {}
	Private _aCols03   := {}
	Private oLbx
	Private aVetor     := {}
	Private oOk	   	   := LoadBitmap( GetResources(), "LBOK" )
	Private oNo	   	   := LoadBitmap( GetResources(), "LBNO" )
	Private oChk1
	Private lChk1 	   := .f.
	Private oChk2
	Private lChk2 	   := .t.
	Private oChk3
	Private lChk3 	   := .t.
	Private oChk4
	Private lChk4 	   := .f.
	Private oChk5
	Private lChk5 	   := .f.
	Private oChk6
	Private lChk6 	   := .f.
	Private _xMargem   := 0
	Private _xTerceiro := 0
	Private _cPesq	   := Space(15)
	Private _oPesq
	Private _cVetor	   := ''
	Define FONT oFontN  NAME "Arial"
	Define FONT oFontB  NAME "Arial" BOLD
	Private oFontN  	:= TFont():New("Arial",9,15,.T.,.T.,5,.T.,5,.T.,.F.)
	Private oFontB 	    := TFont():New("Arial",9,50,.T.,.T.,5,.T.,5,.T.,.F.)
	Private bChange 	:= {||U_STMIXEDIT('2')}
	Private oTotal
	Private _nTotal   := 0
	Private oTotal2
	Private _nTotal2   := 0
	Private oCusto
	Private _nCusto   := 0
	Private  oNet
	Private _nNet  := 0
	Private oFecha
	Private _nFecha		:= 0
	Private oReajus
	Private _nReajus := 0
	Private oMargem
	Private _nMargem := 0
	Private oMarGer
	Private _nMarGer := 0
	Private oMarkup
	Private _nMarkup := 0
	Private _nMnet    := 0
	Private _nMcus 	  := 0
	Private oUnit
	Private _nUnit 	:= 0
	Private oUnImp
	Private _nUnImp := 0
	Private _nAvetor := 0
	Private _nAvex := 1
	ST_a01Header()
	ST_a02Header()

	_xMargem 	  	:=  Iif( SCJ->CJ_XMARGEM = 0,0,(1+(SCJ->CJ_XMARGEM/100)) )
	_xTerceiro  	:=  Iif( SCJ->CJ_XPRCTER = 0,0,(1+(SCJ->CJ_XPRCTER/100)) )

	Processa( {|| ST_aVetor() }, "Aguarde...", "Carregando Unicon...",.F.)

	_aCols01:={}
	aadd(_aCols01,{0,Space(10),Space(15),Space(45),0,0,0,0,0,0,0,'',.F.})

	Define MSDialog oDlg Title cCadastro From aSize[7],000 To aSize[6],aSize[5] of GetWndDefault() Pixel

	@ 031,001 listbox oLbx fields header " ", 'Codigo',"Item","Descrição","Quant."  size  aPosObj[1,4]/4-10 , aPosObj[1,3]/2-30  pixel of oDlg on dbLclick(U_STMIXEDIT('1'))

	oLbx:SetArray( aVetor )

	oLbx:bLine := {|| {Iif(	aVetor[oLbx:nAt,1],oOk,oNo),;
	aVetor[oLbx:nAt,2],;
	aVetor[oLbx:nAt,3],;
	aVetor[oLbx:nAt,4],;
	aVetor[oLbx:nAt,5];
	}}
	@  aPosObj[1,3]/2 +5,5  CHECKBOX oChk1 VAR lChk1 PROMPT "Marca/Desmarca Todos" SIZE 70,7 	PIXEL OF oDlg ON CLICK( aEval( aVetor, {|x| x[1] := lChk1 } ),U_STMIXEDIT('3'),oLbx:Refresh() ) //"Marca/Desmarca Todos"

	@  aPosObj[1,3]/2 +2,100   CHECKBOX oChk2 VAR lChk2 PROMPT "Prod.STECK"     SIZE 70,7 	PIXEL OF oDlg ON CLICK( U_STMIXEDIT('3'),oLbx:Refresh() ) //"Marca/Desmarca Todos"
	@  aPosObj[1,3]/2 +10,100  CHECKBOX oChk3 VAR lChk3 PROMPT "Prod.Terceiros" SIZE 70,7 	PIXEL OF oDlg ON CLICK( U_STMIXEDIT('3'),oLbx:Refresh() ) //"Marca/Desmarca Todos"
	@  aPosObj[1,3]/2 +19,100  CHECKBOX oChk4 VAR lChk4 PROMPT "Itens Vlr. 0"   SIZE 70,7 	PIXEL OF oDlg ON CLICK( U_STMIXEDIT('3'),oLbx:Refresh() ) //"Marca/Desmarca Todos"
	@  aPosObj[1,3]/2 +27,100  CHECKBOX oChk5 VAR lChk5 PROMPT "Itens Vlr. 0,01"   SIZE 70,7 	PIXEL OF oDlg ON CLICK( U_STMIXEDIT('3'),oLbx:Refresh() ) //"Marca/Desmarca Todos"
	@  aPosObj[1,3]/2 +35,100  CHECKBOX oChk6 VAR lChk6 PROMPT "Custo 0"   SIZE 70,7 	PIXEL OF oDlg ON CLICK( U_STMIXEDIT('3'),oLbx:Refresh() ) //"Marca/Desmarca Todos"


	oGetDados1 := MsNewGetDados():New( 31	,aPosObj[1,4]/4-9	, aPosObj[1,3]-90 	,aPosObj[1,4]+5	,nStyle	,"AllWaysTrue","AllWaysTrue", ,acpos,/*freeze*/,999, ,/*superdel*/,/*delok*/,oDlg,_a01Header,_aCols01,/*bChange*/ )
	oGetDados2 := MsNewGetDados():New( aPosObj[1,3]/2 +42 ,01	,aPosObj[1,3]+12	,aPosObj[1,4]/4-9 ,nStyle,"AllWaysTrue","AllWaysTrue",,acpos2,/*freeze*/,999,/*fieldok*/,/*superdel*/,/*delok*/,oDlg,_a02Header,_aCols02)

	oGetDados1:oBrowse:Refresh()
	oGetDados2:oBrowse:Refresh()

	@ aPosObj[1,3]-89,aPosObj[1,4]/4 say "Reajuste"  PIXEL FONT oFontN OF  oDlg
	@ aPosObj[1,3]-82,aPosObj[1,4]/4 msget  oReajus  Var _nReajus picture "@E 999.999999" when .t. size 55,013  valid  U_STMIXEDIT('5') 	 Of odlg Pixel

	@ aPosObj[1,3]-89,aPosObj[1,4]/4+80 say "Total"   PIXEL FONT oFontN OF  oDlg
	@ aPosObj[1,3]-82,aPosObj[1,4]/4+80 msget  oTotal Var _nTotal picture "@E 999,999,999.99" when .f. size 55,013 	 Of odlg Pixel

	@ aPosObj[1,3]-89,aPosObj[1,4]/4+170 say "Total c\Imposto"   PIXEL FONT oFontN OF  oDlg
	@ aPosObj[1,3]-82,aPosObj[1,4]/4+170 msget  oTotal2 Var _nTotal2 picture "@E 999,999,999.99" when .f. size 55,013 	 Of odlg Pixel

	@ aPosObj[1,3]-89,aPosObj[1,4]/4+260 say "Custo"   PIXEL FONT oFontN OF  oDlg
	@ aPosObj[1,3]-82,aPosObj[1,4]/4+260 msget  oCusto Var _nCusto picture "@E 999,999,999.99" when .f. size 55,013 	 Of odlg Pixel

	@ aPosObj[1,3]-89,aPosObj[1,4]/4+350 say "Net"  PIXEL FONT oFontN OF  oDlg
	@ aPosObj[1,3]-82,aPosObj[1,4]/4+350 msget  oNet Var _nNet picture "@E 999,999,999.99" when .f. size 55,013 	 Of odlg Pixel

	@ aPosObj[1,3]-64,aPosObj[1,4]/4 say "Margem"  PIXEL FONT oFontN OF  oDlg
	@ aPosObj[1,3]-57,aPosObj[1,4]/4 msget  oMargem  Var _nMargem picture "@E 999.99" when .t. size 55,013  valid  U_STMIXEDIT('5') 	 Of odlg Pixel

	@ aPosObj[1,3]-64,aPosObj[1,4]/4+80 say "Margem Geral"   PIXEL FONT oFontN OF  oDlg
	@ aPosObj[1,3]-57,aPosObj[1,4]/4+80 msget  oMarger Var _nMarger picture "@E 999,999,999.99" when .f. size 55,013 	 Of odlg Pixel

	@ aPosObj[1,3]-64,aPosObj[1,4]/4+170 say "Markup%(Steck)"   PIXEL FONT oFontN OF  oDlg
	@ aPosObj[1,3]-57,aPosObj[1,4]/4+170 msget  oMarkup Var _nMarkup picture "@E 999,999,999.99" when .f. size 55,013 	 Of odlg Pixel

	@ aPosObj[1,3]-64,aPosObj[1,4]/4+260 say "Total Unit."   PIXEL FONT oFontN OF  oDlg
	@ aPosObj[1,3]-57,aPosObj[1,4]/4+260 msget  oUnit Var _nUnit picture "@E 999,999,999.99" when .f. size 55,013 	 Of odlg Pixel

	@ aPosObj[1,3]-64,aPosObj[1,4]/4+350 say "Tot.Unit.c/Impos."  PIXEL FONT oFontN OF  oDlg
	@ aPosObj[1,3]-57,aPosObj[1,4]/4+350 msget  oUnImp Var _nUnImp picture "@E 999,999,999.99" when .f. size 55,013 	 Of odlg Pixel

	@ aPosObj[1,3]-39,aPosObj[1,4]/4 say "Valor Fechado"  PIXEL FONT oFontN OF  oDlg
	@ aPosObj[1,3]-32,aPosObj[1,4]/4 msget  oFecha  Var _nFecha picture "@E 999,999,999.99" when .t. size 55,013  valid  U_STMIXEDIT('4') 	 Of odlg Pixel

	aAdd(aButtons,{"PMSSETAUP",{|| EXPORTAR()},"Exportar","Exportar"})

	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| nOpca := 1,oDlg:End() },{||oDlg:End()},,aButtons)

	// se a opcao for encerrar executa a rotina.
	If nOpca == 1
		Processa( {|| STGRVMIX() }, "Aguarde...", "Gravando Unicon...",.F.)

	EndIf

	Return

	/*====================================================================================\
	|Programa  | STMIXEDIT          | Autor | GIOVANI.ZAGO           | Data | 10/07/2014  |
	|=====================================================================================|
	|Descrição |                                                                          |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | STMIXEDIT                                                                |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/
	*-----------------------------*
User Function STMIXEDIT(_cEdit)
	*-----------------------------*
	Local _ng  		:= 0
	Local _n02  	:= 0
	Local _cAdd 	:= ' '
	Local cAliasLif := 'TMPB3'
	Local cQuery    := ' '
	Local lMark    	:= .F.
	Local _cSoma  	:= '01'
	Local _nToAcol  := 0
	Local _nNetx	    :=0
	Local _nMao	    :=0
	Local g	    :=0
	Local h	    :=0
	Local i	    :=0
	If _cEdit = '5'
		_nFecha := 0
	EndIf

	If _cEdit = '4'
		For g:=1 To Len(_aCols01)
			_ng := Ascan(aVetor,{|x|  x[2]+x[3] == substr(_aCols01[g,2],1,6)+substr(_aCols01[g,2],8,3)})

			If _ng > 0
				_nToAcol+= ((_aCols01[g,5]*_aCols01[g,8]) * aVetor[_ng,5] )
			EndIf
		Next g


		If _nFecha <> 0
			_nReajus:=(((_nFecha)*100)/(_nToAcol+_nMao))-100
		Else
			_nReajus:=0
		EndIf
	EndIf


	//atualiza acolsX
	For g:=1 To Len(_aCols02)
		_ng := Ascan(_aColsX2,{|x|  x[1] ==_aCols02[g,1]})

		If _ng > 0
			If  _cEdit = '6' .And. oGetDados2:nAt = _ng
				_aColsX2 [_ng,3] := M->CJ_SEGURO
			Else
				_aColsX2 [_ng,3] := _aCols02[g,3]
			EndIf

		EndIf
	Next g

	For g:=1 To Len(_aCols01)
		_ng := Ascan(_aColsX,{|x|  x[1] ==_aCols01[g,1]})

		If _ng > 0
			_aColsX [_ng,6] := _aCols01[g,5]
			_aColsX [_ng,7] := _aCols01[g,6]
			_aColsX [_ng,8] := _aCols01[g,7]
			If 	_cEdit = '2' .And. oGetDados1:nAt = _ng
				_aColsX [_ng,9] :=   M->PP8_PRORC // * Iif( _cEdit = '4' .And. _nReajus <> 0, Iif( _nReajus = 0,1,(1+(_nReajus/100)) ),  Iif(_aColsX [_ng,14] = 'S' ,  Iif( _nReajus = 0,1,(1+(_nReajus/100)) ) ,Iif( _nMargem = 0,1,(1+(_nMargem/100)) ) ) )
				_aColsX [_ng,7] :=	_aColsX [_ng,9]
				_aColsX [_ng,8] := Round(	_aColsX [_ng,7]*_aColsX [_ng,6],2)
				_aColsX [_ng,11] := _aCols01[g,10]
			Else
				_aColsX [_ng,9] := _aCols01[g,8]
				_aColsX [_ng,7] := _aColsX [_ng,9]*Iif( _cEdit = '4' .And. _nReajus <> 0, Iif( _nReajus = 0,1,(1+(_nReajus/100)) ),  Iif(_aColsX [_ng,14] = 'S' ,  Iif( _nReajus = 0,1,(1+(_nReajus/100)) ) ,Iif( _nMargem = 0,1,(1+(_nMargem/100)) ) ) )
				_aColsX [_ng,8] := Round(	_aColsX [_ng,7]*_aColsX [_ng,6],2)
				_aColsX [_ng,11] :=_aColsX [_ng,16]*Iif( _cEdit = '4' .And. _nReajus <> 0, Iif( _nReajus = 0,1,(1+(_nReajus/100)) ),  Iif(_aColsX [_ng,14] = 'S' ,  Iif( _nReajus = 0,1,(1+(_nReajus/100)) ) ,Iif( _nMargem = 0,1,(1+(_nMargem/100)) ) ) )

			EndIf


			_aColsX [_ng,10] := _aCols01[g,9]
			_aColsX [_ng,12] := _aColsX [_ng,11]/_aColsX [_ng,10]
		EndIf

	Next g
	If lChk4   .And. _cEdit = '2'
		return(.t.)
	EndIf
	If lChk5  .And. _cEdit = '2'
		return(.t.)
	EndIf
	If lChk6  .And. _cEdit = '2'
		return(.t.)
	EndIf
	_aCols01:={}
	_aCols02:={}
	If _cEdit = '1'
		aVetor[oLbx:nAt,1]	:= !aVetor[oLbx:nAt,1]
	EndIf
	_nTotal   := 0
	_nTotal2  := 0
	_nCusto   := 0
	_nNet     := 0
	_nMao     := 0
	_nMarkup  := 0
	_nMarger  := 0
	_nMnet    := 0
	_nMcus 	  := 0
	_nUnit 	  := 0
	_nUnImp   := 0
	_nAvetor  := 0
	_nAvex    := 1
	For i:=1 To Len(aVetor)
		If aVetor[i,1]
			_nAvetor++

			For h:=1 To Len(_aColsX)
				If aVetor[i,02]  = _aColsX[h,02]  .And. aVetor[i,03]  = _aColsX[h,03]
					If (_aColsX[h,14] = 'M' .And. lChk3 .Or. _aColsX[h,14] = 'S' .And. lChk2)
						If    (	!lChk4  .Or. lChk4 .And. 	_aColsX[h,09] = 0)
							If    (	!lChk5  .Or. lChk5 .And. 	_aColsX[h,09] = 0.01)
								If    (	!lChk6  .Or. lChk6.And. 	_aColsX[h,10] = 0)
									aadd(_aCols01,{  _aColsX[h,01],;
									_aColsX[h,02]+'/'+_aColsX[h,03],;
									_aColsX[h,04],;
									_aColsX[h,05],;
									_aColsX[h,06],;
									_aColsX[h,07],;
									_aColsX[h,08],;
									_aColsX[h,09],;
									_aColsX[h,10],;
									_aColsX[h,11],;
									_aColsX[h,12],;
									.F. })

									_cTesx:=	_aColsX[h,13]
									_nTotal   +=   aVetor[i,5]* _aColsX[h,08]
									_nCusto   +=  (aVetor[i,5]* (_aColsX[h,06]*_aColsX[h,10]))
									_nNet     +=  (aVetor[i,5]* (_aColsX[h,06]*_aColsX[h,11]))
									_nAvex		:=aVetor[i,5]
									If _aColsX[h,14] = 'S'
										_nMnet += (aVetor[i,5]* (_aColsX[h,06]*_aColsX[h,11]))
										_nMcus += (aVetor[i,5]* (_aColsX[h,06]*_aColsX[h,10]))
									EndIf
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
			Next h

			For h:=1 To Len(_aColsX2)
				If aVetor[i,02]+'/'+aVetor[i,03]  = _aColsX2[h,01]
					aadd(_aCols02,{  _aColsX2[h,01],;
					_aColsX2[h,02],;
					_aColsX2[h,03],;
					.F. })
					_nMao+=	(_aColsX2[h,03]*aVetor[i,05])
				EndIf
			Next h

		EndIf
	Next i

	If _nTotal <> 0
		_nMarkup   := _nMnet/_nMcus
		_nMarger   := _nNet/_nCusto
		_nTotal:= _nTotal+Iif(_nFecha=0,_nMao,0)
		_nTotal2 :=U_STMAFISUNI(_nTotal,_cTesx)
		If _nAvetor = 1
			_nUnImp  := _nTotal2/_nAvex
			_nUnit   := _nTotal/_nAvex
		EndIf
	EndIf

	If len(_aCols01) = 0
		aadd(_aCols01,{0,Space(10),Space(15),Space(45),0,0,0,0,0,0,0,'',.F.})
	EndIf
	If len(_aCols02) = 0
		aadd(_aCols02,{' ',Space(15),0,.F.})
	EndIf
	oGetDados1:Acols:=_aCols01
	oGetDados2:Acols:=_aCols02

	oLbx:Refresh()
	oDlg:Refresh()
	oGetDados1:Refresh()
	oGetDados1:oBrowse:Refresh()
	oGetDados2:Refresh()
	oGetDados2:oBrowse:Refresh()
	oTotal:Refresh()
	oTotal2:Refresh()
	oCusto:Refresh()
	oNet:Refresh()
	oMargem:Refresh()
	oReajus:Refresh()
	oMarger:Refresh()
	oMarkup:Refresh()
	oUnit:Refresh()
	oUnImp:Refresh()


	Return (.T.)

	/*====================================================================================\
	|Programa  | ST_aVetor        | Autor | GIOVANI.ZAGO             | Data | 10/07/2014  |
	|=====================================================================================|
	|Descrição |                                                                          |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | ST_aVetor                                                                |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/
	*-----------------------------*
Static Function ST_aVetor()
	*-----------------------------*
	Local _nX:= 0
	Local _nCoun:= 0
	Local _cCusMix := ' '
	Local _cTesMix := ' '
	Local _nNet:= 0

	aVetor:= {}
	Dbselectarea("PP8")
	PP8->(Dbsetorder(1))
	PP8->(DbSeek(xfilial("PP8")+PP7->PP7_CODIGO))
	Do While PP8->(!eof())  .And. PP7->PP7_CODIGO == PP8->PP8_CODIGO
		_nCoun++
		PP8->(Dbskip())
	Enddo
	ProcRegua(_nCoun+1) // Numero de registros a processar
	IncProc("Aguarde")
	Dbselectarea("PP8")
	PP8->(DbGoTop())
	PP8->(Dbsetorder(1))
	PP8->(DbSeek(xfilial("PP8")+PP7->PP7_CODIGO))
	Do While PP8->(!eof())  .And. PP7->PP7_CODIGO == PP8->PP8_CODIGO
		aadd(aVetor,{.f.,PP8->PP8_CODIGO,alltrim(PP8->PP8_ITEM),SUBSTR(PP8->PP8_DESCR,1,15),PP8->PP8_QUANT,PP8->PP8_NUMORC})

		IncProc("Carregando Unicon: "+PP8->PP8_CODIGO+"  Item: "+PP8->PP8_ITEM+"/"+StrZero(_nCoun,3))

		Dbselectarea('SCJ')
		SCK->(dbsetorder(1))
		Dbseek(xfilial("SCJ") + PP8->PP8_NUMORC )
		aadd(_aColsX2,{PP8->PP8_CODIGO+"/"+alltrim(PP8->PP8_ITEM),SUBSTR(PP8->PP8_DESCR,1,15),SCJ->CJ_XVLRMOD,.f.})
		Dbselectarea('SCK')
		SCK->(dbsetorder(1))
		SCK->(Dbseek(xfilial("SCK") + PP8->PP8_NUMORC ))

		_nReajus 	  :=    SCJ->CJ_XMARGEM
		_nMargem      :=    SCJ->CJ_XPRCTER
		Do while SCK->(!eof()) .And. PP8->PP8_NUMORC == SCK->CK_NUM
			_nX++

			_cTesMix :=	U_STRETSST('01',PP7->PP7_CLIENT,PP7->PP7_LOJA ,ALLTRIM(SCK->CK_PRODUTO) ,PP7->PP7_CPAG  ,'TES')
			//-------------------------------------------------------------------------------------------------------------------
			// Alterado por Richard 19/10/17 - Para corrigir o erro no gatilho.
			// Caso a funcao U_STRETSST nao retorne a TES, uso a TES do SCK (CK_TES)
			// Como as funcoes STRETSST e STTESINTELIGENTE sao usadas em varias rotinas, preferi nao mexer nelas.
			//-------------------------------------------------------------------------------------------------------------------
			If Empty(_cTesMix)
				_cTesMix := SCK->CK_TES
			EndIf
			_cCusMix :=	U_STCUSTO(SCK->CK_PRODUTO)
			_nNet:=	STLiq(		SCK->CK_PRCVEN,SCK->CK_PRODUTO,SCK->CK_QTDVEN,_cTesMix)
			aadd(_aColsX,{ _nX,;            //01 SEQ.
			PP8->PP8_CODIGO,;               //02 CODIGO UNICON
			PP8->PP8_ITEM,;                 //03 IITEM
			SCK->CK_PRODUTO,;               //04 PRODUTO
			SUBSTR(SCK->CK_DESCRI,1,25),;   //05 DESCRIÇÃO
			SCK->CK_QTDVEN,;      			//06 QUANTIDADE
			SCK->CK_PRCVEN* Iif(SCK->CK_XTP_PRD = 'S' ,  Iif( _nReajus = 0,1,(1+(_nReajus/100)) ) ,Iif( _nMargem = 0,1,(1+(_nMargem/100)) )) ,;                //07 PREÇO
			(	SCK->CK_PRCVEN *Iif(SCK->CK_XTP_PRD = 'S' ,  Iif( _nReajus = 0,1,(1+(_nReajus/100)) ) ,Iif( _nMargem = 0,1,(1+(_nMargem/100) ) )) )*SCK->CK_QTDVEN,; //08 TOTAL PREÇO * QUANTIDADE
			SCK->CK_PRCVEN,;   				//09 PREÇO
			_cCusMix,;      				//10 CUSTO
			_nNet,;         				//11 NET
			_nNet/_cCusMix,;      			//12 MARKUP
			_cTesMix,;   					//13 TES
			SCK->CK_XTP_PRD,;				//14 TIPO S=STECK;M=MERCADO
			SCK->(RECNO()) ,;			    //15 RECNO
			_nNet	}) 						//16 NET
			SCK->(Dbskip())

		Enddo

		PP8->(Dbskip())
	Enddo


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
	aAdd(_a01Header,{"Seq."			,"XX_SEQ"	,"@E 9999",4,0,"","€€€€€€€€€€€€€€€","N","","","","",".T."})
	aAdd(_a01Header,{"Codigo/Item"	,"XX_ITEM"	,"@!",3					,0,"","€€€€€€€€€€€€€€€","C","","","","",".T."})
	aAdd(_a01Header,{"Produto"		,"XX_COD"	,"@!",TamSx3("D2_COD")[1]	,0,"","€€€€€€€€€€€€€€€","C","","","","",".T."})
	aAdd(_a01Header,{"Descricao"	,"XX_DESC"	,"@!",25	,0,"","€€€€€€€€€€€€€€€","C","","","","",".T."})
	aAdd(_a01Header,{"Qtd."			,"XX_QTDD2"	,"@E 999,999.99",TamSx3("D2_QUANT")[1],TamSx3("D2_QUANT")[2],"","€€€€€€€€€€€€€€€","N","","","","",".T."})
	aAdd(_a01Header,{"Prc.Final"	,"XX_01"	,"@E 999,999.99",TamSx3("D2_QUANT")[1],TamSx3("D2_QUANT")[2],"","€€€€€€€€€€€€€€€","N","","","","",".T."})
	aAdd(_a01Header,{"Prc.Total"	,"XX_02"	,"@E 999,999.99",TamSx3("D2_QUANT")[1],TamSx3("D2_QUANT")[2],"","€€€€€€€€€€€€€€€","N","","","","",".T."})
	aAdd(_a01Header,{"Prc.Base"		,"PP8_PRORC","@E 999,999.99",TamSx3("D2_QUANT")[1],TamSx3("D2_QUANT")[2],"","€€€€€€€€€€€€€€€","N","","","","",".T."})
	aAdd(_a01Header,{"Custo"		,"XX_04"	,"@E 999,999.99",TamSx3("D2_QUANT")[1],TamSx3("D2_QUANT")[2],"","€€€€€€€€€€€€€€€","N","","","","",".T."})
	aAdd(_a01Header,{"Net"			,"XX_05"	,"@E 999,999.99",TamSx3("D2_QUANT")[1],TamSx3("D2_QUANT")[2],"","€€€€€€€€€€€€€€€","N","","","","",".T."})
	aAdd(_a01Header,{"Markup"		,"XX_06"	,"@E 999,999.99",TamSx3("D2_QUANT")[1],TamSx3("D2_QUANT")[2],"","€€€€€€€€€€€€€€€","N","","","","",".T."})

	//"Prc.Final","Prc.Total","Prc.Base","Custo","Net","Markup","."
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
	aAdd(_a02Header,{"Codigo/Item"	,"XX_ITEM"	,"@!",3			,0,"","€€€€€€€€€€€€€€€","C","","","","",".T."})
	aAdd(_a02Header,{"Descricao"	,"XX_DESC"	,"@!",15		,0,"","€€€€€€€€€€€€€€€","C","","","","",".T."})
	aAdd(_a02Header,{"Vlr.Montagem"	,"CJ_SEGURO","@E 999,999.99",TamSx3("D2_QUANT")[1],TamSx3("D2_QUANT")[2],"","€€€€€€€€€€€€€€€","N","","","","",".T."})

Return()

STATIC Function STLiq(_nValor,_cProduto,_nQuant,_cTesA)
	Local   nValCmp , nValDif 							:= 0

	default _cProduto := SuperGetMv("ST_PRDUNIC",,"SUNICOM")
	default _nQuant :=1

	DbSelectArea("SA1")
	SA1->(dbSetOrder(1))
	SA1->(dbseek(xfilial("SA1")+PP7->PP7_CLIENTE+PP7->PP7_LOJA))
	C5_TIPOCLI := SA1->A1_TIPO
	_cTipoCli:= SA1->A1_TIPO
	_cTipoCF := 'C'


	dbSelectArea("SB1")
	dbSetOrder(1)
	DbSeek(xFilial("SB1")+_cProduto)

	_nIcms    	:= SA1->A1_CONTRIB
	_cEst		:= SA1->A1_EST

	//_cTes:=U_STRETSST('01',SA1->A1_COD,SA1->A1_LOJA ,_cProduto,PP7->PP7_CPAG  ,'TES')	// u_LcStOper()

	MaFisSave()
	MaFisEnd()
	MaFisIni(SA1->A1_COD,;	// 1-Codigo Cliente/Fornecedor
	SA1->A1_LOJA ,;			// 2-Loja do Cliente/Fornecedor
	"C",;					// 3-C:Cliente , F:Fornecedor
	"N",;					// 4-Tipo da NF
	SA1->A1_TIPO,;			// 5-Tipo do Cliente/Fornecedor
	Nil,;
	Nil,;
	Nil,;
	Nil,;
	"MATA461")                                                               // 10-Nome da rotina que esta utilizando a funcao

	MaFisAdd(_cProduto,;                                               // 1-Codigo do Produto ( Obrigatorio )
	_cTesA,;                                                            // 2-Codigo do TES ( Opcional )
	_nQuant,;                                                          // 3-Quantidade ( Obrigatorio )
	_nValor,;                                                         // 4-Preco Unitario ( Obrigatorio )
	0,;                														 // 5-Valor do Desconto ( Opcional )
	,;                                                                       // 6-Numero da NF Original ( Devolucao/Benef )
	,;                                                                       // 7-Serie da NF Original ( Devolucao/Benef )
	,;                                                                       // 8-RecNo da NF Original no arq SD1/SD2
	0,;                                                                      // 9-Valor do Frete do Item ( Opcional )
	0,;                                                                      // 10-Valor da Despesa do item ( Opcional )
	0,;                                                                      // 11-Valor do Seguro do item ( Opcional )
	0,;                                                                      // 12-Valor do Frete Autonomo ( Opcional )
	_nValor,;														 // 13-Valor da Mercadoria ( Obrigatorio )
	0,;                                                                      // 14-Valor da Embalagem ( Opiconal )
	0,;                                                                      // 15-RecNo do SB1
	0)                                                                       // 16-RecNo do SF4

	nAliqICM 	:= (MaFisRet(1,'IT_ALIQICM',5,2)  )    //Aliquota do ICMS
	nValICms	:= (MaFisRet(1,'IT_VALICM',14,2)  )    //Valor do ICMS

	nAliqIPI 	:= (MaFisRet(1,"IT_ALIQIPI",5,2)  )    //Aliqutota do IPI
	nValIPI 	:= (MaFisRet(1,"IT_VALIPI",14,2)  )    //Valor do IPI

	nValICMSST 	:= (MaFisRet(1,'IT_VALSOL',14,2)  )    //Valor do ICMS-ST

	nValPis		:= (MaFisRet(1,"IT_VALPS2",14,2)  )    //Valor do PIS
	nValCof		:= (MaFisRet(1,"IT_VALCF2",14,2)  )    //Valor do COFINS

	//DIFAL
	nValCmp 	:= noround(MaFisRet(1,"IT_VALCMP",14,2)  )
	nValDif 	:= noround(MaFisRet(1,"IT_DIFAL",14,2)  )

	mafisend()

	_nValor -= (nValICms  + nValPis + nValCof + (nValCmp) + (nValDif))

Return(round(_nValor,2))



User Function STMISLIQ(_nValor,_cProduto,_nQuant,_nRec)

	Local _cTesA:= '501'
	Local  _ng  := 0
	Local   nValCmp , nValDif 							:= 0
	_ng := Ascan(_aColsX,{|x|  x[1] ==_nRec})

	If _ng > 0
		_cTesA:=	_aColsX [_ng,13]
	EndIf
	default _cProduto := SuperGetMv("ST_PRDUNIC",,"SUNICOM")
	default _nQuant :=1

	DbSelectArea("SA1")
	SA1->(dbSetOrder(1))
	SA1->(dbseek(xfilial("SA1")+PP7->PP7_CLIENTE+PP7->PP7_LOJA))
	C5_TIPOCLI := SA1->A1_TIPO
	_cTipoCli:= SA1->A1_TIPO
	_cTipoCF := 'C'


	dbSelectArea("SB1")
	dbSetOrder(1)
	DbSeek(xFilial("SB1")+_cProduto)

	_nIcms    	:= SA1->A1_CONTRIB
	_cEst		:= SA1->A1_EST

	// u_LcStOper()

	MaFisSave()
	MaFisEnd()
	MaFisIni(SA1->A1_COD,;	// 1-Codigo Cliente/Fornecedor
	SA1->A1_LOJA ,;			// 2-Loja do Cliente/Fornecedor
	"C",;					// 3-C:Cliente , F:Fornecedor
	"N",;					// 4-Tipo da NF
	SA1->A1_TIPO,;			// 5-Tipo do Cliente/Fornecedor
	Nil,;
	Nil,;
	Nil,;
	Nil,;
	"MATA461")                                                               // 10-Nome da rotina que esta utilizando a funcao

	MaFisAdd(_cProduto,;                                               // 1-Codigo do Produto ( Obrigatorio )
	_cTesA,;                                                            // 2-Codigo do TES ( Opcional )
	_nQuant,;                                                          // 3-Quantidade ( Obrigatorio )
	_nValor,;                                                         // 4-Preco Unitario ( Obrigatorio )
	0,;                														 // 5-Valor do Desconto ( Opcional )
	,;                                                                       // 6-Numero da NF Original ( Devolucao/Benef )
	,;                                                                       // 7-Serie da NF Original ( Devolucao/Benef )
	,;                                                                       // 8-RecNo da NF Original no arq SD1/SD2
	0,;                                                                      // 9-Valor do Frete do Item ( Opcional )
	0,;                                                                      // 10-Valor da Despesa do item ( Opcional )
	0,;                                                                      // 11-Valor do Seguro do item ( Opcional )
	0,;                                                                      // 12-Valor do Frete Autonomo ( Opcional )
	_nValor,;														 // 13-Valor da Mercadoria ( Obrigatorio )
	0,;                                                                      // 14-Valor da Embalagem ( Opiconal )
	0,;                                                                      // 15-RecNo do SB1
	0)                                                                       // 16-RecNo do SF4

	nAliqICM 	:= (MaFisRet(1,'IT_ALIQICM',5,2)  )    //Aliquota do ICMS
	nValICms	:= (MaFisRet(1,'IT_VALICM',14,2)  )    //Valor do ICMS

	nAliqIPI 	:= (MaFisRet(1,"IT_ALIQIPI",5,2)  )    //Aliqutota do IPI
	nValIPI 	:= (MaFisRet(1,"IT_VALIPI",14,2)  )    //Valor do IPI

	nValICMSST 	:= (MaFisRet(1,'IT_VALSOL',14,2)  )    //Valor do ICMS-ST

	nValPis		:= (MaFisRet(1,"IT_VALPS2",14,2)  )    //Valor do PIS
	nValCof		:= (MaFisRet(1,"IT_VALCF2",14,2)  )    //Valor do COFINS

	//DIFAL
	nValCmp 	:= noround(MaFisRet(1,"IT_VALCMP",14,2)  )
	nValDif 	:= noround(MaFisRet(1,"IT_DIFAL",14,2)  )

	mafisend()

	_nValor -= (nValICms  + nValPis + nValCof + nValCmp + nValDif)

Return(round(_nValor,2))



Static Function STGRVMIX()

	Local _nCoun  := 0
	Local _nToSck := 0
	Local _nMao   := 0
	Local g	    :=0
	Local h	    :=0
	Local i	    :=0

	For i:=1 To Len(aVetor)
		If aVetor[i,1]
			_nCoun++
		EndIf
	Next i
	ProcRegua(_nCoun+1) // Numero de registros a processar
	IncProc("Aguarde")

	For i:=1 To Len(aVetor)
		If aVetor[i,1]
			IncProc("Gravando Unicon:"+aVetor[i,02]+"  Item:"+aVetor[i,03]+"/"+cvaltochar(_nCoun))
			_nToSck:=0
			For h:=1 To Len(_aColsX)
				If aVetor[i,02]  = _aColsX[h,02]  .And. aVetor[i,03]  = _aColsX[h,03]
					Dbselectarea('SCK')
					SCK->(dbGoTo(_aColsX[h,15] ))

					If 	SCK->(Recno()) == _aColsX[h,15]

						SCK->(RecLock("SCK",.F.))
						SCK->CK_VALOR  := _aColsX[h,09]
						SCK->CK_PRCVEN := _aColsX[h,09]
						SCK->CK_PRUNIT := _aColsX[h,09]
						SCK->(MsUnlock())
						SCK->( DbCommit() )

						_nToSck+=_aColsX[h,08]

					EndIf
				EndIf
			Next h
			Dbselectarea("PP8")
			PP8->(Dbsetorder(1))
			If PP8->(DbSeek(xfilial("PP8")+aVetor[i,02]+aVetor[i,03]))

				Dbselectarea('SCJ')
				SCJ->(dbsetorder(1))
				If 	Dbseek(xfilial("SCJ") + PP8->PP8_NUMORC )

					For h:=1 To Len(_aColsX2)
						If aVetor[i,02]+'/'+aVetor[i,03]  = _aColsX2[h,01]
							_nMao:=	_aColsX2[h,03]
						EndIf
					Next h

					PP8->(RecLock("PP8",.F.))
					PP8->PP8_PRORC :=  _nToSck +Iif(_nFecha=0,_nMao,0)
					PP8->(MsUnlock())
					PP8->( DbCommit() )

					SCJ->(RecLock("SCJ",.F.))
					SCJ->CJ_XPRCTER  := _nMargem
					SCJ->CJ_XMARGEM  := round(_nReajus,6)
					SCJ->CJ_XVLRMOD  := _nMao
					SCJ->(MsUnlock())
					SCJ->( DbCommit() )


				EndIf
			EndIf

		EndIf

	Next i
Return()

/*====================================================================================\
|Programa  | EXPORTAR        | Autor | RENATO.OLIVEIRA           | Data | 26/07/2019  |
|=====================================================================================|
|Descrição | Exportar valores para excel			                                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

Static Function EXPORTAR()

	Local aCabec		:= {}
	Local aDados		:= {}
	Local _nX

	aCabec := {"Seq.","Codigo/Item","Produto","Descricao","Qtd.","Prc.Final","Prc.Total","Prc.Base","Custo","Net","Markup"}

	For _nX:=1 To Len(_aCols01)
		AAdd(aDados, {;
		_aCols01[_nX][1],;
		_aCols01[_nX][2],;
		_aCols01[_nX][3],;
		_aCols01[_nX][4],;
		_aCols01[_nX][5],;
		_aCols01[_nX][6],;
		_aCols01[_nX][7],;
		_aCols01[_nX][8],;
		_aCols01[_nX][9],;
		_aCols01[_nX][10],;
		_aCols01[_nX][11];
		})
	Next
	
	DlgToExcel({ {"ARRAY", "ORÇAMENTO", aCabec, aDados} })

Return()