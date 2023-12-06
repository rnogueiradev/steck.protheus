#INCLUDE "PROTHEUS.CH"
#DEFINE CR    chr(13)+chr(10)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMA450MNU  บAutor  ณJefferson Carlos    บ Data ณ  13/02/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPonto de entrada para adicionar rotina no menu de libera็ใo บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MA450MNU()

	aAdd(aRotina,{"Total de pedidos"  , "U_STTOTSC9"   , 0 , 9, 0, .F.})
	aAdd(aRotina,{"Rel. analise cliente"  , "U_STRFIN01"   , 0 , 9, 0, .F.})

	//aAdd(aRotina,{"Manual STECK"  , "U_xSTMa450ClMan"   , 0 , 9, 0, .F.})
Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  STRFIN01  บAutor  ณRenato Nogueira    บ Data ณ  18/05/23   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function STRFIN01()

	Local aCabec := {}
	Local aDados := {}
	Local _cQuery1 := ""
	Local _cAlias1 := GetNextAlias()

	aCabec := {"Codigo","Loja","Nome","Cond. Pag","Numero","Valor"}

	_cQuery1 := " SELECT A1_COD, A1_LOJA, A1_NOME, C5_ZCONDPG, C5_NUM, ROUND(SUM(( C6_ZVALLIQ / C6_QTDVEN ) * C9_QTDLIB),2) VLRLIQ
	_cQuery1 += " FROM "+RetSqlName("SC9")+" C9
	_cQuery1 += " LEFT JOIN "+RetSqlName("SC6")+" C6
	_cQuery1 += " ON C6_FILIAL=C9_FILIAL AND C6_NUM=C9_PEDIDO AND C6_ITEM=C9_ITEM
	_cQuery1 += " LEFT JOIN "+RetSqlName("SC5")+" C5
	_cQuery1 += " ON C5_FILIAL=C6_FILIAL AND C5_NUM=C6_NUM
	_cQuery1 += " LEFT JOIN "+RetSqlName("SA1")+" A1
	_cQuery1 += " ON A1_COD=C5_CLIENTE AND A1_LOJA=C5_LOJACLI
	_cQuery1 += " WHERE C9.D_E_L_E_T_=' ' AND C6.D_E_L_E_T_=' ' AND C5.D_E_L_E_T_=' ' AND A1.D_E_L_E_T_=' '
	_cQuery1 += " AND C9_BLCRED IN ('01','04','05') AND C9_FILIAL='"+xFilial("SC6")+"'
	_cQuery1 += " GROUP BY A1_COD, A1_LOJA, A1_NOME, C5_ZCONDPG, C5_NUM

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	While (_cAlias1)->(!Eof())
		AAdd(aDados, {(_cAlias1)->A1_COD,(_cAlias1)->A1_LOJA,(_cAlias1)->A1_NOME,(_cAlias1)->C5_ZCONDPG,(_cAlias1)->C5_NUM,StrTran(cValToChar((_cAlias1)->VLRLIQ),".",",")})
		(_cAlias1)->(DbSkip())
	EndDo

	(_cAlias1)->(DbCloseArea())

	DlgToExcel({ {"ARRAY", "PEDIDO", aCabec, aDados} })

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMA450MNU  บAutor  ณJefferson Carlos    บ Data ณ  13/02/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPonto de entrada para adicionar rotina no menu de libera็ใo บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function STTOTSC9()

	Local _aArea	:= GetArea()
	Local _cQuery	:= ""
	Local _cAlias	:= "QRYTEMP"
	Local _cMsg     := ' '

	_cQuery :=	" SELECT  ROUND(SUM(C9_QTDLIB*C9_PRCVEN),2) TOTAL  FROM "+RetSqlName("SC5")+" SC5
	_cQuery += "   INNER JOIN ( SELECT * FROM "+RetSqlName("SC6")+") SC6
	_cQuery += "   ON SC6.D_E_L_E_T_ = ' '
	_cQuery += "   AND SC6.C6_NUM = SC5.C5_NUM
	_cQuery += "   AND SC6.C6_FILIAL = SC5.C5_FILIAL
	_cQuery += " AND SC6.C6_BLQ <> 'R'
	_cQuery += "   INNER JOIN ( SELECT * FROM "+RetSqlName("SC9")+" )SC9
	_cQuery += "   ON SC9.D_E_L_E_T_ = ' '
	_cQuery += "   AND SC6.C6_NUM = SC9.C9_PEDIDO
	_cQuery += "   AND SC6.C6_ITEM = SC9.C9_ITEM
	_cQuery += "   AND SC9.C9_BLCRED IN ('01','02','04','05','06')
	_cQuery += "   AND SC6.C6_FILIAL = SC9.C9_FILIAL
	_cQuery += "   INNER JOIN( SELECT * FROM "+RetSqlName("SA1")+" )SA1
	_cQuery += "   ON SA1.A1_COD = SC5.C5_CLIENTE
	_cQuery += "   AND SA1.D_E_L_E_T_ = ' '
	_cQuery += "   AND SA1.A1_LOJA = SC5.C5_LOJACLI
	_cQuery += "   AND SA1.A1_FILIAL =  ' '
	_cQuery += "   WHERE  SC5.D_E_L_E_T_   = ' '
	_cQuery += "   AND SC5.C5_FILIAL   = '"+xFilial("SC5")+"'
	_cQuery += "   AND SC5.C5_NOTA NOT LIKE '%XXX%'  AND SC5.C5_ZBLOQ <> '1'

	If !Empty(Select(_cAlias))
		DbSelectArea(_cAlias)
		(_cAlias)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.T.,.T.)

	dbSelectArea(_cAlias)
	(_cAlias)->(dbGoTop())

	If (_cAlias)->(!Eof())

		//MsgInfo("O total de pedidos bloqueados ้ de R$: "+ transform(((_cAlias)->TOTAL)	,"@E 99,999,999,999.99") )
		_cMsg     := "O total de pedidos bloqueados ้ de R$: "+ transform(((_cAlias)->TOTAL)	,"@E 99,999,999,999.99")
	EndIf

	_cQuery :=	" SELECT  ROUND(SUM(C9_QTDLIB*C9_PRCVEN),2) TOTAL  FROM "+RetSqlName("SC5")+" SC5
	_cQuery += "   INNER JOIN ( SELECT * FROM "+RetSqlName("SC6")+" )SC6
	_cQuery += "   ON SC6.D_E_L_E_T_ = ' '
	_cQuery += "   AND SC6.C6_NUM = SC5.C5_NUM
	_cQuery += "   AND SC6.C6_FILIAL = SC5.C5_FILIAL
	_cQuery += " AND SC6.C6_BLQ <> 'R'
	_cQuery += "   INNER JOIN ( SELECT * FROM "+RetSqlName("SC9")+" )SC9
	_cQuery += "   ON SC9.D_E_L_E_T_ = ' '
	_cQuery += "   AND SC6.C6_NUM = SC9.C9_PEDIDO
	_cQuery += "   AND SC6.C6_ITEM = SC9.C9_ITEM
	_cQuery += "   AND SC9.C9_BLCRED   = '09'
	_cQuery += "   AND SC6.C6_FILIAL = SC9.C9_FILIAL
	_cQuery += "   INNER JOIN( SELECT * FROM "+RetSqlName("SA1")+" )SA1
	_cQuery += "   ON SA1.A1_COD = SC5.C5_CLIENTE
	_cQuery += "   AND SA1.D_E_L_E_T_ = ' '
	_cQuery += "   AND SA1.A1_LOJA = SC5.C5_LOJACLI
	_cQuery += "   AND SA1.A1_FILIAL =  ' '
	_cQuery += "   WHERE  SC5.D_E_L_E_T_   = ' '
	_cQuery += "   AND SC5.C5_FILIAL   = '"+xFilial("SC5")+"'
	_cQuery += "   AND SC5.C5_NOTA NOT LIKE '%XXX%'

	If !Empty(Select(_cAlias))
		DbSelectArea(_cAlias)
		(_cAlias)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.T.,.T.)

	dbSelectArea(_cAlias)
	(_cAlias)->(dbGoTop())

	If (_cAlias)->(!Eof())

		//MsgInfo("O total de pedidos bloqueados ้ de R$: "+ transform(((_cAlias)->TOTAL)	,"@E 99,999,999,999.99") )
		_cMsg     += CR+CR+"O total de pedidos Rejeitados ้ de R$: "+ transform(((_cAlias)->TOTAL)	,"@E 99,999,999,999.99")
	EndIf

	MsgInfo(_cMsg )

	RestArea(_aArea)

Return()
