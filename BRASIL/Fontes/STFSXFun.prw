#INCLUDE 'PROTHEUS.CH' 
#INCLUDE 'rwmake.CH'
#INCLUDE "Tbiconn.ch"
#INCLUDE "TOTVS.CH"
#Define CR chr(13)+chr(10)
/*
STManaus()
STDeposito()
STProducao()
STReserva(cDoc,cProduto,nQtde,cOper,cFilialRes)  			     	// fazer a reserva
STFalta(cDoc,cProduto,nQtde,cOper)									// fazer a perda
STGetFal(cDoc,cProduto)												// retorna a qtde de falta por documento + produto
STGetRes(cDoc,cProduto,cFilialRes)									// retorna a qtde de reserva por documento + produto
STGrvFR(cChave,cProduto,nQtde)       								// analisa estoque e fazer reserva ou falta
STDelFR(cChave,cProduto)											// deleta falta e reserva de um produto e documento
STDelDoc(cDoc)														// deleta falta e reserva de todos os produto do documento.
STSldRes(cProduto,cFilialRes)										// retorna qtde de reserva por produto
STPriSC5() 															// Grava Prioridade da tabela SC5
STPriSC2()	 														// Grava Prioridade da tabela SC2
STGrvSt(cDoc,lParcial)												// Grava Status do Documento.
STResOP(cProduto)													// retorna qtde de reserva por produto
STResFalta(cProduto)												// retorna a qtde de falta por produto
STResSDC(cProduto)													// retorna qtde de SDC por produto
STPriCB7(cArmExp,cCodOpe)                         			 		// Grava Prioridade da tabela CB7
STGeraSDC(cDoc,cProduto,cArm,nReserva,nRecno,aSD4,cOrdSep)  		// faz a Libera็ใo de estoque, gerando SC9 E SDC ou SD4 E SDC
STDelSDC(cDoc,cProduto,cOrdSep,nRecno)								// Estorna a libercao de estoque e empenho
STGeraOS(cOrigem,cOrdSep,aSD4,cOrdAux,cArmSel)						// gera a ordem de separacao CB7 E CB8
STDelOS(cOrdSep)													// Exclui a ordem de separacao
STDelAux(cOrdFilho)													// Exclui a ordem de separacao auxiliar
STIsTLV(cPedido)													// Verifica se o pedido de venda passado tem origem no TELEVENDAS
STBarra(cProduto,cLote,nQtde,cEmpresa)								// Retorna a codificao do codigo de barras
STFixaPerg(cPerg,aFixa)                                     		// Fixa conteudo de pergunte conforme parametros
STIsIndireto(cProduto)												// Funcao que retorna se o produto eh apropriacao indireta .T. ou .F. para direto
STAltSc5()															// Funcao para alterar transportadora e tipo de faturamento do pedido de venda
STTranArm															// Fun็ใo para transfer๊ncia entre armaz้ns 03 para 90
STTranML															// Fun็ใo para transfer๊ncia entre armaz้ns 03 para 06 Mercado Livre
STSLDSC6(nRecno)													// Funcao para retornar o saldo a faturar do item no pedido de venda
*/

User Function STManaus()
	If GetMV("FS_MANAUS") == cEmpAnt+cFilAnt
		Return .T.
	EndIf
Return .F.

User Function STDeposito()
	If GetMV("FS_DEPOSIT") == cEmpAnt+cFilAnt
		Return .T.
	EndIf
Return .F.

User Function STProducao()
	If !(funname() $ "GFEA070")
		If GetMV("FS_PRODUCA") == cEmpAnt+cFilAnt
			Return .T.
		EndIf
	EndIf
Return .F.

User Function STReserva(cDoc,cProduto,nQtde,cOper,cFilialRes,cFilialSB2)  //renato/leo  ajustado em 10/04/13 passado o parametro cFilialSB2

	Local cTipDoc 	:= If(len(Alltrim(cDoc))==11,"2","1")
	Local aArea 	:= GetArea()
	Local aPA2Area 	:= PA2->(GetArea())
	Local aSB1Area 	:= SB1->(GetArea())
	Local aSB2Area 	:= SB2->(GetArea())
	Local aSD4Area 	:= SD4->(GetArea())
	Local aSC6Area 	:= SC6->(GetArea())
	Local cQuery   	:= ""
	Local cAlias 	:= "QRYTEMP"
	Local cLocal 	:= ''
	Default cOper 	:= "+"
	Default cFilialSB2 := xFilial("SB2") //renato/leo  ajustado em 10/04/13

	cDoc:= Padr(cDoc,11)

	SB1->(DbSetOrder(1))
	SB1->(DbSeek(xFilial("SB1")+cProduto))
	cLocal := SB1->B1_LOCPAD
	
	// FMT - CONSULTORIA - IDENTIFICAR ARMAZEM DESTINO
	If len(Alltrim(cDoc)) == 11 // OP
		SD4->(DbSetOrder(2)) // OP + PRODUTO
		IF SD4->(DBSEEK(XFILIAL("SD4") + Padr(cDoc,14) + cProduto ))
			cLocal := SD4->D4_LOCAL
		Endif	
	else
		SC6->(DbSetOrder(1)) //  PEDIDO + ITEM + PRODUTO
		IF SC6->(DBSEEK(XFILIAL("SC6") + Padr(cDoc,8) + cProduto ))
			cLocal := SC6->C6_LOCAL
		Endif	
	ENDIF
	// FMT - CONSULTORIA - IDENTIFICAR ARMAZEM DESTINO

	SB2->(DbSetOrder(1))
	SB2->(DbSeek(cFilialSB2+cProduto + cLocal)) 	//renato/leo  ajustado em 10/04/13

	PA2->(DbSetOrder(3))
	If PA2->(DbSeek(xFilial('PA2')+cDoc+cProduto+cFilialRes))
		PA2->(RecLock('PA2',.F.))
		If cOper =="+"
			PA2->PA2_QUANT+=nQtde  //AUMENTA A FALTA
		Else
			PA2->PA2_QUANT-=nQtde  //DIMINUI A FALTA
		EndIf
		If Empty(PA2->PA2_QUANT)
			PA2->(DbDelete())
		EndIf
		PA2->(MsUnlock())
		PA2->(DbCommit())
		if SB2->(DbSeek(cFilialSB2+cProduto + cLocal)) 
			If cFilAnt ==cFilialRes .and. cTipDoc == '1'
				GravaB2Emp(cOper,nQtde,,.T.)
			EndIf
		Endif	
	Else
		If cOper =="+"
			PA2->(RecLock('PA2',.T.))
			PA2->PA2_FILIAL	:= xFilial('PA2')
			PA2->PA2_CODPRO	:= cProduto
			PA2->PA2_DOC		:= cDoc
			PA2->PA2_TIPO		:= If(len(Alltrim(cDoc))==11,"2","1")
			PA2->PA2_FILRES		:=cFilialRes
			PA2->PA2_QUANT		:=nQtde
			PA2->PA2_OBS		:= TIME()+" - "+ dtoc(date()) +' - '+ Upper(FunName())
			PA2->(MsUnlock())
			PA2->(DbCommit())
			if SB2->(DbSeek(cFilialSB2+cProduto + cLocal)) 
				If cFilAnt ==cFilialRes .and. cTipDoc == '1'
					GravaB2Emp(cOper,nQtde,,.T.)
				EndIf
			Endif
		EndIf
	EndIf

	RestArea(aPA2Area)
	RestArea(aSB1Area)
	RestArea(aSB2Area)
	RestArea(aSD4Area)
	RestArea(aSC6Area)
	RestArea(aArea)
Return

User Function STFalta(cDoc,cProduto,nQtde,cOper)
	Local aArea := GetArea()
	Local aPA1Area := PA1->(GetArea())
	Local cQuery   := ""
	Local cAlias 		:= "QRYTEMP"
	Default cOper := "+"

	cDoc:= Padr(cDoc,11)

	PA1->(DbSetOrder(3))
	If PA1->(DbSeek(xFilial('PA1')+cDoc+cProduto))
		PA1->(RecLock('PA1',.F.))
		If cOper =="+"
			PA1->PA1_QUANT+=nQtde
		Else
			PA1->PA1_QUANT-=nQtde
		EndIf
		If Empty(PA1->PA1_QUANT) .or. PA1->PA1_QUANT < 0
			PA1->(DbDelete())
		EndIf
		PA1->(MsUnlock())
		PA1->(DbCommit())
	Else
		If cOper =="+"
			PA1->(RecLock('PA1',.T.))
			PA1->PA1_FILIAL	:= xFilial('PA1')
			PA1->PA1_CODPRO	:= cProduto
			PA1->PA1_DOC		:= cDoc
			PA1->PA1_TIPO		:= If(len(Alltrim(cDoc))==11,"2","1")
			PA1->PA1_QUANT		:=nQtde
			PA1->(MsUnlock())
			PA1->(DbCommit())
		EndIf
	EndIf
	//Validar se a falta ้ maior que o saldo [Renato - 280613]
	If PA1->PA1_TIPO=="1"

		cQuery := " SELECT C6_NUM, C6_QTDVEN-C6_QTDENT SALDO"
		cQuery += " FROM " +RetSqlName("SC6") "
		cQuery += " WHERE D_E_L_E_T_=' ' AND C6_FILIAL='"+xFilial("SC6")+"' AND C6_NUM='"+SubStr(cDoc,1,6)+"' AND C6_ITEM='"+SubStr(cDoc,7,2)+"' "

	ElseIf PA1->PA1_TIPO=="2"

		cQuery := " SELECT D4_OP, SUM(D4_QUANT) SALDO "
		cQuery += " FROM " +RetSqlName("SD4") "
		cQuery += " WHERE D_E_L_E_T_=' ' AND D4_FILIAL='"+xFilial("SD4")+"' AND D4_OP='"+cDoc+"' AND D4_COD='"+cProduto+"' "
		cQuery += " GROUP BY D4_OP "

	Else

		RestArea(aPA1Area)
		RestArea(aArea)
		Return
	EndIf

	If !Empty(Select(cAlias))
		DbSelectArea(cAlias)
		(cAlias)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())

	If PA1->PA1_QUANT > (cAlias)->SALDO
		RecLock('PA1',.F.)
		PA1->PA1_QUANT	:= (cAlias)->SALDO
		PA1->(MsUnlock())
		PA1->(DbCommit())
	EndIf
	//Validar se a falta ้ maior que o saldo [Renato - 280613]

	If cEmpAnt=="11"
		If IsInCallStack("U_TransRes")
			U_STFAT630(PA1->PA1_CODPRO)
		ElseIf IsInCallStack("A410ALTERA")
			U_STFAT630(PA1->PA1_CODPRO,PA1->PA1_DOC)
		EndIf
	EndIf

	(cAlias)->(DbCloseArea())

	RestArea(aPA1Area)
	RestArea(aArea)
Return

User Function STGetFal(cDoc,cProduto)
	Local nRet := 0
	Local aArea := GetArea()
	Local aPA1Area := PA1->(GetArea())
	cDoc:= Padr(cDoc,11)

	PA1->(DbSetOrder(3))
	If PA1->(DbSeek(xFilial('PA1')+cDoc+cProduto))
		nRet := PA1->PA1_QUANT
	Endif

	RestArea(aPA1Area)
	RestArea(aArea)
Return nRet

User Function STGetRes(cDoc,cProduto,cFilialRes)
	Local aArea := GetArea()
	Local aPA2Area := PA2->(GetArea())
	Local nRet:=0
	cDoc:= Padr(cDoc,11)
	PA2->(DbSetOrder(3))
	If PA2->(DbSeek(xFilial('PA2')+cDoc+cProduto+cFilialRes))
		nRet:= PA2->PA2_QUANT
	EndIf
	RestArea(aPA2Area)
	RestArea(aArea)
Return nRet

//Grava a Falta ou reserVA
User Function STGrvFR(cChave,cProduto,nQtde,cLocal)
	Local nQFalta		:= 0
	Local aSaldoIt		:= {}
	Local nI       		:= 0
	Local nY			:= 0
	Local cFilDP 		:= Right(AllTrim(GetMV("FS_DEPOSIT")),2)
	Local aFiliais 		:= {cFilAnt,cFilDP}
	Local nSldRes		:= 0
	Local nSldDisp 		:= 0
	Local _cGrpStella 	:= GetMv("ST_QUANV01",,'105')   // STELLA GIOVANI.ZAGO 02/09/14
	Local _nStella	  	:= 0   // STELLA GIOVANI.ZAGO 02/09/14
	DEFAULT cLocal      := ""

	If nQtde > 0 //Incluir quantidade do item
		For nY := 1 to 2
			aSaldoIt	:= {}
			U_STFSVE50(cProduto,aFiliais[nY],cLocal,aSaldoIt )
			For nI:=1 to len(aSaldoIt)
				If ! aSaldoIt[nI,4]
					Loop
				EndIf
				nSldDisp := aSaldoIt[nI,3]
				/*
				// STELLA GIOVANI.ZAGO 02/09/14
				DbSelectArea("SA1")
				SA1->(dbSetOrder(1))
				If SA1->(DbSeek(xFilial("SA1")+ SC5->C5_CLIENTE + SC5->C5_LOJACLI))
					If SA1->A1_GRPVEN <> 'ST' .And. SA1->A1_GRPVEN <> 'SC'
				DbSelectArea("SB1")
				SB1->(dbSetOrder(1))
						If		SB1->(DbSeek(xFilial("SB1")+Alltrim(cProduto)  ))
							If Alltrim(SB1->B1_GRUPO) $ _cGrpStella
								If !Empty(Alltrim( SC5->C5_XSTELLA ))
				_nStella:= U_STSBFSTELLA (SB1->B1_COD, Substr(SC5->C5_XSTELLA,1,1) )
				nSldDisp := _nStella-U_STSLDPA2(cProduto,cFilAnt,"1")  //Ajustado em 29/01/2016 pois nใo estava tirando a reserva do saldo - Chamado 003312
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
				//****************************************************************************
				/*/ //GIOVANI ZAGO DESABILITEI 30/12/17
				If nSldDisp <= 0
					Loop
				EndIf
				If nSldDisp >= nQtde
					U_STReserva(cChave,cProduto,nQtde,"+",aSaldoIt[nI,1])
					u_LOGJORPED("PA1","4",SC6->C6_PRODUTO,SC6->C6_ITEM,SC6->C6_NUM,"","Liberacao estoque")
					nQtde:= 0
				Else
					U_STReserva(cChave,cProduto,nSldDisp,"+",aSaldoIt[nI,1])
					nQtde -= nSldDisp
				Endif
				If nQtde == 0
					Exit
				Endif
			Next
			If nQtde == 0
				Exit
			Endif
		Next

		If nQtde > 0
			U_STFalta(cChave,cProduto,nQtde,"+")
			//u_LOGJORPED("PA1","1",SC6->C6_PRODUTO,SC6->C6_ITEM,SC6->C6_NUM,"","Falta item")
		Endif

	Elseif nQtde < 0 //Excluir quantidade do item

		nQtde *= -1
		nQFalta := U_STGetFal(cChave,cProduto)

		If nQFalta >= nQtde
			U_STFalta(cChave,cProduto,nQtde,"-")
		Else
			U_STFalta(cChave,cProduto,nQFalta,"-")
			nQtde-=nQFalta
			For nI:= 2 to 1 Step -1
				If Empty(nQtde)
					Exit
				EndIf
				nSldRes:= U_STGetRes(cChave,cProduto,aFiliais[nI])
				If nSldRes > 0
					If nSldRes >= nQtde
						U_STReserva(cChave,cProduto,nQtde,"-",aFiliais[nI])
						nQtde:= 0
					Else
						U_STReserva(cChave,cProduto,nSldRes,"-",aFiliais[nI])
						nQtde -= nSldRes
					Endif
				EndIf
			Next
		Endif
	Endif
Return

User Function STDelFR(cChave,cProduto)
	Local cFilDP 	:= Right(AllTrim(GetMV("FS_DEPOSIT")),2)
	Local nQtde		:= 0

	nQtde := U_STGetFal(cChave,cProduto)
	If ! Empty(nQtde)
		U_STFalta(cChave,cProduto,nQtde,"-")
	EndIf

	nQtde := U_STGetRes(cChave,cProduto,cFilAnt)
	If ! Empty(nQtde)
		U_STReserva(cChave,cProduto,nQtde,"-",cFilAnt)
	EndIf

	nQtde := U_STGetRes(cChave,cProduto,cFilDP)
	If ! Empty(nQtde)
		U_STReserva(cChave,cProduto,nQtde,"-",cFilDP)
	EndIf
Return

User Function STDelDoc(cDoc)
	Local aArea 	:= GetArea()
	Local aPA1Area := PA1->(GetArea())
	Local aPA2Area := PA2->(GetArea())
	Local cFilRes	:= ""
	Local cProduto	:= ""
	Local nQtde		:= 0

	cDoc:= Padr(cDoc,11)

	// Elimina as faltas
	PA1->(DbSetOrder(3))
	While PA1->(DbSeek(xFilial('PA1')+cDoc))
		cProduto:= PA1->PA1_CODPRO
		nQtde := U_STGetFal(cDoc,cProduto)
		U_STFalta(cDoc,cProduto,nQtde,"-")
	End

	// Elimina as Reservas
	PA2->(DbSetOrder(3))
	While PA2->(DbSeek(xFilial('PA2')+cDoc))
		cProduto	:= PA2->PA2_CODPRO
		cFilRes	:= PA2->PA2_FILRES
		nQtde := U_STGetRes(cDoc,cProduto,cFilRes)
		U_STReserva(cDoc,cProduto,nQtde,"-",cFilRes)
	End

	RestArea(aPA2Area)
	RestArea(aPA1Area)
	RestArea(aArea)
Return

User Function STSldRes(cProduto,cFilialRes)
	Local aArea := GetArea()
	Local aPA2Area := PA2->(GetArea())
	Local nRet:=0

	PA2->(DbSetOrder(1))
	PA2->(DbSeek(xFilial('PA2')+cProduto+cFilialRes))
	While PA2->(! Eof() .and. PA2_FILIAL+PA2_CODPRO+PA2_FILRES ==xFilial('PA2')+cProduto+cFilialRes)
		nRet+= PA2->PA2_QUANT
		PA2->(DbSkip())
	End
	RestArea(aPA2Area)
	RestArea(aArea)
Return nRet

User Function STSldPV(cProduto,cFilialRes,cLocal)
	Local aArea := GetArea()
	Local aPA2Area := PA2->(GetArea())
	Local nRet:=0
	Local _cQuery1 := ""
	Local _cAlias1 := GetNextAlias()
	Default cLocal := ""

	If Empty(cLocal)
		PA2->(DbSetOrder(1))
		PA2->(DbSeek(xFilial('PA2')+cProduto+cFilialRes))
		While PA2->(! Eof() .and. PA2_FILIAL+PA2_CODPRO+PA2_FILRES ==xFilial('PA2')+cProduto+cFilialRes)
			IF PA2->PA2_TIPO == '1'
				nRet+= PA2->PA2_QUANT
			Endif
			PA2->(DbSkip())
		End
	Else

		_cQuery1 := " SELECT NVL(SUM(PA2_QUANT),0) QTDRES
		_cQuery1 += " FROM "+RetSqlName("PA2")+" PA2
		_cQuery1 += " LEFT JOIN "+RetSqlName("SC6")+" C6
		_cQuery1 += " ON C6_FILIAL=PA2_FILRES AND C6_NUM||C6_ITEM=PA2_DOC
		_cQuery1 += " WHERE PA2.D_E_L_E_T_=' ' AND C6.D_E_L_E_T_=' ' 
		_cQuery1 += " AND PA2_TIPO='1' AND PA2_CODPRO='"+cProduto+"' AND PA2_FILRES='"+cFilialRes+"'
		_cQuery1 += " AND C6_LOCAL='"+cLocal+"'

		If !Empty(Select(_cAlias1))
			DbSelectArea(_cAlias1)
			(_cAlias1)->(dbCloseArea())
		Endif

		DbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery1),_cAlias1,.T.,.T.)

		dbSelectArea(_cAlias1)
		(_cAlias1)->(dbGoTop())

		nRet := (_cAlias1)->QTDRES

		(_cAlias1)->(dbCloseArea())

	EndIf
	RestArea(aPA2Area)
	RestArea(aArea)
Return nRet

User Function STResOP(cProduto,_cFilx)												// retorna qtde de reserva por produto
	Local aArea := GetArea()
	Local aPA2Area := PA2->(GetArea())
	Local nRet:=0

	PA2->(DbSetOrder(1))
	PA2->(DbSeek(xFilial('PA2')+cProduto+_cFilx))
	While PA2->(! Eof() .and. PA2_FILIAL+PA2_CODPRO+PA2_FILRES ==xFilial('PA2')+cProduto+_cFilx)
		If len(Alltrim(PA2->PA2_DOC))==11
			nRet+= PA2->PA2_QUANT
		EndIf
		PA2->(DbSkip())
	End
	RestArea(aPA2Area)
	RestArea(aArea)
Return nRet

// retorna qtde de falta por produto
User Function STResFalta(cProduto)
	Local aArea := GetArea()
	Local aPA1Area := PA1->(GetArea())
	Local nRet:=0

	PA1->(DbSetOrder(1))
	PA1->(DbSeek(xFilial('PA1')+cProduto))
	While PA1->(! Eof() .and. PA1_FILIAL+PA1_CODPRO ==xFilial('PA1')+cProduto)
		nRet+= PA1->PA1_QUANT
		PA1->(DbSkip())
	End

	RestArea(aPA1Area)
	RestArea(aArea)
Return nRet

User Function STResSDC(cProduto,_cLocal)												// retorna qtde de reserva por produto
	Local aArea 	:= GetArea()
	Local aSDCArea := SDC->(GetArea())
	Local nRet		:=0
	Local cLocPad	:= Posicione("SB1",1,xFilial('SB1')+cProduto,"B1_LOCPAD")
	Local _cQuery1 := ""
	Local _cAlias1 := GetNextAlias()
	Default _cLocal := ""

	If Empty(_cLocal)

		SDC->(DbSetOrder(1))
		SDC->(DbSeek(xFilial('SDC')+cProduto))
		While SDC->(! Eof() .and. DC_FILIAL+DC_PRODUTO+DC_LOCAL ==xFilial('SDC')+cProduto+cLocPad)
			nRet+= SDC->DC_QUANT
			SDC->(DbSkip())
		End

	Else

		_cQuery1 := " SELECT NVL(SUM(DC_QUANT),0) QTDDC
		_cQuery1 += " FROM "+RetSqlName("SDC")+" DC
		_cQuery1 += " WHERE DC.D_E_L_E_T_=' ' 
		_cQuery1 += " AND DC_PRODUTO='"+cProduto+"' 
		_cQuery1 += " AND DC_LOCAL='"+_cLocal+"' 
		_cQuery1 += " AND DC_FILIAL='"+xFilial("SDC")+"'

		If !Empty(Select(_cAlias1))
			DbSelectArea(_cAlias1)
			(_cAlias1)->(dbCloseArea())
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

		dbSelectArea(_cAlias1)

		(_cAlias1)->(dbGoTop())

		nRet := (_cAlias1)->QTDDC

		(_cAlias1)->(DbCloseArea())

	EndIf

	RestArea(aSDCArea)
	RestArea(aArea)
Return nRet

User Function STGrvSt(cDoc,lParcial)
	Local cTipDoc 		:= If(len(Alltrim(cDoc))==11,"2","1")
	Local aArea 		:= GetArea()
	Local aPA1Area 	:= PA1->(GetArea())
	Local aPA2Area 	:= PA2->(GetArea())
	Local aSC5Area 	:= SC5->(GetArea())
	Local aSC2Area 	:= SC2->(GetArea())
	Local cStatus 		:= "0" // Legenda PRETO nao tem controle de reserva
	Local cFilDP 		:= Right(AllTrim(GetMV("FS_DEPOSIT")),2)
	Local cDocSeek		:= ""

	Local lTemFalta 	:= .f.
	Local lTemDF		:= .f.
	Local lTemReserva := .f.

	If cTipDoc == "1" // necessario estar posicionado
		cDocSeek := Left(cDoc,6)
		If Left(cDoc,6) <> SC5->(C5_NUM)
			SC5->(DbSetOrder(1))
			SC5->(DbSeek(xFilial('SC5')+cDocSeek))
		EndIf
	Else   // OP
		cDocSeek :=Left(cDoc,11)
		If Left(cDoc,11)  <> SC2->(C2_NUM+C2_ITEM+C2_SEQUEN)
			SC2->(DbSetOrder(1))
			SC2->(DbSeek(xFilial('SC2')+cDocSeek))
		EndIf
	EndIf

	If lParcial == NIL
		If cTipDoc == "1" // necessario estar posicionado
			lParcial := SC5->C5_XTIPF == '2'
		Else   // OP
			lParcial := .T.
		EndIf
	EndIf

	// analista o status do documento
	PA1->(DBSetOrder(3))
	PA2->(DBSetOrder(4))

	lTemFalta 	:= PA1->(DBSeek(xFilial('PA1')+cDocSeek))
	lTemDF		:= PA2->(DBSeek(xFilial('PA2')+cFilDP+cDocSeek))
	lTemReserva := PA2->(DBSeek(xFilial('PA2')+cFilAnt+cDocSeek))

	If ! lTemFalta .and. ! lTemDF .and. lTemReserva
		cStatus := "1"	 // Legenda VERDE	ou seja estแ reservado apto para gerar ordem de separacao
	ElseIf lTemFalta .and. ! lTemDF .and. ! lTemReserva
		cStatus := "2"	 // Legenda VERMELHO	ou seja estแ todo em falta
	ElseIf !lTemFalta .and.  lTemDF .and. ! lTemReserva
		cStatus := "3" //Legenda Amarelo ou seja tem falta tambem tenho deposito fechado e posso atender parcial
	Else
		If !lParcial .and. lTemFalta
			cStatus := "2" //Legenda VERMELHO
		Else//If lTemDF //.and. (lTemFalta .or. lTemReserva)
			If lTemFalta
				If lParcial
					cStatus := "3" //Legenda Amarelo ou seja tem falta tambem tenho deposito fechado e posso atender parcial
				Else
					cStatus := "2" //Legenda VERMELHO
				Endif
			Else
				cStatus := "3" //Legenda Amarelo ou seja tem falta tambem tenho deposito fechado e posso atender parcial
			Endif

			If lTemReserva .and. lTemFalta
				If lParcial
					cStatus := "4" //Legenda Azul ou seja tem falta tambem reserva e posso atender parcial
				Else
					cStatus := "2" //Legenda VERMELHO
				EndIf
			EndIf
		EndIf
	EndIf

	If cTipDoc == "1" // necessario estar posicionado
		If !SC5->(Eof())
			SC5->(RecLock('SC5',.F.))
			SC5->C5_XSTARES:= cStatus
			SC5->(MsUnLock())
			SC5->(DbCommit())
		EndIf
	Else   // OP
		If !SC2->(Eof())
			SC2->(RecLock('SC2',.F.))
			SC2->C2_XSTARES:= cStatus
			SC2->(MsUnLock())
			SC2->(DbCommit())
		EndIf
	EndIf

	RestArea(aSC5Area)
	RestArea(aSC2Area)
	RestArea(aPA2Area)
	RestArea(aPA1Area)
	RestArea(aArea)

Return()

User Function STPriSC2()  // grava prioridade
	Local aArea 		:= GetArea()
	Local aSC2Area 	:= SC2->(GetArea())
	Local cDtEntrega  := Dtos(SC2->C2_DATPRF)
	Local cPriori		:= "2"+cDtEntrega+"ZZZZZ"
	Local nRecno		:= SC2->(Recno())

	SC2->(DbOrderNickName("STFSSC201"))
	SC2->(DbSeek(xFilial('SC2')+cPriori,.T.))
	SC2->(DbSkip(-1))
	If xFilial('SC2')+cDtEntrega == SC2->(C2_FILIAL+Dtos(C2_DATPRF))
		If ! Empty(SC2->C2_XPRIORI)
			cPriori		:= Soma1(SC2->C2_XPRIORI)
		Else
			cPriori		:= "2"+cDtEntrega+"20001"
		EndIf
	Else
		cPriori		:= "2"+cDtEntrega+"20001"
	EndIf
	SC2->(DbGoto(nRecno))
	SC2->(RecLock('SC2',.F.))
	SC2->C2_XPRIORI:= cPriori
	SC2->(MsUnLock())
	SC2->(DbCommit())
	RestArea(aSC2Area)
	RestArea(aArea)
Return ()

User Function STPriSC5()

	Local aArea 		:= GetArea()
	Local aSC5Area 		:= SC5->(GetArea())
	Local cTipFat		:= SC5->C5_XTIPO // 1=RETIRA; 2=ENTREGA
	Local cDtEntrega    := dtos(Date())  //Dtos(SC5->C5_XDTEN)
	Local cPriori		:= cTipFat+cDtEntrega+"10001"
	Local nRecno		:= SC5->(Recno())

	cPriori := SubStr(Dtos(SC5->C5_EMISSAO),3,6)+cValToChar(nRecno)

	SC5->(DbGoto(nRecno))
	SC5->(RecLock('SC5',.F.))

	If SC5->C5_XSTARES == "0"
		SC5->C5_XPRIORI:= ""
	Else
		If Empty(SC5->C5_XPRIORI)
			SC5->C5_XPRIORI:= cPriori
		EndIf
	Endif

	SC5->(MsUnLock())
	SC5->(DbCommit())
	RestArea(aSC5Area)
	RestArea(aArea)

