#Include "Rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³F050MDVC  ºAutor  ³Cristiano Pereira   º Data ³  11/27/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Recalcular os vencimentos do PCC de acordo lei 13.1137/15   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Steck                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function F050MDVC()

Local _dVencPCC := Ctod(Space(8))

If PARAMIXB[2]$("PIS/COFINS/CSLL")
	_dVencPCC :=xVencImp(PARAMIXB[2],ParamIxb[2],ParamIxb[2],ParamIxb[5])
Else                                             
	_dVencPCC :=  PARAMIXB[1]
Endif

return(_dVencPCC)


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³F050VImp  ³ Autor ³ Cristiano Pereira   ³ Data ³ 11/12/03 		³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Calcula a data de vencimento de titulos de impostos IR, PIS		³±±
³          ³ COFINS, CSLL                                     		         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ F050VImp(cImposto,dEmissao,dEmis1,dVencRea,cRetencao,cTipoFor,;³±±
±±³			 ³			   lIRPFBaixa)                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FINA050																	  		³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function xVencImp(cImposto,dEmissao,dEmis1,dVencRea,cRetencao,cTipoFor,lIRPFBaixa) // Calcula o vencimento do imposto
     
/*
Default cRetencao 	:= ""
Default cTipoFor  	:= "J"
Default cImposto	:= ""
Default dEmissao 	:= dDataBase
Default dEmis1		:= dDatabase
Default dVencRea	:= dDatabase
Default lIRPFBaixa := .F.
*/

Local nK			:= 0
Local dNextDay 		:= Ctod("//")
Local nTamData 		:= 0
Local nNextMes 		:= 0
Local dDtQuinz 		:= Ctod("//")

Local lLei11196 	:= SuperGetMv("MV_VC11196",.T.,"2") == "1"
Local lMP447    	:= SuperGetMV("MV_MP447",.T.,.F.)
Local nIn480		:= SuperGetMV("MV_IN480",.T.,3)
Local cVencIRPF 	:= GetMv("MV_VCTIRPF",,"")

Local lAntMP351 	:= .F.
Local lVenctoIN  	:= (SuperGetMv("MV_VENCINS",.T.,"1") == "2")  //1 = Emissao    2= Vencimento Real

Local lVerIRBaixa	:= .F.
Local lEmpPublic	:= SuperGetMv("MV_ISPPUBL" ,.T.,"2") == "1"
Local _lINQuinz     := SuperGetMv("MV_IN4815" ,.T.,"Q")  == "Q" 



lVerIRBaixa := Iif(lIRPFBaixa .AND. cImposto == "IRRF",Iif(cTipoFor == "J",.T.,.F.),.T.) // Verifica se IRPJ na Baixa para calcular vencimento de acordo com a regra do PCC

