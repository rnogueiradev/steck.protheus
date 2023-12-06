#Include "Protheus.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ISI400MNU ºAutor  ³Renato Nogueira     º Data ³  01/09/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada para adicionar itens no menu do ISI400MNU  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck                                                      º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/ 

User Function ISI400MNU()

	Local aRotina := {}

	aAdd(aRotina,{"Preencher infos"	, "U_STPRESW1"   , 0 , 9, 0, .F.})
	aAdd(aRotina,{"Legendas"  		, "U_STLEGEND"   , 0 , 7, 0, .F.})	// Ticket 20210326004956 - Melhorias Sistemicas / Comex (EIC) - Passo 2
	aAdd(aRotina,{"1ª Aprovação"	, "U_ST1APROV"   , 0 , 7, 0, .F.})	// Ticket 20210326004956 - Melhorias Sistemicas / Comex (EIC) - Passo 2
	aAdd(aRotina,{"2ª Aprovação"	, "U_ST2APROV"   , 0 , 7, 0, .F.})	// Ticket 20210326004956 - Melhorias Sistemicas / Comex (EIC) - Passo 2

Return aRotina

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³STPRESW1  ºAutor  ³Renato Nogueira     º Data ³  01/09/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada para adicionar itens no menu do ISI400MNU  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck                                                      º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/ 

User Function STPRESW1()

	Local aArea   		:= GetArea()
	Local cQuery 		:= ""
	Private	_aRet 		:= {}
	Private	_aParamBox 	:= {}

	aAdd(_aParamBox,{1,"Fabricante"		,Space(6)  ,""				,"EXISTCPO('SA2')"	,"SA2"	,"",0	,.T.})
	aAdd(_aParamBox,{1,"Loja" 		 	,Space(2)  ,""				,  					,		,"",0	,.T.})
	aAdd(_aParamBox,{1,"Data embarque"	,dDatabase ,"99/99/9999"	,""					,""		,"",50	,.T.})
	If ParamBox(_aParamBox,"Informações",@_aRet,,,.T.,,500)
		If MsgYesNo("Deseja carregar as informações para a SI: " + SW0->W0__NUM + "?")
			cQuery := " UPDATE " + RetSqlName("SW1") + " W1 "
			cQuery += " SET W1.W1_FABR = '" + _aRet[1] + "', "
			cQuery += " W1.W1_FABLOJ = '" + _aRet[2] + "', "
			cQuery += " W1.W1_DT_EMB = '" + DtoS(_aRet[3]) + "' "
			cQuery += " WHERE W1.D_E_L_E_T_ = ' ' "
			cQuery += " 	AND W1_FILIAL = '" + SW0->W0_FILIAL + "' "
			cQuery += " 	AND W1_CC = '" + SW0->W0__CC + "' "
			cQuery += " 	AND W1_SI_NUM = '" + SW0->W0__NUM + "' AND W1_POSIT <> ' ' "
			nErrQry := TCSqlExec( cQuery )
			If nErrQry <> 0
				MsgAlert('Erro no UPDATE: ' + AllTrim(Str(nErrQry)),'ATENÇÃO')
			EndIf
			MsgAlert("Informações atualizadas com sucesso!")		
		EndIf
	EndIf

	RestArea(aArea)

Return

/*/Protheus.doc STLEGEND
(long_description) Criação das legendas da Alçada SI - EIC
type  Static Function
@author Eduardo Pereira - Sigamat
@since 26/03/2021
@version 12.1.25
/*/

User Function STLEGEND()

Local aLegenda := {}
     
    //Monta as legendas (Cor, Legenda)
    aAdd(aLegenda,{"BR_VERDE",        "Em Aberto"})
    aAdd(aLegenda,{"BR_AMARELO",      "Aprovado Parcialmente"})
    aAdd(aLegenda,{"BR_VERMELHO",     "Aprovado Totalmente"})
     
    //Chama a função que monta a tela de legenda
    BrwLegenda("Legendas", "Detalhamento das Cores", aLegenda)

