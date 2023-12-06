#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*/{Protheus.doc} RSTBUDGET
Relatorio de previsao de compras
@author thiago.fonseca
@since 06/05/2016
@version 1.0
@return SC1, Query
/*/

User Function RSTBUDGET() //U_RSTBUDGET()

	Local oReport
	Private cPerg := "RBUGET"
	Private cAliasQRY	:= "TRB"
	Private _cAlias1 := GetNextAlias()

	//Verifica se relatorios personalizaveis estao disponiveis
	If TRepInUse(.F.)
		fCriaSx1(cPerg)
		If !Pergunte(cPerg,.T.)
			Return
		EndIf
		oReport:=ReportDef(cPerg)
		oReport:PrintDialog()
	EndIf

Return .T.

/*/{Protheus.doc} ReportDef
Definicao das Colunas.
@author thiago.fonseca
@since 06/05/2016
@version 1.0
@param cPerg, character, (Input dos parametros)
@return oReport
/*/

Static Function ReportDef(cPerg)

	Local cProg 		:= 'RSTBUDGET'
	Local cTitulo		:= 'Solicitacoes De Compra com Pedidos de Compra - BUDGET'
	Local cDescri		:= ''

	Local bReport 	:= { |oReport| ReportPrint( oReport, cAliasQRY,aOrder) }
	Local aOrder		:= {'Por Solicitacoes'}
	//Private cRef			:= Alltrim(MV_PAR07)

	oReport:= TReport():New(cProg, cTitulo, cPerg , bReport, cDescri,.T.,,.F.,,.T.)
	oReport:SetLineHeight(30)
	oReport:DisableOrientation()
	//oReport:SetTotalInLine(.F.)

	oSection1 := TRSection():New(oReport  ,OemToAnsi(""),{"SC1","SB1"},aOrder)
	oSection1:SetTotalInLine(.F.)
	//oSection1:SetHeaderPage(.T.) //Unico cabecalho por pagina
	oSection1:SetAutoSize(.T.)
	//oSection1:SetHeaderBreak(.T.)

	// New ( < oParent>, < cName>, [ cAlias], [ cTitle], [ cPicture], [ nSize], [ lPixel], [ bBlock],"LEFT",,"LEFT" ) --> TRCell
	TRCell():New(oSecTion1, 'NUMSOL'	,	cAliasQry, "Num da SC."		,PesqPict("SC1","C1_NUM")		,TamSx3("C1_NUM")[1],,,,,)
	TRCell():New(oSecTion1, 'ITEM'		,	cAliasQry, "Item"			,PesqPict("SC1","C1_ITEM")			,TamSx3("C1_ITEM")[1],,,,,)
	TRCell():New(oSecTion1, 'DTEMIS'	,	cAliasQry, "DT Emissão"		,PesqPict("SC1","C1_EMISSAO")	,TamSx3("C1_EMISSAO")[1],,,,,)
	TRCell():New(oSecTion1, 'PRODUTO'	,	cAliasQry, "Produto"			,PesqPict("SC1","C1_PRODUTO")	,TamSx3("C1_PRODUTO")[1],,,,,)
	TRCell():New(oSecTion1, 'DESCRI'	,	cAliasQry, "Descricao"		,PesqPict("SC1","C1_DESCRI")	,TamSx3("C1_DESCRI")[1],,,,,)
	TRCell():New(oSecTion1, 'QUANTID'	,	cAliasQry, "Quantidade"		,PesqPict("SC1","C1_QUANT")		,TamSx3("C1_QUANT")[1],,,"LEFT",,"LEFT")
	TRCell():New(oSecTion1, 'MOTIVO'	,	cAliasQry, "Motivo"			,PesqPict("SC1","C1_MOTIVO")	,TamSx3("C1_MOTIVO")[1],,,,,)
	TRCell():New(oSecTion1, 'PRECO'		,	cAliasQry, "Valor Unit"		,PesqPict("SB1","B1_UPRC",12)	,TamSx3("B1_UPRC")[1],,,"LEFT",,"LEFT")
	TRCell():New(oSecTion1, 'TOTAL'		,	cAliasQry, "Valor Total"		,PesqPict("SB1","B1_UPRC",12)	,TamSx3("B1_UPRC")[1],,,"LEFT",,"LEFT")
	TRCell():New(oSection1, 'REFER'  	,	"   "	  ,	"Referencia"		,/*Picture*/,30,/*lPixel*/, )
	TRCell():New(oSecTion1, 'SOLICIT'	,	cAliasQry, "Solicitante"		,PesqPict("SC1","C1_SOLICIT")	,TamSx3("C1_SOLICIT")[1],,,,,)
	TRCell():New(oSecTion1, 'CC'		,	cAliasQry, "C.Custo"			,PesqPict("SC1","C1_CC")			,TamSx3("C1_CC")[1],,,,,)
	TRCell():New(oSecTion1, 'ZAPROV'	,	cAliasQry, "Aprovador"		,PesqPict("SC1","C1_ZAPROV")	,TamSx3("C1_ZAPROV")[1],,,,,)
	TRCell():New(oSecTion1, 'PRCORC'	,	cAliasQry, "Preço Orçado"	,PesqPict("SC1","C1_XPRCORC")	,TamSx3("C1_XPRCORC")[1],,,,,)		// Valdemir Rabelo 30/03/2020
	TRCell():New(oSecTion1, 'DTVLORC'	,	cAliasQry, "Dt.Validade Orç.",PesqPict("SC1","C1_XDTVORC")	,TamSx3("C1_XDTVORC")[1],,,,,)		// Valdemir Rabelo 30/03/2020
	oSection1:SetHeaderSection(.T.)
	TRFunction():New(oSection1:Cell("TOTAL"),NIL,"SUM",,"Valor Total Geral",,,.F.)
