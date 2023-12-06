#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"

/*====================================================================================\
|Programa  | STIMP060        | Autor | RENATO.OLIVEIRA           | Data | 27/04/2020  |
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

User Function STIMP060()
	
	Local _nY
	Private cArquivo := ""

	//RpcSetType( 3 )
	//RpcSetEnv("01","02",,,"FAT")

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
	Local _aHeader1 := {}
	Local _aCols1 	:= {}
	Local _nY, nY, _nX
	Private aDados   := {}

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

	oProcess:SetRegua1(Len(aDados))

	_cLog := ""

	DbSelectArea("SE1")
	SE1->(DbSetOrder(2)) //E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
	DbSelectArea("FI2")
	FI2->(DbSetOrder(1)) //FI2_FILIAL+FI2_CARTEI+FI2_NUMBOR+FI2_PREFIX+FI2_TITULO+FI2_PARCEL+FI2_TIPO+FI2_CODCLI+FI2_LOJCLI+FI2_OCORR+FI2_GERADO

	_aProc := {}

	For _nY:=1 To Len(aDados)

		oProcess:IncRegua1("Importando "+cValToChar(_nY)+"/"+cValToChar(Len(aDados)))

		If !(Len(aDados[_nY])==7)
			Loop
		EndIf

		_cCliente := PADL(aDados[_nY][1],TamSx3("A1_COD")[1],"0")
		_cLoja	  := PADL(aDados[_nY][2],TamSx3("A1_LOJA")[1],"0")
		_cPrefixo := PADL(aDados[_nY][3],TamSx3("E1_PREFIXO")[1],"0")
		_cNum	  := PADL(aDados[_nY][4],TamSx3("E1_NUM")[1],"0")
		_cParcela := PADL(aDados[_nY][5],TamSx3("E1_PARCELA")[1],"")
		_cHist	  := AllTrim(aDados[_nY][7])

		If !SE1->(DbSeek(xFilial("SE1")+_cCliente+_cLoja+_cPrefixo+_cNum+_cParcela))
			AADD(_aProc,{cValToChar(_nY),_cNum,"ERRO","Título não encontrado"})
			Loop
		EndIf

		_cValAnt := DTOC(SE1->E1_VENCREA)

		SE1->(RecLock("SE1",.F.))
		SE1->E1_VENCREA := CTOD(aDados[_nY][6])
		SE1->E1_OCORREN := "06"
		SE1->E1_HIST	:= _cHist
		SE1->(MsUnLock())

		_lInclui := .F.

		If !FI2->(DbSeek(SE1->E1_FILIAL+"1"+SE1->(E1_NUMBOR+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA+E1_OCORREN)+"1"))
			_lInclui := .T.
		Else
			If !(FI2->FI2_DTGER==Date())
				_lInclui := .T.
			EndIf
		EndIf

		If _lInclui
			FI2->(RecLock("FI2",.T.))
			FI2->FI2_FILIAL := SE1->E1_FILIAL
			FI2->FI2_OCORR  := SE1->E1_OCORREN
			FI2->FI2_DESCOC := "ALTERACAO DO VENCIME"
			FI2->FI2_PREFIX	:= SE1->E1_PREFIXO
			FI2->FI2_TITULO	:= SE1->E1_NUM
			FI2->FI2_PARCEL := SE1->E1_PARCELA
			FI2->FI2_TIPO	:= SE1->E1_TIPO
			FI2->FI2_CODCLI	:= SE1->E1_CLIENTE
			FI2->FI2_LOJCLI	:= SE1->E1_LOJA
			FI2->FI2_GERADO := "2"
			FI2->FI2_NUMBOR := SE1->E1_NUMBOR
			FI2->FI2_CARTEI := "1"
			FI2->FI2_DTOCOR := Date()
			FI2->FI2_VALANT := _cValAnt
			FI2->FI2_VALNOV := DTOC(SE1->E1_VENCREA)
			FI2->FI2_CAMPO  := "E1_VENCREA"
			FI2->FI2_TIPCPO	:= "D"
			FI2->(MsUnLock())
		EndIf

		AADD(_aProc,{cValToChar(_nY),_cNum,"OK","Atualizado com sucesso"})

	Next

	_aHeader1 := {}
	_aCols1   := {}

	Aadd(_aHeader1,{"Legenda"				,"LEGENDA"		,"@BMP"						,1								,0				,"",,"C","R"})
	Aadd(_aHeader1,{"Linha"					,"LINHA"		,"@!"						,5								,0				,"",,"C","R"})
	Aadd(_aHeader1,{"Título"				,"E1_NUM"		,"@!"						,TamSx3("E1_NUM")[1]			,0				,"",,"C","R"})
	Aadd(_aHeader1,{"Status"				,"STATUS"		,"@!"						,10								,0				,"",,"C","R"})
	Aadd(_aHeader1,{"Observação"     		,"OBS"			,"@!"						,50								,0				,"",,"C","R"})

	For _nX:=1 To Len(_aProc)

		AADD(_aCols1,Array(Len(_aHeader1)+1))

		For nY := 1 To Len(_aHeader1)

			DO CASE

				CASE AllTrim(_aHeader1[nY][2]) =  "LEGENDA"
				_aCols1[Len(_aCols1)][nY] := IIf(AllTrim(_aProc[_nX][3])=="OK","BR_VERDE","BR_VERMELHO")
				CASE AllTrim(_aHeader1[nY][2]) =  "LINHA"
				_aCols1[Len(_aCols1)][nY] := _aProc[_nX][1]
				CASE AllTrim(_aHeader1[nY][2]) =  "E1_NUM"
				_aCols1[Len(_aCols1)][nY] := _aProc[_nX][2]
				CASE AllTrim(_aHeader1[nY][2]) =  "STATUS"
				_aCols1[Len(_aCols1)][nY] := _aProc[_nX][3]
				CASE AllTrim(_aHeader1[nY][2]) =  "OBS"
				_aCols1[Len(_aCols1)][nY] := _aProc[_nX][4]
			ENDCASE

		Next

		_aCols1[Len(_aCols1)][Len(_aHeader1)+1] := .F.

	Next

	DEFINE MSDIALOG oDlgEmail1 TITLE OemToAnsi("Resumo de processamento") From  1,0 To 500,800 Pixel

	MsNewGetDados():New(0,0,oDlgEmail1:nClientHeight/2-15,oDlgEmail1:nClientWidth/2-5,,"AllWaysTrue()","AllWaysTrue()",,,,Len(_aCols1),,, ,oDlgEmail1,_aHeader1,_aCols1)

	ACTIVATE MSDIALOG oDlgEmail1 CENTERED

Return()