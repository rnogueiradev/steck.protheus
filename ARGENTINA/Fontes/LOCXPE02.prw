#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"

/*====================================================================================\
|Programa  | LOCXPE02        | Autor | RENATO.OLIVEIRA           | Data | 06/12/2018  |
|=====================================================================================|
|Descrição | PE para bloquear o cancelamento de remitos                               |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function LOCXPE02()

	Local _lRet 	:= .T.
	Local _cQuery1 	:= ""
	Local _cAlias1 	:= GetNextAlias()

	If IsInCallStack("MATA462N")

		/*
		_cQuery1 := " SELECT CB8_QTDORI, CB8_SALDOE
		_cQuery1 += " FROM "+RetSqlName("SF2")+" F2
		_cQuery1 += " LEFT JOIN "+RetSqlName("SD2")+" D2
		_cQuery1 += " ON D2_FILIAL=F2_FILIAL AND D2_DOC=F2_DOC AND D2_SERIE=F2_SERIE AND D2_CLIENTE=F2_CLIENTE AND D2_LOJA=F2_LOJA
		_cQuery1 += " LEFT JOIN "+RetSqlName("CB7")+" CB7
		_cQuery1 += " ON CB7_FILIAL=D2_FILIAL AND CB7_PEDIDO=D2_PEDIDO
		_cQuery1 += " LEFT JOIN "+RetSqlName("CB8")+" CB8
		_cQuery1 += " ON CB8_FILIAL=CB7_FILIAL AND CB8_ORDSEP=CB7_ORDSEP AND CB8_PROD = D2_COD
		_cQuery1 += " WHERE F2.D_E_L_E_T_=' ' AND D2.D_E_L_E_T_=' ' AND CB7.D_E_L_E_T_=' ' AND CB8.D_E_L_E_T_=' '
		_cQuery1 += " AND F2_FILIAL='"+SF2->F2_FILIAL+"' AND F2_SERIE='"+SF2->F2_SERIE+"'
		_cQuery1 += " AND F2_DOC='"+SF2->F2_DOC+"' AND CB8_QTDORI>CB8_SALDOE
		_cQuery1 += " AND F2_SERIE='R'

		If !Empty(Select(_cAlias1))
			DbSelectArea(_cAlias1)
			(_cAlias1)->(dbCloseArea())
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

		dbSelectArea(_cAlias1)
		(_cAlias1)->(dbGoTop())

		//If (_cAlias1)->(!Eof())
		*/
		If SF2->F2_XSTATUS <> "0"
			If lDeleta
				MsgAlert("Este remito no podrá ser cancelado pues ya se ha iniciado el proceso de embalaje.")
				_lRet := .F.
			EndIf
		EndIf

	ElseIf IsInCallStack("MATA465N")

	//Nota de credito

	EndIf

Return(_lRet)