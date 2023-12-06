#include 'Protheus.ch'
#include 'RwMake.ch'
#DEFINE CR    chr(13)+chr(10)
/*====================================================================================\
|Programa  | AFAT002        | Autor | GIOVANI.ZAGO               | Data | 10/01/2013  |
|=====================================================================================|
|Descrição | Chama Tela de Cadastro    VENDEDOR REPRESENTANTE X GRUPO DE PRODUTOS     |
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
User Function STCAM2()
*---------------------------------------------------*

Local aCamVend :={ 'SZ3';   //1
,'Z3_VENDEDO';              //2
,'Z3_NOMVEND';              //3
,'Z3_GRUPO'  ;              //4
,'Z3_COMIS'  ;              //5
,'Z3_FILIAL' ;              //6
,'Z3_NOMGRUP';              //7
,'VENDEDOR REPRESENTANTE X GRUPO DE PRODUTOS'; //8
,'Z3_LOG'} //9

U_XSTAFAT(aCamVend)

Return

/*====================================================================================\
|Programa  | AFAT001        | Autor | GIOVANI.ZAGO               | Data | 10/01/2013  |
|=====================================================================================|
|Descrição | Chama Tela de Cadastro    VENDEDOR REPRESENTANTE X  PRODUTOS             |
|          | 													                      |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | AFAT001                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*---------------------------------------------------*
User Function AFAT003()
*---------------------------------------------------*

Local aCamVend :={ 'SZ2';   //1
,'Z2_VENDEDO';              //2
,'Z2_NOMVEND';              //3
,'Z2_PRODUTO';              //4
,'Z2_COMIS'  ;              //5
,'Z2_FILIAL' ;              //6
,'Z2_NOMPROD';              //7
,'VENDEDOR REPRESENTANTE X  PRODUTOS';//8
,'Z2_LOG'} //9
U_XSTAFAT(aCamVend)

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
User Function XSTAFAT(aCamVend)
*---------------------------------------------------*

Private cCadastro  := aCamVend[8]
Private aRotina	   := MenuDef()
Private cString    := aCamVend[1]
Private cVend      := aCamVend[2]
Private cNomVend   := aCamVend[3]
Private cGrup      := aCamVend[4]
Private cComsVend  := aCamVend[5]
Private cFilVend   := aCamVend[6]
Private cNomGrup   := aCamVend[7]
Private cLog       := aCamVend[9]
Private cST_USRCOMIS    := SuperGetMV("ST_USRCOMIS",,"000000")  +'/000000'
Private _aEmail    := {}

If __cUserId $ cST_USRCOMIS
	
   /*	(cString)->(DbSetOrder(1))
	
	mBrowse( 6,1,22,75,cString)
	
	RetIndex(cString)
	*/
DbSelectArea(cString)
(cString)->(DbClearFilter())
(cString)->(DbSetOrder(1))
mBrowse( 6,1,22,75,cString)
(cString)->(DbClearFilter())
EndIf
Return NIL

