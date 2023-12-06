#include 'Protheus.ch' 
#include 'RwMake.ch'
#DEFINE CR    chr(13)+chr(10)

/*====================================================================================\
|Programa  | TabeSt           | Autor | GIOVANI.ZAGO             | Data | 15/05/2013  |
|=====================================================================================|
|Descrição | TabeSt                                                                   |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | TabeSt                                                                   |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*------------------------------*
User Function TabeSt()
	*------------------------------*
	Local _aArea     := GetArea()
	Local cAliasLif  := 'XCD'
	Local cAliasSt   := 'STC9'
	Local cQuery     := ' '
	Local _cPed      := ' '
	Local _lParcial  := .F.

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf
	DBSELECTAREA("SC9")
	DBSELECTAREA("SD2")
	DBSELECTAREA("SF2")

	cQuery := ' SELECT  MAX(SC9.R_E_C_N_O_)  "RECNO", SC9.C9_ORDSEP   "ORDSEP", SC9.C9_PEDIDO "PEDIDO", SC9.C9_ITEM  "ITEM", SC9.C9_QTDLIB "QTD"   '
	cQuery += " FROM "+RetSqlName("SD2")+" SD2 "
	cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SC9")+") SC9 "
	cQuery += " ON  SC9.C9_PEDIDO   = SD2.D2_PEDIDO
	cQuery += " AND SC9.C9_ITEM     = SD2.D2_ITEMPV
	cQuery += " AND SC9.R_E_C_D_E_L_ <> 0
	cQuery += " AND SC9.C9_FILIAL   =  SD2.D2_FILIAL
	cQuery += " AND SC9.C9_ORDSEP   <> ' '
	cQuery += " AND SD2.D2_QUANT    =  SC9.C9_QTDLIB
	cQuery += " WHERE SD2.D2_DOC    = '"+SF2->F2_DOC+"'"
	cQuery += " AND SD2.D2_SERIE    = '"+SF2->F2_SERIE+"'"
	cQuery += " AND SD2.D_E_L_E_T_  = '*'
	cQuery += " AND SD2.D2_FILIAL   = '"+xFilial("SD2")+"'"
	cQuery += " GROUP BY  SC9.C9_ORDSEP, SC9.C9_PEDIDO, SC9.C9_ITEM, SC9.C9_QTDLIB
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAliasLif, .T., .T.)
	DBSELECTAREA(cAliasLif)
	(cAliasLif)->(DbGoTop())

	While 	(cAliasLif)->(!Eof() )
		_cPed:=(cAliasLif)->PEDIDO

		cQuery := " "
		cQuery := ' SELECT MAX(SC9.R_E_C_N_O_) "_RECNO" '
		cQuery += " FROM "+RetSqlName("SC9")+" SC9 "
		cQuery += " WHERE SC9.C9_QTDLIB  =  "+	STRTRAN(cvaltochar((cAliasLif)->QTD),',','.')    +" "
		cQuery += " AND   SC9.C9_PEDIDO  =  '"+ (cAliasLif)->PEDIDO +"'"
		cQuery += " AND   SC9.C9_ITEM    =  '"+ (cAliasLif)->ITEM   +"'"
		cQuery += " AND   SC9.C9_FILIAL  =  '"+xFilial("SC9")+"'"


		cQuery := ChangeQuery(cQuery)

		If Select(cAliasSt) > 0
			(cAliasSt)->(dbCloseArea())
		EndIf

		dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasSt)
		dbSelectArea(cAliasSt)
		If  Select(cAliasSt) > 0

			DbSelectArea("SC9")
			SC9->(DbGoTo((cAliasSt)->_RECNO))

			IF Empty(Alltrim(SC9->C9_NFISCAL))
				DbSelectArea("SC6")
				SC6->(DbSetOrder(1))
				If SC6->(DbSeek(xFilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM))
					STSDCExc(SC6->C6_NUM,SC6->C6_PRODUTO,'03',SC9->C9_QTDLIB,SC6->(RECNO()),{},'')
				EndIf
				SC9->(RecLock("SC9",.F.))
				SC9->C9_ORDSEP  := (cAliasLif)->ORDSEP
				SC9->C9_BLEST   := ''
				SC9->C9_BLcred  := ''
				SC9->(MsUnlock())
				SC9->(DbCommit())

			EndIf

		EndIf
		(cAliasLif)->(DbSkip())
	End


	DbSelectArea("SC9")
	SC9->(DbSetOrder(1))
	If SC9->(DbSeek(xFilial("SC9")+_cPed))

		While SC9->(!Eof()) .and. SC9->C9_FILIAL = xFilial("SC9") .And. SC9->C9_PEDIDO = _cPed
			If ! Empty(Alltrim(SC9->C9_NFISCAL))
				_lParcial:= .t.
			EndIf

			SC9->(DBSKIP())
		END
	EndIf
	DbSelectArea("SC5")
	SC5->(DbSetOrder(1))
	If SC5->(DbSeek(xFilial("SC5")+_cPed))
		SC5->(RecLock("SC5",.F.))
		SC5->C5_ZFATBLQ  := Iif(_lParcial,'2',' ')
		SC5->(MsUnlock())
		SC5->(DbCommit())
	EndIf

	U_MaiStCanc(_cPed) //envia e-mail de cancelamento

	RestArea(_aArea)
	Return

	/*====================================================================================\
	|Programa  | STSDCExc         | Autor | GIOVANI.ZAGO             | Data | 08/05/2013  |
	|=====================================================================================|
	|Descrição | STSDCExc                                                                 |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | STSDCExc                                                                 |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/
	*-----------------------------------------------------------------------*
Static Function STSDCExc(cDoc,cProduto,cArm,nReserva,nRecno,aSD4,cOrdSep)
	*-----------------------------------------------------------------------*
	Local cTipDoc 	:= If(len(Alltrim(cDoc))==11,"2","1")
	Local aSaldos	:= {}
	Local lUsaVenc	:= SuperGetMv('MV_LOTVENC')=='S'
	Local _cQuery   := ' '
	Local cAliasQue := 'TASDB'
	Local _lExcNf   := GetMv("ST_EXCLNF",,.F.)
	SC6->(DbGoto(nRecno))

	a460Estorna()

	If _lExcNf
		_cQuery := " SELECT * FROM SDB010 SDB
		_cQuery += " WHERE SDB.D_E_L_E_T_ = ' '
		_cQuery += " AND SDB.DB_PRODUTO = '"+SC6->C6_PRODUTO+"'
		_cQuery += " AND SDB.DB_DOC     = '"+SF2->F2_DOC+"'"
		_cQuery += " AND SDB.DB_SERIE   = '"+SF2->F2_SERIE+"'"
		_cQuery += " AND SDB.DB_CLIFOR  = '"+SF2->F2_CLIENTE+"'"
		_cQuery += " AND SDB.DB_LOJA    = '"+SF2->F2_LOJA+"'"
		_cQuery += " AND SDB.DB_FILIAL  = '"+xFilial("SDB")+"'"
		_cQuery += " AND SDB.DB_TM <> '499'

		_cQuery := ChangeQuery(_cQuery)
		If Select(cAliasQue) > 0
			(cAliasQue)->(dbCloseArea())
		EndIf
		dbUseArea(.T.,"TOPCONN", TCGENQRY(,,_cQuery),cAliasQue, .T., .T.)
		DBSELECTAREA(cAliasQue)
		(cAliasQue)->(DbGoTop())

		While 	(cAliasQue)->(!Eof() )
			aSaldos	:= {}
			aSaldos := {{ "","",(cAliasQue)->DB_LOCALIZ,"",(cAliasQue)->DB_QUANT,ConvUm(SC6->C6_PRODUTO,2,0,(cAliasQue)->DB_QUANT),Ctod(""),"","","",SC6->C6_LOCAL,0}}

			nRecno:= SC6->(Recno())
			MaLibDoFat(SC6->(Recno()),nReserva,.T.,.T.,.F.,.F.,.F.,.F.,Nil,{||SC9->C9_ORDSEP:= cOrdSep },aSaldos,Nil,Nil,Nil)
			MaLiberOk({SC6->C6_NUM},.F.)
			MsUnLockall()
			SC6->(DbGoto(nRecno))
			aSaldos	:= {}
			(cAliasQue)->(DbSkip())
		End
	Else
		aSaldos := {{ "","","","",nReserva,ConvUm(SC6->C6_PRODUTO,2,0,nReserva),Ctod(""),"","","",SC6->C6_LOCAL,0}}
		nRecno:= SC6->(Recno())
		MaLibDoFat(SC6->(Recno()),nReserva,.T.,.T.,.F.,.F.,.F.,.F.,Nil,{||SC9->C9_ORDSEP:= cOrdSep },aSaldos,Nil,Nil,Nil)
		MaLiberOk({SC6->C6_NUM},.F.)
		MsUnLockall()
		SC6->(DbGoto(nRecno))
	EndIf
	Return

	/*====================================================================================\
	|Programa  | SF2520E          | Autor | GIOVANI.ZAGO             | Data | 16/04/2013  |
	|=====================================================================================|
	|Descrição | SF2520E                                                                  |
	|          |  Valida estorno da NF saida			                                  |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | SF2520E                                                                  |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/
	//ms520vld
	*-----------------------------*
User Function MaiStCanc(_cPed)
	*-----------------------------*
	Local _aarea     := getarea()
	Local cInd        := "1"
	Local cGetMotivo  := iif(__cuserid = '000000','teste de envio de email na exclusao da nf de saida favor desconsiderar este email',Space(80))
	Local nOpcao      := 0
	Local _lRetRoman  := .F.
	Local _lRetOrdsep := .F.
	Local lBrowser    := .F.
	Local lSaida      := .F.
	Local _aMotRej    := {}
	Local _aInfRmo    := {}
	Local _aInfOrd    := {}
	Local _aInfFat    := {}
	Local _cItem      := '001'
	Local _nRom       := 0
	Local _cSerie     := SF2->F2_SERIE
	Local _cNota      := SF2->F2_DOC

	Local cStmt := ""

	AADD(_aMotRej,' ')
	DbSelectArea("SX5")
	SX5->(dbSetOrder(1))
	SX5->(dbSeek(xFilial("SX5") + 'ZT'))
	Do While SX5->(!EOF()) .and. xFilial("SX5") = SX5->X5_FILIAL .And. SX5->X5_TABELA  = 'ZT'
		AADD(_aMotRej,ALLTRIM(SX5->X5_CHAVE)+' - '+ALLTRIM(SX5->X5_DESCRI))
		SX5->(DbSkip())
	EndDo

	Do While !lSaida
		nOpcao := 0

		Define msDialog oDxlg Title "Exclusão de Nota Fiscal de Saída " From 10,10 TO 300,400 Pixel

		@ 010,010 say "NF: " COLOR CLR_BLACK  Of oDxlg Pixel
		@ 010,050 get _cNota   when .f. size 030,08  Of oDxlg Pixel
		@ 020,010 say "SERIE: " COLOR CLR_BLACK  Of oDxlg Pixel
		@ 020,050 get _cSerie  when .f. size 025,08  Of oDxlg Pixel

		@ 040,010 say "Observação da Exclusão:" COLOR CLR_HBLUE  Of oDxlg Pixel
		@ 050,010 get cGetMotivo  size 165,08  Of oDxlg Pixel

		@ 070,010 Say "Motivo da Exclusão:"   COLOR CLR_HBLUE  Of oDxlg Pixel
		@ 080,010 COMBOBOX _cItem ITEMS _aMotRej SIZE 110,50 Of oDxlg Pixel

		@ 115, 050  Say "O Pedido Será Refaturado ? "   COLOR CLR_HRED  Of oDxlg Pixel
		@ 130, 052  Button "SIM"    Size 28,12 Action Eval({||IF(!empty(alltrim(_cItem)),(lSaida:=.T.,nOpcao:=1,oDxlg:End()),msgInfo("Motivo da Exclusão não preenchido","Atenção"))}) OF oDxlg Pixel
		@ 130, 102  Button "NÃO"    Size 28,12 Action Eval({||IF(!empty(alltrim(_cItem)),(lSaida:=.T.,nOpcao:=2,oDxlg:End()),msgInfo("Motivo da Exclusão não preenchido","Atenção"))}) OF oDxlg Pixel

		Activate Dialog oDxlg Centered

	EndDo

	If nOpcao == 1 .Or. nOpcao == 2
		Begin Transaction
			DbSelectArea("SC9")
			SC9->(DbSetOrder(1))
			If SC9->(DbSeek(xFilial("SC9")+_cPed))
				While SC9->(!Eof()) .and. SC9->C9_FILIAL = xFilial("SC9") .And. SC9->C9_PEDIDO = _cPed
					If Empty(Alltrim(SC9->C9_NFISCAL))  .and. Empty(Alltrim(SC9->C9_BLEST))
						aadd(_aInfFat,{_cSerie,_cNota,SC9->C9_ORDSEP,SC9->C9_PEDIDO,cGetMotivo,_cItem,	'Vendas'} )
						If !Empty(Alltrim(SC9->C9_ORDSEP))
							aadd(_aInfOrd,{_cSerie,_cNota,SC9->C9_ORDSEP,SC9->C9_PEDIDO,cGetMotivo,_cItem,'Expedição'} )
							_lRetOrdsep:= .T.
							DbSelectArea('CB7')
							CB7->(DbSetorder(1))
							If CB7->(DbSeek(xFilial('CB7')+SC9->C9_ORDSEP))
								RecLock('CB7',.F.)
								CB7->CB7_STATUS := '4'
								CB7->CB7_NOTA   := ' '
								CB7->CB7_SERIE  := ' '
								CB7->( MsUnLock())
								CB7->( DbCommit())

							EndIf
						EndIf
					EndIf
					SC9->(DBSKIP())
				END
			EndIf

			cStmt := " MERGE INTO sdc110 sdcx"
			cStmt += " USING"
			cStmt += " (select cb8_lcaliz, dc_localiz, cb8.r_e_c_n_o_ RECCB8, sdc.r_e_c_n_o_ RECSDC from " + RetSqlName("CB8") + " cb8"
			cStmt += " inner join " + RetSqlName("SDC") + " sdc on dc_filial = cb8_filial and dc_pedido = cb8_pedido and dc_item = cb8_item"
			cStmt += " inner join " + RetSqlName("SBE") + " sbe on be_filial = cb8_filial and be_local = cb8_local and be_localiz = cb8_lcaliz"
			cStmt += " where cb8_filial = '" + FWxFilial("CB8") + "' and cb8_pedido = '" + _cPed + "' and sbe.be_xempenh = 'S' and cb8.d_e_l_e_t_ = ' ' and sdc.d_e_l_e_t_ = ' ' and sbe.d_e_l_e_t_ = ' ') qry"
			cStmt += " ON (sdcx.R_E_C_N_O_ = qry.RECSDC)"
			cStmt += " WHEN MATCHED THEN UPDATE SET"
			cStmt += " sdcx.dc_localiz = qry.cb8_lcaliz"

			If TcSqlExec(cStmt) < 0 .And. !IsBlind()
				FWAlertInfo(TCSQLError() + CRLF + "Erro ao atualizar Composição de Empenho dos itens Emprenho = Sim")
			End If

			DbSelectArea("PD2")
			PD2->(DbSetOrder(2))
			If PD2->(DbSeek(xFilial("PD2")+_cNota+_cSerie))
				While PD2->(!Eof()) .and. PD2->PD2_FILIAL = xFilial("PD2") .And. PD2->PD2_SERIES = _cSerie .And. PD2->PD2_NFS = _cNota
					_lRetRoman:= .T.
					AADD(_aInfRmo,{_cSerie,_cNota,PD2->PD2_CODROM,SC9->C9_PEDIDO ,cGetMotivo,_cItem,'Logística'} )
					RecLock('PD2',.F.)
					PD2->PD2_STATUS := '3'
					PD2->(DbDelete())
					PD2->( MsUnLock())
					PD2->( DbCommit())

					PD2->(DBSKIP())
				END
			EndIf
			If Len(_aInfRmo)>0
				DbSelectArea("PD2")
				PD2->(DbSetOrder(1))
				If !PD2->(DbSeek(xFilial("PD2")+_aInfRmo[1,3]))
					DbSelectArea("PD1")
					PD1->(DbSetOrder(1))
					If PD1->(DbSeek(xFilial("PD1")+_aInfRmo[1,3]))
						RecLock('PD1',.F.)
						PD1->PD1_STATUS := '3'
						PD1->( DbDelete())
						PD1->( MsUnLock())
						PD1->( DbCommit())
					EndIf
				EndIf

			EndIf

		End Transaction
		If _lRetRoman
			StRomaMail(_aInfRmo)
		EndIf

		If _lRetOrdsep  //.And. nOpcao = 2 //giovani zago 09/05/2019 solicitação  simone mara
			StRomaMail(_aInfOrd)
		EndIf
		DbSelectArea("SC5")
		SC5->(DbSetOrder(1))
		If SC5->(DbSeek(xFilial("SC5")+_cPed))
			SC5->(Reclock("SC5",.F.))
			SC5->C5_ZREFNF := '1'
			//SC5->C5_ZFATBLQ:= '2' - Aguardar rafael.pereira executar o teste de cancelamento no protheus11_renato
			SC5->(MsUnlock())
			SC5->( DbCommit() )
		EndIf

		aadd(_aInfFat,{SF2->F2_SERIE,SF2->F2_DOC,"","",cGetMotivo,_cItem,	'Vendas'} )
		//StRomaMail(_aInfFat)

	EndIf


	Restarea(_aarea)
	Return(.T.)
	/*====================================================================================\
	|Programa  | StExcDoc         | Autor | GIOVANI.ZAGO             | Data | 25/04/2013  |
	|=====================================================================================|
	|Descrição | StExcDoc                                                                 |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | StExcDoc                                                                 |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/
	*-----------------------------*
User Function StExcDoc (_cSerie,_cNota)
	*-----------------------------*

	Local _aArea	:= GetArea()
	Local _lRet     := .T.

	MV_PAR08 := MV_PAR07
	Sx1St(2)


	Restarea(_aArea)
	Return(_lRet)
	/*====================================================================================\
	|Programa  | StExc2Re         | Autor | GIOVANI.ZAGO             | Data | 25/04/2013  |
	|=====================================================================================|
	|Descrição | StExc2Re                                                                 |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | StExc2Re                                                                 |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/
	*------------------------------------------------------------------*
User Function StExc2Re()
	*------------------------------------------------------------------*
	Local cPerg      := 'MT521A'
	Local cPerg1     := 'MTA521'
	/* Removido - 18/05/2023 - Não executa mais Recklock na X1 - Criar/alterar perguntas no configurador
	dbSelectArea("SX1")
	dbSetOrder(1)
	cPerg  := PADR(cPerg , Len(SX1->X1_GRUPO)," " )
	cPerg1 := PADR(cPerg1, Len(SX1->X1_GRUPO)," " )

	If SX1->(dbSeek(cPerg+'07'))
		RecLock("SX1",.F.)
		SX1->X1_CNT01:= ' '
		SX1->(MsUnlock())
	Endif
	If SX1->(dbSeek(cPerg+'08'))
		RecLock("SX1",.F.)
		SX1->X1_CNT01:= ' '
		SX1->(MsUnlock())
	Endif

	If SX1->(dbSeek(cPerg1+'04'))
		MV_PAR04:=SX1->X1_PRESEL
	Endif*/

