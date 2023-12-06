 
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "XMLXFUN.CH"
#INCLUDE "ap5mail.ch"
#INCLUDE "FILEIO.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STCEPIMPORTºAutor ³ GIOVANI ZAGO	     º Data ³  27/02/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  										                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³  Exportação                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*-----------------------------*
User Function STCEPIMPORT()
	Private tTabFAT				// Tabela temporária
	Private aCamposFAT := {}	// Campos da tabela
PREPARE ENVIRONMENT EMPRESA '01' FILIAL '02'  TABLES "Z1D"	
	//Processa({|| Importacao()},"Importando arquivos", "")
	
	Importacao()
	
Return .T.



Static Function Importacao()
	Local aDirImpor   := {}		// Array com os arquivos do diretorio
	Local nCountFiles := 0  	// Contador dos arquivos do diretorio
	Local lArquivoValido
	Local cLayoutVer  := "" 	// Versão do Layout 3 ou 5
	Local cFormatDt
	Local cFormatTm
	Local cNewNomeArq	:= ""
	Local cDiretorio	:= "\arquivos\telefonia"//'\XML_CTE\CEP'
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
		//aDirImpor := DIRECTORY("C:\arquivos_protheus\telefonia\*.TXT" )
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
	_nProc:= 0
	_nProc:= Len(aDirImpor)
	ProcRegua(_nProc)
	
	For nCountFiles := 1 To Len(aDirImpor)
		_nProc--
	 
		IncProc("Falta: "+cvaltochar(_nProc))
		lArquivoValido := .T.
		cNomeArq := aDirImpor[nCountFiles][1]
		
		GFELog116:Add(Replicate("-", 80))
		GFELog116:Add("[" + ALLTRIM(STR(nCountFiles)) + "] Arquivo: " + cNomeArq)
		
		
		
		StartJob("U_XLAYZ1D",GetEnvServer(), .F.,cDiretorio + "\" + cNomeArq)
		
		
	//	GFEFile:Clear()
		//GFEFile:Open(cDiretorio + "\" + cNomeArq)
		
		
		
		//LayoutPro3()
		//XLAYZ1D()
		//GFEFile:Clear()
		//FERASE(cDiretorio + "\" + cNomeArq)
	Next
	
	GFEResult:Show("Importação de arquivos", "Arquivos", "Erros", "Ocorreram erros na importação")
	
	GFELog116:EndLog()
	
Return Nil



User Function XLAYZ1D(_cCamin)
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
	Local aEmitFatura	:= {}
	Local nContPrev		:= 0
	Local cSerDFBase	:= ""
	Local cNrDFBase		:= ""
	Local cEmitFatura	:= ""
	Local _aCod	:= {}
	Private GFEFile
	//faça enquanto não chega o fim do arquivo
	nContLinhas := 0
	nCountFatArq := 0
	rTabFAT[1] := ""
	rTabFAT[2] := ""
	
RpcSetType( 3 )
	RpcSetEnv("01","02",,,"FAT")
	conout(_cCamin)
	GFEFile     := GFEXFILE():New()
	GFEFile:Clear()
	GFEFile:Open(_cCamin)
		Conout("ww "+_cCamin)	
	
	
	While !GFEFile:FEof()
		nContLinhas++
		
		
		
		cBuffer := GFEFile:Line()
		
		_aCod	:= {}
		_aCod   := StrTokArr( cBuffer, ';' )
		If !(Empty(alltrim(_aCod[ 3])))
			DbSelectArea('Z1D')
			Z1D->(DbSetOrder(1))
		Conout(_cCamin)	
			Z1D->(RecLock("Z1D",.T.) )
			
			Z1D->Z1D_NUM  := alltrim(_aCod[ 1])
			Z1D->Z1D_PARA := alltrim(_aCod[ 3])
			Z1D->Z1D_DESC := alltrim(_aCod[ 2])
			Z1D->Z1D_DATA :=    stod(padl(alltrim(_aCod[ 7]),4,"0") + padl(alltrim(_aCod[ 6]),2,"0") + padl(alltrim(_aCod[ 5]),2,"0")  )
			Z1D->Z1D_HORA := padl(alltrim(_aCod[ 8]),2,"0") +":"+ padl(alltrim(_aCod[ 9]),2,"0")+":" + padl(alltrim(_aCod[ 10]),2,"0")
			Z1D->Z1D_VALOR:= VAL( alltrim(_aCod[ 4]) )
			Z1D->Z1D_REF  := alltrim(_aCod[ 11])
			Z1D->Z1D_DIA  := CDOW( stod(padl(alltrim(_aCod[ 7]),4,"0") + padl(alltrim(_aCod[ 6]),2,"0") + padl(alltrim(_aCod[ 5]),2,"0")  ))
			
			Z1D->(MsUnlock())
			Z1D->(DbCommit())
		EndIf
		
		
		GFEFile:FNext()
		
		//GFELog116:Save()
	EndDo
	
	GFEFile:Clear()
	FERASE(_cCamin)
Return


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
	Local aEmitFatura	:= {}
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
		If nContLinhas = 1
			GFEFile:FNext()
		EndIf
		cBuffer := GFEFile:Line()
		lEmisDf := .F.
		
		DbSelectArea("JC2")
		RecLock("JC2", .T.)
		
		
		JC2->JC2_FILIAL := xFilial("JC2")
		JC2->JC2_CEP 	:= AllTrim(SubStr(cBuffer,92,08))
		JC2->JC2_LOGRAD := ' '//TiraGraf ( UPPER(AllTrim(SubStr(cBuffer,447,66))))
		JC2->JC2_NUMINI := ' '//AllTrim(SubStr(cBuffer,528,10))
		JC2->JC2_NUMFIM := ' '//AllTrim(SubStr(cBuffer,539,10))
		JC2->JC2_LADO 	:= " "
		JC2->JC2_BAIRRO := ' '//TiraGraf ( UPPER(AllTrim(SubStr(cBuffer,103,77))))
		JC2->JC2_CIDADE := TiraGraf ( UPPER(AllTrim(SubStr(cBuffer,020,77))))
		JC2->JC2_ESTADO := UPPER(AllTrim(SubStr(cBuffer,004,02)))
		JC2->JC2_CODCID := " "
		JC2->JC2_OBS 	:= " "
		
		
		
		
		MsUnLock("JC2")
		
		
		GFEFile:FNext()
		
		GFELog116:Save()
	EndDo
Return

Static function TiraGraf (_sOrig)
	local _sRet := _sOrig
	_sRet = strtran (_sRet, "á", "a")
	_sRet = strtran (_sRet, "é", "e")
	_sRet = strtran (_sRet, "í", "i")
	_sRet = strtran (_sRet, "ó", "o")
	_sRet = strtran (_sRet, "ú", "u")
	_SRET = STRTRAN (_SRET, "Á", "A")
	_SRET = STRTRAN (_SRET, "É", "E")
	_SRET = STRTRAN (_SRET, "Í", "I")
	_SRET = STRTRAN (_SRET, "Ó", "O")
	_SRET = STRTRAN (_SRET, "Ú", "U")
	_sRet = strtran (_sRet, "ã", "a")
	_sRet = strtran (_sRet, "õ", "o")
	_SRET = STRTRAN (_SRET, "Ã", "A")
	_SRET = STRTRAN (_SRET, "Õ", "O")
	_sRet = strtran (_sRet, "â", "a")
	_sRet = strtran (_sRet, "ê", "e")
	_sRet = strtran (_sRet, "î", "i")
	_sRet = strtran (_sRet, "ô", "o")
	_sRet = strtran (_sRet, "û", "u")
	_SRET = STRTRAN (_SRET, "Â", "A")
	_SRET = STRTRAN (_SRET, "Ê", "E")
	_SRET = STRTRAN (_SRET, "Î", "I")
	_SRET = STRTRAN (_SRET, "Ô", "O")
	_SRET = STRTRAN (_SRET, "Û", "U")
	_sRet = strtran (_sRet, "ç", "c")
	_sRet = strtran (_sRet, "Ç", "C")
	_sRet = strtran (_sRet, "à", "a")
	_sRet = strtran (_sRet, "À", "A")
	_sRet = strtran (_sRet, "º", ".")
	_sRet = strtran (_sRet, "ª", ".")
	_sRet = strtran (_sRet, chr (9), " ") // TAB
return _sRet
