
#include 'Protheus.ch'
#include 'RwMake.ch'
#DEFINE CR    chr(13)+chr(10)

/*====================================================================================\
|Programa  | STPREV2         | Autor | GIOVANI.ZAGO               | Data | 25/02/2014  |
|=====================================================================================|
|Descrição | Chama Tela de Cadastro   Previsao de entrega manaus                      |
|          | 													                      |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STPREV2                                                                   |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*---------------------------------------------------*
User Function STPREV2()
	*---------------------------------------------------*
	
	Private cCadastro  := 'Previsão de Entrega'
	Private aRotina	   := {}//MenuDef()
	Private cString    := 'ZZJ'
	Private cVend      := 'ZZJ_NUM'
	Private cNomVend   := 'ZZJ_COD'
	Private cGrup      := 'ZZJ_QUANT'
	Private cFilVend   := 'ZZJ_FILIAL'
	Private cNomGrup   := 'ZZJ_DATA'
	Private cNomOP     := 'ZZJ_OP'
	Private cCance     := 'ZZJ_CANCEL'
	Private cAlter     := 'ZZJ_ALTER'
	Private cTransp    := 'ZZJ_TRANSP'
	Private _cFiltro   := "ZZJ_FILIAL = '"+xFilial("ZZJ")
	Private	aCores2    := {}
	
	MsgAlert("Rotina desativada")
	Return
	
	DbSelectArea("ZZJ")
	//Processa({|| U_STATUSALDO( ) },"Aguarde")
	
	If ZZJ->(LASTREC()) > 0
		aAdd( aRotina, {"Previsão"   ,"u_ZZJ080Manut",0,4} )
		aAdd( aRotina, {"Visualizar" ,"u_ZZJ080Manut",0,2} )
		aAdd( aRotina, {"Encerradas" ,"u_ZZJ080Manut",0,2} )
		aAdd( aRotina, {"Legenda"    ,"u_LegendZZJ()",0,2} )
		aAdd( aRotina, {"Canceladas" ,"u_ZZJ080Manut",0,8} )
		aAdd( aRotina, {"Processa"   ,"u_STPREVATU()",0,5} )
		aAdd( aRotina, {"Importar TXT"   ,"u_STCOMIMPORT()",0,5} )
		aAdd( aRotina, {"Motivos de Cancelamento"   ,"u_STSX5Z4()",0,5} )
		aAdd( aRotina, {"Exclui Reg.TXT"   ,"u_STTXTEXC()",0,5} )
		aAdd( aRotina, {"Informar Chegada"   ,"u_STCHEPREV()",0,5} )
		aAdd( aRotina, {"Alt.Massa"   ,"u_COMALT(ZZJ->ZZJ_OP)",0,5} ) 
	Else
		aAdd( aRotina, {"Previsão"   ,"u_ZZJ080Manut",0,3} )
		aAdd( aRotina, {"Visualizar" ,"u_ZZJ080Manut",0,2} )
		aAdd( aRotina, {"Encerradas" ,"u_ZZJ080Manut",0,2} )
		aAdd( aRotina, {"Legenda"    ,"u_LegendZZJ()",0,2} )
		aAdd( aRotina, {"Canceladas" ,"u_ZZJ080Manut",0,8} )
		aAdd( aRotina, {"Processa"   ,"u_STPREVATU()",0,5} )
		aAdd( aRotina, {"Importar TXT"   ,"u_STCOMIMPORT()",0,5} )
		aAdd( aRotina, {"Motivos de Cancelamento"   ,"u_STSX5Z4()",0,5} )
		aAdd( aRotina, {"Exclui Reg.TXT"   ,"u_STTXTEXC()",0,5} )
		aAdd( aRotina, {"Informar Chegada"   ,"u_STCHEPREV()",0,5} )
		aAdd( aRotina, {"Alt.Massa"   ,"u_COMALT(ZZJ->ZZJ_OP)",0,5} ) 
	EndIf
	
	aCores2    := {;
		{" DTOS(ZZJ_DATA) >= '"+DTOs(DATE())+ "' .and. Empty(Alltrim(ZZJ_CANCEL)) .and. ZZJ_SALDO <> 0 "	, "BR_VERDE"	},; // dentro da alcaçada
	{" !Empty(Alltrim(ZZJ_CANCEL))  "  											, "BR_PRETO"   	},; // Acima do permitido
	{" DTOS(ZZJ_DATA) < '"+DTOs(DATE()) + "' .and. Empty(Alltrim(ZZJ_CANCEL)) .and. ZZJ_SALDO <> 0 "	, "BR_VERMELHO"   	},; // Acima do permitido
	{"  !Empty(Alltrim(ZZJ_DTCHEG))"	, "BR_AZUL" }}	// Abaixo da Alcada
	
	DbSelectArea("ZZJ")
	ZZJ->(DbSetOrder(3))
	mBrowse( 6,1,22,75,'ZZJ',,,,,,aCores2,,,,,,,,)
	
	U_STALTCOM()
	
Return NIL

/*====================================================================================\
|Programa  | ZZJ080Manut    | Autor | GIOVANI.ZAGO               | Data | 10/01/2013  |
|=====================================================================================|
|Descrição | Manutenção do Menu										                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | ZZJ080Manut                                                              |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*---------------------------------------------------*
User Function ZZJ080Manut( cAlias, nReg, nOpcx )
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
	Private aTela[0][0],aGets[0]
	Private aHeader  := {}
	Private aCols    := {}
	Private _cOrd    := 'Numero'
	Private oDlgEsp
	Private _oDados
	Private _cProd  := space(15)
	Private _cNum   := space(6)
	Private _dData  := Ctod(Space(8))
	Private _cOp    := space(8)
	Private _aButtons	    := {}
	Private nAt             := 0
	Private cAliaszzj  := 'STZZJVAL'
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define a funcao utilizada ( Incl.,Alt.,Visual.,Exclu.)  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ZZJ->(dbSetFilter({||  DTOS(ZZJ_DATA) >= DTOs(DATE())  .and. Empty(Alltrim(ZZJ_CANCEL)) }," DTOS(ZZJ_DATA) >= '"+DTOs(DATE()) + "' .and. Empty(Alltrim(ZZJ_CANCEL)) "))
	
	If nOpcx == 2
		l080Visual  := .T.
		ZZJ->(DbClearFilter())
		ZZJ->(dbSetFilter({||  DTOS(ZZJ_DATA) >= DTOs(DATE())  .and. Empty(Alltrim(ZZJ_CANCEL)) }," DTOS(ZZJ_DATA) >= '"+DTOs(DATE()) + "' .and. Empty(Alltrim(ZZJ_CANCEL)) "))
		//ZZJ->(dbSetFilter({||  ZZJ_CANCEL <> ' ' },"  ZZJ_CANCEL <> ' ' "))
		
		
	ElseIf nOpcx == 3        .or. nOpcx == 4
		l080Visual	:= .T.
		
		ZZJ->(DbClearFilter())
		ZZJ->(dbSetFilter({||  ZZJ_CANCEL <> ' ' .And. Empty(Alltrim(ZZJ_DTCHEG)) },"  ZZJ_CANCEL <> ' ' .And. Empty(Alltrim(ZZJ_DTCHEG))"))
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
			If (AllTrim(SX3->X3_CAMPO)$ cVend)
				AAdd(aVisual,SX3->X3_CAMPO)
				If l080Copia
					M->&(cCampo) := Space(SX3->X3_TAMANHO)
				Endif
			EndIf
		EndIf
		//-- Acrescenta no array aCmpUser os campos criados pelo usuario.
		If SX3->X3_PROPRI == 'U' .And. SX3->X3_BROWSE <> 'S'
			AAdd(aCmpUser ,cCampo)
		EndIf
		SX3->(DbSkip())
	EndDo
	
	//-- Varre o array cCmpUser para definir se os campos de usuarios vao aparecer no aCols ou no aHeader.
	If	Len(aCmpUser) == 0
		AAdd(aVisual,"NOUSER")
	Else
		AEval(aCmpUser,{|x| AAdd(aNoFields,x)})
	EndIf
	
	//-- Array contendo os campos que nao estarao no aHeader
	
	aNoFields := {'ZZJ_REPRO','ZZJ_HREPRO','ZZJ_USUARI','ZZJ_USEREP','ZZJ_NOME','ZZJ_DTCHEG'}
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montagem do AHEADER e ACOLS para GetDados  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If l080Inclui
		FillGetDados(nOpcx,cString,1,,,,aNoFields,,,,,.T.,,,)
	Else
		If l080Copia
			cSeekDC6 := xFilial(cString)
		Else
			cSeekDC6 := xFilial(cString)
		EndIf
		cWhile   := cString+'->'+cFilVend
		
		FillGetDados(nOpcx,cString,1,cSeekDC6,{|| &cWhile },,aNoFields,,,,,,,,,)
		aCols := aSort( aCols ,,, { |x,y| x[Ascan(aHeader,{|x| AllTrim(x[2])==(cVend)})] < y[Ascan(aHeader,{|x| AllTrim(x[2])==(cVend)})] } )
	EndIf
	
	//-- Dimensoes padroes
	aSize := MsAdvSize()
	AAdd( aObjects, { 100, 32, .T., .T. } )
	AAdd( aObjects, { 200, 200, .T., .T. } )
	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
	aPosObj := MsObjSize( aInfo, aObjects,.T.)
	
	Inclui := ((l080Inclui).Or.(l080Altera).Or.(l080Copia)) //-- Impede que a Descrição apaceca na inclusão de itens durante a alteracao
	
	AAdd(aVisual,"NOUSER")
	If nOpcx = 2
		aAdd(_aButtons,{"DBG06"  , {|| u_STMENPREV()} ,"Pedidos"})
	EndIf
	DEFINE MSDIALOG oDlgEsp TITLE cCadastro FROM aSize[7],00 TO aSize[6],aSize[5] OF oMainWnd PIXEL
	
	
	@ 05,04 SAY "Ordena:" PIXEL OF oDlgEsp
	@ 15,04 COMBOBOX _cOrd ITEMS {"Numero","Produto","Data","Referencia"} Size 60,10 valid StOrdAcols(_cOrd) PIXEL OF oDlgEsp
	
	@ 05,70 SAY "Pesquisa:" PIXEL OF oDlgEsp
	
	@ 15,70 MsGet _cNum  Size 50,10 valid StPesAcols(_cOrd) PIXEL OF oDlgEsp when _cOrd = "Numero"
	
	@ 15,120 MsGet _cProd  Size 50,10 valid StPesAcols(_cOrd) PIXEL OF oDlgEsp  when _cOrd = "Produto"
	
	@ 15,170 MsGet _dData  Size 50,10 valid StPesAcols(_cOrd) PIXEL OF oDlgEsp when _cOrd = "Data"
	
	@ 15,230 MsGet _cOp  Size 50,10 valid StPesAcols(_cOrd) PIXEL OF oDlgEsp when _cOrd = "Referencia"
	
	_oDados:=MSNewGetDados():New(aPosObj[2,1], aPosObj[2,2] , aPosObj[2,3], aPosObj[2,4], iif(!l080Visual,GD_INSERT+GD_UPDATE,)/*+GD_DELETE*/,"U_ZZJLinOK", "U_ZZJTudOK" , /*"+"+cVend*/ , , 	  ,9999		,,,,oDlgEsp,aHeader,aCols)
	//_oDados:AddAction (  cGrup, msgInfo('tesr') )
	ACTIVATE MSDIALOG oDlgEsp ON INIT EnchoiceBar(oDlgEsp,{||Iif(u_ZZJTudOK(),(nOpca := 1,oDlgEsp:End()),nOpcA:=0)},{||nOpcA:=0,oDlgEsp:End()},,_aButtons)
	
	If nOpca == 1 .And. !l080Visual
		If	nOpca == 1
			ZZJGrava(nOpcx)
		EndIf
	EndIf
	ZZJ->(DbClearFilter())
	RestArea(aAreaAnt)
	
