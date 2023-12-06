#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | STFAT520        | Autor | RENATO.OLIVEIRA           | Data | 21/05/2021  |
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

User Function STFAT520()

	Local _cQuery1 := ""
	Local _cAlias1 := ""
	Local _nX 	   := 0
	Local lPrim	   := .T.
	Local aDados   := {}

	RpcSetType( 3 )
	RpcSetEnv("01","02",,,"FAT")

	Conout("[STFAT520]"+FWTimeStamp(2)+" - Inicio do processamento de carga de fatec")

	_cAlias1 := GetNextAlias()
	_cAlias2 := GetNextAlias()

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

	DbSelectArea("SA1")
	SA1->(DbSetOrder(1))
	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))
	DbSelectArea("SBM")
	SBM->(DbSetOrder(1))

	_cLog := "RELATÓRIO DE CARGA"+CHR(13) +CHR(10)

	For _nX:=1 to Len(aDados)

		_cNumFat := GETSX8NUM("PC1","PC1_NUMERO")
		PC1->(ConfirmSX8())

		If !SA1->(DbSeek(xFilial("SA1")+PADL(AllTrim(aDados[_nX][6]),6,"0")+PADL(AllTrim(aDados[_nX][7]),2,"0")))
			_cLog := cValToChar(_nX)+";"+"Cliente não encontrado"+CHR(13) +CHR(10)
			Loop
		EndIf
		If !SB1->(DbSeek(xFilial("SB1")+PADR(AllTrim(aDados[_nX][27]),25)))
			_cLog := cValToChar(_nX)+";"+"Produto não encontrado"+CHR(13) +CHR(10)
			Loop
		EndIf
		If !SBM->(DbSeek(xFilial("SBM")+SB1->B1_GRUPO))		
			_cLog := cValToChar(_nX)+";"+"Grupo não encontrado"+CHR(13) +CHR(10)
			Loop
		EndIf

		_cQuery1 := " SELECT F2_FILIAL, F2_DOC, F2_SERIE, D2_ITEM, D2_QUANT
		_cQuery1 += " FROM "+RetSqlName("SF2")+" F2
		_cQuery1 += " LEFT JOIN "+RetSqlName("SD2")+" D2
		_cQuery1 += " ON D2_FILIAL=F2_FILIAL AND D2_DOC=F2_DOC AND D2_SERIE=F2_SERIE
		_cQuery1 += " AND D2_CLIENTE=F2_CLIENTE AND D2_LOJA=F2_LOJA
		_cQuery1 += " WHERE F2.D_E_L_E_T_=' ' AND D2.D_E_L_E_T_=' ' 
		_cQuery1 += " AND F2_FILIAL='02'
		_cQuery1 += " AND F2_DOC='"+aDados[_nX][29]+"'
		_cQuery1 += " AND F2_SERIE='"+aDados[_nX][30]+"'
		_cQuery1 += " AND D2_COD='"+SB1->B1_COD+"'

		If !Empty(Select(_cAlias1))
			DbSelectArea(_cAlias1)
			(_cAlias1)->(dbCloseArea())
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

		dbSelectArea(_cAlias1)
		(_cAlias1)->(dbGoTop())
		
		If (_cAlias1)->(Eof())
			_cLog := cValToChar(_nX)+";"+"Nota não encontrada"+CHR(13) +CHR(10)
			Loop
		EndIf

		PC1->(RecLock("PC1",.T.))
		PC1->PC1_FILIAL	:= xFilial("PC1")
		PC1->PC1_NUMERO	:= _cNumFat
		PC1->PC1_STATUS	:= "0"
		PC1->PC1_NOTAE	:=	""
		PC1->PC1_SERIEE	:=	""
		PC1->PC1_CODCLI	:= SA1->A1_COD
		PC1->PC1_NOMCLI	:= SA1->A1_NOME
		PC1->PC1_LOJA	:= SA1->A1_LOJA
		PC1->PC1_CONTAT	:= "20210518008164"
		PC1->PC1_ATENDE	:= "Administrador"
		PC1->PC1_MOTIVO	:= aDados[_nX][11]
		PC1->PC1_REPOSI	:= "2"
		PC1->PC1_DEVMAT	:= "1"
		PC1->PC1_DTOCOR	:= Date()
		PC1->PC1_PEDREP	:= ""
		PC1->PC1_CODUSR	:= "000000"
		PC1->(MsUnLock())

		PC2->(RecLock("PC2",.T.))
		PC2->PC2_FILIAL := xFilial("PC2")
		PC2->PC2_NFATEC := _cNumFat
		PC2->PC2_PRODUT := SB1->B1_COD
		PC2->PC2_DESPRO	:= SB1->B1_DESC
		PC2->PC2_NFORIG := (_cAlias1)->F2_DOC
		PC2->PC2_SERIE  := (_cAlias1)->F2_SERIE
		PC2->PC2_ITEM	:= (_cAlias1)->D2_ITEM
		PC2->PC2_QTDNFS	:= (_cAlias1)->D2_QUANT
		PC2->PC2_QTDFAT	:= Val(aDados[_nX][33])
		PC2->PC2_GRPPRO	:= SB1->B1_GRUPO
		PC2->PC2_DSCPRO := SBM->BM_DESC
		PC2->(MsUnLock())

	Next

	Conout("[STFAT520]"+FWTimeStamp(2)+" - Fim do processamento de fatec automática")

Return()
