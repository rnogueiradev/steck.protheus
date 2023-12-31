#include 'Protheus.ch'
#include 'RwMake.ch'

/*====================================================================================\
|Programa  | STINTMETA      | Autor | GIOVANI.ZAGO               | Data | 24/10/2018  |
|=====================================================================================|
|Descri��o | Chama Tela de Cadastro   metas										      |
|          | 													                      |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STINTMETA                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Hist�rico....................................|
\====================================================================================*/
*---------------------------------------------------*
User Function STINTMETA()
	*---------------------------------------------------*
	//     u_STFATMETA()
	Local aCamVend :={ 'ZZ0';   //1
	,'ZZ0_MES'		;              //2
	,'ZZ0_ANO'		;              //3
	,'ZZ0_VEND'  	;              //4
	,'ZZ0_NVEND'  	;               //5
	,'ZZ0_GRUPO'  	;              //6
	,'ZZ0_NGRUPO'  	;              //7
	,'ZZ0_FILIAL' 	;              //8
	,'ZZ0_QTD'		;
	,'ZZ0_VALOR'	;
	,'Meta Internos'} //10
	
	U_YSTFATMETA(aCamVend)
	
Return


/*====================================================================================\
|Programa  | XSTFATMETA     | Autor | GIOVANI.ZAGO               | Data | 09/08/2013  |
|=====================================================================================|
|Descri��o | Cria mBrowse 											                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | XSTFATMETA                                                               |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Hist�rico....................................|
\====================================================================================*/
*---------------------------------------------------*
User Function YSTFATMETA(aCamVend)
	*---------------------------------------------------*
	
	Private cCadastro  := aCamVend[11]
	Private aRotina	   := MenuDef()
	Private cString    := aCamVend[1]
	Private cZZ02      := aCamVend[2]
	Private cZZ03      := aCamVend[3]
	Private cZZ04      := aCamVend[4]
	Private cZZ05      := aCamVend[5]
	Private cZZ06      := aCamVend[6]
	Private cZZ07      := aCamVend[7]
	Private cZZ08      := aCamVend[8]
	Private cZZ09      := aCamVend[9]
	Private cZZ010      := aCamVend[10]
	Private cZZ011      := aCamVend[11]
	(cString)->(DbSetOrder(2))
	
	mBrowse( 6,1,22,75,cString)
	
	RetIndex(cString)
	
Return NIL