return(.T.)

Static Function Sx1St(_nSx1)
	Local cPerg     := 'MTA521'
	/* Removido - 18/05/2023 - Não executa mais Recklock na X1 - Criar/alterar perguntas no configurador
	dbSelectArea("SX1")
	dbSetOrder(1)
	cPerg := PADR(cPerg, Len(SX1->X1_GRUPO)," " )

	If SX1->(dbSeek(cPerg+'04'))
		RecLock("SX1",.F.)
		SX1->X1_PRESEL:= _nSx1
		SX1->(MsUnlock())
	Endif*/

	Return()

	/*====================================================================================\
	|Programa  | StRomaMail       | Autor | GIOVANI.ZAGO             | Data | 25/04/2013  |
	|=====================================================================================|
	|Descrição | StRomaMail                                                               |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | StRomaMail                                                               |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/
	*------------------------------------------------------------------*
Static Function  StRomaMail(_aInfRmo)
	*------------------------------------------------------------------*

	Local aArea 	:= GetArea()
	Local _cFrom   := "protheus@steck.com.br"
	Local _cAssunto:= _aInfRmo[1,7]+' - Exclusão da Nota Fiscal De Saída  -  Série: '+_aInfRmo[1,1] +' - Nota: '+_aInfRmo[1,2] +' '
	Local cFuncSent:= "StRomaMail"
	Local _aMsg    := {}
	Local i        := 0
	Local cArq     := ""
	Local cMsg     := ""
	Local _nLin
	Local _cCopia  := ' KLEBER.BRAGA@STECK.COM.BR'
	Local cAttach  := ''
	Local _cEmail  := ' '

	If alltrim(_aInfRmo[1,7])  = 'Logística'
		_cEmail  := 'KLEBER.BRAGA@STECK.COM.BR'
	ElseIf alltrim(_aInfRmo[1,7])  = 'Vendas'
		DbSelectArea('SA3')
		SA3->(DbSetOrder(1))
		If (SA3->(dbSeek(xFilial('SA3')+alltrim(SF2->F2_VEND2))))
			_cEmail  := SA3->A3_EMAIL
			If  !Empty(Alltrim(SA3->A3_SUPER))
				If (SA3->(dbSeek(xFilial('SA3')+alltrim(SA3->A3_SUPER))))
					_cEmail:= _cEmail +';'+SA3->A3_EMAIL
				EndIf
			EndIf
		EndIf

	ElseIf alltrim(_aInfRmo[1,7])  = 'Expedição'
		_cEmail  := ' jefferson.puglia@steck.com.br;  simone.mara@steck.com.br; jefferson.puglia@steck.com.br;kleber.braga@steck.com.br;maurilio.francischetti@steck.com.br;marcelo.galera@steck.com.br;guilherme.fernandez@steck.com.br;leandro.nobre@steck.com.br;francisco.smania@steck.com.br;wellington.gamas@steck.com.br'
	EndIf


	If ( Type("l410Auto") == "U" .OR. !l410Auto )

		Aadd( _aMsg , { "Nota Fiscal: "     , _aInfRmo[1,2] } )
		Aadd( _aMsg , { "Série: "  			, _aInfRmo[1,1] } )
		Aadd( _aMsg , { "Pedido: "    		, _aInfRmo[1,4] } )
		If alltrim(_aInfRmo[1,7])  <> 'Vendas'
			Aadd( _aMsg , { _aInfRmo[1,7]+':'   , _aInfRmo[1,3] } )
		EndIf
		Aadd( _aMsg , { "Motivo: "    		, _aInfRmo[1,6] } )
		Aadd( _aMsg , { "Observação: "    	, _aInfRmo[1,5]+" - PEDIDO BLOQUEADO PARA REFATURAMENTO, EFETUE A LIBERAÇÃO PARA NOVO FATURAMENTO" } )
		Aadd( _aMsg , { "Usuario: "    	    , cUserName 	} )
		Aadd( _aMsg , { "Hora: "    		, Time() 		} )
		Aadd( _aMsg , { "Dt. Exclusão: "    , DTOC(Date())  } )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do cabecalho do email                                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cMsg := ""
		cMsg += '<html>'
		cMsg += '<head>'
		cMsg += '<title>' + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
		cMsg += '</head>'
		cMsg += '<body>'
		//cMsg += '<Img Src="C:/AP5/SIGAADV/LGRL01.BMP"><BR>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
		cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do texto/detalhe do email                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For _nLin := 1 to Len(_aMsg)
			IF (_nLin/2) == Int( _nLin/2 )
				cMsg += '<TR BgColor=#B0E2FF>'
			Else
				cMsg += '<TR BgColor=#FFFFFF>'
			EndIF
			cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
			cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
			cMsg += '</TR>'
		Next
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do rodape do email                                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cMsg += '</Table>'
		cMsg += '<P>'
		cMsg += '<Table align="center">'
		cMsg += '<tr>'
		cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">('+cFuncSent+')</td>'
		cMsg += '</tr>'
		cMsg += '</Table>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		//cMsg += '<B><Font Color=#000000 Size="2" Face="Arial"> Atenciosamente </Font></B><BR>'
		//cMsg += '<B><Font Color=#000000 Size="2" Face="Arial">' + SM0->M0_NOMECOM + '</Font></B><BR>'
		//cMsg += '<Img Src="C:/AP5/SIGAADV/LGRL01.BMP">'
		cMsg += '</body>'
		cMsg += '</html>'


		If !(   U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,cAttach) )
			MsgInfo("Email não Enviado..!!!!")

		EndIf
	EndIf
	RestArea(aArea)
Return()


User Function STSC9AM()


	Local cAliasLif  := 'STSC9AM'
	Local cQuery     := ' '
	Local _cPed 	 := ' '
	Local _aPed 	 := {}
	Local l        	  := 0
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf


	cQuery := ' SELECT DISTINCT SD2.D2_PEDIDO , SD2.D2_ORDSEP '
	cQuery += " FROM "+RetSqlName("SD2")+" SD2 "
	cQuery += " WHERE SD2.D2_DOC    = '"+SF2->F2_DOC+"'"
	cQuery += " AND SD2.D2_SERIE    = '"+SF2->F2_SERIE+"'"
	cQuery += " AND SD2.D_E_L_E_T_  = '*'
	cQuery += " AND SD2.D2_FILIAL   = '"+xFilial("SD2")+"'"

	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAliasLif, .T., .T.)
	DBSELECTAREA(cAliasLif)
	(cAliasLif)->(DbGoTop())
	If !(Empty(Alltrim((cAliasLif)->D2_ORDSEP )))
		U_TabeSt()
		Return()
	EndIf

	DbSelectArea('ZZT')
	ZZT->(DbSetOrder(2))
	If ZZT->(DbSeek(xFilial("ZZT")+SF2->F2_DOC+SF2->F2_SERIE))
		While ZZT->(!Eof()) .and. ZZT->ZZT_FILIAL == xFilial("ZZT") .And. ZZT->ZZT_NF == SF2->F2_DOC .And. ZZT->ZZT_SERIEN == SF2->F2_SERIE

			Reclock("ZZT",.F.)
			Replace ZZT_STATUS With "2"
			Replace ZZT_NF With " "
			Replace ZZT_SERIEN With " "
			Replace ZZT_HRFIM With " "
			MsUnlock()


			ZZT->(DbSkip())

		End

	EndIf



	While 	(cAliasLif)->(!Eof() )

		aadd(_aPed,{(cAliasLif)->D2_PEDIDO})


		(cAliasLif)->(DbSkip())

	End
	For l:=1 To Len(_aPed)
		_cPed:=  _aPed[l,1]
		DbSelectArea('SC6')
		SC6->(DbSetOrder(1))
		If SC6->(DbSeek(xFilial("SC6")+_cPed))
			While SC6->(!Eof()) .and. SC6->C6_FILIAL+SC6->C6_NUM == xFilial("SC6")+SC5->C5_NUM

				dbSelectArea("SC9")
				SC9->(	dbSetOrder(1) )
				If	SC9->(dbSeek(xFilial("SC9")+SC6->C6_NUM+SC6->C6_ITEM))

					While SC9->(!Eof()) .And. SC9->C9_PEDIDO==SC6->C6_NUM .And. SC9->C9_ITEM==SC6->C6_ITEM .And. SC9->C9_FILIAL==SC6->C6_FILIAL //Ajustado em 29/05/2014 - Não estava fazendo while na SC9

						If	Empty(Alltrim(SC9->C9_NFISCAL))

							a460estorna()

						Else

							SC9->(DbSkip())
							Loop

						EndIf

						SC9->(DbSkip())

					EndDo

				EndIf
				nRecno:= SC6->(RecNo())
				MaLibDoFat(SC6->(RecNo()), SC6->C6_QTDVEN-SC6->C6_QTDENT,.F.,.T.,.T.,.T.,.T.,.T.,NIL,NIL,NIL,NIL,NIL,0)
				MaLiberOk({SC6->C6_NUM},.F.)
				MsUnLockall()
				dbcommitall()
				SC6->(DbGoto(nRecno))
				SC9->(RecLock("SC9",.F.))
				SC9->C9_BLEST  := ' '
				SC9->C9_BLCRED := ' '
				SC9->C9_LOCAL  := '15'
				SC9->(MsUnlock())
				SC9->(DbCommit())


				SC6->(DbSkip())

			End

		Endif

	Next l






Return()

