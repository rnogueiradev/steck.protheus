#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TOTVS.ch"
#INCLUDE "TBICONN.ch"
#INCLUDE "TBICODE.ch"
#INCLUDE "FWMVCDEF.CH"


Static cCaminho := "C:\TEMP"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FATA101   º Autor ³ Flávia Rocha       º Data ³  28/02/2023 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Browse do cadastro de apuração de comissões                º±±
±±º          ³ Opções para Exportar e IMportar CSV                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Preenchimento das informações de comissões a pagar - Ubá   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
USER FUNCTION STFSFA80()


Local aTIPOS	:= {"1=SA1-CLIENTES",;
					"2=CT1-PLANO CONTAS",;
					"3=CTT-CENTROS DE CUSTOS",;
					"4=SB1-PRODUTOS",;
					"5=CT2-LANÇTOS CONTÁBEIS" }
Local nX        := 0

Private cCadastro   := OemToAnsi(OemtoAnsi("Atualização DFL"))
Private aParamBox	:= {}
Private aParam		:= {}

Private cCPOEX1:= "A1_COD/A1_LOJA/A1_NOME/A1_XDESCRI/A1_XCLAHFM"			//CÓDIGO / LOJA / NOME / DESCRIÇÃO DFL / CLASSIFI.HFM
Private cCPOEX2:= "CT1_CONTA/CT1_DESC01/CT1_XDESCR/CT1_XCTAGL/CT1_XCWC/CT1_XFXC"  //CONTA / DESCRIÇÃO MOEDA 1 / DESCRIÇÃO DFL / DFL CONTA GLOBAL / CWC ? / FXC ?
Private cCPOEX3:= "CTT_CUSTO/CTT_DESC01/CTT_XDESCR/CTT_XTPCC"   //C.CUSTO / DESCRIÇÃO MOEDA 1 / DESCRIÇÃO DFL / DFL TIPO CC
Private cCPOEX4:= "B1_COD/B1_DESC/B1_XCATEG/B1_XCATEG2"   
Private cCPOEX := ""
Private aRet   := {}

AAdd( aParamBox, { 2, "Qual Cadastro Atualizar"				,	4        						,aTIPOS		,	100	, "AllwaysTrue()"			,	.T.})

lCentered := .T.	
lCanSave  := .T.
lUserSave := .T.

//----------------------------------------------------------------------------------------------------------//
//Parambox - sintaxe geral
//ParamBox( < aParametros >  , < cTitle > , < aRet > , < bOk >, < aButtons > ,< lCentered >, < nPosX >,< nPosY > ,;
//          < oDlgWizard >, < cLoad > ,< lCanSave >,< lUserSave >  ) 

    // 1 - < aParametros > - Vetor com as configurações
    // 2 - < cTitle >      - Título da janela
    // 3 - < aRet >        - Vetor passador por referencia que contém o retorno dos parâmetros
    // 4 - < bOk >         - Code block para validar o botão Ok
    // 5 - < aButtons >    - Vetor com mais botões além dos botões de Ok e Cancel
    // 6 - < lCentered >   - Centralizar a janela
    // 7 - < nPosX >       - Se não centralizar janela coordenada X para início
    // 8 - < nPosY >       - Se não centralizar janela coordenada Y para início
    // 9 - < oDlgWizard >  - Utiliza o objeto da janela ativa
    //10 - < cLoad >       - Nome do perfil se caso for carregar
    //11 - < lCanSave >    - Salvar os dados informados nos parâmetros por perfil
    //12 - < lUserSave >   - Configuração por usuário
//----------------------------------------------------------------------------------------------------------//     

If ParamBox(aParamBox, "Parâmetros", @aRet,,,lCentered,,,,,lCanSave,lUserSave)	
	
	For nX := 1 to Len(aParamBox)
		If aParambox[nX,1] == 2
			If ValType(aRet[nX]) == "C"
				aRet[nX] := Val(aRet[nX])
			EndIf
	
			aAdd(aParam,aParambox[nX,4,aRet[nX]])
		Else
			aAdd(aParam,aRet[nX])
		EndIf
	Next nX	
	
	
	IF VALTYPE(MV_PAR01) == "N"
		If MV_PAR01 == 1 //CLIENTES
			FDFLSA1()
		Elseif MV_PAR01 == 2 //PLANO CONTAS
			FDFLCT1()
		Elseif MV_PAR01 == 3 //CENTRO DE CUSTOS
			FDFLCTT()
		Elseif MV_PAR01 == 4 //PRODUTOS
			FDFLSB1()
		Elseif MV_PAR01 == 5 //LANÇTOS CONTÁBEIS (CT2)
			FDFLCT2()		
		Endif 
	ELSEIF VALTYPE(MV_PAR01) == "C"
		If MV_PAR01 == '1' //CLIENTES
			FDFLSA1()
		Elseif MV_PAR01 == '2' //PLANO CONTAS
			FDFLCT1()
		Elseif MV_PAR01 == '3' //CENTRO DE CUSTOS
			FDFLCTT()
		Elseif MV_PAR01 == '4' //PRODUTOS
			FDFLSB1()
		Elseif MV_PAR01 == '5' //LANÇTOS CONTÁBEIS (CT2)
			FDFLCT2()		
		Endif 
	ENDIF 	
Endif //parambox

Return

//----------------------------------------------------------//
//FUNÇÃO : FDLSA1 - BROWSE DO CADASTRO SA1 - CAD.CLIENTES
//AUTORIA: FLÁVIA ROCHA - SIGAMAT CONSULTORIA
//DATA   : 02/06/2023
//POSSIBILITA A IMPORTAÇÃO DE CSV PARA POVOAR CAMPO DA SA1
//----------------------------------------------------------//
Static Function FDFLSA1()

Private cCadastro := "Importação Dados DFL - CLIENTES"
Private cAlias    := "SA1"

Private aRotina := MenuDef(cAlias)

Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock


DbSelectArea("SA1")
DbSetOrder(1)


DbSelectArea("SA1")
MBrowse( 6,1,22,75,"SA1")

Return

//----------------------------------------------------------//
//FUNÇÃO : FDLCT1 - BROWSE DO CADASTRO CT1 - PLANO CONTAS
//AUTORIA: FLÁVIA ROCHA - SIGAMAT CONSULTORIA
//DATA   : 02/06/2023
//POSSIBILITA A IMPORTAÇÃO DE CSV PARA POVOAR CAMPO DA CT1
//----------------------------------------------------------//
Static Function FDFLCT1()

Private cCadastro := "Importação Dados DFL - PLANO CONTAS"
Private cAlias    := "CT1"

Private aRotina := MenuDef()

Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock


DbSelectArea("CT1")
DbSetOrder(1)


DbSelectArea("CT1")
MBrowse( 6,1,22,75,"CT1")

Return

//----------------------------------------------------------//
//FUNÇÃO : FDLCTT - BROWSE DO CADASTRO CT1 - CENTRO CUSTOS
//AUTORIA: FLÁVIA ROCHA - SIGAMAT CONSULTORIA
//DATA   : 02/06/2023
//POSSIBILITA A IMPORTAÇÃO DE CSV PARA POVOAR CAMPO DA CTT
//----------------------------------------------------------//
Static Function FDFLCTT()

Private cCadastro := "Importação Dados DFL - CENTRO DE CUSTOS"
Private cAlias    := "CTT"

Private aRotina := MenuDef()

Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock


DbSelectArea("CTT")
DbSetOrder(1)


DbSelectArea("CTT")
MBrowse( 6,1,22,75,"CTT")

Return

//----------------------------------------------------------//
//FUNÇÃO : FDLSB1 - BROWSE DO CADASTRO SB1 - PRODUTOS
//AUTORIA: FLÁVIA ROCHA - SIGAMAT CONSULTORIA
//DATA   : 12/07/2023
//POSSIBILITA A IMPORTAÇÃO DE CSV PARA POVOAR CAMPO DA SB1
//----------------------------------------------------------//
Static Function FDFLSB1()

Private cCadastro := "Importação Dados DFL - PRODUTOS"
Private cAlias    := "SB1"

Private aRotina := MenuDef()

Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock


DbSelectArea("SB1")
DbSetOrder(1)


DbSelectArea("SB1")
MBrowse( 6,1,22,75,"SB1")

Return

//----------------------------------------------------------//
//FUNÇÃO : FDLCT2 - BROWSE DOS LANCTOS CONTÁBEIS - CT2
//AUTORIA: FLÁVIA ROCHA - SIGAMAT CONSULTORIA
//DATA   : 18/09/2023
//----------------------------------------------------------//
Static Function FDFLCT2()

Private cCadastro := "Exportação Dados DFL - LANÇTOS CONTÁBEIS - BALANCE SHEET"
Private cAlias    := "CT2"