/*====================================================================================\
|Programa  | ZZ0080Manut    | Autor | GIOVANI.ZAGO               | Data | 09/08/2013  |
|=====================================================================================|
|Descri��o | Manuten��o do Menu										                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | ZZ0080Manut                                                              |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Hist�rico....................................|
\====================================================================================*/
*---------------------------------------------------*
User Function ZZ0080Manut( cAlias, nReg, nOpcx )
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
	
	AAdd(aButtons, {"DBG06",{|| u_YSTreajuste() },"Reajuste" } )
	AAdd(aButtons, {"DBG06",{|| u_YSTPesqMeta() },"Pesquisa" } )
	AAdd(aButtons, {"DBG06",{|| u_YSTCopyVen() } ,"Cop.Vendedor" } )
	//���������������������������������������������������������Ŀ
	//� Define a funcao utilizada ( Incl.,Alt.,Visual.,Exclu.)  �
	//�����������������������������������������������������������
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
	
	//���������������������������������������������������������������������������Ŀ
	//� Configura variaveis da Enchoice                                           �
	//�����������������������������������������������������������������������������
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
			If (AllTrim(SX3->X3_CAMPO)$ (cZZ02+"."+cZZ03))
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
	AAdd( aNoFields, cZZ02 )
	AAdd( aNoFields, cZZ03 )
	
	//��������������������������������������������Ŀ
	//� Montagem do AHEADER e ACOLS para GetDados  �
	//����������������������������������������������
	If l080Inclui
		FillGetDados(nOpcx,cString,1,,,,aNoFields,,,,,.T.,,,)
	Else
		If l080Copia
			cSeekDC6 := xFilial(cString)+(cString)->(&cZZ02)+(cString)->(&cZZ03)
		Else
			cSeekDC6 := xFilial(cString)+M->&cZZ02+M->&cZZ03
		EndIf
		cWhile   := cString+'->'+cZZ08+'+'+cString+'->'+cZZ02+'+'+cString+'->'+cZZ03
		
		FillGetDados(nOpcx,cString,1,cSeekDC6,{|| &cWhile },,aNoFields,,,,,,,,,)
		nOrdem := aScan(aHeader,{|x| Trim(x[2])==(cZZ04)})
		aSort(aCols,,,{|x,y| x[nOrdem]<y[nOrdem]})
	EndIf
	
	//-- Dimensoes padroes
	aSize := MsAdvSize()
	AAdd( aObjects, { 100, 32, .T., .T. } )
	AAdd( aObjects, { 200, 200, .T., .T. } )
	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
	aPosObj := MsObjSize( aInfo, aObjects,.T.)
	
	Inclui := ((l080Inclui).Or.(l080Copia)) //-- Impede que a Descri��o apaceca na inclus�o de itens durante a alteracao
	
	DEFINE MSDIALOG oDlgEsp TITLE cCadastro FROM aSize[7],00 TO aSize[6],aSize[5] OF oMainWnd PIXEL
	//���������������������������������������������������������������������������Ŀ
	//� Monta a Enchoice                                                          �
	//�����������������������������������������������������������������������������
	EnChoice( cAlias, nReg, If(l080Copia, 3, nOpcx),,,,aVisual, aPosObj[1], , 3, , , , , ,.T. )
	//EnChoice( cAlias, nReg, nOpc,,,,aExibe,{013,001,217,315}, aAltera,,,,,,,.T. )
	MSGetDados():New(aPosObj[2,1], aPosObj[2,2] , aPosObj[2,3], aPosObj[2,4], If(l080Copia, 4, nOpcx),"U_ZZ0LinOK", "U_ZZ0TudOK", , !l080Visual,			 , ,    ,9999)
	//MsGetDados():New(05			 , 05			, 145		  , 195			, 4						 , "U_LINHAOK", "U_TUDOOK"	, "+A1_COD", .T.		, {"A1_NOME"}, , .F., 200, "U_FIELDOK", "U_SUPERDEL", , "U_DELOK", oDlg)
	ACTIVATE MSDIALOG oDlgEsp ON INIT EnchoiceBar(oDlgEsp	,{||If(u_ZZ0TudOK(),(nOpca := 1,oDlgEsp:End()),nOpcA:=0)},{||nOpcA:=0,oDlgEsp:End()},,aButtons)
	
	If nOpca == 1 .And. !l080Visual
		If	nOpca == 1
			ZZ0Grava(nOpcx)
		EndIf
	EndIf
	
	RestArea(aAreaAnt)
	
Return( nOpca )