If cImposto == "IRRF" .and. !(lEmpPublic .and. cTipoFor == "J" .AND. lIrpfBaixa)
	//Calculo o Vencimento do IR para Pessoa Fisica
	If cTipoFor == "F" .And. !Empty(cVencIRPF)
		If GetMv("MV_VCTIRPF") == "E"
			dNextDay := dEmissao+1
		Elseif GetMv("MV_VCTIRPF") == "C"
			dNextDay := dEmis1+1
		Else
			dNextDay := dVencRea+1
		EndIf
		//Calculo o Vencimento do IR para Pessoa Juridica
	Else
		If GetMv("MV_VENCIRF") == "E"
			dNextDay := dEmissao+1
		Elseif GetMv("MV_VENCIRF") == "C"
			dNextDay := dEmis1+1
		Else
			dNextDay := dVencRea+1
		EndIf
	EndIf
	
	//Fato gerador até 31/12/05
	If (!lLei11196 .or. (dNextDay-1) < CTOD("01/01/06")) .and. ;
		!lMP447 .And.;
		!(AllTrim(cRetencao) $ "8739|8767|6147|6175|6190|6188|9060|8850|5706") .AND. ;
		!Empty(cRetencao)
		
		For nK:=1 To 7
			If Dow( dNextDay ) = 1
				Exit
			End
			dNextDay++
		Next
		For nK:= 1 to 3
			dNextDay := DataValida(dNextDay+1,.T.)
		Next
		
	ElseIf AllTrim(cRetencao) $ "8739|8767|6147|6175|6190|6188|9060|8850"
		
		//Caso seja preenchido com outro valor diferente de 3(3o. dia util) ou 5 (5o. dia util),
		//atribui o valor default 3
		nIn480 := Iif(nIn480 <> 3 .And. nIn480 <> 5,3,nIn480)
		
		//se aplicar-se o paragrafo II do artigo 5º da IN480, o sistema deverá ir até o final da quinzena
		// para calcular a qtd de dias uteis da semana subsequente.
		If _lINQuinz
			dNextDay -= 1 // Retira 1 dia que foi somado
			nTamData := Iif(Len(Dtoc(dNextDay)) == 10, 7, 5)
			
			If Day(dNextDay) <= 15
				dNextDay := CTOD("16/"+Subs(Dtoc(dVencrea),4,nTamData))
			Else
				nNextMes := Month(dNextDay)+1
				dNextDay := CTOD("01/"+;  //dia
				Iif(nNextMes==13,"01",StrZero(nNextMes,2))+"/"+; //mes
				Substr(Str(Iif(nNextMes==13,Year(dNextDay)+1,Year(dNextDay))),2))    //ano
			EndIf
		EndIf
		
		For nK:=1 To 7
			If Dow( dNextDay ) = 1
				Exit
			End
			dNextDay++
		Next
		
		If _lINQuinz .and. nIn480 == 5   //ultimo dia útil da semana, se houver somente 4 dias úteis, nao pode cair na semana seguinte
			dNextDay := dNextDay + nIn480
			While DataValida(dNextDay,.T.) <> dNextDay
				dNextDay := dNextDay - 1
			EndDo
		Else
			For nK:= 1 to nIn480
				dNextDay := DataValida(dNextDay+1,.T.)
			Next
		EndIf
		
	ElseIf (AllTrim(cRetencao) $ "5706#9385#8053#3426")
		
		dNextDay -= 1 // Retira 1 dia que foi somado
		nNextMes := Month(dNextDay)+1
		
		If Day(dNextDay) >= 1 .And. Day(dNextDay) <= 10 // Primeiro decendio
			//Posiciono no 1o. dia util do decendio subsequente do fato gerador
			dNextDay := CTOD("11/"+StrZero(Month(dNextDay),2)+"/"+Str(Year(dNextDay)))
		ElseIf Day(dNextDay) >= 11 .And. Day(dNextDay) <= 20 // Segundo decendio
			//Posiciono no 1o. dia util do decendio subsequente do fato gerador
			dNextDay := CTOD("21/"+StrZero(Month(dNextDay),2)+"/"+Str(Year(dNextDay)))
		Else //Terceiro decendio
			//Posiciono no 1o. dia util do decendio subsequente do fato gerador
			dNextDay := CTOD("01/"+If(nNextMes==13,"01",StrZero(nNextMes,2))+"/"+;
			Str(If(nNextMes==13,Year(dNextDay)+1,Year(dNextDay))))
		EndIf
		
		nI := 1
		While nI <= 3
			If DataValida(dNextday,.T.) == dNextDay
				If nI < 3
					dNextDay += 1
				EndIf
				nI +=1
			Else
				dNextDay += 1
			Endif
		EndDo
		
	ElseIf AllTrim(cRetencao) $ SuperGetMv("MV_VENCCRC",,"") //Empresas CRC
		//Calculo da data de vencimento do imposto a partir de 26/07/04 - Lei 10925
		nTamData := Iif(Len(Dtoc(dVencrea)) == 10, 7, 5)
		
		//Calculo com base na Lei 11196 art. 74
		If Day(dVencRea) <= 15
			dNextDay := Ctod(Str(Day(LastDay(dVencRea)),2)+"/"+Subs(Dtoc(dVencrea),4,nTamData))
		Else
			nNextMes := Month(dVencRea)+1
			dNextDay := CTOD("15/"+Iif(nNextMes==13,"01",StrZero(nNextMes,2))+"/"+;
			Substr(Str(Iif(nNextMes==13,Year(dVencRea)+1,Year(dVencRea))),2))
		Endif
		
		//Acho o ultimo dia util da semana subsequente
		While .T.
			If DataValida(dNextday,.T.) == dNextDay
				Exit
			Else
				dNextDay -= 1
			Endif
		Enddo
		//DEZEMBRO/2006
	ElseIf (dNextDay-1) >= CTOD("01/12/06") .And. (dNextDay-1) <= CTOD("31/12/06")
		//No mes de dezembro de 2006, os recolhimentos serao efetuados, de acordo com a lei 11.196,05 art.70:
		//a) Ate o terceiro dia util do decendio subsequente, para os fatos geradores ocorridos no primeiro e segundo decendios;
		//b) Ate o ultimo dia util do primeiro decendio do mes de janeiro de 2007, para os fatos geradores ocorridos no terceiro decendio.
		//OBS: Datas abaixo definidas pela agenda IOB para ocorrencias no primeiro e segundo decendio
		If (dNextDay-1) >= CTOD("01/12/06") .And. (dNextDay-1) <= CTOD("10/12/06") // Primeiro decendio
			//Acho o terceiro dia util subsequente ao decendio de ocorrência do fato gerador
			dNextDay := CTOD("11/12/06")  //primeiro dia do decendio subsequente
			nI := 1
			While nI <= 3
				If DataValida(dNextday,.T.) == dNextDay
					If nI < 3
						dNextDay += 1
					EndIf
					nI +=1
				Else
					dNextDay += 1
				Endif
			EndDo
		ElseIf (dNextDay-1) >= CTOD("11/12/06") .And. (dNextDay-1) <= CTOD("20/12/06") // Segundo decendio
			dNextDay := CTOD("21/12/06")  //primeiro dia do decendio subsequente
			nI := 1
			While nI <= 3
				If DataValida(dNextday,.T.) == dNextDay
					If nI < 3
						dNextDay += 1
					EndIf
					nI +=1
				Else
					dNextDay += 1
				Endif
			EndDo
		Else
			dNextDay -= 1 // Retira 1 dia que foi somado acima
			nNextMes := Month(dNextDay) + 1
			//Monto a data para decimo dia do mes subsequente
			dNextDay := CTOD("10/"+Iif(nNextMes==13,"01",StrZero(nNextMes,2))+"/"+	Substr(Str(Iif(nNextMes==13,Year(dNextDay)+1,Year(dNextday))),2))
			//Acho o ultimo dia util do primeiro decenio do mes subsequente
			While .T.
				If DataValida(dNextday,.T.) == dNextDay
					Exit
				Else
					dNextDay -= 1
				Endif
			Enddo
		EndIf
		//DEZEMBRO/2007
	ElseIf (dNextDay-1) >= CTOD("01/12/07") .And. (dNextDay-1) <= CTOD("31/12/07")
		//No mes de dezembro de 2007, os recolhimentos serao efetuados, de acordo com a lei 11.196,05 art.70:
		//a) Ate o terceiro dia util do segundo decendio, para os fatos geradores ocorridos no primeiro decendio;
		//b) Ate o ultimo dia util do primeiro decendio do mes de janeiro de 2008, para os fatos geradores ocorridos no segundo e no terceiro decendio.
		If (dNextDay-1) >= CTOD("01/12/07") .And. (dNextDay-1) <= CTOD("10/12/07")
			//Acho o terceiro dia util subsequente ao decendio de ocorrência do fato gerador
			dNextDay := CTOD("11/12/07")  //primeiro dia do decendio subsequente
			nI := 1
			While nI <= 3
				If DataValida(dNextday,.T.) == dNextDay
					If nI < 3
						dNextDay += 1
					EndIf
					nI +=1
				Else
					dNextDay += 1
				Endif
			EndDo
		Else
			dNextDay -= 1 // Retira 1 dia que foi somado acima
			nNextMes := Month(dNextDay) + 1
			//Monto a data para decimo dia do mes subsequente
			dNextDay := CTOD("10/"+Iif(nNextMes==13,"01",StrZero(nNextMes,2))+"/"+	Substr(Str(Iif(nNextMes==13,Year(dNextDay)+1,Year(dNextday))),2))
			//Acho o ultimo dia util do primeiro decenio do mes subsequente
			While .T.
				If DataValida(dNextday,.T.) == dNextDay
					Exit
				Else
					dNextDay -= 1
				Endif
			Enddo
		EndIf
		//Media Provisória 447/2008
	ElseIf lMP447 .and. (dNextDay-1) >= CTOD("01/11/08")
		dNextDay -= 1 // Retira 1 dia que foi somado para o calculo anterior.
		//Medida Provisória 447/2008 - Vencimento do IRRF passa a ser no ultimo dia util do segundo decendio
		//do mes subsequente para fatos geradores a partir de 01/11/08
		nNextMes := Month(dNextDay) + 1
		//Monto a data para vigésimo dia do mes subsequente
		dNextDay := CTOD("20/"+Iif(nNextMes==13,"01",StrZero(nNextMes,2))+"/"+ Substr(Str(Iif(nNextMes==13,Year(dNextDay)+1,Year(dNextday))),2))
		//Localiza o ultimo dia util do segundo decenio do mes subsequente
		While .T.
			If DataValida(dNextday,.T.) == dNextDay
				Exit
			Else
				dNextDay -= 1
			Endif
		Enddo
	Else
		dNextDay -= 1 // Retira 1 dia que foi somado para o calculo anterior.
		//Lei 11.196 - Vencimento do IRRF passa a ser no ultimo dia util do primeiro decenio do mes seguinte
		//para fatos geradores a partir de 01/01/06
		nNextMes := Month(dNextDay) + 1
		//Monto a data para decimo dia do mes subsequente
		dNextDay := CTOD("10/"+Iif(nNextMes==13,"01",StrZero(nNextMes,2))+"/"+	Substr(Str(Iif(nNextMes==13,Year(dNextDay)+1,Year(dNextday))),2))
		//Acho o ultimo dia util do primeiro decenio do mes subsequente
		While .T.
			If DataValida(dNextday,.T.) == dNextDay
				Exit
			Else
				dNextDay -= 1
			Endif
		Enddo
	Endif