Return()

User Function STPriCB7(cArmExp,cCodOpe)

	Local aArea 		:= GetArea()
	Local aCB7Area 	:= CB7->(GetArea())
	Local cPriori		:= '2'+Dtos(dDatabase)+"ZZZZZ"
	Local nRecno		:= CB7->(Recno())

	//CB7_FILIAL+CB7_LOCAL+CB7_XSEP+CB7_CODOPE+CB7_XPRIOR
	CB7->(DbOrderNickName("STFSCB702"))
	CB7->(DbSeek(xFilial('CB7')+cArmExp+'2'+cCodOpe+cPriori,.T.))
	CB7->(DbSkip(-1))
	If xFilial('CB7')+cArmExp+'2'+cCodOpe == CB7->(CB7_FILIAL+CB7_LOCAL+CB7_XSEP+CB7_CODOPE)
		If ! Empty(CB7->CB7_XPRIOR)
			cPriori		:= Soma1(CB7->CB7_XPRIOR)
		Else
			cPriori		:= '2'+Dtos(dDatabase)+"00001"
		EndIf
	Else
		cPriori		:= '2'+Dtos(dDatabase)+"00001"
	EndIf
	CB7->(DbGoto(nRecno))
	CB7->(RecLock('CB7',.F.))
	CB7->CB7_XPRIOR:= cPriori
	CB7->(MsUnLock())
	CB7->(DbCommit())
	RestArea(aCB7Area)
	RestArea(aArea)
Return ()

User Function STGeraSDC(cDoc,cProduto,cArm,nReserva,nRecno,aSD4,cOrdSep)

	Local cTipDoc 	:= Iif(len(Alltrim(cDoc))==11,"2","1")
	Local aSaldos	:= {}
	Local lUsaVenc	:= SuperGetMv('MV_LOTVENC')=='S'
	Local _cGrpStella 	:= GetMv("ST_QUANV01",,'105')   // STELLA GIOVANI.ZAGO 02/09/14

	If cTipDoc = "1" // pedido

		SC6->(DbGoto(nRecno))
		SC9->(DbSetOrder(1)) //C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_SEQUEN+C9_PRODUTO
		If SC9->(DbSeek(xFilial("SC9")+SC6->(C6_NUM+C6_ITEM)))
			While SC9->(! Eof() .and. SC9->(C9_FILIAL+C9_PEDIDO+C9_ITEM) == xFilial("SC9")+SC6->(C6_NUM+C6_ITEM))
				If Empty(SC9->C9_ORDSEP) .and. Empty(SC9->C9_NFISCAL) //140413 RENATO
					a460Estorna() // Estorna o item liberado
					//Exit
				EndIf
				SC9->(DbSkip())
			End
		EndIf

		If cEmpAnt=="11" .And. cFilAnt=="01"
			aSaldos := U_SLDSTECK(SC6->C6_PRODUTO,SC6->C6_LOCAL,nReserva,ConvUm(SC6->C6_PRODUTO,2,0,nReserva),SC6->C6_LOTECTL,SC6->C6_NUMLOTE,SC6->C6_LOCALIZ,SC6->C6_NUMSERI,NIL,NIL,NIL,lUsaVenc,nil,nil,dDataBase)
		Else
			If Rastro(SC6->C6_PRODUTO)
				aSaldos := SldPorLote(SC6->C6_PRODUTO,SC6->C6_LOCAL,nReserva,ConvUm(SC6->C6_PRODUTO,2,0,nReserva),SC6->C6_LOTECTL,SC6->C6_NUMLOTE,SC6->C6_LOCALIZ,SC6->C6_NUMSERI,NIL,NIL,NIL,lUsaVenc,nil,nil,dDataBase)
			Else

				If len(aSaldos) = 0

					aSaldos := {{ "","","","",nReserva,ConvUm(SC6->C6_PRODUTO,2,0,nReserva),Ctod(""),"","","",cArm,0}}
				EndIf
			Endif
		EndIf

		MaLibDoFat(SC6->(Recno()),nReserva,.T.,.T.,.F.,.F.,.T.,.F.,Nil,{||SC9->C9_ORDSEP:= cOrdSep },aSaldos,Nil,Nil,Nil)
		MaLiberOk({SC6->C6_NUM},.F.)
		MsUnLockall()

		SC6->(DbGoto(nRecno)) // Linha adicionada pelo Richard - RVG, pois ap๓s a atualiza็ใo da LIB e Patchs, o sistema se perdia na tabela SC6.

		_nSaldoCB8	:= 0 						//[RENATO 150513] - Considerar CB8 para gerar o saldo

		CB8->(DbSetOrder(2))
		If	CB8->(DbSeek(xFilial("SC9")+SC9->(C9_PEDIDO+C9_ITEM)))  //CB8_FILIAL+CB8_PEDIDO+CB8_ITEM+CB8_SEQUEN+CB8_PROD
			While CB8->(! Eof() .and. CB8->(CB8_FILIAL+CB8_PEDIDO+CB8_ITEM) == xFilial("SC9")+SC9->(C9_PEDIDO+C9_ITEM))
				_nSaldoCB8	+=	CB8->CB8_QTDORI
				CB8->(DbSkip())
			End
		Endif
		//	nSaldoPed := SC6->C6_QTDVEN - SC6->C6_QTDENT - nReserva   //verifica se sobrou saldo no item para separa็ใo
		nSaldoPed := SC6->C6_QTDVEN - _nSaldoCB8 - nReserva   //verifica se sobrou saldo no item para separa็ใo //[RENATO 150513] - Considerar CB8 para gerar o saldo

		// Leonardo Flex -> analisar se gerou SDC, caso nao tenha gerado limpar o campo C9_ORDSEP e gravar o campo C9_BLEST como bloqueado por estoque 020513
		SDC->(DbSetOrder(1)) //DC_FILIAL+DC_PRODUTO+DC_LOCAL+DC_ORIGEM+DC_PEDIDO+DC_ITEM+DC_SEQ+DC_LOTECTL
		SC9->(DbSetOrder(1)) //C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_SEQUEN+C9_PRODUTO
		If	SC9->(DbSeek(xFilial("SC9")+SC6->(C6_NUM+C6_ITEM)))
			While SC9->(! Eof() .and. SC9->(C9_FILIAL+C9_PEDIDO+C9_ITEM) == xFilial("SC9")+SC6->(C6_NUM+C6_ITEM))
				If !SDC->( dbSeek(xFilial("SDC")+SC9->C9_PRODUTO+SC9->C9_LOCAL+"SC6"+SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_SEQUEN))
					If !Empty(SC9->C9_ORDSEP) .And. Empty(SC9->C9_NFISCAL)
						SC9->(RecLock("SC9",.F.))
						SC9->C9_ORDSEP := ""
						SC9->C9_BLEST := "02"
						SC9->(MsUnlock())
						SC9->(DbCommit())
					EndIf
				EndIf
				SC9->(DbSkip())
			End
		EndIf
		If nSaldoPed > 0 //se o saldo do item forma maior que zero, entใo deve gerar uma outra libera็ใo com o sc9 bloqueado

			If Len(aSaldos) > 0
				aSaldos[1][5] := nSaldoPed
			Else 
				//array vazio
			Endif 
			//GIOVANI ZAGO TIREI O ASALDO PRECISA REAVALIAR 15/06/15
			MaLibDoFat(SC6->(Recno()),nSaldoPed,.T.,.F.,.F.,.F.,.T.,.F.,Nil,{||SC9->C9_ORDSEP:= "" },NIL,Nil,Nil,Nil)
			MaLiberOk({SC6->C6_NUM},.F.)
			MsUnLockall()
			SC6->(DbGoto(nRecno))
		EndIf
	Else
		SD4->(DbGoto(nRecno))
		AtuSD4(cDoc,cProduto,cArm,nReserva,aSD4,cOrdSep)
		MsUnLockall()
	EndIf

Return()

User Function STDelSDC(cDoc,cProduto,cOrdSep,nRecno,lLibPV)
	Local cTipDoc 	:= If(len(Alltrim(cDoc))==11,"2","1")
	Local aArea		:= GetArea()
	Local aAreaSC5	:= SC5->(GetArea())
	Local aAreaSC6	:= SC6->(GetArea())
	Local aAreaSC9	:= SC9->(GetArea())
	Local aAreaSD4	:= SD4->(GetArea())
	Local cOP		:= ""
	Local aTravas	:={}
	Local nQtde		:=0
	Local aSaldos	:={}

	Default nRecno	:= 0
	Default lLibPV	:= .T.


	If cTipDoc == "1" // pedido
		SC5->(DbSetorder(1))
		SC5->(DbSeek(xFilial('SC5')+CB8->CB8_PEDIDO))
		SC6->(DbSetOrder(1))
		If nRecno > 0
			SC6->(DbGoTo(nRecno))
		Else
			SC6->(DbSeek(xFilial('SC6')+CB8->(CB8_PEDIDO+CB8_ITEM))	)
		Endif
		
		SC9->(DbSetOrder(1)) //C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_SEQUEN+C9_PRODUTO
		If SC9->(DbSeek(xFilial("SC9")+CB8->(CB8_PEDIDO+CB8_ITEM+CB8_SEQUEN ))) .and. SC9->C9_ORDSEP == cOrdSep
			nQtde	:= SC9->C9_QTDLIB
			a460Estorna() // Estorna o item liberado

			SC9->(RecLock('SC9',.F.))
			SC9->C9_ORDSEP:=""
			SC9->(MsUnlock())
			SC9->(DbCommit())
			If lLibPV
				aSaldos := {{ "","","","",nQtde,ConvUm(SC6->C6_PRODUTO,0,2,nQtde),Ctod(""),"","","",SC6->C6_LOCAL,0}}
				nRecno:= SC6->(Recno())
				MaLibDoFat(SC6->(Recno()),nQtde,.T.,.F.,.F.,.F.,.F.,.F.,Nil,/*{||SC9->C9_ORDSEP:= "" }*/,aSaldos,Nil,Nil,Nil)
				MaLiberOk({SC6->C6_NUM},.F.)
				MsUnLockall()
				SC6->(DbGoto(nRecno))
			Endif
		Endif

		MsUnLockAll()
	Else
		cOP	:= Padr(cDoc,14)
		SD4->(DbSetOrder(2))
		If nRecno > 0
			SD4->(DbGoTo(nRecno))
		Else
			SD4->(DbSeek(xFilial('SD4')+cOP+cProduto))
		Endif
		While SD4->(! Eof() .and. D4_FILIAL+D4_OP+D4_COD == xFilial('SD4')+cOP+cProduto)
			/*/
			If Alltrim(SD4->D4_LOCAL) == Alltrim(GetMV("MV_LOCPROC"))    //GALLO GRAVAEMP
				SD4->(DBSkip())
				Loop
			EndIf
			/*/
			If SD4->D4_XORDSEP <> cOrdSep .and. nRecno == 0
				SD4->(DBSkip())
				Loop
			EndIf
			If nRecno > 0 .and. !(SD4->(Recno()) == nRecno)
				SD4->(DbSkip())
				Loop
			Endif
			GravaEmp(SD4->D4_COD,;      	// produto
			SD4->D4_LOCAL,;		// local
			SD4->D4_QUANT,;		// qtde 1 un
			NIL,;						// qtde 2 un
			SD4->D4_LOTECTL,;		// lote
			SD4->D4_NUMLOTE,;		// num lote
			NIL,;						// endere็o
			NIL,;						// numero de serie
			SD4->D4_OP,;			// op
			SD4->D4_TRT,;			// sequencia
			NIL,;						// pedido de venda
			NIL,;						// item do pedido
			"SC2",;					// origem
			NIL,;						// op original
			SD4->D4_DATA,;			// data de entrega
			@aTravas,;				// controle de travas nao sei o que faz
			.T.,;						// estorno
			NIL,;						// integracao PMS
			.T.,;              	// atualiz sb2
			.T.,;						// gera sd4
			NIL,;						// considera lote vencido
			.T.,;						// Empenha SB8 e SBF
			.T.)						//	CriaSDC
			MaDestrava(aTravas)
			SD4->(RecLock('SD4',.F.))
			SD4->D4_XORDSEP := ''
			SD4->(MsUnLock())
			SD4->(DbCommit())
			MsUnLockAll()
			SD4->(DbSkip())
		End
	EndIf

	RestArea(aAreaSD4)
	RestArea(aAreaSC9)
	RestArea(aAreaSC6)
	RestArea(aAreaSC5)
	RestArea(aArea)
Return

Static Function AtuSD4(cDoc,cCod,cArm,nReserva,aSD4Recno,cOrdSep,lTransf)
	Local aArea		:= GetArea()
	Local aAreaSD4	:= SD4->(GetArea())
	Local aOpOrig	:={}
	Local nTotal 	:=0
	Local aTravas 	:={}
	Local aOpOri	:={}
	Local nDif		:=0
	Local nX
	Local aSaldo	:={}
	Local aLotes	:={}
	Local cTRT		:={}
	Local aSD4		:={}
	Local cOP		:= Padr(cDoc,14)
	Local cAux		:= ""
	Local nPos		:= 0
	Default lTransf:= .F.

	SD4->(DbSetOrder(2))
	SD4->(DbSeek(xFilial('SD4')+cOP+cCod))
	cTRT	:= SD4->D4_TRT
	While SD4->(! Eof() .and. D4_FILIAL+D4_OP+D4_COD == xFilial('SD4')+cOP+cCod)
		/*/
		If Alltrim(SD4->D4_LOCAL) == Alltrim(GetMV("MV_LOCPROC"))    //GALLO GRAVAEMP
			SD4->(DBSkip())
			Loop
		EndIf
		/*/
		If ! Empty(SD4->D4_XORDSEP)
			SD4->(DBSkip())
			Loop
		EndIf
		aadd(aSD4,SD4->(Recno()))
		If ! Empty(SD4->D4_OPORIG)
			nPos := aScan(aOpOri,{|x| x[1]+x[2]+x[3]+x[4] == SD4->(D4_LOCAL+D4_LOTECTL+D4_NUMLOTE+D4_TRT)})
			If Empty(nPos)
				SD4->(aadd(aOpOri,{Iif(lTransf,cArm,D4_LOCAL),D4_LOTECTL,D4_NUMLOTE,D4_TRT,D4_DATA,D4_OPORIG}))
				//SD4->(aadd(aOpOri,{"90",D4_LOTECTL,D4_NUMLOTE,D4_TRT,D4_DATA,D4_OPORIG}))
				//Verificar SD4 depois que finalizar a opera็ใo e eliminar linha duplicada e somar quantidade na linha ๚nica
			EndIf
		EndIf
		nTotal += SD4->D4_QUANT
		SD4->(DbSkip())
	End

	For nX:= 1 to len(aSD4)
		// eliminar o sd4 original.
		SD4->(DbGoto(aSD4[nX]))
		GravaEmp(SD4->D4_COD,;      	// produto
		SD4->D4_LOCAL,;		// local
		SD4->D4_QUANT,;		// qtde 1 un  / gallo em 27/12/13
		NIL,;						// qtde 2 un
		SD4->D4_LOTECTL,;		// lote
		SD4->D4_NUMLOTE,;		// num lote
		NIL,;						// endere็o
		NIL,;						// numero de serie
		SD4->D4_OP,;			// op
		SD4->D4_TRT,;			// sequencia
		NIL,;						// pedido de venda
		NIL,;						// item do pedido
		"SC2",;					// origem
		NIL,;						// op original
		SD4->D4_DATA,;			// data de entrega
		@aTravas,;				// controle de travas nao sei o que faz
		.T.,;						// estorno
		NIL,;						// integracao PMS
		.T.,;              	// atualiz sb2
		.T.,;						// gera sd4
		NIL,;						// considera lote vencido
		.F.,;						// Empenha SB8 e SBF
		.T.)						//	CriaSDC
		MaDestrava(aTravas)
		SD4->(RecLock('SD4',.F.))
		SD4->(DbDelete())
		SD4->(MsUnlock())
		SD4->(DbCommit())
	Next

	nDif := nTotal - nReserva
	If nDif > 0   //giovani 5/2/13
		If len(aOpOri) > 0
			For nX:= 1 to len(aOpOri)
				//A650ReplD4(cCod,aOpOri[nX,1],dDataBase,nDif/len(aOpOri),cOp,cTrt,aOpOri[nX,3],aOpOri[nX,2],NIL,aOpOri[nX,6],aOpOri[nX,5])
				GravaEmp(cCod,;      					// produto
				aOpOri[nX,1],;					        // local
				nDif/len(aOpOri),;	  	          	    // qtde 1 un
				NIL,;							    	// qtde 2 un
				aOpOri[nX,2],;					// lote
				aOpOri[nX,3],;					// num lote
				NIL,;								// endere็o
				NIL,;								// numero de serie
				cOP,;								// op
				aOpOri[nX,4],;					// sequencia
				NIL,;								// pedido de venda
				NIL,;								// item do pedido
				"SC2",;							// origem
				aOpOri[nX,6],;					// op original
				aOpOri[nX,5],;					// data de entrega
				@aTravas,;						// controle de travas nao sei o que faz
				.F.,;								// estorno
				NIL,;								// integracao PMS
				.T.,;              			// atualiz sb2
				.T.,;								// gera sd4
				NIL,;				  				// considera lote vencido
				.T.,;								// Empenha SB8 e SBF
				.F.)								//	CriaSDC
				MaDestrava(aTravas)
			Next
		Else
			//A650ReplD4(cCod,cArm,dDataBase,nDif,cOp,cTrt,NIL,NIL,NIL,Repl("Z",13))
			GravaEmp(cCod	,;      					// produto
			cArm	,;							// local
			nDif	,;	  						// qtde 1 un
			NIL,;								// qtde 2 un
			Space(10),;						// lote
			Space(6),;						// num lote
			NIL,;								// endere็o
			NIL,;								// numero de serie
			cOP,;								// op
			cTRT,;							// sequencia
			NIL,;								// pedido de venda
			NIL,;								// item do pedido
			"SC2",;							// origem
			Repl("Z",13),;					// op original
			dDataBase,;					// data de entrega
			@aTravas,;						// controle de travas nao sei o que faz
			.F.,;								// estorno
			NIL,;								// integracao PMS
			.T.,;              			// atualiz sb2
			.T.,;								// gera sd4
			NIL,;				  				// considera lote vencido
			.T.,;								// Empenha SB8 e SBF
			.F.)								//	CriaSDC
			MaDestrava(aTravas)
		EndIf
	EndIf

	aSaldo := SldPorLote(cCod,cArm,nReserva)
	aLotes := {}
	For nX:= 1 to len(aSaldo)
		nPos := ascan(aLotes,{|x| x[1] == aSaldo[nX,1]})
		If nPos == 0
			aadd(aLotes,aClone(aSaldo[nx]))
		Else
			aLotes[nPos,5] +=	aSaldo[nx,5]
			aLotes[nPos,6] +=	aSaldo[nx,6]
		EndIf
	Next

	aSD4Recno:={}
	For nX:= 1 to len(aLotes)
		cAux := Subs(Dtos(dDatabase)+StrTran(Time(),":",""),2)

		//A650ReplD4(cCod,cArm,dDataBase,aLotes[nX,5],cOp,cTrt,aLotes[nX,2],aLotes[nX,1],aLotes[nX,7],cAux,aLotes[nX,6],aLotes[nX,12])
		GravaEmp(cCod,;      					// produto
		cArm,;							// local
		aLotes[nX,5],;					// qtde 1 un
		aLotes[nX,6],;					// qtde 2 un
		aLotes[nX,1],;					// lote
		aLotes[nX,2],;					// num lote
		NIL,;								// endere็o
		NIL,;								// numero de serie
		cOP,;								// op
		cTRT,;							// sequencia
		NIL,;								// pedido de venda
		NIL,;								// item do pedido
		"SC2",;							// origem
		cAux,;								// op original
		dDataBase,;						// data de entrega
		@aTravas,;						// controle de travas nao sei o que faz
		.F.,;								// estorno
		NIL,;								// integracao PMS
		.T.,;              			// atualiz sb2
		.T.,;								// gera sd4
		NIL,;				  				// considera lote vencido
		.T.,;								// Empenha SB8 e SBF
		.T.,;  							//	CriaSDC
		NIL,;                      // Encerra OP
		cOrdSep)							// ID DCF, estamos utilizando este campo nos espeficios no ACD
		MaDestrava(aTravas)
		aadd(aSD4Recno,SD4->(Recno()))
	Next
	RestArea(aArea)
	RestArea(aAreaSD4)
Return

User Function STGeraOS(cOrigem,cOrdSep,aSD4,cOrdAux,cArm,lDifArm)
	Local aArea		:= GetArea()
	Local aAreaSDC := SDC->(GetArea())
	Local aAreaCB7 := CB7->(GetArea())
	Local cArmExp 	:= GetMv("FS_ARMEXP")
	Local cArmEst 	:= GetMv("FS_ARMEST")
	Local cArmAnt	:= ""
	Local cArmSel

	Local nX

	//Default lDifArm	:= .F.

	If cOrigem == "SC5"
		// SC5 e SC6 estao posicionados
		SC9->(DbSetOrder(1)) //C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_SEQUEN+C9_PRODUTO
		SDC->(DbSetOrder(1)) //DC_FILIAL+DC_PRODUTO+DC_LOCAL+DC_ORIGEM+DC_PEDIDO+DC_ITEM+DC_SEQ+DC_LOTECTL
		SC9->(DbGoTop( ))
		If	SC9->(DbSeek(xFilial("SC9")+SC6->C6_NUM+SC6->C6_ITEM))
			While SC9->(! Eof()) .And. SC9->C9_FILIAL+SC9->C9_PEDIDO+SC9->C9_ITEM == xFilial("SC9")+SC6->C6_NUM+SC6->C6_ITEM
				If !(SC9->C9_ORDSEP == cOrdSep)
					SC9->(DbSkip())
					Loop
				Endif

				SDC->( dbSeek(xFilial("SDC")+SC9->C9_PRODUTO+SC9->C9_LOCAL+"SC6"+SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_SEQUEN))
				While SDC->(! Eof() .and. DC_FILIAL+DC_PRODUTO+DC_LOCAL+DC_ORIGEM+DC_PEDIDO+DC_ITEM+DC_SEQ==;
						xFilial("SDC")+SC9->(C9_PRODUTO+C9_LOCAL+"SC6"+C9_PEDIDO+C9_ITEM+C9_SEQUEN))
					SB1->(DBSetOrder(1))
					If SB1->(DbSeek(xFilial("SB1")+SDC->DC_PRODUTO)) .AND. Alltrim(SB1->B1_TIPO) == "MO"
						SDC->(DbSkip())
						Loop
					Endif
					//STGrvCB8("SC5",cOrdSep,cOrdAux,Iif(!lDifArm,cArmExp,"  "))
					STGrvCB8("SC5",cOrdSep,cOrdAux,cArm)
					If ! Empty(cOrdAux)
						STGrvAux("SC5",cOrdAux,Iif(!lDifArm,cArmEst,"  "),cOrdSep,cArmSel)
					EndIf
					SDC->(DbSkip())
				End

				SC9->(DbSkip())
			End
		EndIf
	Else
		cArmSel	:= "01"
		For nX:= 1 to len(aSD4)
			SD4->(DbGoto(aSD4[nX]))

			//		If Alltrim(SD4->D4_LOCAL) <> Alltrim(GetMV("MV_LOCPROC"))    //GALLO GRAVAEMP

			SDC->(DbSetOrder(2))
			SDC->( dbSeek(xFilial("SDC")+SD4->(D4_COD+D4_LOCAL+D4_OP+D4_TRT)))
			While SDC->(! Eof() .and. DC_FILIAL+DC_PRODUTO+DC_LOCAL+DC_OP+DC_TRT==;
					xFilial("SDC")+SD4->(D4_COD+D4_LOCAL+D4_OP+D4_TRT))
				SB1->(DBSetOrder(1))
				If SB1->(DbSeek(xFilial("SB1")+SDC->DC_PRODUTO)) .AND. Alltrim(SB1->B1_TIPO) == "MO"
					SDC->(DbSkip())
					Loop
				Endif
				If SDC->DC_IDDCF <> IIf(SD4->D4_LOCAL=="03",cOrdAux,cOrdSep) //alterado dia 20/06/13 [Renato Nogueira]
					//			If SDC->DC_IDDCF <> cOrdSep
					SDC->(DbSkip())
					Loop
				EndIf

				If Alltrim(SDC->DC_LOCAL)==Alltrim(cArmEst) //22042013 Renato OP duplicada
					STGrvCB8("SC2",cOrdSep,cOrdAux,Iif(!lDifArm,cArmEst,"  "))
				Endif										//22042013 Renato OP duplicada

				If ! Empty(cOrdAux)
					STGrvAux("SC2",cOrdAux,Iif(!lDifArm,cArmExp,"  "),cOrdSep,cArmSel)
				EndIf
				SDC->(DbSkip())
			End

			SD4->(RecLock("SD4"))
			If SD4->D4_LOCAL="01"
				SD4->D4_XORDSEP := cOrdSep
			ElseIf SD4->D4_LOCAL="03"
				SD4->D4_XORDSEP := cOrdAux
			EndIf
			SD4->(MsUnlock())
			SD4->(DbCommit())
			//		EndIf // GALLO GRAVAEMP

		Next
	EndIf
	RestArea(aAreaCB7)
	RestArea(aAreaSDC)
	RestArea(aArea)
Return

Static Function STGrvCB8(cOrigem,cOrdSep,cOrdAux,cArmSep)
	CB7->(DbSetOrder(1))
	If ! CB7->(DbSeek(xFilial("CB7")+cOrdSep))
		CB7->(RecLock( "CB7",.T.))
		CB7->CB7_FILIAL := xFilial("CB7")
		CB7->CB7_ORDSEP := cOrdSep
		CB7->CB7_XAUTSE := "1"
		If cOrigem == "SC5" 
			CB7->CB7_PEDIDO := SC9->C9_PEDIDO
			CB7->CB7_CLIENT := SC9->C9_CLIENTE
			CB7->CB7_LOJA   := SC9->C9_LOJA
			CB7->CB7_COND   := SC5->C5_CONDPAG
			CB7->CB7_LOJENT := SC5->C5_LOJAENT
			CB7->CB7_TRANSP := SC5->C5_TRANSP
			CB7->CB7_ORIGEM := "1"
			CB7->CB7_TIPEXP := "00*02*06*"
			CB7->CB7_XPRIAN := SC5->C5_XPRIORI

			//20190507000024
			If !U_STFAT340("4","T",.F.)
				SC5->(RecLock("SC5",.F.))
				SC5->C5_XREAN14  := "1"
				SC5->(MsUnLock())
			EndIf
			If !U_STFAT340("1","T",.F.)
				SC5->(RecLock("SC5",.F.))
				SC5->C5_XBLQROM  := "1"
				SC5->(MsUnLock())
			EndIf

		Else
			CB7->CB7_OP     := SD4->D4_OP
			CB7->CB7_ORIGEM := "3"
			CB7->CB7_TIPEXP := "00*"
			CB7->CB7_XPRIAN := SC2->C2_XPRIORI
		EndIf
	CB7->CB7_LOCAL  	:= cArmSep
	CB7->CB7_DTEMIS 	:= dDataBase
	CB7->CB7_HREMIS 	:= Time()
	CB7->CB7_STATUS 	:= " "
	CB7->CB7_CODOPE 	:= ""
	CB7->CB7_PRIORI 	:= "1"
	CB7->CB7_XSEP		:= "2"
	/*
	If cOrigem == "SC5"
	CB7->CB7_XOSFIL 	:= cOrdAux
	EndIf
	*/
	CB7->(MsUnlock())
	CB7->(DbCommit())
	U_STPriCB7(CB7->CB7_LOCAL,Space(6))
		u_LOGJORPED("CB7","5"," "," ",SC5->C5_NUM,"","Geracao OS")
	Endif

	CB8->(RecLock("CB8",.T.))
	CB8->CB8_FILIAL := xFilial("CB8")
	CB8->CB8_ORDSEP := CB7->CB7_ORDSEP
	CB8->CB8_PROD   := SDC->DC_PRODUTO
	CB8->CB8_LOCAL  := SDC->DC_LOCAL
	
	If cOrigem == "SC5"
		CB8->CB8_ITEM   := SC9->C9_ITEM
		CB8->CB8_PEDIDO := SC9->C9_PEDIDO
		CB8->CB8_SEQUEN := SC9->C9_SEQUEN
	Else
		CB8->CB8_OP     := SD4->D4_OP
		CB8->CB8_ITEM   := StrZero(CB7->CB7_NUMITE+1,2)
		CB8->CB8_SEQUEN := SD4->D4_TRT
	EndIf

	CB8->CB8_QTDORI := SDC->DC_QUANT
	CB8->CB8_SALDOS := SDC->DC_QUANT
	CB8->CB8_SALDOE := SDC->DC_QUANT
	CB8->CB8_LCALIZ := SDC->DC_LOCALIZ
	CB8->CB8_NUMSER := SDC->DC_NUMSERI
	CB8->CB8_LOTECT := SDC->DC_LOTECTL
	CB8->CB8_NUMLOT := SDC->DC_NUMLOTE
	CB8->CB8_CFLOTE := "1"
	CB8->(MsUnLock())
	CB8->(DbCommit())

	//DbSelectArea("CB8")
	//DbSetOrder(1) //CB8_FILIAL+CB8_ORDSEP+CB8_ITEM+CB8_SEQUEN+CB8_PROD	  //130413 renato verificar se existe cb8 antes de gravar
	//DbSeek(xFilial("CB8")+cOrdSep+_c9Item+_c9Sequen+cProduto) //130413 renato verificar se existe cb8 antes de gravar

	//Atualizacao do controle do numero de itens a serem impressos
	
	CB7->(RecLock("CB7",.F.))
	CB7->CB7_NUMITE++
	CB7->CB7_STATUS := "0"  // nao iniciado
	IF !EMPTY(SC9->C9_ORDSEP)
		CB7->CB7_ZVALLI += ((SC6->C6_ZVALLIQ/SC6->C6_QTDVEN)*SC9->C9_QTDLIB)	
	ENDIF
	CB7->(MsUnLock())
	CB7->(DbCommit())

	IF !EMPTY(SC9->C9_ORDSEP)
		Z05->(RecLock("Z05",.F.))
		Z05->Z05_VALOR += ((SC6->C6_ZVALLIQ/SC6->C6_QTDVEN)*SC9->C9_QTDLIB)				
		Z05->(MsUnlock())
		Z05->(DbCommit())
	ENDIF