/*====================================================================================\
|Programa  | ZZ0Grava       | Autor | GIOVANI.ZAGO               | Data | 09/08/2013  |
|=====================================================================================|
|Descri��o | Grava os Dados                                                           |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | ZZ0Grava                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Hist�rico....................................|
\====================================================================================*/
*---------------------------------------------------*
Static Function ZZ0Grava(nOpcx)
	*---------------------------------------------------*
	
	Local nCntFor   := 0
	Local nCntFo1   := 0
	Local nPosCpo   := 0
	Local nItem     := 0
	Local n030Index :=(cString)->(IndexOrd())
	
	If	nOpcx == 5 			//Excluir
		(cString)->(DbSetOrder(1))
		While (cString)->(DbSeek(xFilial(cString) + M->&cZZ02+ M->&cZZ03 ))
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
					(cString)->(DbGoTo(aCols[nCntFor,Ascan(aHeader,{|x| AllTrim(x[2])==('ZZ0_REC_WT')})]))
					If	(cString)->(RECNO()) = aCols[nCntFor,Ascan(aHeader,{|x| AllTrim(x[2])==('ZZ0_REC_WT')})]    .and. nOpcx <> 6
						RecLock(cString,.F.)
					Else
						RecLock(cString,.T.)
					EndIf
					(cString)->&cZZ08  := xFilial(cString)
					(cString)->&cZZ02  := SUBSTR(M->&cZZ02,1,2)
					(cString)->&cZZ03  := M->&cZZ03
					(cString)->&cZZ04  := aCols[nCntFor,Ascan(aHeader,{|x| AllTrim(x[2])==(cZZ04)})]
					(cString)->&cZZ05  := aCols[nCntFor,Ascan(aHeader,{|x| AllTrim(x[2])==(cZZ05)})]
					(cString)->&cZZ06  := aCols[nCntFor,Ascan(aHeader,{|x| AllTrim(x[2])==(cZZ06)})]
					(cString)->&cZZ07  := aCols[nCntFor,Ascan(aHeader,{|x| AllTrim(x[2])==(cZZ07)})]
					(cString)->&cZZ09  := aCols[nCntFor,Ascan(aHeader,{|x| AllTrim(x[2])==(cZZ09)})]
					(cString)->&cZZ010 := aCols[nCntFor,Ascan(aHeader,{|x| AllTrim(x[2])==(cZZ010)})]
					
					
					
					
					MsUnLock()
					DbCommit()
				Else
					(cString)->(DbGoTo(aCols[nCntFor,Ascan(aHeader,{|x| AllTrim(x[2])==('ZZ0_REC_WT')})]))
					If	(cString)->(RECNO()) = aCols[nCntFor,Ascan(aHeader,{|x| AllTrim(x[2])==('ZZ0_REC_WT')})]
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
|Programa  | ZZ0LinOK       | Autor | GIOVANI.ZAGO               | Data | 09/08/2013  |
|=====================================================================================|
|Descri��o | Valida��o do linha do Acols   							                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | ZZ0LinOK                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Hist�rico....................................|
\====================================================================================*/
*---------------------------------------------------*
User Function ZZ0LinOK()
	*---------------------------------------------------*
	
	Local lRet       := .T.
	Local cGruop     := aCols[n,Ascan(aHeader,{|x| AllTrim(x[2])==cZZ04})]
	Local cGruop2    := aCols[n,Ascan(aHeader,{|x| AllTrim(x[2])==cZZ06})]
	Local cAtivSai   := ""
	Local nLin       :=0
	Local i
	
	For i := 1 To Len(aCols)
		If	!aCols[i,Len(aCols[i])]
			If 	cGruop   = aCols[i,Ascan(aHeader,{|x| AllTrim(x[2])==cZZ04})] .And. cGruop2   = aCols[i,Ascan(aHeader,{|x| AllTrim(x[2])==cZZ06})]
				nLin++
			EndIf
			
			
		EndIf
	Next  i
	
	If nLin > 1
		lRet       := .F.
		MsgInfo('Vendedor/Grupo Duplicado .....Verifique!!!!')
	EndIf
	
	//If (aCols[n,Ascan(aHeader,{|x| AllTrim(x[2])==cZZ010})]   <= 0 .or. aCols[n,Ascan(aHeader,{|x| AllTrim(x[2])==cZZ09})]   <= 0)    .And. lRet
	//	lRet       := .F.
	//	MsgInfo('Quantidade ou Meta Est� Zerado.......Verifique!!!!!!!!')
	//EndIf
	
Return( lRet )

