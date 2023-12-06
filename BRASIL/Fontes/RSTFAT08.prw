#INCLUDE "APWEBSRV.CH" 
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "tbiconn.ch"
#INCLUDE "tbicode.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RSTFAT08    ºAutor  ³Giovani Zago    º Data ³  10/07/13     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio de Lista de Preço                               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RSTFAT08()

	Local   oReport
	Private cPerg := "RFAT08"
	Private cTime           := Time()
	Private cHora           := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private lXlsHeader      := .f.
	Private lXmlEndRow      := .f.
	Private oGetDad                                                            //Inserido Jefferson Carlos 02/12/13

	Public n
	Private _cArq := "" 	//FR - 18/01/2022
	Private aHeader := {} 	//FR - 18/01/2022
	Private aCols   := {}	//FR - 18/01/2022
	Private xOrigFab := ""  //FR - 20/01/2022

	Private _nTotal := 0

	PutSx1( cPerg, "01","Grupo de?"   ,"","","mv_ch1","C",6,0,0,"G","","SBM","","","mv_par01","","","","","","","","","","","","","","","","")
	PutSx1( cPerg, "02","Grupo Até?"  ,"","","mv_ch2","C",6,0,0,"G","","SBM","","","mv_par02","","","","","","","","","","","","","","","","")
	PutSx1( cPerg, "03","Cliente?"    ,"","","mv_ch3","C",6,0,0,"G","","SA1","","","mv_par03","","","","","","","","","","","","","","","","")
	PutSx1( cPerg, "04","Loja?"       ,"","","mv_ch4","C",2,0,0,"G","","","","","mv_par04","","","","","","","","","","","","","","","","")
	PutSx1( cPerg, "05","Cond. Pag.?" ,"","","mv_ch5","C",3,0,0,"G","","SE4_01","","","mv_par05","","","","","","","","","","","","","","","","")
	PutSx1( cPerg, "06","Obser."      ,"","","mv_ch6","C",99,0,0,"G","","","","","mv_par06","","","","","","","","","","","","","","","","")
	PutSx1( cPerg, "07","Tipo "       ,"","","mv_ch7","N",1,0,2,"C","","","","","mv_par07","Todos","","","","Lista","","","","","","","","","","","")
	PutSx1( cPerg, "08","Produto "    ,"","","mv_ch8","C",15,0,0,"G","","SB1","","","mv_par08","","","","","","","","","","","","","","","","")

	oReport		:= ReportDef()

	If IsInCallStack("U_STFAT370") .Or. IsInCallStack("U_STFAT373")

		MV_PAR01 := "      "
		MV_PAR02 := "ZZZZZZ"
		//MV_PAR01 := "000"
		//MV_PAR02 := "000"
		MV_PAR03 := SA1->A1_COD
		MV_PAR04 := SA1->A1_LOJA

		If !Empty(SA1->A1_ZCONDPG)
			MV_PAR05 := SA1->A1_ZCONDPG
		Else
			MV_PAR05 := "502"
		EndIf
		MV_PAR07 := 2
		MV_PAR08 := ""

		_cArq := AllTrim(STTIRAGR(SA1->A1_NOME))+"_"+AllTrim(SA1->A1_EST)+"_LOJA"+AllTrim(SA1->A1_LOJA)+'.xls'

		oReport:SetPreview(.F.)
		oReport:SetDevice(4)
		oReport:cFile := '\arquivos\listaprecos\'+_cArq
		oReport:Print(.F.)

	Else
		oReport:PrintDialog()
	EndIf

Return(_cArq)

