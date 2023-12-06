#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"
#include "tbiconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ STFIS053 ºAutor  ³Cristiano Pereira   º Data ³  24/08/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Importação da amarracao produto x fornecedor Steck SP/AM    º±±
±±º          ³                                                            º±±
±±º          |                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³          ³Especifico SMB Automotive                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

User Function STFIS053()

	Local aSays			:= {}
	Local aButtons 		:= {}
	Local nOpca 		:= 0
	Local cCadastro		:= "Importação amarração produto x fornecedor SP/AM"

	AADD(aSays,"Importação amarração produto x fornecedor SP/AM")
	AADD(aSays," ")
	AADD(aSays,"")
	AADD(aSays,"")
	AADD(aSays,"")
	AADD(aSays,"VERSAO 1.0 ")
	AADD(aSays,"Especifico Steck Industria")
	AADD(aButtons, { 1,.T.,{|o| nOpca:= 1,o:oWnd:End() } } )
	AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )

	FormBatch( cCadastro , aSays , aButtons )

	If nOpca==1
		Processa( { || STFI053A() } , "Processando amarrações produto x fornecedor Sao Paulo..." )
		Processa( { || STFI053B() } , "Processando amarrações produto x fornecedor Manaus..." )
	Endif

	MsgInfo("Processamento finalizado com sucesso..","Atenção")


return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ STFI053A ºAutor  ³Cristiano Pereira   º Data ³  24/08/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Inicio do processamento                                     º±±
±±º          ³                                                            º±±
±±º          |                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³          ³Especifico SMB Automotive                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function STFI053A()


	Local _cQryA5 := ""

	If Select ("TSA5") > 0
		dbSelectArea("TSA5")
		dbCloseArea()
	Endif


	_cQryA5 := " SELECT SD2.D2_FILIAL AS FILIAL,   "
	_cQryA5 += "        SD2.D2_DOC    AS NF,       "
	_cQryA5 += "        SD2.D2_COD   AS PRODUTO,   "
	_cQryA5 += "        SD2.D2_CLIENTE AS CLIENTE, "
	_cQryA5 += "        SD2.D2_LOJA    AS LOJA,    "
	_cQryA5 += "        SD2.D2_SERIE   AS SERIE    "

	_cQryA5 += " FROM SD2010 SD2                   "

	_cQryA5 += " WHERE SD2.D_E_L_E_T_ <> '*'         AND "
	_cQryA5 += "       SD2.D2_EMISSAO >='20201001'   AND "
	_cQryA5 += "       SD2.D2_CLIENTE IN ('033467')  AND "
	_cQryA5 += "       SD2.D2_LOJA    IN ('05')          "



	TCQUERY  	_cQryA5   NEW ALIAS "TSA5"


	_nRec := 0
	DbEval({|| _nRec++  })

	DbSelectArea("TSA5")
	DbGotop()

	While !TSA5->(EOF())



		If TSA5->FILIAL =="02"

			DbSelectArea("SA5")
			DbSetOrder(1)
			If !DbSeek(xFilial("SA5")+"00576402"+TSA5->PRODUTO)

				DbSelectArea("SB1")
				DbSetOrder(1)
				If DbSeek(xFilial("SB1")+TSA5->PRODUTO)

					Reclock("SA5",.t.)
					SA5->A5_FILIAL := xFilial("SA5")
					SA5->A5_FORNECE := "005764"
					SA5->A5_LOJA 	:= "02"
					SA5->A5_NOMEFOR := "STECK INDUSTRIA ELETRICA LTDA"
					SA5->A5_PRODUTO := TSA5->PRODUTO //SB1->B1_COD
					SA5->A5_NOMPROD := SB1->B1_DESC
					SA5->A5_CODPRF  := TSA5->PRODUTO
					SA5->A5_SITU := "A"
					SA5->A5_TEMPLIM :=  1
					SA5->A5_FABREV := "F"

					SA5->(MsUnlock())
				Endif
			Endif

	    elseIf TSA5->FILIAL =="04"

				DbSelectArea("SA5")
				DbSetOrder(1)
				If !DbSeek(xFilial("SA5")+"00576403"+TSA5->PRODUTO)

					DbSelectArea("SB1")
					DbSetOrder(1)
					If DbSeek(xFilial("SB1")+TSA5->PRODUTO)

						Reclock("SA5",.t.)
						SA5->A5_FILIAL := xFilial("SA5")
						SA5->A5_FORNECE := "005764"
						SA5->A5_LOJA 	:= "03"
						SA5->A5_NOMEFOR := "STECK INDUSTRIA ELETRICA LTDA"
						SA5->A5_PRODUTO := TSA5->PRODUTO
						SA5->A5_NOMPROD := SB1->B1_DESC
						SA5->A5_CODPRF  := TSA5->PRODUTO
						SA5->A5_SITU := "A"
						SA5->A5_TEMPLIM :=  1
						SA5->A5_FABREV := "F"

						SA5->(MsUnlock())
					Endif
				Endif
		Endif


		DbSelectArea("TSA5")
		DbSkip()
	Enddo

