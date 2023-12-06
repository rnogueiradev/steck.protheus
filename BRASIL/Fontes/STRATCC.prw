#Include "Protheus.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ STSLDCC  บAutor  ณMicrosiga           บ Data ณ  08/10/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao auxiliar criada para auxiliar a contabiliza็ใo      บฑฑ
ฑฑบ          ณ retorna a conta contabil ou valor conforme parametros      บฑฑ
ฑฑบ          ณ cLP = Lan็amento Padrใo                                    บฑฑ
ฑฑบ          ณ cSeq = Sequencia de Lan็amento                             บฑฑ
ฑฑบ          ณ cTipo = "D" - Debito, "C" - Credito, "V" - Valor           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function STRATCC()

	Local cQuery	:= ""
	Local cAlias	:= "QRYXPTO"
	Local aCampos	:= {}
	Local cCampo	:= ""
	Local cLinha	:= "000"
	Local cDoc		:= U_STDocRat()
	Local nX		:= 0
	Local cQuebra	:= ""


	Ajusta()

	If !Pergunte("STRATCC",.T.)
		Return()
	EndIf

	If Empty(cDoc)
		cDoc := "000000"
	EndIf



	DbSelectArea("CT2")
	DbGoto(IIF(cEmpAnt="01",7500180,434184))

	DbSelectArea("SX3")
	DbSeek("CT2")
	While !Eof() .And. SX3->X3_ARQUIVO = "CT2"
		cCampo := SX3->X3_CAMPO
		If !AllTrim(cCampo)$"CT2_DEBITO|CT2_CREDIT|CT2_CCD|CT2_CCC|CT2_ITEMD|CT2_ITEMC|CT2_VALOR|CT2_DOC|CT2_SEQLAN|CT2_LINHA|CT2_DATA|CT2_USERGI|CT2_USERGA" .And. !(SX3->X3_CONTEXT == 'V')
			Aadd(aCampos, {cCampo,CT2->&cCampo})
		EndIf
		SX3->(DbSkip())
	End

	cQuery	:=	" SELECT RATEIO, CT2_CONTA, CT2_CC, ROUND(SUM(DEBITO-CREDITO),2) CT2_SALDO, CTQ_PERBAS, CTQ_PERCEN, CTQ_CTCPAR, CTQ_CCCPAR, CTQ_ITCPAR FROM ( "
	cQuery	+=	" SELECT CTQ_RATEIO RATEIO,CT2_DEBITO CT2_CONTA, CT2_CCD CT2_CC, SUM(CT2_VALOR) DEBITO, 0 CREDITO "
	cQuery	+=	" FROM "+RetSqlName("CT2")+" CT2 "
	cQuery	+=	" INNER JOIN (SELECT CTQ_RATEIO, CTQ_CCORI FROM "+RetSqlName("CTQ")+" CTQ WHERE CTQ_FILIAL = '"+xFilial("CTQ")+"' AND CTQ_RATEIO BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' AND CTQ.D_E_L_E_T_ = ' ' GROUP BY CTQ_RATEIO, CTQ_CCORI) CTQ ON  CTQ_CCORI = CT2_CCD "
	cQuery	+=	" WHERE "
	cQuery	+=	" CT2_FILIAL = '"+xFilial("CT2")+"' AND "
	cQuery	+=	" CT2_DATA BETWEEN '"+Dtos(mv_par05)+"' AND '"+Dtos(mv_par06)+"' AND "
	cQuery	+=	" CT2_DEBITO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' AND "
	cQuery	+=	" CT2_MOEDLC = '01' AND "
	cQuery	+=	" CT2_TPSALD = '1' AND "
	cQuery	+=	" CT2.D_E_L_E_T_ = ' ' "
	cQuery	+=	" GROUP BY CTQ_RATEIO, CT2_DEBITO, CT2_CCD "
	cQuery	+=	" UNION ALL "
	cQuery	+=	" SELECT CTQ_RATEIO,CT2_CREDIT CT2_CONTA, CT2_CCC CT2_CC, 0 DEBITO, SUM(CT2_VALOR) CREDITO "
	cQuery	+=	" FROM "+RetSqlName("CT2")+" CT2 "
	cQuery	+=	" INNER JOIN (SELECT CTQ_RATEIO, CTQ_CCORI FROM "+RetSqlName("CTQ")+" CTQ WHERE CTQ_FILIAL = '"+xFilial("CTQ")+"' AND CTQ_RATEIO BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' AND CTQ.D_E_L_E_T_ = ' ' GROUP BY CTQ_RATEIO, CTQ_CCORI) CTQ ON CTQ_CCORI = CT2_CCC "
	cQuery	+=	" WHERE "
	cQuery	+=	" CT2_FILIAL = '"+xFilial("CT2")+"' AND "
	cQuery	+=	" CT2_DATA BETWEEN '"+Dtos(mv_par05)+"' AND '"+Dtos(mv_par06)+"' AND "
	cQuery	+=	" CT2_CREDIT BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' AND "
	cQuery	+=	" CT2_MOEDLC = '01' AND "
	cQuery	+=	" CT2_TPSALD = '1' AND "
	cQuery	+=	" CT2.D_E_L_E_T_ = ' ' "
	cQuery	+=	" GROUP BY CTQ_RATEIO, CT2_CREDIT, CT2_CCC "
	cQuery	+=	" )XXX "
	cQuery	+=	" INNER JOIN "+RetSqlName("CTQ")+" CTQ ON CTQ_FILIAL = '"+xFilial("CTQ")+"' AND CTQ_RATEIO = RATEIO AND CTQ.D_E_L_E_T_ = ' ' "
	cQuery	+=	" GROUP BY RATEIO, CT2_CONTA, CT2_CC, CTQ_PERBAS, CTQ_PERCEN, CTQ_CTCPAR, CTQ_CCCPAR, CTQ_ITCPAR "
	cQuery	+=	" ORDER BY 1,2,3"

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Fecha Alias se estiver em Uso ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If !Empty(Select(cAlias))
		DbSelectArea(cAlias)
		(cAlias)->(dbCloseArea())
	Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta Area de Trabalho executando a Query ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAlias,.T.,.T.)

	TCSetField(cAlias,"CT2_SALDO","N",18,2)
	TCSetField(cAlias,"CTQ_PERBAS","N",18,2)
	TCSetField(cAlias,"CTQ_PERCEN","N",18,2)

	DbSelectArea(cAlias)
	(cAlias)->(dbGoTop())
	While (cAlias)->(!Eof())

		If cQuebra<>(cAlias)->RATEIO+(cAlias)->CT2_CONTA+(cAlias)->CT2_CC
			cQuebra := (cAlias)->RATEIO+(cAlias)->CT2_CONTA+(cAlias)->CT2_CC
			nSaldo := (cAlias)->CT2_SALDO
			nPerBase := (cAlias)->CTQ_PERBAS
			cDoc := SOMA1(cDoc)
			cLinha := "000"
		EndIf

		If IIf(nSaldo>0,nSaldo,Abs(nSaldo))> 0 .And. nPerBase > 0 .And. (cAlias)->CTQ_PERCEN > 0

			If (cAlias)->CTQ_PERCEN>=nPerBase
				nRateio := nSaldo
			Else
				nRateio := Round(nSaldo*((cAlias)->CTQ_PERCEN/nPerBase),2)
			EndIf

			If ABS(nRateio)>0


				cLinha := SOMA1(cLinha)
				Reclock("CT2",.T.)
				For nX := 1 To Len(aCampos)
					cCampo := aCampos[nX][1]
					CT2->&cCampo := aCampos[nX][2]
				Next nX

				If Substr(cNumEmp,01,02) == "11"

					CT2->CT2_LOTE  := "001000"
					CT2->CT2_MOEDLC := "01"
					CT2->CT2_TPSALD  := '1'
					CT2->CT2_HIST    := 'RATEIO CC INDIRETOS PARA CUSTOS-'
					CT2->CT2_HP      := "003"
					CT2->CT2_SBLOTE := "001"
					CT2->CT2_DC      := "3"
					CT2->CT2_DOC	:= cDoc
					CT2->CT2_DATA	:= dDataBase
					CT2->CT2_LINHA	:= cLinha
					CT2->CT2_DEBITO := IIF(nRateio>0,(cAlias)->CTQ_CTCPAR,(cAlias)->CT2_CONTA)
					CT2->CT2_CREDIT := IIF(nRateio<0,(cAlias)->CTQ_CTCPAR,(cAlias)->CT2_CONTA)
					CT2->CT2_CCD	:= IIF(nRateio>0,(cAlias)->CTQ_CCCPAR,(cAlias)->CT2_CC)
					CT2->CT2_CCC	:= IIF(nRateio<0,(cAlias)->CTQ_CCCPAR,(cAlias)->CT2_CC)
					CT2->CT2_ITEMD	:= IIF(nRateio>0,(cAlias)->CTQ_ITCPAR,"")
					CT2->CT2_ITEMC	:= IIF(nRateio<0,(cAlias)->CTQ_ITCPAR,"")
					CT2->CT2_VALOR	:= IIf(nRateio >0,nRateio ,ABS(nRateio))
					CT2->CT2_ORIGEM	:= "STRATCC"+(cAlias)->RATEIO
					CT2->CT2_SEQLAN := cLinha


				else

					CT2->CT2_DOC	:= cDoc
					CT2->CT2_DATA	:= dDataBase
					CT2->CT2_LINHA	:= cLinha
					CT2->CT2_DEBITO := IIF(nRateio>0,(cAlias)->CTQ_CTCPAR,(cAlias)->CT2_CONTA)
					CT2->CT2_CREDIT := IIF(nRateio<0,(cAlias)->CTQ_CTCPAR,(cAlias)->CT2_CONTA)
					CT2->CT2_CCD	:= IIF(nRateio>0,(cAlias)->CTQ_CCCPAR,(cAlias)->CT2_CC)
					CT2->CT2_CCC	:= IIF(nRateio<0,(cAlias)->CTQ_CCCPAR,(cAlias)->CT2_CC)
					CT2->CT2_ITEMD	:= IIF(nRateio>0,(cAlias)->CTQ_ITCPAR,"")
					CT2->CT2_ITEMC	:= IIF(nRateio<0,(cAlias)->CTQ_ITCPAR,"")
					CT2->CT2_VALOR	:= IIf(nRateio >0,nRateio ,ABS(nRateio))
					CT2->CT2_ORIGEM	:= "STRATCC"+(cAlias)->RATEIO
					CT2->CT2_SEQLAN := cLinha

				Endif


				MsUnlock()

				nSaldo -= nRateio
				nPerBase -= (cAlias)->CTQ_PERCEN

			EndIf
		EndIf
		(cAlias)->(dbSkip())
	EndDo

	If !Empty(Select(cAlias))
		DbSelectArea(cAlias)
		(cAlias)->(dbCloseArea())
	Endif