Private aRotina := MenuDef()

Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock


DbSelectArea("CT2")
DbSetOrder(1)


DbSelectArea("CT2")
MBrowse( 6,1,22,75,"CT2")

Return


//MONTA MENU DE OPÇÕES
Static Function MenuDef(cAlias)
Local aMenu := {}

If cAlias <> "SB1"
	aMenu := { ;
	{"Pesquisar"			,"AxPesqui"					,0,1} ,;
	{"Visualizar"			,"AxVisual"					,0,2} ,;
	{"Exportar"				,"U_FEXPORT(cAlias)"		,0,3} ,; //cria um modelo de planilha para facilitar o preenchimento
	{"Importar"				,"U_FIMPORT(cAlias)"		,0,3} ,; //importa a planilha .csv e grava 
	{"Gera Arq.Master Data"	,"U_DFLGerArq(cAlias)"		,0,4} }
Else 
	aMenu := { ;
	{"Pesquisar"			,"AxPesqui"					,0,1} ,;
	{"Visualizar"			,"AxVisual"					,0,2} ,;
	{"Exportar"				,"U_FEXPORT(cAlias)"		,0,3} ,; //cria um modelo de planilha para facilitar o preenchimento
	{"Importar"				,"U_FIMPORT(cAlias)"		,0,3} } //importa a planilha .csv e grava 
Endif 

Return( aMenu )

//----------------------------------------------------------------------------//
//FUNÇÃO EXPORTAR PARA CSV - CRIA UMA PLANILHA EM BRANCO PARA PREENCHIMENTO
//DEPOIS É SÓ SALVAR COMO .CSV SEPARADO POR VÍRGULAS
//----------------------------------------------------------------------------//
USER FUNCTION FEXPORT(cAlias)
Local lRET    := .T.
Private aHeader := {}

aHeader := FMONTAHEAD(cAlias)

FWMsgRun(,{|| ExpPedVen(aHeader,cAlias)},"Aguarde...","Carregando Dados")

RETURN(lRET)

//----------------------------------------------------------------------------//
//FUNÇÃO IMPORTAR CSV - LÊ O ARQUIVO SELECIONADO PELO USUÁRIO E GRAVA 
//AS INFORMAÇÕES NA TABELA ZCE
//----------------------------------------------------------------------------//
USER FUNCTION FIMPORT(cAlias)

Local lRET      := .T.
Local aButtons  := {}
Local lEnd      := .F.
Local oProcess                  //incluído o parâmetro lEnd para controlar o cancelamento da janela
Local aRet      := {}
Local aPergs    := {}
Private lWhen   := .F.

//cAlias := "ZCE"

aAdd( aPergs ,{6,"Arquivo:",cCaminho,"","","",80,.T.,"Arquivos CSV|*.CSV| Arquivo TXT|*.txt"})

If ParamBox(aPergs ,"- Informe o Arquivo para Importar",@aRet,,aButtons,,,,,,.F.)
	cCaminho := aRet[1]
	oProcess := MsNewProcess():New({|lEnd| ImpPedVen(@oProcess,@lEnd,cAlias) },"Aguarde...","Importando Dados",.T.)
	oProcess:Activate()
Endif

RETURN(lRET)


/*/{Protheus.doc} ImpPedVen
Rotina que faz a importação dos Itens
@type function
@version  12.1.33
@since 20/10/2022
@param oProcess, object, Regua de Processamento
@param lEnd, logical, Variavel que aborta processamento
@return variant, Nil
/*/
Static Function ImpPedVen(oProcess,lEnd,pAlias)
	Local nLin     := 0
	
	If pAlias == "SA1"				//A1_FILIAL + A1_COD + A1_LOJA
		aCabTMP := Separa(cCPOEX1,"/")                    
	Elseif pAlias == "CT1"			//CT1_FILIAL+CT1_CONTA
		aCabTMP := Separa(cCPOEX2,"/")
	Elseif pAlias == "CTT"          //CTT_FILIAL+CTT_CUSTO
		aCabTMP := Separa(cCPOEX3,"/")
	Elseif pAlias == "SB1"          //
		aCabTMP := Separa(cCPOEX4,"/")
	Endif 

	aColTMP := gDadosImp(oProcess,lEnd)

	// Valida a estrutura do arquivo
	if !(Len(aColTMP[1])==Len(aCabTMP))
	   FWAlertHelp("Arquivo informado com LayOut diferente do sistema","Verifique se o arquivo está correto, ou se precisa ser ajustado o layout.")
	   Return
	endif 

	aCols   := {}
	oProcess:SetRegua2(Len(aColTMP))

	For nLin := 1 To Len(aColTMP)
		If (oProcess:lEnd)
			Exit
		EndIf
		
		n := nLin 		
		oProcess:IncRegua2("Importando Item: ")		
		
		If pAlias == "SA1"
			SA1->(OrdSetFocus(1))		//A1_FILIAL + A1_COD + A1_LOJA
			If SA1->(Dbseek(xFilial("SA1") + aColTMP[nLin][1] + aColTMP[nLin][2]  ))
				Reclock("SA1" , .F.)
				REPLACE A1_XDESCRI   WITH aColTMP[nLin][4]
				SA1->(MSUNLOCK())
			Endif

		Elseif pAlias == "CT1"
			CT1->(OrdSetFocus(1))		//CT1_FILIAL+CT1_CONTA
			If CT1->(Dbseek(xFilial("CT1") + aColTMP[nLin][1] ))
				Reclock("CT1" , .F.)
				REPLACE CT1_XDESCR   WITH aColTMP[nLin][3]
				REPLACE CT1_XCTAGL   WITH aColTMP[nLin][4]
				REPLACE CT1_XCWC     WITH aColTMP[nLin][5]  //S=sim / N=não
				REPLACE CT1_XFXC     WITH aColTMP[nLin][6]  //S=sim / N=não
				CT1->(MSUNLOCK())
			Endif 

		Elseif pAlias == "CTT"		
			CTT->(OrdSetFocus(1))		//CTT_FILIAL+CTT_CUSTO
			If CTT->(Dbseek(xFilial("CTT") + aColTMP[nLin][1] ))
				Reclock("CTT" , .F.)
				REPLACE CTT_XDESCR   WITH aColTMP[nLin][3]
				REPLACE CTT_XTPCC    WITH aColTMP[nLin][4]
				CTT->(MSUNLOCK())
			Endif 

		Elseif pAlias == "SB1"		
			SB1->(OrdSetFocus(1))		//B1_FILIAL+B1_COD
			If SB1->(Dbseek(xFilial("SB1") + aColTMP[nLin][1] ))
				Reclock("SB1" , .F.)
				REPLACE B1_XCATEG   WITH aColTMP[nLin][3]
				REPLACE B1_XCATEG2  WITH aColTMP[nLin][4]
				SB1->(MSUNLOCK())
			Endif 
		Endif 

	Next
	(pAlias)->(DBGOTOP())
	
Return


/*/{Protheus.doc} gDadosImp
Rotina que carrega os dados da planilha
@type function
@version  12.1.33
@author valdemir rabelo
@since 20/10/2022
@param oProcess, object, Regua de processamento
@param lEnd, logical, variavel que aborta processamento
/*/
Static Function gDadosImp(oProcess, lEnd)
	Local aRET   := {}
	Local cLinha := ""

	//Definindo o arquivo a ser lido
	oFile := FWFileReader():New(cCaminho)
	
	//Se o arquivo pode ser aberto
	If (oFile:Open())

		oProcess:SetRegua1(oFile:getFileSize())
	
		//Se não for fim do arquivo
		If ! (oFile:EoF())
		
			//Enquanto houver linhas a serem lidas
			While (oFile:HasLine())
				If (oProcess:lEnd)
					Break
				EndIf			
				//Buscando o texto da linha atual
				cLinha := oFile:GetLine()
				oProcess:IncRegua1("Bytes lidos....: " + cValToChar(oFile:getBytesRead()))		
				NL     := 0
				aTMP   := Separa(cLinha,";")
				aEval(aTMP, {|X| iif(!Empty(X),NL++,0)})
				
				//se for a primeira linha ou se a linha lida possuir nome de campo ZCE_ , ignora e vai para próxima
				//if (NL = 1) .or. Left(aTMP[1],4)=="ZCE_"
				if (NL = 1) .or. Left(aTMP[1],3)=="A1_" .or. Left(aTMP[1],4) == "CT1_" .or. Left(aTMP[1],4) == "CTT_";
				.or. Left(aTMP[1],4) == "B1_" 
					FT_FSKIP()
					Loop
				Endif 		

				cLinha := StrTran(cLinha,"'","")

				AADD(aRET,Separa(cLinha,";",.T.))

				If SubStr(cLinha,1,1) = ';'
					Exit
				EndIf

				//Mostrando a linha no console.log
				ConOut("Linha: " + cLinha)
			EndDo
		EndIf
		
		//Fecha o arquivo e finaliza o processamento
		oFile:Close()
	EndIf	

