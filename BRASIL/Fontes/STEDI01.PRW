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
|Programa  | STEDI01         | Autor | GIOVANI.ZAGO               | Dat | 18,12,2017  |
|=====================================================================================|
|Descrição |  STEDI01      				                                      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STEDI01                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function STEDI01()
	*-----------------------------*
	
	PREPARE ENVIRONMENT EMPRESA '11' FILIAL '01'
	
	Processa({|| Importacao()},"Importando arquivos", "")
	
	
	
Return .T.



Static Function Importacao()
	Local aDirImpor   := {}		// Array com os arquivos do diretorio
	Local nCountFiles := 0  	// Contador dos arquivos do diretorio
	Local lArquivoValido
	Local cLayoutVer  := "" 	// Versão do Layout 3 ou 5
	Local cFormatDt
	Local cFormatTm
	Local t:= 0
	Local cNewNomeArq	:= ""
	Local cDiretorio	:= '\arquivos\EDI\FG'
	Local cDirOk		:= '\arquivos\EDI\FG\OK'
	Local cDirErro		:= ' '
	Local lImportou     := .T.
	Private GFEResult := GFEViewProc():New()
	Private cFilialFat
	Private cNomeArq
	Private nNRIMP		:= 0
	Private nCountImpor := 0  	// Contador de arquivos importados
	Private cMsgPreVal	:= ""	// Armazena as mensagens de pré-validações para o Campo Observação (Importação)
	Private GFELog116 	:= GFELog():New("Importacao_EDI", "EDI", SuperGetMV('MV_GFEEDIL',,'1'))
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
		
		
		XLAYZZ6()
		
		
	Next nCountFiles
	
	For t:=1  To Len(aDirImpor)
		cNomeArq := aDirImpor[t][1]
		FRename(cDiretorio + "\" + cNomeArq, cDirOk + "\" + cNomeArq)
	Next t
	
	
	//GFEResult:Show("Importação de arquivos", "Arquivos", "Erros", "Ocorreram erros na importação")
	
	GFELog116:EndLog()
	
Return Nil



Static Function XLAYZZ6()
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
	Local _aCod				:= {}
	Local _nPedIt			:= 0
	Local _cCodCli			:= ""
	//faça enquanto não chega o fim do arquivo
	nContLinhas 	:= 0
	nCountFatArq 	:= 0
	rTabFAT[1] 		:= ""
	rTabFAT[2] 		:= ""
	While !GFEFile:FEof()
		nContLinhas++
		
		
		
		cBuffer := GFEFile:Line()
		If 	nContLinhas = 1
			_cNGAA	:= Substr(cBuffer,1,17)
			_cCGC	:= Substr(cBuffer,109,14)
			
			
			
			If _cNGAA = 'NGAAPurchaseOrder'
				
				//Verifica se cliente existe na base
				DbSelectArea("SA1")
				SA1->(DbSetOrder(3)) //A1_FILIAL+A1_CGC
				SA1->(DbGoTop())
				If !SA1->(DbSeek(xFilial("SA1")+_cCGC))
					Conout("CNPJ: "+ AllTrim(_cCGC)+" não encontrado!"+" - OC: ")
					Return .T.
				Else
					_cCodCli:= SA1->A1_COD
				EndIf
			EndIf
		EndIf
		If Empty(Alltrim(_cCodCli))
			Conout("CNPJ: "+ AllTrim(_cCGC)+" não encontrado!"+" - OC: ")
			Return .T.
		EndIf
		If 	nContLinhas = 2
			_cNGBA	:= Substr(cBuffer,1,4)
			_cOc	:= Substr(cBuffer,5,12)
			
			If _cNGBA = 'NGBA'
				DbSelectArea("ZZ6")
				ZZ6->(DbSetOrder(1)) //ZZ6_FILIAL+ZZ6_NUMOC+ZZ6_CLIENT+ZZ6_LOJA
				ZZ6->(DbGoTop())
				If ZZ6->(DbSeek(xFilial("ZZ6")+PADR(AllTrim(_cOc),15)+SA1->(A1_COD+A1_LOJA)))
					Conout("OC: "+ AllTrim(_cOc)+" já existe na base!")
					Return .T.
				EndIf
				
				
				//Iniciando a importação dos dados para as tabelas
				
				
				
				//Cabeçalho
				ZZ6->(RecLock("ZZ6",.T.))
				ZZ6->ZZ6_FILIAL	:= xFilial("ZZ6")
				ZZ6->ZZ6_NUMOC	:= AllTrim(_cOc)
				ZZ6->ZZ6_CLIENT	:= SA1->A1_COD
				ZZ6->ZZ6_LOJA	:= SA1->A1_LOJA
				ZZ6->ZZ6_CNPJ	:= AllTrim(_cCGC)
				ZZ6->ZZ6_CONDPG	:= '615'
				ZZ6->ZZ6_OBSERV	:= ' '
				ZZ6->ZZ6_TPENT	:= '0'
				ZZ6->ZZ6_TPFAT	:= '0'
				ZZ6->ZZ6_TPFRET	:= 'F'
				//ZZ6->ZZ6_DTENT	:= ::Pedido:dDtEnt
				ZZ6->ZZ6_STATUS	:= "1"
				ZZ6->ZZ6_DATA  	:= Date()
				ZZ6->ZZ6_HORA	:= Time()
				ZZ6->(MsUnLock())
				ZZ6->(DbCommit())
				//Itens
			EndIf
		EndIf
		
		_cNGCD:= Substr(cBuffer,1,4)
		If 	nContLinhas > 2 .And.  _cNGCD <> 'NGCD' .And.  _cNGCD <> 'NGDA' .And.  _cNGCD <> 'NGCA'
			_nPedIt ++
			If Empty(Alltrim(ZZ6->ZZ6_DTENT))
				ZZ6->(RecLock("ZZ6",.F.))
				ZZ6->ZZ6_DTENT	:= stod(AllTrim(Substr(cBuffer,207,8)))
				ZZ6->(MsUnLock())
				ZZ6->(DbCommit()) 
			EndIf
			
			
			DbSelectArea("SZD")
			SZD->(DbSetOrder(1))
			SZD->(DbGoTop())
			If	!(SZD->(DbSeek(xFilial("SZD")+SA1->A1_COD+ AllTrim(Substr(cBuffer,5,8)))))
				SZD->(RecLock("SZD",.T.))
				SZD->ZD_CLIENTE	:= SA1->A1_COD
				SZD->ZD_CODCLI	:= AllTrim(Substr(cBuffer,5,8))
				SZD->ZD_CODSTE	:= AllTrim(Substr(cBuffer,337,15))
				SZD->(MsUnLock())
				SZD->(DbCommit())
			EndIf
			
			ZZ7->(RecLock("ZZ7",.T.))
			ZZ7->ZZ7_FILIAL	:=	xFilial("ZZ7")
			ZZ7->ZZ7_NUMOC 	:= ZZ6->ZZ6_NUMOC //'"'+ AllTrim(Substr(cBuffer,5,8))+'"'
			ZZ7->ZZ7_CLIENT	:= SA1->A1_COD
			ZZ7->ZZ7_LOJA	:= SA1->A1_LOJA
			ZZ7->ZZ7_PRODUT	:= AllTrim(Substr(cBuffer,5,8))
			ZZ7->ZZ7_ITEMP 	:=  cvaltochar(_nPedIt)
			ZZ7->ZZ7_QUANT 	:= val(AllTrim(Substr(cBuffer,165,12)))
			GFEFile:FNext()
			cBuffer := GFEFile:Line()
			ZZ7->ZZ7_PRECO 	:= round(val(AllTrim(Substr(cBuffer,18,5))+'.'+ AllTrim(Substr(cBuffer,23,4))),2)
			ZZ7->(MsUnLock())
			ZZ7->(DbCommit())
			
			
			
			
		EndIf
		
		GFEFile:FNext()
		
	EndDo
Return











