#INCLUDE "TOTVS.CH" 
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "RWMAKE.CH"

/*====================================================================================\
|Programa  | STAPO050        | Autor | RENATO.OLIVEIRA           | Data | 12/01/2022  |
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

User Function STAPO050()

	Local cArq    := "C:\arquivos_protheus\sb1.csv"
	Local cLinha  := ""
	Local lPrim   := .T.
	Local aCampos := {}
	Local aDados  := {}
	Local cDir	  := "C:\"
	Local n		  := 0
	Local i		  := 0
	Local oDlg
	Local _cQuery1 := ""
	Local _cAlias1 := ""
	Private aErro := {}

	_cAlias1 := GetNextAlias()

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

	DbSelectArea("SFM")
	SFM->(DbSetOrder(2)) //FM_FILIAL+FM_TIPO+FM_CLIENTE+FM_LOJACLI+FM_FORNECE+FM_LOJAFOR+FM_GRTRIB+FM_PRODUTO+FM_GRPROD+FM_EST+FM_POSIPI

	For i:=1 to Len(aDados)  //ler linhas da array

	_cId := ""

	_cQuery1 := " SELECT MAX(FM_ID) FM
	_cQuery1 += " FROM "+RetSqlName("SFM")+" SFM
	_cQuery1 += " WHERE SFM.D_E_L_E_T_=' ' 

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)

	(_cAlias1)->(dbGoTop())

	If (_cAlias1)->(!Eof())
		_cId := Soma1((_cAlias1)->FM)
	EndIf

		_cFilial := aDados[i,1]
		_cTipo   := PADR(aDados[i,2],2)
		_cCliente := PADR("",6)
		_cLojaCli := PADR("",2)
		_cFornece := aDados[i,4]
		_cLojFor  := aDados[i,5]
		_cGrTrib  := PADR("",3)
		_cProduto := PADR(AllTrim(aDados[i,6]),15)

		If !SFM->(DbSeek(_cFilial+_cTipo+_cCliente+_cLojaCli+_cFornece+_cLojFor+_cGrTrib+_cProduto))
			_cId := Soma1(_cId)
			SFM->(RecLock("SFM",.T.))
			SFM->FM_TIPO := _cTipo
			SFM->FM_TE 	 := AllTrim(aDados[i,3])
			SFM->FM_FORNECE := _cFornece
			SFM->FM_LOJAFOR := _cLojFor
			SFM->FM_PRODUTO := _cProduto
			SFM->FM_ZCLAPRO := SubStr(AllTrim(aDados[i,7]),1,1)
			SFM->FM_ZCONSUM := SubStr(AllTrim(aDados[i,8]),1,1)
			SFM->FM_ZCONTRI	:= SubStr(AllTrim(aDados[i,9]),1,1)
			SFM->FM_ID		:= _cId
			SFM->(MsUnLock())
		EndIf

	Next i
	//End Transaction              // finaliza transação

	FT_FUSE()

	@ 000, 000 TO 230, 350 DIALOG oDlg TITLE 'Relatorio de Inconsistencias '
	@ 005,005 Get _clOG Size 167,080 MEMO Object oMemo
	@ 92,135 BMPBUTTON TYPE 1 ACTION Close(oDlg)
	ACTIVATE DIALOG oDlg CENTERED

Return
