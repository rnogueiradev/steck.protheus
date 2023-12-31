#IFNDEF WINDOWS
	#include "Inkey.ch"
#ELSE
	#include "Fivewin.ch"
#ENDIF
//#INCLUDE "CFGX025.ch"

Static __aUserLg := {}

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � STWFLOG  � Autor � Thiago Godinho       � Data �          ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Permite Visualizacao dos campos para gravacao de Logs      ���
�������������������������������������������������������������������������Ĵ��
���Parametros� Sem Argumentos                                             ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Configurador   � Fun��o Relacionada � Entrada Dados (Todos)���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function STWFLOG() //U_STWFLOG()
Local aArqs := {},cFilter := "",cArq := "",nArq
Local nSavRec:=Recno(),cOldAlias := Alias()
#IFNDEF WINDOWS
	Local cSavCor := SetColor()
	Local cScr := SaveScreen(1,0,24,78)
#ELSE
	Local oDlg,oLbx,lRet := .F.
#ENDIF
Private cCadastro := OemTOAnsi("Consulta Log de Registros") //"Consulta Log de Registros"
PRIVATE aRotina := {  { OemToAnsi("Pesquisar") ,"AxPesqui"  , 0 , 1},; //"Pesquisar"
							 { OemToAnsi("Visualizar"),"u_STVsLog()"  , 0 , 2},; // "Visualizar"
							 { OemToAnsi("Imprimir"),"u_CC025Imp()" 	, 0 , 2}  }	// "Imprimir"

DbSelectarea("SX2")
cFilter := DbFilter()
DbClearFil()
dbGotop()

setNaoUsado( .F. )

#IFNDEF WINDOWS
	SX3->(dbSetOrder(2))
	While !Eof()
		IF SX3->(dbSeek(If(Left(SX2->X2_CHAVE,1) == "S",Subs(SX2->X2_CHAVE,2,2)+"_USERLG",Subs(SX2->X2_CHAVE,1,3)+"_USERG")))
			AADD(aArqs,X2_CHAVE + "  " + X2Nome())
		Endif
		DbSkip()
	End
	SX3->(dbSetOrder(1))
	IF Len(aArqs) == 0
		Help(" ",1,"NOUSERLOG")
		Return .t.
	Endif
	While .T.
	*��������������������������������������������������������������Ŀ
	*� Monta a tela de Bancos de Dados                              �
	*����������������������������������������������������������������
	ScreenDraw("SMT050", 3, 0, 0, 0)
	sombra(6,10,18,45)
	SetColor("n/bg,,,")
	@ 6,10 CLEAR TO 18,45
	SET COLOR TO w/n
	@ 6,10, 6,45 BOX "���������"
	@ 6,23 SAY OemToAnsi(" Arquivos ") //" Arquivos "
	@ 6,10,18,10 BOX "�"
	@ 6,45,18,45 BOX "�"
	SET COLOR TO b/w
	@7,11 CLEAR TO 7,44
	@18,11 CLEAR TO 18,44
	@18,11 Say OemToAnsi("<ENTER>  Seleciona Arquivo")  Color "R/W" // "<ENTER>  Seleciona Arquivo"
	@7,11 SAY OemToAnsi("Arquivo      Descricao") //"Arquivo      Descricao"
	@ 3, 1 Say OemToAnsi("Consulta Log de Registros") //"Consulta Log de Registros"
	*-------------------------------------------------------*
		nOp := 1; nLi:= 1
		SetColor("b/bg,w/n,,,")
		nArq := AChoice(9,11,17,44,aArqs,.T.,"fChoice",nOp,nLi)
		If LastKey() == 27
			Exit
		Endif
		cArq := SubStr(aArqs[nArq],1,3)
		If !SelArq(cArq)
			Loop
		Endif
		SetColor("b/w,,,")

		Set Dele Off
		mBrowse( 6, 1,22,75,cArq,,,,"!Deleted()")
		Set Dele On
		dbSelectArea(cArq)
		dbCloseArea()
	Enddo
	SetColor(cSavCor)
	RestScreen(1,0,24,78,cScr)

