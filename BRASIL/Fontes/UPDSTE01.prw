#INCLUDE "Protheus.ch"
#INCLUDE "ParmType.ch"

#DEFINE X3_USADO_EMUSO 		"€€€€€€€€€€€€€€ "
#DEFINE X3_USADO_NAOUSADO 		"€€€€€€€€€€€€€€€"
#DEFINE X3_USADO_OBRIGATO 		"€€€€€€€€€€€€€€°"
#DEFINE X3_USADO_RES			Replicate(CHR(128),15)		//Usado para campos reservados
#DEFINE X3_RESER 				"şÀ"
#DEFINE X3_RESEROBRIG 			"ƒ€"
#DEFINE X3_RES					"€€"
#DEFINE X3_RESLOG				"şA"
#DEFINE X3_RESBLQ				"‚€"

//Tamanho da descricao SXA
#DEFINE nTAMSXAD			30
//Estrutura - Exportacao arquivos (tabelas)
#DEFINE POS_EXA_CAB		1	//Cabecalho
#DEFINE POS_EXA_IVC		2	//Inicializadores, validadores e combos
#DEFINE POS_EXA_ITE		3	//Itens
//Subestrutura do POS_EXA_IVC
#DEFINE POS_IVC_INI		1
#DEFINE POS_IVC_VLD		2
#DEFINE POS_IVC_CMB		3
//Estrutura - Exportacao arquivos (parametros)
#DEFINE POS_EXP_CAB		1	//Cabecalho
#DEFINE POS_EXP_ITE		2	//Itens

Static nTamDiv			:= 125
Static lAjSExc			:= .F.					//Fazer ajustes com sem acesso exclusivo ao dicionario
Static lAltREGEx		:= .T.					//Alterar registros existentes nos arquivos do dicionario?

//--------------------------------------------------------------
/*/{Protheus.doc} UPDSTE01
Rotina para ajuste de dicionario para dar suporte a rotina de 
envio de comunicados aos clientes de titulos a pagar a vencer
e vencidas.

@param : Nenhum

@return : Nenhum

@author  Pablo Gollan Carreras [RVG]
@since 14/02/2014
/*/
//--------------------------------------------------------------

User Function UPDSTE01()

Local lRet				:= .T.
Local lSIX				:= .F.
Local aAjUnico			:= {}
Local aArq  			:= {}
Local ni				:= 0
Local dDataAPO			:= CtoD("")
Local aTMP				:= {}
Local aLstAPO			:= {{"RVGFUN01.PRW","01/12/13"}}
Local lErro				:= .F.

Private oMainWnd
Private cRotina 		:= StrTran(Upper(AllTrim(ProcName(0))),"U_","")
Private oBarra			:= Nil
Private oFunc			:= Nil

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Validar lista de APOs necessarios para a execucao do update  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For ni := 1 to Len(aLstAPO)
	If !Empty(aTMP := GetAPOInfo(aLstAPO[ni][1]))
		If (dDataAPO := CtoD(AllToChar(aTMP[4]))) < CtoD(aLstAPO[ni][2])
			MsgAlert(OemToAnsi("Impossível executar este update, pois o APO [" + aLstAPO[ni][1] + ;
				"] compilado no repositório possui data inferior [" + DtoC(dDataAPO) + ;
				"] ao da versão necessária deste mesmo APO!"),cRotina)
			lErro := .T.
		Endif
	Else
		MsgAlert(OemToAnsi("Impossível executar este update, pois o APO [" + aLstAPO[ni][1] + ;
			"] necessário para a execução deste não consta no repositório!"),cRotina)
		lErro := .T.
	Endif
Next ni
If lErro
	Return Nil
Endif
oFunc := rvgFun01():New()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Desligar refresh no lock do TOP  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#IFDEF TOP
	TCInternal(5,'*OFF')
#ENDIF
SET(_SET_DELETED,.T.)
//Interface para viabilizar o emprego da barra de progressao e da funcao Aviso
DEFINE WINDOW oMainWnd FROM 000,000 TO 001,001 TITLE OemToAnsi("Ajustes de dicionário")
ACTIVATE WINDOW oMainWnd ICONIZED ON INIT (lRet := PergProc(),oMainWnd:End())
If 	!lRet
	Return Nil
Endif
oBarra := MsNewProcess():New({|| ProcAtua(@aArq,@aAjUnico,@lSIX)},cRotina,"Processando ajustes...",.F.)
oBarra:Activate()

oFunc:Finish()

Return Nil

//--------------------------------------------------------------
/*/{Protheus.doc} PergProc
Rotina para confirmacao de processamento

@param : Nenhum

@return : Nenhum

@author  Pablo Gollan Carreras [RVG]
@since 14/02/2014
/*/
//--------------------------------------------------------------

Static Function PergProc()

Local lRet				:= .T.
Local cMens				:= ""

cMens := "Atencao !" + CRLF
cMens += "Esta rotina irá atualizar os dicionários de dados para ajustes para dar " + CRLF
cMens += "suporte a rotina de envio de comunicados aos clientes de titulos a pagar e a vencer." + CRLF
cMens += "Importante : " + CRLF
cMens += "1. Não devem existir usuários utilizando o sistema durante a atualização!" + CRLF
cMens += "Caso o acesso exclusivo não seja possível, apenas atualizações possíveis " + CRLF
cMens += "neste modo serão realizadas." + CRLF
cMens += "2. Indices customizados que estejam em conflito com índices que " + CRLF
cMens += "serão criados, se possuirem nickname serão deslocados, caso " + CRLF
cMens += "contrário serão sobreescritos." + Replicate(CRLF,2)
If Aviso("Ajustes de dicionário",cMens,{"Confirmar","Cancelar"},3) # 1
	Return !lRet
Endif

Return lRet

//--------------------------------------------------------------
/*/{Protheus.doc} ProcAtua
Rotina de chamada das funcoes de atualizacao de dicionario

@param : Nenhum

@return : Nenhum

@author  Pablo Gollan Carreras [RVG]
@since 14/02/2014
/*/
//--------------------------------------------------------------

Static Function ProcAtua(aArq,aAjUnico,lSIX)

Local lRet				:= .T.
Local aEmp				:= ConectaSM0()
Local ni				:= 0
Local nx				:= 0
Local cLOG				:= ""
Local cLOGArq			:= ""
Local cTipoArq    		:= "Arquivos Texto (*.TXT) |*.txt|"
Local oTela
Local oMemo
Local oFont
Local nEtapas			:= 8
Local aCampos			:= {}
Local aCamposBrw		:= {}
Local cAlias			:= "TRB"
Local cArqTrab			:= ""
Local cArqTrab02		:= ""
Local nOpca				:= 0
Local lInverte			:= .F.
Local cMarca			:= ""
Local aAreaSM0			:= {}
Local oDlg
Local oEtq01
Local cArq				:= "SIGAMAT.EMP"
Local cArqInd			:= "SIGAMAT.IND"

Private lAjEfetua		:= .F.
Private lForcaSIX		:= .F.					//Forca recriar todos os indices customizados do SIX
Private lAjVlPrEx		:= .F.					//Sobreescrever valores pre-existentes da SX5 e SX6
Private aPst			:= {"Padrão","Exportação"}

If Len(aEmp) == 0
	Return Nil
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tela de selecao de empresas  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAreaSM0 := SM0->(GetArea())
aEmp := Array(0)
SM0->(dbGoTop())
RpcSetType(3)
RpcSetEnv(SM0->M0_CODIGO,SM0->M0_CODFIL)
RpcClearEnv()
If !lAjSExc
	OpenSm0Excl()
Else
	dbUseArea(.T.,"TOPCONN",cArq,"SM0",.T.,.T.)	// adicionado o driver TOPCONN \Ajustado
	SM0->(dbSetIndex(cArqInd))
Endif
FechaArqT(cAlias)
cMarca := "2e"
//Estrutura do arquivo
aAdd(aCampos,{"SEL","C",2,0})
aAdd(aCampos,{"CODIGO","C",Len(SM0->M0_CODIGO),0})
aAdd(aCampos,{"FILIAL","C",Len(SM0->M0_CODFIL),0})
aAdd(aCampos,{"NOME","C",Len(SM0->M0_NOME),0})
//Campos para o browse
aAdd(aCamposBrw,{"SEL",,"",""})
aAdd(aCamposBrw,{"CODIGO",,"Código","@!"})
aAdd(aCamposBrw,{"FILIAL",,"Filial","@!"})
aAdd(aCamposBrw,{"NOME",,"Empresa","@!"})
//Montando e indexando o arquivo temporario
//cArqTrab := CriaTrab(aCampos,.T.) 			 //Função CriaTrab descontinuada, adicionado o oTable no lugar
oTable := FWTemporaryTable():New(cAlias) 		 //adicionado\Ajustado
oTable:SetFields(aCampos)				    	 //adicionado\Ajustado
oTable:Create()									 //adicionado\Ajustado
cAlias	:= oTable:GetAlias()					 //adicionado\Ajustado
cArqTrab	:= oTable:GetRealName()				 //adicionado\Ajustado
dbUseArea(.T.,"TOPCONN",cArqTrab,cAlias,Nil,.F.) //adicionado o driver TOPCONN \Ajustado
cArqTrab := CriaTrab(Nil,.F.)
IndRegua(cAlias,cArqTrab,"CODIGO+FILIAL",,.F.,"","Processando")
Do While !SM0->(Eof())
	If aScan(aEmp,{|x| x == SM0->M0_CODIGO}) == 0
		RecLock(cAlias,.T.)
		(cAlias)->SEL 		:= Space(Len((cAlias)->SEL))
		(cAlias)->CODIGO 	:= SM0->M0_CODIGO
		(cAlias)->FILIAL 	:= SM0->M0_CODFIL
		(cAlias)->NOME 		:= SM0->M0_NOME
		aAdd(aEmp,SM0->M0_CODIGO)
		MsUnlock(cAlias)
	Endif
	SM0->(dbSkip())
EndDo
aEmp := Array(0)
(cAlias)->(dbGoTop())
RestArea(aAreaSM0)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Montando a tela para selecao de empresas.  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oDlg := tDialog():New(200,200,550,600,"Empresas",,,,,CLR_WHITE,CLR_WHITE,,,.T.)

