#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"
#include "rwmake.ch"
#include "ap5mail.ch"
#include "TOTVS.CH"
#INCLUDE "STR.CH"
#INCLUDE "FWMVCDEF.CH"

#Define CR chr(13)+ chr(10)
/*====================================================================================\
|Programa  | STINUPD           | Autor | GIOVANI.ZAGO             | Dat | 10,07,2014  |
|=====================================================================================|
|Descrição |  STINUPD      UPDATE				                                      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STINUPD                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function STINUPD()
	*-----------------------------*
	Local _aCod  := {}
	Local _cSoma := '0001'
	Local _Z1D  := {}
	Local cQueryUpd := ' '
	PREPARE ENVIRONMENT EMPRESA '01' FILIAL '02'
	
	Processa({|| Importacao()},"Importando arquivos", "")
	
	
	
Return .T.



Static Function Importacao()
	Local aDirImpor   := {}		// Array com os arquivos do diretorio
	Local nCountFiles := 0  	// Contador dos arquivos do diretorio
	Local lArquivoValido
	Local cLayoutVer  := "" 	// Versão do Layout 3 ou 5
	Local cFormatDt
	Local cFormatTm
	Local cNewNomeArq	:= ""
	Local cDiretorio	:= '\SA1'
	Local cDirOk		:= ' '
	Local cDirErro		:= ' '
	Local lImportou     := .T.
	Private GFEResult := GFEViewProc():New()
	Private cFilialFat
	Private cNomeArq
	Private nNRIMP		:= 0
	Private nCountImpor := 0  	// Contador de arquivos importados
	Private cMsgPreVal	:= ""	// Armazena as mensagens de pré-validações para o Campo Observação (Importação)
	Private GFELog116 	:= GFELog():New("Importacao_CEP", "CEP - Importação", SuperGetMV('MV_GFEEDIL',,'1'))
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
	
	GFELog116:Add("- Início da importação")
	GFELog116:NewLine()
	GFELog116:Save()
	
	ProcRegua(Len(aDirImpor))
	
	For nCountFiles := 1 To Len(aDirImpor)
		lArquivoValido := .T.
		cNomeArq := aDirImpor[nCountFiles][1]
		
		GFELog116:Add(Replicate("-", 80))
		GFELog116:Add("[" + ALLTRIM(STR(nCountFiles)) + "] Arquivo: " + cNomeArq)
		
		GFEFile:Clear()
		GFEFile:Open(cDiretorio + "\" + cNomeArq)
		
		cBuffer := GFEFile:Line()
		
		//LayoutPro3()
		XLAYZ1D()
	Next
	
	GFEResult:Show("Importação de arquivos", "Arquivos", "Erros", "Ocorreram erros na importação")
	
	GFELog116:EndLog()
	
Return Nil



Static Function XLAYZ1D()
	Local cBuffer			:= ""
	Local nContDF			:= 1
	Local lSelecao			:= .T.
	Local nContLinhas		:= 0        // Contador de Linhas do arquivo
	Local nCountFatArq		:= 0		// Contador de Faturas por arquivo
	Local lDocFind			:= .F.
	Local nI				:= 0
	Local nJ				:= 0
	Local cCdTrp			:= ""
	Local lContEmis			:= .F.
	Local cCGCTrp			:= ""
	Local lEmisDf			:= .F.
	Local cCDEMIT			:= "'
	Local cNrDf				:= ""
	Local cNrDfArquivo		:= ""
	Local nQtNumDF			:= 0
	Local rTabFAT[2]				// Chave da tabela temporária tTabFAT, FILIAL + NRIMP
	Local aDocFrete[10]
	Local cEmitEmbarc		:= ""
	Local aEmitFatura		:= {}
	Local nContPrev			:= 0
	Local cSerDFBase		:= ""
	Local cNrDFBase			:= ""
	Local cEmitFatura		:= ""
	Local _aCod	:= {}
	//faça enquanto não chega o fim do arquivo
	nContLinhas := 0
	nCountFatArq := 0
	rTabFAT[1] := ""
	rTabFAT[2] := ""
	While !GFEFile:FEof()
		nContLinhas++
		
		
		
		cBuffer := GFEFile:Line()
		
		_aCod	:= {}
		_aCod   := StrTokArr( cBuffer, ';' )
		//If !(Empty(alltrim(_aCod[ 1])))
		DbSelectArea('AI3')
		AI3->(DbGoTop())
		DbSelectArea('AI6')
		AI3->(dbsetorder(1))
		
		WHILE AI3->(!Eof())
			
			AI6->(RecLock("AI6",.T.))
			AI6->AI6_CODUSU := AI3->AI3_CODUSU
			AI6->AI6_WEBSRV := alltrim(_aCod[1])
			
			AI6->(MsUnlock())
			AI6->(DbCommit())
			AI3->(dbskip())
			
		End
		
		//	EndIf
		GFEFile:FNext()
		
		GFELog116:Save()
	EndDo
Return