#ELSE
	SX3->(dbSetOrder(2))
	While !Eof()
		IF SX3->(dbSeek(If(Left(SX2->X2_CHAVE,1) == "S",Subs(SX2->X2_CHAVE,2,2)+"_USERLG",Subs(SX2->X2_CHAVE,1,3)+"_USERG")))
			AADD(aArqs,{X2_CHAVE ,OemToAnsi(Capital(X2Nome()))})
		Endif
		DbSkip()
	End
	SX3->(dbSetOrder(1))
	IF Len(aArqs) == 0
		Help(" ",1,"NOUSERLOG")
		Return .t.
	Endif
	While .T.
	lRet := .F.
	*��������������������������������������������������������������Ŀ
	*� Monta a tela de Bancos de Dados                              �
	*����������������������������������������������������������������
	DEFINE MSDIALOG oDlg FROM  10,15 TO 23,53 TITLE OemToAnsi("Consulta Log de Registro") // "Consulta Log de Registro"

	@ 11,12 LISTBOX oLbx FIELDS HEADER OemToAnsi("Arq    "),OemToAnsi("Descri��o")  SIZE 131, 69 OF oDlg PIXEL ; // "Arq    " ###  "Descri��o"
				ON CHANGE (nArq:=oLbx:nAt) ON DBLCLICK (lRet := .T.,nArq := oLbx:nAt,oDlg:End())
	oLbx:SetArray(aArqs)
   oLbx:bLine := { || {aArqs[oLbx:nAt,1],aArqs[oLbx:nAt,2]}}

	DEFINE SBUTTON FROM 83, 88  TYPE 1  ENABLE OF oDlg ACTION (lRet := .T.,nArq := oLbx:nAt,oDlg:End())
	DEFINE SBUTTON FROM 83, 116 TYPE 2  ENABLE OF oDlg ACTION (lRet := .F.,oDlg:End())

	ACTIVATE MSDIALOG oDlg CENTERED
	If !lRet
		Exit
	Endif

	cArq := SubStr(aArqs[nArq,1],1,3)
	If !SelArq(cArq)
		Loop
	Endif

	Set Dele Off
	mBrowse( 6, 1,22,75,cArq,,,,"!Deleted()")
	Set Dele On
	dbSelectArea(cArq)
	dbCloseArea()
Enddo
#ENDIF
dbSelectArea("SX2")
Set FIlter to &cFilter
DbSelectarea(cOldAlias)
dbgoto(nSavRec)
Return Nil


Static Function SelArq(cArq)
Local  i
DbSelectArea("SX2")
DbSeek(cArq)
cArquivo := RetArq(__cRdd,AllTrim(x2_path)+AllTrim(x2_arquivo),.t.)
If !MSFile(cArquivo)
	Help("",1,"NOFILE")
	Return .F.
Else
	If Select(cArq) == 0
		If !ChkFile(cArq,.F.)
			Help("",1,"ABREEXCL")
			Return .F.
		Endif
	Else
		dbselectarea(cArq)
	endif
Endif
Return .T.


User Function StGetCampos(cArq)
Local nSavOrder,cSavRec,cAlias := Alias()
Local aCampos := {}
Local cUsado := ""

DbSelectarea("SX3")
nSavRec := Recno()
nSavOrder := IndexOrd()

DbSetOrder(1)
DbSeek(cArq)
While X3_ARQUIVO ==	cArq
	IF !("USERLG" $ X3_CAMPO) .AND. !(X3_CONTEXT == "V")
		cUsado   := FirstBitOff(Bin2Str(X3_USADO))
		// Verifica se o campo � usado
		If !Empty(cUsado)
			AADD(aCampos,{X3_CAMPO,X3Titulo()})
		EndIf
	Endif
	dbSkip()
End

DbSetOrder(nSavOrder)
DbSelectarea(cAlias)
Return aCampos