Return aRET

/*/{Protheus.doc} ExpPedVen
Rotina que fará a exportação dos dados
@type function
@version  12.1.33
@since 20/10/2022
@return variant, Logico
/*/
Static Function ExpPedVen(aHeader,pAlias)
    Local aHeadTMP := {}
	Local nX       := 0
	Local cCPOEX   := ""

	/*	
	Private cCPOEX1:= "A1_COD/A1_LOJA/A1_NOME/A1_XDESCRI"			//CÓDIGO / LOJA / NOME / DESCRIÇÃO DFL
	Private cCPOEX2:= "CT1_CONTA/CT1_DESC01/CT1_XDESCR/CT1_XCTAGL"  //CONTA / DESCRIÇÃO MOEDA 1 / DESCRIÇÃO DFL / DFL CONTA GLOBAL
	Private cCPOEX3:= "CTT_CUSTO/CTT_DESC01/CTT_XDESCR/CTT_XTPCC"   //C.CUSTO / DESCRIÇÃO MOEDA 1 / DESCRIÇÃO DFL / DFL TIPO CC
	Private cCPOEX4:= "B1_COD/B1_DESC/B1_XCATEG/B1_XCATEG2"   
	*/

	If pAlias == "SA1"				
		aCabTMP := Separa(cCPOEX1,"/")                    
		cCPOEX  := cCPOEX1
	Elseif pAlias == "CT1"			
		aCabTMP := Separa(cCPOEX2,"/")
		cCPOEX  := cCPOEX2
	Elseif pAlias == "CTT"          
		aCabTMP := Separa(cCPOEX3,"/")
		cCPOEX  := cCPOEX3
	Elseif pAlias == "SB1"         
		aCabTMP := Separa(cCPOEX4,"/")
		cCPOEX  := cCPOEX4
	Endif 
    
    aCabTMP := aClone(aHeader)
	aColTMP := {}

	For nX := 1 to Len(aCabTMP)
		IF (Alltrim(aCabTMP[nX][2]) $ cCPOEX)
			aAdd(aHeadTMP, aCabTMP[nX][2])
        Endif 
    Next
    aCabTMP := aClone(aHeadTMP)
	aadd(aColTMP, Array(Len(aCabTMP)))

	FWMsgRun(,{|| ExpMsExcel(aCabTMP, aColTMP, "Exporta P/ Preenchimento - Tab. " + pAlias,pAlias )},"Aguarde!","Exportando Planilha")

Return


// ---------+---------------------------------------------------------------------
// Função   : ExpotMsExcel
// Descrição: Gera Planilha Excel.
// Retorno  : Nenhum.
// ---------+---------------------------------------------------------------------
Static Function ExpMsExcel(paCabec1, paItens1, pcTable,pAlias)
	Local cArq       := ""
	Local cDirTmp    := GetTempPath()
	Local cWorkSheet := ""
	Local cTable     := pcTable
	Local oFwMsEx    := FWMsExcel():New()
	Local aHeadTMP   := {}
	Local nX         := 0
	Local nC         := 0
	Local nL         := 0
	Local cCPOEX     := ""

	Local cAlign  := ""
	Local cForm   := ""
	Private aAlgn := {}      // Alinhamento da coluna ( 1-Left,2-Center,3-Right )
	Private aForm := {}      // Codigo de formatação ( 1-General,2-Number,3-Monetário,4-DateTime )

	/*
	Private cCPOEX1:= "A1_COD/A1_LOJA/A1_NOME/A1_XDESCRI"			//CÓDIGO / LOJA / NOME / DESCRIÇÃO DFL
	Private cCPOEX2:= "CT1_CONTA/CT1_DESC01/CT1_XDESCR/CT1_XCTAGL"  //CONTA / DESCRIÇÃO MOEDA 1 / DESCRIÇÃO DFL / DFL CONTA GLOBAL
	Private cCPOEX3:= "CTT_CUSTO/CTT_DESC01/CTT_XDESCR/CTT_XTPCC"   //C.CUSTO / DESCRIÇÃO MOEDA 1 / DESCRIÇÃO DFL / DFL TIPO CC
	Private cCPOEX4:= "B1_COD/B1_DESC/B1_XCATEG/B1_XCATEG2" 
	*/

	If pAlias == "SA1"				
		cCPOEX := cCPOEX1
	Elseif pAlias == "CT1"		
		cCPOEX := cCPOEX2
	Elseif pAlias == "CTT"          
		cCPOEX := cCPOEX3
	Elseif pAlias == "SB1"          
		cCPOEX := cCPOEX4
	Endif 

	SX3->( dbSetOrder(2) )

	cAlign := "{"
	cForm  := "{"
	For nX := 1 to Len(paCabec1)
		IF (alltrim(paCabec1[nX]) $ cCPOEX)
			aAdd(aHeadTMP, paCabec1[nX])
			SX3->( dbSeek(paCabec1[nX]) )
			if nX > 1
				cAlign += ","
				cForm  += ","
			endif
			if SX3->X3_TIPO == "C"
				cAlign += "1"
				cForm  += "1"
			elseif SX3->X3_TIPO == "N"
				cAlign += "3"
				cForm  += "2"
			elseif SX3->X3_TIPO == "D"
				cAlign += "2"
				cForm  += "4"
			elseif SX3->X3_TIPO == "L"
				cAlign += "2"
				cForm  += "1"
			else
				cAlign += "1"
				cForm  += "1"
			endif
		Endif
	Next
	cAlign += "}"
	cForm  += "}"
	//
	paCabec1 := aClone(aHeadTMP)
	aAlgn := &cAlign
	aForm := &cForm

	cWorkSheet := "Registros Gerados"

	oFwMsEx:AddWorkSheet( cWorkSheet )
	oFwMsEx:SetTitleSizeFont(13)
	oFwMsEx:AddTable( cWorkSheet, cTable )

	oFwMsEx:SetTitleBold(.T.)

	For nC := 1 to Len(paCabec1)
		oFwMsEx:AddColumn( cWorkSheet, cTable , paCabec1[nC] , aAlgn[nC], aForm[nC] )
	Next

	For nL := 1 to Len(paItens1)
		oFwMsEx:AddRow(cWorkSheet,cTable, paItens1[nL] )
	Next

	oFwMsEx:Activate()

	cArq := CriaTrab( NIL, .F. ) + ".xml"

	LjMsgRun( "Gerando Planilha, aguarde...", cTable, {|| oFwMsEx:GetXMLFile( cArq ) } )

	If __CopyFile( cArq, cDirTmp + cArq )
		IncProc("Carregando planilha")
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open( cDirTmp + cArq )
		oExcelApp:SetVisible(.T.)
		oExcelApp:Destroy()
	Else
		MsgInfo( "Arquivo não copiado para o diretório dos arquivos temporários do usuário." )
	Endif

Return

STATIC FUNCTION FMONTAHEAD(cAlias)
Local aHead := {}
Local cQuery:= ""

//qdo o sx3 estiver no banco de dados
/*
cQuery := " SELECT X3_ARQUIVO ARQUIVO, X3_CAMPO CAMPO, X3_TAMANHO TAMANHO, X3_DECIMAL DECIMAL, X3_TIPO TIPO, X3_CONTEXT CONTEXT, "
cQuery += " X3_TITULO TITULO, X3_VALID VALID, X3_NIVEL NIVEL,  X3_USADO USADO, X3_PICTURE PICTURE, X3_CONTEXT CONTEXT, X3_F3 F3 "
cQuery += " FROM " + RETSQLNAME("SX3") + " SX3 "
cQuery += " WHERE X3_ARQUIVO = 'ZCE' AND SX3.D_E_L_E_T_ = ' ' "

// Fecha arquivo temporario
If Select("TRBX3") > 0
	DbSelectArea("TRBX3")
	DbCloseArea()
Endif

TCQUERY cQuery NEW ALIAS "TRBX3"

DbSelectArea("TRBX3")
DbGotop()
While !TRBX3->(EOF()) 
	aAdd(aHead,{TRBX3->TITULO,;
		TRBX3->CAMPO,;
		TRBX3->PICTURE,;
		TRBX3->TAMANHO,;
		TRBX3->DECIMAL,;
		TRBX3->VALID,;
		TRBX3->USADO,;
		TRBX3->TIPO,;
		TRBX3->F3,;
		TRBX3->CONTEXT})
	
	TRBX3->(DBSKIP())
Enddo
*/

