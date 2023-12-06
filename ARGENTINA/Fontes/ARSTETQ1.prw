#INCLUDE "PROTHEUS.CH"
#INCLUDE "SET.CH"
#INCLUDE "Topconn.ch"

/*/{Protheus.doc} ARSTETQ01

Etiquetas de Cientes

@type function
@author Everson Santana
@since 15/06/18
@version Protheus 12 - Stock/Costos

@history , ,

/*/
User Function ARSTETQ1()//u_ARSTETQ01()

	Local cPorta 	:= "LPT1"
	LOCAL oButton 	:={}
	LOCAL cDoc 		:= Space(13)
	LOCAL nQuant  	:= space(16)
	Local _cQuery   := ""
	Local _nTam		:= 0
	Local _lConf	:= .F.

	LOCAL oDlg, oSay
	LOCAL oFont:= TFont():New("Courier New",,-12,.T.,.T.)
	LOCAL aFont:= TFont():New("Arial",,-12,.T.)
	LOCAL bFont:= TFont():New("Arial",,-14,.T.,.T.)

	Local n := 0

	DEFINE MSDIALOG oDlg FROM 0,0 TO 180,300 PIXEL TITLE "Impreso Etiquetas de Clientes - ARSTETQ1"

	@ 010, 07 SAY OemToAnsi("Remito:")	FONT aFont COLOR CLR_BLACK,CLR_RED OF oDlg PIXEL
	@ 010, 075 MSGET oGet VAR cDoc    SIZE 57,10 OF oDlg PIXEL
	@ 030, 07 SAY OemToAnsi("Bulto:")FONT aFont COLOR CLR_BLACK,CLR_RED OF oDlg PIXEL
	@ 030, 075 MSGET oGet VAR nQuant		SIZE 57,10 OF oDlg PIXEL

	oButton:=tButton():New(050,090,"CONFIRMA",oDlg,{||_lConf:= .T.,oDlg:End()},40,20,,,,.T.)

	ACTIVATE MSDIALOG oDlg CENTERED

	If _lConf

		_cQuery += " SELECT F2.F2_EMISSAO,F2.F2_CLIENTE,A1.A1_NOME,F2.F2_LOJA,F2.F2_HORA,F2.F2_TRANSP,A4.A4_NOME,A1.A1_END,A1.A1_EST,A1.A1_MUN,F2.F2_PBRUTO,F2.F2_VALBRUT,F2.F2_DOC,F2.F2_SERIE "
		_cQuery += "  FROM " + RetSqlName("SF2") + " F2 "
		_cQuery += "  LEFT JOIN " + RetSqlName("SA1") + " A1 "
		_cQuery += "  ON A1.A1_COD = F2.F2_CLIENTE "
		_cQuery += " AND A1.A1_LOJA = F2.F2_LOJA "
		_cQuery += " AND A1.D_E_L_E_T_ = ' ' "
		_cQuery += "  LEFT JOIN " + RetSqlName("SA4") + " A4 "
		_cQuery += " ON A4.A4_COD = F2.F2_TRANSP "
		_cQuery += " AND F2.D_E_L_E_T_ = ' ' "
		_cQuery += " WHERE F2.F2_DOC = '"+cDoc+"' "
		_cQuery += " AND F2.F2_SERIE = 'R00' "
		_cQuery += " AND F2.D_E_L_E_T_ = ' ' "
		_cQuery += " Order By F2.F2_EMISSAO, F2.F2_HORA "

		If Select("QRY") > 0
			Dbselectarea("QRY")
			QRY->(DbClosearea())
		EndIf

		TcQuery _cQuery New Alias "QRY"

		dbSelectArea("QRY")
		QRY->(dbGoTop())

		If !Empty(QRY->F2_DOC)

			MSCBPRINTER("ELTRON",cPorta,,,.F.)

			MSCBLOADGRF("STECK1.PCX")

			For n:= 1 To Val(nQuant)

				MSCBBEGIN(1,6) //124.5 Tamanho da etiqueta

				MSCBGRAFIC(02,01,"STECK1")

				//_nTam := AT( " ", QRY->A1_NOME )

				MSCBSAY(19,05, Substring(Alltrim(QRY->A1_NOME),1,20),"N","4","2,2")
				MSCBSAY(19,15, Substring(Alltrim(QRY->A1_NOME),21,40),"N","4","2,2")
				MSCBSAY(19,25, Substring(Alltrim(QRY->A1_EST+"/"+QRY->A1_MUN),21,40),"N","4","2,2")
				MSCBSAY(19,40, "Remito:"+Alltrim(QRY->F2_DOC),"N","4","2,2")
				MSCBSAY(19,50, "Bulto: "+StrZero(n,2)+"/"+StrZero(Val(nQuant),2),"N","4","3,3")

				MSCBEND()

			Next n

			MSCBCLOSEPRINTER()

		EndIf

		_lConf := .F.

	EndIF

RETURN
