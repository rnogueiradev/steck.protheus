#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "RWMAKE.CH"

/*====================================================================================\
|Programa  | STAPO040        | Autor | RENATO.OLIVEIRA           | Data | 12/01/2022  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STAPO040()

	Local cArq    := "C:\arquivos_protheus\sb1.csv"
	Local cLinha  := ""
	Local lPrim   := .T.
	Local aCampos := {}
	Local aDados  := {}
	Local cDir	  := "C:\"
	Local n		  := 0
	Local i		  := 0
	Local oDlg

	Private aErro := {}

	RpcSetType( 3 )
	RpcSetEnv("11","01",,,"FAT")

	_cLog:= "RELATÓRIO DE PRODUTOS NÃO ENCONTRADOS "+CHR(13) +CHR(10)

	cArquivo := cGetFile("Arquivos CSV (*.CSV) |*.CSV*| ","Selecione o Arquivo",,,.T.,GETF_LOCALHARD+GETF_LOCALFLOPPY)
	cArquivo := AllTrim(cArquivo)

	If !File(cArquivo)
		MsgStop("O arquivo " +cDir+cArq + " não foi encontrado. A importação será abortada!","[AEST901] - ATENCAO")
		Return
	EndIf

	oFT   := fT():New()
	oFT:ft_fUse( cArquivo )

	_nX := 0

	While !( oFT:ft_fEof() )
		_nX++
		cLinha := oFT:ft_fReadLn()

		If lPrim
			aCampos := Separa(cLinha,";",.T.)
			lPrim := .F.
		Else
			AADD(aDados,Separa(cLinha,";",.T.))
		EndIf

	oFT:ft_fSkip()
	End While

	oFT:ft_fUse()	

	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))
	DbSelectArea("SB2")
	SB2->(DbSetOrder(1))
	
	For i:=1 to Len(aDados)  //ler linhas da array

		_cCodigo := PADR(AllTrim(aDados[i,1]),15)

		If SB1->(DbSeek(xFilial("SB1")+_cCodigo))

			CriaSb2(SB1->B1_COD,"03")

			If SB2->(DbSeek(xfilial("SB2") + SB1->B1_COD +'03'))
				SB2->(Reclock("SB2",.F.))
				SB2->B2_CMFIM1	:= Val(StrTran(aDados[i,2],",","."))
				SB2->(MsUnLock())
			EndIf

		EndIf

	Next i
	//End Transaction              // finaliza transação

	FT_FUSE()

	@ 000, 000 TO 230, 350 DIALOG oDlg TITLE 'Relatorio de Inconsistencias '
	@ 005,005 Get _clOG Size 167,080 MEMO Object oMemo
	@ 92,135 BMPBUTTON TYPE 1 ACTION Close(oDlg)
	ACTIVATE DIALOG oDlg CENTERED

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
	
return _sRet