Return

Static Function STGrvAux(cOrigem,cOrdAux,cArmSep,cOrdPai,cArmSel)
	Local aArea		:= GetArea()
	Local aAreaCB7	:= CB7->(GetArea())
	CB7->(DbSetOrder(1))
	If ! CB7->(DbSeek(xFilial("CB7")+cOrdAux))
		CB7->(RecLock( "CB7",.T.))
		CB7->CB7_FILIAL := xFilial("CB7")
		CB7->CB7_ORDSEP := cOrdAux
		CB7->CB7_LOCAL  := cArmSep
		If cOrigem == "SC5"
			CB7->CB7_PEDIDO := SC9->C9_PEDIDO
			CB7->CB7_CLIENT := SC9->C9_CLIENTE
			CB7->CB7_LOJA   := SC9->C9_LOJA
			CB7->CB7_COND   := SC5->C5_CONDPAG
			CB7->CB7_LOJENT := SC5->C5_LOJAENT
			CB7->CB7_TRANSP := SC5->C5_TRANSP
			CB7->CB7_ORIGEM := "1"
			CB7->CB7_TIPEXP := "00*"
			CB7->CB7_XPRIAN := SC5->C5_XPRIORI
		Else
			CB7->CB7_OP     := SD4->D4_OP
			CB7->CB7_ORIGEM := "3"
			CB7->CB7_TIPEXP := "00*"
			CB7->CB7_XPRIAN := SC2->C2_XPRIORI
		EndIf
		CB7->CB7_XAUTSE 	:= "1" 							//alterado em 2404013
		CB7->CB7_DTEMIS 	:= dDataBase
		CB7->CB7_HREMIS 	:= Time()
		CB7->CB7_STATUS 	:= " "
		CB7->CB7_CODOPE 	:= ""
		CB7->CB7_PRIORI 	:= "1"
		CB7->CB7_XSEP		:= "2"
		If cOrigem == "SC5"
			CB7->CB7_XOSPAI 	:= cOrdPai
		Endif
		CB7->(MsUnlock())
		CB7->(DbCommit())
		U_STPriCB7(CB7->CB7_LOCAL,Space(6))
	EndIf

	If SDC->DC_LOCAL <> cArmSel
		CB8->(RecLock("CB8",.T.))
		CB8->CB8_FILIAL := xFilial("CB8")
		CB8->CB8_ORDSEP := CB7->CB7_ORDSEP
		CB8->CB8_PROD   := SDC->DC_PRODUTO
		CB8->CB8_LOCAL  := SDC->DC_LOCAL
		If cOrigem == "SC5"
			CB8->CB8_ITEM   := SC9->C9_ITEM
			CB8->CB8_PEDIDO := SC9->C9_PEDIDO
			CB8->CB8_SEQUEN := SC9->C9_SEQUEN
		Else
			CB8->CB8_OP     := SD4->D4_OP
			CB8->CB8_ITEM   := StrZero(CB7->CB7_NUMITE+1,2)
			CB8->CB8_SEQUEN := SD4->D4_TRT
		EndIf

		CB8->CB8_QTDORI := SDC->DC_QUANT
		CB8->CB8_SALDOS := SDC->DC_QUANT
		CB8->CB8_SALDOE := SDC->DC_QUANT
		CB8->CB8_LCALIZ := SDC->DC_LOCALIZ
		CB8->CB8_NUMSER := SDC->DC_NUMSERI
		CB8->CB8_LOTECT := SDC->DC_LOTECTL
		CB8->CB8_NUMLOT := SDC->DC_NUMLOTE
		CB8->CB8_CFLOTE := "1"
		CB8->(MsUnLock())
		CB8->(DbCommit())

		//Atualizacao do controle do numero de itens a serem impressos
		CB7->(RecLock("CB7",.F.))
		CB7->CB7_NUMITE++
		CB7->CB7_STATUS := "0"  // nao iniciado
		CB7->(MsUnLock())
		CB7->(DbCommit())
	EndIf
	RestArea(aAreaCB7)
	RestArea(aArea)
Return

User Function STDelOS(cOrdSep)  //ESTORNA A OS - Sำ ALTERA CB7
	Local aArea		:= GetArea()
	Local aAreaCB7 := CB7->(GetArea())
	Local aAreaCB8 := CB8->(GetArea())

	CB8->(RecLock('CB8',.F.))
	CB8->(DbDelete())
	CB8->(MsUnLock())
	CB8->(DbCommit())
	CB7->(DbSetOrder(1))
	If CB7->(DbSeek(xFilial("CB7")+cOrdSep))
		CB7->(RecLock("CB7",.F.))
		CB7->CB7_NUMITE--
		CB7->CB7_STATUS := "0"  // nao iniciado
		If Empty(CB7->CB7_NUMITE)
			CB7->(DBDelete())
		EndIf
		CB7->(MsUnLock())
		CB7->(DbCommit())
	EndIf
	RestArea(aAreaCB7)
	RestArea(aAreaCB8)
	RestArea(aArea)
Return

User Function STDelAux(cOrdFilho)
	Local aArea	:= GetArea()
	Local aCB7Area	:= CB7->(GetArea())
	CB7->(DbSetOrder(1))
	CB8->(DbSetOrder(1))
	While CB8->(DbSeek(xFilial('CB8')+cOrdFilho))
		CB8->(RecLock('CB8',.F.))
		CB8->(DbDelete())
		CB8->(MsUnLock())
		CB8->(DbCommit())
	End
	If CB7->(DbSeek(xFilial("CB7")+cOrdFilho))
		CB7->(RecLock("CB7",.F.))
		CB7->(DBDelete())
		CB7->(MsUnLock())
		CB7->(DbCommit())
	EndIf

	RestArea(aCB7Area)
	RestArea(aArea)

Return

User Function STISTLV(cPedido)
	Local lRet 		:= .F.
	Local aArea		:= GetArea()
	Local aSC6Area	:= SC6->(GetArea())

	SC6->(DbSetOrder(1)) //C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
	If !SC6->(DbSeek(xFilial("SC6")+cPedido))
		Return lRet
	Endif

	While SC6->(!Eof() .and. C6_FILIAL+C6_NUM == xFilial("SC6")+cPedido)
		If Left( SC6->C6_PEDCLI, 3 ) == "TMK"
			lRet := .T.
			Exit
		Endif
		SC6->(DbSkip())
	End

	RestArea(aSC6Area)
	RestArea(aArea)
Return lRet

User Function STBarra(cProduto,cLote,nQtde,cEmpresa)
	Local cParte1 	:= Alltrim(cProduto)
	Local cParte2 	:= Alltrim(cLote)
	Local cBarra	:= ""
	Local nT			:= TamSx3("D3_QUANT")[1]
	Local nD			:= TamSx3("D3_QUANT")[2]
	Local cQtde		:= Alltrim(Str(nQtde,nT,nD))
	Local cIntQtde	:= Left(cQtde,at(".",cQtde)-1)
	Local cDecQtde := Subs(cQtde,At(".",cQtde)+1)
	If cEmpresa == NIL .or. Empty(cEmpresa)
		cEmpresa := SM0->M0_CODIGO
	EndIf

	//analisando de pode compactar o produto
	//If Alltrim(Str(val(cParte1))) == cParte1	// Leonardo Flex -> retirado pois dependendo do codigo do produto esse teste se perdia e ocasionava erro
	If U_STFXRETNUM(cParte1) == cParte1
		// o produto eh numero
		If Mod(Len(cParte1),2) == 0
			cBarra	:= cParte1+MSCB128B()+"|"
		Else
			cBarra	:= Left(cParte1,len(cParte1)-1)+MSCB128B()+Right(cParte1,1) +"|"
		EndIf
	Else
		cBarra	:= MSCB128B()+cParte1+"|"
	EndIf
	//analisando de pode compactar o lote
	//If Alltrim(Str(val(cParte2))) == cParte2 	// Leonardo Flex -> retirado pois dependendo do codigo do produto esse teste se perdia e ocasionava erro
	If U_STFXRETNUM(cParte2) == cParte2
		// O LOTE EH numero
		If Mod(Len(cParte2),2) == 0
			cBarra	+= MSCB128C()+cParte2+MSCB128B()+"|"
		Else
			cBarra	+= MSCB128C()+Left(cParte2,len(cParte2)-1)+MSCB128B()+Right(cParte2,1)+"|"
		EndIf
	Else
		cBarra	+= cParte2+"|"
	EndIf
	If Mod(Len(cIntQtde),2) == 0 .and. len(cIntQtde) > 1
		cBarra	+= MSCB128C()+cIntQtde
		If ! Empty(Val(cDecQtde))
			cBarra	+= MSCB128B()+"."+cDecQtde+"|"+cEmpresa
		Else
			cBarra	+= MSCB128B()+"|"+cEmpresa
		Endif
	Else
		If len(cIntQtde) == 1
			cBarra	+= MSCB128B()+"0"+cIntQtde
		Else
			cBarra	+= MSCB128C()+Left(cIntQtde,len(cIntQtde)-1)+MSCB128B()+Right(cIntQtde,1)
		EndIf
		If ! Empty(Val(cDecQtde))
			cBarra	+= "."+cDecQtde
		EndIf
		cBarra	+= "|"+cEmpresa
	EndIf

Return cBarra

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออัอออออออัออออออออออออออออออออัออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTFXRETNUMณAutor  ณLeonardo Kichitaro  ณ Data ณ  27/03/13   บฑฑ
ฑฑฬออออออออออุออออออออออฯอออออออฯออออออออออออออออออออฯออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao para ler todos os caracteres de uma string e retornarบฑฑ
ฑฑบ          ณapenas o conteudo numerico dessa string.                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function STFXRETNUM(cVar)
	Local cRet := ""
	Local nX := 0
	Local cLenVar := Alltrim(cVar)
	Local cChar := ""

	While .T.
		cChar := SubStr(cLenVar,1,1)
		cLenVar := SubStr(cLenVar,2)
		If AllTrim(Str(Val(cChar))) == cChar
			cRet += cChar
		EndIf
		If Len(cLenVar) == 0
			Exit
		EndIf
	EndDo

Return cRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTFixaPergบAutor  ณMicrosiga           บ Data ณ  02/03/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPE MVCHANGE para manipular a pergunte e desconsiderar a     บฑฑ
ฑฑบ          ณmanipula็ใo do usuario utilizando a funcao STFixaPerg       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
Exemplo:

cPerg := "MTA650"
aFixa	:= {{"MV_PAR08",2},{"MV_PAR13",2}}
U_StFixaPerg(cPerg,aFixa)
*/

User Function STFixaPerg(cPerg,aFixa)
	Local cParPerg := Alltrim(PARAMIXB[1])
	Local nX
	If cParPerg == cPerg
		For nX:= 1 to len(aFixa)
			&(aFixa[nX,1]) := aFixa[nX,2]
		Next
		//SaveParam(cPerg,aPergunta)
	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSaveParam บAutor  ณMicrosiga           บ Data ณ  02/03/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao static de apoio para o STFixaPerg                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
/*
Static Function SaveParam(cPergunta,aPergunta,lUseProf)
Local nI
Local nEl := 1
Local lProfile := (__CUSERID <> "000000") .and. ( VerSenha(108) .Or. VerSenha(150) ) .And. GetUpdPerg() == 1
Local xVar
Local cProfile := ""
Local aArray   := {}
Local lForEmp  := VerSenha(150)
Local __lSaveMVVars := SaveMVVars()

DEFAULT lUseProf := .T.

	If __lSaveMVVars
DbSelectArea("SX1")
DbSetOrder(1)
DbSeek(cPergunta)
		While !Eof() .and. X1_GRUPO == PadR(cPergunta,Len(X1_GRUPO))
			If aPergunta[nEl,6] == "C"
aPergunta[nEl,5] := &("MV_PAR"+StrZero(nEl,2,0))
xVar := AllTrim(Str(aPergunta[nEl,5]))
			ElseIf aPergunta[nEl,6] == "R"
aPergunta[nEl,20] := &("MV_PAR"+StrZero(nEl,2,0))
xVar := aPergunta[nEl,20]
			ElseIf aPergunta[nEl,6] == "K"
aArray := &("MV_PAR"+StrZero(nEl,2,0))
xVar   := ""
				For nI := 1 To Len(aArray)
					If aArray[nI,1]
xVar+= LTrim(Str(nI))+";"
					EndIf
				Next nI
			Else
aPergunta[nEl,8] := &("MV_PAR"+StrZero(nEl,2,0))
				If Upper(aPergunta[nEl,2]) == "D"
xVar := DTOS(aPergunta[nEl,8])
				ElseIf Upper(aPergunta[nEl,2]) == "N"
xVar := Str(aPergunta[nEl,8],aPergunta[nEl,3],aPergunta[nEl,4])
				Else
xVar := aPergunta[nEl,8]
				EndIf
			EndIf

			If GetUpdPerg() == 1
				If (lProfile .Or. X1_GSC == "E") .And. lUseProf
cProfile += X1_TIPO + "#" + X1_GSC + "#" + xVar + CRLF
				Else
RecLock("SX1")
					If aPergunta[nEl,6] == "C"
Replace X1_PRESEL with aPergunta[nEl,5]
					ElseIf aPergunta[nEl,6] == "R"
Replace X1_CNT02 With xVar
					Else
Replace X1_CNT01 With xVar
					EndIf
MSUnlock()
				EndIf
			EndIf
nEl++
DbSkip()
		End

		If lProfile .And. lUseProf
			If lForEmp
				If FindProfDef(cEmpAnt+cUserName,cPergunta,"PERGUNTE","MV_PAR")
WriteProfDef(cEmpAnt+cUserName,cPergunta,"PERGUNTE","MV_PAR",cEmpAnt+cUserName,cPergunta,"PERGUNTE","MV_PAR",cProfile)
				Else
WriteNewProf(cEmpAnt+cUserName,cPergunta,"PERGUNTE","MV_PAR",cProfile)
				EndIf
			Else
				If FindProfDef(cUserName,cPergunta,"PERGUNTE","MV_PAR")
WriteProfDef(cUserName,cPergunta,"PERGUNTE","MV_PAR",cUserName,cPergunta,"PERGUNTE","MV_PAR",cProfile)
				Else
WriteNewProf(cUserName,cPergunta,"PERGUNTE","MV_PAR",cProfile)
				EndIf
			EndIf
		ElseIf GetUpdPerg() == 1 .And. lUseProf
			If !Empty(cProfile)
				If FindProfDef("SX1"+cEmpAnt+cPergunta,cPergunta,"PERGUNTE","MV_PAR")
WriteProfDef("SX1"+cEmpAnt+cPergunta,cPergunta,"PERGUNTE","MV_PAR","SX1"+cEmpAnt+cPergunta,cPergunta,"PERGUNTE","MV_PAR",cProfile)
				Else
WriteNewProf("SX1"+cEmpAnt+cPergunta,cPergunta,"PERGUNTE","MV_PAR",cProfile)
				EndIf
			EndIf
		EndIf
	EndIf
Return nil
*/

User Function STIsIndireto(cProduto)
	Local lRet 		:= .F.
	Local aArea		:= GetArea()
	Local aSB1Area	:= SB1->(GetArea())
	SB1->(DbSetOrder(1))
	SB1->(DbSeek(xFilial("SB1")+cProduto))
	lRet := SB1->B1_APROPRI =="I"
	RestArea(aSB1Area)
	RestArea(aArea)
Return lRet