DbSelectArea("SX3")
DbGotop()
SX3->(OrdSetFocus(1))
SX3->(Dbseek(cAlias))
While !SX3->(EOF()) .AND. Alltrim(SX3->X3_ARQUIVO) == cAlias //"ZCE"
	If !SX3->X3_CAMPO $ "FILIAL" //<> "ZCE_FILIAL"
		aAdd(aHead,{ ;
			Alltrim(SX3->X3_TITULO),;	//1
			SX3->X3_CAMPO,;				//2
			SX3->X3_PICTURE,;			//3
			SX3->X3_TAMANHO,;			//4
			SX3->X3_DECIMAL,;			//5
			SX3->X3_VALID,;				//6
			SX3->X3_USADO,;				//7
			SX3->X3_TIPO,;				//8
			SX3->X3_F3,;				//9
			SX3->X3_CONTEXT,;			//10
			SX3->X3_ORDEM})				//11
	Endif 
	
	SX3->(DBSKIP())
Enddo

aSort(aHead, , , {|x, y| x[11] < y[11]})

Return(aHead)

//--------------------------------------------------//
//GERAÇÃO DOS ARQUIVOS CSV PARA DFL:
//--------------------------------------------------//
User Function DFLGerArq(xAlias)

Local aParambox  := {}
Local cCliDe     := Space(6)
Local cCliAte    := "ZZZZZZ"
Local cCliIni    := ""
Local cCliFim    := ""
Local cContaDe   := Space(20)
Local cContaTe   := Replicate("Z" , 20)
Local cCustoDe   := Space(09)
Local cCustoATe  := Replicate("Z" , 9)
Local cLoteDe    := Space(6)
Local cLoteAte   := Replicate("Z", 6)
Local cSubLoteDe := Space(3)
Local cSubLoteAte:= Replicate("Z", 3)
Local dDtLancI   := Ctod("  /  /    ")
Local dDtLancF   := Ctod("  /  /    ")
Local cDocDe     := Space(6)
local cDocAte    := Replicate("Z", 6)

Local cCtaIni    := ""
Local cCtaFim    := ""
PRIVATE nTipo    := 1
PRIVATE aPages   := {}
PRIVATE aPosGet1 := {}
PRIVATE aBrowse  := {}
PRIVATE aVetor   := {}
PRIVATE aVetPed  := {}
PRIVATE aCAB  	 := {}
PRIVATE aITEM    := {}
PRIVATE oBrowse
PRIVATE oFolder1
PRIVATE oFolder2
PRIVATE oSize1
PRIVATE oOk       := LoadBitmap( GetResources(), "LBOK" )
PRIVATE oNo       := LoadBitmap( GetResources(), "LBNO" )
PRIVATE oCheckBox
PRIVATE lCheckBox := .F.
PRIVATE nQtdPed   := 0
PRIVATE cQtdPed   := 0
PRIVATE oQtdPed
PRIVATE oBtOK
PRIVATE oBtSair
PRIVATE nTotRec := 0
PRIVATE nPos := 0
PRIVATE aTitles1 := {} //{ xTitulo + " aptos à serem <<< EXPORTADOS >>>"}
PRIVATE aTitles2 := {} //{ "Total de " + xTitulo + " Selecionados" }
Private aCAB     := {}
Private aVetor   := {}
//STATIC oDlg

If xAlias == "CT1"
	xTitulo := "Contas"
Elseif xAlias == "SA1"
	xTitulo := "Clientes"
Elseif xAlias == "CTT"
	xTitulo := "Centro de Custos"
Elseif xAlias == "CT2"
	xTitulo := "Lançamentos Contábeis"
Endif

//aCAB := FMONTACAB(xAlias,aCAB) //monta a estrutura de campos de acordo com a tabela que está em xAlias (SA1, CT1, CTT...)

aTitles1 := { xTitulo + " aptos à serem <<< EXPORTADOS >>>"}
aTitles2 := { "Total de " + xTitulo + " Selecionados" }

If xAlias == "SA1"
	aAdd( aParamBox,	{1,		"Clientes De"		,cCliDe 						,""		,""		,"SA1"		,""		,50		,.T.})
	aAdd( aParamBox,	{1,		"Clientes Até"		,cCliAte						,""		,""		,"SA1"		,""		,50		,.T.})

	//aAdd( aParamBox,	{1,		"Dt.Faturamento De"	,dDataDe,""		,"MV_PAR03 <= ddatabase"		,""		,""		,50		,.T.})
	//aAdd( aParamBox,	{1,		"Dt.Faturamento Até",dDataAte,""	,"MV_PAR04 <= ddatabase"		,""		,""		,50		,.T.})

	If !ParamBox(aParamBox, "Seleção de Clientes", aRet)
		Return Nil
	Else
		cCliIni	:=	aRet[1]
		cCliFim	:=	aRet[2]
		//dDataDe	:=	aRet[3]
		//dDataAte:=	aRet[4]
		If Empty(cCliIni)	
			cCliIni := "000001"
		Endif 
		If Empty(cCliFim)
			cCliAte := "ZZZZZZ"
		Endif 
		
		If MsgYesNo("Confirma a Geração do Arquivo?")
			PROCESSA({ || FGERADADOS(xAlias,cCliIni,cCliFim)}, "Aguarde", "Gerando Arquivo CSV...")
		Else 
			MsgInfo("Operação Cancelada Pelo Operador")
		Endif 

	EndIf 

Elseif xAlias == "CT1"
	aAdd( aParamBox,	{1,		"Conta De"		,cContaDe 						,""		,""		,"CT1"		,""		,50		,.T.})
	aAdd( aParamBox,	{1,		"Conta Até"		,cContaTe						,""		,""		,"CT1"		,""		,50		,.T.})

	//aAdd( aParamBox,	{1,		"Dt.Faturamento De"	,dDataDe,""		,"MV_PAR03 <= ddatabase"		,""		,""		,50		,.T.})
	//aAdd( aParamBox,	{1,		"Dt.Faturamento Até",dDataAte,""	,"MV_PAR04 <= ddatabase"		,""		,""		,50		,.T.})

	If !ParamBox(aParamBox, "Seleção de Contas", aRet)
		Return Nil
	Else
		cCtaIni	:=	aRet[1]
		cCtaFim	:=	aRet[2]
		
		If MsgYesNo("Confirma a Geração do Arquivo?")
			PROCESSA({ || FGERADADOS(xAlias,,,cCtaIni,cCtaFim)}, "Aguarde", "Gerando Arquivo CSV...")
		Else 
			MsgInfo("Operação Cancelada Pelo Operador")
		Endif 
	EndIf 

Elseif xAlias == "CTT"
	aAdd( aParamBox,	{1,		"C.Custo De"		,cCustoDe 						,""		,""		,"CTT"		,""		,50		,.T.})
	aAdd( aParamBox,	{1,		"C.Custo Até"		,cCustoATe						,""		,""		,"CTT"		,""		,50		,.T.})

	If !ParamBox(aParamBox, "Seleção de C.Custo", aRet)
		Return Nil
	Else
		cCCIni	:=	aRet[1]
		cCCFim	:=	aRet[2]
		
		If MsgYesNo("Confirma a Geração do Arquivo?")
			PROCESSA({ || FGERADADOS(xAlias,,,cCtaIni,cCtaFim,cCCIni,cCCFim)}, "Aguarde", "Gerando Arquivo CSV...")
		Else 
			MsgInfo("Operação Cancelada Pelo Operador")
		Endif 
	EndIf 

Elseif xAlias == "CT2"
	aAdd( aParamBox,	{1,		"Dt.Lançto De"		,dDtLancI		,""		,"MV_PAR01 <= ddatabase"		,""		,""		,50		,.T.})
	aAdd( aParamBox,	{1,		"Dt.Lançto Até"		,dDtLancF		,""		,"MV_PAR02 <= ddatabase"		,""		,""		,50		,.T.})
	aAdd( aParamBox,	{1,		"Lote De"			,cLoteDe 		,""		,""		,""		,""		,50		,.T.})
	aAdd( aParamBox,	{1,		"Lote Até"			,cLoteATe		,""		,""		,""		,""		,50		,.T.})
	aAdd( aParamBox,	{1,		"Sub Lote De"		,cSubLoteDe 	,""		,""		,"SB"	,""		,50		,.T.})
	aAdd( aParamBox,	{1,		"Sub Lote Até"		,cSubLoteAte	,""		,""		,"SB"	,""		,50		,.T.})
	aAdd( aParamBox,	{1,		"Documento De"		,cDocDe			,""		,""		,""		,""		,50		,.T.})
	aAdd( aParamBox,	{1,		"Documento Até"		,cDocAte		,""		,""		,""		,""		,50		,.T.})
		
	If !ParamBox(aParamBox, "Seleção de Lançamentos Contábeis", aRet)
		Return Nil
	Else
		dDataDe	:=	aRet[1]
		dDataAte:=	aRet[2]
		cLotIni	:=	aRet[3]
		cLotFim	:=	aRet[4]
		cSBLotI	:=	aRet[5]
		cSBLotF	:=	aRet[6]
		cDocI	:=	aRet[7]
		cDocF	:=	aRet[8]		
		
		If MsgYesNo("Confirma a Geração do Arquivo?")
			PROCESSA({ || FGERADADOS(xAlias, , ,cCtaIni,cCtaFim, , ,dDataDe,dDataAte,cLotIni,cLotFim,cSBLotI,cSBLotF,cDocI,cDocF)}, "Aguarde", "Gerando Arquivo CSV...")
		Else 
			MsgInfo("Operação Cancelada Pelo Operador")		
		Endif 
	EndIf 