#IFNDEF WINDOWS
	User Function STVsLog()
	Local i,cStatus,cUsuarioI,cUsuarioA,cDataI,cDataA,cTipo := "0"
	Local aCampos := {},aAux := {},nPos := 0,aStruct := {}

	aStruct := DbStruct()
	nPos := Ascan(aStruct,{ |x| ( "USERLGI" $ x[1] .Or. "USERGI" $ x[1] ) })
	If nPos != 0
		cTipo := "1"
	Endif

	nPos := Ascan(aStruct,{ |x| ( "USERLGA" $ x[1] .Or. "USERGA" $ x[1] ) })
	If nPos != 0
		cTipo := IIF(cTipo == "1","3","2")
	EnDif

	If cTipo == "0"
		Help("",1,"NOLOG")
		Return Nil
	Endif

	aAux := U_StGetCampos(Alias())
	For i := 1 To Len(aAux)
		AADD(aCampos,{aAux[i,2],&(aAux[i,1])})
	Next i

	aAux := {}
	For i := 1 To Len(aCampos)
		IF ValType(aCampos[i,2]) == "N"
			AADD(aAux,aCampos[i,1] + "�" + AllTrim(Str(aCampos[i,2])))
		Elseif ValType(aCampos[i,2]) == "D"
			AADD(aAux,aCampos[i,1] + "�" + DTOC(aCampos[i,2]))
		Else
			AADD(aAux,aCampos[i,1] + "�" + AllTrim(aCampos[i,2]))
		Endif
		aAux[i] := AllTrim(aAux[i])
	Next i

	aCampos := AClone(aAux)

	u_LeLog(@cStatus,@cUsuarioI,@cUsuarioA,@cDataI,@cDataA,cTipo)
	ScreenDraw("CFG025",6,3,-2,1)
	@9,47  Say cStatus	 Color "r/bg"
	@12,56 Say cUsuarioI  Color "r/bg"
	@13,56 Say cDataI  Color "r/bg"
	@16,56 Say cUsuarioA  Color "r/bg"
	@17,56 Say cDataA  Color "r/bg"

	SETCOLOR("b/bg,w/b,,,b/bg")
	ACHOICE(9,7,17,41,aCampos,.T.)

	Return
