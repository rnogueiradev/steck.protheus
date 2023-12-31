 
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �STCEPIMPORT�Autor � GIOVANI ZAGO	     � Data �  27/02/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �  										                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �  Exporta��o                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
*-----------------------------*
User Function STCEPIMPORT()
	Private tTabFAT				// Tabela tempor�ria
	Private aCamposFAT := {}	// Campos da tabela
PREPARE ENVIRONMENT EMPRESA '01' FILIAL '02'  TABLES "Z1D"	
	//Processa({|| Importacao()},"Importando arquivos", "")
	
	Importacao()
	
Return .T.



Static Function Importacao()
	Local aDirImpor   := {}		// Array com os arquivos do diretorio
	Local nCountFiles := 0  	// Contador dos arquivos do diretorio
	Local lArquivoValido
	Local cLayoutVer  := "" 	// Vers�o do Layout 3 ou 5
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
	Private cMsgPreVal	:= ""	// Armazena as mensagens de pr�-valida��es para o Campo Observa��o (Importa��o)
	Private GFELog116 	:= GFELog():New("Importacao_CEP", "CEP - Importa��o", SuperGetMV('MV_GFEEDIL',,'1'))
	Private GFEFile     := GFEXFILE():New()
	
	
	aDirImpor := DIRECTORY(cDiretorio + "\*.TXT" )
		//aDirImpor := DIRECTORY("C:\arquivos_protheus\telefonia\*.TXT" )
	// Verifica se existe arquivos no diret�rio informado
	If Len(aDirImpor) == 0
		GFELog116:Add("** " + "Nenhum arquivo encontrado no diret�rio " + cDiretorio)
		GFELog116:EndLog()
		MsgAlert("Nenhum arquivo encontrado no diret�rio " + cDiretorio, "Aviso")
		Return
	Endif
	
	// Data e Hora
	cFormatDt := stuff(DTOC(date()),3,1,'')
	cFormatDt := stuff(cFormatDt,5,1,'')
	
	cFormatTm := stuff(Time(),3,1,'')
	cFormatTm := stuff(cFormatTm,5,1,'')
	
	GFELog116:Add("- In�cio da importa��o")
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
	
	GFEResult:Show("Importa��o de arquivos", "Arquivos", "Erros", "Ocorreram erros na importa��o")
	
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
	Local rTabFAT[2]				// Chave da tabela tempor�ria tTabFAT, FILIAL + NRIMP
	Local aDocFrete[10]
	Local cEmitEmbarc	:= ""
	Local aEmitFatura	:= {}
	Local nContPrev		:= 0
	Local cSerDFBase	:= ""
	Local cNrDFBase		:= ""
	Local cEmitFatura	:= ""
	Local _aCod	:= {}
	Private GFEFile
	//fa�a enquanto n�o chega o fim do arquivo
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
	Local rTabFAT[2]				// Chave da tabela tempor�ria tTabFAT, FILIAL + NRIMP
	Local aDocFrete[10]
	Local cEmitEmbarc	:= ""
	Local aEmitFatura	:= {}
	Local nContPrev		:= 0
	Local cSerDFBase		:= ""
	Local cNrDFBase		:= ""
	Local cEmitFatura	:= ""
	
	//fa�a enquanto n�o chega o fim do arquivo
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
	_sRet = strtran (_sRet, "�", "a")
	_sRet = strtran (_sRet, "�", "e")
	_sRet = strtran (_sRet, "�", "i")
	_sRet = strtran (_sRet, "�", "o")
	_sRet = strtran (_sRet, "�", "u")
	_SRET = STRTRAN (_SRET, "�", "A")
	_SRET = STRTRAN (_SRET, "�", "E")
	_SRET = STRTRAN (_SRET, "�", "I")
	_SRET = STRTRAN (_SRET, "�", "O")
	_SRET = STRTRAN (_SRET, "�", "U")
	_sRet = strtran (_sRet, "�", "a")
	_sRet = strtran (_sRet, "�", "o")
	_SRET = STRTRAN (_SRET, "�", "A")
	_SRET = STRTRAN (_SRET, "�", "O")
	_sRet = strtran (_sRet, "�", "a")
	_sRet = strtran (_sRet, "�", "e")
	_sRet = strtran (_sRet, "�", "i")
	_sRet = strtran (_sRet, "�", "o")
	_sRet = strtran (_sRet, "�", "u")
	_SRET = STRTRAN (_SRET, "�", "A")
	_SRET = STRTRAN (_SRET, "�", "E")
	_SRET = STRTRAN (_SRET, "�", "I")
	_SRET = STRTRAN (_SRET, "�", "O")
	_SRET = STRTRAN (_SRET, "�", "U")
	_sRet = strtran (_sRet, "�", "c")
	_sRet = strtran (_sRet, "�", "C")
	_sRet = strtran (_sRet, "�", "a")
	_sRet = strtran (_sRet, "�", "A")
	_sRet = strtran (_sRet, "�", ".")
	_sRet = strtran (_sRet, "�", ".")
	_sRet = strtran (_sRet, chr (9), " ") // TAB
return _sRet
