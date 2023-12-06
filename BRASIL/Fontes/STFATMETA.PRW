#include 'Protheus.ch'
#include 'RwMake.ch'

/*====================================================================================\
|Programa  | STFATMETA      | Autor | GIOVANI.ZAGO               | Data | 09/08/2013  |
|=====================================================================================|
|Descrição | Chama Tela de Cadastro   metas										      |
|          | 													                      |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | AFAT002                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*---------------------------------------------------*
User Function STFATMETA()
	*---------------------------------------------------*
	//     u_STFATMETA()
	Local aCamVend :={ 'ZZD';   //1
	,'ZZD_MES'		;              //2
	,'ZZD_ANO'		;              //3
	,'ZZD_VEND'  	;              //4
	,'ZZD_NVEND'  	;               //5
	,'ZZD_GRUPO'  	;              //6
	,'ZZD_NGRUPO'  	;              //7
	,'ZZD_FILIAL' 	;              //8
	,'ZZD_QTD'		;
		,'ZZD_VALOR'	;
		,'Cadastro de Meta'} //10
	
	U_XSTFATMETA(aCamVend)
	
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
User Function XSTFATMETA(aCamVend)
	*---------------------------------------------------*
	
	Private cCadastro  := aCamVend[11]
	Private aRotina	   := MenuDef()
	Private cString    := aCamVend[1]
	Private cZzd2      := aCamVend[2]
	Private cZzd3      := aCamVend[3]
	Private cZzd4      := aCamVend[4]
	Private cZzd5      := aCamVend[5]
	Private cZzd6      := aCamVend[6]
	Private cZzd7      := aCamVend[7]
	Private cZzd8      := aCamVend[8]
	Private cZzd9      := aCamVend[9]
	Private cZzd10      := aCamVend[10]
	Private cZzd11      := aCamVend[11]
	(cString)->(DbSetOrder(1))
	
	If ! __cuserid $ GetMv("ST_FATMETA",,'001694')
		MsgInfo("Usuario sem acesso, Metas ")
		Return()
	EndIf


	mBrowse( 6,1,22,75,cString)
	
	RetIndex(cString)
	
Return NIL

/*====================================================================================\
|Programa  | ZZD080Manut    | Autor | GIOVANI.ZAGO               | Data | 09/08/2013  |
|=====================================================================================|
|Descrição | Manutenção do Menu										                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | ZZD080Manut                                                              |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*---------------------------------------------------*
User Function ZZD080Manut( cAlias, nReg, nOpcx )
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
	
	AAdd(aButtons, {"DBG06",{|| u_xSTreajuste() },"Reajuste" } )
	AAdd(aButtons, {"DBG06",{|| u_xSTPesqMeta() },"Pesquisa" } )
	AAdd(aButtons, {"DBG06",{|| u_xSTCopyVen() } ,"Cop.Vendedor" } )
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
			If (AllTrim(SX3->X3_CAMPO)$ (cZzd2+"."+cZzd3))
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
	AAdd( aNoFields, cZzd2 )
	AAdd( aNoFields, cZzd3 )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montagem do AHEADER e ACOLS para GetDados  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If l080Inclui
		FillGetDados(nOpcx,cString,1,,,,aNoFields,,,,,.T.,,,)
	Else
		If l080Copia
			cSeekDC6 := xFilial(cString)+(cString)->(&cZzd2)+(cString)->(&cZzd3)
		Else
			cSeekDC6 := xFilial(cString)+M->&cZzd2+M->&cZzd3
		EndIf
		cWhile   := cString+'->'+cZzd8+'+'+cString+'->'+cZzd2+'+'+cString+'->'+cZzd3
		
		FillGetDados(nOpcx,cString,1,cSeekDC6,{|| &cWhile },,aNoFields,,,,,,,,,)
		nOrdem := aScan(aHeader,{|x| Trim(x[2])==(cZzd4)})
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
	MSGetDados():New(aPosObj[2,1], aPosObj[2,2] , aPosObj[2,3], aPosObj[2,4], If(l080Copia, 4, nOpcx),"U_ZZDLinOK", "U_ZZDTudOK", , !l080Visual,			 , ,    ,9999)
	//MsGetDados():New(05			 , 05			, 145		  , 195			, 4						 , "U_LINHAOK", "U_TUDOOK"	, "+A1_COD", .T.		, {"A1_NOME"}, , .F., 200, "U_FIELDOK", "U_SUPERDEL", , "U_DELOK", oDlg)
	ACTIVATE MSDIALOG oDlgEsp ON INIT EnchoiceBar(oDlgEsp	,{||If(u_ZZDTudOK(),(nOpca := 1,oDlgEsp:End()),nOpcA:=0)},{||nOpcA:=0,oDlgEsp:End()},,aButtons)
	
	If nOpca == 1 .And. !l080Visual
		If	nOpca == 1
			ZZDGrava(nOpcx)
		EndIf
	EndIf
	
	RestArea(aAreaAnt)
	
Return( nOpca )

/*====================================================================================\
|Programa  | ZZDGrava       | Autor | GIOVANI.ZAGO               | Data | 09/08/2013  |
|=====================================================================================|
|Descrição | Grava os Dados                                                           |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | ZZDGrava                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*---------------------------------------------------*
Static Function ZZDGrava(nOpcx)
	*---------------------------------------------------*
	
	Local nCntFor   := 0
	Local nCntFo1   := 0
	Local nPosCpo   := 0
	Local nItem     := 0
	Local n030Index :=(cString)->(IndexOrd())
	
	If	nOpcx == 5 			//Excluir
		(cString)->(DbSetOrder(1))
		While (cString)->(DbSeek(xFilial(cString) + M->&cZzd2+ M->&cZzd3 ))
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
					(cString)->(DbGoTo(aCols[nCntFor,Ascan(aHeader,{|x| AllTrim(x[2])==('ZZD_REC_WT')})]))
					If	(cString)->(RECNO()) = aCols[nCntFor,Ascan(aHeader,{|x| AllTrim(x[2])==('ZZD_REC_WT')})]    .and. nOpcx <> 6
						RecLock(cString,.F.)
					Else
						RecLock(cString,.T.)
					EndIf
					(cString)->&cZzd8  := xFilial(cString)
					(cString)->&cZzd2  := SUBSTR(M->&cZzd2,1,2)
					(cString)->&cZzd3  := M->&cZzd3
					(cString)->&cZzd4  := aCols[nCntFor,Ascan(aHeader,{|x| AllTrim(x[2])==(cZzd4)})]
					(cString)->&cZzd5  := aCols[nCntFor,Ascan(aHeader,{|x| AllTrim(x[2])==(cZzd5)})]
					(cString)->&cZzd6  := aCols[nCntFor,Ascan(aHeader,{|x| AllTrim(x[2])==(cZzd6)})]
					(cString)->&cZzd7  := aCols[nCntFor,Ascan(aHeader,{|x| AllTrim(x[2])==(cZzd7)})]
					(cString)->&cZzd9  := aCols[nCntFor,Ascan(aHeader,{|x| AllTrim(x[2])==(cZzd9)})]
					(cString)->&cZzd10 := aCols[nCntFor,Ascan(aHeader,{|x| AllTrim(x[2])==(cZzd10)})]
					
					
					
					
					MsUnLock()
					DbCommit()
				Else
					(cString)->(DbGoTo(aCols[nCntFor,Ascan(aHeader,{|x| AllTrim(x[2])==('ZZD_REC_WT')})]))
					If	(cString)->(RECNO()) = aCols[nCntFor,Ascan(aHeader,{|x| AllTrim(x[2])==('ZZD_REC_WT')})]
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
|Programa  | ZZDLinOK       | Autor | GIOVANI.ZAGO               | Data | 09/08/2013  |
|=====================================================================================|
|Descrição | Validação do linha do Acols   							                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | ZZDLinOK                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*---------------------------------------------------*
User Function ZZDLinOK()
	*---------------------------------------------------*
	
	Local lRet       := .T.
	Local cGruop     := aCols[n,Ascan(aHeader,{|x| AllTrim(x[2])==cZzd4})]
	Local cGruop2    := aCols[n,Ascan(aHeader,{|x| AllTrim(x[2])==cZzd6})]
	Local cAtivSai   := ""
	Local nLin       :=0
	Local i
	
	For i := 1 To Len(aCols)
		If	!aCols[i,Len(aCols[i])]
			If 	cGruop   = aCols[i,Ascan(aHeader,{|x| AllTrim(x[2])==cZzd4})] .And. cGruop2   = aCols[i,Ascan(aHeader,{|x| AllTrim(x[2])==cZzd6})]
				nLin++
			EndIf
			
			
		EndIf
	Next  i
	
	If nLin > 1
		lRet       := .F.
		MsgInfo('Vendedor/Grupo Duplicado .....Verifique!!!!')
	EndIf
	
	//If (aCols[n,Ascan(aHeader,{|x| AllTrim(x[2])==cZzd10})]   <= 0 .or. aCols[n,Ascan(aHeader,{|x| AllTrim(x[2])==cZzd9})]   <= 0)    .And. lRet
	//	lRet       := .F.
	//	MsgInfo('Quantidade ou Meta Está Zerado.......Verifique!!!!!!!!')
	//EndIf
	
Return( lRet )

/*====================================================================================\
|Programa  | ZZDTudOK       | Autor | GIOVANI.ZAGO               | Data | 09/08/2013  |
|=====================================================================================|
|Descrição | Validação do Processo 								                      |
|          |  														                  |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | ZZDTudOK                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*---------------------------------------------------*
User Function ZZDTudOK()
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
					If aCols[w,Ascan(aHeader,{|x| AllTrim(x[2])==cZzd4})]  = aCols[i,Ascan(aHeader,{|x| AllTrim(x[2])==cZzd4})]  .and. aCols[w,Ascan(aHeader,{|x| AllTrim(x[2])==cZzd6})]  = aCols[i,Ascan(aHeader,{|x| AllTrim(x[2])==cZzd6})]
						nLin++
					EndIf
					If  aCols[i,Ascan(aHeader,{|x| AllTrim(x[2])==cZzd10})]  <= 0 .or. aCols[i,Ascan(aHeader,{|x| AllTrim(x[2])==cZzd9})]   <= 0
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
	{ "Visualizar" ,"u_ZZD080Manut" ,0 ,2 ,0 ,Nil},;  //"Visualizar"
	{ "Incluir" ,"u_ZZD080Manut" ,0 ,3 ,0 ,Nil},;  //"Incluir"
	{ "Alterar" ,"u_ZZD080Manut" ,0 ,4 ,0 ,Nil},;  //"Alterar"
	{ "Excluir" ,"u_ZZD080Manut" ,0 ,5 ,0 ,Nil},;  //"Excluir"
	{ "Copiar" ,"u_ZZD080Manut" ,0 ,6 ,0 ,Nil},;   //"Copiar"
	{ "Imp.CSV" ,"u_ZZD080CSV" ,0 ,6 ,0 ,Nil}}  //"Excluir"
	
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
User Function METAVALID()
	*---------------------------------------------------*
	Local _lret := .T.
	
	DbSelectArea("ZZD")
	ZZD->(DbSetOrder(1) )
	If ZZD->(DbSeek(xFilial("ZZD")+M->ZZD_MES+M->ZZD_ANO))
		_lret := .F.
		MsgInfo("Ano: "+M->ZZD_ANO+ "  Mês: "+M->ZZD_MES+"  Já Cadastrados...Verifique.!!!!!")
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
user Function xSTreajuste()
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
				
				If aCols[k,Ascan(aHeader,{|x| AllTrim(x[2])==cZzd4})]  >= _cVend1 .and. ;
						aCols[k,Ascan(aHeader,{|x| AllTrim(x[2])==cZzd4})]  <= _cVend2 .and. ;
						aCols[k,Ascan(aHeader,{|x| AllTrim(x[2])==cZzd6})]  >= _cGrou1 .and. ;
						aCols[k,Ascan(aHeader,{|x| AllTrim(x[2])==cZzd6})]  <= _cGrou2
					
					
					aCols[k,Ascan(aHeader,{|x| AllTrim(x[2])==cZzd9})] := aCols[k,Ascan(aHeader,{|x| AllTrim(x[2])==cZzd9})] * ((_nQtd/100)+1)
					
					aCols[k,Ascan(aHeader,{|x| AllTrim(x[2])==cZzd10})] := aCols[k,Ascan(aHeader,{|x| AllTrim(x[2])==cZzd10})] * ((_nMeta/100)+1)
					
					
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



User Function xSTPesqMeta ()
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
|Descrição | Opção de copia de vendedor  							                  |
|          | 													                      |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | xSTCopyVen                                                               |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*---------------------------------------------------*
user Function xSTCopyVen()
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
				
				If aCols[k,Ascan(aHeader,{|x| AllTrim(x[2])==cZzd4})]  = _cVend2
					_lrVen:= .F.
					
				EndIf
			Endif
		Next k
		If _lrVen
			For k:= 1 To Len(Acols)
				If	!aCols[k,Len(aCols[k])]
					
					If aCols[k,Ascan(aHeader,{|x| AllTrim(x[2])==cZzd4})]  = _cVend1
						
						AADD(_aVend2,Array(Len(aHeader) + 1))
						For nCntFor3 := 1 To Len(aHeader)
							If nCntFor3 = 1
								_aVend2[Len(_aVend2)][nCntFor3]:= _cVend2
							ElseIf   nCntFor3 = 2
								_aVend2[Len(_aVend2)][nCntFor3]:= Alltrim(Posicione("SA3",1,xFilial("SA3")+_cVend2,"A3_NOME"))
							ElseIf   nCntFor3 = 8
								_nRec++
								_aVend2[Len(_aVend2)][nCntFor3]:= ZZD->(LASTREC())+_nRec
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
			MsgInfo("Vendedor já Cadastrado("+_cVend2+")....")
		Endif
	ElseIf  nOpcao = 2
		_lret:= .t.
	Endif
	
	
	
	If ( Type("l410Auto") == "U" .OR. !l410Auto )
		oDlgEsp:Refresh()
	EndIf
Return







/*====================================================================================\
|Programa  | ZZD080CSV       | Autor | ANTONIO CORDEIRO          | Data | 10/11/2023  |
|=====================================================================================|
|Descrição | ROTINA PARA IMPORTAR CSV PARA A ZZD- METAS                               |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function ZZD080CSV()

Processa({|| ValCsv() },"","Valida CSV..")

Return()

// Valida CSV. 

Static Function ValCsv() 

	Local cLinha  := ""
	Local lPrim   := .T.
	Local aCampos := {}
	Local aDados  := {}
	Local aProc   := {}
	Local lErro    :=.F.
	Local cErro    :=""
	Local nx     :=0
	Local lContinua:=.T.
    Private q      :=""
    Private z      :=""
    Private aErro  := {}
    Private cArquivo:=""
	Private nP       :=0
    Private cAltera:=""



	cArquivo := cGetFile("Arquivos CSV (*.CSV) |*.CSV*| ","Selecione o Arquivo",,,.T.,GETF_LOCALHARD+GETF_LOCALFLOPPY)
	cArquivo := AllTrim(cArquivo)


	If !File(cArquivo)
		MsgStop("O arquivo " +cArquivo+ " não foi encontrado. A importação será abortada!","[AEST901] - ATENCAO")
		Return()
	EndIf

    nP:=AT(',',cArquivo)
    cVarFile := cFileChgx:=1

    nP:=AT('.',cArquivo)

    _cArquivo:=substr(cArquivo,1,nP-1)+"_log"+Substr(cArquivo,nP,len(cArquivo)+4)
    _cArqProc:=substr(cArquivo,1,nP-1)+"_proc"+Substr(cArquivo,nP,len(cArquivo)+4)

    z := fcreate(alltrim(_cArquivo))

	oFT   := fT():New()
	oFT:ft_fUse( cArquivo )

	_nX := 0

	FT_FUSE(cArquivo)
	ProcRegua(FT_FLASTREC()) 
	FT_FGOTOP()  

	While !( oFT:ft_fEof() )
		IncProc(' Validando Registros ...')
		_nX++
		cLinha := oFT:ft_fReadLn()

		If lPrim
			aCampos := Separa(cLinha,";",.T.)
			lPrim := .F.
            For nx:=1 to len(aCampos)
                q+=ALLTRIM(aCampos[nx])+'";'
            next 
            q+='Log Erro'+'";'
            q+=chr(13)+chr(10)
            fwrite(z,q,len(q))
		Else
			cErro:=""
		   aDados:={}
		   AADD(aDados,Separa(cLinha,";",.T.))
		   nx:=len(aDados)


	       aDados[nx,1] := PADL(AllTrim(aDados[nx,1]),TAMSX3("ZZD_MES")[1],"0")
		   aDados[nx,2] := PADL(AllTrim(aDados[nx,2]),TAMSX3("ZZD_ANO")[1],"0")
		   aDados[nx,3] := PADL(AllTrim(aDados[nx,3]),TAMSX3("ZZD_VEND")[1],"0")
		   aDados[nx,4] := AllTrim(aDados[nx,4])
		   aDados[nx,5] := PADL(AllTrim(aDados[nx,5]),3,"0")
		   aDados[nx,6] := AllTrim(aDados[nx,6])
           aDados[nx,7] := VAL(REPLACE(aDados[nx,7],',','.'))
           aDados[nx,8] := REPLACE(aDados[nx,8],'.','')
		   aDados[nx,8] := VAL(REPLACE(aDados[nx,8],',','.'))
		


           //Valida o Mes. 
		   IF ! ALLTRIM(aDados[nx,1]) $ '/01/02/03/04/05/06/07/08/09/10/11/12/'
			   cErro+='/ Mes informado: '+aDados[nx,1]+' invalido '
		   ENDIF

           //Valida o ano. 
		   IF val(aDados[nx,2]) > year(date())+1 .OR.  val(aDados[nx,2]) < year(date())-1 
			   cErro+='Ano informado: '+aDados[nx,2]+' 2 anos acima ou abaixo do ano atual '
		   ENDIF

           //Valida se o vendedor existe 
		   SA3->(DBSETORDER(1))
		   IF !SA3->(DBSEEK(XFILIAL('SA3')+aDados[nx,3]))
			   cErro+='/ Vendedor: '+aDados[nx,3]+' não localizado/ '
		   ENDIF

           //Valida se o grupo existe. 
		   SBM->(DBSETORDER(1))
		   IF !SBM->(DBSEEK(XFILIAL('SBM')+aDados[nx,5]))
			   cErro+='/ Grupo: '+aDados[nx,5]+' não localizado: '
		   ENDIF
			
           //Valida quantidade 
	       IF aDados[nx,7]<=0
              cErro+='/ Quantidade : '+STR(aDados[nx,7])+ 'invalida'
		   ENDIF

           //Valida quantidade 
	       IF aDados[nx,8]<=0
              cErro+='/ Valor : '+STR(aDados[nx,7])+ 'invalido'
		   ENDIF

		   IF !Empty(cErro)
			   lErro:=.T.
               GravaLog(aDados[NX],cErro)
		   ELSE 
            //Valida se o registro ja existe e exibe alteração 
			   cAltera:=""
               ZZD->(DBSETORDER(7))
			   IF ZZD->(DBSEEK(XFILIAL('ZZD')+aDados[nx,1]+aDados[nx,2]+aDados[nx,3]+aDados[nx,5]))
				  cAltera:=' Alteração de Registo '
			   ELSE 
				  cAltera:=' Novo Registro '	  
			   ENDIF	  
               aadd(aProc,{aDados[nx,1],aDados[nx,2],aDados[nx,3],aDados[nx,4],aDados[nx,5],aDados[nx,6],aDados[nx,7],aDados[nx,8],.T.})
               GravaLog(aDados[nx],cAltera)
           ENDIF   
		EndIf

		oFT:ft_fSkip()
	End While

    fclose(z)
    incproc("Abrindo os dados em Excel.....")

    If !ApOleClient( 'MsExcel' )
       MsgAlert( 'MsExcel não instalado')
	   Return
    else
	   oExcel1 := MsExcel():New()
	   oExcel1:WorkBooks:Open(alltrim(_cArquivo))
	   oExcel1:SetVisible(.T.)
    EndIf

    oFT:ft_fUse()

    if lErro
	   If Msgyesno('Houve erro na análise do CSV  - Continua ?...')
          lContinua:=.T.
	   ELSE 
	      lContinua:=.F.
	   ENDIF 
    ELSE 
	   If Msgyesno('CSV OK - Continua ?...')
          lContinua:=.T.
       ELSE 
	      lContinua:=.F.
	   ENDIF 
    ENDIF	   

 	IF lContinua    
	   oFT:ft_fUse()
       //aSort(aProc, , , {|x,y| x[1]+x[2] < y[1]+y[2] } ) 
	   IF LEN(aProc)>0
	      ImpZZD(aProc)
	   ELSE 
          FWAlertSuccess('Sem dados para processar!! ')
	   ENDIF

	   //For i:=1 to Len(aDados)  //ler linhas da array
	   //Next i
	   FT_FUSE()
    ENDIF 

	FWAlertSuccess('Final do Processo!! ')

Return()



Static Function ImpZZD(aDados)

Processa({|| RunProc(aDados) },"","Atualizando Regisros")

Return()


Static Function RunProc(aDados1)

Local cFilAtu:=""
Local lRet   :=.F.
Local nx:=0



cFilAtu:=cFilAnt

ProcRegua(len(aDados1))

For nx:=1 to len(aDados1)

  IncProc('Processando Registros!!')
 
  //cFilAnt:=aDados1[nx,1]
  DbSelectArea("ZZD")
  ZZD->(DbSetOrder(7))
  IF ZZD->(dbseek(XFILIAL('ZZD')+aDados1[nx,1]+aDados1[nx,2]+aDados1[nx,3]+aDados1[nx,5]))
     ZZD->(RECLOCK('ZZD',.F.))
	 ZZD->ZZD_QTD:=aDados1[nx,7]
     ZZD->ZZD_VALOR:=aDados1[nx,8] 
	 ZZD->(MSUNLOCK('ZZD'))
  ELSE 
     ZZD->(RECLOCK('ZZD',.T.))
	 ZZD->ZZD_MES   :=aDados1[nx,1]
     ZZD->ZZD_ANO   :=aDados1[nx,2] 
     ZZD->ZZD_VEND  :=aDados1[nx,3] 
	 ZZD->ZZD_NVEND :=Posicione("SA3",1,xFilial("SA3")+aDados1[nx,3],"A3_NOME")
	 ZZD->ZZD_GRUPO :=aDados1[nx,5] 
	 ZZD->ZZD_NGRUPO:=Posicione("SBM",1,xFilial("SBM")+aDados1[nx,5],"BM_DESC")
	 ZZD->ZZD_QTD:=aDados1[nx,7]
     ZZD->ZZD_VALOR:=aDados1[nx,8] 
	 ZZD->(MSUNLOCK('ZZD'))
  ENDIF
Next 

Return(lRet)



Static Function GravaLog(aDados2,cErro2)

Local NX:=0

FOR NX:=1 TO LEN(aDados2)
   IF NX<=6
      q := CHR(160)+aDados2[NX]+';';fwrite(z,q,len(q))
   ELSE 
      q := CHR(160)+str(aDados2[NX])+';';fwrite(z,q,len(q))
   ENDIF
NEXT 
q := CHR(160)+cErro2+';';fwrite(z,q,len(q))  
q := chr(13)+chr(10);fwrite(z,q,len(q))
q:=''

Return()


Static Function GravaProc(cFil,cPed,cMotivo,cObs)

q := CHR(160)+cFil+';';fwrite(z,q,len(q))
q := CHR(160)+cPed+';';fwrite(z,q,len(q))
q := CHR(160)+cMotivo+';';fwrite(z,q,len(q))
q := CHR(160)+cObs+';';fwrite(z,q,len(q))  
q := chr(13)+chr(10);fwrite(z,q,len(q))
q:=''

Return()