#ELSE
	User Function STVsLog()
	Local i,cStatus,cUsuarioI,cUsuarioA,cDataI,cDataA,cTipo := "0"
	Local aCampos := {},aAux := {},nPos := 0,aStruct := {},lDeletado
	Local oDlg,oLbx,oChk


	aStruct := DbStruct()
	nPos := Ascan(aStruct,{ |x| ( "USERLGI" $ x[1] .Or. "USERGI" $ x[1] ) })
	If nPos != 0
		cTipo := "1"
	Endif

	nPos := Ascan(aStruct,{ |x| ( "USERLGA" $ x[1] .Or. "USERGA" $ x[1] ) })
	If nPos != 0
		cTipo := IIF(cTipo == "1","3","2")
	EnDif

	If cTipo == "0"
		Help("",1,"NOLOG")
		Return
	Endif

	aAux := U_StGetCampos(Alias())
	For i := 1 To Len(aAux)
		AADD(aCampos,{aAux[i,2],&(aAux[i,1])})
	Next i

	aAux := {}
	For i := 1 To Len(aCampos)
		IF ValType(aCampos[i,2]) == "N"
			AADD(aAux,{aCampos[i,1],AllTrim(Str(aCampos[i,2]))})
		Elseif ValType(aCampos[i,2]) == "D"
			AADD(aAux,{aCampos[i,1],DTOC(aCampos[i,2])})
		Else
			AADD(aAux,{aCampos[i,1],AllTrim(aCampos[i,2])})
		Endif
		aAux[i,1] := OemToAnsi(aAux[i,1])
		aAux[i,2] := OemToAnsi(AllTrim(aAux[i,2]))
	Next i

	aCampos := AClone(aAux)

	u_LeLog(@cStatus,@cUsuarioI,@cUsuarioA,@cDataI,@cDataA,cTipo)
	lDeletado := IIF(cStatus == "Deletado",.T.,.F.)

	DEFINE MSDIALOG oDlg FROM  16,2 TO 296,475 TITLE OemToAnsi("Log do Registro") PIXEL // "Log do Registro"

			@ 88, 7 TO 116, 116 LABEL OemToAnsi("Status") OF oDlg  PIXEL // "Status"
			@ 7, 124 TO 57, 229 LABEL OemToAnsi("Log de Inclus�o") OF oDlg  PIXEL // "Log de Inclus�o"
			@ 65, 124 TO 115, 229 LABEL OemToAnsi("Log de Altera��o") OF oDlg  PIXEL // "Log de Altera��o"
			@ 8,8 LISTBOX oLbx FIELDS HEADER OemToAnsi("Campos"),OemToAnsi("Conte�do")  SIZE 110, 68 OF oDlg PIXEL  // "Campos" ### "Conte�do"
				oLbx:SetArray(aCampos)
			   oLbx:bLine := { || {aCampos[oLbx:nAt,1],aCampos[oLbx:nAt,2]}}

				@ 22, 134 SAY OemToAnsi("Usu�rio:") SIZE 26, 7 OF oDlg PIXEL // "Usu�rio:"
				@ 21, 165 MSGET cUsuarioI SIZE 51, 10 OF oDlg PIXEL When .F.
				@ 38, 134 SAY OemToAnsi("Data :") SIZE 26, 7 OF oDlg PIXEL  // "Data :"
				@ 37, 165 MSGET cDataI SIZE 51, 10 OF oDlg PIXEL When .F.
				@ 79, 134 SAY OemToAnsi("Usu�rio:") SIZE 26, 7 OF oDlg PIXEL // "Usu�rio:"
				@ 78, 165 MSGET cUsuarioA SIZE 51, 10 OF oDlg PIXEL When .F.
				@ 96, 134 SAY OemToAnsi("Data :") SIZE 26, 7 OF oDlg PIXEL // "Data :"
				@ 94, 165 MSGET cDataA SIZE 51, 10 OF oDlg PIXEL When .F.
				@ 98, 20 CHECKBOX oChk Var lDeletado PROMPT OemToAnsi("Registro Deletado") SIZE 69, 10 OF oDlg PIXEL When .F.;oChk:oFont := oDlg:oFont // "Registro Deletado"

				DEFINE SBUTTON FROM 123,203 TYPE 2 ENABLE OF oDlg ACTION oDlg:End()

	ACTIVATE MSDIALOG oDlg CENTERED
	Return
#ENDIF


User Function LeLog (cStatus,cUsuarioI,cUsuarioA,cDataI,cDataA,cTipo)
Local cAlias := Alias(),cUserLg := "",cCampo

cStatus := IIF(Deleted(),"Deletado","Ativo")
If cTipo $ "13"
	cCampo 	:= If ( Subs(cAlias, 1, 1) == "S", Subs(cAlias,2) + "_USERLGI", cAlias+ "_USERGI" )
	cUsuarioI := U_StGetUserLg(cCampo)
	cDataI := U_StGetUserLg(cCampo, 2)
Else
	cUsuarioI := OemtoAnsi("Log N�o Ativo") //"Log N�o Ativo"
Endif
If cTipo $ "23"
	cCampo 	:= If ( Subs(cAlias, 1, 1) == "S", Subs(cAlias,2) + "_USERLGA", cAlias+ "_USERGA" )
	cUsuarioA := U_StGetUserLg(cCampo)
	cDataA := U_StGetUserLg(cCampo, 2)
Else
	cUsuarioA := OemtoAnsi("Log N�o Ativo") // "Log N�o Ativo"
Endif
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 � StGetUserLg � Autor � Thiago Godinho        � Data � 09.11.11 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Retorna as informa��es do USERLGI/USERLGA dependendo do     ��
���			 � campo e do tipo de consulta selecionada.					   ��
�������������������������������������������������������������������������Ĵ��
���Observa��o� Esta consulta mant�m um cache com as informa��es do usu�rio���
���			 � para que n�o seja necess�rio efetuar novamente a pesquisa. ���
���			 � Possibilita apresentar as informa��es diretamente no browse���
�������������������������������������������������������������������������Ĵ��
���Sintaxe	 � StGetUserLg(cCampo, nTipo)								  ���
�������������������������������������������������������������������������Ĵ��
���Par�metros� cCampo - Nome do campo que ser� verificado. 				  ���
���			 � 			Ex: A1_USERLGI ou
 A1_USERLGA					  ���
���			 � nTipo - Tipo de consulta que ser� realizada.				  ���
���			 � 			[1] - pesquisa o usu�rio						  ���
���			 � 			[2] - pesquisa a data							  ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � cRet - Nome do usu�rio ou data em que o registro foi       ���
���			 � 		manipulado, dependendo da consulta que foi efetuada	  ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � STWFLOG 													  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function StGetUserLg(cCampo, nTipo)
Local nPos			:= 0
Local cAux			:= ""
Local cID			:= ""
Local cUsrName 	:= ""
Local cRet			:= ""
Local cAlias		:= ""
Local cSvAlias  	:= Alias()
Local lChgAlias 	:= .F.
Local lAliasInDic := .T.

Default nTipo := 1


//-----------------------------------------------------
// Tratamento para tabelas tempor�rias
//-----------------------------------------------------
lTemporary := cSvAlias == "TRB"
If !lTemporary
	If ( ! AliasInDic( cSvAlias ) )
		cAlias := Subs(cCampo, 1, At('_', cCampo)- 1 )

		If ( len( cAlias ) == 2 )
			cAlias := 'S' + cAlias
		EndIf

		lAliasInDic := ( AliasInDic( cAlias ) )
		lTemporary  :=  ! lAliasInDic
	EndIf
EndIf

If !lTemporary
	//--------------------------------------------------
	// For�a a pesquisa do conte�do do _USERLG na tabela
	// correspondente ao campo
	//--------------------------------------------------
	nPos := At( '->', cCampo)

	If !( nPos == 0 )
		cCampo := Subs(cCampo, nPos + 2 )
	EndIf

	If  ( lAliasInDic )
		cAlias := Subs(cCampo, 1, At('_', cCampo)- 1 )

		If ( len(cAlias) == 2 )
			cAlias := 'S'+cAlias
		EndIf
	EndIf

	If cAlias != cSvAlias
		DbSelectArea(cAlias)
		lChgAlias := .T.
	Endif

EndIf

cAux := Embaralha(&cCampo,1)

If !Empty(cAux)
	If Subs(cAux, 1, 2) == "#@"
		cID := Subs(cAux, 3, 6)
		If Empty(__aUserLg) .Or. Ascan(__aUserLg, {|x| x[1] == cID}) == 0
			PSWORDER(1)
			If ( PSWSEEK(cID) )
				cUsrName	:= Alltrim(PSWRET()[1][2])
			EndIf
			Aadd(__aUserLg, {cID, cUsrName})
		EndIf

		If nTipo == 1 // retorna o usu�rio
			nPos := Ascan(__aUserLg, {|x| x[1] == cID})
			cRet := __aUserLg[nPos][2]
		Else
			cRet := Dtoc(CTOD("01/01/96","DDMMYY") + Load2In4(Substr(cAux,16)))
		Endif
	Else
		If nTipo == 1 // retorna o usu�rio
			cRet := Subs(cAux,1,15)
		Else
			cRet := Dtoc(CTOD("01/01/96","DDMMYY") + Load2In4(Substr(cAux,16)))
		Endif
	EndIf
EndIf

If lChgAlias
	If !Empty(cSvAlias)
		DbSelectArea(cSvAlias)
	Endif
EndIf

Return cRet

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 � CC025Imp � Autor � Thiago Godinho         � Data � 24.11.99 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprime a consulta ao Log de Registro                      ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe	 � CC025Imp()																  ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � STWFLOG 																	  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function CC025Imp()

Local cDesc1 := "Este programa ir� imprimir a Consulta ao LOG de"
Local cDesc2 := "inclusao e alteracao do registro corrente, bem como"
Local cDesc3 := "os dados constantes no registro."
Local cString:=alias()
Local cSavScr := ""
Local cTamanho:="M"
Local aAuxPrint:={}
Local i,cStatus,cUsuarioI,cUsuarioA,cDataI,cDataA,cTipo := "0"
Local aCampos := {},aAux := {},nPos := 0,aStruct := {},lDeletado
Local oDlg,oLbx,oChk
Local aCpoPrint := {}
Local aHelpPor := {}
Local aHelpEng := {}
Local aHelpSpa := {}