Return( nOpca )

/*====================================================================================\
|Programa  | ZZJGrava       | Autor | GIOVANI.ZAGO               | Data | 10/01/2013  |
|=====================================================================================|
|Descrição | Grava os Dados                                                           |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | ZZJGrava                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*---------------------------------------------------*
Static Function ZZJGrava(nOpcx)
	*---------------------------------------------------*
	
	Local nCntFor   := 0
	Local nCntFo1   := 0
	Local nPosCpo   := 0
	Local nItem     := 0
	Local n030Index :=(cString)->(IndexOrd())
	Local lDbseek   := .F.
	Local _cLog     := ''
	
	Begin Transaction
		
		(cString)->(DbSetOrder(3))
		For nCntFor := 1 To Len(_oDados:aCols)
			If	!_oDados:aCols[nCntFor,Len(_oDados:aCols[nCntFor])]
				If	(cString)->(DbSeek(xFilial(cString)+_oDados:aCols[nCntFor,Ascan(aHeader,{|x| AllTrim(x[2])==(cVend)})] ))
					If 		Alltrim((cString)->&cNomVend)  <> Alltrim(_oDados:aCols[nCntFor,Ascan(aHeader,{|x| AllTrim(x[2])==(cNomVend)})]) ;
							.Or. (cString)->&cGrup     		   <> _oDados:aCols[nCntFor,Ascan(aHeader,{|x| AllTrim(x[2])==(cGrup)})] ;
							.Or. Alltrim( (cString)->&cNomOP)  <> Alltrim(_oDados:aCols[nCntFor,Ascan(aHeader,{|x| AllTrim(x[2])==(cNomOP)})]) ;
							.Or. (cString)->&cNomGrup <> _oDados:aCols[nCntFor,Ascan(aHeader,{|x| AllTrim(x[2])==(cNomGrup)})] ;
							.Or. (cString)->&cCance   <> _oDados:aCols[nCntFor,Ascan(aHeader,{|x| AllTrim(x[2])==(cCance)})] ;
							.Or. (cString)->&cTransp  <> _oDados:aCols[nCntFor,Ascan(aHeader,{|x| AllTrim(x[2])==(cTransp)})]
						
						RecLock(cString,.F.)
						_cLog:= _oDados:aCols[nCntFor,Ascan(aHeader,{|x| AllTrim(x[2])==('ZZJ_MHISTO')})]+CR+CR+'ALTERADO: '+DTOC(DATE())+' - '+TIME() +' - '+CUSERNAME+__cUserId+CR+Alltrim( (cString)->&cNomOP)+' - '+Alltrim((cString)->&cNomVend)+' - '+cvaltochar((cString)->&cGrup)+' - '+dtos((cString)->&cNomGrup)
						(cString)->ZZJ_MHISTO := _cLog
						
						(cString)->&cFilVend  := xFilial(cString)
						(cString)->&cVend     := _oDados:aCols[nCntFor,Ascan(aHeader,{|x| AllTrim(x[2])==(cVend)})]
						(cString)->&cNomVend  := _oDados:aCols[nCntFor,Ascan(aHeader,{|x| AllTrim(x[2])==(cNomVend)})]
						(cString)->&cGrup     := _oDados:aCols[nCntFor,Ascan(aHeader,{|x| AllTrim(x[2])==(cGrup)})]
						(cString)->&cNomGrup  := _oDados:aCols[nCntFor,Ascan(aHeader,{|x| AllTrim(x[2])==(cNomGrup)})]
						(cString)->ZZJ_USUARI := __cUserId
						(cString)->ZZJ_NOME	  := cUserName
						(cString)->&cNomOP    := _oDados:aCols[nCntFor,Ascan(aHeader,{|x| AllTrim(x[2])==(cNomOP)})]
						(cString)->&cCance    := _oDados:aCols[nCntFor,Ascan(aHeader,{|x| AllTrim(x[2])==(cCance)})]
						(cString)->&cTransp   := _oDados:aCols[nCntFor,Ascan(aHeader,{|x| AllTrim(x[2])==(cTransp)})]
						(cString)->ZZJ_ALT    := '1'
						(cString)->&cAlter    := _oDados:aCols[nCntFor,Ascan(aHeader,{|x| AllTrim(x[2])==(cAlter)})]
						//	(cString)->ZZJ_JOB    := '1'
						MsUnLock()
						DbCommit()
						
					EndIf
				Else
					RecLock(cString,.T.)
					
					_cLog:= DTOC(DATE())+' - '+TIME() +' - '+CUSERNAME
					(cString)->ZZJ_MHISTO:=	_cLog
					(cString)->&cFilVend  := xFilial(cString)
					(cString)->&cVend     := _oDados:aCols[nCntFor,Ascan(aHeader,{|x| AllTrim(x[2])==(cVend)})]
					(cString)->&cNomVend  := _oDados:aCols[nCntFor,Ascan(aHeader,{|x| AllTrim(x[2])==(cNomVend)})]
					(cString)->&cGrup     := _oDados:aCols[nCntFor,Ascan(aHeader,{|x| AllTrim(x[2])==(cGrup)})]
					(cString)->&cNomGrup  := _oDados:aCols[nCntFor,Ascan(aHeader,{|x| AllTrim(x[2])==(cNomGrup)})]
					(cString)->ZZJ_USUARI := __cUserId
					(cString)->ZZJ_NOME	  := cUserName
					(cString)->&cNomOP    := _oDados:aCols[nCntFor,Ascan(aHeader,{|x| AllTrim(x[2])==(cNomOP)})]
					(cString)->&cCance    := _oDados:aCols[nCntFor,Ascan(aHeader,{|x| AllTrim(x[2])==(cCance)})]
					(cString)->&cTransp   := _oDados:aCols[nCntFor,Ascan(aHeader,{|x| AllTrim(x[2])==(cTransp)})]
					(cString)->&cAlter    := _oDados:aCols[nCntFor,Ascan(aHeader,{|x| AllTrim(x[2])==(cAlter)})]
					MsUnLock()
					DbCommit()
				EndIf
			EndIf
			
		Next nCntFor
		
		EvalTrigger()
	End Transaction
	
	
Return NIL

/*====================================================================================\
|Programa  | ZZJLinOK       | Autor | GIOVANI.ZAGO               | Data | 10/01/2013  |
|=====================================================================================|
|Descrição | Validação do linha do Acols   							                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | ZZJLinOK                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*---------------------------------------------------*
User Function ZZJLinOK()
	*---------------------------------------------------*
	
	Local lRet       := .T.
	Local cGruop     := _oDados:aCols[_oDados:nat,Ascan(aHeader,{|x| AllTrim(x[2])==cNomVend})]
	Local cAtivSai   := ""
	Local nLin       :=0
	Local i
	Local cxGruop     := _oDados:aCols[_oDados:nat,Ascan(aHeader,{|x| AllTrim(x[2])==cNomGrup})]
	
	For i := 1 To Len(_oDados:aCols)
		If	!_oDados:aCols[i,Len(_oDados:aCols[i])]
			If 	cGruop   = _oDados:aCols[i,Ascan(aHeader,{|x| AllTrim(x[2])==cNomVend})]     .And. 	cxGruop   = _oDados:aCols[i,Ascan(aHeader,{|x| AllTrim(x[2])==cNomGrup})]
				nLin++
			EndIf
		EndIf
	Next  i
	
	If nLin > 1
		lRet       := .F.
		MsgInfo('Produto/Data Já Cadastrado')
	EndIf
	
	
	If Empty(Alltrim(_oDados:aCols[1,Ascan(aHeader,{|x| AllTrim(x[2])==(cVend)})] ))
		_oDados:aCols[1,Ascan(aHeader,{|x| AllTrim(x[2])==(cVend)})] :='000001'
	EndIf
	
Return( lRet )

/*====================================================================================\
|Programa  | ZZJTudOK       | Autor | GIOVANI.ZAGO               | Data | 10/01/2013  |
|=====================================================================================|
|Descrição | Validação do Processo 								                      |
|          |  														                  |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | ZZJTudOK                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*---------------------------------------------------*
User Function ZZJTudOK()
	*---------------------------------------------------*
	
	Local lRet       := .T.
	Local cGruop     := ''
	Local cAtivSai   := ''
	Local nLin     	 :=0
	local nValCom    :=0
	Local nAcols     :=0
	Local i,w
	
	If Empty(Alltrim(_oDados:aCols[1,Ascan(aHeader,{|x| AllTrim(x[2])==(cVend)})] ))
		_oDados:aCols[1,Ascan(aHeader,{|x| AllTrim(x[2])==(cVend)})] :='000001'
	EndIf
	
	For i := 1 To Len(_oDados:aCols)
		If	!_oDados:aCols[i,Len(_oDados:aCols[i])]
			If  _oDados:aCols[i,Ascan(aHeader,{|x| AllTrim(x[2])==(cGrup)})]	= 0
				MsgInfo("Compromisso: "+_oDados:aCols[i,Ascan(aHeader,{|x| AllTrim(x[2])==(cVend)})]+" Zerado...Verifique..!!!!")
				lRet:= .F.
			EndIf
		EndIf
	Next  i
	
Return( lRet )


Static Function StOrdAcols(_cOrd)
	
	If  _cOrd = 'Numero'
		_oDados:aCols := aSort( _oDados:aCols ,,, { |x,y| x[Ascan(aHeader,{|x| AllTrim(x[2])==(cVend)})] < y[Ascan(aHeader,{|x| AllTrim(x[2])==(cVend)})] } )
		_cProd  := space(15)
		_cOp    := space(8)
		_dData  := Ctod(Space(8))
	ElseIf _cOrd = 'Produto'
		_oDados:aCols := aSort( _oDados:aCols ,,, { |x,y| x[Ascan(aHeader,{|x| AllTrim(x[2])==(cNomVend)})]+Dtos(x[Ascan(aHeader,{|x| AllTrim(x[2])==(cNomGrup)})]) < y[Ascan(aHeader,{|x| AllTrim(x[2])==(cNomVend)})]+Dtos(y[Ascan(aHeader,{|x| AllTrim(x[2])==(cNomGrup)})]) } )
		
		_cNum   := space(6)
		_dData  := Ctod(Space(8))
		_cOp    := space(8)
	ElseIf _cOrd = 'Data'
		_oDados:aCols := aSort( _oDados:aCols ,,, { |x,y| Dtos(x[Ascan(aHeader,{|x| AllTrim(x[2])==(cNomGrup)})]) < Dtos(y[Ascan(aHeader,{|x| AllTrim(x[2])==(cNomGrup)})]) } )
		_cProd  := space(15)
		_cNum   := space(6)
		_cOp    := space(8)
	ElseIf _cOrd = "Referencia"
		_oDados:aCols := aSort( _oDados:aCols ,,, { |x,y| x[Ascan(aHeader,{|x| AllTrim(x[2])==(cNomOP)})] < y[Ascan(aHeader,{|x| AllTrim(x[2])==(cNomOP)})] } )
		_cProd  := space(15)
		_cNum   := space(6)
		_dData  := Ctod(Space(8))
	EndIf
	_oDados:forcerefresh()
	oDlgEsp:refresh()
Return (.T.)

Static Function StPesAcols(_cOrd)
	
	Local nY := 0
	
	
	If  _cOrd = 'Numero'
		nY := aScan(_oDados:aCols,{|x| x[Ascan(aHeader,{|x| AllTrim(x[2])==(cVend)})] == _cNum})
	ElseIf _cOrd = 'Produto'
		nY := aScan(_oDados:aCols,{|x| x[Ascan(aHeader,{|x| AllTrim(x[2])==(cNomVend)})] == _cProd})
	ElseIf _cOrd = 'Data'
		nY := aScan(_oDados:aCols,{|x| Dtos(x[Ascan(aHeader,{|x| AllTrim(x[2])==(cNomGrup)})]) == Dtos(_dData)  })
	ElseIf _cOrd = "Referencia"
		nY := aScan(_oDados:aCols,{|x| x[Ascan(aHeader,{|x| AllTrim(x[2])==(cNomOP)})] == _cOp})
	EndIf
	
	
	If nY > 0
		_oDados:nat:=nY
		_oDados:GoTo ( nY )
	EndIf
	_oDados:refresh(.T.)
	oDlgEsp:refresh()
Return (.T.)



/*====================================================================================\
|Programa  | xLegendAlca    | Autor | GIOVANI.ZAGO              | Data | 06/012/2013  |
|=====================================================================================|
|Descrição | Opçoes do Menu											                  |
|          | 													                      |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | xLegendAlca                                                              |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*---------------------------------------------------*
User Function LegendZZJ()
	*---------------------------------------------------*
	Local	aLegenda:= {;
		{"BR_VERDE" 	,'Dentro do Prazo'},;
		{"BR_PRETO" 	,'Canceladas'},;
		{"BR_VERMELHO"  ,'Encerradas'},;
		{"BR_AZUL"		,'Atendido'}}
	
	
	BrwLegenda("Compromisso","Legenda",aLegenda)
	
Return
/*====================================================================================\
|Programa  | xLegendAlca    | Autor | GIOVANI.ZAGO              | Data | 06/012/2013  |
|=====================================================================================|
|Descrição | Opçoes do Menu											                  |
|          | 													                      |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | xLegendAlca                                                              |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*---------------------------------------------------*
User Function ZZJNEXTNUM()
	Local _cRet := '000000'
	Local _aArea	:= GetArea()
	Local cAliasLif  := 'TMPB2'
	Local cQuery     := ' '
	Local _nPosNum := 0
	Local h:=1
	
	If ! GetMv("ST_PREV2",,.F.) //TESTE TA DANDO ERRO NISSO AQUI
		return(IIF(INCLUI,GETSXENUM("ZZJ","ZZJ_NUM"),ZZJ->ZZJ_NUM) )
		//IIF(INCLUI,GETSXENUM("ZZJ","ZZJ_NUM"),ZZJ->ZZJ_NUM)
	EndIf
	_nPosNum := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "ZZJ_NUM"})    // Codigo
	
	
	cQuery := " SELECT ZZJ_NUM
	cQuery += " FROM "+RetSqlName("ZZJ")+" ZZJ "
	cQuery += " ORDER BY ZZJ_NUM DESC
	
	
	cQuery := ChangeQuery(cQuery)
	
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf
	
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
	dbSelectArea(cAliasLif)
	If  Select(cAliasLif) > 0
		(cAliasLif)->(dbgotop())
		
		_cRet 	:= (cAliasLif)->ZZJ_NUM
		
	EndIf
	
	
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf
	
	If ValType(aCols) <> "U"
		
		For h:=1 To Len(Acols)
			If val(Alltrim(_cRet)) <  val(Alltrim(aCols[h,_nPosNum]))
				_cRet:=Alltrim(aCols[h,_nPosNum])
			EndIf
		Next h
		
	EndIf
	If Empty(Alltrim(_cRet))
		_cRet:= '000000'
	EndIf
	_cRet:=soma1(_cRet)
Return(_cRet)


User Function STZZJVAL()
	Local _lRezzj := .F.
	Local _nQtAcol:= 0
	Local _nQuer  := 0
	Local _nPosQtd:= 0
	Local _nPosCod:= 0
	Local cQuery     := ' '
	Local cFunName := Upper(FunName())
	Local h := 0
	If !("STPREV2" $ cFunName)
		Return(U_STVALPREV2())
	EndIf
	
	
	
	_nPosQtd:= aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "ZZJ_QUANT"})    // quantidade
	_nPosCod:= aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "ZZJ_COD"})    // produto
	
	For h:=1 To Len(Acols)
		If Alltrim(aCols[n,_nPosCod]) ==  Alltrim(aCols[h,_nPosCod])
			_nQtAcol += aCols[h,_nPosQtd]
		EndIf
	Next h
	
	//_nQtAcol -= aCols[n,_nPosQtd] M->ZZJ_QUANT
	
	cQuery := " SELECT
	cQuery += " SUM(SC7.C7_QUANT - SC7.C7_QUJE )
	cQuery += ' "VALOR"
	
	cQuery += " FROM "+RetSqlName("SC7")+" SC7
	cQuery += " WHERE SC7.D_E_L_E_T_ = ' '
	cQuery += " AND SC7.C7_PRODUTO = '"+ Alltrim(aCols[n,_nPosCod])+"'
	cQuery += " AND SC7.C7_QUANT > SC7.C7_QUJE
	cQuery += " AND SC7.C7_RESIDUO = ' '
	cQuery += " AND SC7.C7_FILIAL  = '"+XFILIAL("SC7")+"'
	cQuery := ChangeQuery(cQuery)
	
	If Select(cAliaszzj) > 0
		(cAliaszzj)->(dbCloseArea())
	EndIf
	
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliaszzj)
	dbSelectArea(cAliaszzj)
	If  Select(cAliaszzj) > 0
		(cAliaszzj)->(dbgotop())
		
		_nQuer 	:= (cAliaszzj)->VALOR
		
	EndIf
	
	
	If _nQuer - _nQtAcol >= M->ZZJ_QUANT
		_lRezzj := .T.
	Else
		MsgInfo("Quantidade Superior ao Saldo do Pedido de Compras...!!!"+CR+CR+"Saldo Disponivel: "+ cvaltochar(_nQuer - _nQtAcol))
	EndIf
	
Return(_lRezzj)




User Function STSX5Z4()
	Local aTabelas := {}
	Local oDlgTabe
	Local nQ:=1
	Local n := 1
	Private NOPCX,NUSADO,AHEADER,ACOLS,ARECNO
	Private _CCODFIL,_CCHAVE,_CDESCRI,NQ,_NITEM,NLINGETD
	Private CTITULO,AC,AR,ACGD,CLINHAOK,CTUDOOK
	Private LRETMOD2,N
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Opcao de acesso para o Modelo 2 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	// 3,4 Permitem alterar getdados e incluir linhas
	// 6 So permite alterar getdados e nao incluir linhas
	// Qualquer outro numero so visualiza
	nOpcx    := 3
	nUsado   := 0
	aHeader  := {}
	aCols    := {}
	aRecNo   := {}
	cTabela  := "Z4"
	_cTabela := cTabela // Defina aqui a Tabela para edicao
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona a filial corrente ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_cCodFil := xFilial("SX5")
	//_cCodFil := cFilAnt
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montando aHeader ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek("SX5")
	While !Eof() .And. (X3_ARQUIVO == "SX5")
		If X3USO(X3_USADO) .And. cNivel >= X3_NIVEL
			If AllTrim(X3_CAMPO) $ "X5_DESCRI*X5_CHAVE"
				nUsado:=nUsado+1
				Aadd(aHeader,{ AllTrim(x3_titulo), x3_campo, x3_Picture,;
					x3_tamanho, x3_decimal, x3_Valid ,;
					x3_usado, x3_tipo, x3_arquivo, x3_context } )
			EndIf
		EndIf
		dbSkip()
	End
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona o Cabecalho da Tabela a ser editada (_cTabela) ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SX5")
	dbSetOrder(1)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cabecalho da tabela, filial ‚ vazio ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !dbSeek(xFilial("SX5")+"00"+_cTabela)
		MsgStop("O cabeçalho da tabela "+ _cTabela +" não foi encontrado. Cadastre a tabela Z4(SX5) para prosseguir.","Atenção","STOP" )
		Return
	EndIf
	_cChave  := AllTrim(SX5->X5_CHAVE)
	_cDescri := SubStr(SX5->X5_DESCRI,1,35)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montando aCols - Posiciona os itens da tabela conforme a filial corrente ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSeek(_cCodFil+_cTabela)
	While !Eof() .And. SX5->X5_FILIAL == _cCodFil .And. SX5->X5_TABELA==_cTabela
		Aadd(aCols ,Array(nUsado+1))
		Aadd(aRecNo,Array(nUsado+1))
		For nQ:=1 to nUsado
			aCols[Len(aCols),nQ]  := FieldGet(FieldPos(aHeader[nQ,2]))
			aRecNo[Len(aCols),nQ] := FieldGet(FieldPos(aHeader[nQ,2]))
		Next
		aRecNo[Len(aCols),nUsado+1] := RecNo()
		aCols[Len(aCols),nUsado+1]  := .F.
		dbSelectArea("SX5")
		dbSkip()
	EndDo
	
	_nItem := Len(aCols)
	If Len(aCols)==0
		Aadd(aCols,Array(nUsado+1))
		For nQ:=1 to nUsado
			aCols[Len(aCols),nQ]:= CriaVar(FieldName(FieldPos(aHeader[nQ,2])))
		Next
		aCols[Len(aCols),nUsado+1] := .F.
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis do Rodape do Modelo 2 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nLinGetD:=0
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Titulo da Janela ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cTitulo := _cDescri
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Array com descricao dos campos do Cabecalho do Modelo 2      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aC:={}
	Aadd(aC,{"_cChave" ,{15,10} ,"Tabela"   ,"@!"," ","",.f.})
	Aadd(aC,{"_cDescri",{15,58} ,"Descricao","@!"," ","",.f.})
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Nao utiliza o rodape, apesar de passar para Modelo 2         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aR:={}
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Array com coordenadas da GetDados no modelo2 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aCGD:={44,5,118,315}
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Validacoes na GetDados da Modelo 2 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cLinhaOk:= "(!Empty(aCols[n,2]) .Or. aCols[n,3])"
	cTudoOk := "AllwaysTrue()"
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Chamada da Modelo2 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lRetMod2 := .F.
	N        := 1
	lRetMod2 := Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk,{"X5_CHAVE","X5_DESCRI"})
	
	If lRetMod2
		
		Begin Transaction
			
			dbSelectAre("SX5")
			dbSetOrder(1)
			For n := 1 to Len(aCols)
				If aCols[n,Len(aHeader)+1] == .T.
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Filial e Chave e a chave indepEndente da descricao		 ³
					//³ que pode ter sido alterada               					 ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If dbSeek(_cCodFil+_cTabela+aCols[n,1])
						RecLock("SX5",.F.,.T.)
						dbDelete()
						MsUnlock()
					EndIf
				Else
					If dbSeek(_cCodFil+_cTabela+aCols[n,1])
						If aCols[n,2] != SX5->X5_DESCRI
							/* Removido\Ajustado - Não executa mais RecLock na X5. Criação/alteração de dados deve ser feita apenas pelo módulo Configurador ou pela rotina de atualização de versão.
							RecLock("SX5",.F.)
							SX5->X5_CHAVE  := aCols[n,1]
							SX5->X5_DESCRI := aCols[n,2]
							MsUnlock()*/
						EndIf
					Else
						If _nItem >= n
							dbGoto(aRecNo[n,3])
							/* Removido\Ajustado - Não executa mais RecLock na X5. Criação/alteração de dados deve ser feita apenas pelo módulo Configurador ou pela rotina de atualização de versão.
							RecLock("SX5",.F.)
							SX5->X5_CHAVE := aCols[n,1]
							SX5->X5_DESCRI:= aCols[n,2]
							MsUnlock()*/
						ElseIf (!Empty(aCols[n,1]))
							/* Removido\Ajustado - Não executa mais RecLock na X5. Criação/alteração de dados deve ser feita apenas pelo módulo Configurador ou pela rotina de atualização de versão.
							RecLock("SX5",.T.)
							SX5->X5_FILIAL := _cCodFil
							SX5->X5_TABELA := _cTabela
							SX5->X5_CHAVE  := aCols[n,1]
							SX5->X5_DESCRI := aCols[n,2]
							MsUnlock()*/
						EndIf
					EndIf
				EndIf
			Next
			
		End Transaction
	EndIf
	
