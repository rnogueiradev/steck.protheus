#Include "Protheus.ch"
#Include "RwMake.ch"
#Include "Ap5Mail.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "FWMVCDEF.CH"
#Include "TOPCONN.CH"


/*/{Protheus.doc} ARJOBENV

Envia os e-mails da faturas automaticamente

@type function
@author Everson Santana
@since 04/10/18
@version Protheus 12 - Faturamento

@history , ,

/*/

User Function ARJOBENV()

	Local _cQry := " "
	Local lJob 	:= .t.

	PREPARE ENVIRONMENT EMPRESA '07' FILIAL '01'

	_cQry += " SELECT * "
	_cQry += " FROM " + RetSqlName("SF2")+ " SF2 "
	_cQry += " WHERE D_E_L_E_T_ = ' ' " 
	_cQry += " AND F2_SERIE <> 'R' "
	_cQry += " AND F2_XDTENV = ' ' "
	_cQry += " AND F2_XHRENV = ' ' "
	_cQry += " AND F2_FLFTEX = 'S' "
	//_cQry += " 	AND F2_EMISSAO >= '20181009'  " // Data que iniciou a transmissão automatica
	_cQry += " 	AND F2_EMISSAO >= '20210101'
	_cQry += "	AND F2_ENVLOG = ' '" 

	If Select("QRY") > 0
		Dbselectarea("QRY")
		QRY->(DbClosearea())
	EndIf

	TcQuery _cQry New Alias "QRY"

	Dbselectarea("QRY")
	dbGotop()

	Do While !eof()

		cRemisi := QRY->F2_DOC
		cRemisf := QRY->F2_DOC
		cSerie  := QRY->F2_SERIE
		cTipo   := 2

		u_ARFAT04(cRemisi,cRemisf,cSerie,cTipo,lJob)

		DbSelectArea("SF2")
		DbSetOrder(1)
		DbGotop()
		DbSeek(xFilial("SF2")+QRY->F2_DOC+QRY->F2_SERIE)

		SF2->(RecLock("SF2",.F.))

		SF2->F2_XDTENV		:= DATE()
		SF2->F2_XHRENV		:= TIME()

		SF2->(MsUnlock())

		Dbselectarea("QRY")
		DbSkip()

	EndDo

	_cQry := " "
	_cQry += " SELECT * "
	_cQry += " FROM " + RetSqlName("SF1")+ " SF1 "
	_cQry += " WHERE D_E_L_E_T_ = ' ' "
	_cQry += " AND F1_SERIE <> 'R' "
	_cQry += " AND F1_FORMUL = 'S' "
	_cQry += " AND F1_TIPO IN('D','B') "
	_cQry += " AND F1_XDTENV = ' ' "
	_cQry += " AND F1_XHRENV = ' ' "
	_cQry += " AND F1_FLFTEX = 'S' "
	//_cQry += " AND F1_DTDIGIT >= '20181009'  "// Data que iniciou a transmissão automatica
	_cQry += " AND F1_EMISSAO >= '" + StrZero(year(dDataBase),4) + "0222'"
	_cQry += " AND F1_ENVLOG = ' '" 

	If Select("QRY") > 0
		Dbselectarea("QRY")
		QRY->(DbClosearea())
	EndIf

	TcQuery _cQry New Alias "QRY"

	Dbselectarea("QRY")
	dbGotop()

	Do While !eof()

		cRemisi := QRY->F1_DOC
		cRemisf := QRY->F1_DOC
		cSerie  := QRY->F1_SERIE
		cTipo   := 1

		u_ARFAT04(cRemisi,cRemisf,cSerie,cTipo,lJob)

		DbSelectArea("SF1")
		DbSetOrder(1)
		DbGotop()
		DbSeek(xFilial("SF1")+QRY->F1_DOC+QRY->F1_SERIE)

		SF1->(RecLock("SF1",.F.))

		SF1->F1_XDTENV		:= DATE()
		SF1->F1_XHRENV		:= TIME()

		SF1->(MsUnlock())

		Dbselectarea("QRY")
		DbSkip()

	EndDo

Return