aStruct := DbStruct()
nPos := Ascan(aStruct,{ |x| ( "USERLGI" $ x[1] .Or. "USERGI" $ x[1] ) })
If nPos != 0
	cTipo := "1"
Endif

nPos := Ascan(aStruct,{ |x| ( "USERLGA" $ x[1] .Or. "USERGA" $ x[1] ) })
If nPos != 0
	cTipo := IIF(cTipo == "1","3","2")
EnDif

If cTipo == "0"
	Help("",1,"NOLOG")
	Return
Endif

aAux := U_StGetCampos(Alias())
For i := 1 To Len(aAux)
	AADD(aCpoPrint,{aAux[i,2],alltrim(transform(&(aAux[i,1]),"@X"))})
Next i

u_LeLog(@cStatus,@cUsuarioI,@cUsuarioA,@cDataI,@cDataA,cTipo)
aAuxPrint := {cStatus,cUsuarioI,cDataI,cUsuarioA,cDataA}

// ---------------------------------------------------------

Private aReturn := { OemToAnsi("Zebrado"), 1,OemToAnsi("Administracao"), 1, 2, 1, "",1 } // Zebrado ### Administracao
Private nLastKey:= 0
Private cTitulo  := OemToAnsi("Consulta LOG de Registros") // "Consulta LOG de Registros"
Private lEnd	 := .F.

#IFNDEF WINDOWS
	cSavScr := 	SaveScreen(00,00,24,79)
#ENDIF

li 		 := 80
m_pag 	 := 1

wnrel :="CFGX025"

SX1->(DbSetOrder(1))
If ! (SX1->(DbSeek("CFG02501")))
	AAdd(aHelpPor,"Imprime todos os registros?")
	AAdd(aHelpEng,"Prints all records?")
	AAdd(aHelpSpa,"�Imprime todos los registros?")
	PutSx1("CFG025", "01", "Imprime todos os registros?", "Imprime todos os registros?", "Imprime todos os registros?","mv_ch1","N",1,0,0,"C","","","","","MV_PAR01","Nao","No","No"," ","Sim","Si","Yes"," "," "," "," "," "," ","","","")
	aHelpPor := {}
	aHelpEng := {}
	aHelpSpa := {}
Else
	RecLock("SX1", .F.)
		SX1->X1_DEF01   := "Nao"
		SX1->X1_DEFSPA1 := "No"
		SX1->X1_DEFENG1 := "No"

		SX1->X1_DEF02   := "Sim"
		SX1->X1_DEFSPA2 := "Si"
		SX1->X1_DEFENG2 := "Yes"
	SX1->(MsUnlock())
EndIf

AAdd(aHelpPor,"Data De?")
AAdd(aHelpEng,"From Date?")
AAdd(aHelpSpa,"�De Fecha?")
PutSx1("CFG025","02","Data De?","Data De?","Data De?","mv_ch2","D",8,00,0,"G","","","","","MV_PAR02","","","","","","","","","","","","","","","","", "","","")
aHelpPor := {}
aHelpEng := {}
aHelpSpa := {}

AAdd(aHelpPor,"Data Ate?")
AAdd(aHelpEng,"To Date?")
AAdd(aHelpSpa,"�A fecha?")
PutSx1("CFG025","03","Data Ate?","Data Ate?","Data Ate?","mv_ch3","D",8,00,0,"G","","","","","MV_PAR03","","","","","","","","","","","","","","","","", "","","")

Pergunte("CFG025",.F.)
wnrel := SetPrint(cString,wnrel,"CFG025",cTitulo,cDesc1,cDesc2,cDesc3,.F.,"",.T.,cTamanho,"",.F.)

//wnrel := SetPrint(cString,wnrel,,cTitulo,cDesc1,cDesc2,cDesc3,.F.,"",.T.,cTamanho,"",.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

