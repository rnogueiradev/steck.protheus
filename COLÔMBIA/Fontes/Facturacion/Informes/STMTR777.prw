#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*/{Protheus.doc} STMTR777
Rotina Impressão Relatorio Pick-List
@type function
@version 12.1.33
@author Valdemir Rabelo
@since 21/05/2023
@return variant, Nil
/*/
USER FUNCTION STMTR777
	Local   oReport
	Private cPerg   := "MTR777"

	oReport	:= ReportDef()
	if oReport != nil 
		oReport:PrintDialog()
	endif 

RETURN

/*/{Protheus.doc} ReportDef
Rotina Motagem layout relatório
@type function
@version 12.1.33
@author Valdemir Rabelo
@since 22/05/2023
@return variant, Objeto
/*/
Static Function ReportDef()
	Local oReport
	Local oSection1
	Local nomeprog  := "STMTR777"
	Private aDados  := Array(16)

	oReport := TReport():New(nomeprog,"Relatorio PICK-LIST",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irÃ¡ imprimir um relatÃ³rio Pick-List")

	Pergunte(cPerg,.F.)

	oSection1 := TRSection():New(oReport,"Relatorio PICK-LIST",{"SC9"})

	TRCell():New(oSection1,"C9_PEDIDO"  	,,"Orden"			,"@!",		12,/*lPixel*/,{||aDados[01]})    // Pedido
	TRCell():New(oSection1,"C9_ITEM"  	    ,,"Artículo"		,"@!",		10,/*lPixel*/,{||aDados[02]})    // Item
	TRCell():New(oSection1,"C9_PRODUTO"  	,,"Producto  "		,"@!",		18,/*lPixel*/,{||aDados[03]})    // Produto
	TRCell():New(oSection1,"B1_DESC"  		,,"Descripción"		,"@!",		30,/*lPixel*/,{||aDados[04]})    // Descrição
	TRCell():New(oSection1,"B1_UM"	    	,,"Unidad"			,"@!",		03,/*lPixel*/,{||aDados[05]})    // Unidade
	TRCell():New(oSection1,"C9_QTDLIB"	    ,,"Cantidad"		,PesqPict("SC9","C9_QTDLIB"),10,/*lPixel*/,{||aDados[06]})    // Quantidade
	TRCell():New(oSection1,"C9_LOCAL"  		,,"Almacenamiento"	,"@!",		03,/*lPixel*/,{||aDados[07]})		// Armazem
	TRCell():New(oSection1,"C9_CLIENTE"	    ,,"Cod.Cliente"		,"@!",		20,/*lPixel*/,{||aDados[08]})       // código cliente
	TRCell():New(oSection1,"NOMECLI"	    ,,"Nombre del cliente"	,"@!",		30,/*lPixel*/,{||aDados[09]})	// Nome Cliente
	TRCell():New(oSection1,"C5_XCIUD" 	    ,,"Departamento"    ,"@!",		50,/*lPixel*/,{||aDados[10]})		// Cidade
	TRCell():New(oSection1,"C5_XORDEM" 	    ,,"Orden Compra"    ,"@!",		20,/*lPixel*/,{||aDados[15]})		// Ordem Compra
//	TRCell():New(oSection1,"C5_XOBS"  	    ,,"Observação"	    ,"@!",		50,/*lPixel*/,{||aDados[10]})

	TRCell():New(oSection1,"C5_XMUN"  	    ,,"Ciudad"  	    ,"@!",		20,/*lPixel*/,{||aDados[11]})   		 // Municipio
	TRCell():New(oSection1,"C5_XENDENT"	    ,,"Direccion"	    ,"@!",		20,/*lPixel*/,{||aDados[12]})
	TRCell():New(oSection1,"C5_XTEL"	    ,,"Telefono"	    ,"@!",		20,/*lPixel*/,{||aDados[13]})
	TRCell():New(oSection1,"C5_XNOMECT"	    ,,"Nombre Cont"	    ,"@!",		30,/*lPixel*/,{||aDados[14]})
	TRCell():New(oSection1,"C5_FECENT"	    ,,"Fech.Entrega"    ,"@D 99/99/9999",	10,/*lPixel*/,{||aDados[16]})


	oSection1:SetHeaderSection(.t.)
	oSection1:Setnofilter("SC9")

Return oReport

