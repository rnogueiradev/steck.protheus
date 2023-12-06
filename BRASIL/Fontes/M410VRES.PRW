#include "RWMAKE.CH"
#include "PROTHEUS.CH"
#INCLUDE "AP5MAIL.CH"
#Include "TOPCONN.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  M410VRES   º Autor ³ Giovani Zago        º Data ³  09/04/13  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ limpa qtd. emp.                                             º±±
±±º  Tipo    ³ Ponto de Entrada                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ STECK                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function M410VRES()

	Local aSC6Area		:= SC6->(GetArea())
	Local aArea			:= GetArea()
	Local aSC5Area		:= SC5->(GetArea())
	Local lContinua 	:= .T.
	Local _cUserx   	:= GetMv('ST_ELIUSER',,'000000')+'000000/000645'
	Local _cUserEx  	:= GetMv('ST_ELIUSEX',,'000000/000301/000077/000651')+'000000/000645'
	Local cGetMot		:=  space(70)
	Local cGetMDe       :=  space(110)
	Local lSaida		:= .F.
	Local _cAltPed02 	:= SuperGetMV("ST_GRPPLAN",.F.,"000000")
	Local _aGrupos    	:= {}
	Local _aMotRej   	:= {}
	Local _cTabRej   	:= 'Z7'
	Local _cQry 		:= ""
	Local _cQry1 		:= ""
	Local _cQry2	 	:= ""
	DEFAULT aVetItens := PARAMIXB

	If !IsBlind()
		If !Empty(Alltrim(SC5->C5_PEDEXP))

			If  !(__cuserid $ _cUserEx)
				lContinua:= .F.
				MsgInfo('Usuario sem Acesso!!!!!!')
			Endif
		Else
			//Chamado 003023 abre
			PswOrder(1)
			If PswSeek(__cUserId,.T.)
				_aGrupos  := PswRet()
			Endif
			If  (__cuserid $ _cUserx)
				lContinua:= .T.
			ElseIf (_aGrupos[1][10][1]) $ _cAltPed02 .And. (SC5->C5_CLIENTE = '033467')
				lContinua:= .T.
				//Chamado 003023 fecha
			ElseIf Posicione("SA3",7,xFilial("SA3")+__cUserId,"A3_TIPO")=="I" //Ticket 20191010000033
				lContinua:= .T.
			ElseIf SC5->C5_FILIAL $ "04#05"
				lContinua := .T.
			Else
				lContinua:= .F.
				MsgInfo('Usuario sem Acesso!!!!!!')
			Endif

		Endif
	EndIf

	If SC5->C5_ZFATBLQ = '1' .And. lContinua
		lContinua:=.F.
		msgiNFO("Pedido de Venda Faturado Totalmente....!!!!!!"+Chr(13)+Chr(10)+Chr(13)+Chr(10)+;
			"O mesmo não poderá ser utilizado para Eliminação de Resíduo....!!!!!!")
	Endif

	If ('XXXX' $ SC5->C5_NOTA).And.(SC5->C5_ZFATBLQ $ '1/2') .And. lContinua
		lContinua:=.F.
		msgiNFO("Pedido de Venda Eliminado por Resíduo (Saldo)....!!!!!!"+Chr(13)+Chr(10)+Chr(13)+Chr(10)+;
			"O mesmo não poderá ser utilizado para Eliminação de Resíduo....!!!!!!")
	Endif

	If ('XXXX' $ SC5->C5_NOTA).And. (SC5->C5_ZFATBLQ = '3' .Or. Empty(Alltrim(SC5->C5_ZFATBLQ))) .And. lContinua
		lContinua:=.F.
		msgiNFO("Pedido de Venda Cancelado....!!!!!!"+Chr(13)+Chr(10)+Chr(13)+Chr(10)+;
			"O mesmo não poderá ser utilizado para Eliminação de Resíduo....!!!!!!")
	Endif

	If lContinua
		/***************************************************************************************************************************************
		<<Alteração>>
		Ação......: Verifica se a chamada é feita atraés de um POST
		..........: Se for um POST passa somente o registro para a SC6
		Analista..: Marcelo Klopfer Leme - SIGAMAT
		Data......: 07/12/2022
		Chamado...:  20221205021467- Oferta Logística - Eliminação de Resíduo
		***************************************************************************************************************************************/
		IF IsInCallStack("POST")
			SC6->(DBSETORDER(1))
			SC6->(DBGOTO(aVetItens[1]))
			SC9->(DBSETORDER(1))
			IF SC9->(dbSeek(xFilial("SC9")+SC6->C6_NUM+SC6->C6_ITEM))
				WHILE SC9->(!EOF() .AND. SC9->C9_FILIAL+SC9->C9_PEDIDO+SC9->C9_ITEM == XFILIAL("SC6")+SC6->C6_NUM+SC6->C6_ITEM)
					IF !EMPTY(SC9->C9_ORDSEP) .AND. EMPTY(SC9->C9_NFISCAL)
							lContinua:=.F.
					ENDIF
					SC9->(DBSKIP())
				ENDDO
			ENDIF
		ELSE
			DbSelectArea('SC6')
			SC6->(DbSetOrder(1)) //C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
			If SC6->(DbSeek(xFilial("SC6")+SC5->C5_NUM))
				While SC6->(!Eof()) .and. SC6->C6_FILIAL+SC6->C6_NUM == xFilial("SC6")+SC5->C5_NUM
					dbSelectArea("SC9")
					SC9->(	dbSetOrder(1) )
					If	SC9->(dbSeek(xFilial("SC9")+SC6->C6_NUM+SC6->C6_ITEM))
						While SC9->(! Eof() .and. C9_FILIAL+C9_PEDIDO+C9_ITEM == xFilial("SC6")+SC6->(C6_NUM+C6_ITEM))
							If !Empty (SC9->C9_ORDSEP) .And. Empty(SC9->C9_NFISCAL)
								lContinua:=.F.
							EndIf
							SC9->(DbSkip())
						End
					EndIf
					SC6->(DbSkip())
				End
			Endif
		ENDIF

		If !lContinua
			Msginfo("Pedido de Venda em Separação pela Expedição....!!!!!!"+Chr(13)+Chr(10)+Chr(13)+Chr(10)+;
				"O mesmo não poderá ser utilizado para Eliminação de Resíduo....!!!!!!"+Chr(13)+Chr(10)+Chr(13)+Chr(10)+;
				"Não será possível utilizar a rotina de Eliminação de Resíduo até a emissão da Nota Fiscal....!!!!!!")
		EndIf

	Endif

	If lContinua

		Begin Transaction

			/***************************************************************************************************************************************
			<<Alteração>>
			Ação......: Verifica se a chamada é feita atraés de um POST
			..........: Se for um POST passa somente o registro para a SC6
			Analista..: Marcelo Klopfer Leme - SIGAMAT
			Data......: 07/12/2022
			Chamado...:  20221205021467- Oferta Logística - Eliminação de Resíduo
			***************************************************************************************************************************************/
			IF IsInCallStack("POST")
				SC6->(DBSETORDER(1))
				SC6->(DBGOTO(aVetItens[1]))

				//Chamado 001591 - Gravar data da eliminação de resíduo
				SC6->(RecLock("SC6",.F.))
				SC6->C6_QTDEMP 	 := 0
				SC6->C6_XDTRES   := Date()
				SC6->C6_XUSRRES  := __cUserId
				SC6->(MsUnlock())
				SC6->(DbCommit())

				PA1->(DbSetOrder(3))
				IF PA1->(DbSeek(xFilial('PA1')+SC6->C6_NUM+SC6->C6_ITEM))
					PA1->(RecLock('PA1',.F.))
					PA1->PA1_OBS:="ELIMINAÇÃO DE RESIDUO "+cUserName+' - '+__cuserId+' - '+dTOc(date())  +' - '+TIME()
					PA1->(DbDelete())
					PA1->(MsUnlock())
				ENDIF

				PA2->(DbSetOrder(3))
				IF PA2->(DbSeek(xFilial('PA2')+SC6->C6_NUM+SC6->C6_ITEM))
					PA2->(RecLock('PA2',.F.))
					PA2->PA2_OBS:="ELIMINAÇÃO DE RESIDUO "+cUserName+' - '+__cuserId+' - '+dTOc(date())  +' - '+TIME()
					PA2->(DbDelete())
					PA2->(MsUnlock())
				ENDIF

                //Elimina a Z96 SE HOUVER
                U_STDELZ96(SC6->C6_FILIAL,SC6->C6_NUM,SC6->C6_ITEM,.F.)

			ELSE
				dbSelectArea("SC6")
				SC6->(	dbSetOrder(1))
				SC6->(	dbSeek(xFilial("SC6")+SC5->C5_NUM))
				Do While ( SC6->(!Eof()) .And. SC6->C6_FILIAL == xFilial("SC6") .And. SC6->C6_NUM 	== SC5->C5_NUM )

					//Chamado 001591 - Gravar data da eliminação de resíduo
					SC6->(RecLock("SC6",.F.))
					SC6->C6_QTDEMP 	 := 0
					SC6->C6_XDTRES   := Date()
					SC6->C6_XUSRRES  := __cUserId
					SC6->(MsUnlock())
					SC6->(DbCommit())
					dbSelectArea("PA1")
					PA1->(DbSetOrder(3))
					If PA1->(DbSeek(xFilial('PA1')+SC6->C6_NUM+SC6->C6_ITEM))
						PA1->(RecLock('PA1',.F.))
						PA1->PA1_OBS:="ELIMINAÇÃO DE RESIDUO "+cUserName+' - '+__cuserId+' - '+dTOc(date())  +' - '+TIME()
						PA1->(DbDelete())
						PA1->(MsUnlock())
					EndIf
					dbSelectArea("PA2")
					PA2->(DbSetOrder(3))
					If PA2->(DbSeek(xFilial('PA2')+SC6->C6_NUM+SC6->C6_ITEM))
						PA2->(RecLock('PA2',.F.))
						PA2->PA2_OBS:="ELIMINAÇÃO DE RESIDUO "+cUserName+' - '+__cuserId+' - '+dTOc(date())  +' - '+TIME()
						PA2->(DbDelete())
						PA2->(MsUnlock())
					EndIf
					
					//Elimina a Z96 SE HOUVER
					U_STDELZ96(SC6->C6_FILIAL,SC6->C6_NUM,SC6->C6_ITEM,.F.)
					
					SC6->(dbSkip())
				EndDo
			ENDIF
		End Transaction

	Endif

	//13/08/2014 - Limpar bloqueio após eliminacao de residuo
	If lContinua
		SC5->(RecLock("SC5",.F.))
		SC5->C5_ZBLOQ	:= "2"
		SC5->C5_ZMOTBLO	:= ""
		MSMM(SC5->C5_XALTCAB,,,"Eliminado Residuo "+cUsername+" - "+dtoc(date())+' - '+time(),1,,,"SC5","C5_XALTCAB",,.T.)
		SC5->(MsUnLock())

		U_STZZI01()

		DbSelectArea("SC9")
		SC9->(DbGoTop())
		SC9->(DbSetOrder(1))
		If SC9->(DbSeek(xFilial("SC9")+SC5->C5_NUM))
			While SC9->(!EOF() .and. C9_FILIAL+C9_PEDIDO  == xFilial("SC9")+SC5->C5_NUM )
				If    Empty( Alltrim(SC9->C9_NFISCAL) )
					SC9->(RecLock("SC9",.F.))
					SC9->C9_XOBSFIN:=  "Eliminação de residuo  - " + CUSERNAME +' - '+ __cuserId + ' - ' + dTOc(date())  +' - '+TIME()
					SC9->(DbDelete())
					SC9->(MsUnlock())
				EndIf
				SC9->(Dbskip())
			End
		EndIf
	EndIf

	If lContinua //001591

		If !IsInCallStack("U_STELIMRES") .AND. !IsInCallStack("POST") .and. !IsInCallStack("U_STFAT703") .and. !IsInCallStack("U_STFAT704")
			aAdd(_aMotRej,' ') // CHAMADO 003971 - ROBSON MAZZAROTTO
			DbSelectArea("SX5")
			SX5->(dbSetOrder(1))
			SX5->(dbSeek(xFilial("SX5") + _cTabRej))
			Do While SX5->(!EOF()).and. xFilial("SX5") = SX5->X5_FILIAL .And. SX5->X5_TABELA  = _cTabRej
				AADD(_aMotRej,ALLTRIM(SX5->X5_CHAVE)+' - '+ALLTRIM(SX5->X5_DESCRI))
				SX5->(DbSkip())
			EndDo
			If Len(_aMotRej) > 1

				While !lSaida

					Define msDialog oDlg Title "Motivo da rejeição" From 10,10 TO 20,65 Style DS_MODALFRAME

					@ 000,001 Say "Motivo: " Pixel Of oDlg
					@ 010,003 COMBOBOX cGetMot ITEMS _aMotRej SIZE 165,08 Of oDlg Pixel

					@ 025,001 Say "Descrição do motivo: " Pixel Of oDlg
					@ 035,003 MsGet cGetMDe valid !empty(cGetMDe) size 200,10 Picture "@!" pixel OF oDlg

					DEFINE SBUTTON FROM 50,20 TYPE 1 ACTION IF(!empty(cGetMot),(nOpcao:=1,lSaida:=.T.,oDlg:End()),msgInfo("Parametro em Branco","Atenção")) ENABLE OF oDlg

					Activate dialog oDlg centered

				End
			Else
				ApMsgInfo("Não existem Motivos de Rejeição cadastrados"+ Chr(10) + Chr(13) +;
					CHR(10)+CHR(13)+;
					"Os Itens analisados não serão rejeitados.",;
					"Rejeição")
				Return
			Endif

		EndIf

		If IsInCallStack("U_STELIMRES") .OR. IsInCallStack("POST") 
			cGetMot	:= "ELIMINADO PELA ROTINA AUTOMÁTICA"
			nOpcao	:= 1
		EndIf

        IF IsInCallStack("U_STFAT703") .OR. IsInCallStack("U_STFAT704")
			nOpcao	:= 1
        ENDIF			

		If nOpcao = 1

			/***************************************************************************************************************************************
			<<Alteração>>
			Ação......: Verifica se a chamada é feita atraés de um POST
			..........: Se for um POST passa somente o registro para a SC6
			Analista..: Marcelo Klopfer Leme - SIGAMAT
			Data......: 07/12/2022
			Chamado...:  20221205021467- Oferta Logística - Eliminação de Resíduo
			***************************************************************************************************************************************/
			IF IsInCallStack("POST")
				SC6->(DBSETORDER(1))
				SC6->(DBGOTO(aVetItens[1]))
				SDC->(DBSETORDER(1))
				IF SDC->(DBSEEK(XFILIAL("SDC")+SC6->C6_PRODUTO+SC6->C6_LOCAL+"SC6"+SC6->C6_NUM+SC6->C6_ITEM))
					Begin Transaction
						WHILE SDC->(!EOF()) .AND. SDC->CD_PRODUTO+SDC->CD_LOCAL+"SC6"+SDC->DC_PEDIDO+SDC->DC_ITEM = SC6->C6_PRODUTO+SC6->C6_LOCAL+"SC6"+SC6->C6_NUM+SC6->C6_ITEM

							SBF->(DBSETORDER(1))
							IF SBF->(DBSEEK(XFILIAL("SBF")+SDC->DC_LOCAL+SDC->DC_LOCALIZ+SDC->DC_PRODUTO))
								WHILE SBF->(!EOF()) .AND. SBF->BF_FILIAL+SBF->BF_LOCAL+SBF->BF_LOCALIZ+SBF->BF_PRODUTO = SDC->DC_FILIAL+SDC->DC_LOCAL+SDC->DC_LOCALIZ+SDC->DC_PRODUTO
									SBF->(RECLOCK("SBF",.F.))
									SBF->BF_EMPENHO := SBF->BF_EMPENHO - SDC->DC_QUANT
									SBF->(MSUNLOCK())
									SBF->(DBSKIP())
								ENDDO
							ENDIF

							SDC->(DBSKIP())
						ENDDO
					End Transaction
				ENDIF
			ELSE

				Begin Transaction 
					cGetMot	:= Alltrim(cGetMot)
					SC5->(RecLock("SC5",.F.))
					SC5->C5_XMOTRES	:= cGetMot + "--" + cGetMDe
					SC5->(MsUnLock())

					//>> Ticket 20201030009781 - Everson Santana - 04.11.2020

					If Select("TRD") > 0
						TRD->(DbCloseArea())
					Endif

					_cQry := " "
					_cQry += " SELECT * FROM "+RetSqlName("SDC")
					_cQry += " WHERE DC_ORIGEM = 'SC6' "
					_cQry += " AND DC_FILIAL = '"+xFilial("SDC")+"' "
					_cQry += " AND DC_PEDIDO = '"+SC5->C5_NUM+"' "
					_cQry += " AND D_E_L_E_T_ = ' ' "

					TcQuery _cQry New Alias "TRD"

					SDC->(DBSETORDER(1))
					TRD->(dbGoTop())
					While TRD->(!EOF())

						IF SDC->(DBSEEK(XFILIAL("SDC")+TRD->DC_PRODUTO+TRD->DC_LOCAL+"SC6"+TRD->DC_PEDIDO+TRD->DC_ITEM))
							reclock("SDC", .F.)
								SDC->( dbdelete() )
							SDC->( msunlock() )

							SBF->(DBSETORDER(1))
							IF SBF->(DBSEEK(XFILIAL("SBF")+SDC->DC_LOCAL+SDC->DC_LOCALIZ+SDC->DC_PRODUTO))
								SBF->(RECLOCK("SBF",.F.))
									SBF->BF_EMPENHO := SBF->BF_EMPENHO - SDC->DC_QUANT
								SBF->(MSUNLOCK())
							ENDIF
						ENDIF

						/*_cQry1 := " "
						_cQry1 += " UPDATE "+RetSqlName("SBF")+" SET BF_EMPENHO = BF_EMPENHO - '"+Str(TRD->DC_QUANT)+"'
						_cQry1 += " WHERE BF_PRODUTO = '"+TRD->DC_PRODUTO+"'  "
						_cQry1 += " AND BF_LOCAL = '"+TRD->DC_LOCAL+"' "
						_cQry1 += " AND BF_LOCALIZ = '"+TRD->DC_LOCALIZ+"' "
						_cQry1 += " AND BF_FILIAL = '"+xFilial("SBF")+"'"
						_cQry1 += " AND D_E_L_E_T_ = ' ' "

						Tcsqlexec(_cQry1)

						_cQry2 := " "
						_cQry2 += " UPDATE "+RetSqlName("SDC")+" SET D_E_L_E_T_ = '*' "
						_cQry2 += " WHERE DC_ORIGEM = 'SC6' "
						_cQry2 += " AND DC_FILIAL = '"+xFilial("SDC")+"' "
						_cQry2 += " AND DC_PEDIDO = '"+SC5->C5_NUM+"' "
						_cQry2 += " AND DC_PRODUTO = '"+TRD->DC_PRODUTO+"'
						_cQry2 += " AND D_E_L_E_T_ = ' ' "

						Tcsqlexec(_cQry2)*/

						TRD->(dbSkip())

					End
				End Transaction
			ENDIF
		EndIf
	EndIf

	If lContinua
		U_STMAILPV(3,,)//Chamado 002881
		U_STMAILPV(4,,)//Chamado 002881
	Endif
	STATULEG() //Chamado 001017

	dbcommitall()
	RestArea(aSC5Area)
	RestArea(aSC6Area)
	RestArea(aArea)
Return (lContinua)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STATULEG	ºAutor  ³Renato Nogueira     º Data ³  29/09/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Fonte utilizado para atualizar a legenda do pedido após a   º±±
±±º          ³eliminacao de residuo				  	 				      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRetorno   ³ Nenhum 										              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function STATULEG()

	Local cQuery   		:= ""
	Local cAlias   		:= "QRYTEMP"

	cQuery := " SELECT COUNT(*) CONTADOR "
	cQuery += " FROM "+RetSqlName("SC6")+" C6 "
	cQuery += " WHERE C6.D_E_L_E_T_=' ' AND C6_QTDENT>0 AND C6_NUM='"+SC5->C5_NUM+"' AND C6_FILIAL='"+SC5->C5_FILIAL+"' "

	If !Empty(Select(cAlias))
		DbSelectArea(cAlias)
		(cAlias)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())

	If (cAlias)->CONTADOR>0 //Faturado parcial
		SC5->(RecLock("SC5",.F.))
		SC5->C5_ZFATBLQ	:= "2"
		SC5->(MsUnLock())
	EndIf

Return()