#IFDEF WINDOWS
	RptStatus({|lEnd| CC025Rel(@lEnd,wnRel,cString,aCpoPrint,aAuxPrint)},cTitulo)
#ELSE
	CC025Rel(@lEnd,wnRel,cString,aCpoPrint,aAuxPrint)
#ENDIF

Return

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
��� Fun��o	  � CC025Rel � Autor � Thiago Godinho         � Data � 24.11.99 ���
��������������������������������������������������������������������������Ĵ��
��� Descri��o � Impressao da Consulta ao LOG    							      ���
��������������������������������������������������������������������������Ĵ��
��� Sintaxe	  � CC025Rel(lEnd,wnRel,cString)										   ���
��������������������������������������������������������������������������Ĵ��
��� Uso		  � SIGACFG																   	���
��������������������������������������������������������������������������Ĵ��
���Parametros � lEnd 	- A��o do Codeblock										   ���
���			  � wnRel	- Titulo do relat�rio									   ���
���			  � cString - Mensagem 													   ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/
Static Function CC025Rel(lEnd,WnRel,cString,aCpoPrint,aAuxPrint)
//����������������������������������������������������������������������Ŀ
//�Salva a integridade dos dados														 �
//������������������������������������������������������������������������
Local cTitulo,cCabec1,cCabec2,cTamanho,cNomeProg,dData,dVencto
Local nPedidos :=0,nNotas:=0,nTotal:=0,nTitulos:=0,nTotNota:=0,nTotPgto:=0,nTitPagos:=0
Local cbtxt 	 := SPACE(10)
Local cbcont	 := 0
Local cBanco,cAgencia,cConta,cHistor
Local nCol := 0
Local nLaco
Local aAux
Local cSvAlias := Alias()
Local i,cStatus,cUsuarioI,cUsuarioA,cDataI,cDataA,cTipo := "0"
Local nPos := 0,aStruct := {}
Local lImp
Local cCond
Local xValue
Local xType

cTitulo	:= OemToAnsi("Consulta ao LOG de Registros") // "Consulta ao LOG de Registros"
cCabec1	:= OemToAnsi("CAMPO      CONTEUDO") // "CAMPO      CONTEUDO"
cCabec2	:= " "
cNomeProg:= "CFGX025"
cTamanho := "M"
li 		:= 80
m_pag 	:= 1

cabec(cTitulo,cCabec1,cCabec2,cNomeProg,cTamanho)

