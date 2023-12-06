#Include "Protheus.ch"
#Include "RwMake.ch"
#Include "Topconn.ch"

/*====================================================================================\
|Programa  | STEST070        | Autor | RENATO.OLIVEIRA           | Data | 26/12/2018  |
|=====================================================================================|
|Descrição | Tela para consulta e exportação de informações                           |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STEST070()

	Local oArea			:= FWLayer():New()
	Local aCoord		:= FWGetDialogSize(oMainWnd)
	Local cNome			:= "Filtros de cadastros"
	Private aButtons 	:= {}
	Private oMV_PAR01
	Private oMV_PAR02
	Private oMV_PAR03
	Private oMV_PAR04
	Private nComboBo1
	Private aCombo1	  := {"Produto","Fornecedor"}
	Private nComboBo2
	Private aCombo2	  := {}
	Private nComboBo3
	Private aCombo3	  := {"Igual a","Diferente de","Menor que","Menor ou igual a","Maior que","Maior ou igual a","Contém a expressão","Não contém","Inicia em","Não inicia em","Termina em","Não termina em"}
	Private cMV_PAR04 := Space(100)
	Private cMemo	  := ""
	Private oGet2
	Private cGet2
	Private aCols1	  := {}
	Private aHeader1  := {}

	GETCAMPOS("SB1")

	DEFINE FONT oFont11  NAME "Arial"	SIZE 0, -11 BOLD

	oTela := tDialog():New(aCoord[1],aCoord[2],aCoord[3],aCoord[4],OemToAnsi(cNome),,,,,/*nClrText*/,/*nClrBack*/,,,.T.)
	oArea:Init(oTela,.F.)

	oArea:AddLine("L01",15,.F.)
	oArea:AddLine("L02",35,.F.)
	oArea:AddLine("L03",25,.F.)
	oArea:AddLine("L04",25,.F.)

	oArea:AddCollumn("C01",100,.F.,"L01")
	oArea:AddCollumn("C02",100,.F.,"L02")
	oArea:AddCollumn("C03",100,.F.,"L03")
	oArea:AddCollumn("C04",100,.F.,"L04")

	oArea:AddWindow("C01" 	,"C01"  ,"Tabela"			, 100,.F.,.F.,/*bAction*/,"L01",/*bGotFocus*/)
	oArea:AddWindow("C02"	,"C02" 	,"Filtros"			, 100,.F.,.F.,/*bAction*/,"L02",/*bGotFocus*/)
	oArea:AddWindow("C03" 	,"C03"  ,"Campos"			, 100,.F.,.F.,/*bAction*/,"L03",/*bGotFocus*/)
	oArea:AddWindow("C04"	,"C04" 	,""					, 100,.F.,.F.,/*bAction*/,"L04",/*bGotFocus*/)

	oPain1 		:= oArea:GetWinPanel("C01"  	,"C01"		,"L01")
	oPain2 		:= oArea:GetWinPanel("C02"  	,"C02"		,"L02")
	oPain3 		:= oArea:GetWinPanel("C03"  	,"C03"		,"L03")
	oPain4 		:= oArea:GetWinPanel("C04"  	,"C04"		,"L04")

	//Painel 1
	@ 8   , 2 Say oSay Prompt 'Selecione a tabela' FONT oFont11 COLOR CLR_BLUE Size 100,08 Of oPain1 Pixel
	@ 0.5 , 7 MSCOMBOBOX oMV_PAR01 Var nComboBo1 ITEMS aCombo1 SIZE 083, 010 Of oPain1 VALID CHANGETAB()

	//Painel 2
	@ 2   , 2  	Say oSay Prompt 'Campo' FONT oFont11 COLOR CLR_BLUE Size 100,08 Of oPain2 Pixel
	@ 0.9 , 0.2 MSCOMBOBOX oMV_PAR02 Var nComboBo2 ITEMS aCombo2 SIZE 083, 010 Of oPain2 VALID CHANGEGET()

	@ 2   , 120 Say oSay Prompt 'Operador' FONT oFont11 COLOR CLR_BLUE Size 100,08 Of oPain2 Pixel
	@ 0.9 , 15  MSCOMBOBOX oMV_PAR03 Var nComboBo3 ITEMS aCombo3 SIZE 083, 010 Of oPain2

	@ 2   , 238 Say oSay Prompt 'Expressão' FONT oFont11 COLOR CLR_BLUE Size 100,08 Of oPain2 Pixel
	//@ 12  , 238 MSGet oMV_PAR04 Var cMV_PAR04 FONT oFont11 COLOR CLR_BLUE Pixel SIZE  100, 05 When .T.	F3 "" PICTURE "@!" Of oPain2

	cGet2 := Space(50)
	oGet2 := TGet():New(12,238, { | u | If( PCount() == 0, cGet2, cGet2 := u ) },oPain2, 080, 010, "!@",,,,,.F.,,.T.,,.F.,,.F.,.F.,{|| },.F.,.F. ,,"cGet2",,,,,,,"", 1 )

	@ 12 , 360 BUTTON oButton PROMPT "Adicionar" SIZE 50,10 OF oPain2 PIXEL ACTION ADICIONAR()

	@ 12 , 430 BUTTON oButton PROMPT "("  SIZE 10,10 OF oPain2 PIXEL ACTION EXPRESSAO("(")
	@ 12 , 440 BUTTON oButton PROMPT ")"  SIZE 10,10 OF oPain2 PIXEL ACTION EXPRESSAO(")")
	@ 12 , 450 BUTTON oButton PROMPT "e"  SIZE 10,10 OF oPain2 PIXEL ACTION EXPRESSAO("AND")
	@ 12 , 460 BUTTON oButton PROMPT "ou" SIZE 10,10 OF oPain2 PIXEL ACTION EXPRESSAO("OR")

	aHeader1 := {}
	Aadd(aHeader1,{"Expressão", "EXPRESSAO", "", 100, 0, "" , "", "C", "", "", "", "", ".T."})

	oGrid1 := MsNewGetDados():New(30,05,(oPain2:nClientHeight/2)-5,(oPain2:nClientWidth/2)-10, GD_DELETE,/*cLinhaOk*/,/*cTudoOk*/,/*cIniCpos*/,{},/*nFreeze*/,/*nMax*/,, /*cSuperDel*/,/*cDelOk*/, oPain2, aHeader1, aCols1)

	//Painel 3
	@ 02 , 02 BUTTON oButton PROMPT "Selecionar campos" SIZE 50,10 OF oPain3 PIXEL ACTION SELECIONAR()
	@ 15 , 02 GET oMemo VAR cMemo MEMO SIZE 220,070 When .F. PIXEL OF oPain3 

	//Painel 4
	@ 3 , oPain4:nClientWidth/4+20 BUTTON oButton PROMPT "Limpar" SIZE 50,10 OF oPain4 PIXEL ACTION LIMPAR()
	@ 3 , oPain4:nClientWidth/4-50 BUTTON oButton PROMPT "Processar" SIZE 50,10 OF oPain4 PIXEL ACTION PROCESSAR()

	oTela:Activate(,,,.T.,/*valid*/,,{ || EnchoiceBar(@oTela, {|| (lOk:=.T., oTela:End()) },{|| oTela:End()},,@aButtons,,,.F.,.F.,.F.,.F.,.F.) })