Return oReport

/*/{Protheus.doc} ReportPrint
Geracao do Relatorio.
@author thiago.fonseca
@since 06/05/2016
@version 1.0
@param oReport, objeto, (Descrição do parâmetro)
@param cAliasQRY, character, (Descrição do parâmetro)
@return NIL
/*/

Static Function ReportPrint(oReport, cAliasQRY, aOrder)

	Local oSection1	:= oReport:Section(1)
	Local nQtdReg		:= 0
	Local cQryGroup	:= ""
	//Local cNum			:= Alltrim(MV_PAR05)
	Local nOrdem     	:= oSection1:GetOrder()
	Local cOrdem		:= ""
	Local aDados1[99]
	Private cRef		:= Alltrim(MV_PAR07)
	Private cDescPro 	:= ""


	oSection1:Cell("NUMSOL"):SetBlock( 	{ || aDados1[01] } )
	oSection1:Cell("ITEM"):SetBlock( 	{ || aDados1[02] } )
	oSection1:Cell("DTEMIS"):SetBlock( 	{ || aDados1[03] } )
	oSection1:Cell("PRODUTO"):SetBlock( { || aDados1[04] } )
	oSection1:Cell("DESCRI"):SetBlock(  { || aDados1[05] } )
	oSection1:Cell("QUANTID"):SetBlock( { || aDados1[06] } )
	oSection1:Cell("MOTIVO"):SetBlock( 	{ || aDados1[07] } )
	oSection1:Cell("PRECO"):SetBlock( 	{ || aDados1[08] } )
	oSection1:Cell("TOTAL"):SetBlock( 	{ || aDados1[09] } )
	oSection1:Cell("REFER"):SetBlock( 	{ || aDados1[10] } )
	oSection1:Cell("SOLICIT"):SetBlock( { || aDados1[11] } )
	oSection1:Cell("CC"):SetBlock( 		{ || aDados1[12] } )
	oSection1:Cell("ZAPROV"):SetBlock(  { || aDados1[13] } )
	oSection1:Cell("PRCORC"):SetBlock(  { || aDados1[14] } )
	oSection1:Cell("DTVLORC"):SetBlock( { || aDados1[15] } )

	oReport:SetTitle(oReport:Title()+" - "+AllTrim(aOrder[nOrdem]))

	oReport:SetMeter(0)
	aFill(aDados1,nil)
	oSection1:Init()

	_cQuery1 := " 		SELECT	SC1.C1_NUM NUMSOL, SC1.C1_ITEM ITEM,SC1.C1_SOLICIT SOLICIT,SC1.C1_CC CC,SC1.C1_ZAPROV ZAPROV,SC1.C1_ZSTATUS ,SC1.C1_EMISSAO DTEMIS, " + CRLF
	_cQuery1 += " 		SC1.C1_PRODUTO PRODUTO, SC1.C1_DESCRI DESCRI, SC1.C1_QUANT QUANTID, SC1.C1_MOTIVO MOTIVO,	SB1.B1_UPRC PRECO, " + CRLF
	_cQuery1 += " 		SC1.C1_XPRCORC PRCORC, SC1.C1_XDTVORC DTVLORC, SUM(SC1.C1_QUANT)*SUM(SB1.B1_UPRC) TOTAL" + CRLF
	_cQuery1 += " 		FROM	"+RetSqlName("SC1")+" SC1 " + CRLF
	_cQuery1 += " 		INNER JOIN "+RetSqlName("SB1")+" SB1 " + CRLF
	_cQuery1 += " 		ON SB1.B1_COD = SC1.C1_PRODUTO AND SB1.B1_FILIAl = '"+xFilial("SB1")+"'"
	_cQuery1 += " 		WHERE 	SC1.C1_EMISSAO  >= '"+DTOS(MV_PAR01)+"' AND " + CRLF
	_cQuery1 += " 		SC1.C1_EMISSAO  <= '"+DTOS(MV_PAR02)+"' AND " + CRLF
	_cQuery1 += " 		SC1.C1_MOTIVO	  >= '"+MV_PAR03+"'	AND " + CRLF
	_cQuery1 += " 		SC1.C1_MOTIVO	  <= '"+MV_PAR04+"' 	AND " + CRLF
	_cQuery1 += " 		SC1.C1_NUM		  >= '"+MV_PAR05+"' 	AND " + CRLF
	_cQuery1 += " 		SC1.C1_NUM		  <= '"+MV_PAR06+"' 	AND " + CRLF
	_cQuery1 += " 		SC1.C1_ZSTATUS	<> '4'	AND " + CRLF
	_cQuery1 += " 		SC1.C1_ZSTATUS	<> '5' AND " + CRLF
	_cQuery1 += " 		SC1.C1_FILIAL = '"+xFilial("SC1")+"' AND " + CRLF
	_cQuery1 += " 		SC1.D_E_L_E_T_=' '  " + CRLF

	If nOrdem = 1 //Por Solicitacoes
		_cQuery1 += " GROUP BY SC1.C1_NUM,SC1.C1_ITEM,SC1.C1_SOLICIT,SC1.C1_CC,SC1.C1_ZAPROV,SC1.C1_ZSTATUS,SC1.C1_EMISSAO,SC1.C1_PRODUTO,SC1.C1_DESCRI,SC1.C1_QUANT ,SC1.C1_MOTIVO,SB1.B1_UPRC, SC1.C1_XPRCORC, SC1.C1_XDTVORC " + CRLF
		_cQuery1 += " ORDER BY SC1.C1_NUM,SC1.C1_ITEM,SC1.C1_SOLICIT,SC1.C1_CC,SC1.C1_ZAPROV,SC1.C1_ZSTATUS,SC1.C1_EMISSAO,SC1.C1_PRODUTO,SC1.C1_DESCRI,SC1.C1_QUANT ,SC1.C1_MOTIVO,SB1.B1_UPRC " + CRLF
	EndIf

	If !Empty(Select(cAliasQRY))
		DbSelectArea(cAliasQRY)
		(cAliasQRY)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),cAliasQRY,.T.,.T.)

	dbSelectArea(cAliasQRY)
	(cAliasQRY)->(dbGoTop())

	While (cAliasQRY)->(!Eof())

		aDados1[01]	:=  (cAliasQRY)->NUMSOL
		aDados1[02]	:=  (cAliasQRY)->ITEM
		aDados1[03]	:=  DTOC(STOD((cAliasQRY)->DTEMIS))
		aDados1[04]	:=  (cAliasQRY)->PRODUTO
		aDados1[05]	:=  (cAliasQRY)->DESCRI
		aDados1[06]	:=  (cAliasQRY)->QUANTID
		aDados1[07]	:=  (cAliasQRY)->MOTIVO

		_cQuery1 := " SELECT ROUND(PRECO/QTD,5) PRCMED
		_cQuery1 += " FROM (
		_cQuery1 += " SELECT SUM(C8_PRECO) PRECO, SUM(QTD) QTD
		_cQuery1 += " FROM (
		_cQuery1 += " SELECT C8_PRECO, 1 QTD
		_cQuery1 += " FROM "+RetSqlName("SC8")+" C8
		_cQuery1 += " INNER JOIN (
		_cQuery1 += " SELECT MAX(C8_NUM) COTACAO
		_cQuery1 += " FROM "+RetSqlName("SC8")+" C8
		_cQuery1 += " WHERE C8.D_E_L_E_T_=' ' AND C8_FILIAL='"+xFilial("SC1")+"' AND C8_PRODUTO='"+(cAliasQRY)->PRODUTO+"' AND C8_XPORTAL='S' AND C8_PRECO>0
		_cQuery1 += " ) XXX
		_cQuery1 += " ON C8.C8_FILIAL='"+xFilial("SC1")+"' AND C8.C8_NUM=XXX.COTACAO AND C8.C8_PRODUTO='"+(cAliasQRY)->PRODUTO+"' 
		_cQuery1 += " WHERE C8.D_E_L_E_T_=' ' AND C8_XPORTAL='S' AND C8_PRECO>0
		_cQuery1 += " ) XXX
		_cQuery1 += " ) ZZZ

		If !Empty(Select(_cAlias1))
			DbSelectArea(_cAlias1)
			(_cAlias1)->(dbCloseArea())
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

		dbSelectArea(_cAlias1)
		(_cAlias1)->(dbGoTop())

		If (_cAlias1)->(!Eof()) .And. (_cAlias1)->PRCMED>0

			aDados1[08]	:=  (_cAlias1)->PRCMED
			aDados1[09]	:=  (_cAlias1)->PRCMED*(cAliasQry)->QUANTID

		Else

			aDados1[08]	:=  (cAliasQRY)->PRECO
			aDados1[09]	:=  (cAliasQRY)->TOTAL

		EndIf		

		If ! Empty(cRef)
			aDados1[10]	:=  cRef
		EndIf
		aDados1[11]	:=  (cAliasQRY)->SOLICIT
		aDados1[12]	:=  (cAliasQRY)->CC
		aDados1[13]	:=  (cAliasQRY)->ZAPROV
		aDados1[14]	:=  (cAliasQRY)->PRCORC
		aDados1[15]	:=  dtoc(stod((cAliasQRY)->DTVLORC))

		oSection1:PrintLine()
		aFill(aDados1,nil)

		(cAliasQRY)->(DbSkip())
	EndDo

	oSection1:Finish()
	aFill(aDados1,nil)
	oReport:EndPage()
	If Select(cAliasQRY) > 0
		(cAliasQRY)->(dbCloseArea())
	EndIf