ElseIf cImposto == "FETHAB"
	nDiaVenc := SuperGetMv("MV_VENCFET",.F.,5)
	nAno := Year(dEmissao)
	
	nMes     := Month(dEmissao)+1
	If nMes > 12
		nMes := 1
		nAno := Year(dEmissao)+1
	Endif
	
	dData    := CtoD(StrZero(nDiaVenc,2)+"/"+StrZero(nMes,2)+"/"+StrZero(nAno,4))
	
	If Empty(dData)
		While Empty(dData)
			dData    := CtoD(StrZero(nDiaVenc,2)+"/"+StrZero(nMes,2)+"/"+StrZero(nAno,4))
			nDiaVenc--
		EndDo
	Endif
	
	dNextDay := DataValida(dData,.T.)
	
ElseIf cImposto == "CIDE"
	
	If Day(dVencRea) <= 15
		dNextDay := Ctod(StrZero(Day(LastDay(dVencRea)),2)+"/"+StrZero(Month(dVencrea),2)+"/"+StrZero(Year(dVencrea),4))
	Else
		nNextMes := Month(dVencRea)+1
		dNextDay := CTOD("15/"+Iif(nNextMes==13,"01",StrZero(nNextMes,2))+"/"+;
		Substr(Str(Iif(nNextMes==13,Year(dVencRea)+1,Year(dVencRea))),2))
	Endif
	
	dNextDay	:=	DataValida(dNextday,.F.)
	
	
