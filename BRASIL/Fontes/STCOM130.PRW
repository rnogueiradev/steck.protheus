#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | STCOM130        | Autor | RENATO.OLIVEIRA           | Data | 10/01/2019  |
|=====================================================================================|
|Descrição | Tela para upload de preços							                      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STCOM130()

	Local cArquivo := cGetFile("Arquivos CSV  (*.CSV)  | *.CSV  ","",1,"C:\",.T.,GETF_LOCALHARD,.T.,.T.)
	Local aDados   := {}
	Local lPrim	   := .T.
	Local _cAlias1 := GetNextAlias()
	Local _cQuery1 := ""
	Local i := 0

	RpcSetType( 3 )
	RpcSetEnv("01","01",,,"FAT")

	FT_FUSE(cArquivo)                   // abrir arquivo
	ProcRegua(FT_FLASTREC())             // quantos registros ler
	FT_FGOTOP()                          // ir para o topo do arquivo
	While !FT_FEOF()                     // faça enquanto não for fim do arquivo

		cLinha := FT_FREADLN()           // lendo a linha

		If lPrim
			aCampos := Separa(cLinha,";",.T.)
			lPrim := .F.
		Else
			AADD(aDados,Separa(cLinha,";",.T.))
		EndIf

		FT_FSKIP()
	EndDo

	_cCodFor := "013418"
	_cLojFor := "01"
	_cCodTab := "001"
	_cDataVig:= "05/02/2020"

	DbSelectArea("AIA")
	AIA->(DbSetOrder(1))
	AIA->(DbGoTop())
	If !AIA->(DbSeek(xFilial("AIA")+_cCodFor+_cLojFor))
		AIA->(RecLock("AIA",.T.))
		AIA->AIA_CODFOR := _cCodFor
		AIA->AIA_LOJFOR := _cLojFor
		AIA->AIA_CODTAB := _cCodTab
		AIA->AIA_DESCRI := "TABELA DE PREÇO"
		AIA->AIA_DATDE  := Date()
		AIA->AIA_DATATE := CTOD(_cDataVig)
		AIA->(MsUnLock())
	EndIf

	DbSelectArea("AIB")
	AIB->(DbSetOrder(2))
	AIB->(DbGoTop())

	ProcRegua(Len(aDados))   //incrementa regua
	For i:=1 to Len(aDados)  //ler linhas da array

		_cItem := "0001"

		If AIB->(DbSeek(xFilial("AIB")+_cCodFor+_cLojFor+_cCodTab+aDados[i,1]))
			AIB->(RecLock("AIB",.F.))
		Else
		
			AIB->(RecLock("AIB",.T.))

			_cQuery1 := " SELECT AIB_ITEM
			_cQuery1 += " FROM "+RetSqlName("AIB")+" AIB
			_cQuery1 += " WHERE AIB.D_E_L_E_T_=' ' AND AIB_CODFOR='"+_cCodFor+"' AND AIB_LOJFOR='"+_cLojFor+"' AND AIB_CODTAB='"+_cCodTab+"'
			_cQuery1 += " ORDER BY AIB_ITEM DESC

			If !Empty(Select(_cAlias1))
				DbSelectArea(_cAlias1)
				(_cAlias1)->(dbCloseArea())
			Endif

			dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

			dbSelectArea(_cAlias1)
			(_cAlias1)->(dbGoTop())

			If (_cAlias1)->(!Eof())
				_cItem := Soma1((_cAlias1)->AIB_ITEM)
			Else
				_cItem := "0001"
			EndIf

			AIB->AIB_CODFOR := _cCodFor
			AIB->AIB_LOJFOR := _cLojFor
			AIB->AIB_CODTAB	:= _cCodTab
			AIB->AIB_ITEM   := _cItem
			AIB->AIB_CODPRO := aDados[i,1]

		EndIf

		AIB->AIB_PRCCOM := Val(StrTran(StrTran(aDados[i,2],"R$",""),",","."))
		AIB->AIB_QTDLOT := 999999.99
		AIB->AIB_INDLOT := "000000000999999.99"
		AIB->AIB_MOEDA  := 1
		AIB->AIB_DATVIG	:= CTOD(_cDataVig)

		AIB->(MsUnLock())

	Next

Return()