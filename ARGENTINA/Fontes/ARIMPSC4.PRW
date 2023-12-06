#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"

/*====================================================================================\
|Programa  | ARIMPSC4        | Autor | RENATO.OLIVEIRA           | Data | 24/10/2018  |
|=====================================================================================|
|Descrição | ROTINA PARA IMPORTAR SC4				                                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function ARIMPSC4()

	Processa( {||XSC4() }, "Aguarde...", ,.F.)

Return()

Static Function XSC4()

	Local cArquivo 	:= ""
	Local aDados   	:= {}
	Local aCampos  	:= {}
	Local lPrim	   	:= .T.
	Local i:=0
	Local x:=0
	Local _cB1Cod	:= ""

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

	DbSelectArea("SC4")
	SE1->(DbSetOrder(1)) //E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO

	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))
	i:=0
	x:=0
	ProcRegua(Len(aDados))   //incrementa regua

	For i:=1 to Len(aDados)  //ler linhas da array
		ProcRegua(Len(aDados)-i)
		
		If SC4->(DbSeek(xFilial("SC4")+PADR(aDados[i][1],TamSx3("B1_COD")[1])+DTOS( Ctod(aDados[i][5]))))
			SC4->(RecLock("SC4",.F.))
			SC4->C4_QUANT	:= Val(aDados[i][4])
			SC4->C4_OBS		:= "IMP "+DTOC(Date())
			SC4->(MsUnLock())
		Else

			SB1->(DbGoTop())

			If SB1->(DbSeek(xFilial("SB1")+aDados[i][1]))
				SC4->(RecLock("SC4",.T.))
				SC4->C4_FILIAL 	:= xFilial("SC4")
				SC4->C4_PRODUTO	:= aDados[i][1]
				SC4->C4_LOCAL	:= StrZero(Val(aDados[i][2]),2)
				SC4->C4_DOC		:= aDados[i][3]
				SC4->C4_QUANT	:= Val(aDados[i][4])
				SC4->C4_DATA	:= Ctod(aDados[i][5]) //CTOD(aCampos[x])
				SC4->C4_OBS		:= "IMP "+DTOC(Date())
				SC4->(MsUnLock())
			EndIf

		EndIf
		
		// Para Atualizar campo de Previsao Mensal de Vendas
		If _cB1Cod <> aDados[i][1]
			_cB1Cod := aDados[i][1]

			If SB1->(DbSeek(xFilial("SB1")+aDados[i][1]))
				SB1->(RecLock("SB1",.F.))
				SB1->B1_XPREMES := aDados[i][4]
				SB1->(MsUnLock())
			Endif
		Endif			

	Next i

	MsgAlert("Importação finalizada, obrigado!")

	/*
	@ 000, 000 TO 230, 350 DIALOG oDlg TITLE 'Resumo do processamento'
	@ 005,005 Get _cLog Size 167,080 MEMO Object oMemo
	@ 92,135 BMPBUTTON TYPE 1 ACTION Close(oDlg)
	ACTIVATE DIALOG oDlg CENTERED
	*/

Return()