Return

/*/{Protheus.doc} GETCAMPOS
@name GETCAMPOS
@type Static Function
@desc retornar campos da tabela
@author Renato Nogueira
@since 20/11/2017
/*/

Static Function GETCAMPOS(_cTabela)

	aCombo2 := {}

	DbSelectArea("SX3")
	SX3->(DbSetOrder(1))
	SX3->(DbGoTop())
	SX3->(DbSeek(_cTabela))

	While SX3->(!Eof()) .And. SX3->X3_ARQUIVO==_cTabela

		If SX3->X3_CONTEXT<>"V"
			AADD(aCombo2,AllTrim(SX3->X3_TITULO))
		EndIf

		SX3->(DbSkip())
	EndDo 

	aSort(aCombo2)
Return()

/*/{Protheus.doc} CHANGETAB
@name CHANGETAB
@type Static Function
@desc ajustar informações da tela ao trocar de tabela
@author Renato Nogueira
@since 20/11/2017
/*/

Static Function CHANGETAB()

	Do Case
		Case AllTrim(nComboBo1)=="Produto"
		GETCAMPOS("SB1")
		Case AllTrim(nComboBo1)=="Fornecedor"
		GETCAMPOS("SA2")
	EndCase

	oMV_PAR02:aItems := aCombo2
	oMV_PAR02:Refresh()
	aCols1:={}
	oGrid1:SetArray(aCols1)
	oGrid1:Refresh()
	cMemo := ""
	oMemo:Refresh()
	oPain2:Refresh()
	oTela:Refresh()