Static Function ReportDef()

	Local oReport
	Local oSection

	oReport := TReport():New(cPerg,"RELATÓRIO DE LISTA DE PREÇO",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório de Lista de Preço .")

	Pergunte(cPerg,.F.)

	oSection := TRSection():New(oReport,"Lista de Preço",{"DA1"})

	TRCell():New(oSection,"PRODUTO",,"PRODUTO",,20,.F.,)
	TRCell():New(oSection,"DESCRICAO",,"DESCRICAO",,20,.F.,)
	//TRCell():New(oSection,"GRUPO",,"GRUPO",,3,.F.,)
	//TRCell():New(oSection,"DESCR. GRUPO",,"DESCR. GRUPO",,20,.F.,)
	TRCell():New(oSection,"QTD.EMB.",,"LOTE MINIMO","@E 999.99",6)
	TRCell():New(oSection,"CLAS.FISCAL",,"CLAS.FISCAL","@R 9999.99.99",11,.F.,)
	TRCell():New(oSection,"CST",,"CST",,3,.F.,)
	//TRCell():New(oSection,"Prc.BASE",,"Prc.BASE","@E 99,999,999.99",14)
	TRCell():New(oSection,"%ICMS",,"%ICMS","@E 999.99",6)
	//TRCell():New(oSection,"%DESC.",,"%DESC.","@E 999.99",6)
	TRCell():New(oSection,"PREÇO" ,,"PREÇO","@E 99,999,999.99",14)
	TRCell():New(oSection,"%IPI",,"%IPI","@E 999.99",6)
	TRCell():New(oSection,"IPI" ,,"IPI","@E 99,999,999.99",14)
	TRCell():New(oSection,"IVA",,"IVA","@E 999.99",6)
	TRCell():New(oSection,"ICMS ST",,"ICMS ST","@E 99,999,999.99",14)
	TRCell():New(oSection, "%ICMS ST",, "%ICMS ST","@E 999.99",6)
	TRCell():New(oSection,"Prc.FINAL",,"Prc.FINAL","@E 99,999,999.99",14)
	TRCell():New(oSection,"CAMPANHA",,"CAMPANHA",,3,.F.,)
	TRCell():New(oSection,"EAN 14 (1)",,"EAN 14 (1)","@E 99,999,999.99",14)
	TRCell():New(oSection,"EAN 14 (2)",,"EAN 14 (2)","@E 99,999,999.99",14)
	TRCell():New(oSection,"EAN13",,"EAN13",,30,.F.,)
	TRCell():New(oSection,"EAN141",,"EAN141",,30,.F.,)
	TRCell():New(oSection,"EAN142",,"EAN142",,30,.F.,)
	TRCell():New(oSection,"ORIGEM",,"ORIGEM",,10,.F.,)
	TRCell():New(oSection,"CODCLIENTE",,"COD.CLIENTE",,50,.F.,)

	oSection:SetHeaderSection(.t.)
	oSection:Setnofilter("DA1")

Return oReport

Static Function ReportPrint(oReport)

	Local oSection	:= oReport:Section(1)
	Local oSection1	:= oReport:Section(1)
	Local nX			:= 0
	Local cQuery 	:= ""
	Local cAlias 		:= "QRYTEMP9"
	Local aDados[2]
	Local aDados1[99]
	Local nValLiq 	:= 0
	Local nValBrut	:= 0
	Local   _nPosPrv  		:= 0
	Local   _nPosProd  		:= 0
	Local   _nPosTes  		:= 0
	Local	nPValICMS		:= 0
	Local	nPAliqICM  		:= 0
	Local	nPValICMSST		:= 0
	Local	nPValIPI		:= 0
	Local	nPosIpi		    := 0
	Local	nPosList		:= 0
	Local	_nPosDEXC		:= 0
	Local	_nPosCamp		:= 0
	Local	nPosCOMISS		:= 0
	Local _nPosDESC         := 0
	Local _nPosOrig         := 0   //FR - 20/01/2022
	Local _cGrupProd        := ' '
	Local i

	oSection1:Cell("PRODUTO")		:SetBlock( { || aDados1[01] } )
	oSection1:Cell("DESCRICAO")		:SetBlock( { || aDados1[02] } )
	//oSection1:Cell("GRUPO")			:SetBlock( { || aDados1[03] } )
	//oSection1:Cell("DESCR. GRUPO")	:SetBlock( { || aDados1[04] } )
	oSection1:Cell("QTD.EMB.")		:SetBlock( { || aDados1[05] } )
	oSection1:Cell("CLAS.FISCAL")	:SetBlock( { || aDados1[06] } )
	oSection1:Cell("CST")			:SetBlock( { || aDados1[07] } )
	//oSection1:Cell("Prc.BASE")		:SetBlock( { || aDados1[08] } )
	oSection1:Cell("%ICMS")			:SetBlock( { || aDados1[09] } )
	//oSection1:Cell("%DESC.")		:SetBlock( { || aDados1[10] } )
	oSection1:Cell("PREÇO")			:SetBlock( { || aDados1[11] } )
	oSection1:Cell("%IPI")			:SetBlock( { || aDados1[12] } )
	oSection1:Cell("IPI")			:SetBlock( { || aDados1[13] } )
	oSection1:Cell("IVA")			:SetBlock( { || aDados1[14] } )
	oSection1:Cell("ICMS ST")		:SetBlock( { || aDados1[15] } )
	oSection1:Cell("%ICMS ST")		:SetBlock( { || aDados1[16] } )
	oSection1:Cell("Prc.FINAL")		:SetBlock( { || aDados1[17] } )
	oSection1:Cell("CAMPANHA")		:SetBlock( { || aDados1[18] } )
	oSection1:Cell("EAN 14 (1)")	:SetBlock( { || aDados1[19] } )
	oSection1:Cell("EAN 14 (2)")	:SetBlock( { || aDados1[20] } )
	oSection1:Cell("EAN13")			:SetBlock( { || aDados1[21] } )
	oSection1:Cell("EAN141")		:SetBlock( { || aDados1[22] } )
	oSection1:Cell("EAN142")		:SetBlock( { || aDados1[23] } )
	oSection1:Cell("ORIGEM")		:SetBlock( { || aDados1[24] } )

	oSection1:Cell("CODCLIENTE")		:SetBlock( { || aDados1[25] } )

	oReport:SetTitle("Lista de Preço")// Titulo do relatório

	oReport:SetMeter(0)
	aFill(aDados,nil)
	aFill(aDados1,nil)
	oSection:Init()

	strelquer()

	dbSelectArea("SB1")
	dbSelectArea("SA1")
	SA1->(DbSetOrder(1))

	DbSelectArea("SZD")
	SZD->(DbSetOrder(2))
	SZD->(DbGoTop())

	dbSelectArea(cAliasLif)
	(cAliasLif)->(dbgotop())
	If  Select(cAliasLif) > 0

		_nX := 0

		While 	(cAliasLif)->(!Eof())

			SB1->(DbGoTo((cAliasLif)->RECSB1))
			If SA1->(DbSeek(xFilial("SA1")+MV_PAR03+MV_PAR04))

				_aPreco := {}
				_aPreco := U_STRETSST("01",SA1->A1_COD,SA1->A1_LOJA,SB1->B1_COD,MV_PAR05,'TUDO',.F.,SA1->A1_TIPO,         ,"001",)

				aDados1[01]	:=	SB1->B1_COD
				aDados1[02]	:=	ALLTRIM(SB1->B1_DESC)
				aDados1[05]	:=	iif(SB1->B1_XLM=0,1,SB1->B1_XLM)
				aDados1[06]	:=  Transform(SB1->B1_POSIPI,' @R 9999.99.99 '  )
				aDados1[07]	:=	ALLTRIM(SB1->B1_ORIGEM)
				aDados1[08]	:=	0
				aDados1[09]	:=  _aPreco[6]
				aDados1[11]	:=	_aPreco[1]
				aDados1[14]	:=	Posicione("SF7", 4 , xFilial("SF7") + SB1->B1_GRTRIB + SA1->A1_GRPTRIB + SA1->A1_EST + SA1->A1_TIPO,"F7_MARGEM")
				aDados1[12]	:= 	_aPreco[4]
				aDados1[13]	:=	_aPreco[2]
				aDados1[15]	:=	_aPreco[3]
				aDados1[16]	:=	_aPreco[5]
				aDados1[17]	:=  aDados1[11]+aDados1[13]+aDados1[15]
				aDados1[18]	:=	""
				aDados1[19]	:=	0
				aDados1[20]	:=	0
				aDados1[21]	:=	SB1->B1_CODBAR
				aDados1[22]	:=	""
				aDados1[23]	:=	""
				aDados1[24] :=  ""

				_cCliente :=  SA1->A1_COD
				If  Substr(AllTrim(SA1->A1_NOME),1,3) = 'MRV' .Or. Substr(AllTrim(SA1->A1_NREDUZ),1,3) = 'MRV'
					_cCliente:= '043252'
				EndIf
				If SZD->(DbSeek(xFilial("SZD")+_cCliente+SB1->B1_COD))
					aDados1[25] :=  SZD->ZD_CODCLI
				EndIf

			EndIf

			oSection1:PrintLine()
			aFill(aDados1,nil)

			(cAliasLif)->(DbSkip())
		EndDo
	EndIf

	oReport:SkipLine()

	aDados1[01]	:='Informações Adicionais:'
	oSection1:PrintLine()
	aFill(aDados1,nil)

	oSection1:PrintLine()
	aFill(aDados1,nil)

	dbSelectArea("SE4")
	SE4->(dbsetOrder(1))
	SE4->(DbSeek(xFilial("SE4")+ MV_PAR05))
	aDados1[01]	:='Taxa Financeira: '+transform(SE4->E4_XACRESC,'@e 999.99')+'%  para: ' +SE4->E4_DESCRI
	oSection1:PrintLine()
	aFill(aDados1,nil)

	aDados1[01]	:='IPI correspondente a '
	oSection1:PrintLine()
	aFill(aDados1,nil)
	aDados1[01]	:='cada linha de produto'
	oSection1:PrintLine()
	aFill(aDados1,nil)

	aDados1[01]	:='Substituição Tributaria '
	oSection1:PrintLine()
	aFill(aDados1,nil)
	aDados1[01]	:='Somadas nas Ultimas Duas Colunas'
	oSection1:PrintLine()
	aFill(aDados1,nil)

	aDados1[01]	:='RAZAO SOCIAL: '+substr(ALLTRIM(SA1->A1_NOME) ,1,30)
	oSection1:PrintLine()
	aFill(aDados1,nil)
	aDados1[01]	:='CNPJ/CPF: '+Transform(SA1->A1_CGC,PicPesFJ(RetPessoa(SA1->A1_CGC)))
	oSection1:PrintLine()
	aFill(aDados1,nil)

	aDados1[01]	:='Observação: '+alltrim(MV_PAR06)
	oSection1:PrintLine()
	aFill(aDados1,nil)

	oSection1:PrintLine()
	aFill(aDados1,nil)

Return oReport

//SELECIONA OS PRODUTOS
Static Function strelquer()

	Local cQuery     := ' '

	cQuery := " SELECT SB1.R_E_C_N_O_ RECSB1, DA1.DA1_CODPRO  ,DA1.DA1_PRCVEN ,SB1.B1_GRUPO  ,SB1.B1_DESC " + CRLF

	//FR - 20/01/2022
	cQuery += " ,(SELECT COUNT(*) CONTADOR "+ CRLF
	cQuery += " FROM "+GetMv("STTMKG0311",,"UDBD02")+".SG1010 G1 "+ CRLF
	cQuery += " WHERE G1.D_E_L_E_T_=' ' AND G1_FILIAL='05' AND G1_COD = DA1.DA1_CODPRO ) AS ORIG_GUA " + CRLF

	cQuery += ", ( SELECT COUNT(*) CONTADOR "+ CRLF
	cQuery += " FROM "+GetMv("STTMKG0311",,"UDBD02")+".SG1030 G1 "+ CRLF
	cQuery += " WHERE G1.D_E_L_E_T_=' ' AND G1_FILIAL='01' AND G1_COD = DA1.DA1_CODPRO) AS ORIG_MAO" + CRLF

	//FR - 20/01/2022

	cQuery += " FROM "+RetSqlName("DA1")+" DA1 "+ CRLF

	cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SB1")+" ) SB1 "+ CRLF
	cQuery += " ON SB1.B1_COD = DA1.DA1_CODPRO " + CRLF
	cQuery += " AND SB1.D_E_L_E_T_ = ' ' "+ CRLF
	cQuery += " AND SB1.B1_GRUPO BETWEEN  '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' "+ CRLF
	If !Empty(MV_PAR08)
		cQuery += " AND SB1.B1_COD='"+MV_PAR08+"'
	EndIf
	cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SBM")+" ) SBM "+ CRLF
	cQuery += " ON SBM.BM_GRUPO =  SB1.B1_GRUPO " + CRLF
	cQuery += " AND SBM.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += " AND SBM.BM_FILIAL = '"+xFilial("SBM")+"' " + CRLF
	cQuery += " WHERE
	cQuery += " DA1.D_E_L_E_T_     = ' ' "   + CRLF
	cQuery += " AND DA1.DA1_PRCVEN > 0 AND SB1.B1_XDESAT<>'2' " + CRLF
	cQuery += " AND DA1.DA1_CODTAB = '"+ ALLTRIM(GETMV("ST_TPRCFAT"))+"'" + CRLF
	cQuery += " AND DA1_XVISUA<>'2'
	cQuery += " ORDER BY SB1.B1_GRUPO,SB1.B1_DESC "

	MemoWrite("C:\TEMP\RSTFAT08.TXT" , cQuery)

	cQuery := ChangeQuery(cQuery)

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

	Count To _nTotal