Return



/*/{Protheus.doc} fCriaSx1
Definicao dos parametros de pergunta
@author thiago.fonseca
@since 06/05/2016
@version 1.0
@param cPerg, character, (Descrição do parâmetro)
@return ${return}, ${return_description}
/*/

Static Function fCriaSx1(cPerg)

	Local aRegs:=	{}
	Local _i   := 0
	Local _j   := 0
	Local nTam := 0
	Local aHelpPor		:= {}

	aHelpPor	:= {}
	AAdd(aHelpPor ,"Data de emissão" )
	PutSx1(cPerg,"01","Emissão De        ","Emissão De        ","Emissão De        ","mv_ch1","D",8,0,0,"G","","SZ1","","","MV_PAR01","","","","","","","","","","","","","","","","",aHelpPor,,)

	aHelpPor	:= {}
	AAdd(aHelpPor ,"Data de emissão" )
	PutSx1(cPerg,"02","Emissão Até          ","Emissão Até          ","Emissão Até          ","mv_ch2","D",8,0,0,"G","","SZ1","","","MV_PAR02","","","","","","","","","","","","","","","","",aHelpPor,,)

	aHelpPor	:= {}
	AAdd(aHelpPor ,"Motivo da Compra" )
	PutSx1(cPerg,"03","Motivo De        ","Motivo De        ","Motivo De        ","mv_ch3","C",3,0,0,"G","","","","","MV_PAR03","","","","","","","","","","","","","","","","",aHelpPor,,)

	aHelpPor	:= {}
	AAdd(aHelpPor ,"Motivo da Compra" )
	PutSx1(cPerg,"04","Motivo Até          ","Motivo Até          ","Motivo Até          ","mv_ch4","C",3,0,0,"G","","","","","MV_PAR04","","","","","","","","","","","","","","","","",aHelpPor,,)


	aHelpPor	:= {}
	AAdd(aHelpPor ,"Numero da Solicitacao  " )
	PutSx1(cPerg,"05","Do Numero       ","Do Numero       ","Do Numero       ","mv_ch5","C",6,0,0,"G","","","","","MV_PAR05","","","","","","","","","","","","","","","","",aHelpPor,,)

	aHelpPor	:= {}
	AAdd(aHelpPor ,"Numero da Solicitacao  " )
	PutSx1(cPerg,"06","Até o Numero       ","Até o Numero  ","Até o Numero       ","mv_ch6","C",6,0,0,"G","","","","","MV_PAR06","","","","","","","","","","","","","","","","",aHelpPor,,)

	aHelpPor	:= {}
	AAdd(aHelpPor ,"Digite um hitorico de referencia  " )
	PutSx1(cPerg,"07","Referencia       ","Referencia  ","Referencia       ","mv_ch7","C",15,0,0,"G","","","","","MV_PAR07","","","","","","","","","","","","","","","","",aHelpPor,,)

	SX1->(dbSetOrder(1))
	nTam:= Len(SX1->X1_GRUPO)
	For _i:=1 to Len(aRegs)
		IF SX1->( !dbSeek( Padr(aRegs[_i,1],nTam)+aRegs[_i,2] ) )
			SX1->(RecLock("SX1", .T. ))
			For _j:=1 to SX1->(FCount())
				If _j <= Len(aRegs[_i])
					SX1->(FieldPut(_j,aRegs[_i,_j]))
				Endif
			Next _J
			SX1->(MsUnlock())
		ELSE
			SX1->(RecLock("SX1", .F. ))
			For _j:=1 to SX1->(FCount())
				if AllTrim(SX1->(Field(_j))) <> "X1_CNT01"
					If _j <= Len(aRegs[_i])
						SX1->(FieldPut(_j,aRegs[_i,_j]))
					Endif
				endif
			Next _J
			SX1->(MsUnlock())

		END
	NEXT _I
	Return


	/*/{Protheus.doc}SqlIn
	Retira caracteres especiais para clausula IN
	@author thiago.fonseca
	@since 14/10/2015
	@version 1.0
	@param cRet, character, (Descrição do parâmetro)
	@return _Result
	/*/
	#IFDEF TOP