/*====================================================================================\
|Programa  | ZZ0TudOK       | Autor | GIOVANI.ZAGO               | Data | 09/08/2013  |
|=====================================================================================|
|Descri��o | Valida��o do Processo 								                      |
|          |  														                  |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | ZZ0TudOK                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Hist�rico....................................|
\====================================================================================*/
*---------------------------------------------------*
User Function ZZ0TudOK()
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
					If aCols[w,Ascan(aHeader,{|x| AllTrim(x[2])==cZZ04})]  = aCols[i,Ascan(aHeader,{|x| AllTrim(x[2])==cZZ04})]  .and. aCols[w,Ascan(aHeader,{|x| AllTrim(x[2])==cZZ06})]  = aCols[i,Ascan(aHeader,{|x| AllTrim(x[2])==cZZ06})]
						nLin++
					EndIf
					If  aCols[i,Ascan(aHeader,{|x| AllTrim(x[2])==cZZ010})]  <= 0 .or. aCols[i,Ascan(aHeader,{|x| AllTrim(x[2])==cZZ09})]   <= 0
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
	//	MsgInfo('Quantidade ou Meta Est� Zerado.......Verifique!!!!!!!!')
	//EndIf
	
Return( lRet )

/*====================================================================================\
|Programa  | MenuDef        | Autor | GIOVANI.ZAGO               | Data | 09/08/2013  |
|=====================================================================================|
|Descri��o | Op�oes do Menu											                  |
|          | 													                      |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | MenuDef                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Hist�rico....................................|
\====================================================================================*/
*---------------------------------------------------*
Static Function MenuDef()
	*---------------------------------------------------*
	
	PRIVATE aRotina	 := {	{ "Pesquisar" ,"AxPesqui"    ,0 ,1 ,0 ,.F.},;  //"Pesquisar"
	{ "Visualizar" ,"u_ZZ0080Manut" ,0 ,2 ,0 ,Nil},;  //"Visualizar"
	{ "Incluir" ,"u_ZZ0080Manut" ,0 ,3 ,0 ,Nil},;  //"Incluir"
	{ "Alterar" ,"u_ZZ0080Manut" ,0 ,4 ,0 ,Nil},;  //"Alterar"
	{ "Excluir" ,"u_ZZ0080Manut" ,0 ,5 ,0 ,Nil},;  //"Excluir"
	{ "Copiar" ,"u_ZZ0080Manut" ,0 ,6 ,0 ,Nil} }  //"Copiar"
	
	
Return(aRotina)

/*====================================================================================\
|Programa  | MenuDef        | Autor | GIOVANI.ZAGO               | Data | 09/08/2013  |
|=====================================================================================|
|Descri��o | Op�oes do Menu											                  |
|          | 													                      |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | MenuDef                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Hist�rico....................................|
\====================================================================================*/
*---------------------------------------------------*
User Function XMETAVALID()
	*---------------------------------------------------*
	Local _lret := .T.
	
	DbSelectArea("ZZ0")
	ZZ0->(DbSetOrder(1) )
	If ZZ0->(DbSeek(xFilial("ZZ0")+M->ZZ0_MES+M->ZZ0_ANO))
		_lret := .F.
		MsgInfo("Ano: "+M->ZZ0_ANO+ "  M�s: "+M->ZZ0_MES+"  J� Cadastrados...Verifique.!!!!!")
	EndIf
	
Return(_lret)