User Function STAltSc5()
	Local cTransp, cTipFat, cCondPag
	Local cXObsExp, cZObs, cXBlqFMI, cXBlqMkt,cXBlqAti, cXBlqCli,cXBlqCo
	Local cXAlertF, cXTipo, cTpFrete, cXObsVen
	Local cVlRese,_nSalPv
	Local cXVlMin, cXLibAVi
	Local cxDe , cxAte ,cxAnoD //GIOVANI ZAGO 16/01/14
	Local cxMDe , cxMAte,cxAnoA //GIOVANI ZAGO 20/02/14
	Local aParamBox         := {}
	Local aRet              := {}
	Local cMV_XLIBFMI       := SuperGetMV("MV_XLIBFMI",,"")
	Local lLIBFMI           := .f.
	Local cMV_XLIBTRA       := SuperGetMV("FS_XLIBTRA",,"")
	Local _cUser            := RetCodUsr()
	Local _aAltIni,_aAltFim := {} //Renato Nogueira 230114
	Local nX                := 0 //Renato Nogueira 230114
	Local _cMsg             := "" //Renato Nogueira 230114
	Local _lDif             := .F. //Renato Nogueira 230114
	Local _cEmail           := ""
	Local _cCopia           := ""
	Local _cAssunto         := 'Novo chamado ERP'
	Local cMsg              := ""
	Local cAttach           := ''
	Local _aAttach          := {}
	Local _cCaminho         := ''
	Local _aAreaSC6         := SC6->(GetArea())
	Local _aAreaPA1         := PA1->(GetArea())
	Local _cCliblt          := GetMv( 'ST_XCLIBLT' ,, '000000' ) // chamado 005307 - Robson Mazzarotto
	Local lAtiva            := GetMV("ST_ATINPUT",.F.,.T.) // Valdemir Rabelo 17/06/2021 Ticket: ticket Nบ 20210211002338 / 20210601009141

	Private lSaida 				:= .T.
	Private oDlgEmail
	Private aSize      			:= MsAdvSize(.F.)//giovani zago 12/08/13
	Private _cRefNF       		:= ' '    //giovani zago 20/06/13
	Private _cxIbl      		:= ' '    //giovani zago 19/09/13
	Private _cxoldibl   		:= ' '    //giovani zago 19/09/13
	Private _lxret      		:= .t.    //giovani zago 20/06/13
	Private _cGrCif      		:= GetMv('ST_GRUCIF',,'000000')   //giovani zago 14/02/14
	Private cZCodM, cZEndEnt, cZBairrE, cZMunE,cZEstE, cZCepE ,cBlqCom , cBlqFin , _cTntFob, _cEstE2, _cMunE2
	Private _cBlqRom  := ' '
	Private _cBlqEAN  := ' '
	PRIVATE _dDtProg := STOD("")
	PRIVATE cEntFat  := ' '
	

	DbSelectArea("SA1")
	DbSetOrder(1)
	If	DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI)
		If SA1->A1_XBLQFIN=="1"
			cBlqFin		:= SA1->A1_XMOTBLQ//giovani zago 06/08/15
		Else
			cBlqFin		:= SC5->C5_ZMOTREJ // Robson Mazzarotto chamado -005212.
		EndIf
	EndIf

	_cTntFob    := SC5->C5_XTNTFOB//giovani zago 09/09/15
	cBlqCom		:= SC5->C5_ZMOTBLO//giovani zago 03/08/15
	_cRefNF     := SC5->C5_ZREFNF//giovani zago 20/06/13
	cTransp		:= SC5->C5_TRANSP
	cXBlqCli    := Posicione("SA1",1,xFilial('SA1')+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_XBLQFIN")
	cTipFat		:= SC5->C5_XTIPF	//1=Total;2=Parcial
	cCondPag	:= SC5->C5_CONDPAG
	cXObsExp	:= SC5->C5_XOBSEXP
	cZObs		:= SC5->C5_ZOBS
	cXBlqFMI	:= SC5->C5_XBLQFMI	//S=Sim;N=Nao
	cXLibAVi	:= SC5->C5_XLIBAVI	//S=Sim;N=Nao
	cXAlertF	:= SC5->C5_XALERTF
	cXObsVen    := SC5->C5_XOBSVEN
	cXTipo		:= SC5->C5_XTIPO	//1=Retira;2=Entrega
	cTpFrete	:= SC5->C5_TPFRETE	//C=CIF;F=FOB;T=Por conta terceiros;S=Sem frete
	cZEndEnt	:= SC5->C5_ZENDENT
	cZBairrE	:= SC5->C5_ZBAIRRE
	cZMunE		:= SC5->C5_ZMUNE
	cZEstE		:= SC5->C5_ZESTE
	cZCepE		:= SC5->C5_ZCEPE
	/*cxDe		:= SC5->C5_XDE   //GIOVANI ZAGO 16/01/14
	cxAte		:= SC5->C5_XATE //GIOVANI ZAGO 16/01/14
	cxMDe		:= SC5->C5_XMDE   //GIOVANI ZAGO 20/02/14
	cxMAte		:= SC5->C5_XMATE //GIOVANI ZAGO 20/02/14
	cxAnoD		:= SC5->C5_XDANO //GIOVANI ZAGO 20/09/15
	cxAnoA		:= SC5->C5_XAANO //GIOVANI ZAGO 20/09/15*/
	cXBlqMkt	:= SC5->C5_XPEDMKT
	cXBlqAti	:= SC5->C5_XOPER32
	cXBlqCo		:= SC5->C5_XOPERCO //Ticket 20191107000028 - Everson Santana 08.11.2019
	cZCodM		:= SC5->C5_XCODMUN
	_cBlqRom  := SC5->C5_XBLQROM
	_cBlqEAN  := SC5->C5_XREAN14
	_dDtProg  := SC5->C5_XDTENPR
	cEntFat  := SC5->C5_XENTFAT

	IF !EMPTY(SC5->C5_CLIENT) .AND. EMPTY(cZEstE)   // Criado valida็ใo, Giovani fez merda chamado 005185.

		DbSelectArea("SA1")
		DbSetOrder(1)
		dbGoTop()
		If	DbSeek(xFilial("SA1")+SC5->C5_CLIENT+SC5->C5_LOJAENT)
			_cEstE2 := SA1->A1_EST
			_cMunE2 := SA1->A1_COD_MUN
			cZMunE		:= _cMunE2
			cZEstE		:= _cEstE2
		EndIf

	ELSEIF EMPTY(cZEstE)

		DbSelectArea("SA1")
		DbSetOrder(1)
		dbGoTop()
		If	DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI)
			_cEstE2 := SA1->A1_EST
			_cMunE2 := SA1->A1_COD_MUN
			cZMunE		:= _cMunE2
			cZEstE		:= _cEstE2
		EndIf

	ENDIF

	cVlRese := U_STFSXRES(SC5->C5_NUM)
	cXVlMin := Posicione("SE4",1,XFILIAL("SE4")+SC5->C5_CONDPAG,"E4_XVLRMIN")

	_nSalPv := U_SALDPVST(SC5->C5_NUM)

	//If msgyesno("Usar Nova Tela ?")
	cTipFat := Iif(cTipFat=="1","Total","Parcial")
	cXTipo  := Iif(cXTipo=="1","Retira","Entrega")
	cTpFrete:= Iif(cTpFrete=="C","CIF",Iif(cTpFrete=="F","FOB",""))
	cXBlqFMI:= Iif(cXBlqFMI=="S","Sim","Nao")
	cXLibAVi:= Iif(cXLibAVi=="S","Sim","Nao")
	_cRefNF := Iif(_cRefNF=="1","Bloqueado","Liberado")
	_cxIbl  := Iif(SC5->C5_XIBL="2","2=Bloqueado","1=Liberado")
	_cBlqRom:= Iif(_cBlqRom="1","Sim","Nao")
	_cBlqEAN:= Iif(_cBlqEAN="1","Sim","Nao")

	cXBlqMkt:= Iif(cXBlqMkt=="S","Sim","Nao")
	cXBlqAti:= Iif(cXBlqAti=="2","Bloqueado","Liberado")
	cXBlqCo := Iif(cXBlqCo=="2","Bloqueado","Liberado") //Ticket 20191107000028 - Everson Santana 08.11.2019
	_cTntFob:= Iif(_cTntFob=="1","Bloqueado","Liberado")
	//Renato Nogueira - 230114 - Verificar se houve altera็ใo no cabe็alho do pedido ap๓s confirmar
	_aAltIni	:= {}
	Aadd(_aAltIni,{_cRefNF,"Ref NF"})
	Aadd(_aAltIni,{cTransp,"Transportadora"})
	Aadd(_aAltIni,{cXBlqCli,"Blq. Cliente"})
	Aadd(_aAltIni,{cTipFat,"Tipo Fat"})
	Aadd(_aAltIni,{cCondPag,"Cond. Pag."})
	Aadd(_aAltIni,{cXObsExp,"Obs Exp"})
	Aadd(_aAltIni,{cZObs,"Obs"})
	Aadd(_aAltIni,{cXBlqFMI,"Blq. FMI."})
	Aadd(_aAltIni,{cXLibAVi,"Lib. a Vista"})
	Aadd(_aAltIni,{cXAlertF,"Alert F."})
	Aadd(_aAltIni,{cXObsVen,"Obs. Vendas"})
	Aadd(_aAltIni,{cXTipo,"Tipo"})
	Aadd(_aAltIni,{cTpFrete,"Tipo Frete"})
	Aadd(_aAltIni,{cZEndEnt,"End Entrega"})
	Aadd(_aAltIni,{cZBairrE,"Bairro Entrega"})
	Aadd(_aAltIni,{cZMunE,"Municํpio Entrega"})
	Aadd(_aAltIni,{cZEstE,"Estado Entrega"})
	Aadd(_aAltIni,{cZCepE,"CEP Entrega"})
	Aadd(_aAltIni,{cVlRese,"Valor reserva"})
	Aadd(_aAltIni,{cXVlMin,"Valor mํnimo"})
	Aadd(_aAltIni,{_nSalPv,"Saldo PV"})
	Aadd(_aAltIni,{_cxIbl,"IBL"})
	Aadd(_aAltIni,{_cBlqRom,"Bloqueio distribui็ใo"})
	Aadd(_aAltIni,{_cBlqEAN,"Retrabalho EAN14"})
	/*Aadd(_aAltIni,{cxDe,"Dia De"})
	Aadd(_aAltIni,{cxAte,"Dia Ate"})
	Aadd(_aAltIni,{cxMDe,"Mes De"})
	Aadd(_aAltIni,{cxMAte,"Mes Ate"})*/
	Aadd(_aAltIni,{cXBlqMkt,"Blq Mkt"})
	Aadd(_aAltIni,{cXBlqAti,"Blq Ati"})
	Aadd(_aAltIni,{cXBlqCo,"Blq Comodato"})
	Aadd(_aAltIni,{cZCodM,"Cod.Mun"})
	/*Aadd(_aAltIni,{cxAnoD,"Ano de"})
	Aadd(_aAltIni,{cxAnoA,"Ano Ate"})*/
	Aadd(_aAltIni,{_cTntFob,"Tnt/Fob"})
	Aadd(_aAltIni,{DTOC(_dDtProg),"Ent. Prog. Cliente"})
	Aadd(_aAltIni,{cEntFat,"Data entrega/faturamento"})

	//----------------------------------------------------------------------------------------------

	While lSaida
		//	DEFINE MSDIALOG oDlgEmail FROM 90,200 TO 780,780 TITLE Alltrim(OemToAnsi('Cabe็alho Do P.V.: '+SC5->C5_NUM)) Pixel //430,531
		Define msDialog oDlgEmail TITLE Alltrim(OemToAnsi('Cabe็alho Do P.V.: '+SC5->C5_NUM)) From 0,0 To aSize[6]-15,aSize[5]-15  PIXEL OF oMainWnd //from 178,181 to 590,1100 pixel

		nOpca:=0

		@ 40,04 SAY "Endereco Entrega" PIXEL OF oDlgEmail
		@ 50,04 MSGet cZEndEnt Size 150,10 Picture "@!"    pixel OF oDlgEmail  when  getWhen()
		@ 70,04 SAY "Bairro Entrega" PIXEL OF oDlgEmail
		@ 80,04 MSGet cZBairrE Size 100,10 Picture "@!"    pixel OF oDlgEmail when  getWhen()
		@ 100,04 SAY "Municipio Entrega" PIXEL OF oDlgEmail
		@ 110,04 MSGet cZMunE Size 100,10 Picture "@!"    pixel OF oDlgEmail when  getWhen()

		@ 130,04 SAY "Estado Entrega" PIXEL OF oDlgEmail
		@ 140,04 MSGet cZEstE Size 30,10 Picture "@!"   valid iif(Posicione('SA1',1,xFilial('SA1')+SC5->C5_CLIENT+SC5->C5_LOJAENT,'A1_EST')<>cZEstE .And. SC5->C5_CLIENTE <> '070874',(MSGINFO('UF divergente!!!'),.f.),.t.)  pixel OF oDlgEmail  when  getWhen()
		@ 130,44 SAY "Cod.Mun." PIXEL OF oDlgEmail
		@ 140,44 MSGet cZCodM Size 60,10 Picture "@!"	    pixel OF oDlgEmail when  getWhen()

		@ 155,04 SAY "CEP Entrega" PIXEL OF oDlgEmail
		@ 165,04 MSGet cZCepE Size 60,10 Picture "@R 99999-999"	 F3 "JC2"   pixel OF oDlgEmail  valid Iif (cZCepE <> SC5->C5_ZCEPE ,CEPALTSC5(cZCepE),.T.) when STSA3WNHE(__cUserId)

		@ 185,04 SAY "Refaturamento" PIXEL OF oDlgEmail
		@ 195,04 COMBOBOX _cRefNF ITEMS {"Bloqueado","Liberado"} Size 60,10 PIXEL OF oDlgEmail

		IF __cUserId $ GetMv("ST_ROMEAN")

			@ 155,100 SAY "Retrabalho EAN14?"
			@ 165,100 COMBOBOX _cBlqEAN ITEMS {"Nใo","Sim"} Size 50,10 PIXEL OF oDlgEmail Valid U_STWF35(SC5->C5_NUM,1,_cBlqEAN)

			@ 185,100 SAY "Bloqueio distribui็ใo?"
			@ 195,100 COMBOBOX _cBlqRom ITEMS {"Nใo","Sim"} Size 50,10 PIXEL OF oDlgEmail Valid U_STWF35(SC5->C5_NUM,2,_cBlqRom)

		ENDIF

		//combo
		if SC5->C5_CLIENTE $ _cCliblt // Chamado 005307 - Robson Mazzarotto
			// o Tipo de Faturamento nใo deve aparecer para os clientes informados no parametro.
		else
			@ 10,200 SAY "Tipo de Faturamento" PIXEL OF oDlgEmail
		@ 245, 250 Button "Cancela" Size 35,12 Action Eval({||lSaida:=.f.,nOpca:=2,oDlgEmail:End()})  Pixel OF oDlgEmail
			@ 20,200 COMBOBOX cTipFat ITEMS {"Total","Parcial"} Size 50,10 PIXEL OF oDlgEmail //valid U_VLDTPFAT(SC5->C5_CLIENTE,SC5->C5_LOJACLI,cTipFat,SC5->C5_NUM,nOpca)
		Endif

		@ 40,200 SAY "Tipo Entrega" PIXEL OF oDlgEmail
		@ 50,200 COMBOBOX cXTipo ITEMS {"Retira","Entrega"} Size 50,10 PIXEL OF oDlgEmail Valid U_STTPECB(cTransp,cXTipo)

		If _cUser $ _cGrCif
			@ 70,200 SAY "Tipo Frete" PIXEL OF oDlgEmail
			@ 80,200 COMBOBOX cTpFrete ITEMS {"CIF","FOB"} when getWhen() Size 50,10 PIXEL OF oDlgEmail  Valid ((U_STCABTRANSP(cTransp,cTpFrete)) .And. (U_STVLDTRA(cTransp,cXTipo,cTpFrete,cZEstE,cZCodM)))//U_STVLDFRE(Iif(AllTrim(cTpFrete)=="CIF","C","F"),SC5->C5_CLIENTE,SC5->C5_LOJACLI)
		Else
			@ 70,200 SAY "Tipo Frete" PIXEL OF oDlgEmail
			@ 80,200 COMBOBOX cTpFrete ITEMS {"CIF","FOB"} when getWhen()  Size 50,10 PIXEL OF oDlgEmail
		EndIf

		@ 10,04 SAY "Transportadora" PIXEL OF oDlgEmail
		@ 20,04 MSGet cTransp Size 50,10 Picture "@!" Valid ((!(empty(alltrim(cTransp)))  .And. (existcpo("SA4",cTransp))) .and. (U_STVLDTRA(cTransp,cXTipo,cTpFrete,cZEstE,cZCodM))   .and. U_STCABTRANSP(cTransp,cTpFrete))  f3 'SA4'    pixel OF oDlgEmail When Iif(Alltrim(cTpFrete)=="CIF" .And. Alltrim(Posicione("SA3",7,xFilial("SA3")+__cuserid,"A3_TPVEND"))=="R",.F.,.T.)

		@ 10,100 SAY "Bloqueio Cliente" PIXEL OF oDlgEmail
		@ 20,100 COMBOBOX cXBlqCli ITEMS {" ","Bloqueado","Liberado"} when .f.  Size 50,10 PIXEL OF oDlgEmail

		//If !(Empty(Alltrim(cBlqFin)))
		@ 10,300 SAY "Blq Financeiro" PIXEL OF oDlgEmail
		@ 20,300 MSGet cBlqFin Size 275,8 Picture "@!" when .f. PIXEL  OF oDlgEmail
		//EndIf

		@ 35,300 SAY "Observacใo NF" PIXEL OF oDlgEmail
		@ 43,300 MSGet cZObs Size 275,10 Picture "@!" PIXEL  OF oDlgEmail
		@ 58,300 SAY "Alerta Faturamento"  PIXEL OF oDlgEmail
		@ 65,300 MSGet cXAlertF Size 275,10 Picture "@!" when __cUserId $ GETMV('ST_USRFAT') PIXEL  OF oDlgEmail
		@ 77,300 SAY "Observa็๕es Vendas" PIXEL OF oDlgEmail
		@ 85,300 MSGet cXObsVen Size 275,10 Picture "@!" PIXEL  OF oDlgEmail

		/*If GetMv("STFSXFUN01",,.T.)

			If __cUserID $ AllTrim(GetMv("STFSXFUN02",,"001583#000000"))

		@ 100,300 SAY "Nใo Gera Os" PIXEL OF oDlgEmail
		@ 105,300 SAY "De:" PIXEL OF oDlgEmail
		@ 105,400 SAY "Ate:" PIXEL OF oDlgEmail

		//GIOVANI ZAGO BLOQUEIO DE GERAวรO DE OS

		@ 110,300 SAY "Dia:" PIXEL OF oDlgEmail
		@ 110,330 SAY "Mes:" PIXEL OF oDlgEmail
		@ 110,360 SAY "Ano:" PIXEL OF oDlgEmail
		@ 110,400 SAY "Dia:" PIXEL OF oDlgEmail
		@ 110,430 SAY "Mes:" PIXEL OF oDlgEmail
		@ 110,460 SAY "Ano:" PIXEL OF oDlgEmail

		@ 120,300 COMBOBOX cxDe ITEMS {"","01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31" };
			Size 25,10  PIXEL  OF oDlgEmail
		@ 120,330 COMBOBOX cxMDe ITEMS {"","01","02","03","04","05","06","07","08","09","10","11","12" };
			Size 25,10  PIXEL  OF oDlgEmail
		@ 120,360 COMBOBOX cxAnoD ITEMS {"","2020","2021","2022","2023","2024","2025" };
			Size 25,10  PIXEL  OF oDlgEmail
		@ 120,400 COMBOBOX cxAte ITEMS {"","01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31"} ;
			Size 25,10 /* Valid ( IIF(( !EMPTY(ALLTRIM(cxMAte)) .Or. !EMPTY(ALLTRIM(cxMDe))),.t.,cxAte >= cxDe) )  PIXEL  OF oDlgEmail
		@ 120,430 COMBOBOX cxMAte ITEMS {"","01","02","03","04","05","06","07","08","09","10","11","12"} ;
			Size 25,10  /* Valid ( cxMDe <= cxMAte  .OR. ( EMPTY(ALLTRIM(cxMAte)) .AND. EMPTY(ALLTRIM(cxMDe))))  PIXEL  OF oDlgEmail
		@ 120,460 COMBOBOX cxAnoA ITEMS {"","2020","2021","2022","2023","2024","2025" };
			Size 25,10  PIXEL  OF oDlgEmail

			EndIf

		EndIf*/

		/*************************************************************
		<<< ALTERAวรO >>> 
		A็ใo...........: 1 - Retira apresenta็ใo do GET _cTntFob
		...............: 2 - Incluido a apresenta็ใo do GET de Entrega Programada Cliente
		Desenvolvedor..: Marcelo Klopfer Leme
		Data...........: 01/06/2022
		Chamado........: 20220429009114 - Oferta Logํstica
		If _cUser $ _cGrCif
			@ 110,500 SAY "Tnt/Fob" PIXEL OF oDlgEmail
			@ 120,500 COMBOBOX _cTntFob ITEMS {"Bloqueado","Liberado"} when .t. Size 60,10 PIXEL OF oDlgEmail
		Else
			@ 110,500 SAY "Tnt/Fob" PIXEL OF oDlgEmail
			@ 120,500 COMBOBOX _cTntFob ITEMS {"Bloqueado","Liberado"} when .F. Size 60,10 PIXEL OF oDlgEmail
		EndIf
		*************************************************************/
		@ 110,500 SAY "Ent. Prog. Cliente" PIXEL OF oDlgEmail
		@ 120,500 MSGET _dDtProg SIZE 40,10 PIXEL OF oDlgEmail

		@ 110,350 SAY "Data entrega/faturamento" PIXEL OF oDlgEmail
		@ 120,350 COMBOBOX cEntFat ITEMS {"1=Data Entrega","2=Data Faturamento"," "} Size 60,10 PIXEL OF oDlgEmail
		
		If SC5->C5_XIBL = '2' .And. cfilant = '02'
			_cxoldibl:='2'
			@ 100,400 SAY "Faturamento na 02" PIXEL OF oDlgEmail   //Giovani Zago 19/09/2013 ibl
			@ 110,400 COMBOBOX _cxIbl ITEMS {"2=Bloqueado","1=Liberado"} Size 60,10 when DTOS(SC5->C5_EMISSAO) < '20131014'  PIXEL OF oDlgEmail  //Giovani Zago 19/09/2013 ibl
		EndIf

		//Renato Nogueira 230114 - Mostra hist๓rico de altera็๕es
		cMemo   := MSMM(SC5->C5_XALTCAB)
		oMemo	:= tMultiget():New(140,300,{|u|if(Pcount()>0,cMemo:=u,cMemo)},oDlgEmail,300,100,,,,,,.T.)
		//-------------------------------------------------------

		If _cUser $ cMV_XLIBFMI

			@ 100,200 SAY "BLQ Fat. Min" PIXEL OF oDlgEmail
			@ 110,200 COMBOBOX cXBlqFMI ITEMS {"Sim","Nao"} Size 50,10 PIXEL OF oDlgEmail

			@ 130,200 SAY "Lib.Pg. a Vista" PIXEL OF oDlgEmail
			@ 140,200 COMBOBOX cXLibAVi ITEMS {"Sim","Nao"} Size 50,10 PIXEL OF oDlgEmail

			@ 150,200 SAY "Cond. Pagto" PIXEL OF oDlgEmail
			@ 158,200 MSGet cCondPag Size 50,10 Picture "@! 999" f3 "SE4_01"   VALID (IF(cCondPag>="501",.T.,.F.) .And. U_STTMKA05(cCondPag)) pixel OF oDlgEmail when .f.

			@ 190,200 SAY "Valor Minimo" PIXEL OF oDlgEmail
			@ 200,200 MSGet cXVlMin Size 80,10 Picture "@E 9,999,999,999,999.99"	 when .f.   pixel OF oDlgEmail
		Else
			//>>Ticket 20191106000008 Everson Santana - 08.11.2019
			DbSelectArea("SA3")
			SA3->(DbSetOrder(7))
			SA3->(DbGotop())
			If SA3->(dbSeek(xFilial("SA3")+__cUserId))

				If SubStr(SA3->A3_COD,1,1) $ "I" .Or. SubStr(SA3->A3_COD,1,1) $ "S" // TICKET
					lLIBFMI := .T.
				EndIf

				If lLIBFMI
					@ 100,200 SAY "BLQ Fat. Min" PIXEL OF oDlgEmail
					@ 110,200 COMBOBOX cXBlqFMI ITEMS {"Sim","Nao"} Size 50,10 PIXEL OF oDlgEmail //when .f. ticket 20191010000031

					@ 160,200 SAY "Cond. Pagto" PIXEL OF oDlgEmail
					@ 170,200 MSGet cCondPag Size 50,10 Picture "@! 999" f3 "SE4_01"    pixel OF oDlgEmail when .f.

					@ 190,200 SAY "Valor Minimo" PIXEL OF oDlgEmail
					@ 200,200 MSGet cXVlMin Size 80,10 Picture "@E 9,999,999,999,999.99"	 when .f.   pixel OF oDlgEmail
				Else
					@ 100,200 SAY "BLQ Fat. Min" PIXEL OF oDlgEmail
					@ 110,200 COMBOBOX cXBlqFMI ITEMS {"Sim","Nao"} Size 50,10 PIXEL OF oDlgEmail when .f. //ticket 20200610002858

				EndIf
			EndIf
			//<<Ticket 20191106000008 Everson Santana - 08.11.2019
		EndIf

		//Robson - Alterado o posicionamento dos dois campos abaixo.
		If __cUserId $ GetMv("ST_USRMKT") //Chamado 001109 - Marketing
			@ 215,100 SAY "Blq Mkt" PIXEL OF oDlgEmail
			@ 225,100 COMBOBOX cXBlqMkt ITEMS {"Sim","Nao"} Size 50,10 PIXEL OF oDlgEmail
		EndIf
		If __cUserId $ GetMv("ST_ATIVOUS") //Chamado 000998 - Controladoria
			@ 215,100 SAY "Blq Ativ" PIXEL OF oDlgEmail
			@ 225,100 COMBOBOX cXBlqAti ITEMS {"Sim","Nao"} Size 50,10 PIXEL OF oDlgEmail
		EndIf
		//>>//Ticket 20191107000028 - Everson Santana 08.11.2019
		If __cUserId $ GetMv("ST_XOPERCO") //Chamado 000998 - Controladoria
			@ 235,100 SAY "Blq Comodato" PIXEL OF oDlgEmail
			@ 245,100 COMBOBOX cXBlqCo ITEMS {"Liberado","Bloqueado"} Size 50,10 PIXEL OF oDlgEmail
		EndIf
		//<< //Ticket 20191107000028 - Everson Santana 08.11.2019

		@ 215,200 SAY "Valor Reservado" PIXEL OF oDlgEmail
		@ 225,200 MSGet cVlRese Size 80,10 Picture "@E 9,999,999,999,999.99" when .f.	    pixel OF oDlgEmail

		@ 210,004 SAY "Saldo Pedido" PIXEL OF oDlgEmail
		@ 220,004 MSGet _nSalPv Size 80,10 Picture "@E 9,999,999,999,999.99" when .f.	    pixel OF oDlgEmail

		//observa็oes
		@ 235,004 SAY "Observa็ใo Expedi็ใo" PIXEL OF oDlgEmail
		//@ 20,300 MSGet cXObsExp Size 275,10 Picture "@!" PIXEL  OF oDlgEmail

		//@ 245,004 MSGet cXObsExp Size 90,10 F3 "OBSEXP" VALID ExistCpo("SZY",cXObsExp) PIXEL OF oDlgEmail
		@ 245,004 MSGet cXObsExp Size 90,10 F3 "OBSEXP" PIXEL OF oDlgEmail

		@ 240,300 SAY "Blq Comercial" PIXEL OF oDlgEmail
		@ 248,300 MSGet cBlqCom Size 275,8 Picture "@!"  when .f. PIXEL  OF oDlgEmail

		//@ 245, 190 Button "Ok"      Size 35,12 Action Eval({||iif(!(empty(alltrim(cTransp))),(lSaida:=.f.,nOpca:=1,oDlgEmail:End()),(MsgInfo("Preencha a Transportadora"),oDlgEmail:End()))})  Pixel OF oDlgEmail
		@ 245, 190 Button "Ok"      Size 35,12 Action Eval({||IIf(STCABECTOK(cTransp,cTpFrete,cZCodM,_dDtProg,_aAltIni,cEntFat,cTipFat),(lSaida:=.f.,nOpca:=1,oDlgEmail:End()),(oDlgEmail:End()))})  Pixel OF oDlgEmail
		@ 245, 250 Button "Cancela" Size 35,12 Action Eval({||lSaida:=.f.,nOpca:=2,oDlgEmail:End()})  Pixel OF oDlgEmail

		ACTIVATE MSDIALOG oDlgEmail CENTERED

	End

	If nOpca == 1

		//Renato Nogueira - 230114 - Verificar se houve altera็ใo no cabe็alho do pedido ap๓s confirmar
		cTipoAnt    := SC5->C5_XTIPO
		_aAltFim	:= {}
		Aadd(_aAltFim,{_cRefNF})
		Aadd(_aAltFim,{cTransp})
		Aadd(_aAltFim,{cXBlqCli})
		Aadd(_aAltFim,{cTipFat})
		Aadd(_aAltFim,{cCondPag})
		Aadd(_aAltFim,{cXObsExp})
		Aadd(_aAltFim,{cZObs})
		Aadd(_aAltFim,{cXBlqFMI})
		Aadd(_aAltFim,{cXLibAVi})
		Aadd(_aAltFim,{cXAlertF})
		Aadd(_aAltFim,{cXObsVen})
		Aadd(_aAltFim,{cXTipo})
		Aadd(_aAltFim,{cTpFrete})
		Aadd(_aAltFim,{cZEndEnt})
		Aadd(_aAltFim,{cZBairrE})
		Aadd(_aAltFim,{cZMunE})
		Aadd(_aAltFim,{cZEstE})
		Aadd(_aAltFim,{cZCepE})
		Aadd(_aAltFim,{cVlRese})
		Aadd(_aAltFim,{cXVlMin})
		Aadd(_aAltFim,{_nSalPv})
		Aadd(_aAltFim,{_cxIbl})
		Aadd(_aAltFim,{_cBlqRom})
		Aadd(_aAltFim,{_cBlqEAN})
		/*Aadd(_aAltFim,{cxDe })
		Aadd(_aAltFim,{cxAte })
		Aadd(_aAltFim,{cxMDe })
		Aadd(_aAltFim,{cxMAte })*/
		Aadd(_aAltFim,{cXBlqMkt })
		Aadd(_aAltFim,{cXBlqAti })
		Aadd(_aAltFim,{cXBlqCo })//Ticket 20191107000028 - Everson Santana 08.11.2019
		Aadd(_aAltFim,{cZCodM })
		/*Aadd(_aAltFim,{cxAnoD })
		Aadd(_aAltFim,{cxAnoA })*/
		Aadd(_aAltFim,{_cTntFob })
		Aadd(_aAltFim,{DTOC(_dDtProg) })
		Aadd(_aAltFim,{cEntFat })


		_cMsg	+= "Usuแrio: "+cUserName+CRLF
		_cMsg	+= "Alterado em: "+DTOC(DDATABASE)+" "+TIME()+CRLF
		_cMsg	+= "Campo               | Anterior                               | Novo                                   "+CRLF

		_lEnvDt := .F.

		For nX := 1 to Len(_aAltIni)

			If _aAltIni[nX][1]<>_aAltFim[nX][1] //Verifica se achou alguma diferen็a entre os valores dos arrays
				_lDif	:= .T.
				_cMsg	+= PADR(_aAltIni[nX][2],20)+"|"+PADR(SubStr(_aAltIni[nX][1],1,40),40)+"|"+PADR(SubStr(_aAltFim[nX][1],1,40),40)+CRLF

				If _aAltIni[nX][2]=="Tipo Frete"
					SC5->(RecLock("SC5",.F.))
					SC5->C5_XLOGFRE	:= "Alterado de: "+_aAltIni[nX][1]+" para: "+_aAltFim[nX][1]+" em "+DTOC(Date())+" "+Time()+" por "+cUserName+" - STFSXFUN"
					SC5->(MsUnlock("SC5"))
					SC5->(DbCommit())
				EndIf

				If _aAltIni[nX][2]== "Blq. FMI." //Libera็ใo do faturamento mํnimo

					_cAlias1 := GetNextAlias()

					_cQuery1 := " SELECT A3X.A3_EMAIL EMAIL
					_cQuery1 += " FROM "+RetSqlName("SA3")+" A3
					_cQuery1 += " LEFT JOIN "+RetSqlName("SA3")+" A3X
					_cQuery1 += " ON A3.A3_XSUPINT=A3X.A3_COD
					_cQuery1 += " WHERE A3.D_E_L_E_T_=' ' AND A3X.D_E_L_E_T_=' '
					_cQuery1 += " AND A3.A3_CODUSR='"+__cUserId+"'

					If !Empty(Select(_cAlias1))
						DbSelectArea(_cAlias1)
						(_cAlias1)->(dbCloseArea())
					Endif

					dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

					dbSelectArea(_cAlias1)

					(_cAlias1)->(dbGoTop())

					If (_cAlias1)->(!Eof())

						_cEmail	  := (_cAlias1)->EMAIL
						_cAssunto := "[STECK] - Pedido "+AllTrim(SC5->C5_NUM)+" foi alterado faturamento mํnimo
						cMsg := ""
						cMsg += '<html><head><title></title></head><body>'
						cMsg += '<b>Pedido: </b>'+Alltrim(SC5->C5_NUM)+'<br>
						cMsg += '<b>Cliente: </b>'+Alltrim(SA1->A1_NOME)+'<br>
						cMsg += '<b>Usuแrio: </b>'+Alltrim(Alltrim(UsrRetName(__cUserId)))+'<br>
						cMsg += '<b>Valor: </b>'+cValToChar(U_SALDPVST(SC5->C5_NUM))+'<br>
						cMsg += '<b>Cond. Pag.: </b>'+Alltrim(SC5->C5_CONDPAG+" - "+Posicione("SE4",1,xFilial("SE4")+SC5->C5_CONDPAG,"E4_DESCRI"))+'<br>
						cMsg += '</body></html>'

						U_STMAILTES(_cEmail,"",_cAssunto,cMsg,{},"")

					EndIf

				EndIf

				If _aAltIni[nX][2]== "Cond. Pag."
					//giovani zago	06/03/17 chamado: 005010

					_cEmail	:= " CLAYTON.BRAGA@steck.com.br;DAVI.SOUZA@steck.com.br  "
					_cAssunto := "Altera็ใo de Cond.Pagamento Pedido: "+SC5->C5_NUM
					cMsg := ""
					cMsg += '<html><head><title></title></head><body>'
					cMsg +=  "Alterado de: "+_aAltIni[nX][1]+"("+SUBSTR(Alltrim(Posicione("SE4",1,xFilial("SE4")+_aAltIni[nX][1],"E4_DESCRI")),1,40)	+") para: "+_aAltFim[nX][1]+"("+SUBSTR(Alltrim(Posicione("SE4",1,xFilial("SE4")+_aAltFim[nX][1],"E4_DESCRI")),1,40)	+") em "+DTOC(Date())+" "+Time()+" por "+cUserName+" - STFSXFUN" ;
						+' </body></html>'

					If !U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)
						//MsgAlert("Problemas no envio de email!")
					EndIf

				EndIf

				//Chamado 008763
				If ( (_aAltIni[nX][2]=="Dia De" .Or.;
						_aAltIni[nX][2]=="Dia Ate" .Or.;
						_aAltIni[nX][2]=="Mes De" .Or.;
						_aAltIni[nX][2]=="Mes Ate" .Or.;
						_aAltIni[nX][2]=="Ano de" .Or.;
						_aAltIni[nX][2]=="Ano Ate") .And.;
						(SC5->C5_VEND1 $ GetMv("ST_VENDENG",,"I08595#I08598#I08569#I08588") .Or. SC5->C5_VEND2 $ GetMv("ST_VENDENG",,"I08595#I08598#I08569#I08588") ) )

					_cCaminho   := ""
					_aAttach	:= {}
					_cCopia 	:= ""
					_cEmail		:= "filipe.nascimento@steck.com.br"
					_cAssunto 	:= "Altera็ใo de data de programa็ใo: "+SC5->C5_NUM

					cMsg := ""
					cMsg += '<html><head><title></title></head><body>
					cMsg += "Em "+DTOC(Date())+" - "+Time()+" por "+cUserName+" - STFSXFUN<br><br>
					cMsg += "<table border='1'><tr><td>Campo</td><td>Alterado de</td><td>Alterado para</td>
					cMsg += '<tr><td>'+_aAltIni[23][2]+'</td><td>'+_aAltIni[23][1]+'</td><td>'+_aAltFim[25][1]+'</td></tr>
					cMsg += '<tr><td>'+_aAltIni[24][2]+'</td><td>'+_aAltIni[24][1]+'</td><td>'+_aAltFim[26][1]+'</td></tr>
					cMsg += '<tr><td>'+_aAltIni[25][2]+'</td><td>'+_aAltIni[25][1]+'</td><td>'+_aAltFim[27][1]+'</td></tr>
					cMsg += '<tr><td>'+_aAltIni[26][2]+'</td><td>'+_aAltIni[26][1]+'</td><td>'+_aAltFim[28][1]+'</td></tr>
					cMsg += '<tr><td>'+_aAltIni[30][2]+'</td><td>'+_aAltIni[30][1]+'</td><td>'+_aAltFim[32][1]+'</td></tr>
					cMsg += '<tr><td>'+_aAltIni[31][2]+'</td><td>'+_aAltIni[31][1]+'</td><td>'+_aAltFim[33][1]+'</td></tr>
					cMsg += '</table></body></html>'

					If !_lEnvDt
						_lEnvDt := .T.
						U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)
					EndIf

				EndIf

				/*
				If _aAltIni[nX][2] $ "Dia De/Dia Ate/Mes De/Mes Ate/Ano de/Ano Ate"
				//giovani zago	06/03/17 chamado: 005010

				_cEmail	:= "GIOVANI.ZAGO@steck.com.br;tereza.mello@steck.com.br  "
				_cAssunto := "Altera็ใo De/Ate  Pedido: "+SC5->C5_NUM
				cMsg := ""
				cMsg += '<html><head><title></title></head><body>'
				cMsg +=  "Alterado de: "+_aAltIni[23][1]+"/"+_aAltIni[25][1]+"/"+_aAltIni[30][1]+" para: "  +_aAltFim[23][1]+"/"+_aAltFim[25][1]+"/"+_aAltFim[30][1]+" em "+DTOC(Date())+" "+Time()+" por "+cUserName+" - STFSXFUN" ;
				+' </body></html>'

					If !U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)
				//MsgAlert("Problemas no envio de email!")
					EndIf

				//EndIf

				EndIf
				*/
			EndIf

			/***********************************************************************************************************************
			Fonte........: MSTECK15
			a็ใo.........: Fun็ใo para cแlculo dos dias da entrega progamada do Or็amento
			Desenvolvedor: Marcelo Klopfer Leme
			Data.........: 01/06/2022
			Chamado......: 20220429009114 - Oferta Logํstica
			***********************************************************************************************************************/
			IF _aAltIni[nX][2]== "Ent. Prog. Cliente"
				RECLOCK("SC5",.F.)
				SC5->C5_XDTENPR := _dDtProg
				SC5->C5_XENTFAT := cEntFat
				IF EMPTY( _dDtProg )
					SC5->C5_XDE     := ' '
					SC5->C5_XMDE    := ' '
					SC5->C5_XDANO 	:= ' '
					SC5->C5_XATE    := ' '
					SC5->C5_XMATE   := ' '
					SC5->C5_XAANO  	:= ' '
				else
					SC5->C5_XDE     := SUBSTR(DTOS(SC5->C5_EMISSAO),7,2) 
					SC5->C5_XMDE    := SUBSTR(DTOS(SC5->C5_EMISSAO),5,2)
					SC5->C5_XDANO 	:= SUBSTR(DTOS(SC5->C5_EMISSAO),1,4)
					SC5->C5_XATE    := IIF(cEntFat=='1',SUBS(DTOS(U_STTMKG04(_dDtProg,.T.)),7,2),SUBS(DTOS(_dDtProg-1),7,2))
					SC5->C5_XMATE   := IIF(cEntFat=='1',SUBS(DTOS(U_STTMKG04(_dDtProg,.T.)),5,2),SUBS(DTOS(_dDtProg-1),5,2))
					SC5->C5_XAANO  	:= IIF(cEntFat=='1',SUBS(DTOS(U_STTMKG04(_dDtProg,.T.)),1,4),SUBS(DTOS(_dDtProg-1),1,4))				
				ENDIF
				SC5->(MSUNLOCK("SC5"))


				SC6->(DbSetOrder(1))
				SC6->(DbSeek(xFilial('SC6')+SC5->C5_NUM))
				While SC6->(! Eof() .and. C6_FILIAL+C6_NUM == xFilial('SC6')+SC5->C5_NUM)
					SC6->(RecLock("SC6",.F.))
						SC6->C6_ZENTREP := _dDtProg
					SC6->(MsUnlock()) 
					SC6->(DbSkip())
				End
			ENDIF

		Next
		U_STMAILPV (2,_aAltIni,_aAltFim)//Chamado 002881
		If _lDif
			SC5->(RecLock("SC5",.F.))
			MSMM(SC5->C5_XALTCAB,,,_cMsg,1,,,"SC5","C5_XALTCAB",,.T.)
			SC5->(MsUnlock("SC5"))
			SC5->(DbCommit())
		EndIf



		//-------------------------------------------------------------------------------------------------

		SC5->(RecLock("SC5",.F.))
		SC5->C5_TRANSP	:= cTransp
		SC5->C5_XTIPF	:= Iif(Substr(cTipFat,1,1)=="T","1","2")
		SC5->C5_XOBSEXP	:= cXObsExp
		SC5->C5_ZOBS	:= cZObs
		SC5->C5_XALERTF := cXAlertF
		SC5->C5_XOBSVEN := cXObsVen
		SC5->C5_XTIPO   := Iif(Substr(cXTipo,1,1)=="R","1","2")
		SC5->C5_TPFRETE := Iif(Substr(cTpFrete,1,1)=="P","T",Substr(cTpFrete,1,1))
		SC5->C5_ZENDENT := cZEndEnt
		SC5->C5_ZBAIRRE := cZBairrE
		SC5->C5_ZMUNE   := cZMunE
		SC5->C5_ZESTE   := cZEstE
		SC5->C5_ZCEPE   := cZCepE
		SC5->C5_XCODMUN := cZCodM

		/*If GetMv("STFSXFUN01",,.T.)

			If __cUserID $ AllTrim(GetMv("STFSXFUN02",,"001583#000000"))

		SC5->C5_XDE     := cxDe
		SC5->C5_XATE    := cxAte
		SC5->C5_XMDE    := cxMDe
		SC5->C5_XMATE   := cxMAte
		SC5->C5_XDANO 	:= cxAnoD
		SC5->C5_XAANO  	:= cxAnoA

			EndIf

		EndIf*/

		SC5->C5_XTNTFOB := Iif(Substr(_cRefNF,1,1)=="B","1"," ")   //giovani zago 20/06/13
		SC5->C5_ZREFNF  := Iif(Substr(_cRefNF,1,1)=="B","1"," ")   //giovani zago 20/06/13
		SC5->C5_XIBL    := Iif(Substr(_cxIbl,1,1)=="1","1","2")
		SC5->C5_XBLQROM := IIf(Substr(_cBlqRom,1,1)=="S","1","2")
		SC5->C5_XREAN14 := IIf(Substr(_cBlqEAN,1,1)=="S","1","2")
		If _cUser $ cMV_XLIBFMI
			SC5->C5_CONDPAG := cCondPag
			SC5->C5_ZCONDPG := cCondPag
			SC5->C5_XLIBAVI	:= Substr(cXLibAVi,1,1)
		EndIf
		SC5->C5_XBLQFMI	:= Substr(cXBlqFMI,1,1)
		If __cUserId $ GetMv("ST_USRMKT")

			If SC5->C5_XPEDMKT=="S" .And. AllTrim(Substr(cXBlqMkt,1,1))=="N" .And. SC5->C5_FILIAL=="02" //Chamado 001209

				_cEmail	  := GetMv("ST_MAILALM")

				_cAssunto := 'O pedido do marketing - '+SC5->C5_NUM+' - foi liberado para separacao'
				cMsg := ""
				cMsg += '<html><head><title>'+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title></head><body>'
				cMsg += '<b>Pedido: </b>'+Alltrim(SC5->C5_NUM)+'<br><b>Filial: </b>'+SC5->C5_FILIAL
				cMsg += '<table border="4">'
				cMsg += '<tr><td>ITEM</td><td>PRODUTO</td><td>QTDE</td><td>FALTA</td>'

				_aAreaSC6	:= SC6->(GetArea())
				_aAreaPA1	:= PA1->(GetArea())

				DbSelectArea("SC6")
				SC6->(DbSetOrder(1))
				SC6->(DbGoTop())

				If SC6->(DbSeek(SC5->(C5_FILIAL+C5_NUM)))

					While SC6->(!Eof()) .And. SC5->(C5_FILIAL+C5_NUM)==SC6->(C6_FILIAL+C6_NUM)

						DbSelectArea("PA1")
						PA1->(DbSetOrder(2))
						PA1->(DbGoTop())

						If PA1->(DbSeek(xFilial("PA1")+"1"+AllTrim(SC6->(C6_NUM+C6_ITEM))))

							cMsg += '<tr><td>'+SC6->C6_ITEM+'</td><td>'+SC6->C6_PRODUTO+'</td><td>'+CVALTOCHAR(SC6->C6_QTDVEN)+'</td>'+'<td>'+CVALTOCHAR(PA1->PA1_QUANT)+'</td>'

						EndIf

						SC6->(DbSkip())

					EndDo

				EndIf

				RestArea(_aAreaPA1)
				RestArea(_aAreaSC6)

				cMsg += '</table></body></html>'

				If !U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)
					MsgInfo("Problemas no envio de email!")
				EndIf

			EndIf

			SC5->C5_XPEDMKT	:= Substr(cXBlqMkt,1,1)
		EndIf
		If __cUserId $ GetMv("ST_ATIVOUS")
			SC5->C5_XOPER32	:= Substr(cXBlqAti,1,1)
		EndIf
		//>>//Ticket 20191107000028 - Everson Santana 08.11.2019
		If __cUserId $ GetMv("ST_XOPERCO")

			If Substr(cXBlqCo,1,1) $ "L#l"
				SC5->C5_XOPERCO	:= "1"
			ElseIf Substr(cXBlqCo,1,1) $ "B#b"
				SC5->C5_XOPERCO	:= "2"
			EndIf

		EndIf
		//<<//Ticket 20191107000028 - Everson Santana 08.11.2019

		SC5->(MsUnlock())
		SC5->(DbCommit())

		// Valdemir Rabelo 17/06/2021 Ticket: ticket Nบ 20210211002338 / 20210601009141
		if lAtiva .and. (Substr(cXTipo,1,1)=='R') .and. (cTipoAnt != iif(Substr(cXTipo,1,1)=="R",'1','2'))
			cEmlCli :=  ALLTRIM(SA1->A1_EMAIL)
			cEmlCli := FWInputBox("Informe o(s) e-mail(s) para envio do WF", cEmlCli)
			if !Empty(SC5->C5_VEND1)
				cEmlCli += "," + Alltrim(Lower(Posicione("SA3",1,xFilial("SA3")+SC5->C5_VEND1,"A3_EMAIL")))
			Endif
			if !Empty(SC5->C5_VEND2)
				cEmlCli += "," + Alltrim(Lower(Posicione("SA3",1,xFilial("SA3")+SC5->C5_VEND2,"A3_EMAIL")))
			Endif
			IF SC5->( FIELDPOS('C5_XEMAILR') > 0)
				if !Empty(cEmlCli)
					RecLock("SC5",.F.)
					SC5->C5_XEMAILR := cEmlCli
					SC5->( MsUnlock() )
				endif
			ELSE
				MsgInfo("Campo C5_XEMAILR nใo foi criado. Favor informar o TI","Aten็ใo!")
			ENDIF
		Endif


		lParcial := SC5->C5_XTIPF == '2'
		U_STGrvSt(SC5->C5_NUM,lParcial)

		If SC5->C5_XIBL  = '1' .And. _cxoldibl ='2' .And. cfilant = '02'

			StartJob("U_StResiduo",GetEnvServer(), .T.,'01', '01',SC5->C5_NUM,1)
			If !_lxret
				SC5->(RecLock("SC5",.F.))
				SC5->C5_XIBL    := '2'
				SC5->(MsUnlock())
				SC5->(DbCommit())
			Endif
		Endif

	Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTFSVECB7 บAutor  ณLeonardo Kichitaro  บ Data ณ  22/03/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao para verificar se existe OS em aberto para o pedido  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function STFSVECB7()

	Local lRet	:= .T.
	Local nOpc	:= PARAMIXB[1]

	If nOpc == 4 .Or. nOpc == 5
		dbSelectArea("SC6")
		dbSetOrder(1)
		If dbSeek(xFilial("SC6")+SC5->C5_NUM)
			If Posicione("SF4",1,XFILIAL("SF4")+SC6->C6_TES,"F4_ESTOQUE") == "S"
				dbSelectArea("CB7")
				dbSetOrder(2)
				dbSeek(xFilial("CB7")+SC5->C5_NUM)
				While !Eof() .And. CB7_FILIAL == xFilial("CB7") .And. CB7_PEDIDO == SC5->C5_NUM
					If CB7->CB7_STATUS <> "9"
						MsgAlert("Existe ordem de separa็ใo em aberto para esse pedido de venda nใo serแ possํvel "+Iif(nOpc == 4,"Alterar.","Excluir."),"Aten็ใo")
						lRet := .F.
						Exit
					EndIf
					dbSkip()
				EndDo
			EndIf
		EndIf
	EndIf

