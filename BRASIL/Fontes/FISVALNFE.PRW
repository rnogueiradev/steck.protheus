#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | FISVALNFE        | Autor | RENATO.OLIVEIRA           | Data | 29/10/2019 |
|=====================================================================================|
|Descrição | PE para validar transmissão da nota		                              |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function FISVALNFE()

	Local _lRet 	:= .T.
	Local _cQuery1 	:= ""
	Local _cAlias1  := GetNextAlias()

	If PARAMIXB[1]=="S"

		_cQuery1 := " SELECT COUNT(*) QTD
		_cQuery1 += " FROM "+RetSqlName("SF2")+" F2
		_cQuery1 += " LEFT JOIN "+RetSqlName("SD2")+" D2
		_cQuery1 += " ON D2_FILIAL=F2_FILIAL AND D2_DOC=F2_DOC AND D2_SERIE=F2_SERIE AND D2_CLIENTE=F2_CLIENTE AND D2_LOJA=F2_LOJA
		_cQuery1 += " LEFT JOIN "+RetSqlName("SC5")+" C5
		_cQuery1 += " ON C5.C5_FILIAL=D2_FILIAL AND C5.C5_NUM=D2_PEDIDO
		_cQuery1 += " LEFT JOIN "+RetSqlName("SC5")+" XC5
		_cQuery1 += " ON XC5.C5_FILIAL=D2_FILIAL AND XC5.C5_XPEDTRI=D2_PEDIDO AND XC5.D_E_L_E_T_=' ' 
		_cQuery1 += " WHERE F2.D_E_L_E_T_=' ' AND D2.D_E_L_E_T_=' ' AND C5.D_E_L_E_T_=' ' AND XC5.C5_XPEDTRI<>' '
		_cQuery1 += " AND F2.F2_XTRIAN=' ' 
		_cQuery1 += " AND F2.F2_TRANSP='000163'
		_cQuery1 += " AND F2_FILIAL='"+PARAMIXB[2]+"' AND F2_DOC='"+PARAMIXB[4]+"'
		_cQuery1 += " AND F2_SERIE='"+PARAMIXB[5]+"' AND F2_CLIENTE='"+PARAMIXB[6]+"'
		_cQuery1 += " AND F2_LOJA='"+PARAMIXB[7]+"'

		If !Empty(Select(_cAlias1))
			DbSelectArea(_cAlias1)
			(_cAlias1)->(dbCloseArea())
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

		dbSelectArea(_cAlias1)

		(_cAlias1)->(dbGoTop())

		If (_cAlias1)->QTD>0
			MsgAlert("Etiqueta não impressa para nota "+PARAMIXB[4]+" triangular, verifique!")
			_lRet := .F.
		EndIf

	EndIf

Return(_lRet)