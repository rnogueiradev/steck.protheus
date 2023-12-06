#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | STATUSZ7        | Autor | RENATO.OLIVEIRA           | Data | 13/08/2018  |
|=====================================================================================|
|Descrição | ATUALIZAR INFORMAÇÕES DO PEDIDO DE COMPRA                                |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STATUSZ7(_cFilial,_cPedido,_cFornece,_cLoja)

	Local _cQuery1  := ""
	Local _cAlias1  := GetNextAlias()
	Local _aAreaSC7 := SC7->(GetArea())
	Local _aAreaSC1	:= SC1->(GetArea())
	Local _aAreaSA2 := SA2->(GetAreA())
	Local _nPrazo	:= 0

	DbSelectArea("SA2")
	SA2->(DbSetOrder(1))
	SA2->(DbGoTop())
	If !SA2->(DbSeek(xFilial("SA2")+_cFornece+_cLoja))
		Return
	EndIf

	_cQuery1 := " SELECT *
	_cQuery1 += " FROM "+RetSqlName("SZP")+" ZP
	_cQuery1 += " WHERE ZP.D_E_L_E_T_=' ' AND '"+SA2->A2_CEP+"' BETWEEN ZP_CEPDE AND ZP_CEPATE

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	DbSelectArea("SC8")
	SC8->(DbSetOrder(3)) //C8_FILIAL+C8_NUM+C8_PRODUTO+C8_FORNECE+C8_LOJA+C8_NUMPED+C8_ITEMPED+C8_ITSCGRD

	SC7->(DbSetOrder(1))
	SC7->(DbSeek(_cFilial+_cPedido))

	While SC7->(!Eof()) .And. SC7->(C7_FILIAL+C7_NUM+C7_FORNECE+C7_LOJA)==_cFilial+_cPedido+_cFornece+_cLoja
		If SC8->(DbSeek(SC7->(C7_FILIAL+C7_NUMCOT+C7_PRODUTO+C7_FORNECE+C7_LOJA+C7_NUM+C7_ITEM)))
			
			If (_cAlias1)->(!Eof())
				_nPrazo := (_cAlias1)->ZP_VALOR
			Else
				_nPrazo := 0
			EndIf
			
			SC7->(RecLock("SC7",.F.))
			SC7->C7_XPRAFOR := DaySum(SC7->C7_EMISSAO,SC8->C8_PRAZO)
			SC7->C7_DATPRF 	:= DaySum(SC7->C7_EMISSAO,SC8->C8_PRAZO+_nPrazo)
			SC7->(MSUnLock())
			
			If Empty(SC8->C8_NUMPED)
				SC8->(RecLock("SC8",.F.))
				SC8->C8_NUMPED := SC7->C7_NUM
				SC8->C8_ITEMPED:= SC7->C7_ITEM
				SC8->(MsUnLock())
			EndIf
			
		EndIf
		SC7->(DbSkip())
	EndDo

	RestArea(_aAreaSA2)
	RestArea(_aAreaSC1)
	RestArea(_aAreaSC7)

Return()