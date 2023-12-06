#INCLUDE "PROTHEUS.CH"
#INCLUDE "APVT100.CH"
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ STFSFA62 ³ Autor ³ Totvs                 ³ Data ³ 03/10/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Rotina Chamada processo de EMBARQUE                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ STECK                                                   	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function STFSFA62()

	Local lRet	 	:= .T.
	Local _cQuery1 	:= ""
	Local _cAlias1 	:= GetNextAlias()
	Private cOrdSep := Space(TamSX3("CB8_ORDSEP")[1])        // Valdemir Rabelo 12/01/2022 - Ticket: 20220110000702
	Public bkey02
	Public _cRomaneio

	bkey02 := VTSetKey(02,{|| U_STXLIMPR()},"Zera romaneio")

	If Empty(_cRomaneio)
		_cRomaneio	:= space(10)
	EndIf

	VTCLEARBUFFER()
	VTCLEAR

	If Empty(_cRomaneio)

		While lRet

			@ 1,0  VTSAY "Romaneio:"
			@ 2,0  VTGET _cRomaneio		PICTURE "@!" F3 "PD1" VALID ExistCpo("PD1",_cRomaneio)

			VTREAD

			If VTLASTKEY()==27
				If CBYesNo("Confirma saida?",".:AVISO:.",.t.)
					Return
				Endif
			Endif

			If Empty(_cRomaneio)
				Loop
			Else
				Exit
			EndIf

		EndDo

	EndIf

	//Conferir se existem registros em branco na CB9

	_cQuery1 := " SELECT CB9.R_E_C_N_O_ RECCB9
	_cQuery1 += " FROM "+RetSqlName("PD1")+" PD1
	_cQuery1 += " LEFT JOIN "+RetSqlName("PD2")+" PD2
	_cQuery1 += " ON PD1_FILIAL=PD2_FILIAL AND PD1_CODROM=PD2_CODROM
	_cQuery1 += " LEFT JOIN "+RetSqlName("CB7")+" CB7
	_cQuery1 += " ON CB7_FILIAL=PD2_FILIAL AND CB7_NOTA=PD2_NFS AND CB7_SERIE=PD2_SERIES AND CB7_CLIENT=PD2_CLIENT AND CB7_LOJA=PD2_LOJCLI
	_cQuery1 += " LEFT JOIN "+RetSqlName("CB8")+" CB8
	_cQuery1 += " ON CB7_FILIAL=CB8_FILIAL AND CB7_ORDSEP=CB8_ORDSEP
	_cQuery1 += " LEFT JOIN "+RetSqlName("CB9")+" CB9
	_cQuery1 += " ON CB8_FILIAL=CB9_FILIAL AND CB8_ORDSEP=CB9_ORDSEP AND CB8_ITEM=CB9_ITESEP AND CB8_SEQUEN=CB9_SEQUEN AND CB8_LCALIZ=CB9_LCALIZ
	_cQuery1 += " WHERE PD1.D_E_L_E_T_=' ' AND PD2.D_E_L_E_T_=' ' AND CB7.D_E_L_E_T_=' ' AND CB8.D_E_L_E_T_=' ' AND CB9.D_E_L_E_T_=' '
	_cQuery1 += " AND PD1_FILIAL='"+xFilial("PD1")+"' AND PD1_CODROM='"+_cRomaneio+"' AND CB9_VOLUME=' '

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	DbSelectArea("CB9")

	While (_cAlias1)->(!Eof())

		CB9->(DbGoTo((_cAlias1)->RECCB9))
		If CB9->(!Eof())
			CB9->(RecLock("CB9",.F.))
			CB9->(DbDelete())
			CB9->(MsUnLock())
		EndIf

		(_cAlias1)->(DbSkip())
	EndDo

	//>> Ticket 20200707003858 - Everson Santana - 13.07.2020
	_cQuery1 := " Select * from ( "
	_cQuery1 += " SELECT Xxx.Cb8_Filial,Xxx.Cb8_Ordsep,Xxx.Cb8_Item,Xxx.Cb8_Prod,Sum(Xxx.Cb8_Qtdori) Cb8_Qtdori,Sum(Xxx.Cb9sep) Cb9sep,Sum(Xxx.Cb9emb)  Cb9emb "

	//_cQuery1 += " SELECT *
	//<< Ticket 20200707003858
	_cQuery1 += " FROM (
	_cQuery1 += " SELECT CB8_FILIAL, CB8_ORDSEP, CB8_ITEM, CB8_PROD, CB8_LCALIZ, CB8_QTDORI, SUM(CB9_QTESEP) CB9SEP, SUM(CB9_QTEEMB) CB9EMB
	_cQuery1 += " FROM "+RetSqlName("PD1")+" PD1
	_cQuery1 += " LEFT JOIN "+RetSqlName("PD2")+" PD2
	_cQuery1 += " ON PD1_FILIAL=PD2_FILIAL AND PD1_CODROM=PD2_CODROM
	_cQuery1 += " LEFT JOIN "+RetSqlName("CB7")+" CB7
	_cQuery1 += " ON CB7_FILIAL=PD2_FILIAL AND CB7_NOTA=PD2_NFS AND CB7_SERIE=PD2_SERIES AND CB7_CLIENT=PD2_CLIENT AND CB7_LOJA=PD2_LOJCLI
	_cQuery1 += " LEFT JOIN "+RetSqlName("CB8")+" CB8
	_cQuery1 += " ON CB7_FILIAL=CB8_FILIAL AND CB7_ORDSEP=CB8_ORDSEP
	_cQuery1 += " LEFT JOIN "+RetSqlName("CB9")+" CB9
	_cQuery1 += " ON CB8_FILIAL=CB9_FILIAL AND CB8_ORDSEP=CB9_ORDSEP AND CB8_ITEM=CB9_ITESEP AND CB8_SEQUEN=CB9_SEQUEN AND CB8_LCALIZ=CB9_LCALIZ AND CB9.D_E_L_E_T_=' '
	_cQuery1 += " WHERE PD1.D_E_L_E_T_=' ' AND PD2.D_E_L_E_T_=' ' AND CB7.D_E_L_E_T_=' ' AND CB8.D_E_L_E_T_=' '
	_cQuery1 += " AND PD1_FILIAL='"+xFilial("PD1")+"' AND PD1_CODROM='"+_cRomaneio+"'
	_cQuery1 += " GROUP BY CB8_FILIAL, CB8_ORDSEP, CB8_ITEM, CB8_PROD, CB8_LCALIZ, CB8_QTDORI
	_cQuery1 += " ORDER BY CB8_ITEM
	_cQuery1 += " ) XXX

	//>> Ticket 20200707003858 - Everson Santana - 13.07.2020
	//_cQuery1 += " WHERE CB8_QTDORI<>CB9SEP OR CB8_QTDORI<>CB9EMB
	_cQuery1 += " Group by Xxx.Cb8_Filial,Xxx.Cb8_Ordsep,Xxx.Cb8_Item,Xxx.Cb8_Prod) xx1 "
	_cQuery1 += " WHERE  cb8_qtdori <> cb9sep "
    _cQuery1 += "    OR cb8_qtdori <> cb9emb "

	//<< Ticket 20200707003858

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	_lTemErro := .F.
	_cLog 	  := ""

	cOrdSep := (_cAlias1)->CB8_ORDSEP    // Valdemir Rabelo 12/01/2022 - Ticket: 20220110000702
	While (_cAlias1)->(!Eof())

		If !((_cAlias1)->CB8_ORDSEP $ _cLog)
			_cLog += (_cAlias1)->CB8_ORDSEP+"/"
		EndIf

		_lTemErro 	:= .T.
		(_cAlias1)->(DbSkip())
	EndDo

	If _lTemErro
		//@ 000, 000 TO 230, 350 DIALOG oDlg TITLE "RESUMO DAS DIVERGÊNCIAS"
		//@ 005,005 Get _cLog Size 167,080 MEMO Object oMemo
		//@ 92,135 BMPBUTTON TYPE 1 ACTION Close(oDlg)
		//ACTIVATE DIALOG oDlg CENTERED
		VTALERT("Atencao, existem divergencias entre a separacao e a embalagem nas OSs "+_cLog)
		Return
	EndIf

U_ACDV175A()

	If CB7->(Bof()) .OR. CB7->(Eof())
		Return
	Endif

	If CB7->CB7_STATUS <> "9" .OR. Empty(CB7->CB7_NOTA)
		Return
	Endif

	CB7->(RecLock("CB7"))
	CB7->CB7_XDFEB := Date()
	CB7->CB7_XHFEB := Time()
	CB7->(MsUnLock())

	SF2->(DbSetOrder(1))
	SF2->(DbSeek(xFilial("SF2")+CB7->(CB7_NOTA+CB7_SERIE)))
	If Empty(SF2->F2_XCODROM)
		Return
	Endif
	U_STFSF60H(SF2->F2_XCODROM,CB7->CB7_NOTA,CB7->CB7_SERIE) 	//Atualizar informacoes dos itens do romaneio:
	U_STFSF60C(SF2->F2_XCODROM) 											//Atualiza informacoes do Romaneio (pesos, quantidades volumes e status)

	VTSetKey(02,bkey02)

Return

User Function STXLIMPR()

	_cRomaneio	:=	space(10)
	VTGetRefresh("_cRomaneio")

	VTALERT("Romaneio zerado, saia da rotina e entre novamente!")

Return()