Return()

/*/{Protheus.doc} ADICIONAR
@name ADICIONAR
@type Static Function
@desc adicionar expressões de filtro no getdados
@author Renato Nogueira
@since 20/11/2017
/*/

Static Function ADICIONAR()

	Local _cTabela 		:= ""
	Local _cExpressao	:= ""
	Local aCols1Bkp		:= {}
	Local _lConector	:= .F.
	Local _nX			:= 1
	Local nY			:= 1
	
	For _nX:=1 To Len(oGrid1:aCols)
		If !oGrid1:aCols[_nX][2]
			AADD(aCols1Bkp,oGrid1:aCols[_nX])
		EndIf
	Next
	For _nX:=1 To Len(aCols1Bkp)
		If _nX==Len(aCols1Bkp)
			If !((AllTrim(aCols1Bkp[_nX][1])=="AND" .Or. AllTrim(aCols1Bkp[_nX][1])=="OR"));
			.And. !(AllTrim(cGet2)=="AND" .Or. AllTrim(cGet2)=="OR")
				MsgAlert("Necessário conector, por favor revise a regra!")
				Return
			EndIf
		EndIf
	Next

	If AllTrim(cGet2)=="(" .Or. AllTrim(cGet2)=="(" .Or. AllTrim(cGet2)=="AND" .Or. AllTrim(cGet2)=="OR"
		_lConector  := .T.
		_cExpressao := " "+AllTrim(cGet2)+" "
	EndIf

	aCols1Bkp := {}

	Do Case
		Case AllTrim(nComboBo1)=="Produto"
		_cTabela := "SB1"
		Case AllTrim(nComboBo1)=="Fornecedor"
		_cTabela := "SA2"
	EndCase

	If !_lConector

		DbSelectArea("SX3")
		SX3->(DbSetOrder(1))
		SX3->(DbGoTop())
		SX3->(DbSeek(_cTabela))

		While SX3->(!Eof()) .And. SX3->X3_ARQUIVO==_cTabela

			If SX3->X3_CONTEXT<>"V"
				If AllTrim(SX3->X3_TITULO)==AllTrim(nComboBo2)
					_cExpressao += AllTrim(SX3->X3_CAMPO)+" "
					Exit
				EndIf
			EndIf

			SX3->(DbSkip())
		EndDo

		_cOper := AllTrim(nComboBo3)

		Do Case
			Case _cOper=="Igual a"
			_cExpressao += " = " + cVarConv()
			Case _cOper=="Diferente de"
			_cExpressao += " <> " + cVarConv()
			Case _cOper=="Menor que"
			_cExpressao += " < " + cVarConv()
			Case _cOper=="Menor ou igual a"
			_cExpressao += " <= " + cVarConv()
			Case _cOper=="Maior que"
			_cExpressao += " > " + cVarConv()
			Case _cOper=="Maior ou igual a"
			_cExpressao += " >= " + cVarConv()
			Case _cOper=="Contém a expressão"
			_cExpressao += " LIKE '%" + StrTran(cVarConv(),"'") + "%' "
			Case _cOper=="Não contém"
			_cExpressao += " NOT LIKE '%" + StrTran(cVarConv(),"'") + "%' "
			Case _cOper=="Inicia em"
			_cExpressao += " LIKE '" + StrTran(cVarConv(),"'") + "%' "
			Case _cOper=="Não inicia em"
			_cExpressao += " NOT LIKE '" + StrTran(cVarConv(),"'") + "%' "
			Case _cOper=="Termina em"
			_cExpressao += " LIKE '%" + StrTran(cVarConv(),"'") +"'"
			Case _cOper=="Não termina em"
			_cExpressao += " NOT LIKE '%" + StrTran(cVarConv(),"'") +"'"
		EndCase

	EndIf

	For _nX:=1 To Len(oGrid1:aCols)
		If !oGrid1:aCols[_nX][2]
			AADD(aCols1Bkp,oGrid1:aCols[_nX])
		EndIf
	Next

	aCols1 := aCols1Bkp

	AADD(aCols1,Array(Len(aHeader1)+1))

	For nY:=1 To Len(aHeader1)

		DO CASE
			CASE AllTrim(aHeader1[nY][2]) =  "EXPRESSAO"
			aCols1[Len(aCols1)][nY] := _cExpressao
		ENDCASE

	Next

	aCols1[Len(aCols1)][Len(aHeader1)+1] := .F.

	oGrid1:SetArray(aCols1)
	oGrid1:Refresh()

