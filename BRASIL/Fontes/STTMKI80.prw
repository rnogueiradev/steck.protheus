#INCLUDE "PROTHEUS.CH"
#define CLR Chr(13)+Chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STTMKI80  ºAutor  ³Joao Victor         º Data ³  06/02/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada para atualizar o pedido de venda gerado    º±±
±±º          ³orcamento do televendas chamado pelo programa STFSVE40      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Gap 25 - Não permitir que no Televendas, um orçamento após º±±
±±ºser convertido em Pedido de Venda, que o atendimento NÃO possa ser     º±±
±±ºalterado nessa rotina.                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STTMKI80(nOrcamento)
	Local _lRet := .T.
	Local _LFun := IsInCallSteck("TMKA273") .Or. IsInCallSteck("TMKA380") .or. IsInCallSteck("U_STFSVE46")
	Local _lVen := GetMv("ST_TMKI80",,.T.)
	Local _cQuery1 := ""
	Local _cAlias1 := GetNextAlias()

	If !_LFun
		If  !INCLUI  .And. SUA->UA_OPER <> "1"
			DbSelectArea('SUB')
			SUB->(DbSetOrder(1)) //C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
			If SUB->(DbSeek(xFilial("SUB")+SUA->UA_NUM))
				While SUB->(!Eof()) .and. SUB->UB_FILIAL+SUB->UB_NUM == xFilial("SUB")+SUA->UA_NUM

					SUB->(RecLock("SUB",.F.))
					SUB->UB_ZB2QATU  :=  u_versaldo(SUB->UB_PRODUTO)
					//SUB->UB_DTENTRE  :=  u_atudtentre(SUB->UB_ZB2QATU,SUB->UB_PRODUTO,SUB->UB_QUANT)
					SUB->(MsUnlock())
					SUB->( DbCommit() )
					SUB->(DbSkip())
				End
			Endif


		Endif
		If  nOrcamento == 4 .and. SUA->UA_OPER == "1"  //.and. _cJoao = "2"
			MsgInfo("Não é Possível Realizar Alterações em Orçamentos que Foram Convertidos em Pedido de Venda!";
				+CLR+CLR+"Favor Alterar o Pedido de Venda "+(SUA->UA_NUMSC5)+" no Módulo Faturamento.","Alteração não Permitida")
			_lRet := .F.
		Endif

		If  nOrcamento == 4 //20200806005303

			_cQuery1 := " SELECT C5_NUM
			_cQuery1 += " FROM "+RetSqlName("SC5")+" C5
			_cQuery1 += " WHERE C5.D_E_L_E_T_=' ' AND C5_FILIAL='"+SUA->UA_FILIAL+"'
			_cQuery1 += " AND C5_ZORCAME='"+SUA->UA_NUM+"'

			If !Empty(Select(_cAlias1))
				DbSelectArea(_cAlias1)
				(_cAlias1)->(dbCloseArea())
			Endif

			dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

			dbSelectArea(_cAlias1)
			(_cAlias1)->(dbGoTop())

			If (_cAlias1)->(!Eof())
				MsgInfo("Não é Possível Realizar Alterações em Orçamentos que Foram Convertidos em Pedido de Venda!";
					+CLR+CLR+"Favor Alterar o Pedido de Venda "+(_cAlias1)->C5_NUM+" no Módulo Faturamento.","Alteração não Permitida")
				_lRet := .F.
			EndIf

		EndIf

		//Giovani Zago 06/05/14  bloquear vendedor externo de alterar cotação digitada pelo interno
		If _lRet  .And. _lVen   .And. nOrcamento = 4
			If !AllTrim(SUA->UA_XORIG)=="1"
				DbSelectArea('SA3')
				SA3->(DbSetOrder(7))
				If SA3->(dbSeek(xFilial('SA3')+__cUserId))
					If Alltrim(SA3->A3_COD) $ 'R00268/R00269/R00152/R00192/R00196/R00261/R00262/R01910/R01911'

						If Alltrim(SA3->A3_COD) $ 'R00268/R00269'
							If !(Alltrim(SUA->UA_VEND2)  $ 'R00268/R00269' .Or. Empty(Alltrim(SUA->UA_VEND2)))
								_lRet := .F.
								MsgInfo("Favor entrar em contato com o vendedor: "+Posicione("SA3",1,xFilial("SA3") + SUA->UA_VEND2 ,"A3_NOME") )
							EndIf
						ElseIf Alltrim(SA3->A3_COD) $ 'R00152/R00192/R00196'
							If !(Alltrim(SUA->UA_VEND2)  $ 'R00152/R00192/R00196' .Or. Empty(Alltrim(SUA->UA_VEND2)))
								_lRet := .F.
								MsgInfo("Favor entrar em contato com o vendedor: "+Posicione("SA3",1,xFilial("SA3") + SUA->UA_VEND2 ,"A3_NOME") )
							EndIf
						ElseIf Alltrim(SA3->A3_COD) $ 'R00261/R00262'
							If !(Alltrim(SUA->UA_VEND2)  $ 'R00261/R00262' .Or. Empty(Alltrim(SUA->UA_VEND2)))
								_lRet := .F.
								MsgInfo("Favor entrar em contato com o vendedor: "+Posicione("SA3",1,xFilial("SA3") + SUA->UA_VEND2 ,"A3_NOME") )
							EndIf
						ElseIf Alltrim(SA3->A3_COD) $ 'R01910/R01911'
							If !(Alltrim(SUA->UA_VEND2)  $ 'R01910/R01911' .Or. Empty(Alltrim(SUA->UA_VEND2)))
								_lRet := .F.
								MsgInfo("Favor entrar em contato com o vendedor: "+Posicione("SA3",1,xFilial("SA3") + SUA->UA_VEND2 ,"A3_NOME") )
							EndIf


						EndIf


					Else
						If SA3->A3_TPVEND <> 'I'
							If !(SUA->UA_VEND2 = SA3->A3_COD .Or. Empty(Alltrim(SUA->UA_VEND2))) .And. substr(SA3->A3_COD,1,1) <> 'E' //GIOVANI ZAGO LIBERAR EXTERNO PARA ACESSAR
								_lRet := .F.
								MsgInfo("Favor entrar em contato com o vendedor: "+Posicione("SA3",1,xFilial("SA3") + SUA->UA_VEND2 ,"A3_NOME") )
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf

	Endif


Return (_lRet)

