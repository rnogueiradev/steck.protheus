#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STWF31	ºAutor  ³Cristiano Pereira  º Data ³  04/03/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Envio de Workflow na liberação do pedido de compra		  º±±
±±º          ³	    							 	 				      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³ nOpca,cNumPC                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRetorno   ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STWF31(aParams)

	//Local aParams

	prepare environment empresa aParams[1] filial aParams[2] Tables "SC7"

	U_STWF31A()

return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STWF31A	ºAutor  ³Cristiano Pereira  º Data ³  04/03/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Envio de Workflow na liberação do pedido de compra		  º±±
±±º          ³	    							 	 				      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³ nOpca,cNumPC                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRetorno   ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STWF31A()

	Local _aArea		:= GetArea()
	Local _cQuery		:= ""
	Local _cAlias 		:= "QRYTEMP"
	Local _cEmail   	:= "cristiano.pereira@sigamat.com.br"
	Local _cCopia   	:= ""
	Local _cAssunto 	:= 'Liberação Pedido de compra '
	Local cMsg	    	:= ""
	Local cAttach   	:= ''
	Local _aAttach  	:= {}
	Local _cCaminho 	:= ''
	Local cRot 			:= ' '
	Local aEma 			:= {}
	Local _cMal         := ' '
	Local _lAlterou	:= .F.
	Local _cWork  	:= GetMV("ST_MAILPED",," ")
	Local aRet := {}
	Local aParamBox := {}
	Local lContinua	:= .F.
	Local _nY:= 0
	Local _cQuery2  := ""
	Local _cAlias2  := GetNextAlias()
	Local _cChvC7   := ""

	If Select("TC7") > 0
		DbSelectArea("TC7")
		DbCloSeArea()
	Endif

	_cQuery		:= " SELECT SC7.C7_FILIAL  AS FIL,                 "
	_cQuery		+= "        SC7.C7_NUM     AS NUM,                 "
	_cQuery		+= "        SC7.C7_FORNECE AS FORNECE,             "
	_cQuery		+= "        SC7.C7_LOJA    AS LOJA,                "
	_cQuery		+= "        SC7.C7_USER    AS USERR                 "

	_cQuery		+= " FROM   "+RetSqlName("SC7")+"   SC7            "
	_cQuery		+= " WHERE SC7.C7_FILIAL ='"+xFilial("SC7")+"' AND "
	_cQuery		+= "       SC7.D_E_L_E_T_ <> '*'               AND "
	_cQuery		+= "       SC7.C7_XWF = ' '                    AND "
	_cQuery		+= "       SC7.C7_ENCER <> 'E'                 AND "
	_cQuery		+= "       SC7.C7_CONAPRO = 'L'                    "

	_cQuery		+= " GROUP BY  SC7.C7_FILIAL,SC7.C7_NUM,SC7.C7_FORNECE,SC7.C7_LOJA,SC7.C7_USER "

	_cQuery		+= " ORDER BY  SC7.C7_FILIAL,SC7.C7_NUM,SC7.C7_FORNECE,SC7.C7_LOJA "

	TCQUERY _cQuery	  NEW ALIAS "TC7"

	_nRec := 0
	DbEval({|| _nRec++  })

	DbSelectArea("TC7")
	DbGoTop()

	While !TC7->(EOF())

		aEma 			:= {}
		_cWork  	:= GetMV("ST_MAILPED",," ")
		_cChvC7   := ""

		Dbselectarea("SC7")
		SC7->(Dbsetorder(1))
		Dbselectarea("SA2")
		SA2->(Dbsetorder(1))
		SA2->(dbseek(xfilial("SA2")+TC7->FORNECE))
		If SC7->(dbseek(xfilial("SC7")+TC7->NUM))
			_cPed := _cWork
			aadd(aEma,{"Pedido",TC7->NUM})
			//aadd(aEma,{"Dt.Entrega",dtoc(SC7->C7_DATPRF)})
			aadd(aEma,{"Usuario",UsrRetName(SC7->C7_USER)})
			aadd(aEma,{"Data",dtoc(dDataBase)})
			aadd(aEma,{"Hora",substr(time(),1,5)})
			aadd(aEma,{"Fornecedor",cValtochar(SC7->C7_FORNECE)}) //- JEFF
			aadd(aEma,{"Razao Social",cValToChar(SA2->A2_NOME)}) // - JEFF
			aadd(aEma,{"Obs",cValToChar(SC7->C7_OBS)}) // - JEFF

			DbSelectArea("SC7")
			DbSetOrder(3)
			If DbSeek(xFilial("SC7")+SC7->C7_FORNECE+SC7->C7_LOJA+SC7->C7_NUM)
				_cChvC7  :=  SC7->C7_FILIAL+SC7->C7_FORNECE+SC7->C7_LOJA+SC7->C7_NUM
				While !SC7->(EOF()) .And.SC7->C7_FILIAL+SC7->C7_FORNECE+SC7->C7_LOJA+SC7->C7_NUM == _cChvC7
					If Reclock("SC7",.F.)
						SC7->C7_XWF :=  "S"
						MsUnlock()
					Endif
					DbSelectArea("SC7")
					DbSkip()
				Enddo
			Endif

			SC7->(dbseek(xfilial("SC7")+_cChvC7))

			If !(Empty(AllTrim(_cPed)))
				If Substr(cNumEmp,01,02) == "01"
					U_PCEMAIL("Liberação de pedido de compra "+" "+TC7->NUM+' filial '+cFilAnt+' empresa '+"STECK INDUSTRIA",aEma,_cPed)
				Else
					U_PCEMAIL("Liberação de pedido de compra "+" "+TC7->NUM+' filial '+cFilAnt+' empresa '+"STECK AMAZONIA",aEma,_cPed)
				Endif
			EndIf

		EndIf

		DbSelectArea("TC7")
		DbSkip()
	Enddo

	RestArea(_aArea)

Return
