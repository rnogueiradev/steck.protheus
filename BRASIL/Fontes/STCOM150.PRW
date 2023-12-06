#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | STCOM150        | Autor | RENATO.OLIVEIRA           | Data | 10/01/2019  |
|=====================================================================================|
|Descrição | Limpar residuo da SC			 					                      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STCOM150()

	Local _aAreaSC1 := SC1->(GetArea())
	Local _cFilSC	:= SC1->C1_FILIAL
	Local _cNumSC	:= SC1->C1_NUM
	Local _cQuery1  := ""
	Local _cAlias1  := GetNextAlias()
	Local _lProc	:= .F.

	If !(__cUserId $ AllTrim(GetMv("STCOM1501",,"000000")))
		MsgAlert("Rotina não disponível para o seu usuário, verifique!")
		Return
	EndIf

	If !SubStr(SC1->C1_COTACAO,1,1)=="X"
		MsgAlert("Cotação não está eliminada por resíduo, verifique!")
		Return
	EndIf

	SC1->(DbSetOrder(1))
	SC1->(DbSeek(_cFilSC+_cNumSC))

	While SC1->(!Eof()) .And. SC1->(C1_FILIAL+C1_NUM)==_cFilSC+_cNumSC

		_cQuery1 := " SELECT COUNT(*) CONTADOR
		_cQuery1 += " FROM "+RetSqlName("SC7")+" C7
		_cQuery1 += " WHERE C7.D_E_L_E_T_=' ' AND C7_FILIAL='"+SC1->C1_FILIAL+"'
		_cQuery1 += " AND C7_NUMSC='"+SC1->C1_NUM+"' AND C7_ITEMSC='"+SC1->C1_ITEM+"'

		If !Empty(Select(_cAlias1))
			DbSelectArea(_cAlias1)
			(_cAlias1)->(dbCloseArea())
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

		dbSelectArea(_cAlias1)
		(_cAlias1)->(dbGoTop())

		If (_cAlias1)->CONTADOR==0

			SC1->(RecLock("SC1",.F.))
			SC1->C1_COTACAO := ""
			SC1->C1_RESIDUO := ""
			SC1->C1_QUJE 	:= 0
			SC1->(MsUnLock())

			_lProc := .T.

		Else

			MsgAlert("Existe pedido em aberto para o item "+SC1->C1_ITEM+" desta cotação, verifique!")

		EndIf

		SC1->(DbSkip())
	EndDo

	If _lProc
		MsgAlert("Processamento finalizado!")
	EndIf

	RestArea(_aAreaSC1)

Return()