#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "RWMAKE.CH"

/*====================================================================================\
|Programa  | STAPO040        | Autor | RENATO.OLIVEIRA           | Data | 12/01/2022  |
|=====================================================================================|
|Descri��o |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Hist�rico....................................|
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

	_cLog:= "RELAT�RIO DE PRODUTOS N�O ENCONTRADOS "+CHR(13) +CHR(10)

	cArquivo := cGetFile("Arquivos CSV (*.CSV) |*.CSV*| ","Selecione o Arquivo",,,.T.,GETF_LOCALHARD+GETF_LOCALFLOPPY)
	cArquivo := AllTrim(cArquivo)

	If !File(cArquivo)
		MsgStop("O arquivo " +cDir+cArq + " n�o foi encontrado. A importa��o ser� abortada!","[AEST901] - ATENCAO")
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
	//End Transaction              // finaliza transa��o

	FT_FUSE()

	@ 000, 000 TO 230, 350 DIALOG oDlg TITLE 'Relatorio de Inconsistencias '
	@ 005,005 Get _clOG Size 167,080 MEMO Object oMemo
	@ 92,135 BMPBUTTON TYPE 1 ACTION Close(oDlg)
	ACTIVATE DIALOG oDlg CENTERED

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
	
return _sRet