Return(Nil)


User Function STCHEPREV()
	Local cString	:= 'ZZJ'
	Local _cLog  	:= ' '
	Local 	lSaida  := .F.
	Local 	dGetMot := dDataBase
	Local nOpcao 	:= 0
	
	If MsgYesNO("Deseja Informar a Data de Chegada ?")
		While !lSaida
			
			Define msDialog oDlg Title "Motivo da rejeição" From 10,10 TO 20,65 Style DS_MODALFRAME
			
			@ 000,001 Say "Motivo: " Pixel Of oDlg
			@ 010,003 MsGet dGetMot valid !empty(dGetMot) size 200,10 Picture "@!" pixel OF oDlg
			DEFINE SBUTTON FROM 50,20 TYPE 1 ACTION (nOpcao:=1,lSaida:=.T.,oDlg:End()) ENABLE OF oDlg
			
			Activate dialog oDlg centered
			
		End
		
		If nOpcao = 1
			
			RecLock(cString,.F.)
			_cLog:= DTOC(DATE())+' - '+TIME() +' - '+CUSERNAME
			(cString)->ZZJ_MHISTO :=	(cString)->ZZJ_MHISTO + CR + _cLog
			(cString)->ZZJ_DTCHEG :=	dGetMot
			MsUnLock()
			DbCommit()
		EndIf
		
	EndIf
	
