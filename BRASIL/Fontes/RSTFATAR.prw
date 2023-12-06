#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  RSTFATAR     ºAutor  ³Giovani Zago    º Data ³  26/07/16     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio Metas	P/ Vendedor  	                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±EXPORTXM±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RSTFATAR()
	
	Local   oReport
	Private cPerg 			:= "RFATAR"
	Private cTime           := Time()
	Private cHora           := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private lXlsHeader      := .f.
	Private lXmlEndRow      := .f.
	Private cPergTit 		:= cAliasLif
	Private _aErro			:= {}
	
	PutSx1(cPerg, "01", "Filial de:" 	,"Produto de:" 	 ,"Produto de:" 		,"mv_ch1","C",02,0,0,"G","",' ' ,"","","mv_par01","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "02", "Filial Ate:"	,"Produto Ate:"  ,"Produto Ate:"		,"mv_ch2","C",02,0,0,"G","",' ' ,"","","mv_par02","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "03", "CGC de:" 	,"Produto de:" 	 ,"Produto de:" 			,"mv_ch3","C",14,0,0,"G","",' ' ,"","","mv_par03","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "04", "CGC Ate:"	,"Produto Ate:"  ,"Produto Ate:"			,"mv_ch4","C",14,0,0,"G","",' ' ,"","","mv_par04","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "05", "Da Data:" 		,"Da Data: ?" 		,"Da Data: ?" 		,"mv_ch5","D",8,0,0,"G","",''    ,"","","mv_par05","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "06", "Ate Data:" 	,"Ate Data: ?" 		,"Ate Data: ?" 		,"mv_ch6","D",8,0,0,"G","",''    ,"","","mv_par06","","","","","","","","","","","","","","","","")
	
	
	oReport		:= ReportDef()

	oReport:PrintDialog()
	
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ReportDef    ºAutor  ³Giovani Zago    º Data ³  04/07/15     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio MMG 							                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*-----------------------------*
Static Function ReportDef()
	*-----------------------------*
	Local oReport
	Local oSection
	
	oReport := TReport():New(cPergTit,"RELATÓRIO Nf-e de Inconsistencia",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório Nf-e de Inconsistencia")
	
	Pergunte(cPerg,.F.)
	
	oSection := TRSection():New(oReport,"Nf-e de Inconsistencia",{"SZ9"})
	
	
	TRCell():New(oSection,"01",,"FILIAL"	,,02,.F.,)
	TRCell():New(oSection,"02",,"CHAVE NF-e"			,,40,.F.,)
	TRCell():New(oSection,"03",,"FORNECEDOR" 			,,30,.F.,)
	TRCell():New(oSection,"04",,"DATA NF-e"		,,08,.F.,)
	TRCell():New(oSection,"05",,"MOTIVO"		,,20,.F.,)
	TRCell():New(oSection,"06",,"CONTEUDO"		,,20,.F.,)
	TRCell():New(oSection,"07",,"OBS."		,,50,.F.,)
	
	
	oSection:SetHeaderSection(.t.)
	oSection:Setnofilter("SZ9")
	
Return oReport
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ReportPrint  ºAutor  ³Giovani Zago    º Data ³  04/07/15     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio MMG 							                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*------------------------------------*
Static Function ReportPrint(oReport)
	*------------------------------------*
	Local oSection	:= oReport:Section(1)
	Local oSection1	:= oReport:Section(1)
	Local nX		:= 0
	Local aDados[2]
	Local aDados1[99]
	Local i		:= 0
	
	oSection1:Cell("01") :SetBlock( { || aDados1[01] } )
	oSection1:Cell("02") :SetBlock( { || aDados1[02] } )
	oSection1:Cell("03") :SetBlock( { || aDados1[03] } )
	oSection1:Cell("04") :SetBlock( { || aDados1[04] } )
	oSection1:Cell("05") :SetBlock( { || aDados1[05] } )
	oSection1:Cell("06") :SetBlock( { || aDados1[06] } )
	oSection1:Cell("07") :SetBlock( { || aDados1[07] } )
	
	
	oReport:SetTitle("Nf-e de Inconsistencia")// Titulo do relatório
	
	oReport:SetMeter(0)
	aFill(aDados,nil)
	aFill(aDados1,nil)
	oSection:Init()
	
	
	Processa({|| StQuery(  ) },"Compondo Relatorio")
	

		//Z9_OBS    
		oSection1:PrintLine()
		aFill(aDados1,nil)
	For i:=1 To Len(_aErro)
		aDados1[01]	:=  _aErro[i,1]
		aDados1[02]	:=  _aErro[i,2]
		aDados1[03]	:=  _aErro[i,3]
		aDados1[04]	:=  _aErro[i,4]
		aDados1[05]	:=  _aErro[i,5]
		aDados1[06]	:=  _aErro[i,6]
		aDados1[07]	:=  _aErro[i,7]
		
		//Z9_OBS    
		oSection1:PrintLine()
		aFill(aDados1,nil)
	Next i
	
	
	oReport:SkipLine()
Return oReport


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  StQuery      ºAutor  ³Giovani Zago    º Data ³  04/07/15     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio MMG 							                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*-----------------------------*
Static Function StQuery(_ccod)
	*-----------------------------*
	
	DbSelectArea("SZ9")
	SZ9->(DbGoTop())
	SZ9->(DbSetOrder(3)) 
	
	While !(SZ9->(Eof()))
		_cXml:= Alltrim(SZ9->Z9_XML)
		If MV_PAR01 <= SZ9->Z9_FILIAL .And. MV_PAR02 >= SZ9->Z9_FILIAL .And. MV_PAR03 <= Alltrim(SZ9->Z9_CHAVE) .And. MV_PAR04 >= Alltrim(SZ9->Z9_CHAVE) ;
				.And. MV_PAR05 <= SZ9->Z9_DTEMIS .And. MV_PAR06 >= SZ9->Z9_DTEMIS
			If   !("STECK" $ SZ9->Z9_NOMFOR) .And. !(Empty(Alltrim(SZ9->Z9_CHAVE)))
				
				If  (AllTrim(UPPER(SZ9->Z9_STATUSA))=="CIENCIA" .OR. AllTrim(UPPER(SZ9->Z9_STATUSA))=="CIÊNCIA")
					
					cAviso := ""
					cErro  := ""
					_cXml  := ""
					_cXml:= Alltrim(SZ9->Z9_XML)
					_cXml:= FwCutOff(_cXml, .t.)
					oNfe := XmlParser(_cXml,"_",@cAviso,@cErro)
					
					If VALType(oNFe) <> "U"
						If valtype(oNFe:_NfeProc) = 'O'
							oNF := oNFe:_NFeProc:_NFe
							If !(oNFe == NIL )
								VALIDXML(oNFe,oNF)
							EndIf
						Else
							If valtype(oNFe:_NFe)= 'O'
								oNF := oNFe:_NFe
								If !(oNF == NIL )
									VALIDXML(oNFe,oNF)
								EndIf
								
								
							Endif
						Endif
						
					Endif
					
					
				EndIf
			Endif
		Endif
		SZ9->(DbSkip())
		
	EndDo
	
Return()





Static Function VALIDXML(oNfe,oNF)
	
	
	Local _cTiponf  := ''
	Local _cNorm	:= getmv("ST_CFNORM",,"1949/2949/5101/5102/5405/5911/5949/6101/6949/5909/6102/6933")
	Local _cDev 	:= getmv("ST_CFDEV" ,,"1201/1202/2202/2411/5201/5202/5411/5556/5916/6202/6411/6556")
	Local _cBene	:= getmv("ST_CFBENE",,"1901/5124/5902")
	Local lAchou  	:= .f.
	Local nX		:= 0
	//AAdd(_aErro,{"FILIAL","CHAVE NF-e","FORNECEDOR","DATA NF-e","MOTIVO","CONTEUDO"})
	
	//VERIFICA SE O XML É VALIDO
	//oNF := oNFe
	oNFChv := oNFe:_NFeProc:_protNFe
	
	oEmitente  := oNF:_InfNfe:_Emit
	oIdent     := oNF:_InfNfe:_IDE
	oDestino   := oNF:_InfNfe:_Dest
	oTotal     := oNF:_InfNfe:_Total
	oTransp    := oNF:_InfNfe:_Transp
	oDet       := oNF:_InfNfe:_Det
	cChvNfe    := oNFChv:_INFPROT:_CHNFE:TEXT
	cTpNf	   := oNf:_INFNFE:_IDE:_TPNF:TEXT
	
	oDet := IIf(ValType(oDet)=="O",{oDet},oDet)
	cCgc := AllTrim(IIf(Type("oEmitente:_CPF")=="U",ALLTRIM(AJUSTSTR(oEmitente:_CNPJ:TEXT))	,ALLTRIM(AJUSTSTR(oEmitente:_CPF:TEXT))))
	cIe  := AllTrim(IIf(Type("oEmitente:_CPF")=="U",ALLTRIM(AJUSTSTR(oEmitente:_IE:TEXT))	,ALLTRIM(AJUSTSTR(oEmitente:_CPF:TEXT))))
	cCfop  := ALLTRIM(oDet[1]:_PROD:_CFOP:TEXT)
	//Conout(cCfop+" - "+cChvNfe)
	If cTpNf <> '1'
		//AAdd(_aErro,{SZ9->Z9_FILIAL,SZ9->Z9_CHAVE,SZ9->Z9_NOMFOR,DTOC(SZ9->Z9_DTEMIS),"NF ENTRADA",cCgc})
	Else
		
		If cCfop $ _cNorm
			_cTiponf  := 'N'
		ElseIf cCfop $ _cDev
			_cTiponf  := 'D'
		ElseIf cCfop $ _cBene
			_cTiponf  := 'B'
		EndIf
		
	EndIf
	
	
	
	
	If 	_cTiponf  = 'N' // Nota Normal Fornecedor
		dbselectarea("SA2")
		//dbSetOrder(3)
		SA2->(DbOrderNickName("CGCINSCR2"))
		SA2->(dbSeek(xFilial("SA2")+cCgc+cIe))
		do while !lAchou .and. !eof() .and. (xFilial("SA2") = SA2->A2_FILIAL) .AND. (TRIM(SA2->A2_CGC) == cCgc) .AND. (TRIM(SA2->A2_INSCR) == cIe)
			IF FieldPos("A2_MSBLQL") > 0
				IF !(SA2->A2_MSBLQL == "1")
					lAchou := .t.
					EXIT
				endif
			else
				lAchou := .t.
				EXIT
			endif
			dbselectarea('SA2')
			dbskip()
		enddo
	Else
		dbselectarea("SA1")
		//dbSetOrder(3)
		SA1->(DbOrderNickName("CGCINSCR1"))
		SA1->(dbSeek(xFilial("SA1")+cCgc+cIe))
		do while !lAchou .and. !eof() .and. (xFilial("SA1") = SA1->A1_FILIAL) .AND. (TRIM(SA1->A1_CGC) == cCgc) .AND. (TRIM(SA1->A1_INSCR) == cIe)
			IF FieldPos("A1_MSBLQL") > 0
				IF !(SA1->A1_MSBLQL == "1")
					lAchou := .t.
					EXIT
				endif
			else
				lAchou := .t.
				EXIT
			endif
			dbselectarea('SA1')
			dbskip()
		enddo
	Endif
	If !lAchou
		AAdd(_aErro,{SZ9->Z9_FILIAL,SZ9->Z9_CHAVE,SZ9->Z9_NOMFOR,DTOC(SZ9->Z9_DTEMIS),"CNPJ/IE NÃO LOCALIZADO",cCgc+" / "+cIe,SZ9->Z9_OBS})
	Endif
	
	
	If 	_cTiponf  = 'N'
		cProds := ''
		aPedIte:= {}
		
		For nX := 1 To Len(oDet)
			
			cProduto:=PadR(AllTrim(oDet[nX]:_Prod:_cProd:TEXT),TamSx3("A5_CODPRF")[1])
			xProduto:=cProduto
			
			oAux := oDet[nX]
			cNCM :=IIF(Type("oAux:_Prod:_NCM")=="U",space(12),oAux:_Prod:_NCM:TEXT)
			
			DbSelectArea("SA5")
			SA5->(DbOrderNickName("FORPROD"))   // FILIAL + FORNECEDOR + LOJA + CODIGO PRODUTO NO FORNECEDOR
			If !SA5->(dbSeek(xFilial("SA5")+SA2->A2_COD+SA2->A2_LOJA+cProduto))
				
				AAdd(_aErro,{SZ9->Z9_FILIAL,SZ9->Z9_CHAVE,SZ9->Z9_NOMFOR,DTOC(SZ9->Z9_DTEMIS),"PRODUTO SEM AMARRAÇÃO",cProduto,SZ9->Z9_OBS})
				
			EndIf
		Next nX
	Endif
	
	
	
	
	/*
	?	NF. com pedido não liberado ( disponível para recebimento);
		?	NF. sem pedido;
		?	NF. com divergência de Valor  em relação ao pedido;
		?	NF. com divergência de quantidade em relação ao pedido;
		?	NF.com Unidade de medida do produto diferente;
		?	Item não localizado nos pedidos;
		?	Divergência nos impostos;
		*/
Return




Static Function AJUSTSTR(cStr)
	
	Local nY		:= 0
	Local cNewStr	:= ""
	
	For nY:=1 To Len(cStr)
		
		If asc(substr(cStr,nY,1))<>10
			cNewStr		+= substr(cStr,nY,1)
		EndIf
		
	Next
	
Return(cNewStr)