//
	MsgInfo("Processo Finalizado!")

Return

User Function STDocRat()

	Local cRet := "000000"
	Local cQuery	:= ""
	Local cAlias	:= "QRYXPTO2"

	cQuery	:=	" SELECT MAX(CT2_DOC) CT2_DOC "
	cQuery	+=	" FROM "+RetSqlName("CT2")+" CT2 "
	cQuery	+=	" WHERE "
	cQuery	+=	" CT2_FILIAL = '"+xFilial("CT2")+"' AND "
	cQuery	+=	" CT2_DATA = '"+Dtos(dDataBase)+"' AND "
	cQuery	+=	" CT2_LOTE = '001000' AND "
	cQuery	+=	" CT2_MOEDLC = '01' AND "
	cQuery	+=	" CT2_TPSALD = '1' AND "
	cQuery	+=	" CT2.D_E_L_E_T_ = ' ' "

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Fecha Alias se estiver em Uso ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If !Empty(Select(cAlias))
		DbSelectArea(cAlias)
		(cAlias)->(dbCloseArea())
	Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta Area de Trabalho executando a Query ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAlias,.T.,.T.)

	DbSelectArea(cAlias)
	(cAlias)->(dbGoTop())
	If (cAlias)->(!Eof())
		If !Empty((cAlias)->CT2_DOC)
			cRet := (cAlias)->CT2_DOC
		EndIf
	EndIf