Return

User Function STATUSALDO()
	Local _cQuery := " "
	ProcRegua(4) // Numero de registros a processar
	IncProc()
	_cQuery := " UPDATE "+RetSqlName("ZZJ")+" ZZJ SET ZZJ_SALDO = (
	_cQuery += " SELECT NVL(SUM(PA1_QUANT),0) FROM "+RetSqlName("PA1")+" PA1 WHERE PA1.D_E_L_E_T_ = ' ' AND PA1_FILIAL = '"+XFILIAL("PA1")+"' AND PA1_TIPO = '1' AND EXISTS (
	_cQuery += " SELECT * FROM "+RetSqlName("SC6")+" SC6 WHERE SC6.D_E_L_E_T_ = ' ' AND C6_FILIAL = PA1_FILIAL AND SC6.C6_NUM||SC6.C6_ITEM = PA1.PA1_DOC AND SC6.C6_XPREV = ZZJ.ZZJ_NUM))
	_cQuery += " WHERE ZZJ.D_E_L_E_T_ = ' '   AND ZZJ.ZZJ_CANCEL = ' '   AND ZZJ.ZZJ_DTCHEG = ' ' and ZZJ_DATA >= '"+DTOs(DATE())+ "'
	IncProc()
	
	TCSqlExec( _cQuery )
	_cQuery := " UPDATE "+RetSqlName("ZZJ")+" ZZJ SET ZZJ_FALTA = (
	_cQuery += " SELECT NVL(SUM(PA1_QUANT),0) FROM "+RetSqlName("PA1")+" PA1 WHERE PA1.D_E_L_E_T_ = ' ' AND PA1.PA1_CODPRO = ZZJ.ZZJ_COD AND PA1_FILIAL = '"+XFILIAL("PA1")+"' AND PA1_TIPO = '1' )
	_cQuery += " WHERE ZZJ.D_E_L_E_T_ = ' '   AND ZZJ.ZZJ_CANCEL = ' '   AND ZZJ.ZZJ_DTCHEG = ' ' and ZZJ_DATA >= '"+DTOs(DATE())+ "'
	IncProc()
	
	TCSqlExec( _cQuery )
	
	
	IncProc()
	IncProc()
