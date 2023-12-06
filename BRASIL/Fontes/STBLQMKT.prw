#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �STBLQMKT	�Autor  �Renato Nogueira     � Data �  11/11/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Fonte utilizado para verificar se � pedido do mkt e fazer	  ���
���          �o bloqueio 							  				      ���
�������������������������������������������������������������������������͹��
���Parametro � 		                                                      ���
�������������������������������������������������������������������������ͼ��
���Retorno   �L�gico	                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function STBLQMKT()

	Local _aArea 		:= GetArea()
	Local _nOper        := aScan(aHeader, { |x| AllTrim(x[2]) == "C6_OPER"    })
	Local _nProd        := aScan(aHeader, { |x| AllTrim(x[2]) == "C6_PRODUTO"    })
	Local _lRet			:= .T.
	Local _cEmail   := ""
	Local _cCopia   := ""
	Local _cAssunto := 'Novo chamado ERP'
	Local cMsg	    := ""
	Local cAttach   := ''
	Local _aAttach  := {}
	Local _cCaminho := ''
	Local _cQuery1  := ""
	Local _cAlias1  := GetNextAlias()
	Local i
	Local _lPedMkt := .F.

	If ( Type("l410Auto") == "U" .OR. !l410Auto )  .and. !IsInCallSteck("U_STFAT15")

		If cEmpAnt == '01'//STECK SAO PAULO
			/*
			_cQuery1 := " SELECT COUNT(*) QTD
			_cQuery1 += " FROM "+RetSqlName("SRA")+" RA
			_cQuery1 += " WHERE RA.D_E_L_E_T_=' ' AND RA_XUSRCFG='"+__cUserId+"'
			_cQuery1 += " AND RA_DEPTO IN ("+GetMv("ST_DPTOMKT",,"'000000007','000000180','000000181'")+")

			If !Empty(Select(_cAlias1))
				DbSelectArea(_cAlias1)
				(_cAlias1)->(dbCloseArea())
			Endif

			dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

			dbSelectArea(_cAlias1)
			(_cAlias1)->(dbGoTop())

			If (_cAlias1)->(!Eof())
				If (_cAlias1)->QTD>0 //Usu�rio MKT
			*/

					For i:=1 To Len(aCols)
						If  SubStr(aCols[i,_nProd],1,3)=="MKT"
							_lPedMkt := .T.
							Exit
						EndIf
					Next i

					If _lPedMkt
						M->C5_XPEDMKT	:= "S"
						MsgInfo("Este pedido ficar� bloqueado por marketing, solicite a libera��o ao seu gerente!")

						_cEmail	  := GetMv("ST_MAILMKT")

						_cAssunto := 'O pedido do marketing - '+M->C5_NUM+' - encontra-se bloqueado no Protheus'
						cMsg := ""
						cMsg += '<html><head><title>'+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title></head><body>'
						cMsg += '<b>Pedido: </b>'+Alltrim(M->C5_NUM)+'<br><b>Filial: </b>'+cFilAnt+'</body></html>'

						U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)
						//	EndIf
					EndIf

					If AllTrim(aCols[1,_nOper])=="32" //Material de propaganda
						M->C5_XOPER32	:= "2"
						MsgInfo("Pedido de Venda de Ativo, Solicite a Libera��o da Controladoria!")
					EndIf

					If AllTrim(aCols[1,_nOper])=="70" //Nota fiscal de Comodato
						M->C5_XOPERCO	:= "2"
						MsgInfo("Pedido de Venda de Comodato, Solicite a Libera��o do Fiscal!")
					EndIf

				ElseIf cEmpAnt == '03'//STECK MANAUS

					If AllTrim(aCols[1,_nOper])=="04" //Nota fiscal de Comodato
						M->C5_XOPERCO	:= "2"
						MsgInfo("Pedido de Venda de Comodato, Solicite a Libera��o do Fiscal")
					EndIf

				Endif

			EndIf

			RestArea(_aArea)

			Return(_lRet)
