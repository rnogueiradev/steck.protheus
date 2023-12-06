#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"
#include "tbiconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ STCTB49 ºAutor  ³Cristiano Pereira   º Data ³  24/08/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Atualização dos fornecedores nos movimentos contábeis       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³          ³Especifico Steck Industria                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

User Function STCTB49()

	Local aSays			:= {}
	Local aButtons 		:= {}
	Local nOpca 		:= 0
	Local cCadastro		:= " Código dos fornecedores, movimentos contábeis "

	AADD(aSays," Código dos fornecedores, movimentos contábeis ")
	AADD(aSays," ")
	AADD(aSays,"")
	AADD(aSays,"")
	AADD(aSays,"")
	AADD(aSays,"VERSAO 1.0 ")
	AADD(aSays,"Especifico Steck Industria")
	AADD(aButtons, { 1,.T.,{|o| nOpca:= 1,o:oWnd:End() } } )
	AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )

	FormBatch( cCadastro , aSays , aButtons )


	Processa( { || STCTB49A() } , "Processando, código dos fornecedores, movimentos contábeis." )
	MsgInfo("Processando, código dos fornecedores, movimentos contábeis..","Atenção")

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ STCTB49A ºAutor  ³Cristiano Pereira   º Data ³  24/08/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Inicio do processamento                                     º±±
±±º          ³                                                            º±±
±±º          |                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³          ³Especifico Steck Industria                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function STCTB49A()


	Local _cQryCT2 := ""

	If Select ("TCT2") > 0
		dbSelectArea("TCT2")
		dbCloseArea()
	Endif


	_cQryCT2 := " SELECT CT2.*                            "
	_cQryCT2 += " FROM "+RetSqlName("CT2")+" CT2          "
	_cQryCT2 += " WHERE CT2.D_E_L_E_T_ <> '*'         AND "
	_cQryCT2 += "       CT2.CT2_DATA>='20210101'      AND "
	_cQryCT2 += "       CT2.CT2_DATA<='20210531'      AND "
	_cQryCT2 += "       CT2.CT2_XFORNE=' '               "

	TCQUERY _cQryCT2 NEW ALIAS "TCT2"


	_nRec := 0
	DbEval({|| _nRec++  })

	aLERT(	_nRec )

	DbSelectArea("TCT2")
	DbGotop()

	While !TCT2->(EOF())


		IncProc("Registro:"+ TCT2->CT2_HIST+" de "+DTOC(STOD(TCT2->CT2_DATA)))

		DbSelectArea("CT2")
		DbSetOrder(1)
		If DbSeek(xFilial("CT2")+DTOS(STOD(TCT2->CT2_DATA))+TCT2->CT2_LOTE+TCT2->CT2_SBLOTE+TCT2->CT2_DOC+TCT2->CT2_LINHA+TCT2->CT2_TPSALD+TCT2->CT2_EMPORI+TCT2->CT2_FILORI+TCT2->CT2_MOEDLC)

			If !Empty(CT2->CT2_ITEMD) .And. TCT2->CT2_LP=="650"

				DbSelectArea("SA2")
				DbSetOrder(1)
				If DbSeek(xFilial("SA2")+SubStr(CT2->CT2_ITEMD,2,8))
					If Reclock("CT2",.F.)
						CT2->CT2_XFORNE:= SA2->A2_COD
						CT2->CT2_XLOJA := SA2->A2_LOJA
						CT2->CT2_XNOME := SA2->A2_NOME
						MsUnlock()
					Endif
				Endif



				DbSelectArea("SA2")
				DbSetOrder(1)
				If DbSeek(xFilial("SA2")+SUBSTR(CT2->CT2_KEY,15,8))
					If Reclock("CT2",.F.)
						CT2->CT2_XFORNE:= SA2->A2_COD
						CT2->CT2_XLOJA := SA2->A2_LOJA
						CT2->CT2_XNOME := SA2->A2_NOME
						MsUnlock()
					Endif
				Endif


			Endif


			If !Empty(CT2->CT2_ITEMC) .And. TCT2->CT2_LP=="650"

				DbSelectArea("SA2")
				DbSetOrder(1)
				If DbSeek(xFilial("SA2")+SubStr(CT2->CT2_ITEMC,2,8))
					If Reclock("CT2",.F.)
						CT2->CT2_XFORNE:= SA2->A2_COD
						CT2->CT2_XLOJA := SA2->A2_LOJA
						CT2->CT2_XNOME := SA2->A2_NOME
						MsUnlock()
					Endif
				Endif

				DbSelectArea("SA2")
				DbSetOrder(1)
				If DbSeek(xFilial("SA2")+SUBSTR(CT2->CT2_KEY,15,8))
					If Reclock("CT2",.F.)
						CT2->CT2_XFORNE:= SA2->A2_COD
						CT2->CT2_XLOJA := SA2->A2_LOJA
						CT2->CT2_XNOME := SA2->A2_NOME
						MsUnlock()
					Endif
				Endif


			Endif







			If !Empty(CT2->CT2_ITEMD) .And. TCT2->CT2_LP=="610"

				DbSelectArea("SA1")
				DbSetOrder(1)
				If DbSeek(xFilial("SA1")+SubStr(CT2->CT2_ITEMD,2,8))
					If Reclock("CT2",.F.)
						CT2->CT2_XFORNE:= SA1->A1_COD
						CT2->CT2_XLOJA := SA1->A1_LOJA
						CT2->CT2_XNOME := SA1->A1_NOME
						MsUnlock()
					Endif
				Endif


				DbSelectArea("SA1")
				DbSetOrder(1)
				If DbSeek(xFilial("SA1")+SUBSTR(CT2->CT2_KEY,15,8))
					If Reclock("CT2",.F.)
						CT2->CT2_XFORNE:= SA1->A1_COD
						CT2->CT2_XLOJA := SA1->A1_LOJA
						CT2->CT2_XNOME := SA1->A1_NOME
						MsUnlock()
					Endif
				Endif


			Endif


			If !Empty(CT2->CT2_ITEMC) .And. TCT2->CT2_LP=="610"

				DbSelectArea("SA1")
				DbSetOrder(1)
				If DbSeek(xFilial("SA1")+SubStr(CT2->CT2_ITEMC,2,8))
					If Reclock("CT2",.F.)
						CT2->CT2_XFORNE:= SA1->A1_COD
						CT2->CT2_XLOJA := SA1->A1_LOJA
						CT2->CT2_XNOME := SA1->A1_NOME
						MsUnlock()
					Endif
				Endif

				DbSelectArea("SA1")
				DbSetOrder(1)
				If DbSeek(xFilial("SA1")+SUBSTR(CT2->CT2_KEY,15,8))
					If Reclock("CT2",.F.)
						CT2->CT2_XFORNE:= SA1->A1_COD
						CT2->CT2_XLOJA := SA1->A1_LOJA
						CT2->CT2_XNOME := SA1->A1_NOME
						MsUnlock()
					Endif
				Endif


			Endif





			If !Empty(CT2->CT2_ITEMD) .And. TCT2->CT2_LP=="640"

				DbSelectArea("SA1")
				DbSetOrder(1)
				If DbSeek(xFilial("SA1")+SubStr(CT2->CT2_ITEMD,2,8))
					If Reclock("CT2",.F.)
						CT2->CT2_XFORNE:= SA1->A1_COD
						CT2->CT2_XLOJA := SA1->A1_LOJA
						CT2->CT2_XNOME := SA1->A1_NOME
						MsUnlock()
					Endif
				Endif

				DbSelectArea("SA1")
				DbSetOrder(1)
				If DbSeek(xFilial("SA1")+SUBSTR(CT2->CT2_KEY,15,8))
					If Reclock("CT2",.F.)
						CT2->CT2_XFORNE:= SA1->A1_COD
						CT2->CT2_XLOJA := SA1->A1_LOJA
						CT2->CT2_XNOME := SA1->A1_NOME
						MsUnlock()
					Endif
				Endif


			Endif


			If !Empty(CT2->CT2_ITEMC) .And. TCT2->CT2_LP=="640"

				DbSelectArea("SA1")
				DbSetOrder(1)
				If DbSeek(xFilial("SA1")+SubStr(CT2->CT2_ITEMC,2,8))
					If Reclock("CT2",.F.)
						CT2->CT2_XFORNE:= SA1->A1_COD
						CT2->CT2_XLOJA := SA1->A1_LOJA
						CT2->CT2_XNOME := SA1->A1_NOME
						MsUnlock()
					Endif
				Endif

				DbSelectArea("SA1")
				DbSetOrder(1)
				If DbSeek(xFilial("SA1")+SUBSTR(CT2->CT2_KEY,15,8))
					If Reclock("CT2",.F.)
						CT2->CT2_XFORNE:= SA1->A1_COD
						CT2->CT2_XLOJA := SA1->A1_LOJA
						CT2->CT2_XNOME := SA1->A1_NOME
						MsUnlock()
					Endif
				Endif


			Endif




			If !Empty(CT2->CT2_ITEMD) .And. TCT2->CT2_LP=="520"

				DbSelectArea("SA1")
				DbSetOrder(1)
				If DbSeek(xFilial("SA1")+SubStr(CT2->CT2_ITEMD,2,8))
					If Reclock("CT2",.F.)
						CT2->CT2_XFORNE:= SA1->A1_COD
						CT2->CT2_XLOJA := SA1->A1_LOJA
						CT2->CT2_XNOME := SA1->A1_NOME
						MsUnlock()
					Endif
				Endif

				DbSelectArea("SA1")
				DbSetOrder(1)
				If DbSeek(xFilial("SA1")+SUBSTR(CT2->CT2_KEY,15,8))
					If Reclock("CT2",.F.)
						CT2->CT2_XFORNE:= SA1->A1_COD
						CT2->CT2_XLOJA := SA1->A1_LOJA
						CT2->CT2_XNOME := SA1->A1_NOME
						MsUnlock()
					Endif
				Endif


			Endif


			If !Empty(CT2->CT2_ITEMC) .And. TCT2->CT2_LP=="520"


				DbSelectArea("SA1")
				DbSetOrder(1)
				If DbSeek(xFilial("SA1")+SubStr(CT2->CT2_ITEMC,2,8))
					If Reclock("CT2",.F.)
						CT2->CT2_XFORNE:= SA1->A1_COD
						CT2->CT2_XLOJA := SA1->A1_LOJA
						CT2->CT2_XNOME := SA1->A1_NOME
						MsUnlock()
					Endif
				Endif

				DbSelectArea("SA1")
				DbSetOrder(1)
				If DbSeek(xFilial("SA1")+SUBSTR(CT2->CT2_KEY,15,8))
					If Reclock("CT2",.F.)
						CT2->CT2_XFORNE:= SA1->A1_COD
						CT2->CT2_XLOJA := SA1->A1_LOJA
						CT2->CT2_XNOME := SA1->A1_NOME
						MsUnlock()
					Endif
				Endif

			Endif



			If !Empty(CT2->CT2_ITEMD) .And. TCT2->CT2_LP=="530"

				DbSelectArea("SA2")
				DbSetOrder(1)
				If DbSeek(xFilial("SA2")+SubStr(CT2->CT2_ITEMD,2,8))
					If Reclock("CT2",.F.)
						CT2->CT2_XFORNE:= SA2->A2_COD
						CT2->CT2_XLOJA := SA2->A2_LOJA
						CT2->CT2_XNOME := SA2->A2_NOME
						MsUnlock()
					Endif
				Endif

				DbSelectArea("SA2")
				DbSetOrder(1)
				If DbSeek(xFilial("SA2")+SUBSTR(CT2->CT2_KEY,15,8))
					If Reclock("CT2",.F.)
						CT2->CT2_XFORNE:= SA2->A2_COD
						CT2->CT2_XLOJA := SA2->A2_LOJA
						CT2->CT2_XNOME := SA2->A2_NOME
						MsUnlock()
					Endif
				Endif

			Endif


			If !Empty(CT2->CT2_ITEMC) .And. TCT2->CT2_LP=="530"

				DbSelectArea("SA2")
				DbSetOrder(1)
				If DbSeek(xFilial("SA2")+SubStr(CT2->CT2_ITEMC,2,8))
					If Reclock("CT2",.F.)
						CT2->CT2_XFORNE:= SA2->A2_COD
						CT2->CT2_XLOJA := SA2->A2_LOJA
						CT2->CT2_XNOME := SA2->A2_NOME
						MsUnlock()
					Endif
				Endif

				DbSelectArea("SA2")
				DbSetOrder(1)
				If DbSeek(xFilial("SA2")+SUBSTR(CT2->CT2_KEY,15,8))
					If Reclock("CT2",.F.)
						CT2->CT2_XFORNE:= SA2->A2_COD
						CT2->CT2_XLOJA := SA2->A2_LOJA
						CT2->CT2_XNOME := SA2->A2_NOME
						MsUnlock()
					Endif
				Endif
			Endif


		Endif
		DbSelectArea("TCT2")
		DbSkip()
	Enddo



return