ElseIf cImposto == "INSS"
	
	//Calculo do Vencto do INSS
	//Por intermedio da Medida Provisoria 351/2007, publicada no DOU 1 de 22.01.2007 (Edicao Extra),
	//foi alterada a data de recolhimento das contribuicoes previdenciarias a cargo da empresa,
	//inclusive as contribuicoes referentes à remuneracao dos empregados, trabalhadores avulsos e a
	//prestacao de servicos do contribuinte individual para o dia 10 do mes seguinte ao da competencia
	//a que se refere.
	If lVenctoIN
		dNextMes := Month(dVencRea)+1
		If dVencRea < CTOD("22/01/07")  //Anterior a MP351
			lAntMP351 := .T.
			dNextVen := CTOD("02/"+IIF(dNextMes==13,"01",StrZero(dNextMes,2))+"/"+;
			Substr(Str(IIF(dNextMes==13,Year(dVencRea)+1,Year(dVencrea))),2))
		Else
			If lMP447 .and. dVencRea > CTOD("01/11/08")
				//Medida Provisória 447/2008 - Vencimento do INSS passa a ser ate o dia 20
				//do mes subsequente ao da competencia.
				//Vencimento para PJ = 20 e PF = 15 (somente para funrural)
				If cTipoFor == "F" .AND. isFunrural()
					dNextVen := CtoD("15/"+IIf(dNextMes==13,"01",StrZero(dNextMes,2))+"/"+;
					Substr(Str(IIF(dNextMes==13,Year(dVencRea)+1,Year(dVencRea))),2))
				Else
					lAntMP351 := .F.
					dNextVen := CTOD("20/"+IIF(dNextMes==13,"01",StrZero(dNextMes,2))+"/"+;
					Substr(Str(IIF(dNextMes==13,Year(dVencrea)+1,Year(dVencrea))),2))
				Endif
			Else
				lAntMP351 := .F.
				dNextVen := CTOD("10/"+IIF(dNextMes==13,"01",StrZero(dNextMes,2))+"/"+;
				Substr(Str(IIF(dNextMes==13,Year(dVencrea)+1,Year(dVencrea))),2))
			Endif
		Endif
	Else
		dNextMes := Month(dEmissao)+1
		If dEmissao < CTOD("22/01/07")  //Anterior a MP351
			lAntMP351 := .T.
			dNextVen := CTOD("02/"+IIF(dNextMes==13,"01",StrZero(dNextMes,2))+"/"+;
			Substr(Str(IIF(dNextMes==13,Year(dEmissao)+1,Year(dEmissao))),2))
		Else
			If lMP447 .and. dEmissao > CTOD("01/11/08")
				//Medida Provisória 447/2008 - Vencimento do INSS passa a ser ate o dia 20
				//do mes subsequente ao da competencia.
				//Vencimento para PJ = 20 e PF = 15 (somente para funrural)
				If cTipoFor == "F" .AND. isFunrural()
					dNextVen := CtoD("15/"+IIf(dNextMes==13,"01",StrZero(dNextMes,2))+"/"+;
					Substr(Str(IIF(dNextMes==13,Year(dEmissao)+1,Year(dEmissao))),2))
				Else
					lAntMP351 := .F.
					dNextVen := CTOD("20/"+IIF(dNextMes==13,"01",StrZero(dNextMes,2))+"/"+;
					Substr(Str(IIF(dNextMes==13,Year(dEmissao)+1,Year(dEmissao))),2))
				Endif
			Else
				lAntMP351 := .F.
				dNextVen := CTOD("10/"+IIF(dNextMes==13,"01",StrZero(dNextMes,2))+"/"+;
				Substr(Str(IIF(dNextMes==13,Year(dEmissao)+1,Year(dEmissao))),2))
			Endif
		Endif
	Endif
	
	If lMP447
		
		// Caso seja pessoa física e FUNRURAL a data de vencimento será prorrogada
		If cTipoFor == "F" .AND. isFunrural()
			
			While .T.
				If DataValida(dNextVen,.T.) == dNextVen
					dNextDay := dNextVen
					Exit
				Else
					dNextVen += 1
				Endif
			Enddo
			
		Else
			//Caso o dia do vencimento não for util, será considerado antecipado o prazo para o primeiro
			//dia util que o anteceder.
			While .T.
				If DataValida(dNextVen,.T.) == dNextVen
					dNextDay := dNextVen
					Exit
				Else
					dNextVen -= 1
				Endif
			Enddo
		Endif
	Else
		dNextDay := DataValida(dNextVen,.T.)
	Endif
	
