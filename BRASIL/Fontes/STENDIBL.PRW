#include 'Protheus.ch'
#include 'RwMake.ch'

/*====================================================================================\
|Programa  | STENDIBL       | Autor | GIOVANI.ZAGO               | Data | 10/01/2013  |
|=====================================================================================|
|Descrição | Chama Tela de Cadastro    Ordem Separação X Endereço                     |
|          | 													                      |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STENDIBL                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*---------------------------------------------------*
User Function STENDIBL()
*---------------------------------------------------*

Local aCamVend :={ 'SZ5';   //1
,'Z5_ORDSEP';              //2
,'Z5_ENDEREC';              //3
,'Z5_DTEMISS'  ;              //4
,'Ordem Separação X Endereço';   //5
,'Z5_FILIAL'} //6

U_IBLSTAFAT(aCamVend)

Return

/*====================================================================================\
|Programa  | XSTAFAT        | Autor | GIOVANI.ZAGO               | Data | 10/01/2013  |
|=====================================================================================|
|Descrição | Cria mBrowse 											                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | XSTAFAT                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*---------------------------------------------------*
User Function IBLSTAFAT(aCamVend)
*---------------------------------------------------*

Private cCadastro  := aCamVend[5]
Private aRotina	   := MenuDef()
Private cString    := aCamVend[1]
Private cVend      := aCamVend[2]
Private cNomVend   := aCamVend[3]
Private cGrup      := aCamVend[4]
//Private cComsVend  := aCamVend[5]
Private cFilVend   := aCamVend[6]
//Private cNomGrup   := aCamVend[7]
Private _cFiltro  := "Z5_FILIAL = '"+xFilial("SZ5")


DbSelectArea("SZ5")
SZ5->(DbClearFilter())
mBrowse( 6,1,22,75,"SZ5")
SZ5->(DbClearFilter())
//RetIndex(cString)

Return NIL

/*====================================================================================\
|Programa  | SZ5080Manut    | Autor | GIOVANI.ZAGO               | Data | 10/01/2013  |
|=====================================================================================|
|Descrição | Manutenção do Menu										                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | SZ5080Manut                                                              |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*---------------------------------------------------*
User Function SZ5080Manut( cAlias, nReg, nOpcx )
*---------------------------------------------------*

Local aAreaAnt   := GetArea()
Local nCntFor    := 0
Local nOpca	     := 0
Local oDlgEsp
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
//AAdd( aNoFields, cNomVend )
AAdd( aNoFields, cVend )
AAdd( aNoFields, cVend )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem do AHEADER e ACOLS para GetDados  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If l080Inclui
	FillGetDados(nOpcx,cString,1,,,,aNoFields,,,,,.T.,,,)
Else
	If l080Copia
		cSeekDC6 := xFilial(cString)+(cString)->(&cVend)
	Else
		cSeekDC6 := xFilial(cString)+M->&cVend
	EndIf
	cWhile   := cString+'->'+cFilVend+'+'+cString+'->'+cVend
	
	FillGetDados(nOpcx,cString,1,cSeekDC6,{|| &cWhile },,aNoFields,,,,,,,,,)
	nOrdem := aScan(aHeader,{|x| Trim(x[2])==(cNomVend)})
	//aSort(aCols,,,{|x,y| x[nOrdem]<y[nOrdem]})
EndIf

//-- Dimensoes padroes
aSize := MsAdvSize()
AAdd( aObjects, { 100, 32, .T., .T. } )
AAdd( aObjects, { 200, 200, .T., .T. } )
aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
aPosObj := MsObjSize( aInfo, aObjects,.T.)

Inclui := ((l080Inclui).Or.(l080Altera).Or.(l080Copia)) //-- Impede que a Descrição apaceca na inclusão de itens durante a alteracao

AAdd(aVisual,"NOUSER")
DEFINE MSDIALOG oDlgEsp TITLE cCadastro FROM aSize[7],00 TO aSize[6],aSize[5] OF oMainWnd PIXEL
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a Enchoice                                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
EnChoice( cAlias, nReg, If(l080Copia, 3, nOpcx),,,,aVisual, aPosObj[1], , 3, , , , , ,.T. )

MSGetDados():New(aPosObj[2,1], aPosObj[2,2] , aPosObj[2,3], aPosObj[2,4], If(l080Copia, 4, nOpcx),"U_SZ5LinOK", "U_SZ5TudOK", "+"+cVend, !l080Visual,			 , ,    ,9999)
//MsGetDados():New(05			 , 05			, 145		  , 195			, 4						 , "U_LINHAOK", "U_TUDOOK"	, "+A1_COD", .T.		, {"A1_NOME"}, , .F., 200, "U_FIELDOK", "U_SUPERDEL", , "U_DELOK", oDlg)
ACTIVATE MSDIALOG oDlgEsp ON INIT EnchoiceBar(oDlgEsp,{||If(u_SZ5TudOK(),(nOpca := 1,oDlgEsp:End()),nOpcA:=0)},{||nOpcA:=0,oDlgEsp:End()})

If nOpca == 1 .And. !l080Visual
	If	nOpca == 1
		SZ5Grava(nOpcx)
	EndIf
EndIf

RestArea(aAreaAnt)

Return( nOpca )

/*====================================================================================\
|Programa  | SZ5Grava       | Autor | GIOVANI.ZAGO               | Data | 10/01/2013  |
|=====================================================================================|
|Descrição | Grava os Dados                                                           |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | SZ5Grava                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*---------------------------------------------------*
Static Function SZ5Grava(nOpcx)
*---------------------------------------------------*

Local nCntFor   := 0
Local nCntFo1   := 0
Local nPosCpo   := 0
Local nItem     := 0
Local n030Index :=(cString)->(IndexOrd())
Local lDbseek   := .F.

If	nOpcx == 5 			//Excluir
	(cString)->(DbSetOrder(1))
	While (cString)->(DbSeek(xFilial(cString) + M->&cVend ))
		RecLock(cString,.F.)
		(cString)->(DbDelete())
		MsUnLock()
	EndDo
EndIf

If	nOpcx == 3 .Or. nOpcx == 4 .Or. nOpcx == 6 // Incluir, Alterar ou Copia
	Begin Transaction
	//	nPosCpo := Ascan(aHeader,{|x| AllTrim(x[2])==(cVend)})
	(cString)->(DbSetOrder(1))
	For nCntFor := 1 To Len(aCols)
		If	!aCols[nCntFor,Len(aCols[nCntFor])]
			If	(cString)->(DbSeek(xFilial(cString)+M->&cVend  + aCols[nCntFor,Ascan(aHeader,{|x| AllTrim(x[2])==(cNomVend)})] ))
				RecLock(cString,.F.)
			Else
				RecLock(cString,.T.)
				lDbseek:=.t.
			EndIf
			(cString)->&cFilVend  := xFilial(cString)
			(cString)->&cVend     := M->&cVend
			(cString)->&cNomVend  := aCols[nCntFor,Ascan(aHeader,{|x| AllTrim(x[2])==(cNomVend)})]
			If lDbseek
				(cString)->&cGrup     := ddatabase
			EndIf
			
			MsUnLock()
			DbCommit()
		Else
			If	(cString)->(DbSeek(xFilial(cString)+M->&cVend  + aCols[nCntFor,Ascan(aHeader,{|x| AllTrim(x[2])==(cNomVend)})] ))
				RecLock(cString,.F.)
				(cString)->(DbDelete())
				MsUnLock()
				DbCommit()
			EndIf
		EndIf
	Next
	
	EvalTrigger()
	End Transaction
EndIf
//(cString)->(DbSetOrder(n030Index))

Return NIL

/*====================================================================================\
|Programa  | SZ5LinOK       | Autor | GIOVANI.ZAGO               | Data | 10/01/2013  |
|=====================================================================================|
|Descrição | Validação do linha do Acols   							                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | SZ5LinOK                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*---------------------------------------------------*
User Function SZ5LinOK()
*---------------------------------------------------*

Local lRet       := .T.
Local cGruop     := aCols[n,Ascan(aHeader,{|x| AllTrim(x[2])==cNomVend})]
Local cAtivSai   := ""
Local nLin       :=0
Local i

For i := 1 To Len(aCols)
	If	!aCols[i,Len(aCols[i])]
		If 	cGruop   = aCols[i,Ascan(aHeader,{|x| AllTrim(x[2])==cNomVend})]
			nLin++
		EndIf
	EndIf
Next  i

If nLin > 1
	lRet       := .F.
	MsgInfo('Endereço Já Cadastrado')
EndIf



Return( lRet )

/*====================================================================================\
|Programa  | SZ5TudOK       | Autor | GIOVANI.ZAGO               | Data | 10/01/2013  |
|=====================================================================================|
|Descrição | Validação do Processo 								                      |
|          |  														                  |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | SZ5TudOK                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*---------------------------------------------------*
User Function SZ5TudOK()
*---------------------------------------------------*

Local lRet       := .T.
Local cGruop     := ''
Local cAtivSai   := ''
Local nLin     	 :=0
local nValCom    :=0
Local nAcols     :=0
Local i,w

For i := 1 To Len(aCols)
	If	!aCols[i,Len(aCols[i])]
		nAcols++
		For w := 1 To Len(aCols)
			If	!aCols[w,Len(aCols[i])]
				If aCols[w,Ascan(aHeader,{|x| AllTrim(x[2])==cNomVend})]  = aCols[i,Ascan(aHeader,{|x| AllTrim(x[2])==cNomVend})]
					nLin++
				EndIf
			EndIf
		Next  w
	EndIf
Next  i

If (nLin-nAcols) > 1
	lRet       := .F.
	MsgInfo('Endereço Duplicado, Verifique!!!!!')
EndIf



Return( lRet )

/*====================================================================================\
|Programa  | MenuDef        | Autor | GIOVANI.ZAGO               | Data | 10/01/2013  |
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
{ "Visualizar" ,"u_SZ5080Manut" ,0 ,2 ,0 ,Nil},;  //"Visualizar"
{ "Incluir" ,"u_SZ5080Manut" ,0 ,3 ,0 ,Nil},;  //"Incluir"
{ "Alterar" ,"u_SZ5080Manut" ,0 ,4 ,0 ,Nil},;  //"Alterar"
{ "Excluir" ,"u_SZ5080Manut" ,0 ,5 ,0 ,Nil},;  //"Excluir"
{ "Copiar" ,"u_SZ5080Manut" ,0 ,6 ,0 ,Nil} }  //"Copiar"


Return(aRotina)