return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ STFI053B ºAutor  ³Cristiano Pereira   º Data ³  24/08/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Inicio do processamento                                     º±±
±±º          ³                                                            º±±
±±º          |                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³          ³Especifico SMB Automotive                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function STFI053B()


	Local _cQryA5 := ""

	If Select ("TSA5") > 0
		dbSelectArea("TSA5")
		dbCloseArea()
	Endif


	_cQryA5 := " SELECT SD2.D2_FILIAL AS FILIAL,   "
	_cQryA5 += "        SD2.D2_DOC    AS NF,       "
	_cQryA5 += "        SD2.D2_COD   AS PRODUTO,   "
	_cQryA5 += "        SD2.D2_CLIENTE AS CLIENTE, "
	_cQryA5 += "        SD2.D2_LOJA    AS LOJA,    "
	_cQryA5 += "        SD2.D2_SERIE   AS SERIE    "

	_cQryA5 += " FROM SD2030 SD2                   "

	_cQryA5 += " WHERE SD2.D_E_L_E_T_ <> '*'         AND "
	_cQryA5 += "       SD2.D2_EMISSAO >='20201001'   AND "
	_cQryA5 += "       SD2.D2_CLIENTE IN ('033467')  AND "
	_cQryA5 += "       SD2.D2_LOJA    IN ('05')


	TCQUERY  	_cQryA5   NEW ALIAS "TSA5"


	_nRec := 0
	DbEval({|| _nRec++  })

	DbSelectArea("TSA5")
	DbGotop()

	While !TSA5->(EOF())



		If TSA5->FILIAL =="01"

			DbSelectArea("SA5")
			DbSetOrder(1)
			If !DbSeek(xFilial("SA5")+"00586601"+TSA5->PRODUTO)

				DbSelectArea("SB1")
				DbSetOrder(1)
				If DbSeek(xFilial("SB1")+TSA5->PRODUTO)

					Reclock("SA5",.t.)
					SA5->A5_FILIAL := xFilial("SA5")
					SA5->A5_FORNECE := "005866"
					SA5->A5_LOJA 	:= "01"
					SA5->A5_NOMEFOR := "STECK DA AMAZONIA INDUST ELETRICA LTDA"
					SA5->A5_PRODUTO := TSA5->PRODUTO //SB1->B1_COD
					SA5->A5_NOMPROD := SB1->B1_DESC
					SA5->A5_CODPRF  := TSA5->PRODUTO
					SA5->A5_SITU := "A"
					SA5->A5_TEMPLIM :=  1
					SA5->A5_FABREV := "F"

					SA5->(MsUnlock())
				Endif

			Endif
		Endif


		DbSelectArea("TSA5")
		DbSkip()
	Enddo

return