Return lRet
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTFSXRES  บAutor  ณLeonardo Kichitaro  บ Data ณ  12/03/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao para buscar o valor reservado do pedido              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function STFSXRES(cPedidoSC5, pTipo)

	Local aArea 	:= GetArea()
	Local aAreaPA2	:= PA2->(GetArea())
	Local nVlReserv	:= 0
	Local nRet		:= 0
	Default pTipo   := ""

	dbSelectArea("SB1")                    // ---- Valdemir Rabelo 25/04/2022 - Chamado: 20220407007598
	dbSetOrder(1)
	DbSelectArea("PA2")
	DbSetOrder(3)
	DbSeek(xFilial("PA2")+cPedidoSC5)
	While !Eof() .And. SubStr(PA2_DOC,1,6) == cPedidoSC5
		DbSelectArea("SC6")
		DbSetOrder(2)
		SB1->( dbSeek(xFilial('SB1')+SC6->C6_PRODUTO) )
		If DbSeek(xFilial("SC6")+PA2->PA2_CODPRO+PA2->PA2_DOC)
			   nVlReserv += ( SC6->C6_ZVALLIQ / SC6->C6_QTDVEN ) * PA2->PA2_QUANT
		EndIf
		DbSelectArea("PA2")
		dbSkip()
	EndDo

	nRet := nVlReserv

	RestArea(aAreaPA2)
	RestArea(aArea)

Return nRet
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTFSXFUN  บAutor  ณMicrosiga           บ Data ณ  11/01/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao para transferencia entre armazens de producao e      บฑฑ
ฑฑบ          ณexpedicao                                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function STTranArm(cPedido,cOP,cxOPER,lTela)
	Local cArmExp 	:= GetMv("FS_ARMEXP")
	Local cArmEst 	:= GetMv("FS_ARMEST")
	Local cEndPad	:= Iif(Empty(cPedido),GetMv("FS_ENDEXP",.F.,"EMBALAGEM"),GetMv("FS_ENDPAD",.F.,"PRODUCAO"))
	Local cTipDoc 	:= Iif(Empty(cPedido),"2","1")
	Local cArmComp	:= Iif(cTipDoc == "1",cArmExp,cArmEst)
	Local aArmAnt	:= {}
	Local cArmProd	:= GetMv("FS_LOCPROD",.F.,"90")
	Local aTransf	:= {}
	Local nX		:= 0
	Local lTransf	:= .T.
	Local cPerg       	:= "STGIOSD4"
	Local cTime         := Time()
	Local cHora         := SUBSTR(cTime, 1, 2)
	Local cMinutos    	:= SUBSTR(cTime, 4, 2)
	Local cSegundos   	:= SUBSTR(cTime, 7, 2)
	Local lRetransf := IsInCallStack("U_STKMNTP") .Or. IsInCallStack("U_JOBTRFOP")
	PRIVATE cAlias3   	    := cPerg+cHora+ cMinutos+cSegundos
	//As funcoes abaixo podem parecer duplicadas, mas foram reescritas
	//por se tratar de apenas 1 item

	//-----------------------------------------------------------------------------------------------------------//
	//FR - 29/09/2022 - Ticket #20220928018340 - reprocessar transfer๊ncia (qdo nใo realizada via coletor)
	Default lTela := .F.  	//esta variแvel indicarแ se a chamada veio direto do Protheus e nใo via coletor,
							//se for via coletor, lTela = .F. , 
							//se for via tela de prioridade, esta variแvel fica = .T.
	//-----------------------------------------------------------------------------------------------------------//							

	//Verifica se sera necessario realizar a transferencia entre os armazens
	If cTipDoc == "2" 
		cArmComp := cArmProd
		aTransf := VerTransf(cTipDoc,cArmProd)
		
	Else
		Return //Quando ้ armaz้m 01 nใo hแ mais necessidade de transferir para o armz้m 03 (antigo conceito de OS pai e filha)
		aTransf := VerTransf(cTipDoc,cArmComp)
	Endif

	If len(aTransf) == 0
		Return
	Endif
	//Verifica se o endereco padrao para a transferencia existe
	If !SBE->(DbSeek(xFilial("SBE")+cArmComp+cEndPad)) 
		SBE->(RecLock("SBE",.T.))
		SBE->BE_FILIAL	:= xFilial("SBE")
		SBE->BE_LOCAL	:= cArmComp
		SBE->BE_LOCALIZ:= cEndPad
		SBE->BE_DESCRIC:= cEndPad
		SBE->BE_STATUS := "1"
		SBE->BE_DATGER := dDataBase
		SBE->BE_HORGER := Time()
		SBE->(MsUnlock())
		SBE->(DbCommit())

	Endif
	If cTipDoc = '2'
		U_STSD4QUER(cOP,aTransf)
	EndIf
	//Begin Transaction
	//Apaga empenhos (SC9/SD4/SDC) - ver sc6
	DelEmp(cTipDoc,aTransf,cArmComp)

	If cTipDoc == "1"
		AtuLocSC6(1,aTransf,cArmComp,cPedido,@aArmAnt)

		lTransf := .F.
		For nX := 1 To Len(aTransf)
			If aTransf[nX,3] <> cArmEst
				lTransf := .T.
				Exit
			EndIf
		Next
	EndIf

	//Transfere os produtos
	If lTransf			
		//FR - 29/09/2022 - Ticket #20220928018340 - reprocessar transfer๊ncia (qdo nใo realizada via coletor)
		If !TransfArm(aTransf,cxOPER,lTela)
			DisarmTransaction()
			If lTela == Nil .or. !lTela  //FR - 29/09/2022 - alerta para coletor s๓ exibe no coletor, na tela Protheus, nใo exibe
				If !ISINCALLSTACK("U_JOBTRFOP")
					VtAlert("Problemas na transferencia estoques!")
				else
					conout("U_JOBTRFOP-Erro na transa็ใo de transfer๊ncia")
				Endif
			Elseif lTela 
				MsgAlert("Problemas na Transfer๊ncia Estoques!")
			Endif 
			//FR - 29/09/2022 - Ticket #20220928018340 - reprocessar transfer๊ncia (qdo nใo realizada via coletor)
			If !lRetransf
				Break
			else
				Return
			Endif	
		Endif
	EndIf
	//Refaz empenhos
	CriaEmp(cTipDoc,aTransf,cArmComp,Iif(cTipDoc == "1",cPedido,cOP))
	//End Transaction
	/*
	GeraSD4/sc9
	GeraSDC
	AjustaCB7
	AjustaCB8
	AjustaCB9
	*/
	//FR -05/10/2022 - atualiza็ใo do empenho quando reprocessar transf do 01 para 90: 
	If lTransf
		If lTela <> Nil
			If lTela //s๓ faz se a chamada vier de dentro do Protheus, pela rotina "Reprocessa Transf 90"
				U_FATUSD4(aTransf,cOP)	
			Endif 
		Endif 
	Endif 
	//FR -05/10/2022 - atualiza็ใo do empenho quando reprocessar transf do 01 para 90: 

Return

//=================================================================================================//
//Fun็ใo  : STTRANML - TRANSFERสNCIA "MERCADO LIVRE"
//Autoria : Flแvia Rocha
//Data    : 10/05/2023
//Objetivo: Possibilitar a transfer๊ncia do armaz้m 03 para 06 (Mercado Livre) ap๓s a finaliza็ใo
//          da embalagem (o pedido nใo serแ faturado, serแ transferido e depois encerrado)
//=================================================================================================//
User Function STTranML(cOS,cPedido,cArML,cEndML,cxOPER,lTela)
	
	Local cEndPad   := cEndML
	//Local cTipDoc 	:= Iif(Empty(cPedido),"2","1")
	//Local aArmAnt	:= {}
	Local aTransf	:= {}
	//Local nX		:= 0
	Local lTransf	:= .T.
	//Local cPerg       	:= "STGIOSD4"
	Local cTime         := Time()
	//Local cHora         := SUBSTR(cTime, 1, 2)
	//Local cMinutos    	:= SUBSTR(cTime, 4, 2)
	//Local cSegundos   	:= SUBSTR(cTime, 7, 2)
	Local lTransfOK     := .F.

	//PRIVATE cAlias3   	    := cPerg+cHora+ cMinutos+cSegundos
	
	//-----------------------------------------------------------------------------------------------------------//
	//FR - 29/09/2022 - Ticket #20220928018340 - reprocessar transfer๊ncia (qdo nใo realizada via coletor)
	Default lTela := .F.  	//esta variแvel indicarแ se a chamada veio direto do Protheus e nใo via coletor,
							//se for via coletor, lTela = .F. , 
							//se for via tela de prioridade, esta variแvel fica = .T.
	//-----------------------------------------------------------------------------------------------------------//							

	aTransf := VerTranML(cOS,cArML)  //MONTA O ARRAY DE ITENS QUE SERม USADO NA TRANSFERสNCIA
	
	If len(aTransf) == 0
		Return
	Endif
	
	//Verifica se o endereco padrao para a transferencia existe
	If !SBE->(DbSeek(xFilial("SBE")+cArML+cEndPad))
		SBE->(RecLock("SBE",.T.))
		SBE->BE_FILIAL	:= xFilial("SBE")
		SBE->BE_LOCAL	:= cArML
		SBE->BE_LOCALIZ:= cEndPad
		SBE->BE_DESCRIC:= cEndPad
		SBE->BE_STATUS := "1"
		SBE->BE_DATGER := dDataBase
		SBE->BE_HORGER := Time()
		SBE->(MsUnlock())
		SBE->(DbCommit())

	Endif
	
	//Transfere os produtos
	If lTransf			
		//FR - 29/09/2022 - Ticket #20220928018340 - reprocessar transfer๊ncia (qdo nใo realizada via coletor)
		//If !TransfArm(aTransf,cxOPER,lTela,cArML,cEndML,cOS)				
		Processa( {|| lTransfOK := MLTransf(aTransf,cxOPER,lTela,cArML,cEndML,cOS) }, "Aguarde...", "Efetuando Transfer๊ncia...",.T.)
		If !lTransfOK

			DisarmTransaction()
			If lTela == Nil .or. !lTela  //FR - 29/09/2022 - alerta para coletor s๓ exibe no coletor, na tela Protheus, nใo exibe
				VtAlert("Problemas na transferencia estoques!")
			Elseif lTela 
				Alert("Problemas na Transfer๊ncia Estoques!")
			Endif 
			//FR - 29/09/2022 - Ticket #20220928018340 - reprocessar transfer๊ncia (qdo nใo realizada via coletor)
			lTransfOK := .F.
			Break
		Else 
			lTransfOK := .T.
			MsgInfo("Transfer๊ncia Realizada Com Sucesso")
		Endif
	EndIf
	
Return(lTransfOK)   //RETORNA .T. OU .F. PARA SABER SE A TRANSFERสNCIA PARA MERCADO LIVRE FOI FEITA COM SUCESSO OU NรO
					//SE A TRANSF NรO FOI REALIZADA, NรO PODE FINALIZAR A EMBALAGEM


//===============================================================================//
//FR -05/10/2022 - atualiza็ใo do empenho quando reprocessar transf do 01 para 90
//===============================================================================//
//FUNวรO  :FATUSD4 
//OBJETIVO:Atualizar os empenhos dos produtos na SD4 p๓s transferencia do 01 p/ 90
//         via rotina "Reprocessa Transf. 90"
//AUTORIA : Flแvia Rocha
//DATA    : 05/10/2022
//===============================================================================//
USER FUNCTION FATUSD4(aTransf,cOP)
Local i    := 0
Local nPos := 0
//CB9->(Aadd(aRet,{CB9_PROD,CB9_QTESEP,CB9_LOCAL,cArmComp,CB9_LCALIZ,CB9_LOTSUG,CB9_SLOTSU,"",""}))

If Len(aTransf) > 0
	For i := 1 to Len(aTransf)
		SD4->(DbSetOrder(2))
		SD4->(DbSeek(xFilial('SD4')+Alltrim(cOP)))
		While SD4->(! Eof() .and. D4_FILIAL+ Alltrim(D4_OP) == xFilial('SD4') + Alltrim(cOP) )
			/*
			If ( nPos := ascan(aTransf,{|x| x[1] == SD4->D4_COD}) ) == 0
				SD4->(DBSkip())
				Loop
			EndIf
			If Empty(SD4->D4_XORDSEP)
				SD4->(DBSkip())
				Loop
			Endif
			*/
			//se for o produto na SD4 for o mesmo q tแ no array da transfer๊ncia, atualiza o empenho
			If Alltrim(SD4->D4_COD) == Alltrim(aTransf[i,1])
				//se o local que tแ gravado no empenho for diferente, atualiza
				If SD4->D4_LOCAL <> aTransf[i,4]
					If Reclock("SD4" , .F.)					
						SD4->D4_LOCAL := aTransf[i,4]
						SD4->(MsUnlock())
					Endif 
				Endif 
			Endif 

			SD4->(DbSkip())
		Enddo
	Next 
Endif 

RETURN
//FR -05/10/2022 - atualiza็ใo do empenho quando reprocessar transf do 01 para 90

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAtuLocSC6 บAutor  ณLeonardo Kichitaro  บ Data ณ  01/04/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Atualiza C6_LOCAL antes de atualizar Saldo                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AtuLocSC6(nOpc,aTransf,cArmComp,cDoc,aArmAnt)

	Local nReserva	:= 0
	Local nCont		:= 0

	SC6->(DbSetOrder(1))
	SC9->(DbSetOrder(1)) //C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_SEQUEN+C9_PRODUTO

	SC6->(DbSeek(xFilial('SC6')+cDoc))
	While SC6->(! Eof() .and. C6_FILIAL+C6_NUM == xFilial('SC6')+cDoc)
		If ( nPos := ascan(aTransf,{|x| x[1] == SC6->C6_PRODUTO}) ) == 0
			SC6->(DbSkip())
			Loop
		Endif

		nCont ++
		/*
		If nOpc == 1
		aAdd(aArmAnt,C6_LOCAL)
		EndIf
		*/
		//Ajusta o armazem no PEDIDO DE VENDA
		/*	SC6->(RecLock("SC6",.F.))
		SC6->C6_LOCAL := cArmComp //If(nOpc == 1,cArmComp,aArmAnt[nCont])
		SC6->(MsUnlock())
		*/	//Retirado no dia 09/04/13 pois estแ gerando c6_local errado
		SC6->(DbSkip())
	End

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  VERTRANSF  บAutor  ณMicrosiga           บ Data ณ  11/01/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica se existe a necessidade de transferencia          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function VerTransf(cTipDoc,cArmComp,cxOPER)
	Local aCB9Area	:= CB9->(GetArea())
	Local aArea		:= GetArea()
	Local aRet		:= {}
	Local lRetransf := IsInCallStack("U_STKMNTP") .Or. IsInCallStack("U_JOBTRFOP")
	//Como estou posicionado no CB7, vou buscar o CB9 para a comparacao do armazem
	CB9->(DbSetOrder(1)) //CB9_FILIAL+CB9_ORDSEP+CB9_CODETI
	CB9->(DbSeek(xFilial("CB9")+CB7->CB7_ORDSEP))
	While CB9->(!Eof() .and. CB9_FILIAL+CB9_ORDSEP == xFilial("CB9")+CB7->CB7_ORDSEP)
		If !(CB9->CB9_LOCAL == cArmComp) .and. CB9->CB9_STATUS == "1" .oR. lRetransf
			//                      produto  quantidade  local     local dest endereco   lote      sublote D4_TRT D4_OPORIG
			CB9->(Aadd(aRet,{CB9_PROD,CB9_QTESEP,CB9_LOCAL,cArmComp,CB9_LCALIZ,CB9_LOTSUG,CB9_SLOTSU,"",""}))
		Endif
		CB9->(DbSkip())
	End

	RestArea(aCB9Area)
	RestArea(aArea)
Return aRet

/*
//==========================================================================//
// Programa  ณVERTRANML  - Autoria: Flแvia Rocha            Data: 10/05/2023 
//==========================================================================//
// Desc.      Povoa o array com itens da CB9 a serem transferidos.        
//            A transfer๊ncia de pedidos MELI s๓ ้ feita caso o cliente
//            esteja parametrizado no campo A1_XAMZTRF com o c๓digo do 
//		      armaz้m para transferir (06) 
//            MERCADO LIVRE                                                     
//==========================================================================//
*/
Static Function VerTranML(cOS,cArML)
	Local aCB9Area	:= CB9->(GetArea())
	Local aArea		:= GetArea()
	Local aRet		:= {}
	Local nPosProd  := 0

	
	//Como estou posicionado no CB7, vou buscar o CB9 para a comparacao do armazem	
	//Status CB9: 
	//1=Em Aberto;2=Embalagem Finalizada;3=Embarcado                                                                                  
	CB9->(DbSetOrder(1)) //CB9_FILIAL+CB9_ORDSEP+CB9_CODETI
	CB9->(DbSeek(xFilial("CB9")+ cOS))
	While CB9->(!Eof() .and. CB9_FILIAL+CB9_ORDSEP == xFilial("CB9")+ cOS)

		If CB9->CB9_STATUS == "2" //STATUS = "2" -> EMBALAGEM FINALIZADA
			nPosProd	:= AScan(aRet,{ |x| Alltrim(x[1]) == Alltrim(CB9->CB9_PROD) } ) 
			
			If nPosProd == 0  //se nใo tiver, adiciona
				CB9->(Aadd(aRet,{;
					CB9_PROD ,;		//1-PRODUTO
					 CB9_QTESEP,;	//2-QUANTIDADE
					 CB9_LOCAL,;	//3-LOCAL ORIGEM
					 cArML,;		//4-LOCAL DESTINO
					 CB9_LCALIZ,;	//5-ENDEREวO
					 CB9_LOTSUG,;	//6-LOTE
					 CB9_SLOTSU,;	//7-SUBLOTE
					 ""     ,;		//8-D4_TRT
					 ""      ,;		//9-D4_OPORIG
					 CB9_PEDIDO,;	//10-PEDIDO
					 CB9_VOLUME;	//11-NRO. VOLUME
					  }))
				
			Else 
			//se jแ existir, soma a qtde ao que jแ estแ embalado, pois pode haver produto que foi desmembrada a qtde em 2 volumes por exemplo
			//produto com qtde = 10, embalado em 2 volumes de 5 cada
				aRet[nPosProd,2] += CB9->CB9_QTESEP
			Endif 
		Endif
		CB9->(DbSkip())
	End

	RestArea(aCB9Area)
	RestArea(aArea)
