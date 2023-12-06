#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*====================================================================================\
|Programa  |ARIMPSB9       | Autor | RENATO.OLIVEIRA             | Data | 01/11/2018  |
|=====================================================================================|
|Descrição | IMPORTAR CUSTO NA SB9                                                    |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   |                                                                          |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function ARIMPSB9()

	Local cArquivo := ""
	Local aDados   := {}
	Local aCampos  := {}
	Local lPrim	   := .T.
	Local _cLog	   := ""
	Local i:=0
	Local x:=0

	cArquivo := cGetFile("Arquivos CSV  (*.CSV)  | *.CSV  ","",1,"C:\",.T.,GETF_LOCALHARD,.T.,.T.)

	If Empty(cArquivo)
		Return
	EndIf

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

	DbSelectArea("SB9")
	SB9->(DbSetOrder(1))
	SB9->(DbGoTop())

	ProcRegua(Len(aDados))   //incrementa regua
	For i:=1 to Len(aDados)  //ler linhas da array

		If SB9->(DbSeek(xFilial("SB9")+PADR(aDados[i][1],TamSx3("B9_COD")[1])+PADL(aDados[i][2],TamSx3("B9_LOCAL")[1],"0")+DTOS(CTOD(aDados[i][3]))))

			_nQtd := SB9->B9_QINI

			If _nQtd==0
				_nQtd := 1
			EndIf

			SB9->(RecLock("SB9",.F.))

			If aDados[i][5]=="1" //Pesos

				SB9->B9_CM1	  	:= Val(StrTran(aDados[i][4],",","."))
				SB9->B9_VINI1 	:= _nQtd*SB9->B9_CM1
				SB9->B9_CMRP1 	:= SB9->B9_CM1
				SB9->B9_VINIRP1	:= _nQtd*SB9->B9_CMRP1

			ElseIf aDados[i][5]=="2" //Dolar

				SB9->B9_CM2	  	:= Val(StrTran(aDados[i][4],",","."))
				SB9->B9_VINI2 	:= _nQtd*SB9->B9_CM2
				SB9->B9_CMRP2 	:= SB9->B9_CM2
				SB9->B9_VINIRP2	:= _nQtd*SB9->B9_CMRP2

			EndIf

			SB9->(MsUnLock())

			_cLog += "Produto "+aDados[i][1]+" local "+PADL(aDados[i][2],TamSx3("B9_LOCAL")[1],"0")+" data "+aDados[i][3]+" atualizado"+CHR(13)+CHR(10)
		Else
			_cLog += "Produto "+aDados[i][1]+" local "+PADL(aDados[i][2],TamSx3("B9_LOCAL")[1],"0")+" data "+aDados[i][3]+" não encontrado"+CHR(13)+CHR(10)
		EndIf

	Next

	@ 000, 000 TO 230, 350 DIALOG oDlg TITLE 'Resumo do processamento'
	@ 005,005 Get _cLog Size 167,080 MEMO Object oMemo
	@ 92,135 BMPBUTTON TYPE 1 ACTION Close(oDlg)
	ACTIVATE DIALOG oDlg CENTERED

Return()