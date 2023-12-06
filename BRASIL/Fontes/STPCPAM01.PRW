#Include "Colors.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"
#Include "Rwmake.ch"
#Include "TopConn.ch"
#Define CR chr(13)+chr(10)
/*====================================================================================\
|Programa  | STPCPAM01           | Autor | GIOVANI.ZAGO          | Data | 09/06/2015  |
|=====================================================================================|
|Descrição | IMPORTAÇÃO DE OP VIA TXT				                                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STPCPAM01                                                                |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

*-------------------------------*
User Function STPCPAM01()
	*-------------------------------*
	Private tTabFAT				// Tabela temporária
	Private aCamposFAT := {}	// Campos da tabela
	If cEmpAnt = '03'
		Processa({|| Importacao()},"Importando arquivos", "")
	EndIf
	
	
Return .T.



Static Function Importacao()
	Local aDirImpor   := {}		// Array com os arquivos do diretorio
	Local nCountFiles := 0  	// Contador dos arquivos do diretorio
	Local lArquivoValido
	Local cLayoutVer  := "" 	// Versão do Layout 3 ou 5
	Local cFormatDt
	Local cFormatTm
	Local cNewNomeArq	:= ""
	Local cDiretorio	:= 'C:\OP'
	Local cDirOk		:= ' '
	Local cDirErro		:= ' '
	Local lImportou     := .T.
	Private GFEResult := GFEViewProc():New()
	Private cFilialFat
	Private cNomeArq
	Private nNRIMP		:= 0
	Private nCountImpor := 0  	// Contador de arquivos importados
	Private cMsgPreVal	:= ""	// Armazena as mensagens de pré-validações para o Campo Observação (Importação)
	Private GFELog116 	:= GFELog():New("Importacao de Op", "Importacao de Op")
	Private GFEFile     := GFEXFILE():New()
	
	
	aDirImpor := DIRECTORY(cDiretorio + "\*.TXT" )
	
	// Verifica se existe arquivos no diretório informado
	If Len(aDirImpor) == 0
		GFELog116:Add("** " + "Nenhum arquivo encontrado no diretório " + cDiretorio)
		GFELog116:EndLog()
		MsgAlert("Nenhum arquivo encontrado no diretório " + cDiretorio, "Aviso")
		Return
	Endif
	
	// Data e Hora
	cFormatDt := stuff(DTOC(date()),3,1,'')
	cFormatDt := stuff(cFormatDt,5,1,'')
	
	cFormatTm := stuff(Time(),3,1,'')
	cFormatTm := stuff(cFormatTm,5,1,'')
	
	
	
	ProcRegua(Len(aDirImpor))
	
	For nCountFiles := 1 To Len(aDirImpor)
		lArquivoValido := .T.
		cNomeArq := aDirImpor[nCountFiles][1]
		
		
		GFEFile:Clear()
		GFEFile:Open(cDiretorio + "\" + cNomeArq)
		
		cBuffer := GFEFile:Line()
		
		LayoutPro3()
		
	Next
	
	GFEResult:Show("Importação de arquivos", "Arquivos", "Erros", "Ocorreram erros na importação")
	
	
	
Return Nil

Static Function LayoutPro3()
	Local cBuffer			:= ""
	Local nContDF			:= 1
	Local lSelecao		:= .T.
	Local nContLinhas	:= 0        // Contador de Linhas do arquivo
	Local nCountFatArq	:= 0		// Contador de Faturas por arquivo
	Local lDocFind		:= .F.
	Local nI				:= 0
	Local nJ				:= 0
	Local cCdTrp			:= ""
	Local lContEmis		:= .F.
	Local cCGCTrp			:= ""
	Local lEmisDf			:= .F.
	Local cCDEMIT			:= "'
	Local cNrDf			:= ""
	Local cNrDfArquivo	:= ""
	Local nQtNumDF		:= 0
	Local rTabFAT[2]				// Chave da tabela temporária tTabFAT, FILIAL + NRIMP
	Local aDocFrete[10]
	Local cEmitEmbarc	:= ""
	Local aBarras		:= {}
	Local nContPrev		:= 0
	Local cSerDFBase		:= ""
	Local cNrDFBase		:= ""
	Local cEmitFatura	:= ""
	
	//faça enquanto não chega o fim do arquivo
	nContLinhas := 0
	nCountFatArq := 0
	rTabFAT[1] := ""
	rTabFAT[2] := ""
	While !GFEFile:FEof()
		nContLinhas++
		
		cBuffer := GFEFile:Line()
		
		
		If At(";",cBuffer) > 0
			aBarras :=StrTokArr( cBuffer, ';' )
			If len(aBarras) > 0
				SB1->(DbSetOrder(1))
				SB1->(DbGoTop())
				If SB1->(DbSeek(xFilial("SB1")+aBarras[1]))
					_cLocpad := SB1->B1_LOCPAD
					
					If !(Empty(Alltrim(_cLocpad)))
						
						dbSelectArea("SC2")
						SC2->(dbSetOrder(2))
						If !SC2->(DbSeek(xFilial("SC2")+PADR(aBarras[1],15)+aBarras[5]))
							ST650EXEC(aBarras,_cLocpad,nContLinhas)
						Else
							GFEResult:AddErro("Op: "+Alltrim(SC2->C2_NUM)+ " já Cadastrada!!!")
							GFEResult:AddErro("Linha: "+cvaltochar(nContLinhas))
							GFEResult:AddErro(Replicate("-", 50))
						EndIf
					Else
						GFEResult:AddErro("Produto: "+Alltrim(SB1->B1_COD)+ " sem Armazem Cadastrado!!!")
						GFEResult:AddErro("Linha: "+cvaltochar(nContLinhas))
						GFEResult:AddErro(Replicate("-", 50))
						
						
					EndIf
				EndIf
			EndIf
		EndIf
		
		GFEFile:FNext()
		
		
	EndDo
Return


Static Function ST650EXEC(aBarras,_cLocpad,nContLinhas)
	
	Local aRotAuto	:= {}
	Local aErro		:= {}
	Local cMsg		:= ' '
	Local nX := 0
	Private lMsErroAuto := .f.
	
	dbSelectArea("SC2")
	dbSetOrder(1)
	
	//-- Monta array para utilizacao da Rotina Automatica
	aRotAuto  := {	;
		{"C2_FILIAL"	,xFilial("SC2")		,NIL},;
		;//{"C2_NUM"		,GetSXENum("SC2","C2_NUM") 	,NIL},;
		{"C2_ITEM"		,'01'		,NIL},;
		{"C2_SEQUEN"	,'001'		,NIL},;
		{"C2_PRODUTO"	,aBarras[1]		,NIL},;
		{"C2_QUANT"		,val(aBarras[2])			,NIL},;
		{"C2_ZDESTIN"	,aBarras[3]			,NIL},;
		{"C2_ZDEPTO "	,aBarras[4]			,NIL},;
		{"C2_DATPRI "	,ddatabase	,NIL},;
		{"C2_DATPRF"	,Stod(aBarras[5])			,NIL},;
		{"C2_OBS"		,aBarras[6]			,NIL},;
		{"C2_XUSER"		,'TXT - ' + cUserName			,NIL},;
		{"C2_LOCAL"		,_cLocpad		,NIL}}
	
	
	// Chamada da rotina automatica
	MsExecAuto({|x,y| MATA650(x,y)},aRotAuto,3)
	
	// Mostra Erro na geracao de Rotinas automaticas
	If lMsErroAuto
		aErro := GetAutoGrLog()
		cMsg := " "
		
		For nX := 1 To Len(aErro)
			cMsg += aErro[nX] + CR
		Next nX
		GFEResult:AddErro(Replicate("-", 50))
		GFEResult:AddErro("Linha: "+cvaltochar(nContLinhas))
		GFEResult:AddErro(" ")
		GFEResult:AddErro(cMsg,2)
		GFEResult:AddErro(Replicate("-", 50))
		
		
	EndIf
	
Return




User Function STOPINSERT(_cProd,nContLinhas,_cLocal,_cDest,_cDept)//u_STOPINSERT('00063216',5,'01','5','2')
	
	Local aRotAuto	:= {}
	Local aErro		:= {}
	Local i		:= 0
	Local cMsg		:= ' '
	Private lMsErroAuto := .f.
	Default _cProd 		:= 'N3076'
	Default nContLinhas := 100
	Default _cLocal 	:= '01'
	Default _cDest 		:= '01'
	Default _cDept 		:= '02'
	
	dbSelectArea("SC2")
	dbSetOrder(1)
	For i:=1 to nContLinhas
		//-- Monta array para utilizacao da Rotina Automatica
		aRotAuto  := {	;
			{"C2_FILIAL"	,xFilial("SC2")								,NIL},;
			{"C2_ITEM"		,'01'										,NIL},;
			{"C2_SEQUEN"	,'001'										,NIL},;
			{"C2_PRODUTO"	,_cProd										,NIL},;
			{"C2_QUANT"		,100										,NIL},;
			{"C2_ZDESTIN"	,_cDest										,NIL},;
			{"C2_ZDEPTO"	,_cDept										,NIL},;
			{"C2_DATPRF"	,ddatabase									,NIL},;
			{"C2_OBS"		,"Gerado Automatico  STOPINSERT"			,NIL},;
			{"C2_LOCAL"		,_cLocal		,NIL}}
		
		// Chamada da rotina automatica
		MsExecAuto({|x,y| MATA650(x,y)},aRotAuto,3)
		
	Next i
	
Return

