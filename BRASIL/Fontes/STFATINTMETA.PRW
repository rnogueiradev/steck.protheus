#include 'Protheus.ch'
#include 'RwMake.ch'

/*====================================================================================\
|Programa  | STFATINTMETA   | Autor | GIOVANI.ZAGO               | Data | 04/10/2013  |
|=====================================================================================|
|Descrição | Chama Tela de Cadastro   metas		 VENDEDOR INTERNO				      |
|          | 													                      |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STFATINTMETA                                                             |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*---------------------------------------------------*
User Function STFATINTMETA()
	*---------------------------------------------------*
	//     u_STFATMETA()
	Local aCamVend :={ 'ZZG';      //1
	,'ZZG_MES'		;              //2
	,'ZZG_ANO'		;              //3
	,'ZZG_VEND'  	;              //4
	,'ZZG_NVEND'  	;              //5
	,'ZZG_GRUPO'  	;              //6
	,'ZZG_NGRUPO'  	;              //7
	,'ZZG_FILIAL' 	;              //8
	,'ZZG_QTD'		;
		,'ZZG_VALOR'	;
		,'Cadastro de Meta'} //10
	
	U_zSTFATMETA(aCamVend)
	
Return


/*====================================================================================\
|Programa  | XSTFATMETA     | Autor | GIOVANI.ZAGO               | Data | 09/08/2013  |
|=====================================================================================|
|Descrição | Cria mBrowse 											                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | XSTFATMETA                                                               |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*---------------------------------------------------*
User Function zSTFATMETA(aCamVend)
	*---------------------------------------------------*
	
	Private cCadastro  := aCamVend[11]
	Private aRotina	   := MenuDef()
	Private cString    := aCamVend[1]
	Private cZZG2      := aCamVend[2]
	Private cZZG3      := aCamVend[3]
	Private cZZG4      := aCamVend[4]
	Private cZZG5      := aCamVend[5]
	Private cZZG6      := aCamVend[6]
	Private cZZG7      := aCamVend[7]
	Private cZZG8      := aCamVend[8]
	Private cZZG9      := aCamVend[9]
	Private cZZG10      := aCamVend[10]
	Private cZZG11      := aCamVend[11]
	(cString)->(DbSetOrder(1))
	
	mBrowse( 6,1,22,75,cString)
	
	RetIndex(cString)
	
Return NIL

/*====================================================================================\
|Programa  | ZZG080Manut    | Autor | GIOVANI.ZAGO               | Data | 09/08/2013  |
|=====================================================================================|
|Descrição | Manutenção do Menu										                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | ZZG080Manut                                                              |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*---------------------------------------------------*
User Function ZZG080Manut( cAlias, nReg, nOpcx )
	*---------------------------------------------------*
	
	Local aAreaAnt   := GetArea()
	Local nCntFor    := 0
	Local nOpca	     := 0
	
	Local aVisual    := {}
	Local cCampo     := ''
	Local nOrdem     := 0
	Local aObjects   := {}
	Local aPosObj    := {}
	Local aInfo	     := {}
	Local aSize	     := {}
	Local aNoFields  := {}
	Local cSeekDC6   := ''
	Local cWhile     := ''
	Local l080Visual := .F.
	Local l080Inclui := .F.
	Local l080Altera := .F.
	Local l080Deleta := .F.
	Local l080Copia  := .F.
	Local aCmpUser   := {}
	Local x := 0
	local lSaida   := .f.
	Private aTela[0][0],aGets[0]
	Private aHeader  := {}
	Private aCols    := {}
	Private aButtons    := {}
	Private oDlgEsp
	Private oget
	
	AAdd(aButtons, {"DBG06",{|| u_zSTreajuste() },"Reajuste" } )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define a funcao utilizada ( Incl.,Alt.,Visual.,Exclu.)  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nOpcx == 2
		l080Visual  := .T.
	ElseIf nOpcx == 3
		l080Inclui	:= .T.
	ElseIf nOpcx == 4
		l080Altera	:= .T.
	ElseIf nOpcx == 5
		l080Deleta	:= .T.
	ElseIf nOpcx == 6
		l080Copia   := .T.
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Configura variaveis da Enchoice                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea("SX3")
	DbSetOrder(1)
	SX3->(DbSeek(cString))
	While SX3->(!Eof() .And. (SX3->X3_ARQUIVO == cString))
		If	x3uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL
			cCampo := SX3->X3_CAMPO
			If	( SX3->X3_CONTEXT == "V"  .Or. Inclui )
				M->&(cCampo) := CriaVar(SX3->X3_CAMPO)
			Else
				M->&(cCampo) := (cString)->(FieldGet(FieldPos(SX3->X3_CAMPO)))
			EndIf
			If (AllTrim(SX3->X3_CAMPO)$ (cZZG2+"."+cZZG3))
				AAdd(aVisual,SX3->X3_CAMPO)
				If l080Copia
					M->&(cCampo) := Space(SX3->X3_TAMANHO)
				Endif
			EndIf
		EndIf
		//-- Acrescenta no array aCmpUser os campos criados pelo usuario.
		If SX3->X3_PROPRI == 'U' .And. SX3->X3_BROWSE <> 'S'
			AAdd(aCmpUser ,SX3->X3_CAMPO)
		EndIf
		SX3->(DbSkip())
	EndDo
	
	//-- Varre o array cCmpUser para definir se os campos de usuarios vao aparecer no aCols ou no aHeader.
	If	Len(aCmpUser) == 0
		AAdd(aVisual,"NOUSER")
	Else
		AEval(aCmpUser,{|x| AAdd(aNoFields,x)})
	EndIf
	AAdd(aVisual,"NOUSER")
	//-- Array contendo os campos que nao estarao no aHeader
	AAdd( aNoFields, cZZG2 )
	AAdd( aNoFields, cZZG3 )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montagem do AHEADER e ACOLS para GetDados  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If l080Inclui
		FillGetDados(nOpcx,cString,1,,,,aNoFields,,,,,.T.,,,)
	Else
		If l080Copia
			cSeekDC6 := xFilial(cString)+(cString)->(&cZZG2)+(cString)->(&cZZG3)
		Else
			cSeekDC6 := xFilial(cString)+M->&cZZG2+M->&cZZG3
		EndIf
		cWhile   := cString+'->'+cZZG8+'+'+cString+'->'+cZZG2+'+'+cString+'->'+cZZG3
		
		FillGetDados(nOpcx,cString,1,cSeekDC6,{|| &cWhile },,aNoFields,,,,,,,,,)
		nOrdem := aScan(aHeader,{|x| Trim(x[2])==(cZZG4)})
		aSort(aCols,,,{|x,y| x[nOrdem]<y[nOrdem]})
	EndIf
	
	//-- Dimensoes padroes
	aSize := MsAdvSize()
	AAdd( aObjects, { 100, 32, .T., .T. } )
	AAdd( aObjects, { 200, 200, .T., .T. } )
	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
	aPosObj := MsObjSize( aInfo, aObjects,.T.)
	
	Inclui := ((l080Inclui).Or.(l080Copia)) //-- Impede que a Descrição apaceca na inclusão de itens durante a alteracao
	
	DEFINE MSDIALOG oDlgEsp TITLE cCadastro FROM aSize[7],00 TO aSize[6],aSize[5] OF oMainWnd PIXEL
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta a Enchoice                                                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	EnChoice( cAlias, nReg, If(l080Copia, 3, nOpcx),,,,aVisual, aPosObj[1], , 3, , , , , ,.T. )
	//EnChoice( cAlias, nReg, nOpc,,,,aExibe,{013,001,217,315}, aAltera,,,,,,,.T. )
	MSGetDados():New(aPosObj[2,1], aPosObj[2,2] , aPosObj[2,3], aPosObj[2,4], If(l080Copia, 4, nOpcx),"U_ZZGLinOK", "U_ZZGTudOK", , !l080Visual,			 , ,    ,9999)
	//MsGetDados():New(05			 , 05			, 145		  , 195			, 4						 , "U_LINHAOK", "U_TUDOOK"	, "+A1_COD", .T.		, {"A1_NOME"}, , .F., 200, "U_FIELDOK", "U_SUPERDEL", , "U_DELOK", oDlg)
	ACTIVATE MSDIALOG oDlgEsp ON INIT EnchoiceBar(oDlgEsp	,{||If(u_ZZGTudOK(),(nOpca := 1,oDlgEsp:End()),nOpcA:=0)},{||nOpcA:=0,oDlgEsp:End()},,aButtons)
	
	If nOpca == 1 .And. !l080Visual
		If	nOpca == 1
			ZZGGrava(nOpcx)
		EndIf
	EndIf
	
	RestArea(aAreaAnt)
	
Return( nOpca )

/*====================================================================================\
|Programa  | ZZGGrava       | Autor | GIOVANI.ZAGO               | Data | 09/08/2013  |
|=====================================================================================|
|Descrição | Grava os Dados                                                           |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | ZZGGrava                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*---------------------------------------------------*
Static Function ZZGGrava(nOpcx)
	*---------------------------------------------------*
	
	Local nCntFor   := 0
	Local nCntFo1   := 0
	Local nPosCpo   := 0
	Local nItem     := 0
	Local n030Index :=(cString)->(IndexOrd())
	
	If	nOpcx == 5 			//Excluir
		(cString)->(DbSetOrder(1))
		While (cString)->(DbSeek(xFilial(cString) + M->&cZZG2+ M->&cZZG3 ))
			RecLock(cString,.F.)
			(cString)->(DbDelete())
			MsUnLock()
		EndDo
	EndIf
	
	If	nOpcx == 3 .Or. nOpcx == 4 .Or. nOpcx == 6 // Incluir, Alterar ou Copia
		Begin Transaction
			(cString)->(DbSetOrder(1))
			For nCntFor := 1 To Len(aCols)
				If	!aCols[nCntFor,Len(aCols[nCntFor])]
					(cString)->(DbGoTo(aCols[nCntFor,Ascan(aHeader,{|x| AllTrim(x[2])==('ZZG_REC_WT')})]))
					If	(cString)->(RECNO()) = aCols[nCntFor,Ascan(aHeader,{|x| AllTrim(x[2])==('ZZG_REC_WT')})]    .and. nOpcx <> 6
						RecLock(cString,.F.)
					Else
						RecLock(cString,.T.)
					EndIf
					(cString)->&cZZG8  := xFilial(cString)
					(cString)->&cZZG2  := SUBSTR(M->&cZZG2,1,2)
					(cString)->&cZZG3  := M->&cZZG3
					(cString)->&cZZG4  := aCols[nCntFor,Ascan(aHeader,{|x| AllTrim(x[2])==(cZZG4)})]
					(cString)->&cZZG5  := aCols[nCntFor,Ascan(aHeader,{|x| AllTrim(x[2])==(cZZG5)})]
					(cString)->&cZZG6  := aCols[nCntFor,Ascan(aHeader,{|x| AllTrim(x[2])==(cZZG6)})]
					(cString)->&cZZG7  := aCols[nCntFor,Ascan(aHeader,{|x| AllTrim(x[2])==(cZZG7)})]
					(cString)->&cZZG9  := aCols[nCntFor,Ascan(aHeader,{|x| AllTrim(x[2])==(cZZG9)})]
					(cString)->&cZZG10 := aCols[nCntFor,Ascan(aHeader,{|x| AllTrim(x[2])==(cZZG10)})]
					
					
					
					
					MsUnLock()
					DbCommit()
				Else
					(cString)->(DbGoTo(aCols[nCntFor,Ascan(aHeader,{|x| AllTrim(x[2])==('ZZG_REC_WT')})]))
					If	(cString)->(RECNO()) = aCols[nCntFor,Ascan(aHeader,{|x| AllTrim(x[2])==('ZZG_REC_WT')})]
						RecLock(cString,.F.)
						(cString)->(DbDelete())
						MsUnLock()
						DbCommit()
					EndIf
				EndIf
			Next nCntFor
			
			EvalTrigger()
		End Transaction
	EndIf
	(cString)->(DbSetOrder(n030Index))
	
Return NIL

/*====================================================================================\
|Programa  | ZZGLinOK       | Autor | GIOVANI.ZAGO               | Data | 09/08/2013  |
|=====================================================================================|
|Descrição | Validação do linha do Acols   							                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | ZZGLinOK                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*---------------------------------------------------*
User Function ZZGLinOK()
	*---------------------------------------------------*
	
	Local lRet       := .T.
	Local cGruop     := aCols[n,Ascan(aHeader,{|x| AllTrim(x[2])==cZZG4})]
	Local cGruop2    := aCols[n,Ascan(aHeader,{|x| AllTrim(x[2])==cZZG6})]
	Local cAtivSai   := ""
	Local nLin       :=0
	Local i
	
	For i := 1 To Len(aCols)
		If	!aCols[i,Len(aCols[i])]
			If 	cGruop   = aCols[i,Ascan(aHeader,{|x| AllTrim(x[2])==cZZG4})] .And. cGruop2   = aCols[i,Ascan(aHeader,{|x| AllTrim(x[2])==cZZG6})]
				nLin++
			EndIf
			
			
		EndIf
	Next  i
	
	If nLin > 1
		lRet       := .F.
		MsgInfo('Vendedor/Grupo Duplicado .....Verifique!!!!')
	EndIf
	
	//If (aCols[n,Ascan(aHeader,{|x| AllTrim(x[2])==cZZG10})]   <= 0 .or. aCols[n,Ascan(aHeader,{|x| AllTrim(x[2])==cZZG9})]   <= 0)    .And. lRet
	//	lRet       := .F.
	//	MsgInfo('Quantidade ou Meta Está Zerado.......Verifique!!!!!!!!')
	//EndIf
	
Return( lRet )

/*====================================================================================\
|Programa  | ZZGTudOK       | Autor | GIOVANI.ZAGO               | Data | 09/08/2013  |
|=====================================================================================|
|Descrição | Validação do Processo 								                      |
|          |  														                  |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | ZZGTudOK                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*---------------------------------------------------*
User Function ZZGTudOK()
	*---------------------------------------------------*
	
	Local lRet       := .T.
	Local cGruop     := ''
	Local cAtivSai   := ''
	Local nLin     	 :=0
	local nValCom    :=0
	Local nAcols     :=0
	Local i :=0
	Local w :=0
	
	For i := 1 To Len(aCols)
		If	!aCols[i,Len(aCols[i])]
			nAcols++
			For w := 1 To Len(aCols)
				If	!aCols[w,Len(aCols[i])]
					If aCols[w,Ascan(aHeader,{|x| AllTrim(x[2])==cZZG4})]  = aCols[i,Ascan(aHeader,{|x| AllTrim(x[2])==cZZG4})]  .and. aCols[w,Ascan(aHeader,{|x| AllTrim(x[2])==cZZG6})]  = aCols[i,Ascan(aHeader,{|x| AllTrim(x[2])==cZZG6})]
						nLin++
					EndIf
					If  aCols[i,Ascan(aHeader,{|x| AllTrim(x[2])==cZZG10})]  <= 0 .or. aCols[i,Ascan(aHeader,{|x| AllTrim(x[2])==cZZG9})]   <= 0
						nValCom++
					EndIf
				EndIf
			Next  w
		EndIf
	Next  i
	
	If (nLin-nAcols) > 1
		lRet       := .F.
		MsgInfo('Vendedor/Grupo Duplicado .....Verifique!!!!')
	EndIf
	
	//If nValCom > 1
	//	lRet       := .F.
	//	MsgInfo('Quantidade ou Meta Está Zerado.......Verifique!!!!!!!!')
	//EndIf
	
Return( lRet )

/*====================================================================================\
|Programa  | MenuDef        | Autor | GIOVANI.ZAGO               | Data | 09/08/2013  |
|=====================================================================================|
|Descrição | Opçoes do Menu											                  |
|          | 													                      |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | MenuDef                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*---------------------------------------------------*
Static Function MenuDef()
	*---------------------------------------------------*
	
	PRIVATE aRotina	 := {	{ "Pesquisar" ,"AxPesqui"    ,0 ,1 ,0 ,.F.},;  //"Pesquisar"
	{ "Visualizar" ,"u_ZZG080Manut" ,0 ,2 ,0 ,Nil},;  //"Visualizar"
	{ "Incluir" ,"u_ZZG080Manut" ,0 ,3 ,0 ,Nil},;  //"Incluir"
	{ "Alterar" ,"u_ZZG080Manut" ,0 ,4 ,0 ,Nil},;  //"Alterar"
	{ "Excluir" ,"u_ZZG080Manut" ,0 ,5 ,0 ,Nil},;  //"Excluir"
	{ "Copiar" ,"u_ZZG080Manut" ,0 ,6 ,0 ,Nil} }  //"Copiar"
	
	
Return(aRotina)

/*====================================================================================\
|Programa  | MenuDef        | Autor | GIOVANI.ZAGO               | Data | 09/08/2013  |
|=====================================================================================|
|Descrição | Opçoes do Menu											                  |
|          | 													                      |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | MenuDef                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*---------------------------------------------------*
User Function zMETAVALID()
	*---------------------------------------------------*
	Local _lret := .T.
	
	DbSelectArea("ZZG")
	ZZG->(DbSetOrder(1) )
	If ZZG->(DbSeek(xFilial("ZZG")+M->ZZG_MES+M->ZZG_ANO))
		_lret := .F.
		MsgInfo("Ano: "+M->ZZG_ANO+ "  Mês: "+M->ZZG_MES+"  Já Cadastrados...Verifique.!!!!!")
	EndIf
	
Return(_lret)

/*====================================================================================\
|Programa  | STreajuste     | Autor | GIOVANI.ZAGO               | Data | 09/08/2013  |
|=====================================================================================|
|Descrição | Opçoes de reajuste 									                  |
|          | 													                      |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STreajuste                                                               |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*---------------------------------------------------*
user Function zSTreajuste()
	*---------------------------------------------------*
	local lxSaida   := .f.
	local nOpcao   :=1
	Local _lret:= .f.
	Local cInd := "1"
	Local _cVend1 :='      '
	Local _cVend2 :='ZZZZZZ'
	Local _cGrou1 :='    '
	Local _cGrou2 :='ZZZZ'
	Local _nQtd   :=0
	Local _nMeta  :=0
	Local k   :=0
	
	
	Do While !lxSaida
		
		
		Define msDialog oDxlg Title "Reajuste de Metas" From 10,10 TO 290,260 Pixel
		
		@ 010,010 say "Vendedor de:"  Of oDxlg Pixel
		@ 010,050 msget _cVend1    F3 "SA3" size 050,08  Of oDxlg Pixel
		@ 025,010 say "Vendedor até:  "  Of oDxlg Pixel
		@ 025,050 msget _cVend2   F3 "SA3"  size 050,08  Of oDxlg Pixel
		@ 045,010 say "Grupo de:"   Of oDxlg Pixel
		@ 045,050 msget  _cGrou1  F3 "SBM"  size 050,08  Of oDxlg Pixel
		@ 060,010 say "Grupo até:"   Of oDxlg Pixel
		@ 060,050 msget  _cGrou2  F3 "SBM"  size 050,08  Of oDxlg Pixel
		
		@ 080,010 say "Quantidade(%):"   Of oDxlg Pixel
		@ 080,050 msget  _nQtd picture "@E 999.99" when .t. size 55,013  Of oDxlg Pixel
		@ 095,010 say "Meta(%):"   Of oDxlg Pixel
		@ 095,050 msget  _nMeta picture "@E 999.99" when .t. size 55,013 	 Of oDxlg Pixel
		
		
		@ 115,010 Button "Reajustar"    size 40,14  action ((lxSaida:=.T.,nOpcao:=1,oDxlg:End())) Of oDxlg Pixel
		@ 115,060 Button "Cancelar"    size 40,14  action ((lxSaida:=.T.,nOpcao:=2,oDxlg:End())) Of oDxlg Pixel
		Activate dialog oDxlg centered
		
	EndDo
	
	
	If  nOpcao = 1
		For k:= 1 To Len(Acols)
			If	!aCols[k,Len(aCols[k])]
				
				If aCols[k,Ascan(aHeader,{|x| AllTrim(x[2])==cZZG4})]  >= _cVend1 .and. ;
						aCols[k,Ascan(aHeader,{|x| AllTrim(x[2])==cZZG4})]  <= _cVend2 .and. ;
						aCols[k,Ascan(aHeader,{|x| AllTrim(x[2])==cZZG6})]  >= _cGrou1 .and. ;
						aCols[k,Ascan(aHeader,{|x| AllTrim(x[2])==cZZG6})]  <= _cGrou2
					
					
					aCols[k,Ascan(aHeader,{|x| AllTrim(x[2])==cZZG9})] := aCols[k,Ascan(aHeader,{|x| AllTrim(x[2])==cZZG9})] * ((_nQtd/100)+1)
					
					aCols[k,Ascan(aHeader,{|x| AllTrim(x[2])==cZZG10})] := aCols[k,Ascan(aHeader,{|x| AllTrim(x[2])==cZZG10})] * ((_nMeta/100)+1)
					
					
				Endif
			Endif
		Next k
	ElseIf  nOpcao = 2
		_lret:= .t.
	Endif
	
	_oDlgDefault        := GetWndDefault()
	aEval(_oDlgDefault:aControls,{|x| x:Refresh()})
	
	If ( Type("l410Auto") == "U" .OR. !l410Auto )
		oDlgEsp:Refresh()
	EndIf
Return
