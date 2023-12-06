#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"

/*====================================================================================\
|Programa  | STIMPSC4        | Autor | RENATO.OLIVEIRA           | Data | 24/10/2018  |
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

User Function STIMPSC4()

	Processa( {||XSC4() }, "Aguarde...", ,.F.)

Return()

Static Function XSC4()

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

	DbSelectArea("SC4")
	SE1->(DbSetOrder(1)) //E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO

	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))
	i:=0
	x:=0
	ProcRegua(Len(aDados))   //incrementa regua

	If cFilAnt=="02" //Importação do CD
		For i:=1 to Len(aDados)  //ler linhas da array
    		
			ProcRegua(Len(aDados)-i) 
			For x:=2 to Len(aCampos)

				SC4->(DbGoTop())
				If SC4->(DbSeek(xFilial("SC4")+PADR(aDados[i][1],TamSx3("B1_COD")[1])+DTOS(CTOD(aCampos[x]))))
					SC4->(RecLock("SC4",.F.))
					SC4->C4_QUANT	:= Val(aDados[i][x])
					SC4->C4_OBS		:= "IMP "+DTOC(Date())
					SC4->(MsUnLock())
				Else
					SB1->(DbGoTop())
					If SB1->(DbSeek(xFilial("SB1")+aDados[i][1]))
						SC4->(RecLock("SC4",.T.))
						SC4->C4_FILIAL 	:= xFilial("SC4")
						SC4->C4_PRODUTO	:= SB1->B1_COD
						SC4->C4_LOCAL	:= SB1->B1_LOCPAD
						SC4->C4_QUANT	:= Val(aDados[i][x])
						SC4->C4_DATA	:= CTOD(aCampos[x])
						SC4->C4_OBS		:= "IMP "+DTOC(Date())
						SC4->(MsUnLock())
					EndIf

				EndIf

			Next x

		Next i
	Else
		For i:=1 to Len(aDados)  //ler linhas da array
	    	ProcRegua(Len(aDados)-i) 
			SC4->(DbGoTop())
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
					SC4->C4_LOCAL	:= aDados[i][2]
					SC4->C4_DOC		:= aDados[i][3]
					SC4->C4_QUANT	:= Val(aDados[i][4])
					SC4->C4_DATA	:= Ctod(aDados[i][5]) //CTOD(aCampos[x])
					SC4->C4_OBS		:= "IMP "+DTOC(Date())
					SC4->(MsUnLock())
				EndIf
			EndIf
		Next i
	EndIf

	MsgAlert("Importação finalizada, obrigado!")

Return()
