#INCLUDE "PROTHEUS.ch"

User Function FC010LIST()

	Local aCols 		:= paramixb
	Local cCliente	:= SA1->A1_COD
	Local cLoja		:= SA1->A1_LOJA
	Local cLc			:= SA1->A1_LC
	Local cDtSera	:= SA1->A1_XDTSERA
	Local cDtCad		:= SA1->A1_XDTCAD
	Local cAlias

	aArea := SE1->(GetArea())

	cAlias	 := "QRYSE1"

	cQuery	:=		" SELECT COUNT(E1_NUM) QTD FROM "+RetSqlName("SE1")+" "
	cQuery	+=	" WHERE E1_VENCREA<'"+DTOS(DDATABASE)+"' AND E1_CLIENTE= '"+cCliente+"' AND E1_LOJA= '"+cLoja+"' AND E1_SALDO > 0 AND E1_BAIXA = '' AND E1_TIPO='NF' "
	cQuery	+=	" AND "+RetSqlName("SE1")+".D_E_L_E_T_= ' ' "

	cQuery	:= ChangeQuery(cQuery)

	If !Empty(Select(cAlias))
		DbSelectArea(cAlias)
		(cAlias)->(dbCloseArea())
	Endif

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),cAlias, .T., .T.)

	If Select(cAlias) > 0
		If (cAlias)->QTD > 0
			MsgAlert("EXISTEM TÍTULOS VENCIDOS")
			MsgAlert("EXISTEM TÍTULOS VENCIDOS")
		EndIf
	EndIf

	cAlias	 := "2QRYSE1"

	cQuery	:=		" SELECT SUM(E1_SALDO) SAL FROM "+RetSqlName("SE1")+" "
	cQuery	+=	" WHERE E1_CLIENTE= '"+cCliente+"' AND E1_TIPO='NF' "
	cQuery	+=	" AND "+RetSqlName("SE1")+".D_E_L_E_T_= ' ' "

	cQuery	:= ChangeQuery(cQuery)

	If !Empty(Select(cAlias))
		DbSelectArea(cAlias)
		(cAlias)->(dbCloseArea())
	Endif

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),cAlias, .T., .T.)

	If SA1->A1_XNSEG	=	"S"
		MsgAlert("CLIENTE NÃO SEGURADO")
		MsgAlert("CLIENTE NÃO SEGURADO")
	EndIf

	If Select(cAlias) > 0
		If (cAlias)->SAL >= cLc
			MsgAlert("LIMITE DE CRÉDITO EXCEDIDO")
			MsgAlert("LIMITE DE CRÉDITO EXCEDIDO")
		EndIf
	EndIf

	RestArea(aArea)

	dDiffMonth		:=	DateDiffMonth( cDtSera , DDATABASE )

	If dDiffMonth > 5

		MsgAlert("PASSARAM 5 MESES DA ÚLTIMA CONSULTA NO SERASA")
		MsgAlert("PASSARAM 5 MESES DA ÚLTIMA CONSULTA NO SERASA")

	EndIf

	dDiffMonth		:=	DateDiffMonth( cDtCad  , DDATABASE )

	If dDiffMonth1 > 11

		MsgAlert("PASSARAM 11 MESES DA ÚLTIMA CONSULTA DO CADASTRO")
		MsgAlert("PASSARAM 11 MESES DA ÚLTIMA CONSULTA DO CADASTRO")

	Endif

Return aCols