Return()

/*/{Protheus.doc} cVarConv
@name cVarConv
@type Static Function
@desc converter campos
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function cVarConv()

	Local cRet := "" 

	If SX3->X3_TIPO == "N"
		cRet := CVALTOCHAR(cGet2)
	ElseIf SX3->X3_TIPO == "C"
		If Empty(cGet2)
			cRet := "'"+Space(SX3->X3_TAMANHO)+"'"
		Else
			cRet := "'"+AllTrim(cGet2)+"'"
		EndIf
	ElseIf SX3->X3_TIPO == "D"
		cRet := "'"+DTOS(cGet2)+"'"
	EndIf

return cRet

/*/{Protheus.doc} EXPRESSAO
@name EXPRESSAO
@type Static Function
@desc adicionar expressao
@author Renato Nogueira
@since 20/11/2017
/*/

Static Function EXPRESSAO(_cExp)

	//AADD(aCols1,{" "+_cExp+" ",.F.})

	//oGrid1:SetArray(aCols1)
	//oGrid1:Refresh()

	cGet2 := _cExp
	ADICIONAR()

Return()

/*/{Protheus.doc} SELECIONAR
@name SELECIONAR
@type Static Function
@desc selecionar campos para extração
@author Renato Nogueira
@since 20/11/2017
/*/

Static Function SELECIONAR()

	Local _cTabela 			:= ""
	Local _aMark   			:= {}
	Local lAchou   			:= .F.
	Local _cRetorno			:= ""
	Local _nX				:= 1
	Private _cCampo 		:= Space(10)
	Private aDados  		:= {}
	Private cVar 			:= "  "
	Private oOk1			:= LoadBitmap(GetResources(),"LBOK")
	Private oNo1			:= LoadBitmap(GetResources(),"LBNO")
	Private _oGet9 
	Private lRunDblClick 	:= .T.

	If !Empty(cMemo)
		_aMark	:= StrTokArr(cMemo,"/")
	EndIf

	Do Case
		Case AllTrim(nComboBo1)=="Produto"
		_cTabela := "SB1"
		Case AllTrim(nComboBo1)=="Fornecedor"
		_cTabela := "SA2"
	EndCase

	DbSelectArea("SX3")
	SX3->(DbGoTop())
	SX3->(DbSetOrder(1))
	SX3->(DbSeek(_cTabela))

	While SX3->(!Eof()) .And. AllTrim(SX3->X3_ARQUIVO)==_cTabela 

		If SX3->X3_CONTEXT<>'V'

			lAchou	:= .F.
			For _nX:=1 To Len(_aMark)
				If AllTrim(SX3->X3_CAMPO)==AllTrim(_aMark[_nX])
					lAchou	:= .T.
				EndIf
			Next

			If lAchou
				AADD(aDados,{.T.,AllTrim(SX3->X3_CAMPO),AllTrim(SX3->X3_TITULO)})
			Else
				AADD(aDados,{.F.,AllTrim(SX3->X3_CAMPO),AllTrim(SX3->X3_TITULO)})
			EndIf

		EndIf

		SX3->(DbSkip())
	EndDo

	nOpca := 0
	DEFINE MSDIALOG oDialog TITLE "Cadastro de campos" From 9,0 To 40,60 OF oMainWnd

	//@ 0,0 SAY "Pesquisar:"
	@ 11,5 MSGET _cCampo When .T. Size 100,7 VALID PESQCPO1() PIXEL OF oDialog
	@ 2,0.7 LISTBOX _oGet9 VAR cVar Fields HEADER " ","Campo","Título" SIZE 220,200 ON DBLCLICK (aDados:=FA060Troca(_oGet9:nAt,aDados),_oGet9:Refresh()) NOSCROLL

	_oGet9:SetArray(aDados)
	_oGet9:bLine := { || {if(aDados[_oGet9:nAt,1],oOk1,oNo1),aDados[_oGet9:nAt,2],aDados[_oGet9:nAt,3]}}
	_oGet9:bHeaderClick := {|oObj,nCol| If(lRunDblClick .And. nCol==1, aEval(aDados, {|e| e[1] := !e[1]}),Nil), lRunDblClick := !lRunDblClick, _oGet9:Refresh()}

	DEFINE SBUTTON FROM 10,130  TYPE 1 ACTION (nOpca := 1,oDialog:End()) ENABLE OF oDialog
	DEFINE SBUTTON FROM 10,160  TYPE 2 ACTION oDialog:End() ENABLE OF oDialog
	DEFINE SBUTTON FROM 10,190    TYPE 3 ACTION (LIMPA1()) ENABLE OF oDialog

	ACTIVATE MSDIALOG oDialog CENTERED

	If nOpca == 1

		_cRetorno := ""

		For _nx:=1 To Len(aDados)
			If aDados[_nX][1]
				_cRetorno += aDados[_nX][2]+"/"
			EndIf
		Next

		cMemo := _cRetorno
		oMemo:Refresh()
		oPain3:Refresh()
		oTela:Refresh()

	EndIf

Return()

/*/{Protheus.doc} LIMPA1
@name LIMPA1
@type Static Function
@desc limpa mark
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function LIMPA1()

	Local _nY	:= 0

	For _nY:=1 To Len(aDados)
		aDados[_nY][1]	:= .F.
	Next