Return aRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTFSXFUN  บAutor  ณMicrosiga           บ Data ณ  11/01/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณApaga os empenhos SC9/SD4/SDC                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function DelEmp(cTipDoc,aTransf,cArmComp)
	Local aSC6Area	:= SC6->(GetArea())
	Local aSD4Area	:= SD4->(GetArea())
	Local aArea		:= GetArea()
	Local aTravas	:= {}

	If cTipDoc == "1" // pedido
		SC6->(DbSetOrder(1))
		SC9->(DbSetOrder(1)) //C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_SEQUEN+C9_PRODUTO

		SC6->(DbSeek(xFilial('SC6')+CB7->CB7_PEDIDO))
		While SC6->(! Eof() .and. C6_FILIAL+C6_NUM == xFilial('SC6')+CB7->CB7_PEDIDO)
			If ( nPos := ascan(aTransf,{|x| x[1] == SC6->C6_PRODUTO}) ) == 0
				SC6->(DbSkip())
				Loop
			Endif

			U_STDelSDC(SC6->C6_NUM,SC6->C6_PRODUTO,Iif(Empty(CB7->CB7_XOSPAI),CB7->CB7_ORDSEP,CB7->CB7_XOSPAI),SC6->(Recno()),.F.)

			SC6->(DbSkip())
		End
	Else
		//GIOVANI NOVA SD4

		SD4->(DbSetOrder(2))
		SD4->(DbSeek(xFilial('SD4')+Alltrim(CB7->CB7_OP)))
		While SD4->(! Eof() .and. D4_FILIAL+Alltrim(D4_OP) == xFilial('SD4')+Alltrim(CB7->CB7_OP))
			If ( nPos := ascan(aTransf,{|x| x[1] == SD4->D4_COD}) ) == 0
				SD4->(DBSkip())
				Loop
			EndIf
			If Empty(SD4->D4_XORDSEP)
				SD4->(DBSkip())
				Loop
			Endif
			aTransf[nPos,8] := SD4->D4_TRT
			aTransf[nPos,9] := SD4->D4_OPORIG
			U_STDelSDC(CB7->CB7_OP,SD4->D4_COD,CB7->CB7_ORDSEP,SD4->(Recno()))
			SD4->(DbSkip())
		End
	EndIf

	RestArea(aSC6Area)
	RestArea(aSD4Area)
	RestArea(aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออั	ออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTFSXFUN  บAutor  ณMicrosiga           บ Data ณ  11/01/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRealiza a transferencia de armazem                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function TransfArm(aDados,cxOPER,lTela,cArML,cEndML,cOS)

	Local dValid	:= dDatabase
	Local aArea		:= GetArea()
	Local aSB1Area	:= SB1->(GetArea())
	//Local cEndPad	:= Iif(!Empty(CB7->CB7_PEDIDO),GetMv("FS_ENDEXP",.F.,"EMBALAGEM"),GetMv("FS_ENDPAD",.F.,"PRODUCAO"))
	Local cEndPad	:= ""
	Local nI
	Local nxQuant := 0
	Local _cEmail  := " xarles.silva@steck.com.br "
	Local _cCopia  := " "//Ticket 20201110010294
	//Local _cAssunto:= 'Erro de transfer๊ncia - ('+CB7->CB7_ORDSEP +')'
	Local _cAssunto:= " "
	Local cMsg	   := ""
	Local cAttach  := ''
	Local _aAttach := {}
	Local cCaminho := ''
	Local cCodOpe  := ""
	Local nX 	   := 0
	Local aVetErro := {}
	Local _cErro   := ""
	Local _cDir    := ""
	Local nMDir    := 0
	Local bOK     
	Local lRetransf  := IsInCallStack("U_STKMNTP") .Or. IsInCallStack("U_JOBTRFOP")
	Local nRECC6     := 0
	//Local nEmpenhado := 0
	Local aTravas    := {}

	Private lMsErroAuto	:= .F.
	Private lRetExec  :=.t.
	Private aTransf	:= {}
	Private cPath	:= "\logtransf\"

	//-----------------------------------------------------------------------------------------------------------//
	//FR - 29/09/2022 - Ticket #20220928018340 - reprocessar transfer๊ncia (qdo nใo realizada via coletor)
	Default lTela := .F.  	//esta variแvel indicarแ se a chamada veio direto do Protheus e nใo via coletor,
							//se for via coletor, lTela = .F. , 
							//se for via tela de prioridade, esta variแvel fica = .T.
	//-----------------------------------------------------------------------------------------------------------//							

	//FR - 10/05/2023 - SIGAMAT CONSULTORIA
	//TRATATIVA PARA TRANSFERสNCIA ENTRE ARMAZษNS 03 PARA 06 MERCADO LIVRE
	Default cArML := ""
	Default cEndML:= ""
	Default cOS   := ""

	If !Empty(cOS)
		CB7->(ORDSETFOCUS(1))
		CB7->(Dbseek(xFilial("CB7") + cOS))
	Endif 
	
	_cAssunto:= 'Erro de transfer๊ncia - ('+CB7->CB7_ORDSEP +')'
	cEndPad	:= Iif(!Empty(CB7->CB7_PEDIDO),GetMv("FS_ENDEXP",.F.,"EMBALAGEM"),GetMv("FS_ENDPAD",.F.,"PRODUCAO"))

	If !Empty(cEndML)
		cEndPad := cEndML  //FR - 10/05/2023 - ASSUME O ENDEREวO PADRรO MERCADO LIVRE
	Endif 

	//RETURN(.T.)  //GIOVANI AJUSTE PARA RETORNA ANTES DA EXECAUTO
	
	nxQuant :=xArraLen(aDados,cxOPER)
	SB2->(DbSetOrder(1))
	SBE->(DbSetOrder(1)) //BE_FILIAL+BE_LOCAL+BE_LOCALIZ
	//aadd(aLista,{cProduto,nQtdeProd,cArmOri,cLote,cSLote,cNumSerie})

	aTransf:=Array(nxQuant+1)
	aTransf[1] := {"OS." + CB7->CB7_ORDSEP,dDataBase}

	
	For nI := 1 to nxQuant
		If lRetExec
			SB1->(dbSeek(xFilial("SB1")+aDados[nI,1]))
			dValid := dDatabase+SB1->B1_PRVALID
			//               produto    quantidade  local      local dest   endereco    lote        sublote    D4_TRT D4_OPORIG  PEDIDO
			//CB9->(Aadd(aRet,{CB9_PROD , CB9_QTESEP, CB9_LOCAL, cArML      , CB9_LCALIZ, CB9_LOTSUG, CB9_SLOTSU,""     ,""      , CB9_PEDIDO }))

			If Rastro(aDados[nI,1])
				SB8->(DbSetOrder(3)) //B8_FILIAL+B8_PRODUTO+B8_LOCAL+B8_LOTECTL+B8_NUMLOTE+DTOS(B8_DTVALID)
				SB8->(DbSeek(xFilial("SB8")+aDados[nI,1]+aDados[nI,3]+aDados[nI,6]+AllTrim(aDados[nI,7])))
				dValid := SB8->B8_DTVALID
			EndIf

			If !SB2->(DbSeek(xFilial("SB2")+aDados[nI,1]+aDados[nI,4]))
				CriaSB2(aDados[nI,1],aDados[nI,4])
			EndIf

			aTransf[nI+1]:=  {{"D3_COD" 		, SB1->B1_COD						,NIL}}
			aAdd(aTransf[nI+1],{"D3_DESCRI" , SB1->B1_DESC							,NIL})
			aAdd(aTransf[nI+1],{"D3_UM"     , SB1->B1_UM							,NIL})
			aAdd(aTransf[nI+1],{"D3_LOCAL"  , aDados[nI,3]							,NIL})
			aAdd(aTransf[nI+1],{"D3_LOCALIZ", aDados[nI,5]							,NIL})
			aAdd(aTransf[nI+1],{"D3_COD"    , SB1->B1_COD							,NIL})
			aAdd(aTransf[nI+1],{"D3_DESCRI" , SB1->B1_DESC							,NIL})
			aAdd(aTransf[nI+1],{"D3_UM"     , SB1->B1_UM							,NIL})
			aAdd(aTransf[nI+1],{"D3_LOCAL"  , aDados[nI,4]							,NIL})
			aAdd(aTransf[nI+1],{"D3_LOCALIZ", cEndPad								,NIL})
			aAdd(aTransf[nI+1],{"D3_NUMSERI", CriaVar("D3_NUMSERI",.F.) 			,NIL})//numserie
			aAdd(aTransf[nI+1],{"D3_LOTECTL", criavar("D3_LOTECTL",.F.)			,NIL})//lote
			aAdd(aTransf[nI+1],{"D3_NUMLOTE", criavar("D3_NUMLOTE",.F.)			,NIL})//sublote
			aAdd(aTransf[nI+1],{"D3_DTVALID", criavar("D3_DTVALID",.F.)			,NIL})
			aAdd(aTransf[nI+1],{"D3_POTENCI", criavar("D3_POTENCI",.F.)			,NIL})
			aAdd(aTransf[nI+1],{"D3_QUANT"  , aDados[nI,2]							,NIL})
			aAdd(aTransf[nI+1],{"D3_QTSEGUM", CriaVar("D3_QTSEGUM",.F.)			,NIL})
			aAdd(aTransf[nI+1],{"D3_ESTORNO", CriaVar("D3_ESTORNO",.F.)			,NIL})
			aAdd(aTransf[nI+1],{"D3_NUMSEQ" , CriaVar("D3_NUMSEQ",.F.)				,NIL})
			aAdd(aTransf[nI+1],{"D3_LOTECTL", criavar("D3_LOTECTL",.F.)			,NIL})
			aAdd(aTransf[nI+1],{"D3_DTVALID", criavar("D3_DTVALID",.F.)			,NIL})

			//aAdd(aTransf[nI+1],{"D3_SERVIC", ''								,NIL})
			/*
			aAdd(aTransf,{   SB1->B1_COD,; // 01.Produto Origem
			SB1->B1_DESC,; // 02.Descricao
			SB1->B1_UM,; // 03.Unidade de Medida
			aDados[nI,3],; // 04.Local Origem
			aDados[nI,5],; // 05.Endereco Origem
			SB1->B1_COD,; // 06.Produto Destino
			SB1->B1_DESC,; // 07.Descricao
			SB1->B1_UM,; // 08.Unidade de Medida
			aDados[nI,4],; // 09.Armazem Destino
			cEndPad,; // 10.Endereco Destino
			CriaVar("D3_NUMSERI",.F.),; // 11.Numero de Serie
			aDados[nI,6],; // 12.Lote Origem
			aDados[nI,7],; // 13.Sublote
			dValid,;//CriaVar("D3_DTVALID",.F.),; // 14.Data de Validade
			CriaVar("D3_POTENCI",.F.),; // 15.Potencia do Lote
			aDados[nI,2],; // 16.Quantidade
			CriaVar("D3_QTSEGUM",.F.),; // 17.Quantidade na 2 UM
			CriaVar("D3_ESTORNO",.F.),; // 18.Estorno
			CriaVar("D3_NUMSEQ",.F.),; // 19.NumSeq
			aDados[nI,6],; // 20.Lote Destino
			dValid })//CriaVar("D3_DTVALID",.F.),; // 21.Data de Validade do Destino
			//	Criavar("D3_ITEMGRD",.F.),})	// 22.Item grade MCVN - 16/11/09)
			//	"Rot. Automatica de Separacao",}) // 23.Explicacao
			//}) // 24. Numero de separacao
			*/

		Endif
	Next nI
	//	MATA261(aTransf,3)
	aRetLog := {}
	cRotLogOp := IIF(ISINCALLSTACK( "U_JOBTRFOP" ),"JOBTRFOP_REPROCESSAMENTO","VIA_COLETOR") 
	If lTela == Nil .or. !lTela .Or. lRetransf 
		
		//Gravar log de movimenta็ใo da OP.
		aRetLog:=U_STKGLGOP("",Alltrim(CB7->CB7_OP),SB1->B1_COD,__cUserID,+SubStr(cUsuario, 7, 15),DDataBase,Time(),Funname(),;
					"OS." + CB7->CB7_ORDSEP + " OP:" + Alltrim(CB7->CB7_OP) + "Foi Iniciado Processo de Transfer๊ncia " + cRotLogOp ,""/*mensagem fim*/,"1",;
					/*dDatFimMv*/,/*cHorFimMv*/,/*cRotFimMv*/)
		
		MSExecAuto({|x,y| MATA261(x,y)},aTransf,3)

	Elseif lTela 		
		MsAguarde({|| MSExecAuto({|x,y| MATA261(x,y)},aTransf,3)}, "Aguarde...", "Transferindo Itens do Local: " + aDados[1,3] + " Para Local: " + aDados[1,4],.F. )		
	Endif

	//MSExecAuto({|x| MATA261(x)},aTransf)
	//MSExecAuto({|x| MATA261(x)},aTransf,3,.T.)
	If lMsErroAuto //se deu erro

		//FR - 29/09/2022 - Ticket #20220928018340 - reprocessar transfer๊ncia (qdo nใo realizada via coletor)
		If lTela == Nil .or. !lTela  //FR - 29/09/2022 - alerta para coletor s๓ exibe no coletor, na tela Protheus, nใo exibe
			If !ISINCALLSTACK("U_JOBTRFOP")
				VtAlert("Problemas na EXECAUTO!")
			else
				Conout("U_JOBTRFOP-Erro de execu็ใo do execauto da transfer๊ncia")
			Endif
		Elseif lTela 
			MsgAlert("Problemas na EXECAUTO!")
			If !lRetransf
				MostraErro()
			EndIf
		Endif	
		
		cDirServer:= ""
		lEnviou   := .F.
		If Empty(cArML)
			_cEmail   += ";helida.matos@steck.com.br"
			_cEmail   += ";jhonnatham.cavalcante@steck.com.br"
			//FR - 29/09/2022 - Ticket #20220928018340 - reprocessar transfer๊ncia (qdo nใo realizada via coletor)
		Endif 

		MostraErro("LOGS","OS"+ALLTRIM(CB7->CB7_ORDSEP)+".log")			

		aadd( _aAttach  ,"os"+ALLTRIM(CB7->CB7_ORDSEP)+'.log')
		
		_cCaminho := '\LOGS\'
		_cArq     := "os"+ALLTRIM(CB7->CB7_ORDSEP)+'.log'
		cAnexo    := _cCaminho + _cArq
		lEnviou := U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)
		
		cConteudo  := ""
		
		If Len(aRetLog) > 0
			If aRetLog[1]
				//Definindo o arquivo a ser lido
				oFile := FWFileReader():New(_cCaminho + _cArq)
				
				//Se o arquivo pode ser aberto
				If (oFile:Open())				
					//Se nใo for fim do arquivo
					If ! (oFile:EoF())
						cConteudo  := oFile:FullRead()
					EndIf					
					//Fecha o arquivo e finaliza o processamento
					oFile:Close()
				EndIf			
			
				//Gravar log de movimenta็ใo da OP.
				aRetLog:=U_STKGLGOP(aRetLog[2],Alltrim(CB7->CB7_OP),SB1->B1_COD,__cUserID,+SubStr(cUsuario, 7, 15),DDataBase,Time(),Funname(),;
						""/*Mensagem Inicio*/,"OS." + CB7->CB7_ORDSEP + " OP:" + Alltrim(CB7->CB7_OP) + "Fim do Processo de Transfer๊ncia " + cRotLogOp + " - COM ERRO - " + cConteudo,"1",;
						/*dDatFimMv*/,/*cHorFimMv*/,/*cRotFimMv*/)
			EndIf
		Endif	
		If !lEnviou
		
			//FR - 29/09/2022 - Ticket #20220928018340 - reprocessar transfer๊ncia (qdo nใo realizada via coletor)
			If lTela == Nil .or. !lTela  //FR - 29/09/2022 - alerta para coletor s๓ exibe no coletor, na tela Protheus, nใo exibe
				If !ISINCALLSTACK("U_JOBTRFOP")
					VtAlert("Problemas na EXECAUTO!")
				else
					Conout("U_JOBTRFOP-Erro de execu็ใo do execauto da transfer๊ncia")
				Endif
			Elseif lTela 
				Alert("Problemas no Envio de Email!")
			Endif 
			//FR - 29/09/2022 - Ticket #20220928018340 - reprocessar transfer๊ncia (qdo nใo realizada via coletor)
		EndIf
		
		lRetExec:=.F.		
		
	Else
		//Se deu tudo certo com o execauto gravar o log para finalizar o processo, caso tenha dado errado servirแ de base para reprocessar
		//via job.
		If Len(aRetLog) > 0
			If aRetLog[1]
				//Gravar log de movimenta็ใo da OP.
				aRetLog := U_STKGLGOP(aRetLog[2],Alltrim(CB7->CB7_OP),SB1->B1_COD,__cUserID,+SubStr(cUsuario, 7, 15),DDataBase,Time(),Funname(),;
							"","OS." + CB7->CB7_ORDSEP + "->Transfer๊ncia Realizada Com Sucesso" + cRotLogOp ,"2",DDataBase,Time(),Funname())
			EndIf
		Endif	

		//FR - 29/09/2022 - Ticket #20220928018340 - reprocessar transfer๊ncia (qdo nใo realizada via coletor)
		If lTela <> Nil
			If lTela 
				MsgInfo("Transfer๊ncia Realizada Com Sucesso")
			Endif
		Endif 
		//FR - 29/09/2022 - Ticket #20220928018340 - reprocessar transfer๊ncia (qdo nใo realizada via coletor)
	Endif

	If GetMv("ST_STOPCO",,.F.) .And. cEmpAnt = '03'
		U_STOPCOM(ALLTRIM(CB7->CB7_ORDSEP))  //GIOVANI ZAGO 21/03/2016 ENVIAR WF PARA OP PAGA SEM COMPROMISSO
	EndIf
	Restarea(aSB1Area)
	RestArea(aArea)

Return lRetExec

//FR - 17/08/2023 - EXECAUTO DE TRANSFERสNCIA PARA MERCADO LIVRE
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออั	ออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTFSXFUN  บAutor  ณMicrosiga           บ Data ณ  11/01/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRealiza a transferencia de armazem                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MLTransf(aDados,cxOPER,lTela,cArML,cEndML,cOS)

	Local dValid	:= dDatabase
	Local aArea		:= GetArea()
	Local aSB1Area	:= SB1->(GetArea())
	
	Local cEndPad	:= ""
	Local nI
	Local nxQuant   := 0
	Local _cEmail   := " "
	Local _cCopia   := " "
	
	Local _cAssunto := " "
	Local cMsg	    := ""
	Local _aAttach  := {}
	Local _cCaminho := ''
	Local nX 	    := 0	
	Local nRECC6    := 0
	Local aLog      := {}		
	Local aTravas   := {}
	Local lTransfOK := .T.
	Local aTransfOK := {}
	Local aTransfNAO:= {}
	Local cErro     := ""

	Private lMsErroAuto	:= .F.
	Private lRetExec  :=.t.
	Private aTransf	:= {}
	Private cPath	:= "\logtransf\"

	//-----------------------------------------------------------------------------------------------------------//
	//FR - 29/09/2022 - Ticket #20220928018340 - reprocessar transfer๊ncia (qdo nใo realizada via coletor)
	Default lTela := .F.  	//esta variแvel indicarแ se a chamada veio direto do Protheus e nใo via coletor,
							//se for via coletor, lTela = .F. , 
							//se for via tela de prioridade, esta variแvel fica = .T.
	//-----------------------------------------------------------------------------------------------------------//							

	//FR - 10/05/2023 - SIGAMAT CONSULTORIA
	//TRATATIVA PARA TRANSFERสNCIA ENTRE ARMAZษNS 03 PARA 06 MERCADO LIVRE
	Default cArML := ""
	Default cEndML:= ""
	Default cOS   := ""

	If !Empty(cOS)
		CB7->(ORDSETFOCUS(1))
		CB7->(Dbseek(xFilial("CB7") + cOS))
	Endif 
	
	_cAssunto:= 'Erro de transfer๊ncia - ('+CB7->CB7_ORDSEP +')'
	cEndPad	:= Iif(!Empty(CB7->CB7_PEDIDO),GetMv("FS_ENDEXP",.F.,"EMBALAGEM"),GetMv("FS_ENDPAD",.F.,"PRODUCAO"))

	If !Empty(cEndML)
		cEndPad := cEndML  //FR - 10/05/2023 - ASSUME O ENDEREวO PADRรO MERCADO LIVRE
	Endif 
		
	nxQuant :=xArraLen(aDados,cxOPER)
	SB2->(DbSetOrder(1))
	SBE->(DbSetOrder(1)) //BE_FILIAL+BE_LOCAL+BE_LOCALIZ
	
	
	I := 0
	cErro := "ERRO TRANSFERสNCIA NO(s) ITEM(ns): " + CHR(13) + CHR(10)

	For nI := 1 to nxQuant
		BEGIN TRANSACTION 	//FR - 22/08/2023 - Sำ HAVIA UM DISARM TRANSACTION NA CHAMADA DESTA FUNวรO, COLOQUEI ESTE BEGIN PARA INICIAR E FECHAR A TRANSAวรO COM SEGURANวA
		
		aTransf := {}
		aTransf:= Array(1)  
		aTransf[1] := {"OS." + CB7->CB7_ORDSEP,dDataBase}  //cabe็alho
		
		Aadd( aTransf , Array(21)  )  //n๚mero de campos da D3 no array para transf logo mais abaixo
		I := 2 		 

		//------------------------------------------------------------------------------------------------------//
		//FR - 19/06/2023 - SIGAMAT CONSULTORIA - matar o empenho antes de transferir
		//utilizadas as mesmas fun็๕es de estorno, que sใo usadas no estorno de OS
		//se for para armaz้m do MERCADO LIVRE, ESTORNA EMPENHO ANTES PARA NรO OCORRER ERRO POR FALTA DE SALDO
		//------------------------------------------------------------------------------------------------------//
			
		SC6->(OrdSetfocus(2))  //C6_FILIAL + C6_PRODUTO   + C6_NUM
		If SC6->(DbSeek(xFilial('SC6')        + aDados[nI,1] + aDados[nI,10] ))  //PEGAR RECNO DO SC6
			nRECC6 := SC6->(RECNO())

			//U_STDelSDC(aDados[nI,10], aDados[nI,1], CB7->CB7_ORDSEP, nRECC6,,cArML,aDados[nI,5])  //aqui estorna a OS da SC9
			//STDelSDC(cDoc           , cProduto    , cOrdSep        ,nRecno,lLibPV)
					
			//U_STReserva(aDados[nI,10],aDados[nI,1],aDados[nI,2],"-"  ,cFilAnt)  //aqui estorna da PA2
			//STReserva(cDoc          ,cProduto    ,nQtde       ,cOper,cFilialRes,cFilialSB2)
			//cDoc ้ CB7->CB7_PEDIDO

			//gravar antes
			Reclock("SC6", .F.)
			SC6->C6_NOTA := "MERCLIVRE"
			SC6->C6_QTDENT := aDados[nI,2] //QTDE ENTREGUE PARA QUE ESTE PEDIDO NรO CONSTE COMO PENDENTE
			SC6->(MsUnlock())
					
			//matar o empenho antes de transferir	
			SDC->(OrdSetFocus(1)) //DC_FILIAL+DC_PRODUTO+DC_LOCAL      +DC_ORIGEM+DC_PEDIDO+DC_ITEM          +DC_SEQ+DC_LOTECTL+DC_NUMLOTE+DC_LOCALIZ+DC_NUMSERI 
			If SDC->(DbSeek(xFilial("SDC") + aDados[nI,1] + SC6->C6_LOCAL + "SC6"   + SC6->C6_NUM + SC6->C6_ITEM))

				//FUNวรO PADRรO PARA ESTORNO DE EMPENHO: 
				GravaEmp(aDados[nI,1],;      	// produto
				aDados[nI,3],;					// local
				aDados[nI,2],;					// qtde 1 un
				NIL,;							// qtde 2 un
				SDC->DC_LOTECTL,;		//SD4->D4_LOTECTL,;		// lote
				SDC->DC_NUMLOTE,;		//SD4->D4_NUMLOTE,;		// num lote
				aDados[nI,5],;					//NIL,;						// endere็o
				NIL,;							// numero de serie
				SDC->DC_OP,;					//SD4->D4_OP,;			// op
				SDC->DC_SEQ,;					//SDC->DC_SEQ ? //SD4->D4_TRT,;			// sequencia
				SC6->C6_NUM,;					// pedido de venda
				SC6->C6_ITEM,;					// item do pedido
				SDC->DC_ORIGEM,;				// origem
				NIL,;							// op original
				SC6->C6_ENTREG,;				// data de entrega
				@aTravas,;						// controle de travas nao sei o que faz
				.T.,;							// estorno
				NIL,;							// integracao PMS
				.T.,;              				// atualiz sb2
				.F.,;							// gera sd4
				NIL,;							// considera lote vencido
				.T.,;							// Empenha SB8 e SBF
				.T.)							//	CriaSDC
				MaDestrava(aTravas)				
			Endif 
		Endif					
		//FR - 19/08/2023 - SIGAMAT CONSULTORIA - MERCADO LIVRE - matar o empenho antes de transferir

		SB1->(dbSeek(xFilial("SB1")+aDados[nI,1]))
		dValid := dDatabase+SB1->B1_PRVALID
		//               produto    quantidade  local      local dest   endereco    lote        sublote    D4_TRT D4_OPORIG  PEDIDO
		//CB9->(Aadd(aRet,{CB9_PROD , CB9_QTESEP, CB9_LOCAL, cArML      , CB9_LCALIZ, CB9_LOTSUG, CB9_SLOTSU,""     ,""      , CB9_PEDIDO }))

		If Rastro(aDados[nI,1])
			SB8->(DbSetOrder(3)) //B8_FILIAL+B8_PRODUTO+B8_LOCAL+B8_LOTECTL+B8_NUMLOTE+DTOS(B8_DTVALID)
			SB8->(DbSeek(xFilial("SB8")+aDados[nI,1]+aDados[nI,3]+aDados[nI,6]+AllTrim(aDados[nI,7])))
			dValid := SB8->B8_DTVALID
		EndIf

		If !SB2->(DbSeek(xFilial("SB2")+aDados[nI,1]+aDados[nI,4]))
			CriaSB2(aDados[nI,1],aDados[nI,4])
		EndIf

		//monta o array dos itens para transferir
		aTransf[I]:=  {{"D3_COD" 		, SB1->B1_COD						,NIL}}
		aAdd(aTransf[I],{"D3_DESCRI" , SB1->B1_DESC							,NIL})
		aAdd(aTransf[I],{"D3_UM"     , SB1->B1_UM							,NIL})
		aAdd(aTransf[I],{"D3_LOCAL"  , aDados[nI,3]							,NIL})
		aAdd(aTransf[I],{"D3_LOCALIZ", aDados[nI,5]							,NIL})
		aAdd(aTransf[I],{"D3_COD"    , SB1->B1_COD							,NIL})
		aAdd(aTransf[I],{"D3_DESCRI" , SB1->B1_DESC							,NIL})
		aAdd(aTransf[I],{"D3_UM"     , SB1->B1_UM							,NIL})
		aAdd(aTransf[I],{"D3_LOCAL"  , aDados[nI,4]							,NIL})
		aAdd(aTransf[I],{"D3_LOCALIZ", cEndPad								,NIL})
		aAdd(aTransf[I],{"D3_NUMSERI", CriaVar("D3_NUMSERI",.F.) 			,NIL})//numserie
		aAdd(aTransf[I],{"D3_LOTECTL", criavar("D3_LOTECTL",.F.)			,NIL})//lote
		aAdd(aTransf[I],{"D3_NUMLOTE", criavar("D3_NUMLOTE",.F.)			,NIL})//sublote
		aAdd(aTransf[I],{"D3_DTVALID", criavar("D3_DTVALID",.F.)			,NIL})
		aAdd(aTransf[I],{"D3_POTENCI", criavar("D3_POTENCI",.F.)			,NIL})
		aAdd(aTransf[I],{"D3_QUANT"  , aDados[nI,2]							,NIL})
		aAdd(aTransf[I],{"D3_QTSEGUM", CriaVar("D3_QTSEGUM",.F.)			,NIL})
		aAdd(aTransf[I],{"D3_ESTORNO", CriaVar("D3_ESTORNO",.F.)			,NIL})
		aAdd(aTransf[I],{"D3_NUMSEQ" , CriaVar("D3_NUMSEQ",.F.)				,NIL})
		aAdd(aTransf[I],{"D3_LOTECTL", criavar("D3_LOTECTL",.F.)			,NIL})
		aAdd(aTransf[I],{"D3_DTVALID", criavar("D3_DTVALID",.F.)			,NIL})
		
		//TRANSFERE	de 1 em 1
		MSExecAuto({|x,y| MATA261(x,y)},aTransf,3)		//transfere de 1 em 1
				
		//aqui vai adicionar nos arrays de transf OK ou transf nใo OK os itens conforme o resultado do execauto
		If lMsErroAuto //se deu erro
			DisarmTransaction()			
			//MostraErro() //nใo mostra agora, armazena para s๓ mostrar no final os itens q ocorreram erro de transfer๊ncia
			cErro += "-> " + SB1->B1_COD + ", Qtd: " + cValtoChar(aDados[nI,2]) + CHR(13) + CHR(10)

			aLog := GetAutoGRLog()
			For nX := 1 To Len(aLog)
				If !"---" $ aLog[nX]
					cErro += aLog[nX]+" ; " + CHR(13) + CHR(10)
				Endif
			Next nX

			lTransfOK := .F.
			Aadd(aTransfNAO, { aDados[nI,1] , SB1->B1_DESC, aDados[nI,2], aDados[nI,5] , cEndpad     ,aDados[nI,10] ,aDados[nI,3], cArML      })
			//                 cod.prod     , descri็ใo    , qtde       , end.origem   , end.destino , ped.venda    , Armz.origem, Arm.Destino

			lRetExec := .F.

			//Aviso("ERRO EXECAUTO TRANSFERสNCIA",cErro,{"Ok"})

		Else 

			Aadd(aTransfOK, { aDados[nI,1] , SB1->B1_DESC, aDados[nI,2], aDados[nI,5] , cEndpad     , aDados[nI,10],aDados[nI,3], cArML      })
			//                 cod.prod     , descri็ใo    , qtde       , end.origem   , end.destin , ped.venda    , Armz.origem, Arm.Destino
			//                 1              2              3            4              5            6              7            8
		Endif 
		END TRANSACTION			
	Next nI
	
	//If lMsErroAuto //se deu erro
	If !lTransfOK	//essa variแvel se falsa, ้ porque algum item deu erro, entใo enviarแ o email com todos os itens que deram problema
					//caso contrแrio tb enviarแ email com todos os itens que deram certo	
		
		//GRAVA ERRO DO EXECAUTO: 
		cDirServer:= ""
		lEnviou   := .F.
		
		MostraErro("LOGS","OS"+ALLTRIM(CB7->CB7_ORDSEP)+".log")			

		aadd( _aAttach  ,"os"+ALLTRIM(CB7->CB7_ORDSEP)+'.log')
		
		_cCaminho := '\LOGS\'
		_cArq     := "os"+ALLTRIM(CB7->CB7_ORDSEP)+'.log'
		cAnexo    := _cCaminho + _cArq
		//lEnviou := U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)
		
		cConteudo  := ""				
		//lRetExec:=.F.
		
		//--------------------------------------------------------------------------------------------------//
		//FR - 15/08/2023 - EMPENHO MERCADO LIVRE - EM CASO DE ERRO NA EXECAUTO
		//RECONSTRUIR EMPENHO EM CASO DE ERRO NO EXECAUTO, PORQUE MATOU O EMPENHO ANTES DE FAZER A TRANSF
		//--------------------------------------------------------------------------------------------------//		
		//Aadd(aTransfOK, { aDados[nI,1] , SB1->B1_DESC, aDados[nI,2], aDados[nI,5] , cEndpad     , aDados[nI,10],aDados[nI,3], cArML      })
		//                 cod.prod     , descri็ใo    , qtde       , end.origem   , end.destin , ped.venda    , Armz.origem  , Arm.Destino
		//                 1              2              3            4              5            6              7            8

		//REFAZ O EMPENHO DO ITEM QUE OCORREU ERRO AO TRANSFERIR:
		If !Empty(cArML) //Sำ FAZ SE O ARMAZษM MERCADO LIVRE ESTIVER PREENCHIDO			
			
			//RECONTRำI EMPENHO DOS ITENS NรO TRANSFERIDOS
			For nI := 1 to Len(aTransfNAO) //nxQuant

				SC6->(OrdSetfocus(2))  //C6_FILIAL + C6_PRODUTO          + C6_NUM
				If SC6->(DbSeek(xFilial('SC6')        + aTransfNAO[nI,1] + aTransfNAO[nI,6] ))  

					SDC->(OrdSetFocus(1)) //DC_FILIAL +DC_PRODUTO        +DC_LOCAL      +DC_ORIGEM +DC_PEDIDO    +DC_ITEM +DC_SEQ+DC_LOTECTL+DC_NUMLOTE+DC_LOCALIZ+DC_NUMSERI 			
					//SE NรO ENCONTRAR NA SDC, REFAZ
					If !SDC->(DbSeek(xFilial("SDC")   + aTransfNAO[nI,1] + SC6->C6_LOCAL + "SC6"   + SC6->C6_NUM + SC6->C6_ITEM))

						//FUNวรO PADRรO PARA RECONSTRUIR EMPENHO: 
						GravaEmp(aTransfNAO[nI,1],;      	// produto
						aTransfNAO[nI,7],;					// local ORIGEM
						aTransfNAO[nI,3],;					// qtde 1 un
						NIL,;							// qtde 2 un
						SDC->DC_LOTECTL,;		//SD4->D4_LOTECTL,;		// lote
						SDC->DC_NUMLOTE,;		//SD4->D4_NUMLOTE,;		// num lote
						aTransfNAO[nI,4],;					//NIL,;						// endere็o
						NIL,;							// numero de serie
						SDC->DC_OP,;					//SD4->D4_OP,;			// op
						SDC->DC_SEQ,;					//SDC->DC_SEQ ? //SD4->D4_TRT,;			// sequencia
						SC6->C6_NUM,;					// pedido de venda
						SC6->C6_ITEM,;					// item do pedido
						SDC->DC_ORIGEM,;				// origem
						NIL,;							// op original
						SC6->C6_ENTREG,;				// data de entrega
						@aTravas,;						// controle de travas nao sei o que faz
						.F.,;							// estorno  //.F. - NรO ESTORNA, REFAZ, .T. - ESTORNA EMPENHO
						NIL,;							// integracao PMS
						.T.,;              				// atualiz sb2
						.F.,;							// gera sd4
						NIL,;							// considera lote vencido
						.T.,;							// Empenha SB8 e SBF
						.T.)							//	CriaSDC
						MaDestrava(aTravas)				
					Endif //SEEK NA SDC
				Endif //SEEK NA SC6
			Next

			//envia WF em caso de erro
			_cEmail   := GetNewPar("ST_WFMELI" , "diogo.fausto@steck.com.br;ana.rodrigues@steck.com.br;kleber.braga@steck.com.br;alan.santos@steck.com.br;guilherme.fernandez@steck.com.br")
			_cCopia   := "flah.rocha@sigamat.com.br;flavia.rocha76@outlook.com"  
			//_cCopia   := "" 
			_cAssunto := "ERRO - TRANSFERสNCIA DE MATERIAIS P/ MERCADO LIVRE"
			//_cAssunto += " - TESTE AMB EMERG5 " //_cAssunto += " - TESTE BASE D02 " 
			
			cMsg      := "Problema na Transfer๊ncia dos Itens, " + CRLF + CRLF 
			cMsg      += "Nใo Foram Transferidos do Armaz้m: " + aTransfNAO[1,7] + " Para: " + cArML + CRLF + CRLF

			//MONTA CORPO DA MENSAGEM: 
			U_STMONTAMAIL(@cMsg,aTransfNAO,cOS)

			_aAttach  := {} 
			_cCaminho = ""
			
			//CB9->(Aadd(aRet,{;
			//		CB9_PROD ,;		//1-PRODUTO
			//		 CB9_QTESEP,;	//2-QUANTIDADE
			//		 CB9_LOCAL,;	//3-LOCAL ORIGEM
			//		 cArML,;		//4-LOCAL DESTINO
			//		 CB9_LCALIZ,;	//5-ENDEREวO
			//		 CB9_LOTSUG,;	//6-LOTE
			//		 CB9_SLOTSU,;	//7-SUBLOTE
			//		 ""     ,;		//8-D4_TRT
			//		 ""      ,;		//9-D4_OPORIG
			//		 CB9_PEDIDO,;	//10-PEDIDO
			//		 CB9_VOLUME;	//11-NRO. VOLUME
			//		  }))

			
			lEnviou := U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)
			//U_FILA11() //FR TESTE RETIRAR
			
			Aviso("ERRO EXECAUTO TRANSFERสNCIA",cErro,{"Ok"})

		Endif //!EMPTY(cArmL)
		
		//FR - 15/08/2023 - EMPENHO MERCADO LIVRE
		
	Else
		//deu tudo certo com o execauto 
		If lTela <> Nil
			If lTela 
				MsgInfo("Transfer๊ncia Realizada Com Sucesso")
			Endif
		Endif 
		//FR - 29/09/2022 - Ticket #20220928018340 - reprocessar transfer๊ncia (qdo nใo realizada via coletor) 

		//------------------------------------------------------------------------------------------------//
		//FR - 10/05/2023 - Flแvia Rocha - SIGAMAT CONSULTORIA
		//TRANSFERสNCIA MERCADO LIVRE
		//ENCERRA O PEDIDO APำS TRANSFERสNCIA MERCADO LIVRE
		//ENVIA WF INFORMANDO AOS ENVOLVIDOS QUE A TRANSFERสNCIA FOI REALIZADA
		//------------------------------------------------------------------------------------------------//
		If !Empty(cArML) //Sำ FAZ SE O ARMAZษM MERCADO LIVRE ESTIVER PREENCHIDO			

			SC5->(ORDSETFOCUS(1))
			If SC5->(Dbseek(xFilial("SC5") + CB7->CB7_PEDIDO))
				RecLock("SC5" , .F.)
				//A GRAVAวรO DOS 2 CAMPOS ABAIXO SIGNIFICA PEDIDO ENCERRADO: 
				SC5->C5_NOTA    := "MERCLIVRE"  //grava como se fosse nota, a string 
				SC5->C5_ZFATBLQ := "1"
				SC5->(MsUnlock())
			Endif
			//---------------------------------------------------------------------------------------------//
			//GRAVA QTDE ENTREGUE NA SC6 PARA QUE NA TELA DE PRIORIDADE NรO FIQUE CONSTANDO COMO PENDENTE
			//LEMBRANDO QUE ESTES PEDIDOS DO MERCADO LIVRE NรO SรO FATURADOS, POR ISSO FAวO ESTA GRAVAวรO
			//---------------------------------------------------------------------------------------------//
			  //FR -22/08/2023 - gravar antes conforme alinhamento realizado com Renato, Kleber,Leandro em 22/08/2023
				//Flแvia Rocha - Sigamat Consultoria
			For nI := 1 to Len(aTransfOK) //nxQuant
				//Aadd(aTransfOK, { aDados[nI,1] , SB1->B1_DESC, aDados[nI,2], aDados[nI,5] , cEndpad     , aDados[nI,10],aDados[nI,3], cArML      })
				//                 cod.prod     , descri็ใo    , qtde       , end.origem   , end.destin , ped.venda    , Armz.origem  , Arm.Destino
				//                 1              2              3            4              5            6              7            8

			
				//------------------------------------------------------------------------------------------------------//
				//FR -15/08/2023 - SIGAMAT CONSULTORIA - gravar "nota" depois de transferir, isso evitarแ de mostrar
				//na tela de prioridade que o item estแ "pendente", jแ que este pedido nใo serแ faturado, 
				//------------------------------------------------------------------------------------------------------//
				SC6->(OrdSetfocus(2))  //C6_FILIAL + C6_PRODUTO         + C6_NUM
				If SC6->(DbSeek(xFilial('SC6')        + aTransfOK[nI,1] + aTransfOK[nI,6] ))  
					//nRECC6 := SC6->(RECNO())   //gravar antes da transfer๊ncia para jแ inutilizar o pedido
					//Reclock("SC6", .F.)
					//SC6->C6_NOTA := "MERCLIVRE"
					//SC6->C6_QTDENT := aTransfOK[nI,3]  //QTDE
					//SC6->(MsUnlock())
					
					SC9->(OrdSetfocus(1)) //C9_FILIAL+C9_PEDIDO    +C9_ITEM       +C9_SEQUEN+C9_PRODUTO+C9_BLEST+C9_BLCRED 
					If SC9->(DbSeek(xFilial('SC9')   + SC6->C6_NUM + SC6->C6_ITEM )) 
						Reclock("SC9", .F.)
						SC9->C9_NFISCAL := "MERCLIVRE"
						SC9->(MsUnlock()) 
					Endif 
				
				Endif 
			Next
			
		Endif 

		//SE ESTE ARRAY POSSUIR DADOS, ENVIA POR EMAIL OS ITENS QUE DERAM CERTO NA TRANSF
		If Len(aTransfOK) > 0

			_cEmail   := GetNewPar("ST_WFMELI" , "diogo.fausto@steck.com.br;ana.rodrigues@steck.com.br;kleber.braga@steck.com.br;alan.santos@steck.com.br;guilherme.fernandez@steck.com.br")
			_cCopia   := "flah.rocha@sigamat.com.br;flavia.rocha76@outlook.com"  
			//_cCopia   := "" 
			_cAssunto := "TRANSFERสNCIA DE MATERIAIS P/ MERCADO LIVRE"
			//_cAssunto += " - TESTE AMB EMERG5 " //_cAssunto += " - TESTE BASE D02 "
			
			cMsg      := "Os Seguintes Itens Foram Transferidos do Armaz้m: " + aTransfOK[1,7] + " Para: " + cArML + CRLF + CRLF

			//MONTA CORPO DA MENSAGEM: 
			U_STMONTAMAIL(@cMsg,aTransfOK,cOS)

			_aAttach  := {} 
			_cCaminho = ""
			
			lEnviou := U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)
			//U_FILA11() //FR TESTE RETIRAR
			//-------------------------------------------------------------------------------------------------//
			//FR - 10/05/2023 - Flแvia Rocha - SIGAMAT CONSULTORIA
			//ENCERRA PEDIDO APำS TRANSFERสNCIA MERCADO LIVRE
			//ENVIA WF INFORMANDO AOS ENVOLVIDOS QUE A TRANSFERสNCIA FOI REALIZADA
			//------------------------------------------------------------------------------------------------//
		Endif 
	Endif


	Restarea(aSB1Area)
	RestArea(aArea)