If MV_PAR01 == 2
	aAux := U_StGetCampos(Alias())
	DbSelectArea(cString)
	DbGoTop()

	SetRegua(RecCount())   						// Total de elementos da regua

	While !Eof()
		lImp := .F.

		IncRegua()

		aStruct := DbStruct()

		nPos := Ascan(aStruct,{ |x| ( "USERLGI" $ x[1] .Or. "USERGI" $ x[1] ) })
		If nPos != 0
			cTipo := "1"
		Endif

		nPos := Ascan(aStruct,{ |x| ( "USERLGA" $ x[1] .Or. "USERGA" $ x[1] ) })
		If nPos != 0
			cTipo := IIF(cTipo == "1","3","2")
		EnDif

		If cTipo == "0"
			Help("",1,"NOLOG")
			Return
		Endif

		cStatus:= ""
		cUsuarioI := ""
		cUsuarioA := ""
		cDataI := ""
		cDataA := ""

		u_LeLog(@cStatus,@cUsuarioI,@cUsuarioA,@cDataI,@cDataA,cTipo)
		// converte as informa��es para o formato Data
		cDataI := Ctod(cDataI)
		cDataA := Ctod(cDataA)
		If !Empty(MV_PAR02)
			If !Empty(cDataI) .or. !Empty(cDataA)
				If ((!Empty(cDataI) .And. cDataI >= MV_PAR02) .Or. (!Empty(cDataA) .And. cDataA >= MV_PAR02))
					If !Empty(MV_PAR03)
						If ((!Empty(cDataI) .And. cDataI <= MV_PAR03) .Or. (!Empty(cDataA) .And. cDataA <= MV_PAR03))
							lImp := .T.
						Else
							lImp := .F.
						EndIf
					Else
						lImp := .T.
					EndIf
				Else
					lImp := .F.
				EndIf
			Else
				lImp := .F.
			EndIf
		Else
			If !Empty(MV_PAR03)
				If !Empty(cDataI) .or. !Empty(cDataA)
					If ((!Empty(cDataI) .And. cDataI <= MV_PAR03) .Or. (!Empty(cDataA) .And. cDataA <= MV_PAR03))
						lImp := .T.
					Else
						lImp := .F.
					EndIf
				Else
					lImp := .F.
				EndIf
		    Else
				lImp := .T.
			EndIf
		EndIf

		If lImp
			IF li > 60
				cabec(cTitulo,cCabec1,cCabec2,cNomeProg,cTamanho)
				nCol := 0
			End

			@ li,00 PSAY "Arquivo Pesquisado : " + cString // "Arquivo Pesquisado : "
			@ li,66 PSAY "Status do Registro : " + cStatus	// "Status do Registro : "
			li++
			@ li,00 PSAY "LOG de Inclusao    : " + cUsuarioI + " " + Transform(cDataI,"@X") // "LOG de Inclusao    : "
			@ li,66 PSAY "LOG de Alteracao   : " + cUsuarioA + " " + Transform(cDataA,"@X") // "LOG de Alteracao   : "
			li+=2
			@ li,00 PSAY Replicate("*",132)
			li++
			For i := 1 To Len(aAux)
				IF li > 60
					cabec(cTitulo,cCabec1,cCabec2,cNomeProg,cTamanho)
					nCol := 0
				End
				IF nCol > 0
					If (15+len(aCpoPrint[i][2])) > 65
						li++
						nCol:=0
					Endif
				Endif
				xValue	:=	&(aAux[i,1])
				xType	:=	ValType(xValue)
				If  xType == 'C'
					xValue	:=	AllTrim(xValue)
				ElseIf xType == 'N'
					xValue	:=	cValToChar(xValue)
				ElseIf xType	==	'D'
					xValue	:= DToC(xValue)
				EndIf
				@li, nCol PSAY aAux[i][2] + " | " + xValue
				If nCol>0 .or. (15+len(aCpoPrint[i][2])) > 65
					li++
					nCol:=0
				Else
					nCol:=66
				Endif
			Next
			li++
			li := 61
		EndIf
		DbSKip()
	End

	IF !Empty(cSvAlias)
		DbSelectArea(cSvAlias)
	EndIf
Else
	@ li,00 PSAY "Arquivo Pesquisado : " + cString // "Arquivo Pesquisado : "
	@ li,66 PSAY "Status do Registro : " + aAuxPrint[1]	// "Status do Registro : "
	li++
	@ li,00 PSAY "LOG de Inclusao    : " + aAuxPrint[2] + " " + Transform(aAuxPrint[3],"@X") // "LOG de Inclusao    : "
	@ li,66 PSAY "LOG de Alteracao   : " + aAuxPrint[4] + " " + Transform(aAuxPrint[5],"@X") // "LOG de Alteracao   : "
	li+=2
	@ li,00 PSAY Replicate("*",132)
	li++

	For nLaco := 1 to Len(aCpoPrint)
		IF li > 60
			cabec(cTitulo,cCabec1,cCabec2,cNomeProg,cTamanho)
			nCol := 0
		End
		IF nCol > 0
			If (15+len(aCpoPrint[nLaco][2])) > 65
				li++
				nCol:=0
			Endif
		Endif
		@li, nCol PSAY aCpoPrint[nLaco][1] + " | " + aCpoPrint[nLaco][2]
		If nCol>0 .or. (15+len(aCpoPrint[nLaco][2])) > 65
			li++
			nCol:=0
		Else
			nCol:=66
		Endif
	Next
	li++
EndIF

If li != 80
	li++
	Roda(cbcont,cbtxt,cTamanho)
EndIF

Set Device To Screen

If aReturn[5] = 1
	Set Printer TO
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return(.T.)