EndIf
 
RETURN

//---------------------------------------------------//
//GERA O ARQUIVO CSV DO ALIAS SOLICITADO:
//---------------------------------------------------//
STATIC FUNCTION FGERADADOS(xAlias,cCliDe,cCliAte,cCtaDe ,cCtaTe ,cCCDe,cCCAte,dDataDe,dDataAte,cLotIni,cLotFim,cSBLotI,cSBLotF,cDocI,cDocF)
//              FGERADADOS(xAlias,      ,       ,cCtaIni,cCtaFim,     ,      ,dDataDe,dDataAte,cLotIni,cLotFim,cSBLotI,cSBLotF,cDocI,cDocF)

Local cQuery := ""
LOCAL cPath      := "C:\ARQUIVOS_PROTHEUS\DFL\" //"C:\TEMP\PEDIDO_COMPRA\"
Local cPathSrv   := "\dfl\"
Local cNomArq    := ""
Local aCAB       := {}
Local fr         := 0
Default cCliDe   := Space(6)
Default cCliAte  := Replicate("Z",6)
Default cCtaDe   := Space(20)
Default cCtaTe   := Replicate("Z",20)
Default cCCDe    := Space(09)
Default cCCATe   := Replicate("Z",9)
Default dDataDe  := Ctod("  /  /    ")
Default dDataAte := Ctod("  /  /    ")
Default cLotIni  := Space(6)
Default cLotFim  := Replicate("Z",6)
Default cSBLotI  := Space(3) 
Default cSBLotF  := Replicate("Z",3)
Default cDocI    := Space(6)
Default cDocF    := Replicate("Z",6)

If xAlias == "SA1"
	
	AADD(aCAB, "Data#" )
	AADD(aCAB, "Source System" )
	AADD(aCAB, "Data#" )
	AADD(aCAB, "Customer" )
	AADD(aCAB, "Name / Surname" )
	AADD(aCAB, "Language" )
	AADD(aCAB, "Country" )
	AADD(aCAB, "Street" )
	AADD(aCAB, "Postal Code" )
	AADD(aCAB, "City" )
	AADD(aCAB, "Region" )
	AADD(aCAB, "Trading Partner" )
	AADD(aCAB, "Attribute 9" )
	AADD(aCAB, "Attribute 10" )
	AADD(aCAB, "Data#" )
	AADD(aCAB, "Customer" )
	AADD(aCAB, "Source C.Code" )
		
	/******************************************
	Grava o Arquivo baseado no vetor montado.
	******************************************/
	//cNomArq := "DFL_" + xAlias + "_"+DTOS(DATE())+".CSV"
	cNomArq := "Data_Object_Customer_Master_Data_"+ xAlias + ".CSV"
	IF ExistDir(cPath /*"C:\ARQUIVOS_PROTHEUS\DFL\"*/) = .F.
		MakeDir(cPath /*"C:\ARQUIVOS_PROTHEUS\DFL\"*/)
	ENDIF		

	If ExistDir(cPathSrv) = .F.
		MakeDir(cPathSrv)
	Endif 
	//dbSelectArea(cAlias)
	//(cAlias)->(dbGoTop())

	//If (cAlias)->(!Eof())
	SA1->(Dbsetorder(1))
	If SA1->(Dbseek(xFilial("SA1") + cCliDe))
		nHdl := FCreate(Upper(cPath+ cNomArq))
		nTotRec := 0
		//DbEval({|| nTotRec++  })
		//PROCREGUA(nTotRec)
		//(cAlias)->(dbGoTop())
		//nQtdPed := 0

		//While (cAlias)->(!Eof())
		If Empty(cCliAte)
			cCliAte := "ZZZZZZ"
		Endif 
		cLinha := ""
		//grava cabeçalho
		For fr := 1 to Len(aCAB)
			cLinha += aCAB[fr] + ";"
			//cLinha += Chr(13)+Chr(10)
			//FWrite(nHdl,cLinha)
		Next 
		cLinha += Chr(13)+Chr(10)
		FWrite(nHdl,cLinha)

		While SA1->(!Eof()) .and. SA1->A1_COD >= cCliDe .and. SA1->A1_COD <= cCliAte
			//nRecnoAtu	:=	(cAlias)->R_E_C_N_O_
			//nCab := 0
			nQtdPed++
			//INCPROC("Lendo informações...."+ALLTRIM(STR(nQtdPed))+" / "+ALLTRIM(STR(nTotRec)))
			INCPROC("Lendo informações....")
			/*
			Data#				Número 1												FIXO
			Source System		Protheus												FIXO
			Data#				Sempre número 1											FIXO
			Customer			codigo cadastro cliente (Protheus)						A1_COD
			Name / Surname		razão social do cliente									A1_NOME
			Language			"De acordo com a planilha
								> DFL Language (area masterdata)"						"É PRA COLOCAR POR EXEMPLO: ""E"" (DE ENGLISH?)"
			Country				"De acordo com a planilha 
								> DFL Countries (area masterdata)"						"É PRA COLOCAR ""BR"" ( BRASIL?)"
			Street				Endereço												A1_END
			Postal Code			CEP														A1_CEP
			City				Cidade													A1_MUN
			Region				Estado													A1_EST
			Trading Partner		Entidade parceira - código HFM							"? DE ONDE CAPTO ESTA INFORMAÇÃO"
			Attribute 9			"De acordo com a planilha 
								> DFL Derive Customer Type from Attribute 9 - canal"	? QUAL CRITÉRIO
			Attribute 10		"De acordo com a planilha 
								> DFL Derive Customer Type from Attribute 10"			? QUAL CRITÉRIO
			Data#				1														FIXO
			Customer			"codigo cadastro cliente (Protheus) -
								em confirmação TI SEB"									A1_COD
			Source C.Code 		"Entidade do reporting completo:
								HFM - BR2000 / BR2100 / BR3800 							só completar com zeros no caso das Steck no Brasil"
																						"COLOCAR ""BR"" E PREENCHER COM 2000, 2100 OU 3800 
																						DE ACORDO COM A FILIAL STECK"

			*/
			
			cLinha := ""
		
			cLinha += "1" + ";" 				//Data# 			Número 1												FIXO
			
			cLinha += "PROTHEUS" + ";" 			//Source System		Protheus												FIXO
			
			cLinha += "1" + ";"					//Data#				Sempre número 1											FIXO
			
			cLinha += SA1->A1_COD + ";"			//Customer			codigo cadastro cliente (Protheus)						A1_COD
			
			cLinha += SA1->A1_NOME + ";"		//Name / Surname	razão social do cliente									A1_NOME
			
			cLinha += "E" + ";"					//Language			"De acordo com a planilha
												//> DFL Language (area masterdata)"	
												//"É PRA COLOCAR POR EXEMPLO: ""E"" (DE ENGLISH?)"
			
			cLinha += "BR" + ";"				//Country				"De acordo com a planilha 
												//> DFL Countries (area masterdata)"			"É PRA COLOCAR ""BR"" ( BRASIL?)"
			
			cLinha += SA1->A1_END + ";" 		//Street				Endereço											A1_END
			
			cLinha += SA1->A1_CEP + ";"			//Postal Code			CEP													A1_CEP
			
			cLinha += SA1->A1_MUN + ";"			//City					Cidade												A1_MUN
			
			cLinha += SA1->A1_EST + ";"			//Region				Estado												A1_EST
			
			cLinha += "TRADING PARTNER" + ";"	//Trading Partner		Entidade parceira - código HFM		"? DE ONDE CAPTO ESTA INFORMAÇÃO"
			
			cLinha += "ATTRIBUTE 9" + ";"		//Attribute 9			"De acordo com a planilha 
												//> DFL Derive Customer Type from Attribute 9 - canal"	? QUAL CRITÉRIO
			cLinha += "ATTRIBUTE 10" + ";"		//Attribute 10		"De acordo com a planilha 
												//DFL Derive Customer Type from Attribute 10"			? QUAL CRITÉRIO
			cLinha += "1" + ";"					//Data#				1														FIXO
			
			cLinha += SA1->A1_COD +";"			//Customer	"codigo cadastro cliente (Protheus) -	em confirmação TI SEB"	A1_COD
			
			If SM0->M0_CODIGO == "11" //DISTRIBUIDORA	//Source C.Code  - Entidade do reporting completo:
				cLinha += "BR3800" + ";"				//HFM - BR2000 / BR2100 / BR3800 
			Elseif SM0->M0_CODIGO == "03" //AMAZÔNIA	//só completar com zeros no caso das Steck no Brasil"
				cLinha += "BR2100" + ";"				//"COLOCAR ""BR"" E PREENCHER COM 2000, 2100 OU 3800 
			Else //INDÚSTRIA							//DE ACORDO COM A FILIAL STECK"
				cLinha += "BR2000" + ";"				//Trazer o código da entidade em todos os registros - 
			Endif 										//Ex Steck Indústria BR20 
														// Steck Amazônia BR21
														// Steck Distribuidora BR38

			cLinha += Chr(13)+Chr(10)
			FWrite(nHdl,cLinha)
			//NEXT
			
			//FClose(nHdl)
			//dbSelectArea(cAlias)
			//(cAlias)->(Dbskip())
			Dbskip()
		Enddo
		FClose(nHdl)
		If File(cPath + cNomArq)
			MsgInfo("Processo Finalizado, Arquivo Gerado em: " + cPath + cNomArq)

			xPathArq := Alltrim(cPath) + Alltrim(cNomArq)
			lCopiouD := CpyT2S( xPathArq , cPathSrv , .F. )   // cDirDanfe: "C:\DANFE\" ; cArqDanfe: "DANFE_20220429.PDF" ;  cDir: "\dirdoc\co99\shared\"
		Endif 
	Endif