oEtq01 := tSay():New(003,003,{|| "Selecione as empresas desejadas :"},oDlg,,,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
oMarca := MsSelect():New(cAlias,"SEL",,aCamposBrw,@lInverte,@cMarca,{0013,0003,0135,0198})
oMarca:oBrowse:lCanAllmark := .T.
oMarca:oBrowse:lHasMark = .T.
oMarca:bAval := {||	InverteSel(cAlias,1,cMarca),oMarca:oBrowse:Refresh(.T.)}
oMarca:oBrowse:bAllMark := {|| InverteSel(cAlias,2,cMarca),oMarca:oBrowse:Refresh(.T.)}
oMarca:oBrowse:Align := CONTROL_ALIGN_NONE
//Marca de recriacao de indices
oForcaSIX := tCheckBox():New(0138,0003,OemToAnsi("Forçar para recriar índices?"),{|x| IIf(!Empty(PCount()),;
	lForcaSIX := x,lForcaSIX)},oDlg,0198,0010,,/*bLClicked*/,;
	,,CLR_BLACK,/*nClrPane*/,,.T.,"Caso deseje forçar a recriação dos índices independentemente de sua existência, deixe este item marcado.",,{|| .F.})
//Marca de ajuste de valores de SX5 e SX6 pre-existentes
oAjVlPrEx := tCheckBox():New(0150,0003,OemToAnsi("Alterar valores pré-existentes da SX5 e SX6?"),;
	{|x| IIf(!Empty(PCount()),lAjVlPrEx := x,lAjVlPrEx)},oDlg,0198,0010,,/*bLClicked*/,;
	,,CLR_BLACK,/*nClrPane*/,,.T.,"Caso deseje sobreescrever valores pré-existentes de tabelas padrão e parâmetros, deixe este item marcado.",,/*bWhen*/)
//Botoes
Define SButton From 162,003 Type 1 Enable Of oDlg Action (nOpca := 1, oDlg:End())
Define SButton From 162,033 Type 2 Enable Of oDlg Action (nOpca := 2, oDlg:End())

oDlg:Activate(,,,.T.,Nil)

If nOpcA # 1
	MsgAlert("Operação cancelada!")
	FechaArqT(cAlias)
	Return Nil
Endif
(cAlias)->(dbGoTop())
Do While !(cAlias)->(Eof())
	If IsMark("SEL",cMarca)
		aCampos := Array(0)
		For ni := 2 to FCount()
			aAdd(aCampos,(cAlias)->(FieldGet(ni)))
		Next ni
		aAdd(aCampos,.F.)
		aAdd(aEmp,aCampos)
	Endif
	(cAlias)->(dbSkip())
EndDo
FechaArqT(cAlias)
If Len(aEmp) == 0
	MsgAlert("Operação cancelada!")
	Return Nil
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Processamento dos ajustes  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oBarra:SetRegua1(1)
oBarra:IncRegua1("Processando ajustes (iniciando)")
//Avaliar os ambientes
For ni := 1 to Len(aEmp)
	RpcSetType(3)
	RpcSetEnv(aEmp[ni][1],aEmp[ni][2])
	RpcClearEnv()
	If !lAjSExc
		OpenSm0Excl()
	Else
		dbUseArea(.T.,"TOPCONN",cArq,"SM0",.T.,.T.) //adicionado o driver TOPCONN \Ajustado
		SM0->(dbSetIndex(cArqInd))
	Endif
Next ni
If cPaisLoc # "BRA"
	MsgAlert("Esta rotina destina-se somente para a localidade Brasil.",cRotina)
	Return Nil
Endif
//Processar as empresas e filiais
For ni := 1 to Len(aEmp)
	RpcSetType(3)
	RpcSetEnv(aEmp[ni][1],aEmp[ni][2])
	oBarra:SetRegua1(nEtapas)

	cLOG += Replicate("-",nTamDiv) + CRLF + "EMPRESA [" + aEmp[ni][1] + "-" + aEmp[ni][2] + "]" + CRLF

	oBarra:IncRegua1("[Empresa " + aEmp[ni][1] + "] Ajustando o SX2")
	cLOG += ProcAjSX2(@aArq)

	oBarra:IncRegua1("[Empresa " + aEmp[ni][1] + "] Ajustando o SXA")
	cLOG += ProcAjSXA()

	oBarra:IncRegua1("[Empresa " + aEmp[ni][1] + "] Ajustando o SX3")
	cLOG += ProcAjSX3(@aArq)

	oBarra:IncRegua1("[Empresa " + aEmp[ni][1] + "] Ajustando o SX5")
	cLOG += ProcAjSX5()

	oBarra:IncRegua1("[Empresa " + aEmp[ni][1] + "] Ajustando o SX6")
	cLOG += ProcAjSX6()

	oBarra:IncRegua1("[Empresa " + aEmp[ni][1] + "] Ajustando o SX7")
	cLOG += ProcAjSX7()

	oBarra:IncRegua1("[Empresa " + aEmp[ni][1] + "] Ajustando o SXB")
	cLOG += ProcAjSXB()

	//Ajustando os helps de mensagens
	ProcAjHlp()

	//Atualizar as estruturas consolidadas
	If Len(aArq) # 0 .AND. !lAjSExc
		__SetX31Mode(.F.)
		For nx := 1 To Len(aArq)
			If Select(aArq[nx]) > 0
				dbSelectArea(aArq[nx])
				dbCloseArea()
			EndIf
			X31UpdTable(aArq[nx])
			If __GetX31Error()
				Alert(__GetX31Trace())
				Aviso("Atenção!","Ocorreu um erro desconhecido durante a atualização da tabela " + aArq[nx] + ". Verifique a integridade do dicionario e da tabela.",{"Continuar"},2)
				cLOG += "Ocorreu um erro durante a atualizacao da estrutura da tabela : " + aArq[nx] + CRLF
			EndIf
			//Caso o arquivo tenha sofrido alteracoes em sua chave unica, executar os procedimentos abaixo para atualizar o indice UNQ
			If aScan(aAjUnico,{|x| AllTrim(x) == AllTrim(aArq[nx])}) # 0
   				TcRefresh(aArq[nx])
                dbSelectArea(aArq[nx])
                (aArq[nx])->(dbSetOrder(1))
                (aArq[nx])->(dbCloseArea())
                dbSelectArea(aArq[nx])
			Endif
		Next nx
	Endif
	aArq := {}
	oBarra:IncRegua1("[Empresa " + aEmp[ni][1] + "] Ajustando o SIX")
	cLOG += ProcAjSIX(@aArq,@lSIX)
	//Recriando indices das tabelas atualizadas
	If Len(aArq) # 0 .AND. lSIX .AND. !lAjSExc
		oBarra:IncRegua1("[Empresa " + aEmp[ni][1] + "] Recriando indices")
		oBarra:SetRegua2(Len(aArq))
		__SetX31Mode(.F.)
		For nx := 1 To Len(aArq)
			oBarra:IncRegua2("Indice [" + aArq[nx] + "]")
			If !Empty(Select(aArq[nx]))
				dbSelectArea(aArq[nx])
				(aArq[nx])->(dbCloseArea())
			Endif
			X31UpdTable(aArq[nx])
			If __GetX31Error()
				Alert(__GetX31Trace())
				Aviso("Atenção!","Ocorreu um erro desconhecido durante a atualização da tabela " + aArq[nx] + ". Verifique a integridade do dicionario e da tabela.",{"Continuar"},2)
				cLOG += "Ocorreu um erro durante a atualizacao da estrutura da tabela : " + aArq[nx] + CRLF
			Endif
		Next nx
	Else
		oBarra:IncRegua1("Finalizando")
	Endif
	RpcClearEnv()
	If !lAjSExc
		OpenSm0Excl()
	Else
		dbUseArea(.T.,"TOPCONN",cArq,"SM0",.T.,.T.) //adicionado o driver TOPCONN \Ajustado
		SM0->(dbSetIndex(cArqInd))
	Endif
Next ni
RpcSetEnv(aEmp[1][1],aEmp[1][2],,,,,{"SL1"})
cLOG := "LOG DA ATUALIZAÇÃO :" + CRLF + IIf(!lAjEfetua,Replicate("-",nTamDiv) + CRLF + "NENHUM AJUSTE EFETUADO",cLOG)
DEFINE FONT oFont NAME "Mono AS" SIZE 5,12
DEFINE MSDIALOG oTela TITLE "Ajustes concluídos" FROM 3,0 to 500,658 PIXEL

oMemo:= TMultiGet():New(005,005,{|x| IIf(!Empty(PCount()),cLOG := x,cLOG)},oTela,320,230,oFont,.F.,,,,.T.,,,{|| AllwaysTrue()},,,.T.,{|| AllwaysTrue()},,,,.T.)
oMemo:bRClicked := {|| AllwaysTrue()}

DEFINE SBUTTON  FROM 237,300 TYPE 1 ACTION oTela:End() ENABLE OF oTela PIXEL
DEFINE SBUTTON  FROM 237,265 TYPE 13 ACTION (cArqLOG := cGetFile(cTipoArq,""),IIf(Empty(cArqLOG),.T.,MemoWrite(cArqLOG,cLOG))) ENABLE OF oTela PIXEL

oTela:lCentered := .T.
oTela:Activate( ,,,.T.,{|| AllwaysTrue()},, {|| oMemo:SetFocus()})

Return lRet

//--------------------------------------------------------------
/*/{Protheus.doc} ProcAjSX2
Rotina para processar as atualizacoes no SX2

@param : Nenhum

@return : Nenhum

@author  Pablo Gollan Carreras [RVG]
@since 14/02/2014
/*/
//--------------------------------------------------------------

Static Function ProcAjSX2(aAjUnico,cEmpAt)

Local cRet				:= ""
Local aEstru			:= {}
Local aSX2				:= {}
Local cPath				:= ""
Local ni				:= 0
Local nx				:= 0
Local cAlias			:= ""
Local cEmp				:= ""
Local nPos				:= 0
Local lVer11			:= GetVersao(.F.) == "11" .AND. SX2->(FieldPos("X2_MODOUN")) > 0 .AND. SX2->(FieldPos("X2_MODOEMP")) > 0
Local cChv01			:= ""
Local bAtModoC			:= {|| IIf(lVer11,(nPos := Len(aSX2),aSize(aSX2[nPos],Len(aSX2[nPos]) + 2),;
							aSX2[nPos][Len(aSX2[nPos]) - 1] := aSX2[nPos][8],;
							aSX2[nPos][Len(aSX2[nPos])] := aSX2[nPos][8]),.T.)}
Local bAtMdCDef			:= {|cMdUN,cMdEmp| IIf(lVer11,(nPos := Len(aSX2),aSize(aSX2[nPos],Len(aSX2[nPos]) + 2),;
							aSX2[nPos][Len(aSX2[nPos]) - 1] := cMdUN,;
							aSX2[nPos][Len(aSX2[nPos])] := cMdEmp),.T.)}
Local bGetModoC			:= {|x| IIf(Empty(FWModeAccess(x)),"C",FWModeAccess(x))}

If lVer11
	If (cPaisLoc == "BRA")
		aEstru	:= {"X2_CHAVE","X2_PATH","X2_ARQUIVO","X2_NOME","X2_NOMESPA","X2_NOMEENG","X2_DELET","X2_MODO","X2_TTS","X2_ROTINA","X2_PYME","X2_UNICO","X2_MODOUN","X2_MODOEMP"}
	Else
		aEstru	:= {"X2_CHAVE","X2_PATH","X2_ARQUIVO","X2_NOME","X2_NOMESPA","X2_NOMEENG","X2_DELET","X2_MODO","X2_TTS","X2_ROTINA","X2_PYME","X2_UNICO","X2_MODOUN","X2_MODOEMP"}
	Endif
Else
	If (cPaisLoc == "BRA")
		aEstru	:= {"X2_CHAVE","X2_PATH","X2_ARQUIVO","X2_NOME","X2_NOMESPA","X2_NOMEENG","X2_DELET","X2_MODO","X2_TTS","X2_ROTINA","X2_PYME","X2_UNICO"}
	Else
		aEstru	:= {"X2_CHAVE","X2_PATH","X2_ARQUIVO","X2_NOME","X2_NOMESPA","X2_NOMEENG","X2_DELET","X2_MODO","X2_TTS","X2_ROTINA","X2_PYME","X2_UNICO"}
	Endif
Endif
dbSelectArea("SX2")
SX2->(dbSetOrder(1))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Processamento SX2  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Empty(aSX2) .OR. lAjSExc ; Return cRet ; Endif
oBarra:SetRegua2(Len(aSX2))
SX2->(dbSeek("SA1"))
cPath 	:= SX2->X2_PATH
cEmp	:= cEmpAnt + "0"
For ni := 1 To Len(aSX2)
	cChv01 := aSX2[ni][1]
	oBarra:IncRegua2("[" + cChv01 + "]")
	If !Empty(aSX2[ni][1])
		If !SX2->(dbSeek(cChv01))
			If !aSX2[ni,1] $ cAlias
				cAlias += aSX2[ni][1] + "/"
			EndIf
			cRet += "- Inclusão da tabela : [" + aSX2[ni][1] + "]" + CRLF
			/* Removido\Ajustado - Não executa mais RecLock na X2
			RecLock("SX2",.T.)
			For nx := 1 To Len(aSX2[ni])
				If FieldPos(aEstru[nx]) > 0
					FieldPut(FieldPos(aEstru[nx]),aSX2[ni,nx])
				Else
					ConOut("[ProcAjSX2] Campo nao encontrado : " + aEstru[nx])
				EndIf
			Next nx
			SX2->X2_PATH	:= cPath
			SX2->X2_ARQUIVO	:= IIf(Right(Upper(AllTrim(aSX2[ni][3])),3) == "ZZZ",aSX2[ni][1] + "100",aSX2[ni][1] + cEmp)
			SX2->(MsUnLock())
			SX2->(dbCommit())
			lAjEfetua := .T.*/
		Else
			//Caso esteja vetado alteracoes, saltar
			If !lAltREGEx
				Loop
			Endif
			//Caso a chave unica seja diferente, editar.
			nPos := aScan(aEstru,{|x| x == "X2_UNICO"})
			If PadR(AllTrim(SX2->X2_UNICO),250) # PadR(AllTrim(aSX2[ni][nPos]),250)
				aAdd(aAjUnico,aSX2[ni][1])
				cRet += "- Ajuste da chave única : [" + aSX2[ni][1] + "] DE : " + AllTrim(SX2->X2_UNICO) + " PARA : " + AllTrim(aSX2[ni][nPos]) + CRLF
				/* Removido\Ajustado - Não executa mais RecLock na X2
				RecLock("SX2",.F.)
				SX2->X2_UNICO := aSX2[ni][nPos]
				SX2->(MsUnlock())
				SX2->(dbCommit())
				lAjEfetua := .T.*/
			Endif
			//Caso o compartilhamento seja diferente, editar.
			If !Empty(nPos := aScan(aEstru,{|x| x == "X2_MODO"})) .AND. ;
				PadR(AllTrim(SX2->X2_MODO),1) # PadR(AllTrim(aSX2[ni][nPos]),1)
				
				cRet += "- Ajuste do modo de compartilhamento : [" + aSX2[ni][1] + "] DE : " + SX2->X2_MODO + " PARA : " + aSX2[ni][nPos] + CRLF
				/* Removido\Ajustado - Não executa mais RecLock na X2
				RecLock("SX2",.F.)
				SX2->X2_MODO := aSX2[ni][nPos]
				SX2->(MsUnlock())
				SX2->(dbCommit())
				lAjEfetua := .T.*/
			Endif
			//Caso o compartilhamento da unidade de negocio seja diferente, editar.
			If !Empty(nPos := aScan(aEstru,{|x| x == "X2_MODOUN"})) .AND. ;
				PadR(AllTrim(SX2->X2_MODOUN),1) # PadR(AllTrim(aSX2[ni][nPos]),1)
				
				cRet += "- Ajuste do modo de compartilhamento (unidade negócio) : [" + aSX2[ni][1] + "] DE : " + SX2->X2_MODOUN + " PARA : " + aSX2[ni][nPos] + CRLF
				/* Removido\Ajustado - Não executa mais RecLock na X2
				RecLock("SX2",.F.)
				SX2->X2_MODOUN := aSX2[ni][nPos]
				SX2->(MsUnlock())
				SX2->(dbCommit())
				lAjEfetua := .T.*/
			Endif
			//Caso o compartilhamento do grupo de empresa seja diferente, editar.
			If !Empty(nPos := aScan(aEstru,{|x| x == "X2_MODOEMP"})) .AND. ;
				PadR(AllTrim(SX2->X2_MODOEMP),1) # PadR(AllTrim(aSX2[ni][nPos]),1)
				
				cRet += "- Ajuste do modo de compartilhamento (grupo empresa) : [" + aSX2[ni][1] + "] DE : " + SX2->X2_MODOEMP + " PARA : " + aSX2[ni][nPos] + CRLF
				/* Removido\Ajustado - Não executa mais RecLock na X2
				RecLock("SX2",.F.)
				SX2->X2_MODOEMP := aSX2[ni][nPos]
				SX2->(MsUnlock())
				SX2->(dbCommit())
				lAjEfetua := .T.*/
			Endif
		Endif
	Endif
Next ni
If !Empty(cRet)
	cRet := Replicate("-",nTamDiv) + CRLF + "AJUSTES NO SX2 : " + CRLF + cRet
Endif

Return cRet

//--------------------------------------------------------------
/*/{Protheus.doc} ProcAjSX3
Rotina para processar as atualizacoes no SX3

@param : Nenhum

@return : Nenhum

@author  Pablo Gollan Carreras [RVG]
@since 14/02/2014
/*/
//--------------------------------------------------------------

Static Function ProcAjSX3(aArq)

Local cRet				:= ""
Local aSX3				:= {}
Local aEstru			:= {}
Local ni				:= 0
Local nx				:= 0
Local cAlias			:= ""
Local cSeq				:= ""
Local uTMP				:= ""
Local aLstAC			:= {"aVld","aCmb","aIni"}	//Lista de arrays de controle
Local nTamFil			:= IIf(FindFunction("FWSIZEFILIAL"),FWSizeFilial(),2)
Local aVld				:= {}
Local aCmb				:= {}
Local aIni				:= {}
Local aTam				:= {}
Local aTMP				:= {}
Local aLstCAP			:= {}						//Campos para alteracao de posicionamento de pastas
Local nPos				:= 0
Local nPos02			:= 0
Local bPicN				:= {|x,y| oFunc:RetPictNumerica(x,y,,.T.)}
Local cChv01			:= ""
Local aLExBlEmp			:= {}
Local aLCxBlEmp			:= {}
Local aLTbLOG			:= {}
Local aCpLOG			:= Array(2)
Local aLCpLOG			:= {}
Local bForma01			:= {|x| Upper(AllTrim(x))}
Local bChgOrd			:= {|| }
Local bExCp				:= {|x| IIf(!AliasInDic(FWTabPref(x)),.F.,;
							(SX3->(dbSetOrder(2)),SX3->(dbSeek(Upper(PadR(x,10)))),SX3->(Found())))}
Local aLTbBLQ			:= {""}
Local aLCpBLQ			:= {}
Local cCpBLQ			:= ""
Local aTabChgOrd		:= {}

Private bSXA			:= {|x,z| AllTrim(AllToChar(RetSXA(x,aPst[z])))}

aEstru := {"X3_ARQUIVO","X3_ORDEM","X3_CAMPO","X3_TIPO","X3_TAMANHO","X3_DECIMAL","X3_TITULO","X3_TITSPA","X3_TITENG","X3_DESCRIC","X3_DESCSPA","X3_DESCENG",;
	"X3_PICTURE","X3_VALID","X3_USADO","X3_RELACAO","X3_F3","X3_NIVEL","X3_RESERV","X3_CHECK","X3_TRIGGER","X3_PROPRI","X3_BROWSE","X3_VISUAL","X3_CONTEXT","X3_OBRIGAT",;
	"X3_VLDUSER","X3_CBOX","X3_CBOXSPA","X3_CBOXENG","X3_PICTVAR","X3_WHEN","X3_INIBRW" ,"X3_GRPSXG" ,"X3_FOLDER","X3_PYME","X3_CHKSQL"}

dbSelectArea("SX3")
SX3->(dbSetOrder(2))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³SA1 - CLIENTES  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aEval(aLstAC,{|x| &(x) := Array(0)})

//         X3_ARQUIVO	,X3_ORDEM	,X3_CAMPO		,X3_TIPO	,X3_TAMANHO		,X3_DECIMAL	,X3_TITULO			,X3_TITSPA			,X3_TITENG			,X3_DESCRIC							,X3_DESCSPA							,X3_DESCENG							,X3_PICTURE										,X3_VALID													,X3_USADO				,X3_RELACAO													,X3_F3			,X3_NIVEL	,X3_RESERV		,X3_CHECK	,X3_TRIGGER	,X3_PROPRI	,X3_BROWSE	,X3_VISUAL	,X3_CONTEXT		,X3_OBRIGAT	,X3_VLDUSER											,X3_CBOX												,X3_CBOXSPA										,X3_CBOXENG									,X3_PICTVAR				,X3_WHEN										,X3_INIBRW									,X3_GRPSXG	,X3_FOLDER	,X3_PYME	,X3_CHKSQL
aAdd(aSX3,{"SA1"		,"01"		,"A1_XAVSAV"	,"N"		,002			,00			,"Aviso Antec."		,"Aviso Antec."		,"Aviso Antec."		,"Nr.dias antes venc.titulo"		,"Nr.dias antes venc.titulo"		,"Nr.dias antes venc.titulo"		,"99"											,""															,X3_USADO_EMUSO			,""															,""				,1			,X3_RESER		,""			,""			,"U"		,"N"		,"A"		,"R"			,""			,""													,""														,""												,""											,""						,""												,""											,""			,"2"		,""			,""})
aAdd(aSX3,{"SA1"		,"02"		,"A1_XAVSDV"	,"N"		,002			,00			,"Aviso Poste."		,"Aviso Poste."		,"Aviso Poste."		,"Nr.dias apos venc.titulo"			,"Nr.dias apos venc.titulo"			,"Nr.dias apos venc.titulo"			,"99"											,""															,X3_USADO_EMUSO			,""															,""				,1			,X3_RESER		,""			,""			,"U"		,"N"		,"A"		,"R"			,""			,""													,""														,""												,""											,""						,""												,""											,""			,"2"		,""			,""})
aAdd(aSX3,{"SA1"		,"03"		,"A1_XAVSEML"	,"C"		,080			,00			,"Email aviso"		,"Email aviso"		,"Email aviso"		,"Email de aviso financeiro"		,"Email de aviso financeiro"		,"Email de aviso financeiro"		,"@&"											,""															,X3_USADO_EMUSO			,""															,""				,1			,X3_RESER		,""			,""			,"U"		,"N"		,"A"		,"R"			,""			,""													,""														,""												,""											,""						,""												,""											,""			,"2"		,""			,""})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³SE1 - CONTAS A RECEBER  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aEval(aLstAC,{|x| &(x) := Array(0)})

//         X3_ARQUIVO	,X3_ORDEM	,X3_CAMPO		,X3_TIPO	,X3_TAMANHO		,X3_DECIMAL	,X3_TITULO			,X3_TITSPA			,X3_TITENG			,X3_DESCRIC							,X3_DESCSPA							,X3_DESCENG							,X3_PICTURE										,X3_VALID													,X3_USADO				,X3_RELACAO													,X3_F3			,X3_NIVEL	,X3_RESERV		,X3_CHECK	,X3_TRIGGER	,X3_PROPRI	,X3_BROWSE	,X3_VISUAL	,X3_CONTEXT		,X3_OBRIGAT	,X3_VLDUSER											,X3_CBOX												,X3_CBOXSPA										,X3_CBOXENG									,X3_PICTVAR				,X3_WHEN										,X3_INIBRW									,X3_GRPSXG	,X3_FOLDER	,X3_PYME	,X3_CHKSQL
aAdd(aSX3,{"SE1"		,"01"		,"E1_XAVSAV"	,"D"		,008			,00			,"Aviso Antec."		,"Aviso Antec."		,"Aviso Antec."		,"Data aviso vencto.titulo"			,"Data aviso vencto.titulo"			,"Data aviso vencto.titulo"			,"@D"											,""															,X3_USADO_EMUSO			,""															,""				,1			,X3_RESER		,""			,""			,"U"		,"N"		,"V"		,"R"			,""			,""													,""														,""												,""											,""						,""												,""											,""			,""			,""			,""})
aAdd(aSX3,{"SE1"		,"02"		,"E1_XAVSDV"	,"D"		,008			,00			,"Aviso Poste."		,"Aviso Poste."		,"Aviso Poste."		,"Data aviso titulo vencido"		,"Data aviso titulo vencido"		,"Data aviso titulo vencido"		,"@D"											,""															,X3_USADO_EMUSO			,""															,""				,1			,X3_RESER		,""			,""			,"U"		,"N"		,"V"		,"R"			,""			,""													,""														,""												,""											,""						,""												,""											,""			,""			,""			,""})
aAdd(aSX3,{"SE1"		,"03"		,"E1_XAVSDVN"	,"N"		,002			,00			,"Nr.Avisos"		,"Nr.Avisos"		,"Nr.Avisos"		,"Nr.avisos titulo vencido"			,"Nr.avisos titulo vencido"			,"Nr.avisos titulo vencido"			,"99"											,""															,X3_USADO_EMUSO			,""															,""				,1			,X3_RESER		,""			,""			,"U"		,"N"		,"V"		,"R"			,""			,""													,""														,""												,""											,""						,""												,""											,""			,""			,""			,""})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criar campos de LOG de inclusao e alteracao nas tabelas relacionadas  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For ni := 1 to Len(aLTbLOG)
	//Log de inclusao
	aAdd(aLCpLOG,aCpLOG[1] := oFunc:RetCampoLOG(aLTbLOG[ni],1))
	//Log de alteracao
	aAdd(aLCpLOG,aCpLOG[2] := oFunc:RetCampoLOG(aLTbLOG[ni],2))
	//			X3_ARQUIVO		,X3_ORDEM	,X3_CAMPO		,X3_TIPO	,X3_TAMANHO	,X3_DECIMAL	,X3_TITULO		,X3_TITSPA		,X3_TITENG		,X3_DESCRIC					,X3_DESCSPA					,X3_DESCENG					,X3_PICTURE					,X3_VALID						,X3_USADO			,X3_RELACAO					,X3_F3	,X3_NIVEL	,X3_RESERV		,X3_CHECK	,X3_TRIGGER	,X3_PROPRI	,X3_BROWSE	,X3_VISUAL	,X3_CONTEXT	,X3_OBRIGAT	,X3_VLDUSER	,X3_CBOX						,X3_CBOXSPA						,X3_CBOXENG						,X3_PICTVAR	,X3_WHEN						,X3_INIBRW						,X3_GRPSXG	,X3_FOLDER				,X3_PYME	,X3_CHKSQL
	aAdd(aSX3,{aLTbLOG[ni]		,"01"		,aCpLOG[1]		,"C"		,017			,00		,"Log de Inclu"	,"Log de Inclu"	,"Log de Inclu"	,"Log de Inclusao"			,"Log de Inclusao"			,"Log de Inclusao"			,""							,""								,X3_USADO_RES		,""							,""		,9			,X3_RESLOG		,""			,""			,"L"		,"N"		,"V"		,"R"		,""			,""			,""								,""								,""								,""			,""								,""								,""			,""						,"S"		,""})
	aAdd(aSX3,{aLTbLOG[ni]		,"02"		,aCpLOG[2]		,"C"		,017			,00		,"Log de Alter"	,"Log de Alter"	,"Log de Alter"	,"Log de Alteracao"			,"Log de Alteracao"			,"Log de Alteracao"			,""							,""								,X3_USADO_RES		,""							,""		,9			,X3_RESLOG		,""			,""			,"L"		,"N"		,"V"		,"R"		,""			,""			,""								,""								,""								,""			,""								,""								,""			,""						,"S"		,""})
Next ni

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criar campos de BLOQUEIO nas tabelas relacionadas  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For ni := 1 to Len(aLTbBLQ)
	aAdd(aLCpBLQ,cCpBLQ := IIf(Substr(aLTbBLQ[ni],1,1) == "S",Substr(aLTbBLQ[ni],2,Len(aLTbBLQ[ni])),aLTbBLQ[ni]) + "_MSBLQL")
	//			X3_ARQUIVO		,X3_ORDEM	,X3_CAMPO		,X3_TIPO	,X3_TAMANHO	,X3_DECIMAL	,X3_TITULO		,X3_TITSPA		,X3_TITENG		,X3_DESCRIC					,X3_DESCSPA					,X3_DESCENG					,X3_PICTURE					,X3_VALID						,X3_USADO			,X3_RELACAO					,X3_F3	,X3_NIVEL	,X3_RESERV		,X3_CHECK	,X3_TRIGGER	,X3_PROPRI	,X3_BROWSE	,X3_VISUAL	,X3_CONTEXT	,X3_OBRIGAT	,X3_VLDUSER	,X3_CBOX						,X3_CBOXSPA						,X3_CBOXENG						,X3_PICTVAR	,X3_WHEN						,X3_INIBRW						,X3_GRPSXG	,X3_FOLDER				,X3_PYME	,X3_CHKSQL
	aAdd(aSX3,{aLTbBLQ[ni]		,"01"		,cCpBLQ			,"C"		,001		,00			,"Bloqueado?"	,"Bloqueado?"	,"Bloqueado?"	,"Registro bloqueado"		,"Registro bloqueado"		,"Registro bloqueado"		,""							,""								,X3_USADO_RES		,"'2'"						,""		,9			,X3_RESBLQ		,""			,""			,"L"		,"N"		,"A"		,"R"		,""			,""			,"1=Sim;2=Nao"					,"1=Si;2=No"					,"1=Yes;2=No"					,""			,""								,""								,""			,""						,"S"		,""})
Next ni

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Ajuste de campos pontuais  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aTMP := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Gravar os helps de campos com as informacoes do campo de descricao.  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For ni := 1 to Len(aSX3)
	HelpGrv(aSX3[ni][3],"P",aSX3[ni][10])
Next ni

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Processamento SX3  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Empty(aSX3) ; Return cRet ; Endif
oBarra:SetRegua2(Len(aSX3))
bChgOrd := {|lNovo| IIf(lNovo .OR. AllTrim(SX3->(FieldName(nx))) == "X3_ORDEM",IIf(!Empty(aScan(aTabChgOrd,{|x| x == aSX3[ni][1]})),.T.,.F.),.T.)}
For ni := 1 To Len(aSX3)
	cChv01 := PadR(aSX3[ni][3],Len(SX3->X3_CAMPO))
	oBarra:IncRegua2("[" + cChv01 + "]")
	If !Empty(aSX3[ni][1])
		If !SX3->(dbSeek(cChv01))
			//Caso o acesso nao seja exclusivo, vetar inclusoes (exceto se tratar-se de um campo virtual)
			If lAjSExc .AND. aSX3[ni][aScan(aEstru,{|x| x == "X3_CONTEXT"})] # "V"
				Loop
			Endif
			cRet += "- Inclusão do campo : " + aSX3[ni][3] + CRLF
			cAliasAtu := ""
			If !aSX3[ni][1] $ cAlias .AND. aScan(aArq,{|x| AllTrim(x) == AllTrim(aSX3[ni][1])}) == 0
				cAlias += aSX3[ni][1] + "/"
				aAdd(aArq,aSX3[ni][1])
			Endif
			//Sequencia da ordem
			If Eval(bChgOrd,.T.)
				//Caso seja um campo reservado de LOG ou de bloqueio, utilizar proxima sequencia
				If !Empty(aScan(aLCpLOG,{|x| AllTrim(x) == AllTrim(aSX3[ni][3])})) .OR. ;
					!Empty(aScan(aLCpBLQ,{|x| AllTrim(x) == AllTrim(aSX3[ni][3])}))
					
					cSeq := ProxSX3(aSX3[ni][1],aSX3[ni][3])
				Else
					cSeq := aSX3[ni][2]
				Endif
			Else
				cSeq := ProxSX3(aSX3[ni][1],aSX3[ni][3])
			Endif
			RecLock("SX3",.T.)
			For nx := 1 To Len(aSX3[ni])
				If nx == 2	//Ordem
					FieldPut(FieldPos(aEstru[nx]),cSeq)
				Elseif SX3->(FieldPos(aEstru[nx])) > 0
					FieldPut(FieldPos(aEstru[nx]),aSX3[ni][nx])
				Endif
			Next nx
			SX3->(MsUnLock())
			SX3->(dbCommit())
			lAjEfetua := .T.
		Else
			//Caso o campo seja bloqueado para edicao numa determinada empresa bloqueada, ignorar alteracoes do campo
			If !Empty(aScan(aLExBlEmp,{|x| AllTrim(x) == cEmpAnt})) .AND. !Empty(aScan(aLCxBlEmp,{|x| AllTrim(x) == AllTrim(aSX3[ni][3])}))
				Loop
			Endif
			//Caso seja um campo reservado de LOG ou de bloqueio, nao alterar
			If !Empty(aScan(aLCpLOG,{|x| AllTrim(x) == AllTrim(aSX3[ni][3])})) .OR. ;
				!Empty(aScan(aLCpBLQ,{|x| AllTrim(x) == AllTrim(aSX3[ni][3])}))
			
				Loop
			Endif
			//Verificar os campos
			For nx := 1 To Len(aSX3[ni])
				If aEstru[nx] == SX3->(FieldName(nx)) .AND. ;
					Eval(bChgOrd,.F.) .AND. ;
					PadR(StrTran(AllToChar(SX3->(FieldGet(nx)))," ",""),250) # PadR(StrTran(AllToChar(aSX3[ni][nx])," ",""),250)

					//Caso o acesso nao seja exclusivo, vetar a edicao de campos relacionados com a estrutura de tabela
					If lAjSExc .AND. !Empty(aScan({"X3_ARQUIVO","X3_ORDEM","X3_CAMPO","X3_TIPO","X3_TAMANHO","X3_DECIMAL"},;
						{|x| x == Upper(AllTrim(aEstru[nx]))}))

						Loop
					Endif
					//Montar LOG de alteracao (campos usado, reserva e obrigatorio nao tem suas alteracoes declaradas por seus conteudos)
					cRet += "- Alteracao do campo : " + aSX3[ni][3] + " [" + AllTrim(SX3->(FieldName(nx))) + "] "
					If !AllTrim(SX3->(FieldName(nx))) $ "X3_USADO|X3_RESERV|X3_OBRIGAT"
						cRet += "DE : " + IIf(Empty(AllToChar(SX3->(FieldGet(nx)))),"VAZIO",AllTrim(AllToChar(SX3->(FieldGet(nx))))) + ;
							" PARA : " + IIf(Empty(AllToChar(aSX3[ni][nx])),"VAZIO",AllTrim(AllToChar(aSX3[ni][nx])))
					Endif
					cRet += CRLF
					RecLock("SX3",.F.)
					FieldPut(FieldPos(aEstru[nx]),aSX3[ni][nx])
					SX3->(MsUnLock())
					SX3->(dbCommit())
					lAjEfetua := .T.
					If !aSX3[ni][1] $ cAlias .AND. aScan(aArq,{|x| AllTrim(x) == AllTrim(aSX3[ni][1])}) == 0
						cAlias += aSX3[ni][1] + "/"
						aAdd(aArq,aSX3[ni][1])
					Endif
				Endif
			Next nx
		Endif
	Endif
Next ni
If !Empty(cRet)
	cRet := Replicate("-",nTamDiv) + CRLF + "AJUSTES NO SX3 : " + CRLF + cRet
Endif

Return cRet

//--------------------------------------------------------------
/*/{Protheus.doc} ProcAjSX5
Rotina para processar as atualizacoes no SX5

@param : Nenhum

@return : Nenhum

@author  Pablo Gollan Carreras [RVG]
@since 14/02/2014
/*/
//--------------------------------------------------------------

Static Function ProcAjSX5()

Local aEstru			:= {}
Local ni      			:= 0
Local nx				:= 0
Local lSX5	 			:= .F.
Local cRet   			:= ""
Local cFilX5			:= xFilial("SX5")
Local aLstZE			:= {}
Local cChv01			:= ""
Local bForma01			:= {|x| Upper(NoAcento(OemToAnsi(x)))}

Private aSX5   		:= {}

If cPaisLoc == "BRA"
	aEstru := {"X5_FILIAL","X5_TABELA","X5_CHAVE","X5_DESCRI","X5_DESCSPA","X5_DESCENG"}
Else
	aEstru := {"X5_FILIAL","X5_TABELA","X5_CHAVE","X5_DESCRI","X5_DESCSPA","X5_DESCENG"}
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Processamento SX5  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Empty(aSX5) ; Return cRet ; Endif
oBarra:SetRegua2(Len(aSX5))
dbSelectArea("SX5")
SX5->(dbSetOrder(1))
For ni := 1 To Len(aSX5)
	cChv01 := aSX5[ni][1] + aSX5[ni][2] + aSX5[ni][3]
	oBarra:IncRegua2("[" + cChv01 + "]")
	If !Empty(aSX5[ni][2])
		If !SX5->(dbSeek(cChv01))
    		lSX5 := .T.
    		cRet += "- Inclusão da chave : " + aSX5[ni][2] + " (" + aSX5[ni][3] + ") " + aSX5[ni][4] + CRLF
			RecLock("SX5",.T.)
			For nx := 1 To Len(aSX5[ni])
				If !Empty(SX5->(FieldName(FieldPos(aEstru[nx]))))
					FieldPut(FieldPos(aEstru[nx]),aSX5[ni][nx])
				EndIf
			Next nx
			SX5->(MsUnLock())
			SX5->(dbCommit())
		Else
			//Caso nao seja permitido a alteracao de valores pre-existentes na SX5, saltar
			If !lAjVlPrEx
				Loop
			Endif
			//Verificar os campos
			For nx := 1 To Len(aSX5[ni])
				If aEstru[nx] == SX5->(FieldName(nx)) .AND. ;
					PadR(StrTran(AllToChar(SX5->(FieldGet(nx)))," ",""),250) # PadR(StrTran(AllToChar(aSX5[ni][nx])," ",""),250)

					cRet += "- Alteracao do tabela : " + aSX5[ni,1] + "-" + aSX5[ni,2] + "-" + aSX5[ni,3] + " [" + AllTrim(SX5->(FieldName(nx))) + "] " + ;
						"DE : " + IIf(Empty(AllToChar(SX5->(FieldGet(nx)))),"VAZIO",AllTrim(AllToChar(SX5->(FieldGet(nx))))) + ;
						" PARA : " + IIf(Empty(AllToChar(aSX5[ni][nx])),"VAZIO",AllTrim(AllToChar(aSX5[ni][nx]))) + CRLF
					RecLock("SX5",.F.)
					FieldPut(FieldPos(aEstru[nx]),aSX5[ni][nx])
					SX5->(MsUnLock())
					SX5->(dbCommit())
				Endif
			Next nx
		Endif
	Endif
Next ni
If !Empty(cRet) .AND. lSX5
	cRet := Replicate("-",nTamDiv) + CRLF + "AJUSTES NO SX5 : " + CRLF + cRet
Endif

Return cRet

//--------------------------------------------------------------
/*/{Protheus.doc} ProcAjSX6
Rotina para processar as atualizacoes no SX6

@param : Nenhum

@return : Nenhum

@author  Pablo Gollan Carreras [RVG]
@since 14/02/2014
/*/
//--------------------------------------------------------------

Static Function ProcAjSX6()

Local cRet				:= ""
Local aSX6				:= {}
Local aEstru			:= {}
Local cFil				:= Space(oFunc:RetGroupSize("033","A1_FILIAL"))
Local ni				:= 0
Local nx				:= 0
Local cChv01			:= ""
Local aLPAltCon			:= {}	//Lista de parametros que devem ter o conteudo alterado caso esteja diferente
Local aLstFil			:= IIf(FindFunction("FWAllFilial"),FWAllFilial(,,,.T.),Array(0))

aEstru := {"X6_FIL","X6_VAR","X6_TIPO","X6_DESCRIC","X6_DSCSPA","X6_DSCENG","X6_DESC1","X6_DSCSPA1","X6_DSCENG1","X6_DESC2",;
	"X6_DSCSPA2","X6_DSCENG2","X6_CONTEUD","X6_CONTSPA","X6_CONTENG","X6_PROPRI","X6_PYME"}

//         X6_FIL	,X6_VAR			,X6_TIPO	,X6_DESCRIC														,X6_DSCSPA													,X6_DSCENG													,X6_DESC1													,X6_DSCSPA1														,X6_DSCENG1														,X6_DESC2													,X6_DSCSPA2														,X6_DSCENG2														,X6_CONTEUD																			,X6_CONTSPA																	,X6_CONTENG																	,X6_PROPRI	,X6_PYME
aAdd(aSX6,{cFil		,"MV_XLOGURL"	,"C"		,"URL do logo da empresa p/ WF e emails"						,"URL do logo da empresa p/ WF e emails"					,"URL do logo da empresa p/ WF e emails"					,""															,""																,""																,""															,""																,""																,"http://www.steck.com.br/wp-content/themes/temasteck/img/slider/logo.png"			,"http://www.steck.com.br/wp-content/themes/temasteck/img/slider/logo.png"	,"http://www.steck.com.br/wp-content/themes/temasteck/img/slider/logo.png"	,"U"		,""})
aAdd(aSX6,{cFil		,"MV_XDIASAR"	,"N"		,"Dias para aviso de atraso recorrente"							,"Dias para aviso de atraso recorrente"						,"Dias para aviso de atraso recorrente"						,""															,""																,""																,""															,""																,""																,"7"																				,"7"																		,"7"																		,"U"		,""})
aAdd(aSX6,{cFil		,"MV_XMAXAR"	,"N"		,"Maximo envio aviso de atraso recorrente"						,"Maximo envio aviso de atraso recorrente"					,"Maximo envio aviso de atraso recorrente"					,""															,""																,""																,""															,""																,""																,"5"																				,"5"																		,"5"																		,"U"		,""})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Processamento SX6  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Empty(aSX6) ; Return cRet ; Endif
oBarra:SetRegua2(Len(aSX6))
dbSelectArea("SX6")
SX6->(dbSetOrder(1))
For ni := 1 to Len(aSX6)
	cChv01 := aSX6[ni][1] + PadR(aSX6[ni][2],Len(SX6->X6_VAR))
	oBarra:IncRegua2("[" + cChv01 + "]")
	If !SX6->(dbSeek(cChv01))
		//Caso nao tenha sido encontrado e possua filial declarada, validar se a filial existe na empresa posicionada
		If !Empty(aSX6[ni][1]) .AND. Empty(aScan(aLstFil,{|x| AllTrim(x) == AllTrim(aSX6[ni][1])}))
			Loop
		Endif
		cRet += "- Inclusão do parâmetro : " + aSX6[ni][2] + CRLF
		RecLock("SX6",.T.)
		For nx := 1 to Len(aEstru)
			If SX6->(FieldPos(aEstru[nx])) > 0
				SX6->&(aEstru[nx]) := aSX6[ni][nx]
			Endif
		Next nx
		SX6->(MsUnlock())
		SX6->(dbCommit())
		lAjEfetua := .T.
	Else
		//Verificar os campos
		For nx := 1 To Len(aSX6[ni])
			//Nao alterar os campos de conteudo caso ja contenham um valor definido, desde que nao estejam na variavel aLPAltCon
			If aEstru[nx] $ "X6_CONTEUD|X6_CONTSPA|X6_CONTENG"
				//Caso nao seja permitido a alteracao de valores pre-existentes na SX6, saltar
				If !lAjVlPrEx
					If Empty(aScan(aLPAltCon,{|x| x == AllTrim(aSX6[ni][2])})) .AND. !Empty(SX6->&(aEstru[nx]))
						Loop
					Endif
				Endif
			Endif
			If aEstru[nx] == SX6->(FieldName(nx)) .AND. PadR(StrTran(AllToChar(SX6->(FieldGet(nx)))," ",""),250) # PadR(StrTran(AllToChar(aSX6[ni][nx])," ",""),250)
				cRet += "- Alteracao do parametro : " + aSX6[ni][2] + " [" + AllTrim(SX6->(FieldName(nx))) + "] " + ;
					"DE : " + IIf(Empty(AllToChar(SX6->(FieldGet(nx)))),"VAZIO",AllTrim(AllToChar(SX6->(FieldGet(nx))))) + ;
					" PARA : " + IIf(Empty(AllToChar(aSX6[ni][nx])),"VAZIO",AllTrim(AllToChar(aSX6[ni][nx]))) + CRLF
				RecLock("SX6",.F.)
				FieldPut(FieldPos(aEstru[nx]),aSX6[ni][nx])
				SX6->(MsUnLock())
				SX6->(dbCommit())
				lAjEfetua := .T.
			Endif
		Next nx
	Endif
Next ni
If !Empty(cRet)
	cRet := Replicate("-",nTamDiv) + CRLF + "AJUSTES NO SX6 : " + CRLF + cRet
Endif

Return cRet

//--------------------------------------------------------------
/*/{Protheus.doc} ProcAjSX7
Rotina para processar as atualizacoes no SX7

@param : Nenhum

@return : Nenhum

@author  Pablo Gollan Carreras [RVG]
@since 14/02/2014
/*/
//--------------------------------------------------------------

Static Function ProcAjSX7()

Local aSX7   			:= {}
Local aEstru           	:= {}
Local ni      			:= 0
Local nx      			:= 0
Local cRet	 			:= ""
Local cTMP     			:= ""
Local lSX7	 			:= .F.
Local cChv01			:= ""

If cPaisLoc == "BRA"
	aEstru := {"X7_CAMPO","X7_SEQUENC","X7_REGRA","X7_CDOMIN","X7_TIPO","X7_SEEK","X7_ALIAS","X7_ORDEM","X7_CHAVE","X7_CONDIC","X7_PROPRI"}
Else
	aEstru := {"X7_CAMPO","X7_SEQUENC","X7_REGRA","X7_CDOMIN","X7_TIPO","X7_SEEK","X7_ALIAS","X7_ORDEM","X7_CHAVE","X7_CONDIC","X7_PROPRI"}
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Processamento SX7  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Empty(aSX7) ; Return cRet ; Endif
oBarra:SetRegua2(Len(aSX7))
dbSelectArea("SX7")
SX7->(dbSetOrder(1))
For ni := 1 To Len(aSX7)
	cChv01 := PadR(aSX7[ni][1],10) + aSX7[ni][2]
	oBarra:IncRegua2("[" + cChv01 + "]")
	If !Empty(aSX7[ni][1])
		If !SX7->(dbSeek(cChv01))
			lSX7 := .T.
			cTMP := "- Inclusão do gatilho : " + aSX7[ni][1] + "-" + aSX7[ni][2]
			If !cTMP $ cRet
				cRet += cTMP + CRLF
			Endif
			RecLock("SX7",.T.)
			For nx := 1 To Len(aSX7[ni])
				If !Empty(FieldName(FieldPos(aEstru[nx])))
					FieldPut(FieldPos(aEstru[nx]),aSX7[ni,nx])
				EndIf
			Next nx
			SX7->(MsUnLock())
			SX7->(dbCommit())
			lAjEfetua := .T.
		Else
			//Caso esteja vetado alteracoes, saltar
			If !lAltREGEx
				Loop
			Endif
			//Verificar os campos alterados
			For nx := 1 To Len(aSX7[ni])
				If aEstru[nx] == SX7->(FieldName(nx)) .AND. AllTrim(SX7->(FieldName(nx))) # "X7_SEQUENC" .AND. ;
					PadR(StrTran(AllToChar(SX7->(FieldGet(nx)))," ",""),250) # PadR(StrTran(AllToChar(aSX7[ni][nx])," ",""),250)

					cRet += "- Alteracao do gatilho : " + aSX7[ni][1] + " [" + AllTrim(SX7->(FieldName(nx))) + "] " + ;
						"DE : " + IIf(Empty(AllToChar(SX7->(FieldGet(nx)))),"VAZIO",AllTrim(AllToChar(SX7->(FieldGet(nx))))) + ;
						" PARA : " + IIf(Empty(AllToChar(aSX7[ni][nx])),"VAZIO",AllTrim(AllToChar(aSX7[ni][nx]))) + CRLF
					RecLock("SX7",.F.)
					FieldPut(FieldPos(aEstru[nx]),aSX7[ni][nx])
					SX7->(MsUnLock())
					SX7->(dbCommit())
					lAjEfetua := .T.
				Endif
			Next nx
		Endif
	Endif
Next ni
If !Empty(cRet)
	cRet := Replicate("-",nTamDiv) + CRLF + "AJUSTES NO SX7 : " + CRLF + cRet
Endif

Return cRet

//--------------------------------------------------------------
/*/{Protheus.doc} ProcAjSXA
Rotina para processar as atualizacoes no SXA

@param : Nenhum

@return : Nenhum

@author  Pablo Gollan Carreras [RVG]
@since 14/02/2014
/*/
//--------------------------------------------------------------

Static Function ProcAjSXA()

Local cRet				:= ""
Local aSXA				:= {}
Local aEstru			:= {}
Local ni				:= 0
Local nx				:= 0
Local lNovo				:= .T.
Local nPos				:= 0
Local cChv01			:= ""

aEstru := {"XA_ALIAS","XA_ORDEM","XA_DESCRIC","XA_DESCSPA","XA_DESCENG","XA_PROPRI"}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Processamento SXA  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Empty(aSXA) ; Return cRet ; Endif
oBarra:SetRegua2(Len(aSXA))
dbSelectArea("SXA")
SXA->(dbSetOrder(1))
For ni := 1 To Len(aSXA)
	cChv01 := aSXA[ni][1]
	oBarra:IncRegua2("[" + cChv01 + "]")
	lNovo := .T.
	If !Empty(aSXA[ni][1])
		//Verificar se a pasta jah existe
		SXA->(dbSeek(cChv01))
		Do While !SXA->(Eof()) .AND. SXA->XA_ALIAS == cChv01
			If Upper(PadR(aSXA[ni][3],nTAMSXAD)) == Upper(PadR(SXA->XA_DESCRIC,nTAMSXAD))
				lNovo := !lNovo
				Exit
			Endif
			SXA->(dbSkip())
		EndDo
		//Caso ainda nao exista, incluir
		If lNovo
            aSXA[ni][2] := ProxSXA(aSXA[ni][1])
			cRet += "- Inclusão de pasta : " + aSXA[ni][2] + " (" + aSXA[ni][3] + ")" + CRLF 
			RecLock("SXA",.T.)
			For nx := 1 To Len(aEstru)
				If (nPos := SXA->(FieldPos(aEstru[nx]))) # 0
					SXA->(FieldPut(nPos,aSXA[ni][nx]))
				Endif
			Next nx
			SXA->(MsUnLock())
			SXA->(dbCommit())
		EndIf
	EndIf
Next ni
If !Empty(cRet)
	cRet := Replicate("-",nTamDiv) + CRLF + "AJUSTES NO SXA : " + CRLF + cRet 
Endif

Return cRet

//--------------------------------------------------------------
/*/{Protheus.doc} ProcAjSXB
Rotina para processar as atualizacoes no SXB

@param : Nenhum

@return : Nenhum

@author  Pablo Gollan Carreras [RVG]
@since 14/02/2014
/*/
//--------------------------------------------------------------

Static Function ProcAjSXB()

Local cRet				:= ""
Local aSXB				:= {}
Local aEstru			:= {}
Local cTMP				:= ""
Local ni				:= 0
Local nx				:= 0
Local cFiltro			:= ""
Local cChv01			:= ""

aEstru := {"XB_ALIAS","XB_TIPO","XB_SEQ","XB_COLUNA","XB_DESCRI","XB_DESCSPA","XB_DESCENG","XB_CONTEM"}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Processamento SXB  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Empty(aSXB) ; Return cRet ; Endif
oBarra:SetRegua2(Len(aSXB))
dbSelectArea("SXB")
SXB->(dbSetOrder(1))
For ni := 1 to Len(aSXB)
	cChv01 := PadR(aSXB[ni][1],Len(SXB->XB_ALIAS)) + aSXB[ni][2] + aSXB[ni][3] + aSXB[ni][4]
	oBarra:IncRegua2("[" + cChv01 + "]")
	If !SXB->(dbSeek(cChv01))
		cTMP := "- Inclusão da consulta padrão : " + aSXB[ni][1]
		If !cTMP $ cRet
			cRet += cTMP + CRLF
		Endif
		RecLock("SXB",.T.)
		For nx := 1 to Len(aEstru)
			If SXB->(FieldPos(aEstru[nx])) > 0
				SXB->&(aEstru[nx]) := aSXB[ni][nx]
			Endif
		Next nx
		SXB->(MsUnlock())
		SXB->(dbCommit())
		lAjEfetua := .T.
	Else
		//Verificar os campos
		For nx := 1 To Len(aSXB[ni])
			If aEstru[nx] == SXB->(FieldName(nx)) .AND. PadR(StrTran(AllToChar(SXB->(FieldGet(nx)))," ",""),250) # PadR(StrTran(AllToChar(aSXB[ni][nx])," ",""),250)
				cRet += "- Alteracao da cons. padrão : " + aSXB[ni][1] + "-" + aSXB[ni][2] + "-" + aSXB[ni][3] + "-" + aSXB[ni][4] + " [" + AllTrim(SXB->(FieldName(nx))) + "] " + ;
					"DE : " + IIf(Empty(AllToChar(SXB->(FieldGet(nx)))),"VAZIO",AllTrim(AllToChar(SXB->(FieldGet(nx))))) + ;
					" PARA : " + IIf(Empty(AllToChar(aSXB[ni][nx])),"VAZIO",AllTrim(AllToChar(aSXB[ni][nx]))) + CRLF
				RecLock("SXB",.F.)
				FieldPut(FieldPos(aEstru[nx]),aSXB[ni][nx])
				SXB->(MsUnLock())
				SXB->(dbCommit())
				lAjEfetua := .T.
			Endif
		Next nx
	Endif
Next ni
If !Empty(cRet)
	cRet := Replicate("-",nTamDiv) + CRLF + "AJUSTES NO SXB : " + CRLF + cRet
Endif

Return cRet

//--------------------------------------------------------------
/*/{Protheus.doc} ProcAjSIX
Rotina para processar as atualizacoes no SIX

@param : Nenhum

@return : Nenhum

@author  Pablo Gollan Carreras [RVG]
@since 14/02/2014
/*/
//--------------------------------------------------------------

Static Function ProcAjSIX(aArq,lSIX)

Local cRet				:= ""
Local aSIX				:= {}
Local aEstru			:= {}
Local ni				:= 0
Local nx				:= 0
Local lNovo				:= .T.
Local cAlias			:= ""
Local nPos				:= 0
Local cArq				:= ""
Local cOrdem			:= ""
Local cChv01			:= ""
Local bErro				:= {}				//Bloco de codigo para tratamento de erro
Local cErro				:= ""				//Mensagem de erro
Local lErro				:= .F.				//Aponta existencia de erro no processamento
Local lAtuaTOP			:= .F.				//Atualizar o TOP
Local lOk				:= .F.
Local aLstCp			:= {}

aEstru := {"INDICE","ORDEM","CHAVE","DESCRICAO","DESCSPA","DESCENG","PROPRI","F3","NICKNAME","SHOWPESQ"}

If Empty(aSIX) .OR. lAjSExc ; Return cRet ; Endif
dbSelectArea("SX3")
SX3->(dbSetOrder(2))	//X3_CAMPO
dbSelectArea("SIX")
SIX->(dbSetOrder(1))
//Caso os indices devam ser recriado em base, apagar todos indices customizados para recriar
If lForcaSIX
	SIX->(dbGoTop())
	oBarra:SetRegua2(SIX->(RecCount()))
	Do While !SIX->(Eof())
		oBarra:IncRegua2("Apagando indices customizados para recriar")
		If SIX->PROPRI == "U" .AND. !SIX->(Deleted())
			Sleep(50)
			RecLock("SIX",.F.)
			SIX->(dbDelete())
			SIX->(MsUnlock())
		Endif
		SIX->(dbSkip())
	EndDo
	SIX->(Pack())
Endif
oBarra:SetRegua2(Len(aSIX))
For ni := 1 To Len(aSIX)
	If aSIX[ni][1] == "CC4"
		cChv01 := ""
	Endif
	cChv01 := aSIX[ni][1] + aSIX[ni][2]
	oBarra:IncRegua2("[" + cChv01 + "]")
	If !Empty(aSIX[ni][1])
		If !SIX->(dbSeek(cChv01))
			lNovo := .T.
			lOk := .T.
			//Validar se jah nao existe algum indice com a mesma combinacao de campos o que causaria um erro de lista de colunas jah indexadas
			//ORA-1408:such column list already indexed
			cChv01 := aSIX[ni][1]
			SIX->(dbSeek(cChv01))
			If SIX->(Found())
				Do While !SIX->(Eof()) .AND. SIX->INDICE == cChv01
					If !SIX->(Deleted()) .AND. StrTran(AllTrim(SIX->CHAVE)," ","") == StrTran(AllTrim(aSIX[ni][3])," ","")
						cRet += "- Indice não criado por duplicidade na chave : " + aSIX[ni][1] + " (" + aSIX[ni][2] + ") " + aSIX[ni][3] + CRLF
						lOk := !lOk
						Exit
					Endif
					SIX->(dbSkip())
				EndDo
			Endif
			//Validar se os campos que compoe o indice constam no dicionario
			If lOk .AND. !Empty(aLstCp := StrTokArr(RTrim(aSIX[ni][3]),"+"))
				For nx := 1 to Len(aLstCp)
					If !SX3->(dbSeek(PadR(aLstCp[nx],10)))
						lOk := !lOk
						Exit
					Endif
				Next nx
			Endif
			//Caso a chave jah esteja presente em outro indice da tabela, saltar
			If !lOk
				Loop
			Endif
		Else
			//Identificar se nao se trata apenas de alteracao de NICKNAME, para evitar recriar o indice desnecessariamente
			If !lForcaSIX .AND. AllTrim(SIX->NICKNAME) # AllTrim(aSIX[ni][9]) .AND. SIX->PROPRI # "S"
				lOk := .T.
				For nx := 1 To Len(aSIX[ni])
					If aEstru[nx] == SIX->(FieldName(nx)) .AND. ;
						AllTrim(SIX->(FieldName(nx))) # "NICKNAME" .AND. ;
						PadR(StrTran(AllToChar(SIX->(FieldGet(nx)))," ",""),250) # PadR(StrTran(AllToChar(aSIX[ni][nx])," ",""),250)

						lOk := .F.
						Exit
					Endif
				Next nx
				If lOk
					cRet += "- Alteracao de nickname do índice (" + SIX->ORDEM + ") : " + AllTrim(SIX->NICKNAME) + " -> " + aSIX[ni][9] + CRLF
					RecLock("SIX",.F.)
					SIX->NICKNAME	:= aSIX[ni][9]
					SIX->(MsUnlock())
					Loop
				Endif
			Endif
			//Verificar se a ordem do indice jah esta sendo utilizado pelo usuario e se o mesmo possui um nickname.
			//Caso possua, empurrar o indice para a ultima posicao
			If !Empty(SIX->NICKNAME) .AND. ;
				SIX->PROPRI # "S" .AND. ;
				AllTrim(SIX->NICKNAME) # AllTrim(aSIX[ni][9])

				cOrdem := RetProxInd(aSIX[ni,1])
				cRet += "- Alteracao de posição do índice (" + AllTrim(SIX->NICKNAME) + ") : " + SIX->ORDEM + " -> " + cOrdem + CRLF
				RecLock("SIX",.F.)
				SIX->ORDEM := cOrdem
				SIX->(MsUnlock())
				SIX->(dbCommit())
				lNovo := .T.
			Else
				lNovo := .F.
			Endif
		Endif
		//Caso a recriacao seja forcada, declarar alias na variavel de controle de arquivos
		If lForcaSIX .AND. Empty(aScan(aArq,{|x| AllTrim(x) == AllTrim(aSIX[ni][1])}))
			aAdd(aArq,aSIX[ni][1])
		Endif
		//Caso seja um novo indice e/ou a chave de indice esteja diferente (contanto que o proprietario seja o mesmo)
		If lNovo .OR. (Upper(AllTrim(SIX->CHAVE)) # Upper(Alltrim(aSIX[ni][3])) .AND. SIX->PROPRI == aSIX[ni][7])
			lSIX := .T.
			cRet += IIf(lNovo,"- Inclusão do índice : ","- Alteração do índice : ") + aSIX[ni][1] + " (" + aSIX[ni][2] + ") " + aSIX[ni][3] + CRLF
			If !aSIX[ni][1] $ cAlias .AND. aScan(aArq,{|x| AllTrim(x) == AllTrim(aSIX[ni][1])}) == 0
				cAlias += aSIX[ni][1] + "/"
				aAdd(aArq,aSIX[ni][1])
			Endif
			RecLock("SIX",lNovo)
			For nx := 1 To Len(aEstru)
				If (nPos := SIX->(FieldPos(aEstru[nx]))) # 0
					SIX->(FieldPut(nPos,aSIX[ni][nx]))
				Endif
			Next nx
			SIX->(MsUnLock())
			SIX->(dbCommit())
			lAjEfetua := .T.
		Else
			For nx := 1 To Len(aSIX[ni])
				If aEstru[nx] == SIX->(FieldName(nx)) .AND. ;
					PadR(StrTran(AllToChar(SIX->(FieldGet(nx)))," ",""),250) # PadR(StrTran(AllToChar(aSIX[ni][nx])," ",""),250)

					//Montar LOG de alteracao (campos usado, reserva e obrigatorio nao tem suas alteracoes declaradas por seus conteudos)
					cRet += "- Alteracao do indice : " + aSIX[ni][1] + " (" + aSIX[ni][2] + ") [" + AllTrim(aEstru[nx]) + "] "
					cRet += "DE : " + IIf(Empty(AllToChar(SIX->(FieldGet(nx)))),"VAZIO",AllTrim(AllToChar(SIX->(FieldGet(nx))))) + ;
						" PARA : " + IIf(Empty(AllToChar(aSIX[ni][nx])),"VAZIO",AllTrim(AllToChar(aSIX[ni][nx]))) + CRLF
					If !aSIX[ni][1] $ cAlias .AND. Empty(aScan(aArq,{|x| AllTrim(x) == AllTrim(aSIX[ni][1])}))
						cAlias += aSIX[ni][1] + "/"
						aAdd(aArq,aSIX[ni][1])
					Endif
					RecLock("SIX",.F.)
					SIX->(FieldPut(FieldPos(aEstru[nx]),aSIX[ni][nx]))
					SIX->(MsUnLock())
					SIX->(dbCommit())
					lAjEfetua := .T.
				Endif
			Next nx
		Endif
	Endif
Next ni
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Apagando os indices atualizados para recria-los posteriormente  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cAlias	:= ""
bErro	:= ErrorBlock({|e| VerErro(e,@lErro,@cErro)})
oBarra:SetRegua2(Len(aArq))
For ni := 1 To Len(aArq)
	oBarra:IncRegua2("Excluindo indice na base para recriar [" + aArq[ni] + "]")
	If SX2->(dbSeek(aArq[ni])) .AND. !aArq[ni] $ cAlias
		cAlias	+=	aArq[ni] + "/"
		cArq := AllTrim(SX2->X2_PATH) + AllTrim(SX2->X2_ARQUIVO)
		lAtuaTOP := .F.
		Begin Sequence
			//Apagar indices na base antes de atualizar para evitar criacao de indices jah existentes
			//que sao automaticamente criado pelo CHKFILE
			lAtuaTOP := PrAjSIXVl(aArq[ni],cArq,aSIX,@cRet)
			Recover
		End Sequence
		If lErro
			cRet += "ERRO NA CRIACAO DE INDICE" + CRLF + cErro + CRLF
		Else
			//Caso seja pra atualizar o TOP
			If lAtuaTOP
				//Atualizar as definicoes da tabela no TOP
				TcRefresh(cArq)
			Endif
			//Chamar a rotina de exclusao de indice Protheus com X31IndErase
			PrAjSIXDel(aArq[ni],cArq)
		Endif
		ErrorBlock(bErro)
	Endif
Next ni
If !Empty(cRet)
	cRet := Replicate("-",nTamDiv) + CRLF + "AJUSTES NO SIX : " + CRLF + cRet
Endif

Return cRet

//--------------------------------------------------------------
/*/{Protheus.doc} PrAjSIXDel
Rotina para apagar indices alterados no SGBD

@param : Nenhum

@return : Nenhum

@author  Pablo Gollan Carreras [RVG]
@since 14/02/2014
/*/
//--------------------------------------------------------------

Static Function PrAjSIXDel(cAlias,cTabela)

PARAMTYPE 0	VAR cAlias		AS CHARACTER
PARAMTYPE 1	VAR cTabela		AS CHARACTER

//Processar exclusao
ChkFile(cAlias,.T.)
//Dropar os indices
X31IndErase(cAlias,cTabela,__cRDD)
If !Empty(Select(cAlias))
	(aArq[ni])->(dbCloseArea())
Endif

Return Nil

//--------------------------------------------------------------
/*/{Protheus.doc} PrAjSIXVl
Rotina para excluir os indices pre-existentes no SGBD diretamente
porque o TOP nao consegue identificar a existencias de indices
pre-existente com a mesma combinacao de campos.

@param : Nenhum

@return : Nenhum

@author  Pablo Gollan Carreras [RVG]
@since 14/02/2014
/*/
//--------------------------------------------------------------

Static Function PrAjSIXVl(cAlias,cTabela,aSIX,cErro)

Local lRet				:= .F.
Local cAliasT			:= GetNextAlias()
Local cAliasT02			:= GetNextAlias()
Local cQry				:= ""
Local lTop				:= .T.
Local cSGBD				:= ""
Local cSrvIni			:= GetSrvIniName()
Local cOwner			:= ""
Local bForma01			:= {|x| Upper(AllTrim(x))}
Local ni				:= 0
Local nx				:= 0
Local nz				:= 0
Local lApaga			:= .F.
Local aLstIdx			:= {}
Local aIdx				:= {}
Local lExIdx			:= .F.
Local bFechaAT 			:= {|x| IIf(!Empty(Select(x)),((x)->(dbCloseArea()),;
								IIf(File(x + OrdBagExt()),fErase(x + OrdBagExt()),.T.),;
								IIf(File(x + GetDbExtension()),fErase(x + GetDbExtension()),.T.)),.T.)}
Local cTbOraIdx			:= "dba_ind_columns"

PARAMTYPE 0	VAR cAlias		AS CHARACTER
PARAMTYPE 1	VAR cTabela		AS CHARACTER
PARAMTYPE 2	VAR aSIX		AS ARRAY
PARAMTYPE 3	VAR cErro		AS CHARACTER	OPTIONAL	DEFAULT ""

#IFNDEF TOP
	lTop := !lTop
#ENDIF
//Levantar o ALIAS do SGBD do ambiente
If Empty(cOwner := GetPvProfString(GetEnvServer(),"TOPALIAS","",cSrvIni))
	cOwner := GetPvProfString("TOPCONNECT","ALIAS","",cSrvIni)
Endif
//Validar execucao da rotina
If !lTop .OR. Empty(cOwner) .OR. !MsFile(cTbOraIdx,,__cRDD)
	Return lRet
Endif
cSGBD	:= Eval(bForma01,TcGetDB())
cOwner	:= Eval(bForma01,cOwner)
cTabela	:= Eval(bForma01,cTabela)
Do Case
	Case cSGBD == "ORACLE"
		cQry := "SELECT TABLE_OWNER,TABLE_NAME,INDEX_NAME,COLUMN_NAME "
		cQry += "FROM " + cTbOraIdx + " "
		cQry += "WHERE TABLE_OWNER = '" + cOwner + "' "
		cQry += "AND TABLE_NAME = '" + cTabela + "' "
		cQry += "ORDER BY INDEX_NAME ASC"
EndCase
If !Empty(cQry)
	dbUseArea(.T.,__cRDD,TcGenQry(,,cQry),cAliasT,.F.,.T.)
	(cAliasT)->(dbGoTop())
	If !(cAliasT)->(Eof())
		//Montar array por indice da tabela
		Do While !(cAliasT)->(Eof())
			//Nao considerar campos reservados , indices de chave unica e chave primaria
			If Right(Eval(bForma01,(cAliasT)->INDEX_NAME),4) == "_UNQ" .OR. ;
				Right(Eval(bForma01,(cAliasT)->INDEX_NAME),3) == "_PK" .OR. ;
				Eval(bForma01,(cAliasT)->COLUMN_NAME) $ "R_E_C_D_E_L_|R_E_C_N_O_|D_E_L_E_T_"

				(cAliasT)->(dbSkip())
				Loop
			Endif
			If Empty(nPos := aScan(aLstIdx,{|x| x[1] == Eval(bForma01,(cAliasT)->INDEX_NAME)}))
				aAdd(aLstIdx,{Eval(bForma01,(cAliasT)->INDEX_NAME),{Eval(bForma01,(cAliasT)->COLUMN_NAME)}})
			Else
				aAdd(aTail(aLstIdx[nPos]),Eval(bForma01,(cAliasT)->COLUMN_NAME))
			Endif
			(cAliasT)->(dbSkip())
		EndDo
		//Varrer indices criados e validar a existencia de indices a serem criados ja existentes
		For ni := 1 to Len(aSIX)
			If aSIX[ni][1] == cAlias
				aTMP := StrTokArr(aSIX[ni][3],"+")
				//Varrer lista de indices
				For nx := 1 to Len(aLstIdx)
					aIdx	:= aTail(aLstIdx[nx])
					lApaga	:= .F.
					//Varrer campos do indice do dicionario e validar se o indice jah existe no banco
					If Len(aIdx) == Len(aTMP)
						lApaga := .T.
						For nz := 1 to Len(aTMP)
							If Empty(aScan(aIdx,{|x| x == Eval(bForma01,aTMP[nz])}))
								lApaga := !lApaga
								Exit
							Endif
						Next nz
					Endif
					If lApaga
						//A combinacao dos campos do indice existem, validar se o indice esta realmente publicado
						lExIdx := .T.
						Do Case
							Case cSGBD == "ORACLE"
								cQry := "SELECT 1 "
								cQry += "FROM dba_indexes "
								cQry += "WHERE OWNER = '" + cOwner + "' "
								cQry += "AND TABLE_NAME = '" + cTabela + "' "
								cQry += "AND INDEX_NAME = '" + Eval(bForma01,aLstIdx[nx][1]) + "' "
								dbUseArea(.T.,__cRDD,TcGenQry(,,cQry),cAliasT02,.F.,.T.)
								(cAliasT02)->(dbGoTop())
								If (cAliasT02)->(Eof())
									//Nao foi encontrado nenhum registro com a referencia de indice mencionada, abortar tentativa de excluir
									lExIdx := !lExIdx
								Endif
								Eval(bFechaAT,cAliasT02)
						EndCase
						//Apagar indice somente caso ele exista
						If lExIdx
							cQry := "DROP INDEX " + cOwner + "." + aLstIdx[nx][1]
							If TcSQLExec(cQry) < 0
								cErro += "ERRO AO EXCLUIR O INDICE [" + cOwner + "." + aLstIdx[nx][1] + "]" + CRLF + TcSQLError() + CRLF
							Else
								If cSGBD == "ORACLE"
									TcSQLExec("COMMIT")
								Endif
							Endif
							lRet := .T.
						Endif
					Endif
				Next nx
			Endif
		Next ni
	Endif
	//Remover o arquivo temporario
	Eval(bFechaAT,cAliasT)
Endif

Return lRet

//--------------------------------------------------------------
/*/{Protheus.doc} ProcAjHlp
Rotina para processar as atualizacoes de mensagens de help.

@param : Nenhum

@return : Nenhum

@author  Pablo Gollan Carreras [RVG]
@since 14/02/2014
/*/
//--------------------------------------------------------------

Static Function ProcAjHlp()

Local cRet				:= ""
Local aHelpPor 			:= {}
Local aHelpEng 			:= {}
Local aHelpSpa			:= {}

aHelpPor := {}
aHelpEng := {}
aHelpSpa := {}

Return cRet

//--------------------------------------------------------------
/*/{Protheus.doc} ConectaSM0
Rotina para conectar em modo exclusivo o SIGAMAT.EMP

@param : Nenhum

@return : Nenhum

@author  Pablo Gollan Carreras [RVG]
@since 14/02/2014
/*/
//--------------------------------------------------------------

Static Function ConectaSM0()

Local aRet				:= {}
Local cArq				:= "SIGAMAT.EMP"
Local cArqInd			:= "SIGAMAT.IND"
Local nCont				:= 0
Local lOk				:= .F.
Local lFWLoadSM0		:= FindFunction("FWLoadSM0")
Local lFWCodFilSM0 		:= FindFunction("FWCodFil")

Static nTentativas		:= 10
Static nIntervalo		:= 100

Do While nCont <= nTentativas
	dbUseArea(.T.,"TOPCONN",cArq,"SM0",.F.,.F.) //adicionado o driver TOPCONN \Ajustado
	If Select("SM0") # 0
		SM0->(dbSetIndex(cArqInd))
		SM0->(dbGoTop())
		lOk := .T.
		Exit
	Endif
	nCont++
	Sleep(nIntervalo)
EndDo
If !lOk
	MsgAlert("O arquivo de empresas não pode ser aberta em modo exclusivo!" + CRLF + "Apenas atualizações permitidas nesta modalidade serão realizadas.",cRotina)
	lAjSExc := .T.
	//Abrir em modo compartilhado
	dbUseArea(.T.,"TOPCONN",cArq,"SM0",.T.,.T.) //adicionado o driver TOPCONN \Ajustado
	If Select("SM0") # 0
		SM0->(dbSetIndex(cArqInd))
		SM0->(dbGoTop())
	Else
		Break
	Endif
Endif
If lFWLoadSM0
	aRet := FWLoadSM0()
Else
	Do While !SM0->(Eof())
		aAdd(aRet,{SM0->M0_CODIGO,IIf(lFWCodFilSM0,FWCodFil(),SM0->M0_CODFIL),"","","",SM0->M0_NOME,SM0->M0_FILIAL})
		SM0->(dbSkip())
	EndDo
Endif
SM0->(dbGoTop())

Return aRet

//--------------------------------------------------------------
/*/{Protheus.doc} ProxSX3
Retorna a proxima ordem disponivel no SX3 para o Alias

@param : Nenhum

@return : Nenhum

@author  Pablo Gollan Carreras [RVG]
@since 14/02/2014
/*/
//--------------------------------------------------------------

Static Function ProxSX3(cAlias,cCpo)

Local aArea 		:= GetArea()
Local aAreaSX3 		:= SX3->(GetArea())
Local nOrdem		:= 0
Local nPosOrdem		:= 0

Static aOrdem		:= {}

Default cCpo		:= ""

If !Empty(cCpo)
	SX3->(dbSetOrder(2))
	If SX3->(dbSeek(cCpo))
		nOrdem := Val(RetAsc(SX3->X3_ORDEM,3,.F.))
	Endif
Endif
If Empty(cCpo) .OR. nOrdem == 0
	If (nPosOrdem := aScan(aOrdem, {|aLinha| aLinha[1] == cAlias})) == 0
		SX3->(dbSetOrder(1))
		SX3->(dbSeek(cAlias))
		While !SX3->(Eof()) .AND. SX3->X3_ARQUIVO == cAlias
			nOrdem++
			SX3->(dbSkip())
		EndDo
		nOrdem++
		aAdd(aOrdem,{cAlias,nOrdem})
	Else
    	aOrdem[nPosOrdem][2]++
		nOrdem := aOrdem[nPosOrdem][2]
    Endif
Endif
RestArea(aAreaSX3)
RestArea(aArea)

Return RetAsc(Str(nOrdem),2,.T.)

//--------------------------------------------------------------
/*/{Protheus.doc} InverteSel
Rotina para inversao de selecao

@param : Nenhum

@return : Nenhum

@author  Pablo Gollan Carreras [RVG]
@since 14/02/2014
/*/
//--------------------------------------------------------------

Static Function InverteSel(cAlias,nOpc,cMarca)

Local nPosREG			:= (cAlias)->(Recno())

Do Case
	Case nOpc == 1
		RecLock(cAlias,.F.)
		If !IsMark("SEL",cMarca)
			(cAlias)->SEL := cMarca
		Else
			(cAlias)->SEL := Space(Len((cAlias)->SEL))
		Endif
		MsUnlock(cAlias)
	Otherwise
		(cAlias)->(dbGoTop())
		Do While !(cAlias)->(Eof())
			RecLock(cAlias,.F.)
			If !IsMark("SEL",cMarca)
				(cAlias)->SEL := cMarca
			Else
				(cAlias)->SEL := Space(Len((cAlias)->SEL))
			Endif
			MsUnlock(cAlias)
			(cAlias)->(dbSkip())
		Enddo
		(cAlias)->(dbGoTo(nPosREG))
EndCase

Return Nil

//--------------------------------------------------------------
/*/{Protheus.doc} ProxSXA
Rotina para retornar a proxima ordem disponivel no SXA para o 
Alias.

@param : Nenhum

@return : Nenhum

@author  Pablo Gollan Carreras [RVG]
@since 14/02/2014
/*/
//--------------------------------------------------------------

Static Function ProxSXA(cAlias)

Local aArea 		:= SXA->(GetArea())
Local nOrdem		:= 0

Static aOrdem		:= {}

Default cAlias		:= ""

SXA->(dbSetOrder(1))
SXA->(dbSeek(cAlias))
Do While !SXA->(Eof()) .AND. SXA->XA_ALIAS == cAlias
	nOrdem++
	SXA->(dbSkip())
EndDo
nOrdem++
RestArea(aArea)

Return RetAsc(Str(nOrdem),1,.T.)

//--------------------------------------------------------------
/*/{Protheus.doc} HelpGrv
Rotina para formatar o texto e gravar help de campos.

@param : Nenhum

@return : Nenhum

@author  Pablo Gollan Carreras [RVG]
@since 14/02/2014
/*/
//--------------------------------------------------------------

Static Function HelpGrv(cCampo,cTipo,cTexto)

Local aHelpPor 			:= {}
Local aHelpEng 			:= {}
Local aHelpSpa			:= {}

Default cCampo			:= ""
Default cTipo			:= "P"
Default cTexto			:= ""

If Empty(cCampo)
	Return Nil
Endif
aHelpSpa := aHelpEng := aHelpPor := oFunc:QuebraLinha(cTexto)
PutHelp(cTipo + Upper(AllTrim(cCampo)),aHelpPor,aHelpEng,aHelpSpa,.T.)

Return Nil

//--------------------------------------------------------------
/*/{Protheus.doc} RetProxInd
Rotina para retornar o proximo indice (ordem) disponivel em uma
determinada tabela.

@param : Nenhum

@return : Nenhum

@author  Pablo Gollan Carreras [RVG]
@since 14/02/2014
/*/
//--------------------------------------------------------------

Static Function RetProxInd(cAlias)

Local aArea			:= SIX->(GetArea())
Local cOrdem		:= "1"
Local aOrdEx		:= {}	//Array contendo as ordens existentes
Local nTam			:= 0

If Empty(cAlias)
	Return cOrdem
Endif
dbSelectArea("SIX")
SIX->(dbSetOrder(1))
SIX->(dbSeek(cAlias))
nTam := Len(SIX->ORDEM)
Do While !SIX->(Eof()) .AND. AllTrim(SIX->INDICE) == AllTrim(cAlias)
	aAdd(aOrdEx,SIX->ORDEM)
	SIX->(dbSkip())
EndDo
If Len(aOrdEx) # 0
	aSort(aOrdEx,,,{|x,y| x < y}) //Ordem crescente
	cOrdem := Soma1(aTail(aOrdEx),nTam)
Endif
RestArea(aArea)

Return cOrdem

//--------------------------------------------------------------
/*/{Protheus.doc} RetSXA
Retorna a ordem associado a uma pasta.

@param : Nenhum

@return : Nenhum

@author  Pablo Gollan Carreras [RVG]
@since 14/02/2014
/*/
//--------------------------------------------------------------

Static Function RetSXA(cAlias,cPasta)

Local cRet				:= ""
Local aArea				:= SXA->(GetArea())
Local bOk				:= {|| !Empty(cAlias) .AND. !Empty(cPasta)}

PARAMTYPE 0	VAR cAlias		AS CHARACTER	OPTIONAL	DEFAULT ""
PARAMTYPE 1	VAR cPasta		AS CHARACTER	OPTIONAL	DEFAULT ""

If !Eval(bOk)
	If Type("PARAMIXB") == "A" .AND. Len(PARAMIXB) == 2
		cAlias	:= PARAMIXB[1]
		cPasta	:= PARAMIXB[2]
		If !Eval(bOk)
			Return cRet
		Endif
	Else
		Return cRet
	Endif
Endif
//Verificar se a pasta jah existe
SXA->(dbSeek(cAlias))
Do While !SXA->(Eof()) .AND. SXA->XA_ALIAS == cAlias
	If Upper(PadR(cPasta,nTAMSXAD)) == Upper(PadR(SXA->XA_DESCRIC,nTAMSXAD))
		cRet := SXA->XA_ORDEM
		Exit
	Endif
	SXA->(dbSkip())
EndDo
RestArea(aArea)

Return cRet

//--------------------------------------------------------------
/*/{Protheus.doc} RetElem
Rotina para retornar um declarado elemento de uma array mediante
uma chave de pesquisa informada.

@param : Nenhum

@return : Nenhum

@author  Pablo Gollan Carreras [RVG]
@since 14/02/2014
/*/
//--------------------------------------------------------------

Static Function RetElem(aArray,cChave,nElem)

Local nPos			:= 0
Local ni			:= 0
Local uRet			:= ""

Default nElem		:= 1

If ValType(aArray) # "A" .OR. Len(aArray) == 0 .OR. Empty(cChave)
	Return uRet
Endif
If (nPos := aScan(aArray,{|x| AllTrim(x[1]) == AllTrim(cChave)})) > 0
	//Verificar se o segundo elemento eh uma array
	If ValType(aArray[nPos][2]) # "A"
		uRet := aArray[nPos][2]
	Else
		If Len(aArray[nPos][2]) >= nElem
			uRet := aArray[nPos][2][nElem]
		Endif
	Endif
Endif

Return uRet
