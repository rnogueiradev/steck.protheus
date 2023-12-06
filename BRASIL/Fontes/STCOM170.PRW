#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | STCOM170        | Autor | RENATO.OLIVEIRA           | Data | 10/01/2019  |
|=====================================================================================|
|Descrição | Retorno de infos na grid da solicitacao de compras	                      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STCOM170(_cCampo,_cItem)

	Local _cQuery1  := ""
	Local _cAlias1  := "STCOM1701"
	Local nPosItem	:= aScan(aHeader,{|x| Trim(x[2])=="C1_ITEM"})

	Do Case 
		Case AllTrim(_cCampo)=="C1_XPED"

		_cQuery1 := " SELECT C7_NUM
		_cQuery1 += " FROM "+RetSqlName("SC7")+" C7
		_cQuery1 += " WHERE C7.D_E_L_E_T_=' ' AND C7_FILIAL='"+xFilial("SC1")+"'
		_cQuery1 += " AND C7_NUMSC='"+SC1->C1_NUM+"' AND C7_ITEMSC='"+_cItem+"'

		If !Empty(Select(_cAlias1))
			DbSelectArea(_cAlias1)
			(_cAlias1)->(dbCloseArea())
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

		dbSelectArea(_cAlias1)
		(_cAlias1)->(dbGoTop())

		xRet := ""

		If (_cAlias1)->(!Eof())
			xRet := (_cAlias1)->C7_NUM 
		EndIf

		Case AllTrim(_cCampo)=="C1_XDTENT"

		_cQuery1 := " SELECT C8_PRAZO
		_cQuery1 += " FROM "+RetSqlName("SC8")+" C8
		_cQuery1 += " WHERE C8.D_E_L_E_T_=' ' AND C8_FILIAL='"+xFilial("SC1")+"'
		_cQuery1 += " AND C8_NUMSC='"+SC1->C1_NUM+"' AND C8_ITEMSC='"+_cItem+"'

		If !Empty(Select(_cAlias1))
			DbSelectArea(_cAlias1)
			(_cAlias1)->(dbCloseArea())
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

		dbSelectArea(_cAlias1)
		(_cAlias1)->(dbGoTop())

		xRet := 0

		If (_cAlias1)->(!Eof())
			xRet := (_cAlias1)->C8_PRAZO 
		EndIf

	EndCase

Return(xRet)