ElseIf xAlias == "CT1"	
	
	/******************************************
	Grava o Arquivo baseado no vetor montado.
	******************************************/
	//cNomArq := "DFL_" + xAlias + "_"+DTOS(DATE())+".CSV"
	cNomArq := "Data_Object_GL_Account_Master_Data_"+ xAlias + ".CSV"
	IF ExistDir(cPath /*"C:\ARQUIVOS_PROTHEUS\DFL\"*/) = .F.
		MakeDir(cPath /*"C:\ARQUIVOS_PROTHEUS\DFL\"*/)
	ENDIF		

	If ExistDir(cPathSrv) = .F.
		MakeDir(cPathSrv)
	Endif 

	AADD(aCAB, "Data#" )
	AADD(aCAB, "Source System" )
	AADD(aCAB, "Data#" )
	AADD(aCAB, "G/L Account" )
	AADD(aCAB, "G/L Account  Description" )
	AADD(aCAB, "Group Account" )
	AADD(aCAB, "G/L Account Type" )
	AADD(aCAB, "Data#" )
	AADD(aCAB, "G/L Account" )
	AADD(aCAB, "Source C.Code " )
	
	cQuery := "SELECT * " + CRLF
	cQuery += "FROM " + RetSqlName( 'CT1' ) + " CT1 " 			+ CRLF
	cQuery += "WHERE " 	
	cQuery += " CT1.D_E_L_E_T_= ' ' " 							+ CRLF	
	If !Empty(cCtaTe)
		cQuery += "AND CT1_CONTA BETWEEN '"	+	cCtaDe	+ "' AND '"	+	cCtaTe	+ "'"	+ CRLF
	EndIf	
	cQuery += "ORDER BY CT1.CT1_CONTA"							 	+ CRLF

	MemoWrite("C:\TEMP\MASTERDATA_" + xAlias+".TXT" , cQuery)
	//cAlias := "TMPCT1"
	If Select(cAlias) > 0
		dbSelectArea(cAlias)
		DbCloseArea()
	Endif 
	cQuery := ChangeQuery(cQuery)
	TCQuery cQuery  New Alias (cAlias:=GetNextAlias())
		
	
	//dbSelectArea(cAlias)
	
	If (cAlias)->(!Eof())
		(cAlias)->(dbGoTop())
	
		nHdl := FCreate(Upper(cPath+ cNomArq))
		nTotRec := 0
		DbEval({|| nTotRec++  })
		PROCREGUA(nTotRec)
		(cAlias)->(dbGoTop())
		nQtdPed := 0

		cLinha := ""
		//grava cabeçalho
		For fr := 1 to Len(aCAB)
			cLinha += aCAB[fr] + ";"				
		Next 
		cLinha += Chr(13)+Chr(10)
		FWrite(nHdl,cLinha)	

		While (cAlias)->(!Eof())
					
			nQtdPed++
			INCPROC("Lendo informações...."+ALLTRIM(STR(nQtdPed))+" / "+ALLTRIM(STR(nTotRec)))
			//INCPROC("Lendo informações....")
			/*
			Data#						Número 1											FIXO
			Source System				Protheus											FIXO
			Data#						Sempre número 1										FIXO
			G/L Account					número da conta contábil (Protheus)					CT1_CONTA
			G/L Account  Description	descrição da conta contábil (Protheus)				CT1_XDESCR
			Group Account	"GCOA - 	Mapemamento para o DFL
										campo novo que criamos na CT1 na fase 1"			CT1_XCTAGL
			G/L Account Type			X=Ativo-passivo-PL 
										// N=Receita e despesa não operacional 
										// P=Receitas e custos 
										// S-No caso do SAP tem conta secundária utilizada 
										para o cálculo de custo que não interfere no balancete (os valores zeram)	
										"? QUAL CAMPO 	PEGO ESTA INFORMAÇÃO"
			Data#						Sempre número 1										FIXO
			G/L Account					número da conta contábil (Protheus)					CT1_CONTA
			Source C.Code 				"Trazer o código da entidade em todos os registros - 
										Ex Steck Indústria BR20 
										/ Steck Amazônia BR21 
										/ Steck Distribuidora BR38"	
										"COLOCAR ""BR"" E ACRESCENTAR NÚMERO 20 , 21 OU 38 DE ACORDO 
										COM A FILIAL"
			*/
			
			cLinha := ""

			cLinha += "1" + ";"							//Data#							Número 1								FIXO
			
			cLinha += "PROTHEUS" + ";"					//Source System					Protheus								FIXO
			
			cLinha += "1" + ";"							//Data#							Sempre número 1							FIXO
			
			cLinha += (cAlias)->CT1_CONTA + ";" 		//G/L Account					número da conta contábil (Protheus)		CT1_CONTA
			
			cLinha += (cAlias)->CT1_XDESCR + ";"		//G/L Account  Description		descrição da conta contábil (Protheus)	CT1_XDESCR
			
			cLinha += (cAlias)->CT1_XCTAGL + ";"		//Group Account	"GCOA
														//Mapemamento para o DFL
														//campo novo que criamos na CT1 na fase 1"								CT1_XCTAGL
			
			cLinha += "???" + ";"						//G/L Account Type			
														//X=Ativo-passivo-PL 
														// N=Receita e despesa não operacional 
														// P=Receitas e custos 
														// S-No caso do SAP tem conta secundária utilizada 
														//para o cálculo de custo que não interfere 
														//no balancete (os valores zeram)	
														//"? QUAL CAMPO PEGO ESTA INFORMAÇÃO"
			
			cLinha += "1" + ";" 						//Data#							Sempre número 1							FIXO
			
			cLinha += (cAlias)->CT1_CONTA + ";"			//G/L Account					número da conta contábil (Protheus)		CT1_CONTA
			
			If SM0->M0_CODIGO == "11" //DISTRIBUIDORA 	//Source C.Code 				"Trazer o código da entidade em todos os registros 
				cLinha += "BR38" + ";"													//Ex Steck Indústria BR20 
			Elseif SM0->M0_CODIGO == "03" //AMAZÔNIA									// Steck Amazônia BR21 
				cLinha += "BR21" + ";"													// Steck Distribuidora BR38"	
			Else //INDÚSTRIA															//"COLOCAR ""BR"" E ACRESCENTAR NÚMERO 20 , 21 OU 38 DE ACORDO 
				cLinha += "BR20" + ";"													//COM A FILIAL"
			Endif 	
			
			cLinha += Chr(13)+Chr(10)
			FWrite(nHdl,cLinha)
			
			dbSelectArea(cAlias)
			(cAlias)->(Dbskip())
			
		Enddo
		FClose(nHdl)
		If File(cPath + cNomArq)
			MsgInfo("Processo Finalizado, Arquivo Gerado em: " + cPath + cNomArq)

			xPathArq := Alltrim(cPath) + Alltrim(cNomArq)
			lCopiouD := CpyT2S( xPathArq , cPathSrv , .F. )   // cDirDanfe: "C:\DANFE\" ; cArqDanfe: "DANFE_20220429.PDF" ;  cDir: "\dirdoc\co99\shared\"
		Endif 
	Endif