Return()


/*/{Protheus.doc} STTIRAGR
@name STTIRAGR
@type Static Function
@desc retirar caracteres especiais
@author Renato Nogueira
@since 29/05/2018
/*/

Static Function STTIRAGR(_cStrRec)

	Default _cStrRec := ""

	_cStrRec = StrTran (_cStrRec, "á", "a")
	_cStrRec = StrTran (_cStrRec, "é", "e")
	_cStrRec = StrTran (_cStrRec, "í", "i")
	_cStrRec = StrTran (_cStrRec, "ó", "o")
	_cStrRec = StrTran (_cStrRec, "ú", "u")
	_cStrRec = StrTran (_cStrRec, "Á", "A")
	_cStrRec = StrTran (_cStrRec, "É", "E")
	_cStrRec = StrTran (_cStrRec, "Í", "I")
	_cStrRec = StrTran (_cStrRec, "Ó", "O")
	_cStrRec = StrTran (_cStrRec, "Ú", "U")
	_cStrRec = StrTran (_cStrRec, "ã", "a")
	_cStrRec = StrTran (_cStrRec, "õ", "o")
	_cStrRec = StrTran (_cStrRec, "Ã", "A")
	_cStrRec = StrTran (_cStrRec, "Õ", "O")
	_cStrRec = StrTran (_cStrRec, "â", "a")
	_cStrRec = StrTran (_cStrRec, "ê", "e")
	_cStrRec = StrTran (_cStrRec, "î", "i")
	_cStrRec = StrTran (_cStrRec, "ô", "o")
	_cStrRec = StrTran (_cStrRec, "û", "u")
	_cStrRec = StrTran (_cStrRec, "Â", "A")
	_cStrRec = StrTran (_cStrRec, "Ê", "E")
	_cStrRec = StrTran (_cStrRec, "Î", "I")
	_cStrRec = StrTran (_cStrRec, "Ô", "O")
	_cStrRec = StrTran (_cStrRec, "Û", "U")
	_cStrRec = StrTran (_cStrRec, "ç", "c")
	_cStrRec = StrTran (_cStrRec, "Ç", "C")
	_cStrRec = StrTran (_cStrRec, "à", "a")
	_cStrRec = StrTran (_cStrRec, "À", "A")
	_cStrRec = StrTran (_cStrRec, "º", ".")
	_cStrRec = StrTran (_cStrRec, "ª", ".")
	_cStrRec = StrTran (_cStrRec, chr (9), " ")
	_cStrRec = StrTran (_cStrRec, "Ø", "")
	_cStrRec = StrTran (_cStrRec, "ø", "")
	_cStrRec = StrTran (_cStrRec, '"', '')
	_cStrRec = StrTran (_cStrRec, '”', '')
	_cStrRec = StrTran (_cStrRec, "&", "E")
	_cStrRec = StrTran (_cStrRec, "/", "")
	_cStrRec = StrTran (_cStrRec, "|", "")
	_cStrRec = StrTran (_cStrRec, "\", "")

	_cStrRet := _cStrRec

Return(_cStrRet)