Return(cRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAjusta    บAutor  ณMicrosiga           บ Data ณ  03/30/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Insere novas perguntas na tabela SX1 a Ajusta o Picture    บฑฑ
ฑฑบ          ณ dos valores no SX3                                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Ajusta()

	Local aPergs 	:= {}

	Aadd(aPergs,{"Rateio de ?                  ","Rateio de ?                  ","Rateio de ?                  ","mv_ch1","C",06,0,0,"G",""                   ,"mv_par01","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","CTQ","S","",""})
	Aadd(aPergs,{"Rateio ate ?                 ","Rateio ate ?                 ","Rateio ate ?                 ","mv_ch2","C",06,0,0,"G",""                   ,"mv_par02","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","CTQ","S","",""})
	Aadd(aPergs,{"Conta de ?                   ","Conta de ?                   ","Conta de ?                   ","mv_ch3","C",20,0,0,"G",""                   ,"mv_par03","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","CT1","S","",""})
	Aadd(aPergs,{"Conta ate ?                  ","Conta ate ?                  ","Conta ate ?                  ","mv_ch4","C",20,0,0,"G",""                   ,"mv_par04","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","CT1","S","",""})
	Aadd(aPergs,{"Data de?                     ","Data de?                     ","Data de?                     ","mv_ch5","D",08,0,0,"G",""                   ,"mv_par05","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","","S","",""})
	Aadd(aPergs,{"Data ate ?                   ","Data ate ?                   ","Data ate ?                   ","mv_ch6","D",08,0,0,"G",""                   ,"mv_par06","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","","S","",""})

/*
cQuery	+=	" CTQ_RATEIO BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' AND "
cQuery	+=	" CT2_CREDIT BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' AND "
cQuery	+=	" CT2_DATA BETWEEN '"+Dtos(mv_par05)+"' AND '"+Dtos(mv_par06)+"' AND "
*/

//AjustaSx1("STRATCC",aPergs)

Return