ElseIf !Empty(cImposto)
	//Calculo da data de vencimento para titulos de PIS, COFINS e CSLL
	//Para o IR na Baixa, segue o mesmo conceito do PCC para o calculo.
	
	//Verifico se a baixa ou vencimento sao anteriores a Lei 10925 e
	//fato o calculo da data na forma antiga
	If dVencrea < SuperGetMv("MV_RF10925",.t.,CTOD("26/07/04"))
		dNextDay := dVencRea+1
		For nK:=1 To 7
			If Dow( dNextDay ) = 1
				Exit
			Endif
			dNextDay++
		Next
		For nK:= 1 to 3
			dNextDay := DataValida(dNextDay+1,.T.)
		Next
	Else
		
		//Calculo da data de vencimento do imposto a partir de 26/07/04 - Lei 10925
		nTamData := Iif(Len(Dtoc(dVencrea)) == 10, 7, 5)
		
		//Lei 11.196 - Vencimento do PIS COFINS e CSLL passa a ser no ultimo dia util da quinzena subsequente
		//para fatos geradores a partir de 01/01/06
		//Art. 74 que altera o art.35 da Lei 10833
		//Alterada pela MP 351 de 21/01/07, art 7 e sequintes:
		// O pagamento da Contribuição para o PIS/PASEP e da COFINS deverá ser efetuado ate o ultimo dia util do
		// segundo decendio subsequente ao mes de ocorrencia dos fatos geradores."
		
		
		//Calculo antigo para fatos geradores anteriores a vigencia da Lei ou para onde não se aplique
		If lVerIRBaixa .AND. (!lLei11196 .or. dVencRea < CTOD("01/01/06"))
			//Verifico a quizena do vencimento
			//If Day(dVencRea) <= 15
			//	dDtQuinz := Ctod("15/"+Subs(Dtoc(dVencrea),4,nTamData))
			//	If Dow(dDtQuinz) == 1   //Se o dia 15 for domingo
			//		dNextDay := Ctod("27/"+Subs(Dtoc(dVencrea),4,nTamData))
			//	Else
			//		dNextDay := Ctod("21/"+Subs(Dtoc(dVencrea),4,nTamData))
			//	Endif
			//Else
				nNextMes := Month(dVencRea)+1
				dDtQuinz := Ctod(Str(Day(LastDay(dVencRea)),2)+"/"+Subs(Dtoc(dVencrea),4,nTamData))
				If Dow(dDtQuinz) == 1   //Se o ultimo dia do mes for domingo
					dNextDay := CTOD("12/"+Iif(nNextMes==13,"01",StrZero(nNextMes,2))+"/"+;
					Substr(Str(Iif(nNextMes==13,Year(dVencRea)+1,Year(dVencRea))),2))
				Else
					dNextDay := CTOD("06/"+Iif(nNextMes==13,"01",StrZero(nNextMes,2))+"/"+;
					Substr(Str(Iif(nNextMes==13,Year(dVencRea)+1,Year(dVencRea))),2))
				Endif
			//Endif
			
			//Acho a Sexta feira da semana subsequente
			nDiaSemana := Dow(dNextDay)
			If nDiaSemana < 20
				//dNextDay += 6-nDiaSemana
				dNextDay := Ctod( "20"+"/"+SubStr(Dtos(dNextDay),5,2)+"/"+SubStr(Dtos(dNextDay),1,4))
			ElseIf nDiaSemana > 6
				dNextDay -= 1
			Endif
		ElseIf lLei11196
			
			//Calculo com base na Lei 11196 art. 74
			If Day(dVencRea) <= 15
				dNextDay := Ctod(Str(Day(LastDay(dVencRea)),2)+"/"+Subs(Dtoc(dVencrea),4,nTamData))
			Else
				nNextMes := Month(dVencRea)+1
				dNextDay := CTOD("15/"+Iif(nNextMes==13,"01",StrZero(nNextMes,2))+"/"+;
				Substr(Str(Iif(nNextMes==13,Year(dVencRea)+1,Year(dVencRea))),2))
			Endif
			
		Endif
		
		//Acho o ultimo dia util do periodo desejado
		dNextday := DataValida(dNextday,.F.)
	Endif
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de entrada para que o cliente possa calcular  ³
//³ a data de vencimento                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 



Return dNextDay