ElseIf xAlias == "CTT"	
	
	/******************************************
	Grava o Arquivo baseado no vetor montado.
	******************************************/
	//cNomArq := "DFL_" + xAlias + "_"+DTOS(DATE())+".CSV"
	cNomArq   := "Data_Object_Cost_Center_Master_Data_" + xAlias + ".CSV"
	IF ExistDir(cPath /*"C:\ARQUIVOS_PROTHEUS\DFL\"*/) = .F.
		MakeDir(cPath /*"C:\ARQUIVOS_PROTHEUS\DFL\"*/)
	ENDIF		

	If ExistDir(cPathSrv) = .F.
		MakeDir(cPathSrv)
	Endif 

	AADD(aCAB, "Data#" )
	AADD(aCAB, "Source System" )
	AADD(aCAB, "Data#" )
	AADD(aCAB, "Cost Center" )
	AADD(aCAB, "Short Text" )
	AADD(aCAB, "Description" )
	AADD(aCAB, "Source C.Code " )
	AADD(aCAB, "Reporting Entity" )
	AADD(aCAB, "Functional Area" )
	AADD(aCAB, "Person Responsible" )
	
	cQuery := "SELECT * " + CRLF
	cQuery += "FROM " + RetSqlName( 'CTT' ) + " CTT " 			+ CRLF
	cQuery += "WHERE " 	
	cQuery += " CTT.D_E_L_E_T_= ' ' " 							+ CRLF	
	If !Empty(cCCAte)
		cQuery += "AND CTT_CUSTO BETWEEN '"	+	cCCDe	+ "' AND '"	+	cCCAte	+ "'"	+ CRLF
	EndIf	
	cQuery += "ORDER BY CTT.CTT_CUSTO "							 	+ CRLF

	MemoWrite("C:\TEMP\MASTERDATA_" + xAlias+".TXT" , cQuery)
	
	If Select(cAlias) > 0
		dbSelectArea(cAlias)
		DbCloseArea()
	Endif 
	cQuery := ChangeQuery(cQuery)
	TCQuery cQuery  New Alias (cAlias:=GetNextAlias())
	
	If (cAlias)->(!Eof())
		(cAlias)->(dbGoTop())
	
		nHdl := FCreate(Upper(cPath+ cNomArq))
		nTotRec := 0
		DbEval({|| nTotRec++  })
		PROCREGUA(nTotRec)
		(cAlias)->(dbGoTop())
		nQtdPed := 0

		cLinha := ""
		//grava cabeçalho
		For fr := 1 to Len(aCAB)
			cLinha += aCAB[fr] + ";"				
		Next 
		cLinha += Chr(13)+Chr(10)
		FWrite(nHdl,cLinha)	

		While (cAlias)->(!Eof())
					
			nQtdPed++
			INCPROC("Lendo informações...."+ALLTRIM(STR(nQtdPed))+" / "+ALLTRIM(STR(nTotRec)))
			
			/*
			Data#												Número 1											FIXO
			Source System										Protheus											FIXO
			Data#												Sempre número 1										FIXO
			Cost Center											número do c.c (Protheus)
																(Source ERP local)									CTT_CUSTO
			Short Text											descrição do centro de custo (Protheus)
																(no SAP tem a descrição curta que seria 
																nesse campo e a completa na coluna I (seguinte)		CTT_DESC01
			Description											descrição do centro de custo (Protheus)				CTT_DESC01
			Source C.Code 										Trazer o código da entidade em todos os registros
																- Ex Steck Indústria BR20 
																/ Steck Amazônia BR21 
																/ Steck Distribuidora BR38	"COLOCAR ""BR"" 
																E ACRESCENTAR NÚMERO 20 , 21 OU 38 DE ACORDO 
																COM A FILIAL"
			Reporting Entity									Entidade do reporting completo HFM - 
																BR2000 
																/ BR2100 
																/ BR3800 
																só completar com zeros no caso das Steck 
																no Brasil	"COLOCAR ""BR"" E PREENCHER COM 2000, 
																2100 OU 3800 DE ACORDO 	COM A FILIAL STECK"
			Functional Area										Functional somente visualizando o centro de custo
																 - exemplo o P3 refere-se P64300 
																 (sheet: List of functions do arquivo: 
																 Aligned Group Chart of Accounts with DFL				?
			Person Responsible									Normalmente um colaborador de FP&A - 
																Exemplo Nathana SFC (responsável pela análise)	NATHANA
			*/
			
			cLinha := ""
			
			cLinha += "1" + ";"									//Data#											Número 1			FIXO
			
			cLinha += "PROTHEUS" + ";" 							//Source System									Protheus			FIXO
			
			cLinha += "1" + ";"									//Data#											Sempre número 1		FIXO
			
			cLinha += (cAlias)->CTT_CUSTO + ";"					//Cost Center														CTT_CUSTO									
																//número do c.c (Protheus)
																//(Source ERP local)								
			
			cLinha += (cAlias)->CTT_DESC01 + ";"				//Short Text														CTT_DESC01			
																//descrição do centro de custo (Protheus)
																//(no SAP tem a descrição curta que seria 
																//nesse campo e a completa na coluna I (seguinte)		
			
			cLinha += (cAlias)->CTT_XDESCR + ";"				//Description														CTT_XDESCR
																//descrição do centro de custo campo novo				
			
			If SM0->M0_CODIGO == "11" //DISTRIBUIDORA 			//Source C.Code 										
				cLinha += "BR38" + ";"							//Trazer o código da entidade em todos os registros
																//Ex Steck Indústria BR20 
			Elseif SM0->M0_CODIGO == "03" //AMAZÔNIA			// Steck Amazônia BR21 
				cLinha += "BR21" + ";"							// Steck Distribuidora BR38	"COLOCAR ""BR"" 
			Else //INDÚSTRIA									//E ACRESCENTAR NÚMERO 20 , 21 OU 38 DE ACORDO 
				cLinha += "BR20" + ";"							//COM A FILIAL"
			Endif 														
																
			If SM0->M0_CODIGO == "11" //DISTRIBUIDORA			//Reporting Entity	Entidade do reporting completo HFM - 
				cLinha += "BR3800" + ";"						//BR2000 
			Elseif SM0->M0_CODIGO == "03" //AMAZÔNIA			//BR2100 
				cLinha += "BR2100" + ";"						//BR3800 
			Else //INDÚSTRIA									//só completar com zeros no caso das Steck no Brasil
				cLinha += "BR2000" + ";"						//"COLOCAR ""BR"" E PREENCHER COM ZEROS: 
			Endif 												//2000, 2100 OU 3800 DE ACORDO 	COM A FILIAL STECK"
																//ficando: 2000, 2100 OU 3800
			
			cLinha += "???" + ";"								//Functional Area
																//Functional somente visualizando o centro de custo
																//exemplo o P3 refere-se P64300 
																//(sheet: List of functions do arquivo: 
																//Aligned Group Chart of Accounts with DFL							?
			
			cLinha += "NATHANA" + ";"							//Person Responsible									
																//Normalmente um colaborador de FP&A - 
																//Exemplo Nathana SFC (responsável pela análise)					NATHANA				
			
			cLinha += Chr(13)+Chr(10)
			FWrite(nHdl,cLinha)
			
			dbSelectArea(cAlias)
			(cAlias)->(Dbskip())
			
		Enddo
		FClose(nHdl)
		If File(cPath + cNomArq)
			MsgInfo("Processo Finalizado, Arquivo Gerado em: " + cPath + cNomArq)

			xPathArq := Alltrim(cPath) + Alltrim(cNomArq)
			lCopiouD := CpyT2S( xPathArq , cPathSrv , .F. )   // cDirDanfe: "C:\DANFE\" ; cArqDanfe: "DANFE_20220429.PDF" ;  cDir: "\dirdoc\co99\shared\"
		Endif 
	Endif

