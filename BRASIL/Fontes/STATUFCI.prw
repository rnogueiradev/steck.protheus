#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

Static __lOpened := .F.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTATUFCI	บAutor  ณRenato Nogueira     บ Data ณ  11/09/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo utilizado para atualizar os c๓digos FCI nos pedidos  บฑฑ
ฑฑบ          ณde venda							    				      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametro ณ Nenhum                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบRetorno   ณ Nenhum                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function STATUFCI()

	Processa( {|| U_STATUFCE()},"Aguarde...","Processando rotina...",.T.)

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTATUFCE	บAutor  ณRenato Nogueira     บ Data ณ  11/09/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo utilizado para atualizar os c๓digos FCI nos pedidos  บฑฑ
ฑฑบ          ณde venda							    				      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametro ณ Nenhum                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบRetorno   ณ Nenhum                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function STATUFCE()

	Local aArea     := GetArea()
	Local cQuery 	:= ""
	Local cAlias 	:= "QRYTEMP"
	Local nCountPed	:= 0
	Local nCountOrc	:= 0
	Local aNeg		:={}

	_cLog:= "RELATำRIO DE PEDIDOS ALTERADOS "+CHR(13) +CHR(10)

	cQuery	:= " SELECT C6.R_E_C_N_O_ REGISTRO, C6_PRODUTO, C6_FCICOD, "
	cQuery	+= " (SELECT CFD_FCICOD FROM "+RetSqlName("CFD")+" FD1 WHERE FD1.D_E_L_E_T_=' ' AND C6.C6_PRODUTO=FD1.CFD_COD AND FD1.R_E_C_N_O_= "
	cQuery  += " (SELECT MAX(R_E_C_N_O_) FROM "+RetSqlName("CFD")+" FD2 WHERE FD2.D_E_L_E_T_=' ' AND C6.C6_PRODUTO=FD2.CFD_COD)) AS CODFCINEW "
	cQuery  += " FROM "+RetSqlName("SC6")+" C6 "
	cQuery  += " LEFT JOIN "+RetSqlName("SC5")+" C5 "
	cQuery  += " ON C5_FILIAL=C6_FILIAL AND C5_NUM=C6_NUM AND C5_CLIENTE=C6_CLI AND C5_LOJACLI=C6_LOJA "
	cQuery  += " WHERE C6.D_E_L_E_T_=' ' AND C5.D_E_L_E_T_=' ' AND C6_FCICOD<>(SELECT CFD_FCICOD FROM "+RetSqlName("CFD")+" FD1 WHERE FD1.D_E_L_E_T_=' ' AND C6.C6_PRODUTO=FD1.CFD_COD AND FD1.R_E_C_N_O_= "
	cQuery  += " (SELECT MAX(R_E_C_N_O_) FROM "+RetSqlName("CFD")+" FD2 WHERE FD2.D_E_L_E_T_=' ' AND C6.C6_PRODUTO=FD2.CFD_COD)) AND C6_QTDVEN>C6_QTDENT AND C6_BLQ=' ' "

	If !Empty(Select(cAlias))
		DbSelectArea(cAlias)
		(cAlias)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())

	While (cAlias)->(!Eof())

		DbSelectArea("SC6")
		SC6->(DbGoTop())
		SC6->(DbGoTo((cAlias)->REGISTRO))

		If SC6->(!Eof())

			SC6->(RecLock("SC6",.F.))
			SC6->C6_FCICOD	:= (cAlias)->CODFCINEW
			SC6->(MsUnLock())

			nCountPed	+= 1
			_ClOG	+= SC6->C6_NUM+CHR(13)+CHR(10)

		EndIf

		(cAlias)->(DbSkip())
	EndDo

	cQuery	:= " SELECT UB.R_E_C_N_O_ REGISTRO, UB_PRODUTO, UB_FCICOD, "
	cQuery	+= " (SELECT CFD_FCICOD FROM "+RetSqlName("CFD")+" FD1 WHERE FD1.D_E_L_E_T_=' ' AND UB.UB_PRODUTO=FD1.CFD_COD AND FD1.R_E_C_N_O_= "
	cQuery  += " (SELECT MAX(R_E_C_N_O_) FROM "+RetSqlName("CFD")+" FD2 WHERE FD2.D_E_L_E_T_=' ' AND UB.UB_PRODUTO=FD2.CFD_COD)) AS CODFCINEW "
	cQuery  += " FROM "+RetSqlName("SUB")+" UB "
	cQuery  += " WHERE UB.D_E_L_E_T_=' ' AND UB_FCICOD<>(SELECT CFD_FCICOD FROM "+RetSqlName("CFD")+" FD1 WHERE FD1.D_E_L_E_T_=' ' AND UB.UB_PRODUTO=FD1.CFD_COD AND FD1.R_E_C_N_O_= "
	cQuery  += " (SELECT MAX(R_E_C_N_O_) FROM "+RetSqlName("CFD")+" FD2 WHERE FD2.D_E_L_E_T_=' ' AND UB.UB_PRODUTO=FD2.CFD_COD)) "

	If !Empty(Select(cAlias))
		DbSelectArea(cAlias)
		(cAlias)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())

	While (cAlias)->(!Eof())

		DbSelectArea("SUB")
		SUB->(DbGoTop())
		SUB->(DbGoTo((cAlias)->REGISTRO))

		If SUB->(!Eof())

			SUB->(RecLock("SUB",.F.))
			SUB->UB_FCICOD	:= (cAlias)->CODFCINEW
			SUB->(MsUnLock())

			nCountOrc	+= 1

		EndIf

		(cAlias)->(DbSkip())
	EndDo

	MsgInfo("Foram atualizadas "+CVALTOCHAR(nCountPed)+" linhas de pedidos e "+CVALTOCHAR(nCountOrc)+" linhas de or็amentos")

	@ 000, 000 TO 230, 350 DIALOG oDlg TITLE 'Relatorio de pedidos '
	@ 005,005 Get _clOG Size 167,080 MEMO Object oMemo
	@ 92,135 BMPBUTTON TYPE 1 ACTION Close(oDlg)
	ACTIVATE DIALOG oDlg CENTERED

	RestArea(aArea)

Return()