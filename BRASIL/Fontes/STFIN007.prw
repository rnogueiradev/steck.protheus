#Include "Protheus.ch"
#Include "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ STFIN007  º Autor ³ Cristiano Pereiraº Data ³  30/03/13    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relação de notas fiscais de devoluções de acordo com o XML º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function STFIN007()

	Local oReport
	Local aArea	:= GetArea()



	If Pergunte("STFIN07",.T.)
		oReport 	:= ReportDef()
		oReport		:PrintDialog()
	EndIf

	RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ReportDef ºAutor  ³Microsiga           º Data ³  03/30/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Definicao do layout do Relatorio                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportDef()

	Local oReport
	Local oSection1

	oReport := TReport():New("STFIN07","Relacao de notas fiscais de devoluções","STFIN07",{|oReport| ReportPrint(oReport)},"Relacao de notas fiscais de devoluções.")

	oReport:SetLandscape()
	pergunte("STFIN07",.F.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para parametros						  ³
	//³ mv_par01			// Mes							 		  ³
	//³ mv_par02			// Ano									  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


	oSection1 := TRSection():New(oReport,"Notas fiscais de devoluções",{"SZ9"},)


	TRCell():New(oSection1,"FILIAL"	    ,,"FILIAL"	    ,"@!",002,.F.,)
	TRCell():New(oSection1,"NFISCAL"	    ,,"NOTA FISCAL"	    ,"@!",010,.F.,)
	TRCell():New(oSection1,"CNPJ"	    ,,"CNPJ"	,"@!",020,.F.,)
	TRCell():New(oSection1,"RZAOSO"	,,"RAZAO SOCIAL","@!",040,.F.,)
	TRCell():New(oSection1,"EMISSAO"		,,"EMISSAO" ,"@!",014,.F.,)
	TRCell():New(oSection1,"VALOR"   ,,"VALOR" ,"@E 999,999,999.99",020,.F.,)
	TRCell():New(oSection1,"NFORIG"		    ,,"NOTA ORIGEM"	,"@!",060,.F.,)
	TRCell():New(oSection1,"FATEC"		    ,,"FATEC APROVADA"	,"@!",05,.F.,)
	TRCell():New(oSection1,"VEND"		,,"VENDEDOR"	,"@!",20,.F.,)
	TRCell():New(oSection1,"SUPER"		,,"SUPERVISOR"	,"@!",20,.F.,)
	TRCell():New(oSection1,"EVENTO"		,,"EVENTO"	,"@!",20,.F.,)
	TRCell():New(oSection1,"CHAVE"		,,"CHAVE"	,"@!",60,.F.,)




	//oBreak1 := TRBreak():New(oSection1,".T.","Total general",.F.)
	//oFunction := TRFunction():New(oSection1:Cell('BASE_IMPONIBLE'),NIL,"SUM",oBreak1,"Total general",PesqPict("SE2","E2_VALOR"),/*uFormula*/,.F.,.F.)
	//oFunction := TRFunction():New(oSection1:Cell('RETENCION'),NIL,"SUM",oBreak1,"Total general",PesqPict("SE2","E2_VALOR"),/*uFormula*/,.F.,.F.)



	oSection1:SetHeaderSection(.T.)
	oSection1:Setnofilter("SZ9")


Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrint³ Autor ³Microsiga		          ³ Data ³12.05.12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³A funcao estatica ReportDef devera ser criada para todos os  ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto Report do Relatório                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ReportPrint(oReport)

	Local cTitulo		:= OemToAnsi("Devolucoes Vendas XML")
	Local cAlias1		:= "QRY1SZ9"
	Local cQuery1		:= ""
	Local nRecSM0		:= SM0->(Recno())
	Local aDados1[12]
	Local oSection1  := oReport:Section(1)
	Local _cXml      :=""
	Local _nPos      := 0
	Local _cQryF2    := ""




	oSection1:Cell("FILIAL"  )		:SetBlock( { || aDados1[1] })
	oSection1:Cell("NFISCAL" )		:SetBlock( { || aDados1[2] })
	oSection1:Cell("CNPJ" )		:SetBlock( { || aDados1[3] })
	oSection1:Cell("RZAOSO" )		:SetBlock( { || aDados1[4] })
	oSection1:Cell("EMISSAO" )	    	:SetBlock( { || aDados1[5] })
	oSection1:Cell("VALOR" )	    	:SetBlock( { || aDados1[6] })
	oSection1:Cell("NFORIG" )	:SetBlock( { || aDados1[7] })
	oSection1:Cell("FATEC" )	:SetBlock( { || aDados1[8] })
	oSection1:Cell("VEND" )	:SetBlock( { || aDados1[9] })
	oSection1:Cell("SUPER" )	:SetBlock( { || aDados1[10] })
	oSection1:Cell("EVENTO" )	:SetBlock( { || aDados1[11] })
	oSection1:Cell("CHAVE" )	:SetBlock( { || aDados1[12] })


	cQuery1 := " SELECT SZ9.Z9_FILIAL  AS FIL,                      "
	cQuery1 += "        SZ9.Z9_CHAVE   AS CHAVE                     "
	cQuery1 += " FROM "+RetSqlName("SZ9")+" SZ9                     " 
	cQuery1 += " WHERE SZ9.Z9_FILIAL >='"+MV_PAR05+"'       AND     "
	cQuery1 += "       SZ9.Z9_FILIAL <='"+MV_PAR06+"'       AND     "
	cQuery1 += "       SZ9.Z9_DTEMIS >='"+Dtos(MV_PAR01)+"' AND     "
	cQuery1 += "       SZ9.Z9_DTEMIS <='"+Dtos(MV_PAR02)+"' AND     "
	cQuery1 += "       SZ9.Z9_CNPJ >='"+MV_PAR03+"'         AND     "
	cQuery1 += "       SZ9.Z9_CNPJ <='"+MV_PAR04+"'         AND     "
	cQuery1 += "       SZ9.D_E_L_E_T_ <>'*'                         "




	cQuery1 := ChangeQuery(cQuery1)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Fecha Alias se estiver em Uso ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(Select(cAlias1))
		DbSelectArea(cAlias1)
		(cAlias1)->(dbCloseArea())
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta Area de Trabalho executando a Query ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery1),cAlias1,.T.,.T.)


	oReport:SetTitle(cTitulo)

	nCont:= 0
	dbeval({||nCont++})

	oReport:SetMeter(nCont)

	aFill(aDados1,nil)
	oSection1:Init()

	dbSelectArea(cAlias1)
	(cAlias1)->(dbGoTop())

	//Imprime Dcre
	aFill(aDados1,nil)
	oSection1:Init()


	//Atualiza Array com dados de Captação
	While (cAlias1)->(!Eof())

		_cXml      :=""
		_nPos      := 0
		_cQryF2 := " "

		DbSelectarea("SZ9")
		DbSetOrder(1)
		If DbSeek((cAlias1)->(FIL)+(cAlias1)->(CHAVE))
			_cXml      :=SZ9->Z9_XML
			_nPos      := at("<CFOP>1201</CFOP>", _cXml)
			If _nPos  <=  0
				_nPos      := at("<CFOP>2201</CFOP>", _cXml)
			Endif 
			
			If _nPos  <=  0
				_nPos      := at("<CFOP>1411</CFOP>", _cXml)
			Endif 
			
			If _nPos  <=  0
				_nPos      := at("<CFOP>2411</CFOP>", _cXml)
			Endif
			
			If _nPos  <=  0
				_nPos      := at("<CFOP>1202</CFOP>", _cXml)
			Endif
			
			If _nPos  <=  0
				_nPos      := at("<CFOP>2202</CFOP>", _cXml)
			Endif
			
		Endif
		
		If _nPos <= 0
		     (cAlias1)->(dbSkip())
		     loop
		Endif
		

		aDados1[01]  := (cAlias1)->(FIL)
		aDados1[02]  := SubStr(_cXml,at("<NNF>",UPPER(_cXml))+5,at("</NNF>",UPPER(_cXml))-(at("<NNF>",UPPER(_cXml))+5))
		aDados1[03]  := SZ9->Z9_CNPJ
        aDados1[04]  := SZ9->Z9_NFOR
        aDados1[05]  := DTOC(SZ9->Z9_DTEMIS)
        aDados1[06]  := SZ9->Z9_VALORNF
        aDados1[07]  := SubStr(_cXml,at("<REFNFE>",UPPER(_cXml))+8,(at("</REFNFE>",UPPER(_cXml))-(at("<REFNFE>",UPPER(_cXml))+8)))
        
        If Select("TF2") > 0
            DbSelectArea("TF2")
            DbCloSeArea()
        Endif
        
        _cQryF2 := " SELECT SF2.F2_FILIAL AS FIL,       "
        _cQryF2 += "        SF2.F2_DOC    AS NFISCAL,   "
        _cQryF2 += "        SF2.F2_CLIENTE AS CLIENTE,  "
        _cQryF2 += "        SF2.F2_LOJA    AS LOJA,     "
        _cQryF2 += "        SF2.F2_SERIE   AS SERIE     "
        _cQryF2 += " FROM "+RetSqlName("SF2")+" SF2     "
        _cQryF2 += " WHERE SF2.F2_FILIAL ='"+(cAlias1)->(FIL)+"'  AND "
        _cQryF2 += "       SF2.F2_CHVNFE ='"+aDados1[07]+"'     AND "
        _cQryF2 += "       SF2.D_E_L_E_T_ <>'*'                     "
        
        TCQUERY  _cQryF2   NEW ALIAS "TF2"
		_nRec := 0
		DbEval({|| _nRec++  })  
		

        
        DbSelectArea("TF2")
        DbGotop()
        
        
        aDados1[07] := TF2->NFISCAL
        
        DbSelectArea("SA1")
        DbSetorder(1)
        If DbSeek(xFilial("SA1")+TF2->CLIENTE+TF2->LOJA)
              DbSelectArea("SA3")
              DbSetOrder(1)
              If DbSeek(xFilial("SA3")+SA1->A1_VEND) 
                   aDados1[09] := SA3->A3_NOME
                   
                   DbSelectArea("SA3")
                   DbSetOrder(1)
                   If DbSeek(xFilial("SA3")+SA3->A3_SUPER)
                      aDados1[10]:=SA3->A3_NOME
                   Endif
              Endif
        Endif
          
        aDados1[11]  := RTRIM(LTRIM(SZ9->Z9_STATUSA))
        
        aDados1[12]  := (cAlias1)->(CHAVE)
        
        
        
		



		oSection1:PrintLine()
		aFill(aDados1,nil)

		(cAlias1)->(dbSkip())
	EndDo

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Fecha Alias se estiver em Uso ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(Select(cAlias1))
		DbSelectArea(cAlias1)
		(cAlias1)->(dbCloseArea())
	Endif

	//Imprime os dados de Metas
	aFill(aDados1,nil)
	oSection1:Init()

	oSection1:PrintLine()
	aFill(aDados1,nil)

	oReport:SkipLine()
	oSection1:Finish()

Return