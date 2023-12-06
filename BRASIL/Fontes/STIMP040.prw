#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TOPCONN.CH"

/*====================================================================================\
|Programa  | STIMP040        | Autor | RENATO.OLIVEIRA           | Data | 18/02/2020  |
|=====================================================================================|
|Descrição | 													                      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STIMP040()

	Private cArquivo := ""

	//RpcSetType( 3 )
	//RpcSetEnv("01","04",,,"FAT")

	cArquivo := cGetFile("Arquivos CSV (*.CSV) |*.CSV*| ","Selecione o Arquivo",,,.T.,GETF_LOCALHARD+GETF_LOCALFLOPPY)
	cArquivo := AllTrim(cArquivo)

	If !File(cArquivo)
		MsgStop("O arquivo " +cDir+cArq + " não foi encontrado. A importação será abortada!","[AEST901] - ATENCAO")
		Return
	EndIf

	oProcess := MsNewProcess():New( { || PROCESSA() } , "Processando" , "Processando, por favor aguarde..." , .F. )
	oProcess:Activate()

Return()

/*====================================================================================\
|Programa  | PROCESSA        | Autor | RENATO.OLIVEIRA           | Data | 18/02/2020  |
|=====================================================================================|
|Descrição | 													                      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

Static Function PROCESSA()

	Local aCampos  := {}
	Local lPrim    := .T.
	Local _cLog	   := ""
	Local oDlg
	Local _lExecAuto := .T.
	Local _cQuery1 := ""
	Local _cAlias1 := GetNextAlias()
	Local _nY
	Private aDados   := {}
	Private _nY

	oProcess:SetRegua1(FT_FLASTREC())

	FT_FUSE(cArquivo)                   // abrir arquivo
	ProcRegua(FT_FLASTREC())             // quantos registros ler
	FT_FGOTOP()                          // ir para o topo do arquivo
	While !FT_FEOF()                     // faça enquanto não for fim do arquivo

		oProcess:IncRegua1("Lendo arquivo...")

		cLinha := FT_FREADLN()           // lendo a linha

		If lPrim
			aCampos := Separa(cLinha,";",.T.)
			lPrim := .F.
		Else
			AADD(aDados,Separa(cLinha,";",.T.))
		EndIf

		FT_FSKIP()
	EndDo

	DbSelectArea("SA2")
	SA2->(DbSetOrder(3))

	DbSelectArea("ACJ")
	ACJ->(DbSetOrder(1))

	oProcess:SetRegua1(Len(aDados))

	For _nY:=1 To Len(aDados)

		oProcess:IncRegua1("Importando "+cValToChar(_nY)+"/"+cValToChar(Len(aDados)))

		If _lExecAuto

			_cTipo := AllTrim(aDados[_nY][3])
			If AllTrim(aDados[_nY][3])=="01058"
				_cTipo := "J"
			Else
				_cTipo := "X"
			EndIf

			_cCep := AllTrim(StrTran(StrTran(aDados[_nY][16],"-","")," ",""))
			If AllTrim(_cTipo)=="X"
				_cCep := ""
			EndIf

			_cEst := AllTrim(aDados[_nY][12])
			If AllTrim(_cTipo)=="X"
				_cEst := "EX"
			EndIf

			_cNomeFant := AllTrim(aDados[_nY][7])
			If Empty(_cNomeFant)
				_cNomeFant := SubStr(AllTrim(aDados[_nY][6]),1,TamSx3("A2_NREDUZ")[1])
			EndIf
			_cNomeFant := SubStr(_cNomeFant,1,TamSx3("A2_NREDUZ")[1])

			_cTel1 := STTIRAGR(aDados[_nY][21],TamSx3("A2_TEL")[1])

			If Empty(_cTel1)
				_cTel1 := "."
			EndIf

			_cDDI := ""

			If _cTipo=="X"
				_cDDI := SubStr(AllTrim(aDados[_nY][19]),1,3)
				If !ACJ->(DbSeek(xFilial("ACJ")+_cDDI))
					_cDDI := "86"
				EndIf
			EndIF

			_cFax  := STTIRAGR(aDados[_nY][22],TamSx3("A2_FAX")[1])
			_cMun  := SubStr(AllTrim(aDados[_nY][15]),1,TamSx3("A2_MUN")[1])

			_cQuery1 := " SELECT A2_COD, MAX(A2_LOJA) A2_LOJA
			_cQuery1 += " FROM "+RetSqlName("SA2")+" A2
			_cQuery1 += " WHERE A2.D_E_L_E_T_=' ' AND A2_CGC<>'"+AllTrim(aDados[_nY][5])+"' AND SUBSTR(A2_CGC,1,8)='"+SubStr(aDados[_nY][5],1,8)+"'
			_cQuery1 += " GROUP BY A2_COD

			If !Empty(Select(_cAlias1))
				DbSelectArea(_cAlias1)
				(_cAlias1)->(dbCloseArea())
			Endif

			dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

			dbSelectArea(_cAlias1)

			(_cAlias1)->(dbGoTop())

			If (_cAlias1)->(!Eof())
				_cLoja := Soma1((_cAlias1)->A2_LOJA)
				_cCod  := (_cAlias1)->A2_COD
			Else
				_cLoja := "01"
				_cCod  := ""
			EndIf

			aVetor := {	{"A2_COD",      _cCod                     ,nil},;
			{"A2_LOJA",      _cLoja                     ,nil},;
			{"A2_TIPO",      _cTipo                     ,nil},;
			{"A2_NOME" ,SubStr(AllTrim(aDados[_nY][6]),1,TamSx3("A2_NOME")[1])                    ,nil},;
			{"A2_NREDUZ",    _cNomeFant                    ,nil},;
			{"A2_END",       AllTrim(aDados[_nY][9])                    ,nil},;
			{"A2_BAIRRO",    SubStr(AllTrim(aDados[_nY][11]),1,TamSx3("A2_BAIRRO")[1])                    ,nil},;
			{"A2_EST",       _cEst                   ,nil},;
			{"A2_COD_MUN",   ""                    ,nil},;
			{"A2_MUN",       _cMun                    ,nil},;
			{"A2_CEP",       _cCep                    ,nil},;
			{"A2_INSCRM",     IIf(_cTipo=="X","",AllTrim(aDados[_nY][24]))                    ,nil},;
			{"A2_INSCR",     IIf(_cTipo=="X","",AllTrim(aDados[_nY][23]))                    ,nil},;
			{"A2_CGC",       AllTrim(aDados[_nY][5])                     ,nil},;
			{"A2_DDI",       _cDDI                     ,nil},;
			{"A2_DDD",       SubStr(AllTrim(aDados[_nY][20]),1,TamSx3("A2_DDD")[1])                     ,nil},;
			{"A2_TEL",       _cTel1                     ,nil},;
			{"A2_FAX",       _cFax                     ,nil},;
			{"A2_CODPAIS",   AllTrim(aDados[_nY][3])                     ,nil},;
			{"A2_XSOLIC",   "Schneider"                     ,nil},;
			{"A2_XDEPTO",   "Schneider"                     ,nil},;
			{"A2_XVENDOR",   aDados[_nY][1]                     ,nil},;
			{"A2_EMAIL",   SubStr(AllTrim(aDados[_nY][8]),1,TamSx3("A2_EMAIL")[1])                     ,nil},;
			{"A2_MSBLQL",   "2"                     ,nil}}

			If SA2->(DbSeek(xFilial("SA2")+aDados[_nY][5])) .And. !Empty(aDados[_nY][5])
				SA2->(RecLock("SA2",.F.))
				SA2->A2_XVENDOR := aDados[_nY][1]
				SA2->(MsUnLock())

				//ATUALIZA(aVetor)

				_cLog += AllTrim(aDados[_nY][5])+" fornecedor já existe"+CHR(13)+CHR(10)
				Loop
			EndIf

			_cQuery1 := " SELECT A2.R_E_C_N_O_ RECSA2
			_cQuery1 += " FROM "+RetSqlName("SA2")+" A2
			_cQuery1 += " WHERE A2.D_E_L_E_T_=' ' AND A2_XVENDOR='"+AllTrim(aDados[_nY][1])+"'

			If !Empty(Select(_cAlias1))
				DbSelectArea(_cAlias1)
				(_cAlias1)->(dbCloseArea())
			Endif

			dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

			dbSelectArea(_cAlias1)

			(_cAlias1)->(dbGoTop())

			If (_cAlias1)->(!Eof())
				SA2->(DbGoTo((_cAlias1)->RECSA2))
				_cLog += AllTrim(aDados[_nY][2])+" fornecedor já existe"+CHR(13)+CHR(10)
				If SA2->(!Eof())
					//ATUALIZA(aVetor)
				EndIf
				Loop
			EndIf

			lMsErroAuto := .F.

			MSExecAuto({|x,y| Mata020(x,y)},aVetor,3)

			If lMsErroAuto
				_cErro := MostraErro("arquivos\logs",dtos(date())+time()+".log")
				_cLog += AllTrim(aDados[_nY][2])+" erro ao processar: "+_cErro+CHR(13)+CHR(10)
			Else
				_cLog += AllTrim(aDados[_nY][2])+" inserido com sucesso"+CHR(13)+CHR(10)
			EndIf

		Else

			If SA2->(DbSeek(xFilial("SA2")+aDados[_nY][5])) .And. !Empty(aDados[_nY][5])
				_cLog += AllTrim(aDados[_nY][2])+" fornecedor já existe"+CHR(13)+CHR(10)
				Loop
			EndIf

			If !SA2->(DbSeek(xFilial("SA2")+aDados[_nY][5]))

				SA2->(RecLock("SA2",.T.))
				SA2->(MsUnLock())

				_cLog += AllTrim(aDados[_nY][5])+" inserido com sucesso!"+CHR(13)+CHR(10)

			Else

				SA2->(RecLock("SA2",.F.))
				SA2->(MsUnLock())

				_cLog += AllTrim(aDados[_nY][5])+" alterado com sucesso!"+CHR(13)+CHR(10)

			EndIf

		EndIf

	Next

	@ 000, 000 TO 230, 350 DIALOG oDlg TITLE 'Relatório de inconsistências'
	@ 005,005 Get _cLog Size 167,080 MEMO Object oMemo
	@ 92,135 BMPBUTTON TYPE 1 ACTION Close(oDlg)
	ACTIVATE DIALOG oDlg CENTERED

Return()

Static Function STTIRAGR(_cStrRec,_nTam)

	Default _cStrRec := ""

	_cStrRec = StrTran (_cStrRec, "-", "")
	_cStrRec = StrTran (_cStrRec, "+", "")
	_cStrRec = StrTran (_cStrRec, " ", "")
	_cStrRec = StrTran (_cStrRec, "(", "")
	_cStrRec = StrTran (_cStrRec, ")", "")
	_cStrRec = StrTran (_cStrRec, ".", "")

	_cStrRet := _cStrRec

	_cStrRet := AllTrim(_cStrRet)
	_cStrRet := SubStr(_cStrRet,1,_nTam)

Return(_cStrRet)

/*====================================================================================\
|Programa  | ATUALIZA        | Autor | RENATO.OLIVEIRA           | Data | 18/02/2020  |
|=====================================================================================|
|Descrição | 													                      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

Static Function ATUALIZA(aVetor)

	Local _nW
	Local _cCampo := ""

	SA2->(RecLock("SA2",.F.))

	For _nW:=1 To Len(aVetor)
		If !("A2_LOJA" $ AllTrim(aVetor[_nW][1]))
			SA2->&(aVetor[_nW][1]) := aVetor[_nW][2]
		EndIf
	Next

	SA2->(MsUnLock())

Return()
