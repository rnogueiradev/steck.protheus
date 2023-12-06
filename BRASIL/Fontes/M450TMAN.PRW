#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | M450TMAN        | Autor | RENATO.OLIVEIRA           | Data | 24/06/2020  |
|=====================================================================================|
|Descrição | 													                      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function M450TMAN()

 	Local aArea 	:= GetArea()
    Local _cQuery1 	:= "" 
    Local _cAlias1 	:= GetNextAlias()
    Local lRet      := .T.
    
    _cQuery1 := " SELECT DISTINCT C5_FILIAL, C5_NUM, C5_CONDPAG, C5_XLIBAVI
	_cQuery1 += " FROM "+RetSqlName("SC5")+" C5
	_cQuery1 += " LEFT JOIN "+RetSqlName("SC9")+" C9
	_cQuery1 += " ON C9_FILIAL=C5_FILIAL AND C9_PEDIDO=C5_NUM 
	_cQuery1 += " WHERE C5.D_E_L_E_T_=' ' AND C9.D_E_L_E_T_=' ' 
	_cQuery1 += " AND C5_CLIENTE='"+SA1->A1_COD+"' AND C5_LOJACLI='"+SA1->A1_LOJA+"' AND C5_ZBLOQ='2' AND C9_BLCRED<>' ' AND C9_NFISCAL=' '
	
	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)

	(_cAlias1)->(dbGoTop())
	
	While (_cAlias1)->(!Eof())

    	If AllTrim((_cAlias1)->C5_CONDPAG)=="501" .And. !AllTrim((_cAlias1)->C5_XLIBAVI)=="S"
    		If !MsgYesNo("Atenção, pedido "+(_cAlias1)->C5_NUM+" a vista sem liberação comercial, deseja continuar?")
    			lRet := .F.
    		EndIf
    	EndIf
	
		(_cAlias1)->(DbSkip()) 
    EndDo

    RestArea(aArea)
    
Return(lRet)