Return()

/*/{Protheus.doc} PESQCPO1
@name PESQCPO1
@type Static Function
@desc pesquisa campo
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function PESQCPO1()

	Local _lAchou	:= .F.
	Local _nX

	For _nX:=1 To Len(aDados)
		If AllTrim(_cCampo)==AllTrim(aDados[_nX][2])
			_oGet9:nAt	:= _nX
			_oGet9:Refresh()
			_lAchou	:= .T.
			Exit
		EndIf
	Next

Return(.T.)

/*/{Protheus.doc} PCWFC27A
@name PCWFC27A
@type User Function
@desc converter operadores
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function CHANGEGET()

	Local cCampo 	:= ""
	Local _cTabela	:= ""

	Do Case
		Case AllTrim(nComboBo1)=="Produto"
		_cTabela := "SB1"
		Case AllTrim(nComboBo1)=="Fornecedor"
		_cTabela := "SA2"
	EndCase

	DbSelectArea("SX3")
	SX3->(DbSetOrder(1))
	SX3->(DbGoTop())
	SX3->(DbSeek(_cTabela))

	While SX3->(!Eof()) .And. SX3->X3_ARQUIVO==_cTabela

		If SX3->X3_CONTEXT<>"V"
			If AllTrim(SX3->X3_TITULO)==AllTrim(nComboBo2)
				cCampo := SX3->X3_CAMPO
				Exit
			EndIf
		EndIf

		SX3->(DbSkip())
	EndDo

	cGet2 := CriaVar(AllTrim(cCampo),.F.)

	oPain2:Refresh()

Return()