/*====================================================================================\
|Programa  | STreajuste     | Autor | GIOVANI.ZAGO               | Data | 09/08/2013  |
|=====================================================================================|
|Descri��o | Op�oes de reajuste 									                  |
|          | 													                      |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STreajuste                                                               |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Hist�rico....................................|
\====================================================================================*/
*---------------------------------------------------*
user Function YSTreajuste()
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
	Local k  :=0
	
	Do While !lxSaida
		
		
		Define msDialog oDxlg Title "Reajuste de Metas" From 10,10 TO 290,260 Pixel
		
		@ 010,010 say "Vendedor de:"  Of oDxlg Pixel
		@ 010,050 msget _cVend1    F3 "SA3" size 050,08  Of oDxlg Pixel
		@ 025,010 say "Vendedor at�:  "  Of oDxlg Pixel
		@ 025,050 msget _cVend2   F3 "SA3"  size 050,08  Of oDxlg Pixel
		@ 045,010 say "Grupo de:"   Of oDxlg Pixel
		@ 045,050 msget  _cGrou1  F3 "SBM"  size 050,08  Of oDxlg Pixel
		@ 060,010 say "Grupo at�:"   Of oDxlg Pixel
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
				
				If aCols[k,Ascan(aHeader,{|x| AllTrim(x[2])==cZZ04})]  >= _cVend1 .and. ;
						aCols[k,Ascan(aHeader,{|x| AllTrim(x[2])==cZZ04})]  <= _cVend2 .and. ;
						aCols[k,Ascan(aHeader,{|x| AllTrim(x[2])==cZZ06})]  >= _cGrou1 .and. ;
						aCols[k,Ascan(aHeader,{|x| AllTrim(x[2])==cZZ06})]  <= _cGrou2
					
					
					aCols[k,Ascan(aHeader,{|x| AllTrim(x[2])==cZZ09})] := aCols[k,Ascan(aHeader,{|x| AllTrim(x[2])==cZZ09})] * ((_nQtd/100)+1)
					
					aCols[k,Ascan(aHeader,{|x| AllTrim(x[2])==cZZ010})] := aCols[k,Ascan(aHeader,{|x| AllTrim(x[2])==cZZ010})] * ((_nMeta/100)+1)
					
					
				Endif
			Endif
		Next k
	ElseIf  nOpcao = 2
		_lret:= .t.
	Endif
	
	//_oDlgDefault        := GetWndDefault()
	//aEval(_oDlgDefault:aControls,{|x| x:Refresh()})
	
	If ( Type("l410Auto") == "U" .OR. !l410Auto )
		oDlgEsp:Refresh()
	EndIf
Return



User Function YSTPesqMeta ()
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
	Local _ng :=  0
	Do While !lxSaida
		
		
		Define msDialog oDxlg Title "Pesquisa" From 10,10 TO 290,260 Pixel
		
		@ 010,010 say "Vendedor :"  Of oDxlg Pixel
		@ 010,050 msget _cVend1    F3 "SA3" size 050,08  Of oDxlg Pixel
		
		@ 035,010 say "Grupo  :"   Of oDxlg Pixel
		@ 035,050 msget  _cGrou1  F3 "SBM"  size 050,08  Of oDxlg Pixel
		
		@ 70,010 Button "Pesquisar"    size 40,14  action ((lxSaida:=.T.,nOpcao:=1,oDxlg:End())) Of oDxlg Pixel
		@ 70,060 Button "Cancelar"    size 40,14  action ((lxSaida:=.T.,nOpcao:=2,oDxlg:End())) Of oDxlg Pixel
		Activate dialog oDxlg centered
		
	EndDo
	
	
	If  nOpcao = 1
		
		_ng := Ascan(aCols,{|x| AllTrim(x[3])==_cVend1})
		If Ascan(aCols,{|x| AllTrim(x[3])==_cVend1})<>0
			
			
			/*
			If !Empty(Alltrim(_cGrou1)
				If Ascan(aCols,{|x| AllTrim(x[5])==_cGrou1})<>0
					
					
					
					
				Endif
			Else
				n:=
			Endif
			*/
			
			n:= _ng
		Endif
		
		
		//	_oDlgDefault        := GetWndDefault()
		//	aEval(_oDlgDefault:aControls,{|x| x:Refresh()})
		
		If ( Type("l410Auto") == "U" .OR. !l410Auto )
			oDlgEsp:Refresh()
		EndIf
	EndIf
	
Return()



