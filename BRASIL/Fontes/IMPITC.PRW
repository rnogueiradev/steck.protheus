#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"

/*/{Protheus.doc} IMPITC
(Importacao Planilha ITC)

@author jefferson.carlos
@since 20/09/2016
@version 1.0
@return

/*/

User Function IMPITC()			// Alterado por Valdemir Rabelo 08/10/2019
	Processa( {|| IMPITCA1() }, "Aguarde, Processando")
Return

Static Function IMPITCA1()

	Local cArq    := "steck.csv"
	Local cLinha  := ""
	Local lPrim   := .T.
	Local aCampos := {}
	Local aDados  := {}
	Local cDir	  := "C:\"
	Local n		  := 0
	Local i		  := 0
	Local cCodSte := ""
	Local _nOpc	  := 0

	Private aErro := {}

	cDir:= cGetFile("Arquivos CSV  (*.CSV)  | *.CSV  ","",1,"C:\",.T.,GETF_LOCALHARD,.T.,.T.)

	If Empty(cDir)
		Return()
	EndIf

	If !File(cDir)
		MsgStop("O arquivo " +cDir + " não foi encontrado. A importação será abortada!","[AEST901] - ATENCAO")
		Return
	EndIf

	If !MsgNoYes("Confirma a importação do arquivo " + cDir + " ?")
		MsgAlert("Importação abortada")
		Return
	EndIf

	FT_FUSE(cDir)                   // abrir arquivo
	ProcRegua(FT_FLASTREC())             // quantos registros ler
	FT_FGOTOP()                          // ir para o topo do arquivo
	While !FT_FEOF()

		IncProc("Lendo arquivo texto...")

		cLinha := FT_FREADLN()           // lendo a linha
		cLinha := Upper(U_STTIRAGR(cLinha))

		If lPrim
			aCampos := Separa(cLinha,";",.T.)
			lPrim := .F.
		Else
			AADD(aDados,Separa(cLinha,";",.T.))
		EndIf

		FT_FSKIP()
	EndDo

	DbSelectArea("PC4")
	PC4->(DbSetOrder(3))//PC4_FILIAL+PC4_ESTADO+PC4_CIDADE+PC4_BAIRRO
	cMsgCid := ""

	ProcRegua(Len(aDados))   //incrementa regua
	For i:=1 To Len(aDados)  //ler linhas da array

		IncProc("Importando ZZ5......"+StrZero(i,5))

		DbSelectArea("ZZ5")
		ZZ5->(DbGoTop())
		ZZ5->(dbSetOrder(1))
		ZZ5->(DbSeek(xFilial("ZZ5")+aDados[i,2]))

		If ZZ5->(Eof())
			cCodSte	:= NextCod()
			Reclock("ZZ5",.T.)
			ZZ5->ZZ5_FILIAL		:= xFilial("ZZ5")
			ZZ5->ZZ5_COD		:= aDados[i,2]
			ZZ5->ZZ5_CODSTE		:= cCodSte
			ZZ5->ZZ5_STATUS		:= "O"
			_nOpc := 3
		Else
			Reclock("ZZ5",.F.)
			_nOpc := 4
		EndIF

		_cEstado := UPPER(SubStr(aDados[i,3],1,2))
		_cCidade := PADR(UPPER(AllTrim(aDados[i,10])),45)
		_cBairro := UPPER(AllTrim(aDados[i,8]))
		cVend 	 := ""

		If !PC4->(DbSeek(xFilial("PC4")+_cEstado))
			cMsgCid += "Obra "+AllTrim(aDados[i,2])+" - local não encontrado e será direcionada para o vendedor padrão"+CHR(13)+CHR(10)
		Else
			If Empty(PC4->PC4_CIDADE)//Caso estiver vazio atende o estado todo
				cVend := PC4->PC4_VEND
			Else
				If PC4->(DbSeek(xFilial("PC4")+_cEstado+_cCidade+_cBairro))
					cVend := PC4->PC4_VEND
				ElseIf PC4->(DbSeek(xFilial("PC4")+_cEstado+_cCidade))
					cVend := PC4->PC4_VEND
				Else
					cMsgCid += "Obra "+AllTrim(aDados[i,2])+" - local não encontrado e será direcionada para o vendedor padrão"+CHR(13)+CHR(10)
				EndIf
			EndIf
		EndIf

		If Empty(cVend)
			cVend := "I08595"
		EndIf

		ZZ5->ZZ5_ESTADO	:= aDados[i,3]
		ZZ5->ZZ5_DATA	:= CTOD(aDados[i,4])
		ZZ5->ZZ5_REVISA	:= aDados[i,5]
		ZZ5->ZZ5_NOMEOB	:= aDados[i,6]
		ZZ5->ZZ5_ENDERE	:= aDados[i,7]
		ZZ5->ZZ5_BAIRRO	:= aDados[i,8]
		ZZ5->ZZ5_CEP	:= aDados[i,9]
		ZZ5->ZZ5_CIDADE	:= aDados[i,10]
		ZZ5->ZZ5_INICIO	:= CTOD(aDados[i,11])
		ZZ5->ZZ5_TERMIN	:= CTOD(aDados[i,12])
		ZZ5->ZZ5_INITER	:= aDados[i,13]
		ZZ5->ZZ5_ESTAGI	:= aDados[i,14]
		ZZ5->ZZ5_FASE	:= aDados[i,15]
		ZZ5->ZZ5_SEGMEN	:= aDados[i,16]
		ZZ5->ZZ5_SUBTIP	:= aDados[i,17]
		ZZ5->ZZ5_NUMEDI	:= Val(aDados[i,18])
		ZZ5->ZZ5_CASAS	:= Val(aDados[i,19])
		ZZ5->ZZ5_CONDCA	:= Val(aDados[i,20])
		ZZ5->ZZ5_OUTROS	:= aDados[i,21]
		ZZ5->ZZ5_TOTUNI	:= Val(aDados[i,22])
		ZZ5->ZZ5_NOME	:= aDados[i,23]
		ZZ5->ZZ5_CARGO	:= aDados[i,24]
		ZZ5->ZZ5_NOFANT	:= aDados[i,25]
		ZZ5->ZZ5_DDD	:= Val(Substr(aDados[i,27],1,2))
		ZZ5->ZZ5_TEL1	:= Substr(aDados[i,27],3)
		ZZ5->ZZ5_EMAIL	:= aDados[i,28]
		ZZ5->ZZ5_AREA	:= cVend
		ZZ5->(MsUnlock())

		U_STEITC01(_nOpc)

	Next i

	If !Empty(cMsgCid)
		@ 000, 000 TO 230, 350 DIALOG oDlg TITLE 'Resumo do processamento'
		@ 005,005 Get cMsgCid Size 167,080 MEMO Object oMemo
		@ 92,135 BMPBUTTON TYPE 1 ACTION Close(oDlg)
		ACTIVATE DIALOG oDlg CENTERED
	EndIf

	FT_FUSE()

	ApMsgInfo("Importação concluída com sucesso!","[AEST901] - SUCESSO")

Return

Static Function NextCod()

	Local cCodSte	:= ""
	Local aAreaZZ5	:= ZZ5->(GetArea())

	ZZ5->(dbSetOrder(2))
	Do While .T.
		cCodSte	:= GetSx8Num("ZZ5","ZZ5_CODSTE",,2)
		ConfirmSx8()
		If ! ZZ5->(DbSeek(xFilial("ZZ5")+cCodSte))
			Exit
		EndIf
	EndDo
	ZZ5->(RestArea(aAreaZZ5))

Return(cCodSte)
