#include 'Protheus.ch'
#include 'RwMake.ch'

/*====================================================================================\
|Programa  | M521DNFS         | Autor | GIOVANI.ZAGO             | Data | 16/04/2013  |
|=====================================================================================|
|Descrição | M521DNFS                                                                 |
|          |  Reavalia o pedido de venda C5_ZFATBLQ                                   |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | M521DNFS                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function M521DNFS()
*-----------------------------*
	Local _aArea     := GetArea()

	//Chamado 002701 Abre
	Local cAliasLif  := 'STSC9AM'
	Local cQuery     := ' '
	Local _cOper     := SuperGetMV("ST_OPEREMB",.F.,"15")

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf
 
	cQuery := ' SELECT DISTINCT SD2.D2_PEDIDO , SD2.D2_ORDSEP, SC6.C6_OPER '
	cQuery += " FROM "+RetSqlName("SD2")+" SD2 "
	cQuery += " INNER JOIN "+RetSqlName("SC6")+" SC6 "
	cQuery += " ON SC6.D_E_L_E_T_ = ' '
	cQuery += " AND D2_PEDIDO = C6_NUM
	cQuery += " AND D2_FILIAL = C6_FILIAL
	cQuery += " WHERE SD2.D2_DOC    = '"+SF2->F2_DOC+"'"
	cQuery += " AND SD2.D2_SERIE    = '"+SF2->F2_SERIE+"'"
	cQuery += " AND SD2.D_E_L_E_T_  = '*'
	cQuery += " AND SD2.D2_FILIAL   = '"+xFilial("SD2")+"'"
	
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAliasLif, .T., .T.)
	DbSelectArea(cAliasLif)
	(cAliasLif)->(DbGoTop())
	If ((cAliasLif)->C6_OPER) = _cOper
		U_STSC9AM()
	Else
		U_TabeSt()
	EndIf
	//Chamado 002701 Fecha

	RestArea(_aArea)
	
Return .t.