Elseif xAlias == "CT2"
/*
	Default dDataDe  := Ctod("  /  /    ")
	Default dDataAte := Ctod("  /  /    ")
	Default cLotIni  := Space(6)
	Default cLotFim  := Replicate("Z",6)
	Default cSBLotI  := Space(3) 
	Default cSBLotF  := Replicate("Z",3)
	Default cDocI    := Space(6)
	Default cDocF    := Replicate("Z",6)
*/
	/******************************************
	Grava o Arquivo baseado no vetor montado.
	******************************************/
	//cNomArq := "DFL_" + xAlias + "_"+DTOS(DATE())+".CSV"
	cNomArq := "Data_Object_Balance_Sheet_" + xAlias + ".CSV"
	IF ExistDir(cPath /*"C:\ARQUIVOS_PROTHEUS\DFL\"*/) = .F.
		MakeDir(cPath /*"C:\ARQUIVOS_PROTHEUS\DFL\"*/)
	ENDIF		

	If ExistDir(cPathSrv) = .F.
		MakeDir(cPathSrv)
	Endif 

	AADD(aCAB, "Data#")
	AADD(aCAB, "Source System")
	AADD(aCAB, "Source C.Code ")
	AADD(aCAB, "Reporting Entity")
	AADD(aCAB, "Fiscal Year")
	AADD(aCAB, "Fiscal Period")
	AADD(aCAB, "Data#")
	AADD(aCAB, "External Line Item")
	AADD(aCAB, "G/L Account")
	AADD(aCAB, "Trading Partner")
	AADD(aCAB, "Flow")
	AADD(aCAB, "Amount in SCC Currency")
	AADD(aCAB, "GCOA Description")	

	//FGERADADOS(xAlias,cCliDe,cCliAte,cCtaDe ,cCtaTe ,cCCDe,cCCAte,dDataDe,dDataAte,cLotIni,cLotFim,cSBLotI,cSBLotF,cDocI,cDocF)
	
	cQuery := "SELECT SUBSTRING(CT2_DATA,1,4) CT2ANO, SUBSTRING(CT2_DATA,5,2) CT2MES, CT2_DATA, CT2.* " + CRLF
	cQuery += "FROM " + RetSqlName( 'CT2' ) + " CT2 " 			+ CRLF
	cQuery += "WHERE " 	
	cQuery += " CT2.D_E_L_E_T_= ' ' " 							+ CRLF	
	cQuery += "AND CT2_DATA BETWEEN '"	+	DTOS(dDataDe)		+ "' AND '"	+	DTOS(dDataAte)		+ "'"	+ CRLF
	cQuery += "AND CT2_LOTE BETWEEN '"	+	Alltrim(cLotIni)	+ "' AND '"	+	Alltrim(cLotFim)	+ "'"	+ CRLF
	cQuery += "AND CT2_SBLOTE BETWEEN '"+	Alltrim(cSBLotI)	+ "' AND '"	+	Alltrim(cSBLotF)	+ "'"	+ CRLF
	cQuery += "AND CT2_DOC BETWEEN '"	+	Alltrim(cDocI)		+ "' AND '"	+	Alltrim(cDocF)		+ "'"	+ CRLF
	cQuery += "ORDER BY CT2.CT2_DATA "						 	+ CRLF

	MemoWrite("C:\TEMP\MASTERDATA_" + xAlias+".TXT" , cQuery)
	
	If Select(cAlias) > 0
		dbSelectArea(cAlias)
		DbCloseArea()
	Endif 
	cQuery := ChangeQuery(cQuery)
	TCQuery cQuery  New Alias (cAlias:=GetNextAlias())
	
	If (cAlias)->(!Eof())
		(cAlias)->(dbGoTop())
	
		nHdl := FCreate(Upper(cPath+ cNomArq))
		nTotRec := 0
		DbEval({|| nTotRec++  })
		PROCREGUA(nTotRec)
		(cAlias)->(dbGoTop())
		nQtdPed := 0

		cLinha := ""
		//grava cabeçalho
		For fr := 1 to Len(aCAB)
			cLinha += aCAB[fr] + ";"				
		Next 
		cLinha += Chr(13)+Chr(10)
		FWrite(nHdl,cLinha)	

		While (cAlias)->(!Eof())
					
			nQtdPed++
			INCPROC("Lendo informações...."+ALLTRIM(STR(nQtdPed))+" / "+ALLTRIM(STR(nTotRec)))
			
			/*
			Data#					Número 1													FIXO
			Source System			Protheus													FIXO
			Source C.Code 			Trazer o código da entidade em todos os registros - 		"BR"+código(2)
									Ex Steck Indústria BR20 
									Steck Amazônia BR21 
									Steck Distribuidora BR38
									COLOCAR "BR" MAIS CÓDIGO DE 2 DÍGITOS DEFINIDO PARA FILIAL
			Reporting Entity		Entidade do reporting completo HFM 
									BR2000 / BR2100 / BR3800 
									só completar com zeros no caso das Steck no Brasil
									COLOCAR "BR" MAIS CÓDIGO DE 4 DÍGITOS DEFINIDO PARA FILIAL	"BR"+código(4)
			Fiscal Year				Ano															year(CT2_DATA)
			Fiscal Period			mês COM 3 DÍGITOS, EX.: MÊS OUTUBRO = 010					month(CT2_DATA)
			Data#					1															FIXO
			External Line Item		sequencia													CT2_LINHA
			G/L Account				PCOA - conta contabil protheus								???QUAL CONTA? DÉBIDO OU CRÉDITO?
			Trading Partner			Entidade parceira - código HFM								??? QUAL CRITÉRIO PARA FORMAR CÓDIGO?
			Flow					SAP - De acordo com a natureza ele já faz a  amarração 
									vai precisar fazer para o Microsiga							??? QUAL CRITÉRIO
			Amount in SCC Currency	valor moeda 1												CT2_VLR01
			GCOA Description		Descrição do GCOA (DFL) mais detlhes 
									do que a RCOA (classe de valor)								??? QUAL CRITÉRIO ?
			*/
			
			cLinha := ""

			cLinha += "1" + ";"									//Data#					Número 1								FIXO
			
			cLinha += "PROTHEUS" + ";"							//Source System			Protheus								FIXO
			
			If SM0->M0_CODIGO == "11" //DISTRIBUIDORA 			//Source C.Code 		Source C.Code
				cLinha += "BR38" + ";"							//Trazer o código da entidade em todos os registros				"BR"+código(2)
			Elseif SM0->M0_CODIGO == "03" //AMAZÔNIA			//Ex Steck Indústria BR20 
				cLinha += "BR21" + ";"							//Steck Amazônia BR21 
			Else //INDÚSTRIA									//Steck Distribuidora BR38
				cLinha += "BR20" + ";"							//COLOCAR "BR" MAIS CÓDIGO DE 2 DÍGITOS DEFINIDO PARA FILIAL
			Endif 
			
			If SM0->M0_CODIGO == "11" //DISTRIBUIDORA			//Reporting Entity		Entidade do reporting completo HFM 
				cLinha += "BR3800" + ";"						//BR2000 / BR2100 / BR3800 
			Elseif SM0->M0_CODIGO == "03"						//só completar com zeros no caso das Steck no Brasil
				cLinha += "BR2100" + ";"						//COLOCAR "BR" MAIS CÓDIGO DE 4 DÍGITOS DEFINIDO PARA FILIAL	"BR"+código(4)
			Else //INDÚSTRIA
				cLinha += "BR2000" + ";"
			Endif 
			
			cLinha += (cAlias)->CT2ANO + ";"					//Fiscal Year			Ano										year(CT2_DATA)
			
			cLinha += StrZero(Val( (cAlias)->CT2MES),3) + ";"	//Fiscal Period			mês COM 3 DÍGITOS, 
																						//EX.: MÊS OUTUBRO = 010				month(CT2_DATA)
			cLinha += "1" + ";"									//Data#					1										FIXO
			
			cLinha += (cAlias)->CT2_LINHA + ";"					//External Line Item	sequencia								CT2_LINHA
			
			cLinha += "???" + ";"								//G/L Account			PCOA - conta contabil protheus			???QUAL CONTA? DÉBIDO OU CRÉDITO?
			
			cLinha += "???" + ";"								//Trading Partner		Entidade parceira - código HFM			??? QUAL CRITÉRIO PARA FORMAR CÓDIGO?
			
			cLinha += "???" + ";" 								//Flow					SAP - De acordo com a natureza ele 
																						//já faz a  amarração 
																						//vai precisar fazer para o Microsiga	??? QUAL CRITÉRIO
			cLinha += cValToChar( (cAlias)->CT2_VLR01) + ";" 	//Amount in SCC Currency	valor moeda 1						CT2_VLR01
			
			cLinha += "???" + ";"								//GCOA Description		Descrição do GCOA (DFL) mais detlhes 
																//do que a RCOA (classe de valor)								??? QUAL CRITÉRIO ?
			
			cLinha += Chr(13)+Chr(10)
			FWrite(nHdl,cLinha)
			
			dbSelectArea(cAlias)
			(cAlias)->(Dbskip())
			
		Enddo
		FClose(nHdl)
		If File(cPath + cNomArq)
			MsgInfo("Processo Finalizado, Arquivo Gerado em: " + cPath + cNomArq)

			xPathArq := Alltrim(cPath) + Alltrim(cNomArq)
			lCopiouD := CpyT2S( xPathArq , cPathSrv , .F. )   // cDirDanfe: "C:\DANFE\" ; cArqDanfe: "DANFE_20220429.PDF" ;  cDir: "\dirdoc\co99\shared\"
		Endif 
	Endif 
Endif 	

RETURN