Return()

user Function STTXTEXC()
	Local _nRet := 0
	pUBLIC CCADASTRO:= 'T'
	
	If ZZJ->ZZJ_USUARI = 'TXT'
		_nRet:= AxDeleta("ZZJ",ZZJ->(Recno()),5,,,,,,,,  )
		If _nRet = 1
			RecLock("ZZJ",.F.)
			ZZJ->ZZJ_MHISTO 	:= ZZJ->ZZJ_MHISTO +  "Excluido: " + DTOC(DDATABASE) + "-" + TIME() + " POR: "+ cUserName + chr(13) + chr(10)+REPLICATE("-",80)
			Msunlock()
		Endif
	Else
		MsgInfo("Apenas Compromisso Importados do Txt Poderam ser Excluidos, Demais Deveram ser Cancelados....!!!!")
	Endif
Return()



User Function STALTCOM()
	
	
	Local cAliasLif  := 'STALTCOM'
	Local cQuery     := ' '
	
	
	
	cQuery := " SELECT ZZJ_NUM
	cQuery += " FROM "+RetSqlName("ZZJ")+" ZZJ "
	cQuery += " ORDER BY ZZJ_NUM DESC
	
	
	cQuery := ChangeQuery(cQuery)
	
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf
	
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
	dbSelectArea(cAliasLif)
	If  Select(cAliasLif) > 0
		(cAliasLif)->(dbgotop())
		
		_cRet 	:= (cAliasLif)->ZZJ_NUM
		
	EndIf
	
	
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf
	
	
	
	
	
	
	
	
	
Return()

User function ZZJAJUS()
	
	DbSelectArea("ZZJ")
	ZZJ->(DbSetOrder(3))
	ZZJ->(dbGoTop())
	//If ZZJ->(DbSeek(xFilial("ZZJ")+'999999'))
	While ZZJ->(!Eof())
		If ZZJ->ZZJ_FILIAL+ZZJ->ZZJ_NUM == xFilial("ZZJ")+'999999'
			RecLock("ZZJ",.F.)
			ZZJ->ZZJ_NUM 	:= GETSXENUM("ZZJ","ZZJ_NUM")
			ZZJ->(MsUnlock())
			ZZJ->(DbCommit())
			ConfirmSX8()
		EndIf
		ZZJ->(DbSkip())
	End
	//Endif
	//mSGinFO("TERMINOU")
Return()

