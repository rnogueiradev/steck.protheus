#INCLUDE  "rwmake.ch"
#INCLUDE  "TOPCONN.CH"
#INCLUDE  "tbiconn.ch"

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ COLWF001    ³ Autor ³ Cristiano Pereira    ³ Data ³ 27/06/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ envío de impuestos                                          ³±±
±±³          ³                                                              ³±±
±±³          ³                                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User function COLWF001()


	//aParams := {"01","01"}

	//prepare environment empresa aParams[1] filial aParams[2] Tables "SD2"
	RpcSetEnv("09","01",,,"FAT")

	U_COLWF01A()

	RpcClearEnv()

Return


/*/
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Funcao    ³ COLWF01A  ³ Autor ³ Cristiano Pereira     ³ Data ³ 27/06/03 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descricao ³                                                              ³±±
	±±³          ³                                                              ³±±
	±±³          ³                                                              ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function COLWF01A()

	Private oP, oHtml, _cQryF2
	Private _cCli := ""
	Private _cMail :=""


	// Verifica se arquivo aberto
	If Select("TF2") > 0
		dbSelectArea("TF2")
		dbCloseArea()
	Endif


	_cQryF2 := " SELECT SF2.F2_FILIAL  F2_FILIAL,                                    "
	_cQryF2 += "        SF2.F2_EMISSAO  F2_EMISSAO,                                  "
	_cQryF2 += "        SF2.F2_DOC      F2_DOC   ,                                   "
	_cQryF2 += "        SF2.F2_VALMERC  AS F2_VALMERC,                               "
	_cQryF2 += "        SF2.F2_VALIMP1 F2_VALIMP1 ,                                  "
	_cQryF2 += "        SF2.F2_VALIMP4  F2_VALIMP4 ,                                 "
	_cQryF2 += "        SF2.F2_VALIMP3  F2_VALIMP3 ,                                 "
	_cQryF2 += "        SF2.F2_VALIMP2  F2_VALIMP2 ,                                 "
	_cQryF2 += "        SF2.F2_VALIMP7  F2_VALIMP7 ,                                 "
	_cQryF2 += "        SF2.F2_CLIENTE  F2_CLIENTE,                                  "
	_cQryF2 += "        SF2.F2_LOJA     F2_LOJA,                                     "
	_cQryF2 += "        SF2.F2_TIPO     F2_TIPO                                      "



	_cQryF2 += " FROM "+RetSqlName("SF2")+" SF2                                        "
	_cQryF2 += " WHERE SF2.F2_FILIAL = '"+xFilial("SF2")+"'                        AND "

	If Month(msdate())==3
		_cQryF2 += " SF2.F2_EMISSAO   >='"+SubStr(Dtos(msdate()),1,4)+'0101'+"' and SF2.F2_EMISSAO   <='"+SubStr(Dtos(msdate()),1,4)+'0229'+"'   AND "
	ElseIf Month(msdate())==5
		_cQryF2 += " SF2.F2_EMISSAO   >='"+SubStr(Dtos(msdate()),1,4)+'0301'+"' and SF2.F2_EMISSAO   <='"+SubStr(Dtos(msdate()),1,4)+'0430'+"'   AND "
	ElseIf Month(msdate())==7
		_cQryF2 += " SF2.F2_EMISSAO   >='"+SubStr(Dtos(msdate()),1,4)+'0501'+"' and SF2.F2_EMISSAO   <='"+SubStr(Dtos(msdate()),1,4)+'0630'+"'   AND "
	ElseIf Month(msdate())==9
		_cQryF2 += " SF2.F2_EMISSAO   >='"+SubStr(Dtos(msdate()),1,4)+'0701'+"' and SF2.F2_EMISSAO   <='"+SubStr(Dtos(msdate()),1,4)+'0831'+"'   AND "
	ElseIf Month(msdate())==11
		_cQryF2 += " SF2.F2_EMISSAO   >='"+SubStr(Dtos(msdate()),1,4)+'0901'+"' and SF2.F2_EMISSAO   <='"+SubStr(Dtos(msdate()),1,4)+'1031'+"'   AND "
	ElseIf Month(msdate())==1
		_cQryF2 += " SF2.F2_EMISSAO   >='"+SubStr(Dtos(msdate()-20),1,4)+'1101'+"' and SF2.F2_EMISSAO   <='"+SubStr(Dtos(msdate()-20),1,4)+'1231'+"'   AND "
	Endif
	//_cQryF2 += " SF2.F2_CLIENTE ='8300877217'   AND                                "
	_cQryF2 += " SF2.D_E_L_E_T_ = ' '                                                  "

	_cQryF2 += " AND (  SF2.F2_VALIMP3 > 0 OR SF2.F2_VALIMP2 > 0 )  "

	_cQryF2 += "  UNION ALL                                                            "

	_cQryF2 += " SELECT SF1.F1_FILIAL  F2_FILIAL,                                    "
	_cQryF2 += "        SF1.F1_DTDIGIT  F2_EMISSAO,                                  "
	_cQryF2 += "        SF1.F1_DOC      F2_DOC   ,                                   "
	_cQryF2 += "        SF1.F1_VALMERC  F2_VALMERC,                               "
	_cQryF2 += "        SF1.F1_VALIMP1  F2_VALIMP1 ,                                 "
	_cQryF2 += "        SF1.F1_VALIMP4  F2_VALIMP4 ,                                 "
	_cQryF2 += "        SF1.F1_VALIMP3 F2_VALIMP3 ,                                 "
	_cQryF2 += "        SF1.F1_VALIMP2  F1_VALIMP2 ,                                 "
	_cQryF2 += "        SF1.F1_VALIMP7  F1_VALIMP7 ,                                 "
	_cQryF2 += "        SF1.F1_FORNECE  F2_CLIENTE,                                     "
	_cQryF2 += "        SF1.F1_LOJA     F2_LOJA ,                                        "
	_cQryF2 += "        SF1.F1_TIPO     F2_TIPO                                         "


	_cQryF2 += " FROM "+RetSqlName("SF1")+" SF1                                        "

	_cQryF2 += " WHERE SF1.F1_FILIAL = '"+xFilial("SF1")+"'                            AND "

	If Month(msdate())==3
		_cQryF2 += " SF1.F1_DTDIGIT   >='"+SubStr(Dtos(msdate()),1,4)+'0101'+"' and SF1.F1_DTDIGIT   <='"+SubStr(Dtos(msdate()),1,4)+'0229'+"'   AND "
	ElseIf Month(msdate())==5
		_cQryF2 += " SF1.F1_DTDIGIT  >='"+SubStr(Dtos(msdate()),1,4)+'0301'+"' and SF1.F1_DTDIGIT   <='"+SubStr(Dtos(msdate()),1,4)+'0430'+"'    AND "
	ElseIf Month(msdate())==7
		_cQryF2 += " SF1.F1_DTDIGIT   >='"+SubStr(Dtos(msdate()),1,4)+'0501'+"' and SF1.F1_DTDIGIT   <='"+SubStr(Dtos(msdate()),1,4)+'0630'+"'   AND "
	ElseIf Month(msdate())==9
		_cQryF2 += " SF1.F1_DTDIGIT   >='"+SubStr(Dtos(msdate()),1,4)+'0701'+"' and SF1.F1_DTDIGIT   <='"+SubStr(Dtos(msdate()),1,4)+'0831'+"'   AND "
	ElseIf Month(msdate())==11
		_cQryF2 += " SF1.F1_DTDIGIT   >='"+SubStr(Dtos(msdate()),1,4)+'0901'+"' and SF1.F1_DTDIGIT   <='"+SubStr(Dtos(msdate()),1,4)+'1031'+"'   AND "
	ElseIf Month(msdate())==1
		_cQryF2 += " SF1.F1_DTDIGIT   >='"+SubStr(Dtos(msdate()-20),1,4)+'1101'+"' and SF1.F1_DTDIGIT  <='"+SubStr(Dtos(msdate()-20),1,4)+'1231'+"'   AND "
	Endif
	_cQryF2 += " SF1.D_E_L_E_T_ = ' '   AND SF1.F1_ESPECIE='NCC'                        "
	//_cQryF2 += " AND (  SF1.F1_VALIMP1 > 0 OR SF1.F1_VALIMP4 > 0 OR SF1.F1_VALIMP3 > 0 )  "
	_cQryF2 += " AND (   SF1.F1_VALIMP3> 0 OR   SF1.F1_VALIMP2> 0 )  "
	//_cQryF2 += " AND  SF1.F1_FORNECE ='8300877217'                                                             "

	_cQryF2 += " ORDER BY F2_CLIENTE   "                               "

	TCQUERY  _cQryF2 NEW ALIAS "TF2"


	_nRec := 0
	DbEval({|| _nRec++  })

	_nRec1 := _nRec

	DbSelectArea("TF2")
	DbGoTop()



	While !TF2->(Eof())

		_cCli:= TF2->F2_CLIENTE
		_nItens := 0
		_cMail := ""


		// Inicializa a classe TWFProcess
		oP := TWFProcess():New( "ENVIO", " URGENTE SOLICITUD CERTIFICADOS DE IMPUESTOS STECK ANDINA SAS " )

         oP:cPriority := "3"
		// Cria-se uma nova tarefa para o processo.
		//oP:NewTask( "100400", "C:\wf\COLWF001.htm")
		oP:NewTask( "100400", "\WORKFLOW\COLWF001.htm" )

		// Faz uso do objeto ohtml que pertence ao processo
		oHtml := oP:oHtml



		// Assinala os valores no html
		oHtml:ValByName("Fecha" , MsDate()  )



		DbSelectArea("SA1")
		DbSetOrder(1)
		If DbSeek(xFilial("SA1")+TF2->F2_CLIENTE+TF2->F2_LOJA)

            _cMail :=SA1->A1_EMFIN 

			oHtml:valbyname("nombre", SA1->A1_NREDUZ )
			//oHtml:ValByName("T1.20" , SA1->A1_NREDUZ )
			oHtml:ValByName("nit" , "901.318.588" )

		else

			oHtml:ValByName("nombre" , "" )
			oHtml:ValByName("nit" , "901.318.588" )

		Endif

		If Month(msdate())==3
			oHtml:ValByName("bimestre" , "1° bimestre" )
			oHtml:ValByName("ano" , Rtrim(Str(Year(msdate()))))
		ElseIf Month(msdate())==5
			oHtml:ValByName("bimestre" , "2° bimestre" )
			oHtml:ValByName("ano" , Rtrim(Str(Year(msdate()))))
		ElseIf Month(msdate())==7
			oHtml:ValByName("bimestre" , "3° bimestre" )
			oHtml:ValByName("ano" , Rtrim(Str(Year(msdate()))))
		ElseIf Month(msdate())==9
			oHtml:ValByName("bimestre" , "4° bimestre" )
			oHtml:ValByName("ano" , Rtrim(Str(Year(msdate()))))
		ElseIf Month(msdate())==11
			oHtml:ValByName("bimestre" , "5° bimestre" )
			oHtml:ValByName("ano" , Rtrim(Str(Year(msdate()))))
		ElseIf Month(msdate())==1
			oHtml:ValByName("bimestre" , "6° bimestre" )
			oHtml:ValByName("ano" , Rtrim(Str(Year(msdate())-1)))
		Endif



		While _cCli== TF2->F2_CLIENTE


			DbSelectArea("SA1")
			DbSetOrder(1)
			If DbSeek(xFilial("SA1")+TF2->F2_CLIENTE+TF2->F2_LOJA)

				AAdd(oHtml:valbyname("t1.1")   , Dtoc(stod(TF2->F2_EMISSAO)))
				AAdd(oHtml:valbyname("t1.2")   , SA1->A1_NREDUZ)
				AAdd(oHtml:valbyname("t1.3")   , TF2->F2_DOC)
				AAdd(oHtml:valbyname("t1.0")   , TF2->F2_TIPO)
				AAdd(oHtml:valbyname("t1.4")   , Transform(TF2->F2_VALMERC,"@E 9999,999,999.99"))
				AAdd(oHtml:valbyname("t1.5")   , Transform(TF2->F2_VALIMP1,"@E 9999,999,999.99"))
				AAdd(oHtml:valbyname("t1.6")   , Transform(TF2->F2_VALIMP4,"@E 9999,999,999.99"))
				AAdd(oHtml:valbyname("t1.7")   , Transform(TF2->F2_VALIMP3,"@E 9999,999,999.99"))
				AAdd(oHtml:valbyname("t1.8")   ,Transform(TF2->F2_VALIMP2,"@E 9999,999,999.99"))
				AAdd(oHtml:valbyname("t1.9")   , Transform(TF2->F2_VALMERC+TF2->F2_VALIMP1-TF2->F2_VALIMP4-TF2->F2_VALIMP3,"@E 9999,999,999.99") )

				_nItens++
			else

				DbSelectArea("SA2")
				DbSetOrder(1)
				If DbSeek(xFilial("SA2")+TF2->F2_CLIENTE+TF2->F2_LOJA)


					AAdd(oHtml:valbyname("t1.1")   , Dtoc(stod(TF2->F2_EMISSAO)))
					AAdd(oHtml:valbyname("t1.2")   , SA2->A2_NREDUZ)
					AAdd(oHtml:valbyname("t1.3")   , TF2->F2_DOC)
					AAdd(oHtml:valbyname("t1.0")   , "NCC")
					AAdd(oHtml:valbyname("t1.4")   , Transform(TF2->F2_VALMERC,"@E 9999,999,999.99"))
					AAdd(oHtml:valbyname("t1.5")   , Transform(TF2->F2_VALIMP1,"@E 9999,999,999.99"))
					AAdd(oHtml:valbyname("t1.6")   , Transform(TF2->F2_VALIMP4,"@E 9999,999,999.99"))
					AAdd(oHtml:valbyname("t1.7")   , Transform(TF2->F2_VALIMP3,"@E 9999,999,999.99"))
					AAdd(oHtml:valbyname("t1.8")   ,Transform(TF2->F2_VALIMP2,"@E 9999,999,999.99"))
					AAdd(oHtml:valbyname("t1.9")   , Transform(TF2->F2_VALMERC+TF2->F2_VALIMP1-TF2->F2_VALIMP4-TF2->F2_VALIMP3,"@E 9999,999,999.99") )

					_nItens++

				Endif

			Endif

			dbSelectArea("TF2")
			DbSkip()
		EndDo


		If _nItens > 0

			// Informando o destinatário
			//oP:cTo := "cristiano.pereira@sigamat.com.br,andrea.castro@steckgroup.com,jaqueline.silva@steck.com.br,kamila.jesus@non-steck.com.br"
			oP:cTo :=  Rtrim(_cMail)
            //oP:cTo := "cristiano.pereira@sigamat.com.br,andrea.castro@steckgroup.com"
   

			// O Assundo da mensagem
			oP:cSubject := " URGENTE SOLICITUD CERTIFICADOS DE IMPUESTOS STECK ANDINA SAS "

			// Gerando os arquivos de controle deste processo e enviando a mensagem
			oP:Start()

			// Finaliza o processo.
			oP:Finish()
		Endif
	EndDo



	dbSelectArea("TF2")
	dbCloseArea()


Return