/*====================================================================================\
|Programa  | xSTCopyVen     | Autor | GIOVANI.ZAGO               | Data | 15/01/2014  |
|=====================================================================================|
|Descri��o | Op��o de copia de vendedor  							                  |
|          | 													                      |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | xSTCopyVen                                                               |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Hist�rico....................................|
\====================================================================================*/
*---------------------------------------------------*
user Function YSTCopyVen()
	*---------------------------------------------------*
	local lxSaida   := .f.
	local nOpcao   :=1
	Local _lret:= .f.
	Local cInd := "1"
	Local _cVend1 :='      '
	Local _cVend2 :='      '
	Local _cGrou1 :='    '
	Local _cGrou2 :='ZZZZ'
	Local _nQtd   :=0
	Local _nMeta  :=0
	Local nCntFor3 := 0
	Local _lrVen := .T.
	Local _aVend2:={}
	Local _nRec := 0
	Local k := 0
	Local j := 0
	Do While !lxSaida
		
		
		Define msDialog oDxlg Title "Copiar Vendedor" From 10,10 TO 290,260 Pixel
		
		@ 010,010 say "Vendedor de:"  Of oDxlg Pixel
		@ 010,050 msget _cVend1    F3 "SA3" size 050,08  Of oDxlg Pixel
		
		@ 035,010 say "Vendedor para:"   Of oDxlg Pixel
		@ 035,050 msget  _cVend2  F3 "SA3"  size 050,08  Of oDxlg Pixel
		
		@ 70,010 Button "Copiar"      size 40,14  action ((lxSaida:=.T.,nOpcao:=1,oDxlg:End())) Of oDxlg Pixel
		@ 70,060 Button "Cancelar"    size 40,14  action ((lxSaida:=.T.,nOpcao:=2,oDxlg:End())) Of oDxlg Pixel
		Activate dialog oDxlg centered
		
	EndDo
	If  nOpcao = 1
		For k:= 1 To Len(Acols)
			If	!aCols[k,Len(aCols[k])]
				
				If aCols[k,Ascan(aHeader,{|x| AllTrim(x[2])==cZZ04})]  = _cVend2
					_lrVen:= .F.
					
				EndIf
			Endif
		Next k
		If _lrVen
			For k:= 1 To Len(Acols)
				If	!aCols[k,Len(aCols[k])]
					
					If aCols[k,Ascan(aHeader,{|x| AllTrim(x[2])==cZZ04})]  = _cVend1
						
						AADD(_aVend2,Array(Len(aHeader) + 1))
						For nCntFor3 := 1 To Len(aHeader)
							If nCntFor3 = 1
								_aVend2[Len(_aVend2)][nCntFor3]:= _cVend2
							ElseIf   nCntFor3 = 2
								_aVend2[Len(_aVend2)][nCntFor3]:= Alltrim(Posicione("SA3",1,xFilial("SA3")+_cVend2,"A3_NOME"))
							ElseIf   nCntFor3 = 8
								_nRec++
								_aVend2[Len(_aVend2)][nCntFor3]:= ZZ0->(LASTREC())+_nRec
							Else
								_aVend2[Len(_aVend2)][nCntFor3]:= aCols[k][nCntFor3]
							EndIf
						Next nCntFor3
						
						_aVend2[Len(_aVend2)][Len(aHeader)+1] := .F.
					EndIf
				Endif
			Next k
			
			For j:=1 To Len(_aVend2)
				
				AADD(aCols,Array(Len(aHeader) + 1))
				For nCntFor3 := 1 To Len(aHeader)
					If nCntFor3 = 1
						aCols[Len(aCols)][nCntFor3]:= _aVend2[j][nCntFor3]
					ElseIf   nCntFor3 = 2
						aCols[Len(aCols)][nCntFor3]:= _aVend2[j][nCntFor3]
					Else
						aCols[Len(aCols)][nCntFor3]:= _aVend2[j][nCntFor3]
					EndIf
				Next nCntFor3
				
				aCols[Len(aCols)][Len(aHeader)+1] := .F.
				
				
			Next j
			
			MsgInfo("Copia Finalizada !!!!!!!!!!")
		Else
			MsgInfo("Vendedor j� Cadastrado("+_cVend2+")....")
		Endif
	ElseIf  nOpcao = 2
		_lret:= .t.
	Endif
	
	
	
	If ( Type("l410Auto") == "U" .OR. !l410Auto )
		oDlgEsp:Refresh()
	EndIf
Return


