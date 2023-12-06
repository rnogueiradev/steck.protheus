#INCLUDE "TOTVS.CH"

/*====================================================================================\
|Programa  | STETI010        | Autor | RENATO.OLIVEIRA           | Data | 11/10/2018  |
|=====================================================================================|
|Descrição | ETIQUETA PADRAO C&C					                                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STETI010()

	Local _aParamBox 	:= {}
	Local _aRet 		:= {}
	Local ctamG			:= "035,030"
	Local ctamG1		:= "055,045"
	Local ctamM			:= "024,020"
	Local ctamP			:= "021,018"
	Local ctamx			:= "018,015"
	Local _cQuery1 		:= ""
	Local _cAlias1		:= GetNextAlias()
	Local _cQuery2 		:= ""
	Local _cAlias2		:= GetNextAlias()
	Local _nX			:= 0
	Local aCombo 		:= {"Nao","Sim"}
	Local _nQtdPlt		:= 0
	LOCAL nSleep := 0

	AADD(_aParamBox,{1,"Nota Fiscal de",Space(9),"@!","","",".T.",50,.T.})
	AADD(_aParamBox,{1,"Nota Fiscal ate",Space(9),"@!","","",".T.",50,.T.})
	AADD(_aParamBox,{1,"Impressora" ,Space(6),"@!","ExistCpo('CB5')","CB5",".T.",50,.T.})
	AADD(_aParamBox,{2,"Contador de paletes",,aCombo,50,"",.T.})
	AADD(_aParamBox,{1,"Qtd de paletes",_nQtdPlt,"@E","","",".T.",50,.F.})
	AADD(_aParamBox,{1,"Volume de",Space(4),"@!","","",".T.",50,.F.})
	AADD(_aParamBox,{1,"Volume ate",Space(4),"@!","","",".T.",50,.F.})
	If !ParamBox(_aParamBox,"Etiqueta C&C",@_aRet,{||VLDINFOS()},,.T.,,500)
		Return
	EndIf

	If !CB5SETIMP(MV_PAR03,IsTelNet())
		MsgAlert("Falha na comunicacao com a impressora.")
		Return()
	EndIf

	_cQuery2 := " SELECT F2.R_E_C_N_O_ RECSF2, F2_DOC
	_cQuery2 += " FROM "+RetSqlName("SF2")+" F2
	_cQuery2 += " WHERE F2.D_E_L_E_T_=' ' AND F2_FILIAL='"+xFilial("SF2")+"'
	_cQuery2 += " AND F2_SERIE='001' AND F2_DOC BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'
	_cQuery2 += " ORDER BY F2_DOC

	If !Empty(Select(_cAlias2))
		DbSelectArea(_cAlias2)
		(_cAlias2)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery2),_cAlias2,.T.,.T.)

	dbSelectArea(_cAlias2)
	(_cAlias2)->(dbGoTop())

	DbSelectArea("SF2")

	While (_cAlias2)->(!Eof())

		SF2->(DbGoTop())
		SF2->(DbGoTo((_cAlias2)->RECSF2))
		If SF2->(!Eof())

			DbSelectArea("SA1")
			SA1->(DbSetOrder(1))
			SA1->(DbGoTop())
			SA1->(DbSeek(xFilial("SA1")+SF2->(F2_CLIENTE+F2_LOJA)))

			_cQuery1 := " SELECT XXX.*,

			//_cQuery1 += " (SELECT COUNT(DISTINCT CB9_VOLUME) FROM "+RetSqlName("CB9")+" XCB9
			//_cQuery1 += " WHERE XCB9.D_E_L_E_T_=' ' AND XCB9.CB9_FILIAL=XXX.CB9_FILIAL AND XCB9.CB9_ORDSEP=XXX.CB9_ORDSEP)
			//_cQuery1 += " TOTVOL

			_cQuery1 += " ( "
			_cQuery1 += " SELECT F2_VOLUME1 FROM "+RetSqlName("SF2")+" SF2 "
			_cQuery1 += "  WHERE F2_DOC = '"+SF2->F2_DOC+"' "
			_cQuery1 += " AND D_E_L_E_T_ = ' '"
			_cQuery1 += " ) TOTVOL "

			_cQuery1 += " FROM (
			_cQuery1 += " SELECT DISTINCT CB9_FILIAL, CB9_ORDSEP, CB7_NOTA, CB7_SERIE, CB9_VOLUME, C5_XORDEM, C5_XOBSVEN, C5_NUM
			_cQuery1 += " FROM "+RetSqlName("CB7")+" CB7
			_cQuery1 += " LEFT JOIN "+RetSqlName("CB9")+" CB9
			_cQuery1 += " ON CB9_FILIAL=CB7_FILIAL AND CB9_ORDSEP=CB7_ORDSEP
			_cQuery1 += " LEFT JOIN "+RetSqlName("SC5")+" C5
			_cQuery1 += " ON C5_FILIAL=CB7_FILIAL AND C5_NUM=CB7_PEDIDO
			_cQuery1 += " LEFT JOIN "+RetSqlName("SA1")+" A1
			_cQuery1 += " ON A1_COD=C5_CLIENTE AND A1_LOJA=C5_LOJACLI
			_cQuery1 += " WHERE CB7.D_E_L_E_T_=' ' AND CB9.D_E_L_E_T_=' ' AND C5.D_E_L_E_T_=' ' AND A1.D_E_L_E_T_=' '
			//_cQuery1 += " AND SUBSTR(CB9_VOLUME,7,4) BETWEEN '"+MV_PAR06+"' AND '"+MV_PAR07+"'
			_cQuery1 += " AND CB7_FILIAL='"+xFilial("CB7")+"' AND CB7_NOTA='"+SF2->F2_DOC+"'
			_cQuery1 += " ) XXX
			_cQuery1 += " ORDER BY CB7_NOTA, CB9_VOLUME

			If !Empty(Select(_cAlias1))
				DbSelectArea(_cAlias1)
				(_cAlias1)->(dbCloseArea())
			Endif

			dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

			dbSelectArea(_cAlias1)
			(_cAlias1)->(dbGoTop())

			If Empty(MV_PAR06) .And. Empty(MV_PAR07)
				MV_PAR06 := "0000"
				MV_PAR07 := "9999"
			EndIf

			If MV_PAR04=="Nao"

				_nX:=1

				While (_cAlias1)->(!Eof())

					If SubStr((_cAlias1)->CB9_VOLUME,7,4) >= MV_PAR06 .And. SubStr((_cAlias1)->CB9_VOLUME,7,4) <= MV_PAR07

						IF nSleep >= 5
							nSleep := 0
							Sleep( 5000 )
						ELSE
							nSleep++
						ENDIF

						MSCBINFOETI("Volume","")
						MSCBBEGIN(1,4,100)

						Do Case

							Case SF2->F2_CLIENTE=="092887"

							MSCBSAY(002,006,"END. ENTREGA:","N","0",ctamM)
							MSCBSAY(020,005,AllTrim(SA1->A1_END),"N","0",ctamG)
							MSCBSAY(002,010,AllTrim(SA1->A1_BAIRRO)+', '+AllTrim(SA1->A1_MUN)+' - '+AllTrim(SA1->A1_EST)+', '+AllTrim(SA1->A1_CEP),"N","0",ctamG)

							MSCBSAY(002,016,"END. ORIGEM:","N","0",ctamM)
							MSCBSAY(020,015,AllTrim(SM0->M0_ENDENT),"N","0",ctamG)
							MSCBSAY(002,020,AllTrim(SM0->M0_BAIRENT)+', '+AllTrim(SM0->M0_CIDENT)+' - '+AllTrim(SM0->M0_ESTENT)+', '+AllTrim(SM0->M0_CEPENT),"N","0",ctamG)

							MSCBSAYBAR(002,025, SF2->F2_CHVNFE	,"N",'MB07',10,.T.,.T.,.F.,"B",1.5,1.5,.T.)
							MSCBSAYBAR(002,039, AllTrim((_cAlias1)->C5_XORDEM)	,"N",'MB07',10,.T.,.T.,.F.,"B",3,1,.F.)

							MSCBSAY(002,058,"Pedido Amazon: "+AllTrim((_cAlias1)->C5_XORDEM),"N","0",ctamG)

							MSCBSAY(080,040,"VOLUME","N","0",ctamG1)
							MSCBSAY(084,046,CVALTOCHAR(_nX)+" / "+CVALTOCHAR((_cAlias1)->TOTVOL),"N","0",ctamG1)
							//MSCBSAY(084,046,CVALTOCHAR(Val(SubStr((_cAlias1)->CB9_VOLUME,7,4)))+" / "+CVALTOCHAR((_cAlias1)->TOTVOL),"N","0",ctamG1)

							//Case SF2->F2_CLIENTE=="014519"
							OtherWise

							MSCBSAY(002,005,"FORNEC: "+SM0->M0_NOMECOM,"N","0",ctamG1)
							MSCBSAY(002,017,"NF: "+(_cAlias1)->CB7_NOTA+" - "+(_cAlias1)->CB7_SERIE,"N","0",ctamG1)
							MSCBSAY(002,027,"OC: "+(_cAlias1)->C5_XORDEM,"N","0",ctamG1)
							MSCBSAY(002,037,"LOJA: "+(_cAlias1)->C5_XOBSVEN,"N","0",ctamG1)
							MSCBSAY(002,047,"PEDIDO: "+(_cAlias1)->C5_NUM,"N","0",ctamG1)

							MSCBSAY(075,025,"VOLUME","N","0",ctamG1)
							//MSCBSAY(079,032,CVALTOCHAR(Val(SubStr((_cAlias1)->CB9_VOLUME,7,4)))+" / "+CVALTOCHAR((_cAlias1)->TOTVOL),"N","0",ctamG1)
							MSCBSAY(079,032,CVALTOCHAR(_nX)+" / "+CVALTOCHAR((_cAlias1)->TOTVOL),"N","0",ctamG1)

						EndCase

						MSCBEND()
					EndIf

					_nX += 1

					(_cAlias1)->(DbSkip())
				EndDo

			Else

				If (_cAlias1)->(!Eof())
					For _nX:=1 To MV_PAR05

						MSCBINFOETI("Volume","")
						MSCBBEGIN(1,4,100)

						Do Case
							Case SF2->F2_CLIENTE=="092887"

							MSCBSAY(002,006,"END. ENTREGA:","N","0",ctamM)
							MSCBSAY(020,005,AllTrim(SA1->A1_END),"N","0",ctamG)
							MSCBSAY(002,010,AllTrim(SA1->A1_BAIRRO)+', '+AllTrim(SA1->A1_MUN)+' - '+AllTrim(SA1->A1_EST)+', '+AllTrim(SA1->A1_CEP),"N","0",ctamG)

							MSCBSAY(002,016,"END. ORIGEM:","N","0",ctamM)
							MSCBSAY(020,015,AllTrim(SM0->M0_ENDENT),"N","0",ctamG)
							MSCBSAY(002,020,AllTrim(SM0->M0_BAIRENT)+', '+AllTrim(SM0->M0_CIDENT)+' - '+AllTrim(SM0->M0_ESTENT)+', '+AllTrim(SM0->M0_CEPENT),"N","0",ctamG)

							MSCBSAYBAR(002,025, SF2->F2_CHVNFE	,"N",'MB07',10,.T.,.T.,.F.,"B",1.5,1.5,.T.)
							MSCBSAYBAR(002,039, AllTrim((_cAlias1)->C5_XORDEM)	,"N",'MB07',10,.T.,.T.,.F.,"B",3,1,.F.)

							MSCBSAY(002,058,"Pedido Amazon: "+AllTrim((_cAlias1)->C5_XORDEM),"N","0",ctamG)

							MSCBSAY(080,040,"PALETE","N","0",ctamG1)
							MSCBSAY(084,046,CVALTOCHAR(_nX)+" / "+CVALTOCHAR(MV_PAR05),"N","0",ctamG1)

							//Case SF2->F2_CLIENTE=="014519"
							OtherWise

							MSCBSAY(002,005,"FORNEC: "+SM0->M0_NOMECOM,"N","0",ctamG1)
							MSCBSAY(002,017,"NF: "+(_cAlias1)->CB7_NOTA+" - "+(_cAlias1)->CB7_SERIE,"N","0",ctamG1)
							MSCBSAY(002,027,"OC: "+(_cAlias1)->C5_XORDEM,"N","0",ctamG1)
							MSCBSAY(002,037,"LOJA: "+(_cAlias1)->C5_XOBSVEN,"N","0",ctamG1)
							MSCBSAY(002,047,"PEDIDO: "+(_cAlias1)->C5_NUM,"N","0",ctamG1)

							MSCBSAY(075,025,"PALETE","N","0",ctamG1)
							MSCBSAY(079,032,CVALTOCHAR(_nX)+" / "+CVALTOCHAR(MV_PAR05),"N","0",ctamG1)

						EndCase

						MSCBEND()

					Next
				EndIf

			EndIf

		EndIf

		(_cAlias2)->(DbSkip())
	EndDo

Return

/*/{Protheus.doc} VLDINFOS
@name VLDINFOS
@type Static Function
@desc validar informações digitadas
@author Renato Nogueira
@since 17/05/2018
/*/

Static Function VLDINFOS()

	Local _lRet := .T.

	If MV_PAR04=="Sim" .And. MV_PAR05==0
		MsgAlert("Atenção, preencha a quantidade de paletes!")
		_lRet := .F.
	EndIf

Return(_lRet)