/*====================================================================================\
|Programa  | SZ3080Manut    | Autor | GIOVANI.ZAGO               | Data | 10/01/2013  |
|=====================================================================================|
|Descrição | Manutenção do Menu										                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | SZ3080Manut                                                              |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*---------------------------------------------------*
User Function SZ3080Manut( cAlias, nReg, nOpcx )
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
		If (AllTrim(SX3->X3_CAMPO)$ (cVend+"."+cNomVend))
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
AAdd( aNoFields, cNomVend )
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
	nOrdem := aScan(aHeader,{|x| Trim(x[2])==(cGrup)})
	aSort(aCols,,,{|x,y| x[nOrdem]<y[nOrdem]})
EndIf

//-- Dimensoes padroes
aSize := MsAdvSize()
AAdd( aObjects, { 100, 32, .T., .T. } )
AAdd( aObjects, { 200, 200, .T., .T. } )
aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
aPosObj := MsObjSize( aInfo, aObjects,.T.)

Inclui := ((l080Inclui).Or.(l080Altera).Or.(l080Copia)) //-- Impede que a Descrição apaceca na inclusão de itens durante a alteracao

DEFINE MSDIALOG oDlgEsp TITLE cCadastro FROM aSize[7],00 TO aSize[6],aSize[5] OF oMainWnd PIXEL
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a Enchoice                                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
EnChoice( cAlias, nReg, If(l080Copia, 3, nOpcx),,,,aVisual, aPosObj[1], , 3, , , , , ,.T. )

MSGetDados():New(aPosObj[2,1], aPosObj[2,2] , aPosObj[2,3], aPosObj[2,4], If(l080Copia, 4, nOpcx),"U_SZ3LinOK", "U_SZ3TudOK", "+"+cVend, !l080Visual,			 , ,    ,9999)
//MsGetDados():New(05			 , 05			, 145		  , 195			, 4						 , "U_LINHAOK", "U_TUDOOK"	, "+A1_COD", .T.		, {"A1_NOME"}, , .F., 200, "U_FIELDOK", "U_SUPERDEL", , "U_DELOK", oDlg)
ACTIVATE MSDIALOG oDlgEsp ON INIT EnchoiceBar(oDlgEsp,{||If(u_SZ3TudOK(),(nOpca := 1,oDlgEsp:End()),nOpcA:=0)},{||nOpcA:=0,oDlgEsp:End()})

If nOpca == 1 .And. !l080Visual
	If	nOpca == 1
		SZ3Grava(nOpcx)
	EndIf
EndIf

RestArea(aAreaAnt)

Return( nOpca )

/*====================================================================================\
|Programa  | SZ3Grava       | Autor | GIOVANI.ZAGO               | Data | 10/01/2013  |
|=====================================================================================|
|Descrição | Grava os Dados                                                           |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | SZ3Grava                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*---------------------------------------------------*
Static Function SZ3Grava(nOpcx)
*---------------------------------------------------*

Local nCntFor   := 0
Local nCntFo1   := 0
Local nPosCpo   := 0
Local nItem     := 0
Local n030Index :=(cString)->(IndexOrd())

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
	nPosCpo := Ascan(aHeader,{|x| AllTrim(x[2])==(cGrup)})
	(cString)->(DbSetOrder(1))
	For nCntFor := 1 To Len(aCols)
		If	!aCols[nCntFor,Len(aCols[nCntFor])]
			If	(cString)->(DbSeek(xFilial(cString) + M->&cVend + aCols[nCntFor,nPosCpo] ))
				RecLock(cString,.F.)
				If nOpcx == 4
					If  	(cString)->&cComsVend <> aCols[nCntFor,Ascan(aHeader,{|x| AllTrim(x[2])==(cComsVend)})]
						Aadd(_aEmail,{'Alterado',(cString)->&cGrup,(cString)->&cNomGrup ,CVALTOCHAR((cString)->&cComsVend),cvaltochar(aCols[nCntFor,Ascan(aHeader,{|x| AllTrim(x[2])==(cComsVend)})]) })
						(cString)->&cLog 	  := (cString)->&cLog+CR+CR+'Alterado: '+DTOC(DATE())+' - '+TIME() +' - '+CUSERNAME+' - '+__cUserId ;
						+CR+'Codigo:'+alltrim((cString)->&cGrup)+' - Descrição: '+alltrim((cString)->&cNomGrup)+' - De: '+ CVALTOCHAR((cString)->&cComsVend) +' - Para: '+ cvaltochar(aCols[nCntFor,Ascan(aHeader,{|x| AllTrim(x[2])==(cComsVend)})])
					EndIf
				EndIf
				
			Else
				RecLock(cString,.T.)
				If nOpcx == 4
					Aadd(_aEmail,{'Incluido',alltrim(aCols[nCntFor,Ascan(aHeader,{|x| AllTrim(x[2])==(cGrup)})]),alltrim(aCols[nCntFor,Ascan(aHeader,{|x| AllTrim(x[2])==(cNomGrup)})]) ,'0',cvaltochar(aCols[nCntFor,Ascan(aHeader,{|x| AllTrim(x[2])==(cComsVend)})]) })
					(cString)->&cLog 	  := (cString)->&cLog+CR+CR+'Incluido: '+DTOC(DATE())+' - '+TIME() +' - '+CUSERNAME+' - '+__cUserId ;
					+CR+'Codigo:'+alltrim(aCols[nCntFor,Ascan(aHeader,{|x| AllTrim(x[2])==(cGrup)})])+' - Descrição: '+alltrim(aCols[nCntFor,Ascan(aHeader,{|x| AllTrim(x[2])==(cNomGrup)})])+' -  '+  cvaltochar(aCols[nCntFor,Ascan(aHeader,{|x| AllTrim(x[2])==(cComsVend)})])
					
				EndIf
			EndIf
			(cString)->&cFilVend  := xFilial(cString)
			(cString)->&cVend     := M->&cVend
			(cString)->&cNomVend  := M->&cNomVend
			(cString)->&cGrup     := aCols[nCntFor,Ascan(aHeader,{|x| AllTrim(x[2])==(cGrup)})]
			(cString)->&cNomGrup  := aCols[nCntFor,Ascan(aHeader,{|x| AllTrim(x[2])==(cNomGrup)})]
			(cString)->&cComsVend := aCols[nCntFor,Ascan(aHeader,{|x| AllTrim(x[2])==(cComsVend)})]
			(cString)->(MsUnLock())
			(cString)->(DbCommit())
			
			If 	nOpcx == 3 .Or. nOpcx == 6
				
				Aadd(_aEmail,{'Incluido',(cString)->&cGrup,(cString)->&cNomGrup ,'0',CVALTOCHAR((cString)->&cComsVend) })
				
			EndIf
			
		Else
			If	(cString)->(DbSeek(xFilial(cString) + M->&cVend + aCols[nCntFor,nPosCpo] ))
				Aadd(_aEmail,{'Deletado',(cString)->&cGrup,(cString)->&cNomGrup ,'0','0' })
				RecLock(cString,.F.)
				(cString)->&cLog := 	(cString)->&cLog+CR+CR+'Deletado: '+DTOC(DATE())+' - '+TIME() +' - '+CUSERNAME+' - '+__cUserId
				(cString)->(DbDelete())
				(cString)->(MsUnLock())
				(cString)->(DbCommit())
			EndIf
		EndIf
		
	Next
	
	EvalTrigger()
	End Transaction
EndIf
(cString)->(DbSetOrder(n030Index))

If Len(_aEmail) > 0
	U_AFATMAIL('','',cusername,dtoc(date()),time(),'') 
	_aEmail    := {}
EndIf

Return NIL

/*====================================================================================\
|Programa  | SZ3LinOK       | Autor | GIOVANI.ZAGO               | Data | 10/01/2013  |
|=====================================================================================|
|Descrição | Validação do linha do Acols   							                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | SZ3LinOK                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*---------------------------------------------------*
User Function SZ3LinOK()
*---------------------------------------------------*

Local lRet       := .T.
Local cGruop     := aCols[n,Ascan(aHeader,{|x| AllTrim(x[2])==cGrup})]
Local cAtivSai   := ""
Local nLin       :=0
Local i

For i := 1 To Len(aCols)
	If	!aCols[i,Len(aCols[i])]
		If 	cGruop   = aCols[i,Ascan(aHeader,{|x| AllTrim(x[2])==cGrup})]
			nLin++
		EndIf
	EndIf
Next  i

If nLin > 1
	lRet       := .F.
	MsgInfo('Produto ou Grupo de Produto Já Cadastrado')
EndIf

If aCols[n,Ascan(aHeader,{|x| AllTrim(x[2])==cComsVend})]   < 0   .And. lRet
	lRet       := .F.
	MsgInfo('Valor Da Comissão Incorreto')
EndIf

Return( lRet )

/*====================================================================================\
|Programa  | SZ3TudOK       | Autor | GIOVANI.ZAGO               | Data | 10/01/2013  |
|=====================================================================================|
|Descrição | Validação do Processo 								                      |
|          |  														                  |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | SZ3TudOK                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*---------------------------------------------------*
User Function SZ3TudOK()
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
				If aCols[w,Ascan(aHeader,{|x| AllTrim(x[2])==cGrup})]  = aCols[i,Ascan(aHeader,{|x| AllTrim(x[2])==cGrup})]
					nLin++
				EndIf
				If  aCols[i,Ascan(aHeader,{|x| AllTrim(x[2])==cComsVend})]   < 0
					nValCom++
				EndIf
			EndIf
		Next  w
	EndIf
Next  i

If (nLin-nAcols) > 1
	lRet       := .F.
	MsgInfo('Produto ou Grupo de Produto Duplicado ')
EndIf

If nValCom > 1
	lRet       := .F.
	MsgInfo('Valor Da Comissão Incorreto')
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
{ "Visualizar" ,"u_SZ3080Manut" ,0 ,2 ,0 ,Nil},;  //"Visualizar"
{ "Incluir" ,"u_SZ3080Manut" ,0 ,3 ,0 ,Nil},;  //"Incluir"
{ "Alterar" ,"u_SZ3080Manut" ,0 ,4 ,0 ,Nil},;  //"Alterar"
{ "Excluir" ,"u_SZ3080Manut" ,0 ,5 ,0 ,Nil},;  //"Excluir"
{ "Copiar" ,"u_SZ3080Manut" ,0 ,6 ,0 ,Nil} }  //"Copiar"


Return(aRotina)

/*====================================================================================\
|Programa  | StLibFinMail     | Autor | GIOVANI.ZAGO             | Data | 27/03/2013  |
|=====================================================================================|
|Descrição | StLibFinMail                                                             |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | StLibFinMail                                                             |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*------------------------------------------------------------------*
User Function AFATMAIL(_cObs,_cMot,_cName,_cDat,_cHora,_cEmail)
*------------------------------------------------------------------*

Local aArea 	:= GetArea()
Local _cFrom   := "protheus@steck.com.br"
Local _cAssunto:= 'Cadastro Comissão'
Local cFuncSent:= "AFATMAIL"
Local _aMsg    :={}
Local i        := 0
Local cArq     := ""
Local cMsg     := ""
Local _nLin
Local _cCopia  := ''// "giovani.zago@totvs.com.br;simone.mara@steck.com.br;fabio.brito@steck.com.br;kleber.braga@steck.com.br"
Local cAttach  := ''
Local l		:= 0
_cEmail  := ""

If ( Type("l410Auto") == "U" .OR. !l410Auto )
	
	Aadd( _aMsg , { "Codigo: "          , 	M->&cVend,'Nome: '	,M->&cNomVend,'.'} )
	Aadd( _aMsg , { "Data:"    			, _cDat 	 , "Hora: "	,_cHora		 ,'.'} )
	Aadd( _aMsg , { "Usuario: "    		, _cName 	 ,' '		,' '		 ,'.'} )
	Aadd( _aMsg , { "Tipo"    			, 'Codigo' 	 ,'Descrição','De'		 ,'Ate'} )
	For l:=1 To Len(_aEmail)
		Aadd( _aMsg , { _aEmail[l,1]    	,_aEmail[l,2], _aEmail[l,3], _aEmail[l,4], _aEmail[l,5] } )
	Next l
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Definicao do cabecalho do email                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cMsg := ""
	cMsg += '<html>'
	cMsg += '<head>'
	cMsg += '<title>' + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
	cMsg += '</head>'
	cMsg += '<body>'
	//cMsg += '<Img Src="C:/AP5/SIGAADV/LGRL01.BMP"><BR>'
	cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
	cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
	cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Definicao do texto/detalhe do email                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For _nLin := 1 to Len(_aMsg)
		IF (_nLin/2) == Int( _nLin/2 )
			cMsg += '<TR BgColor=#B0E2FF>'
		Else
			cMsg += '<TR BgColor=#FFFFFF>'
		EndIF
		cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></TD>'
		cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
		cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></TD>'
		cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></TD>'
		cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,5] + ' </Font></TD>'
		cMsg += '</TR>'
	Next
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Definicao do rodape do email                                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cMsg += '</Table>'
	cMsg += '<P>'
	cMsg += '<Table align="center">'
	cMsg += '<tr>'
	cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">('+cFuncSent+')</td>'
	cMsg += '</tr>'
	cMsg += '</Table>'
	cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
	//cMsg += '<B><Font Color=#000000 Size="2" Face="Arial"> Atenciosamente </Font></B><BR>'
	//cMsg += '<B><Font Color=#000000 Size="2" Face="Arial">' + SM0->M0_NOMECOM + '</Font></B><BR>'
	//cMsg += '<Img Src="C:/AP5/SIGAADV/LGRL01.BMP">'
	cMsg += '</body>'
	cMsg += '</html>'
	
	
	If !(   U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,cAttach) )
		MsgInfo("Email não Enviado..!!!!")
		
	EndIf
EndIf
RestArea(aArea)
Return()