Return lRetExec
//FR - 17/08/2023 - EXECAUTO DE TRANSFERสNCIA PARA MERCADO LIVRE

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTFSXFUN  บAutor  ณMicrosiga           บ Data ณ  11/06/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CriaEmp(cTipDoc,aTransf,cArmComp,cDoc)
	Local aSaldos	:= {}
	Local aSD4		:= {}
	Local lUsaVenc	:= SuperGetMv('MV_LOTVENC')=='S'
	Local nReserva	:= 0
	Local cOSSeek	:= CB7->CB7_ORDSEP
	Local cOSPai	:= CB7->CB7_XOSPAI
	Local nI

	If cTipDoc == "1" // pedido

		SC6->(DbSetOrder(1))
		SC9->(DbSetOrder(1)) //C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_SEQUEN+C9_PRODUTO

		SC6->(DbSeek(xFilial('SC6')+cDoc))
		While SC6->(! Eof() .and. C6_FILIAL+C6_NUM == xFilial('SC6')+cDoc)
			If ( nPos := ascan(aTransf,{|x| x[1] == SC6->C6_PRODUTO}) ) == 0
				SC6->(DbSkip())
				Loop
			Endif

			nReserva := aTransf[nPos,2]

			//Ajusta o armazem no PEDIDO DE VENDA
			/*		SC6->(RecLock("SC6",.F.))
			SC6->C6_LOCAL := cArmComp
			SC6->(MsUnlock())          Retirado dia 09/04/2013 pois estava pegando o c6_local errado*/

			If cEmpAnt=="11" .And. cFilAnt=="01"
				aSaldos := U_SLDSTECK(SC6->C6_PRODUTO,SC6->C6_LOCAL,nReserva,ConvUm(SC6->C6_PRODUTO,2,0,nReserva),SC6->C6_LOTECTL,SC6->C6_NUMLOTE,SC6->C6_LOCALIZ,SC6->C6_NUMSERI,NIL,NIL,NIL,lUsaVenc,nil,nil,dDataBase)
			Else
				If Rastro(SC6->C6_PRODUTO)
					aSaldos := SldPorLote(SC6->C6_PRODUTO,SC6->C6_LOCAL,nReserva,ConvUm(SC6->C6_PRODUTO,2,0,nReserva),SC6->C6_LOTECTL,SC6->C6_NUMLOTE,SC6->C6_LOCALIZ,SC6->C6_NUMSERI,NIL,NIL,NIL,lUsaVenc,nil,nil,dDataBase)
				Else
					aSaldos := {{ "","","","",nReserva,ConvUm(SC6->C6_PRODUTO,2,0,nReserva),Ctod(""),"","","",cArmComp,0}}
				Endif
			EndIf

			nRecno:= SC6->(Recno())
			MaLibDoFat(SC6->(Recno()),nReserva,.T.,.T.,.F.,.F.,.F.,.F.,Nil,{||SC9->C9_ORDSEP:= Iif(Empty(CB7->CB7_XOSPAI),CB7->CB7_ORDSEP,CB7->CB7_XOSPAI) },aSaldos,Nil,Nil,Nil)
			MaLiberOk({SC6->C6_NUM},.F.)
			MsUnLockall()
			SC6->(DbGoto(nRecno))
			SC6->(DbSkip())
		End
	Else
		//                      produto  quantidade  local     local dest endereco   lote      sublote D4_TRT
		//	CB9->(Aadd(aRet,{CB9_PROD,CB9_QTESEP,CB9_LOCAL,cArmComp,CB9_LOCALIZ,CB9_LOTSUG,CB9_SLOTSU,""}))
		//cArmComp
		//GIOVANI TESTE DA SD4

		/*
		For nI:=1 to len(aTransf)
		U_STGeraSDC(cDoc,aTransf[nI,1],cArmComp,aTransf[nI,2],1,aSD4,CB7->CB7_ORDSEP,.T.)
		Next
		*/

			U_STGIOSD4(cDoc)

			U_STMONISDC(cDoc)

		EndIf
		//Ajusta o CB8/CB9
		CB8->(DbSetOrder(1)) //CB8_FILIAL+CB8_ORDSEP+CB8_ITEM+CB8_SEQUEN+CB8_PROD
		//CB9->(DbSetOrder(1)) //CB9_FILIAL+CB9_ORDSEP+CB9_CODETI
		CB9->(DbSetOrder(6)) //CB9_FILIAL+CB9_ORDSEP+CB9_ITESEP+CB9_PROD+CB9_LOCAL+CB9_LCALIZ+CB9_LOTECT+C

		For nI:=1 to 2 //Ajusta a OrdSep atual e a Pai se houver
			If nI == 2
				cOSSeek := cOSPai
			Endif
			CB8->(DbSeek(xFilial("CB8")+cOSSeek))

			While CB8->(!Eof() .and. CB8_FILIAL+CB8_ORDSEP == xFilial('CB8')+cOSSeek)
				If CB8->CB8_SALDOS > 0 .and. nI == 1
					CB8->(DbSkip())
					Loop
				Endif

				If CB8->CB8_LOCAL == cArmComp
					CB8->(DbSkip())
					Loop
				Endif

				If ( nPos := ascan(aTransf,{|x| x[1] == CB8->CB8_PROD}) ) == 0
					CB8->(DbSkip())
					Loop
				Endif

				CB8->(RecLock("CB8",.F.))
				CB8->CB8_LOCAL := cArmComp
				CB8->(MsUnlock())
				CB8->(DbCommit())

				CB9->(DbSeek(xFilial("CB9")+CB8->(CB8_ORDSEP+CB8_ITEM+CB8_PROD)))

				While CB9->(!Eof() .and. CB9_FILIAL+CB9_ORDSEP+CB9_ITESEP+CB9_PROD == xFilial("CB9")+CB8->(CB8_ORDSEP+CB8_ITEM+CB8_PROD))
					If !(CB9->CB9_LOCAL == cArmComp) .and. CB9->CB9_STATUS == "1"
						CB9->(RecLock("CB9",.F.))
						CB9->CB9_LOCAL := cArmComp
						CB9->(MsUnlock())
						CB9->(DbCommit())
					Endif
					CB9->(DbSkip())
				End
				CB8->(DbSkip())
			End
		Next
		Return

Static Function xArraLen(aDados,cCodOpe)   //giovani

	Local nxretDados:=0
	Local cXCodOpe	:= cCodOpe //CB7->CB7_CODOPE  	//FR - 29/09/2022 - ocorria error log qdo chamado direto o campo, 
													//estou passando por parโmetro na fun็ใo
	Local i:= 0
	DbSelectArea("CB1")
	CB1->(DbSetOrder(1))
	If  CB1->(DbSeek(xFilial('CB1')+cCodOpe))
		For i:=1 To Len(aDados)
			If aDados[i,3]  = CB1->CB1_XLOCAL
				nxretDados+=1
			Endif
		Next i
	Endif
	If 	nxretDados=0
		nxretDados:=Len(aDados)
	EndIf
Return (nxretDados)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuncao    ณ STSLDSC6   ณ Autor ณ Leonardo Kichitaro/Renato Steckณ Data ณ 15/04/13ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Retorna Saldo do Item do Pedido de venda.                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ STECK                                                                ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function STSLDSC6(nRecno)

	Local nRet		:= 0
	Local nQtdSDC	:= 0

	SC6->(DbGoTo(nRecno))

	SC9->(DbSetOrder(1)) //C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_SEQUEN+C9_PRODUTO
	SDC->(DbSetOrder(1)) //DC_FILIAL+DC_PRODUTO+DC_LOCAL+DC_ORIGEM+DC_PEDIDO+DC_ITEM+DC_SEQ+DC_LOTECTL
	SC9->(DbSeek(xFilial("SC9")+SC6->(C6_NUM+C6_ITEM)))
	While SC9->(! Eof() .and. SC9->(C9_FILIAL+C9_PEDIDO+C9_ITEM) == xFilial("SC9")+SC6->(C6_NUM+C6_ITEM))
		If !Empty(SC9->C9_NFISCAL)
			SC9->(DbSkip())
			Loop
		Endif

		SDC->( dbSeek(xFilial("SDC")+SC9->C9_PRODUTO+SC9->C9_LOCAL+"SC6"+SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_SEQUEN))
		While SDC->(! Eof() .and. DC_FILIAL+DC_PRODUTO+DC_LOCAL+DC_ORIGEM+DC_PEDIDO+DC_ITEM+DC_SEQ==;
				xFilial("SDC")+SC9->(C9_PRODUTO+C9_LOCAL+"SC6"+C9_PEDIDO+C9_ITEM+C9_SEQUEN))

			nQtdSDC += SDC->DC_QUANT

			SDC->(DbSkip())
		End
		SC9->(DbSkip())
	End

	nRet := SC6->C6_QTDVEN - SC6->C6_QTDENT - nQtdSDC

Return nRet

User Function SALDPVST(_cPedxst)

	Local _nxRet  := 0

	DbSelectArea('SC6')
	SC6->(DbSetOrder(1))
	If SC6->(DbSeek(xFilial("SC6")+_cPedxst))
		While SC6->(!Eof()) .and. SC6->C6_FILIAL+SC6->C6_NUM == xFilial("SC6")+_cPedxst
			_nxRet += ( SC6->C6_ZVALLIQ / SC6->C6_QTDVEN ) * (SC6->C6_QTDVEN-SC6->C6_QTDENT)
			SC6->(DbSkip())

		End
	Endif
Return(_nxRet)

User Function StResiduo (cNewEmp, cNewFil,_cPed,nOpc)

	Conout ("Elimina็ใo de residuo na filial 01 automatico")

	//Inicia outra Thread com outra empresa e filial
	RpcSetType( 3 )
	RpcSetEnv( cNewEmp, cNewFil,,,"FAT")
	Conout ("Elimina็ใo de residuo na filial 01 automatico  -"+cfilant)
	DbSelectArea("SC6")
	SC6->(DbGoTop())
	SC6->(DbSetOrder(1))
	If SC6->(DbSeek("01"+_cPed))
		While SC6->(!Eof()) .and.  _cPed = SC6->C6_NUM   .AND. SC6->C6_FILIAL = '01'
			Conout ("Elimina็ใo de residuo na filial 01 automatico  -"+_cPed+SC6->C6_item)

			/*If !   MaResDoFat(SC6->(RECNO()), .T.,.F.,0)
			Conout ("nao executou "+_cPed+SC6->C6_item)
			_lxret:=.f.
		Endif
			*/

			SC6->(RecLock("SC6"),.F.)
			SC6->C6_BLQ	:= "R"
			SC6->(MsUnLock())
			SC6->(DbCommit())
			SC6->(DbSkip())

		End
	Endif
	DbSelectArea("SC5")
	SC5->(DbSetOrder(1))
	If SC5->(DbSeek('01'+_cPed))
		SC5->(RecLock("SC5",.F.))
		SC5->C5_NOTA   :=  'XXXXXXXXX'
		SC5->(Msunlock("SC5"))
		SC5->( DbCommit() )
	Endif
	RpcClearEnv() //volta a empresa anterior

Return ()

//***********************************************************************************************

Static Function CEPALTSC5(_cCep)

	_cCep:= StrTran(_cCep,"-","")
	_cCep:=  AllTrim(_cCep)
	If Len(_cCep) <> 8 .And. ! Empty(AllTrim(_cCep))
		MsgInfo("Cep Nใo Encontrado..!!!"+CR+CR+"Verifique o Cep Digitado!!!")
		Return(.f.)
	EndIf

	// Ajuste referente ao Ticket 20220829016666.
	/*If _cCep = '02275010'
		MsgInfo("Cep Nใo Autorizado....Solicite Libera็ใo เ Gerencia Comercial...!!!!")
		Return(.f.)
	EndIf*/

	DbSelectArea("JC2")
	JC2->( dbSetOrder(1) )
	If JC2->( dbSeek(xFilial("JC2")+_cCep) ) .And. !Empty(Alltrim(_cCep))

		If Posicione('SA1',1,xFilial('SA1')+SC5->C5_CLIENT+SC5->C5_LOJAENT,'A1_EST') <> Alltrim(JC2->JC2_ESTADO) .And. SC5->C5_CLIENTE <> '070874' .And. Posicione('SC6',1,xFilial('SC6')+SC5->C5_NUM,'C6_OPER') <> '95'
			MSGINFO('UF divergente!!!')
			Return(.f.)
		ElseIf Posicione('SA1',1,xFilial('SA1')+SC5->C5_CLIENTE+SC5->C5_LOJACLI,'A1_CEP') = Alltrim(_cCep)
			MSGINFO('Cep de Entrega NยO pode ser Igual Cep de Faturamento..!!!!!!')
			Return(.f.)
		Else
			cZEstE			:= Alltrim(JC2->JC2_ESTADO)
			cZMunE			:= Alltrim(JC2->JC2_CIDADE)
			cZBairrE		:=  Iif(Empty(Alltrim(JC2->JC2_BAIRRO)), TiraGraf(STNUMCEP('2')) ,Alltrim(JC2->JC2_BAIRRO))
			cZEndEnt		:= Iif(Empty(Alltrim(JC2->JC2_LOGRAD)),TiraGraf(STNUMCEP('3'))  ,Alltrim(JC2->JC2_LOGRAD))
			cZEndEnt		:= TiraGraf(cZEndEnt+', '+TiraGraf(STNUMCEP('1')))
			cZCodM			:= Alltrim(JC2->JC2_CODCID)
			cZCepE			:=  _cCep

		EndIf
	Else
		If !Empty(Alltrim(_cCep))
			MsgInfo("Cep Nใo Encontrado..!!!"+CR+CR+"Verifique o Cep Digitado!!!")
		Else
			_cCep := '        '
		EndIf
		cZEstE			:= SPACE(TamSx3("A1_EST")[1])
		cZMunE			:= SPACE(TamSx3("A1_MUN")[1])
		cZBairrE		:= SPACE(TamSx3("A1_BAIRRO")[1])
		cZEndEnt		:= SPACE(TamSx3("A1_END")[1])
		cZCepE			:=  _cCep
		cZCodM			:= SPACE(TamSx3("C5_XCODMUN")[1])
	EndIf
Return(.T.)

	/*====================================================================================\
	|Programa  | STNUMCEP         | Autor | GIOVANI.ZAGO             | Data | 19/07/2014  |
	|=====================================================================================|
	|Descri็ใo | STNUMCEP                                                                 |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | STNUMCEP                                                                 |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Hist๓rico....................................|
	\====================================================================================*/
	*-----------------------------*
Static Function STNUMCEP(_cTip)
	*-----------------------------*
	Local _cRet := Space(60)
	Local oDlgEmail
	Local lSaida      := .F.
	If _cTip = '1'
		Do While !lSaida

			DEFINE MSDIALOG oDlgEmail TITLE OemToAnsi("Numero Entrega") From  1,0 To 80,200 Pixel OF oMainWnd

			@ 02,04 SAY "Numero:" PIXEL OF oDlgEmail
			@ 12,04 MSGet _cRet   Size 55,013  PIXEL OF oDlgEmail valid !Empty(Alltrim(_cRet))
			@ 12,62 Button "Ok"      Size 28,13 Action iif(!Empty(Alltrim(_cRet)),Eval({||lSaida:=.T.,oDlgEmail:End()}),msginfo("Preencha o Numero..!!!"))  Pixel

			ACTIVATE MSDIALOG oDlgEmail CENTERED
		EndDo
	ElseIf _cTip = '2'
		Do While !lSaida

			DEFINE MSDIALOG oDlgEmail TITLE OemToAnsi("Bairro Entrega") From  1,0 To 85,200 Pixel OF oMainWnd

			@ 02,04 SAY "Bairro:" PIXEL OF oDlgEmail
			@ 12,04 MSGet _cRet   Size 90,013  PIXEL OF oDlgEmail valid !Empty(Alltrim(_cRet))
			@ 26,35 Button "Ok"      Size 28,13 Action iif(!Empty(Alltrim(_cRet)),Eval({||lSaida:=.T.,oDlgEmail:End()}),msginfo("Preencha o Numero..!!!"))  Pixel

			ACTIVATE MSDIALOG oDlgEmail CENTERED
		EndDo

	ElseIf _cTip = '3'
		Do While !lSaida

			DEFINE MSDIALOG oDlgEmail TITLE OemToAnsi("Endere็o Entrega") From  1,0 To 85,200 Pixel OF oMainWnd

			@ 02,04 SAY "Endere็o:" PIXEL OF oDlgEmail
			@ 12,04 MSGet _cRet   Size 90,013  PIXEL OF oDlgEmail valid !Empty(Alltrim(_cRet))
			@ 26,35 Button "Ok"      Size 28,13 Action iif(!Empty(Alltrim(_cRet)),Eval({||lSaida:=.T.,oDlgEmail:End()}),msginfo("Preencha o Numero..!!!"))  Pixel

			ACTIVATE MSDIALOG oDlgEmail CENTERED
		EndDo
	EndIf
Return(Alltrim(_cRet))

Static function TiraGraf (_sOrig)
	local _sRet := _sOrig
	_sRet = strtran (_sRet, "แ", "a")
	_sRet = strtran (_sRet, "้", "e")
	_sRet = strtran (_sRet, "ํ", "i")
	_sRet = strtran (_sRet, "๓", "o")
	_sRet = strtran (_sRet, "๚", "u")
	_SRET = STRTRAN (_SRET, "ม", "A")
	_SRET = STRTRAN (_SRET, "ษ", "E")
	_SRET = STRTRAN (_SRET, "อ", "I")
	_SRET = STRTRAN (_SRET, "ำ", "O")
	_SRET = STRTRAN (_SRET, "ฺ", "U")
	_sRet = strtran (_sRet, "ใ", "a")
	_sRet = strtran (_sRet, "๕", "o")
	_SRET = STRTRAN (_SRET, "ร", "A")
	_SRET = STRTRAN (_SRET, "ี", "O")
	_sRet = strtran (_sRet, "โ", "a")
	_sRet = strtran (_sRet, "๊", "e")
	_sRet = strtran (_sRet, "๎", "i")
	_sRet = strtran (_sRet, "๔", "o")
	_sRet = strtran (_sRet, "๛", "u")
	_SRET = STRTRAN (_SRET, "ย", "A")
	_SRET = STRTRAN (_SRET, "ส", "E")
	_SRET = STRTRAN (_SRET, "ฮ", "I")
	_SRET = STRTRAN (_SRET, "ิ", "O")
	_SRET = STRTRAN (_SRET, "Û", "U")
	_sRet = strtran (_sRet, "็", "c")
	_sRet = strtran (_sRet, "ว", "C")
	_sRet = strtran (_sRet, "เ", "a")
	_sRet = strtran (_sRet, "ภ", "A")
	_sRet = strtran (_sRet, "บ", ".")
	_sRet = strtran (_sRet, "ช", ".")
	_sRet = strtran (_sRet, chr (9), " ") // TAB