/*/{Protheus.doc} ReportPrint
Rotina de Carregamento dos dados
@type function
@version 12.1.33
@author Valdemir Rabelo
@since 23/05/2023
@param oReport, object, Objeto
@return variant, Nil
/*/
Static Function ReportPrint(oReport)
	Local nTotReg       := 0
	Local cAliasNew     := GetNextAlias()
	Local lUsaLocal     := (SuperGetMV("MV_LOCALIZ") == "S")

	Private oSection1	:= oReport:Section(1)
	Private aDados	:= {}

	oReport:SetTitle("Relatorio Pick-List")// Titulo do relatorio

	Processa({|| StQuery( @cAliasNew, lUsaLocal ) },"Compondo Relatorio")
	SB1->( dbSetOrder(1) )
	SA1->( dbSetOrder(1) )
	SC5->( dbSetOrder(1) )
	nTotReg := (cAliasNew)->(LastRec())

	aDados := Array(16)
	oReport:SetMeter(nTotReg)
	aFill(aDados,nil)
	oSection1:Init()
	(cAliasNew)->( dbGotop() )

	While !Eof()
		cDesProd := "Produto não encontrado"
		if SB1->(dbSeek(xFilial("SB1")+(cAliasNew)->C9_PRODUTO))
		   cDesProd := Subs(SB1->B1_DESC,1,60)
		endif 
		SA1->(dbSeek(xFilial("SA1")+(cAliasNew)->(C9_CLIENTE+C9_LOJA) ))
		SC5->(dbSeek(xFilial('SC5')+(cAliasNew)->C9_PEDIDO))
		oReport:IncMeter()
		If lUsaLocal
			cEndereco := (cAliasNew)->DC_LOCALIZ
			nQtde     := Iif((cAliasNew)->DC_QUANT>0,(cAliasNew)->DC_QUANT,(cAliasNew)->C9_QTDLIB)
		Else
			cEndereco := ""
			nQtde     := (cAliasNew)->C9_QTDLIB
		EndIf
		
		//cQuant := AllTrim(Transform(nQtde, PesqPict("SC9","C9_QTDLIB")))
		
		aDados[01]	:= (cAliasNew)->C9_PEDIDO
		aDados[02]	:= PadL((cAliasNew)->C9_ITEM,2,"0")
		aDados[03]	:= (cAliasNew)->C9_PRODUTO
		aDados[04]	:= cDesProd
		aDados[05]	:= SB1->B1_UM
		aDados[06]	:= nQtde
		aDados[07]	:= (cAliasNew)->C9_LOCAL
		aDados[08]	:= (cAliasNew)->C9_CLIENTE   //+" / "+(cAliasNew)->C9_LOJA
		aDados[09]	:= SA1->A1_NREDUZ
		aDados[10]	:= POSICIONE("SX5",1,XFILIAL("SX5")+"12"+SC5->C5_XCIUD,"X5_DESCRI")     //iif(SC5->(FieldPos("C5_XOBS")) > 0,SC5->C5_XOBS,"")
		aDados[11]  := SC5->C5_XMUN
		aDados[12]  := SC5->C5_XENDENT
		aDados[13]  := SC5->C5_XTEL
		aDados[14]  := SC5->C5_XNOMECT
		aDados[15]  := SC5->C5_XORDEM
		aDados[16]  := SC5->C5_FECENT
		oSection1:PrintLine()
		
		aFill(aDados,nil)
		dbSkip()
	EndDo

Return oReport

/*/{Protheus.doc} StQuery
Montagem do Filtro
@type function
@version 12.1.33
@author Valdemir Rabelo
@since 23/05/2023
@param cAliasNew, character, Apelido Tabela temporaria
@param lUsaLocal, logical, Usa Endereçamento
@return variant, Nil
/*/
Static Function StQuery(cAliasNew, lUsaLocal)
	Local cQuery     := ""
	Local aStruSC9   := {}
	Local nX         := 0

	aStruSC9 := SC9->(dbStruct())
	cQuery := "SELECT SC9.R_E_C_N_O_ SC9REC," + CRLF
	cQuery += "SC9.C9_PEDIDO,SC9.C9_FILIAL,SC9.C9_QTDLIB,SC9.C9_PRODUTO, " + CRLF
	cQuery += "SC9.C9_LOCAL,SC9.C9_LOTECTL,SC9.C9_POTENCI," + CRLF
	cQuery += "SC9.C9_NUMLOTE,SC9.C9_DTVALID,SC9.C9_NFISCAL," + CRLF
	cQuery += "SC9.C9_CLIENTE, SC9.C9_LOJA, SC9.C9_ITEM" + CRLF

	If lUsaLocal
		cQuery += ",SDC.DC_LOCALIZ,SDC.DC_QUANT,SDC.DC_QTDORIG" + CRLF
	EndIf
	
	cQuery += " FROM " + CRLF
	cQuery += RetSqlName("SC9") + " SC9 " + CRLF
	If lUsaLocal
		cQuery += "LEFT JOIN "+RetSqlName("SDC") + " SDC " + CRLF
		cQuery += "ON SDC.DC_PEDIDO=SC9.C9_PEDIDO AND SDC.DC_ITEM=SC9.C9_ITEM AND SDC.DC_SEQ=SC9.C9_SEQUEN AND SDC.D_E_L_E_T_ = ' '" + CRLF
	EndIf
	cQuery += "WHERE SC9.C9_FILIAL  = '"+xFilial("SC9")+"'" + CRLF
	cQuery += " AND  SC9.C9_PEDIDO >= '"+mv_par01+"'" + CRLF
	cQuery += " AND  SC9.C9_PEDIDO <= '"+mv_par02+"'" + CRLF
	If mv_par03 == 1 .Or. mv_par03 == 3
		cQuery += " AND SC9.C9_BLEST  = '  '" + CRLF
	EndIf
	If mv_par03 == 2 .Or. mv_par03 == 3
		cQuery += " AND SC9.C9_BLCRED = '  '" + CRLF
	EndIf
	cQuery += " AND SC9.D_E_L_E_T_ = ' '" + CRLF
	cQuery += "ORDER BY SC9.C9_FILIAL,SC9.C9_PEDIDO,SC9.C9_ITEM" + CRLF
	
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),(cAliasNew),.T.,.T.)
	
	For nX := 1 To Len(aStruSC9)
		If aStruSC9[nX][2] <> "C" .and.  FieldPos(aStruSC9[nX][1]) > 0
			TcSetField(cAliasNew,aStruSC9[nX][1],aStruSC9[nX][2],aStruSC9[nX][3],aStruSC9[nX][4])
		EndIf
	Next nX	

Return 