Return

/*/Protheus.doc ST1APROV
(long_description) Tratamento da 1ª Aprovação da Alçada SI - EIC
type  Static Function
@author Eduardo Pereira - Sigamat
@since 20/04/2021
@version 12.1.25
/*/

User Function ST1APROV()

	Local cEmail	:= ""
	Local cCopia	:= ""
	Local cAssunto	:= ""
	Local cAprov	:= ""
	Local cQuery	:= ""

	// Filtro a SW1 conforme Numero da SI
	If Select("ST1APROV") > 0
		ST1APROV->( dbCloseArea() )
	EndIf
	cQuery := " SELECT * FROM " + RetSQLName("SW1")
	cQuery += " WHERE D_E_L_E_T_ = ' ' "
	cQuery += " 	AND W1_FILIAL = '" + xFilial("SW1") + "' "
	cQuery += " 	AND W1_SI_NUM = '" + SW0->W0__NUM + "' "
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),"ST1APROV")	

	SZI->( dbSetOrder(3) )	// ZI_FILIAL + ZI_CC + ZI_APROVP
	SZI->( dbGoTop() )
	If SZI->( dbSeek(xFilial("SZI") + ST1APROV->W1_CTCUSTO) )
		cAprov := SZI->ZI_APROVP
		If cAprov == __cUserID
			If Empty(SW0->W0_XAPROV1) .And. Empty(SW0->W0_XAPROV2)
				RecLock("SW0",.F.)
				SW0->W0_XAPROV1 := cAprov
				SW0->W0_XNOMAP1	:= UsrRetName(cAprov)
				MsUnLock()
				cAssunto := "Atencao - Aguardando a 2ª Aprovação da SI"
				cEmail	 := "carla.gomes@steck.com.br"
				cCopia	 := Alltrim(SW0->W0_SOLIC) + "@steck.com.br"
				u_STWF400(SW0->W0__NUM, cAssunto, cEmail, cCopia)
			Else
				If !Empty(SW0->W0_XAPROV1)
					MsgAlert("Atenção - SI já realizada a 1ª aprovação. - Função: ST1APROV")
				Else
					MsgAlert("Atenção - SI com a 2º aprovação realizada sem a 1ª aprovação." + Chr(13) + Chr(10) +;
							 "Favor verifique - Função: ST1APROV")
				EndIf
			EndIf
		Else
			MsgAlert("Atenção - Aprovador diferente do Centro de Custo" + Chr(13) + Chr(10) +;
					 "Não será permitida a aprovação. - Função: ST1APROV")
		EndIf
	EndIf

Return

/*/Protheus.doc ST2APROV
(long_description) Tratamento da 2ª Aprovação da Alçada SI - EIC
type  Static Function
@author Eduardo Pereira - Sigamat
@since 20/04/2021
@version 12.1.25
/*/

User Function ST2APROV()

	Local cEmail	:= ""
	Local cCopia	:= ""
	Local cAssunto	:= ""

	If !Empty(SW0->W0_XAPROV1) .And. Empty(SW0->W0_XAPROV2)
		If "001389" == __cUserID
			RecLock("SW0",.F.)
			SW0->W0_XAPROV2 := "001389"
			SW0->W0_XNOMAP2	:= "carla.gomes"
			MsUnLock()
			cAssunto := "Atencao - SI Totalmente Aprovada"
			cEmail	 := Alltrim(SW0->W0_SOLIC) + "@steck.com.br"
			u_STWF400(SW0->W0__NUM, cAssunto, cEmail, cCopia)
		Else
			MsgAlert("Atenção - Aprovador diferente do Centro de Custo" + Chr(13) + Chr(10) +;
					 "Não será permitida a aprovação. - Função: ST2APROV")
		EndIf
	EndIf

Return