return _sRet

Static Function STSA3WNHE(_cCod)
	Local _lRsa3 := .F.
	Local _cSa3Id:= GetMv("ST_SA3WHE",,"000000")+"/000000/000645"

	DbSelectArea('SA3')
	SA3->(DbSetOrder(7))
	If SA3->(dbSeek(xFilial('SA3')+_cCod))
		_lRsa3 := .T.
	EndIf

	If _cCod $ _cSa3Id
		_lRsa3 := .T.
	EndIf

	Return(_lRsa3)

	/*====================================================================================\
	|Programa  | STGIOSD4          | Autor | GIOVANI.ZAGO             | Data | 03/06/2015 |
	|=====================================================================================|
	|Descri็ใo | STGIOSD4                                                                 |
	|          | Atualiza SD4													      	  |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | STGIOSD4                                                                 |
	|=====================================================================================|
	|Uso       | Especifico Steck                                                         |
	|=====================================================================================|
	|........................................Hist๓rico....................................|
	\====================================================================================*/
	*----------------------------------------------------------------------------------*
User Function STGIOSD4(cDoc)
	*----------------------------------------------------------------------------------*
	Local aSD4x := {}
	Local cOP	:= Padr(cDoc,14)
	Local cQuery        := ""
	Local cAlias4		:= "STGIOSD4"
	Local cPerg       	:= "STGIOSD4999"
	Local cTime         := Time()
	Local cHora         := SUBSTR(cTime, 1, 2)
	Local cMinutos    	:= SUBSTR(cTime, 4, 2)
	Local cSegundos   	:= SUBSTR(cTime, 7, 2)
	Local cxAliasLif   	    := cPerg+cHora+ cMinutos+cSegundos
	Local aTravas		:={}
	Local cAux 			:= Subs(Dtos(dDatabase)+StrTran(Time(),":",""),2)
	Local aSaldo 		:= {}
	Local aLotes 		:= {}
	Local aAlias3		:= {}
	Local aAlias3a		:= {}
	Local _nPosProd		:= 0
	Local nX:= 0
	Local nXz:= 0
	Local nxx:= 0

	SD4->(DbSetOrder(2))
	If	SD4->(DbSeek(xFilial('SD4')+cOP))

		dbSelectArea(cAlias3)
		(cAlias3)->(dbGoTop())

		do While (cAlias3)->(!Eof())
			aadd(aAlias3,{ (cAlias3)->PRODUTO,(cAlias3)->FALTA,(cAlias3)->SOMA,(cAlias3)->OP ,(cAlias3)->TRT })
			(cAlias3)->(DbSkip())
		EndDo

		While SD4->(! Eof() .and. D4_FILIAL+D4_OP == xFilial('SD4')+cOP)
			If ! Empty(SD4->D4_XORDSEP)
				SD4->(DBSkip())
				Loop
			EndIf
			_nPosProd     := aScan(aAlias3, { |x| Alltrim(x[1]) == Alltrim(SD4->D4_COD)   })
			If _nPosProd > 0
				aadd(aSD4x,SD4->(Recno()))
				_nPosProd:=0
			EndIf

			SD4->(DbSkip())
		End

		For nX:= 1 to len(aSD4x)
			// eliminar o sd4 original.
			SD4->(DbGoto(aSD4x[nX]))

			SD4->(RecLock('SD4',.F.))
			SD4->(DbDelete())
			SD4->(MsUnlock())
			SD4->(DbCommit())
		Next nx

		For nX:= 1 to len(aAlias3)

			If aAlias3[nX,2] > 0

				A650ReplD4(;
				aAlias3[nX,1] ,;
				'01',;
				dDataBase,;
				aAlias3[nX,2],;
				aAlias3[nX,4],;
				aAlias3[nX,5],;
				NIL,;
				NIL,;
				NIL,;
				Repl("Z",13))
			EndIf
			//CRIO A SD4 DE ACORDO COM SDC
			aSaldo := SldPorLote(aAlias3[nX,1] ,'90',aAlias3[nX,3])
			aLotes := {}
			For nXz:= 1 to len(aSaldo)
				nPos := ascan(aLotes,{|x| x[1] == aSaldo[nXz,1]})
				If nPos == 0
					aadd(aLotes,aClone(aSaldo[nxz]))
				Else
					aLotes[nPos,5] +=	aSaldo[nxz,5]
					aLotes[nPos,6] +=	aSaldo[nxz,6]
				EndIf
			Next nxz
			A650ReplD4(;
			aAlias3[nX,1] ,;
			'90',;
			dDataBase,;
			aAlias3[nX,3],;
			aAlias3[nX,4],;
			aAlias3[nX,5],;
			NIL,;
			NIL,;
			NIL,;
			Subs(Dtos(dDatabase)+StrTran(Time(),":",""),2))
			For nXx:= 1 to len(aLotes)
				//CONOUT(aAlias3[nX,1] + " - GRAVAEMP")
				GravaEmp(aAlias3[nX,1],;      					// produto
				'90',;							// local
				aLotes[nXx,5],;					// qtde 1 un
				aLotes[nXx,6],;					// qtde 2 un
				aLotes[nXx,1],;					// lote
				aLotes[nXx,2],;					// num lote
				NIL,;							// endere็o
				NIL,;							// numero de serie
				aAlias3[nX,4],;					// op
				aAlias3[nX,5],;				// sequencia
				NIL,;							// pedido de venda
				NIL,;							// item do pedido
				"SC2",;							// origem
				cAux,;							// op original
				dDataBase,;						// data de entrega
				@aTravas,;						// controle de travas nao sei o que faz
				.F.,;							// estorno
				NIL,;							// integracao PMS
				.T.,;              				// atualiz sb2
				.F.,;							// gera sd4
				NIL,;				  			// considera lote vencido
				.T.,;							// Empenha SB8 e SBF
				.T.,;  							//	CriaSDC
				NIL,;                      		// Encerra OP
				aAlias3[nX,4])					// ID DCF, estamos utilizando este campo nos espeficios no ACD

				MaDestrava(aTravas)

			Next nxx

		Next nx

	EndIf
Return()

User Function STSD4QUER(cDoc,_aTrans)

	Local aSD4x := {}
	Local cOP			:= Padr(cDoc,14)
	Local cQuery        := ""
	Local cPerg       	:= "STGIOSD4"
	Local cTime         := Time()
	Local cHora         := SUBSTR(cTime, 1, 2)
	Local cMinutos    	:= SUBSTR(cTime, 4, 2)
	Local cSegundos   	:= SUBSTR(cTime, 7, 2)
	Local cAlias4   	:= cPerg+cHora+ cMinutos+cSegundos
	Local _cPrOs        := ' '
	Local i:=0

	For i:= 1 To Len(_aTrans)
		If i = 1
			_cPrOs := "( '"+_aTrans[i,1]+"'"
		Else
			_cPrOs += ",'"+_aTrans[i,1]+"'"
		EndIf

	Next i

	_cPrOs        += " )"
	//CONOUT(_cPrOs )
	cQuery := " SELECT DC_FILIAL, DC_ORIGEM, DC_PRODUTO AS PRODUTO , DC_LOCAL, SUM(DC_QUANT) AS SOMA , DC_OP AS OP,DC_TRT AS TRT,
	cQuery += " NVL((SELECT  SUM (PA1_QUANT)
	cQuery += " FROM "+RetSqlName("PA1")+" PA1 "
	cQuery += " WHERE PA1.D_E_L_E_T_ = ' ' AND  PA1_CODPRO = DC_PRODUTO AND PA1_TIPO = '2' AND PA1_DOC = DC_OP AND PA1_FILIAL = DC_FILIAL),0)
	cQuery += " AS FALTA
	cQuery += " FROM "+RetSqlName("SDC")+" DC "
	cQuery += " WHERE DC.D_E_L_E_T_=' ' AND DC_OP= '"+cOP+"' AND DC_FILIAL = '"+xFilial("SDC")+"'
	cQuery += " AND DC_PRODUTO IN "+_cPrOs

	cQuery += " GROUP BY DC_FILIAL, DC_ORIGEM, DC_PRODUTO, DC_LOCAL, DC_OP,DC_TRT

	If !Empty(Select(cAlias3))
		DbSelectArea(cAlias3)
		(cAlias3)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias3,.T.,.T.)
Return()

Static Function STCABECTOK(_cTransp,_cTpFrete,_cZCodM,_dDtProg,_aAltIni,cEntFat,cTipFat1)
//FR - 11/07/2022 - valida็ใo dos campos de nใo gerar OS: data de / at้ - Flแvia Rocha - Sigamat Consultoria
Local cDataDe := CtoD("  /  /    ")
Local cDataTe := CtoD("  /  /    ")


	IF !EMPTY(_dDtProg) .AND. EMPTY(ALLTRIM(cEntFat))		
		MsgAlert("Aten็ใo, deve ser preenchido o campo Data entrega/faturamento")
		Return(.F.)
	ELSEIF EMPTY(_dDtProg) .AND. !EMPTY(ALLTRIM(cEntFat))		
		MsgAlert("Aten็ใo, deve ser preenchido o campo Ent. Prog. Cliente")
		Return(.F.)		
	ENDIF

//FR - 11/07/2022 - valida็ใo dos campos de nใo gerar OS: data de / at้ - Flแvia Rocha - Sigamat Consultoria

	If Empty(AllTrim(_cTransp))
		MsgAlert("Aten็ใo, transportadora nใo preenchida, verifique!")
		Return(.F.)
	EndIf

	If _cTransp=="000001" .And. !(AllTrim(_cTpFrete)=="CIF") //Chamado 002987
		MsgAlert("Aten็ใo, transportadora Steck e frete diferente de CIF")
		Return(.F.)
	EndIf

    // Valida altera็ใo do tipo de faturamento Total/Parcial para clientes HomeCenter 
	IF ! U_VLDTPFAT(SC5->C5_CLIENTE,SC5->C5_LOJACLI,cTipFat1,SC5->C5_NUM)
	   Return(.F.)
	ENDIF   


	If _cTransp = "000163" .And. GetMv("ST_TNTCF",,.T.)//  (AllTrim(_cTpFrete)=="CIF")  //Chamado 005994
		xcZCodM:= ' '
		If Empty(Alltrim(_cCodMun))
			xcZCodM:= Posicione('SA1',1,xFilial('SA1')+SC5->C5_CLIENT+SC5->C5_LOJAENT,'A1_COD_MUN')
		Else
			xcZCodM:= _cCodMun
		EndIf
		/*
		Ticket: 20210811015405 - Valdemir Rabelo - 23/08/2021
		Removido conforme conversa com Kleber	
		DbSelectArea("CC2")
		CC2->(DbSetOrder(3))
		CC2->(DbGoTop())
		If CC2->(DbSeek(xFilial("CC2")+xcZCodM))//CC2->(DbSeek(xFilial("CC2")+cZEstE+cZCodM))
			If  AllTrim(CC2->CC2_XSTECK)="S" .AND. ALLTRIM(SA1->A1_ATIVIDA) <> "VE"
				MsgAlert("Aten็ใo, para essa situa็ใo a transportadora nใo pode ser TNT")
				Return(.F.)
			EndIf
		EndIf
		*/
EndIf

	/***********************************************************************************************************************
	<<<< ALTERAวรO >>> 
	A็ใo.........: 1 - Verifica se a Data de Entrega Progamada foi alterada
	.............: 2 - Caso tenha sido alterada passa pela rotina MSTECK15 "Fun็ใo para cแlculo dos dias da entrega progamada"
	.............: 3 - Se a roitna MSTECK15 retornar .T. segue o processo caso contrแrio apresenta o erro.
.............: 4 - Retornando .T. da MSTECK15 mata todas as Reservas "PA2" e Empenhos "PA1 e Z96" para o pedido.
.............: 5 - Limpa o campo C6_XDTRERE data da reserva/falta
	Desenvolvedor: Marcelo Klopfer Leme
	Data.........: 01/06/2022
	Chamado......: 20220429009114 - Oferta Logํstica
	***********************************************************************************************************************/
IF (_dDtProg < DATE()) .AND. !EMPTY(_dDtProg)
	MSGINFO("A data de progrma็ใo nใo pode ser inferior a "+DTOC((DATE()+GETMV("MV_DIASENT",,45))))
	RETURN .F.
ENDIF

IF (CTOD(_aAltIni[ascan(_aAltIni,{|x| x[2] == "Ent. Prog. Cliente"})][1]) <> _dDtProg) 
	IF U_MSTECK15(.T.,_dDtProg) = .F.
		MSGINFO("Nใo foi possํvel alterar as datas de entregas.")
		RETURN .F.
	ENDIF
ENDIF

	//FR - 11/07/2022 - valida็ใo dos campos de nใo gerar OS: data de / at้ - Flแvia Rocha - Sigamat Consultoria
	//cxDe,cxMDe,cxAnoD,cxAte,cxMAte,cxAnoA
	/*cDataDe := CtoD(cxDe  + "/" + cxMDe  + "/" + cxAnoD)
	cDataTe := Ctod(cxAte + "/" + cxMAte + "/" + cxAnoA)
		
	If cDataTe < cDataDe //data ATษ nใo pode ser maior que data DE
		MsgAlert("Aten็ใo, Favor Revisar Campo 'Nใo Gera OS' -> 'Data At้' Menor que 'Data De', verifique!")
		Return(.F.)
	Endif */
	//FR - 11/07/2022 - valida็ใo dos campos de nใo gerar OS: data de / at้ - Flแvia Rocha - Sigamat Consultoria
	
Return(.T.)


User Function STSLDPA2(_cCod,_cFilRes,_cTipo)

	Local cQuery1 	:= ""
	Local cAlias1 	:= "QRYTEMP"
	Local _nSaldo	:= 0

	cQuery1	 := " SELECT SUM(PA2_QUANT) AS SALDO "
	cQuery1  += " FROM " +RetSqlName("PA2")+ " PA2 "
	cQuery1  += " WHERE PA2.D_E_L_E_T_=' ' AND PA2.PA2_FILIAL='"+xFilial("PA2")+"' "
	cQuery1  += " AND PA2.PA2_CODPRO='"+_cCod+"' AND PA2.PA2_FILRES='"+_cFilRes+"' AND PA2.PA2_TIPO='"+_cTipo+"' "

	If !Empty(Select(cAlias1))
		DbSelectArea(cAlias1)
		(cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1),cAlias1,.T.,.T.)

	dbSelectArea(cAlias1)
	(cAlias1)->(dbGoTop())

	_nSaldo	:= (cAlias1)->SALDO

Return(_nSaldo)

User Function STMONISDC(cDoc)

	Local cQuery1 			:= ""
	Local _nSaldo			:= 0
	Local _aSdDc			:= {}
	Private cPerg 			:= "STMONISDC"
	Private cTime           := Time()
	Private cHora           := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private _cAliasd4   		:= cPerg+cHora+ cMinutos+cSegundos

	cQuery1  := " SELECT
	cQuery1  += " D4_COD,D4_QTDEORI,D4_OP, SUM(DC_QTDORIG)
	cQuery1  += ' "EMPENHO",
	cQuery1  += " D4_QTDEORI - SUM(DC_QTDORIG)
	cQuery1  += ' "SALDO"
	cQuery1  += " FROM " +RetSqlName("SD4")+ " SD4
	cQuery1  += " INNER JOIN(SELECT * FROM " +RetSqlName("SDC")+" )SDC
	cQuery1  += " ON SDC.D_E_L_E_T_ = ' '
	cQuery1  += " AND DC_FILIAL = D4_FILIAL
	cQuery1  += " AND DC_LOCAL = D4_LOCAL
	cQuery1  += " AND DC_PRODUTO = D4_COD
	cQuery1  += " AND DC_OP = D4_OP
	cQuery1  += " WHERE SD4.D_E_L_E_T_ = ' '
	cQuery1  += " AND D4_FILIAL = '"+xFilial("SD4")+"' "
	cQuery1  += " AND D4_LOCAL = '90'
	cQuery1  += " AND D4_QUANT <> 0
	cQuery1  += " AND D4_OP = '"+cDoc+"' "
	cQuery1  += " GROUP BY D4_COD,D4_QTDEORI,D4_QUANT,D4_OP

	If !Empty(Select(_cAliasd4))
		DbSelectArea(_cAliasd4)
		(_cAliasd4)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1),_cAliasd4,.T.,.T.)

	dbSelectArea(_cAliasd4)
	(_cAliasd4)->(dbGoTop())

	If  Select(_cAliasd4) > 0

		While 	(_cAliasd4)->(!Eof())

			If  (_cAliasd4)->SALDO <> 0
				Aadd(_aSdDc,{ (_cAliasd4)->D4_COD,(_cAliasd4)->D4_QTDEORI,(_cAliasd4)->D4_OP,(_cAliasd4)->EMPENHO,(_cAliasd4)->SALDO  })
			EndIf

			(_cAliasd4)->(dbskip())

		End
	EndIf

	If Len(_aSdDc) > 0
		STD4DCMAIL(_aSdDc)
	EndIf

Return

	/*====================================================================================\
	|Programa  | STCAMMAIL        | Autor | GIOVANI.ZAGO             | Data | 14/08/2014  |
	|=====================================================================================|
	|Descri็ใo | STCAMMAIL                                                                |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | STCAMMAIL                                                                |
	|=====================================================================================|
	|Uso       | EspecIfico STECK                                                         |
	|=====================================================================================|
	|........................................Hist๓rico....................................|
	\====================================================================================*/
	*------------------------------------------------------------------*
Static Function  STD4DCMAIL(_aSdDc)
	*------------------------------------------------------------------*

	Local aArea 	:= GetArea()
	Local _cFrom   := "protheus@steck.com.br"//Lower(Alltrim(Posicione("SU7",1,xFilial("SU7")+SC5->C5_OPERADO,"U7_EMAIL")))
	Local _cAssunto:= 'Monitoramento Empenho Duplicado OP:'//+_aSdDc[i,3] Ruptura Zero - Jefferson/Everson - 07.03.18
	Local cFuncSent:= "STD4DCMAIL"
	Local _aMsg    :={}
	Local i        := 0
	Local cArq     := ""
	Local cMsg     := ""
	Local _nLin
	Local _cCopia  := ' '
	Local cAttach  := ''

	default _cEmail  := "everson.santana@steck.com.br"

	If ( Type("l410Auto") == "U" .OR. !l410Auto )

		For i:=1 To Len(_aSdDc)
			Aadd( _aMsg , { "Ocorrencia:"   , TRANSFORM(i ,"@E  99999")  } )
			Aadd( _aMsg , { "Produto: "     , _aSdDc[i,1]   } )
			Aadd( _aMsg , { "D4 Orig.: "    , TRANSFORM(_aSdDc[i,2] ,"@E  999,999,999.99")  } )
			Aadd( _aMsg , { "OP: "    		, _aSdDc[i,3]  } )
			Aadd( _aMsg , { "Empenho SDC: " , TRANSFORM(_aSdDc[i,4] ,"@E  999,999,999.99")  } )
			Aadd( _aMsg , { "Diferen็a: "   , TRANSFORM(_aSdDc[i,5] ,"@E  999,999,999.99")  } )
		Next i

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Definicao do cabecalho do email                                             ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Definicao do texto/detalhe do email                                         ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		For _nLin := 1 to Len(_aMsg)
			If (_nLin/2) == Int( _nLin/2 )
				cMsg += '<TR BgColor=#B0E2FF>'
			Else
				cMsg += '<TR BgColor=#FFFFFF>'
			EndIf
			cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
			cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
			cMsg += '</TR>'
		Next
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Definicao do rodape do email                                                ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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

	EndIf
	RestArea(aArea)
Return()

/*/{Protheus.doc} getWhen
	description
	Rotina para habilitar campos 
	Ticket 20201127011359
	@type function
	@version  
	@author Valdemir Jose
	@since 29/12/2020
	@return return_type, return_description
/*/
Static Function getWhen()
	Local lRET := .T.
	Local aArea:= GetArea()

	DbSelectArea("SA3")
	SA3->(DbSetOrder(7))
	SA3->(DbGotop())
	If SA3->(dbSeek(xFilial("SA3")+__cUserId))
		lRET := (SubStr(SA3->A3_COD,1,1) $ "I")
		if !lRET
			lRET := GetMv("ST_CEPBLQ",,.T.)
		endif
	Else
		lRET := GetMv("ST_CEPBLQ",,.T.)
	Endif

	RestArea( aArea )

Return lRET

// Chamada via Dicionario PP7 -> PP7_PEDIDO (Valdemir Rabelo - 04/01/2021)
User Function getWhenU()
Return getWhen()






/*/{Protheus.doc} 
	description
	Rotina para abrir ou nใo a tela de sele็ใo de Consumo / Industrializa็ใo 
	Ticket  20230614007358
	@type function
	@version  
	@author Antonio Cordeiro. 
	@since 15/06/2023
	@return 'S' ou branco 
/*/


User Function TelaConsumo(_cCod,_cLoja)

Local cRet:="N"
Local _cCliMELI     := GetNewPar("ST_CLIMELI" , "102917")  //cliente para envio de pedido remessa MERCADO LIVRE
Local _lEst         :=.T.

Local _cCliTip    :='SA1->A1_TIPO'	 
Local _cCliContrib:='SA1->A1_CONTRIB'
Local _cCliGru    :='SA1->A1_ATIVIDA'
Local _cCliInscr  :='SA1->A1_INSCR'
Local _cCodigo    :='SA1->A1_COD'
Local aAreaSA1    :=SA1->(GETAREA())
Local aArea       :=GETAREA()


SA1->(DBSETORDER(1))
IF SA1->(DBSEEK(XFILIAL('SA1')+_cCod+_cLoja))
   IF  Alltrim(&_cCodigo) != Alltrim(_cCliMELI)  //Se cliente nใo for MERCADO LIVRE
	   If (&_cCliTip $ 'R' .And. &_cCliContrib = '1'  .And. !(alltrim(&_cCliGru) $ 'D1/D2/D3/R1/R2/R3/R5' ) .And. (!Empty(ALLTRIM(&_cCliInscr)) .Or. 'ISENT' $ Upper(ALLTRIM(&_cCliInscr)))) .Or. ;
	      (&_cCliTip $ 'F' .And. &_cCliContrib = '1'  .And. (!Empty(ALLTRIM(&_cCliInscr)) .Or. 'ISENT' $ Upper(ALLTRIM(&_cCliInscr))) .and. _lEst );
          .or. ((&_cCliTip $ 'S' .And. &_cCliContrib = '1'  .And. (!Empty(ALLTRIM(&_cCliInscr)) .Or. 'ISENT' $ Upper(ALLTRIM(&_cCliInscr))) .and. _lEst ) .and.;
	      (cFilAnt=='02' .AND. cCod=='012047' .AND. cLoja=='09'))    // Cliente Adicionado 01/07/2021 - Ticket: 20210108000420 - Valdemir Rabelo
          cRet:='S' 
       ENDIF	   
	ENDIF   
ENDIF

RestArea(aAreaSA1)
RestArea(aArea)


Return(cRet)



//=================================================================================================================//
//FUNวรO  : STMONTAMAIL            AUTORIA: FLมVIA ROCHA                DATA: 10/05/2023 
//OBJETIVO: MONTAR A ESTRUTURA DO HTML DA MENSAGEM QUE SERม ENVIADA VIA WF PARA AVISAR DA TRANSFERสNCIA REALIZADA
//=================================================================================================================//
USER FUNCTION STMONTAMAIL(cMsg,_aEmail,cOrdSep)

LOCAL _nLin    := 0
LOCAL cFuncSent:= "STMONTAMAIL"
LOCAL nQtVol   := 0  //conta qtos volumes
LOCAL nPesVol  := 0  //peso do volume
LOCAL _nCubTot := 0

cMsg += CRLF + CRLF
cMsg += '<html>'
cMsg += '<head>'
cMsg += '<title>' +SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
cMsg += '</head>'
cMsg += '<body>'
cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>'+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
//TอTULOS DAS COLUNAS: 
cMsg += '<TR><B><TD>PEDIDO</TD>'
cMsg += '<TD>OS</TD>'
cMsg += '<TD>CำDIGO</TD>'
cMsg += '<TD>DESCRIวรO</TD>'
cMsg += '<TD>QUANTIDADE</TD>'
cMsg += '</B>'
cMsg += '</TR>'

//CB9->(Aadd(aRet,{;
//		CB9_PROD ,;		//1-PRODUTO
//		 CB9_QTESEP,;	//2-QUANTIDADE
//		 CB9_LOCAL,;	//3-LOCAL ORIGEM
//		 cArML,;		//4-LOCAL DESTINO
//		 CB9_LCALIZ,;	//5-ENDEREวO
//		 CB9_LOTSUG,;	//6-LOTE
//		 CB9_SLOTSU,;	//7-SUBLOTE
//		 ""     ,;		//8-D4_TRT
//		 ""      ,;		//9-D4_OPORIG
//		 CB9_PEDIDO,;	//10-PEDIDO
//		 CB9_VOLUME;	//11-NRO. VOLUME
//		  }))

//Aadd(aTransfOK, { aDados[nI,1] , SB1->B1_DESC, aDados[nI,2], aDados[nI,5] , cEndpad     , aDados[nI,10],aDados[nI,3], cArML      })
		//                 cod.prod     , descri็ใo    , qtde       , end.origem   , end.destin , ped.venda    , Armz.origem  , Arm.Destino
		//                 1              2              3            4              5            6              7              8


//CONTEฺDO DO ARRAY DE ITENS TRANSFERIDOS: 
//CONTA QTOS VOLUMES TEM O PEDIDO
CB6->(OrdSetfocus(2)) //CB6_FILIAL + CB6_PEDIDO
If CB6->(Dbseek(xFilial("CB6")+ _aEmail[1,6] ))
	While CB6->(!Eof()) .and. Alltrim(CB6->CB6_PEDIDO) == Alltrim(_aEmail[1,6])
		nQtVol++  //conta qtos volumes pela qtde de registros na CB6
		nPesVol += CB6->CB6_XPESO
		_nCubTot += Posicione("CB3",1,xFilial("CB3") + CB6->CB6_TIPVOL,"CB3_VOLUME") 
		CB6->(DBSKIP())
	Enddo
Endif 

For _nLin := 1 to Len(_aEmail)
	If (_nLin/2) == Int( _nLin/2 )
		cMsg += '<TR BgColor=#B0E2FF>'
	Else
		cMsg += '<TR BgColor=#FFFFFF>'
	EndIf
	
	SB1->(dbSeek(xFilial("SB1")+_aEmail[_nLin,1]))		
		
	cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aEmail[_nLin,6] + ' </Font></TD>'				//PEDIDO
	cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + cOrdSep + ' </Font></TD>'						//OS
	cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">'  + _aEmail[_nLin,1] + ' </Font></TD>'				//PRODUTO
	cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">'  + SB1->B1_DESC   + ' </Font></TD>'				//DESCR.PRODUTO
	cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + cValTochar(_aEmail[_nLin,3]) + ' </Font></TD>'	//QTDE PRODUTO
	cMsg += '</TR>'	
Next

//DEPOIS DE IMPRIMIR OS ITENS, MONTA 3 LINHAS A MAIS COM OS TOTAIS:
//LINHA EM BRANCO SEPARADORA:
cMsg += '<TR BgColor=#FFFFFF>'
cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial"></Font></TD>'		//PEDIDO
cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial"></Font></TD>'		//OS
cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial"></Font></TD>'		//PRODUTO
cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial"></Font></TD>'		//DESCR.PRODUTO
cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial"></Font></TD>'		//QTDE PRODUTO
cMsg += '</TR>'

cMsg += '<TR BgColor=#B0E2FF>'
cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial"></Font></TD>'				//PEDIDO
cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial"></Font></TD>'				//OS
cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial"></Font></TD>'				//PRODUTO
cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">PESO TOTAL</Font></TD>'		//DESCR PRODUTO
cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + Transform(nPesVol , "@E 999,999,999.999") + '</Font></TD>'			//QTDE PRODUTO
cMsg += '</TR>'

cMsg += '<TR BgColor=#FFFFFF>'
cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial"></Font></TD>'				//PEDIDO
cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial"></Font></TD>'				//OS
cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial"></Font></TD>'				//PRODUTO
cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">CUBAGEM</Font></TD>'		//DESCR PRODUTO
cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">'+ Transform(_nCubTot , "@E 9,999.999") + '</Font></TD>'  			//CUBAGEM		
cMsg += '</TR>'

cMsg += '<TR BgColor=#B0E2FF>'
cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial"></Font></TD>'				//PEDIDO
cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial"></Font></TD>'				//OS
cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial"></Font></TD>'				//PRODUTO
cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">TOTAL DE VOLUMES</Font></TD>'		//DESCR PRODUTO
cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">'+ cValToChar(nQtVol) + '</Font></TD>'  		//CUBAGEM		
cMsg += '</TR>'


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Definicao do rodape do email                                                ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cMsg += '</Table>'
cMsg += '<P>'
cMsg += '<Table align="center">'
cMsg += '<tr>'
cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">('+cFuncSent+')</td>'
cMsg += '</tr>'
cMsg += '</Table>'
cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
cMsg += '</body>'
cMsg += '</html>'	

RETURN