/*/{Protheus.doc} PROCESSAR
@name PROCESSAR
@type User Function
@desc processar exportação
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function PROCESSAR()

	If Empty(cMemo)
		MsgAlert("Atenção, favor selecionar ao menos um campo para exportação, obrigado!")
		Return
	EndIf

	Processa({|| PROCESSAR1() },"Aguarde Processando...")

Return()

/*/{Protheus.doc} PROCESSAR1
@name PROCESSAR1
@type User Function
@desc processar exportação
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function PROCESSAR1()

	Local _cQuery1 := ""
	Local _cAlias1 := "PCWFC27A"
	Local _cTabela := ""
	Local cBuffer  := ""
	Local cPath		:= AllTrim(GetTempPath())
	Local cArquivo	:= DTOS(Date())+Time()+".csv"
	Local cDirDocs  := MsDocPath()
	Local cCrLf      := Chr(13) + Chr(10)
	Local _nX		:= 1

	Do Case
		Case AllTrim(nComboBo1)=="Produto"
		_cTabela := "SB1"
		Case AllTrim(nComboBo1)=="Fornecedor"
		_cTabela := "SA2"
	EndCase

	_aMark		:= StrTokArr(cMemo,"/")
	cArquivo	:= StrTran(cArquivo,":")
	nHandle		:= FCreate(cPath + "\" + cArquivo)
	
	If nHandle == -1
		MsgStop("Erro na criacao do arquivo na estacao local. Contate o administrador do sistema")
		Return
	EndIf

	_cQuery1 := " SELECT "

	For _nX:=1 To Len(_aMark)

		DbSelectArea("SX3")
		SX3->(DbSetOrder(2))
		SX3->(DbGoTop())
		If SX3->(DbSeek(_aMark[_nX]))
			//Chamado 61420
			If SX3->X3_TIPO=="M"
				_cQuery1 += "replace(replace(utl_raw.cast_to_varchar2("+_aMark[_nX]+"),chr(13),'CHR(13)'),chr(10),'CHR(10)') "+_aMark[_nX] 
			Else
				_cQuery1 += _aMark[_nX]
			Endif
			cBuffer  += AllTrim(SX3->X3_CAMPO)+" - "+Alltrim(SX3->X3_TITULO)+";"
			If !(_nX==Len(_aMark))
				_cQuery1 += ","
			EndIf
		EndIf

	Next

	FWrite(nHandle, cBuffer)
	FWrite(nHandle, CRLF)

	_cQuery1 += " FROM "+RetSqlName(_cTabela)+" TAB
	_cQuery1 += " WHERE TAB.D_E_L_E_T_=' '

	If Len(oGrid1:aCols)>0
		If !oGrid1:aCols[1][2]
			_cQuery1 += " AND (
		EndIf 
	EndIf

	For _nX:=1 To Len(oGrid1:aCols) 
		If !oGrid1:aCols[_nX][2]
			_cQuery1 += oGrid1:aCols[_nX][1]
		EndIf
	Next

	If Len(oGrid1:aCols)>0
		If !oGrid1:aCols[1][2]
			_cQuery1 += " )
		EndIf
	EndIf

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	While !(_cAlias1)->(Eof())

		cBuffer := ""

		For _nX:=1 To Len(_aMark)

			DbSelectArea("SX3")
			SX3->(DbSetOrder(2))
			SX3->(DbGoTop())
			SX3->(DbSeek(_aMark[_nX]))

			If SX3->X3_TIPO $ "C#M"
				//cBuffer += "'"
			EndIf

			//Chamado 61420
			If SX3->X3_TIPO=="N"
				cBuffer += CVALTOCHAR((_cAlias1)->&(SX3->X3_CAMPO))
			Else
				cBuffer += (_cAlias1)->&(SX3->X3_CAMPO)
			EndIf

			If _nX <> Len(_aMark)
				cBuffer += ";"
			Endif
			//
		Next		
		FWrite(nHandle, cBuffer)
		FWrite(nHandle, CRLF)
		(_cAlias1)->(DbSkip())
	EndDo

	FClose(nHandle)

	CpyS2T(cDirDocs + "\" + cArquivo, cPath, .T.)

	If ApOleClient("MsExcel")
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open(cPath + "\" + cArquivo)
		oExcelApp:SetVisible(.T.)
		oExcelApp:Destroy()
	Else
		MsgStop("Microsoft Excel nao instalado." + CRLF + "("+cPath+"\"+cArquivo+")")
	EndIf

Return()

/*/{Protheus.doc} LIMPAR
@name LIMPAR
@type Static Function
@desc limpar informações da tela
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function LIMPAR()

	aCols1:={}
	oGrid1:SetArray(aCols1)
	oGrid1:Refresh()
	cMemo := ""
	oMemo:Refresh()
	oPain2:Refresh()
	oTela:Refresh()

Return()
