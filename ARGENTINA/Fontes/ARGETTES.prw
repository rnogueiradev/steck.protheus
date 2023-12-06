#INCLUDE "TOTVS.CH"

/*/{Protheus.doc} ARGETTES
@name ARGETTES
@type User Function
@desc retornar tes
@author Renato Nogueira
@since 04/06/2018
/*/

User Function ARGETTES(_cCliente,_cLojaCli,_cTp,_cProduto,_cRotina)

	Local _cQuery1 		:= ""
	Local _cAlias1 		:= GetNextAlias()
	Local _cTes			:= ""
	Local _cTipo		:= IIf(_cRotina=="2",M->C6_OPER,M->CK_OPER)
	Local _cTipoCli		:= ""
	Default _cCliente 	:= ""
	Default _cLojaCli 	:= ""
	Default _cTp	  	:= ""
	Default _cProduto 	:= ""

	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))
	SB1->(DbGoTop())
	If !SB1->(DbSeek(xFilial("SB1")+_cProduto))
		Return(_cTes)
	EndIf

	_cPosIpi := SB1->B1_POSIPI
	_cGrTrib := SB1->B1_GRTRIB

	Do Case
		Case _cTp=="F"
		_cEstado 	:= SA2->A2_EST
		_cTipoCli	:= SA2->A2_TIPO
		Case _cTp=="C"
		_cEstado 	:= SA1->A1_EST
		_cTipoCli	:= SA1->A1_TIPO
	EndCase

	_cQuery1 :=	" SELECT FM_TS  FROM ( "
	_cQuery1 +=	" SELECT * FROM "+RetSqlName('SFM')+"  "
	_cQuery1 +=	" ORDER BY FM_PRODUTO DESC, FM_GRPROD DESC, FM_POSIPI DESC, FM_TIPOCLI DESC, FM_CLIENTE DESC, FM_LOJACLI DESC, FM_GRTRIB DESC, FM_EST DESC ) SFM "
	_cQuery1 +=	" WHERE FM_FILIAL = '"+xFilial("SFM")+"' AND FM_TIPO = '"+_cTipo+"' AND "
	_cQuery1 +=	" FM_TS <> '   '  
	_cQuery1 +=	" AND (FM_PRODUTO = '"+_cProduto+"' OR (FM_PRODUTO = ' ')) "

	Do Case
		Case _cTp=="F"
		_cQuery1 +=	" AND (FM_CLIENTE = '"+_cCliente+    "' OR (FM_CLIENTE = ' ')) "
		_cQuery1 +=	" AND (FM_LOJACLI = '"+_cLojaCli+   "' OR (FM_LOJACLI = ' ')) "
		Case _cTp=="C"
		_cQuery1 +=	" AND (FM_FORNECE = '"+_cCliente+    "' OR (FM_FORNECE = ' ')) "
		_cQuery1 +=	" AND (FM_LOJAFOR = '"+_cLojaCli+   "' OR (FM_LOJAFOR = ' ')) "
	EndCase

	_cQuery1 +=	" AND (FM_TIPOCLI  = '"+_cTipoCli+ "' OR (FM_TIPOCLI  = ' ')) "
	_cQuery1 +=	" AND (FM_POSIPI  = '"+_cPosIpi+ "' OR (FM_POSIPI  = ' ')) "
	_cQuery1 +=	" AND (FM_GRPROD  = '"+_cGrTrib+ "' OR (FM_GRPROD = ' ')) "
	_cQuery1 +=	" AND (FM_EST  = '"+_cEstado+ "' OR (FM_EST = ' ')) "
	_cQuery1 +=	" AND D_E_L_E_T_ = ' ' "
	_cQuery1 +=	" AND ROWNUM = 1 "

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	If !(_cAlias1)->(Eof())
		_cTes := (_cAlias1)->FM_TS
	EndIf

Return(_cTes)