User Function SqlIN(cRet)

	Local nX 	:=	0
	Local cNovo	:=	""

	For nX := 1 to Len(cRet)
		If SubStr(cRet,nX,1)$"0123456789"
			cNovo += SubStr(cRet,nX,1)
		Else
			If SubStr(cRet,nX+1,1)$"0123456789"
				cNovo := Alltrim(cNovo) + "','"
			Endif
		Endif
	Next
	cNovo	:= "('" + Alltrim(cNovo) + "')"

	Return(cNovo)
	#ENDIF


Static Function ATUULTPRC(_cFilial,_cProduto)

	Local _cQuery1 := ""

	_cQuery1 := " SELECT ROUND(PRECO/QTD,5) PRCMED
	_cQuery1 += " FROM (
	_cQuery1 += " SELECT SUM(C8_PRECO) PRECO, SUM(QTD) QTD
	_cQuery1 += " FROM (
	_cQuery1 += " SELECT C8_PRECO, 1 QTD
	_cQuery1 += " FROM "+RetSqlName("SC8")+" C8
	_cQuery1 += " INNER JOIN (
	_cQuery1 += " SELECT MAX(C8_NUM) COTACAO
	_cQuery1 += " FROM "+RetSqlName("SC8")+" C8
	_cQuery1 += " WHERE C8.D_E_L_E_T_=' ' AND C8_FILIAL='"+_cFilial+"' AND C8_PRODUTO='"+_cProduto+"' AND C8_XPORTAL='S' AND C8_PRECO>0
	_cQuery1 += " ) XXX
	_cQuery1 += " ON C8.C8_FILIAL='"+_cFilial+"' AND C8.C8_NUM=XXX.COTACAO AND C8.C8_PRODUTO='"+_cProduto+"' 
	_cQuery1 += " WHERE C8.D_E_L_E_T_=' ' AND C8_XPORTAL='S' AND C8_PRECO>0
	_cQuery1 += " ) XXX
	_cQuery1 += " ) ZZZ

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	If (_cAlias1)->(!Eof()) .And. (_cAlias1)->PRCMED>0

		(cAliasQry)->PRECO := (_cAlias1)->PRCMED
		(cAliasQry)->TOTAL := (cAliasQry)->PRECO*(cAliasQry)->QUANTID

	EndIf

Return()