#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*====================================================================================\
|Programa  | STIMPSB1        | Autor | RENATO.OLIVEIRA           | Data | 30/04/2019  |
|=====================================================================================|
|Descrição | Subir carga SB1									                      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

Static __lOpened := .F.

User Function STIMPSB1()

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
	DbSelectArea("DA1")
	DA1->(DbSetOrder(1)) 
	
	For i:=1 to Len(aDados)  //ler linhas da array

		conout("rodando "+cValToChar(i))

		_cCodigo := PADR(AllTrim(aDados[i,1]),15)

		If SB1->(DbSeek(xFilial("SB1")+_cCodigo))

			SB1->(Reclock("SB1",.F.))
			SB1->B1_XCODSE := SubStr(aDados[i,2],1,1)
			SB1->B1_XDESAT := IIF(AllTrim(aDados[i,3])=="ATIVADO","1","2")
			SB1->B1_MSBLQL := IIF(AllTrim(aDados[i,4])=="NÃO","2","1")
			SB1->B1_GRUPO := GetGrupo(aDados[i,7])
			SB1->B1_XCATEG := aDados[i,9]
			SB1->(MsUnlock())
		EndIf

		If DA1->(DbSeek(xFilial("DA1")+"001"+_cCodigo))
			DA1->(RecLock("DA1",.F.))
			DA1->DA1_PRCVEN := Val(StrTran(StrTran(aDados[i,10],".",""),",","."))
			DA1->(MsUnLock())
		EndIf

	Next i
	//End Transaction              // finaliza transação

	FT_FUSE()

	@ 000, 000 TO 230, 350 DIALOG oDlg TITLE 'Relatorio de Inconsistencias '
	@ 005,005 Get _clOG Size 167,080 MEMO Object oMemo
	@ 92,135 BMPBUTTON TYPE 1 ACTION Close(oDlg)
	ACTIVATE DIALOG oDlg CENTERED

Return

Static Function GetGrupo(_cDescGrp)

Local _cQuery1 := ""
Local _cAlias1 := GetNextAlias()
Local _cCodGrp := ""

	_cQuery1 := " SELECT BM_GRUPO
	_cQuery1 += " FROM "+RetSqlName("SBM")+" BM
	_cQuery1 += " WHERE BM.D_E_L_E_T_=' ' AND (BM_DESC='"+Upper(AllTrim(_cDescGrp))+"' OR BM_DESC='"+TiraGraf(Upper(AllTrim(_cDescGrp)))+"')

	If !Empty(Select(_cAlias1))
			DbSelectArea(_cAlias1)
			(_cAlias1)->(dbCloseArea())
	Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

		dbSelectArea(_cAlias1)
		(_cAlias1)->(dbGoTop())

		If (_cAlias1)->(!Eof())
			_cCodGrp := (_cAlias1)->BM_GRUPO
		EndIf

		(_cAlias1)->(DbCloseArea())

Return(_cCodGrp)

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
