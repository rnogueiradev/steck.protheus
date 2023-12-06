#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STMNTR01	 ºAutor  ³Willian Borges     º Data ³  14/08/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatório utilizado para verificar os bens cadastrados      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function STMNTR01()
	
	Local oReport
	
	PutSx1("STMNTR01", "01","Familia de?" ,"","","mv_ch1","C",6,0,0,"C","","ST6","","","mv_par01","","","","","","","","","","","","","","","","")
	PutSx1("STMNTR01", "02","Familia ate?","","","mv_ch2","C",6,0,0,"C","","ST6","","","mv_par02","","","","","","","","","","","","","","","","")
	
	oReport		:= ReportDef()
	oReport		:PrintDialog()
	
Return

Static Function ReportDef()
	
	Local oReport
	Local oSection
	
	oReport := TReport():New("STMNTR01","RELATÓRIO DE CADASTRO DE BENS","STMNTR01",{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório de bens.")
	
	Pergunte("STMNTR01",.F.)
	
	oSection := TRSection():New(oReport,"CADASTRO DOS BENS",{"ST9"})
	
	TRCell():New(oSection,"FILIAL","ST9","FILIAL","@!",2)
	TRCell():New(oSection,"CODBEM","ST9","COD.BEM","@!",10)
	TRCell():New(oSection,"DESCRICAO","ST9","DESCRICAO","@!",60)
	TRCell():New(oSection,"MODELO","ST9","MODELO","@!",20)
	TRCell():New(oSection,"SERIE","ST9","SERIE","@!",30)
	TRCell():New(oSection,"FAMILIA","ST9","FAMILIA","@!",4)
	TRCell():New(oSection,"CHAPA","ST9","CHAPA","@!",10)
	TRCell():New(oSection,"CCUSTO","ST9","C.CUSTO","@!",10)
	TRCell():New(oSection,"DEPTO","ST9","DEPTO","@!",20)
	TRCell():New(oSection,"SETOR","ST9","SETOR","@!",20)
	TRCell():New(oSection,"STATUS","ST9","STATUS","@!",2)
	TRCell():New(oSection,"DETALHE","ST9","USUARIO","@!",40)
	TRCell():New(oSection,"DTULT","ST9","DT ULT INV","@!",10)
	
	oSection:SetHeaderSection(.T.)
	oSection:Setnofilter("ST9")
	
	
Return oReport

Static Function ReportPrint(oReport)
	
	Local oSection	:= oReport:Section(1)
	Local cQuery 	:= ""
	Local cAlias 	:= "QRYTEMP"
	Local aDados[13]
	Local _aDados	:= {}
	Local nX:= 0
	oSection:Cell("FILIAL"):SetBlock( { || aDados[1] } )
	oSection:Cell("CODBEM"):SetBlock( { || aDados[2] } )
	oSection:Cell("DESCRICAO"):SetBlock( { || aDados[3] } )
	oSection:Cell("MODELO"):SetBlock( { || aDados[4] } )
	oSection:Cell("SERIE"):SetBlock( { || aDados[5] } )
	oSection:Cell("FAMILIA"):SetBlock( { || aDados[6] } )
	oSection:Cell("CHAPA"):SetBlock( { || aDados[7] } )
	oSection:Cell("CCUSTO"):SetBlock( { || aDados[8] } )
	oSection:Cell("SETOR"):SetBlock( { || aDados[9] } )
	oSection:Cell("STATUS"):SetBlock( { || aDados[10] } )
	oSection:Cell("SETOR"):SetBlock( { || aDados[11] } )
	oSection:Cell("DTULT"):SetBlock( { || aDados[12] } )
	oSection:Cell("DETALHE"):SetBlock( { || aDados[13] } )
	
	
	oReport:SetTitle("CADASTROS DE BENS")// Titulo do relatório
	
	cQuery := " SELECT T9_FILIAL, T9_CODBEM, T9_NOME, T9_MODELO, T9_SERIE, T9_CODFAMI, T9_CHAPA, T9_CCUSTO, T9_XDESCL, T9_SITBEM, T9_XDESCL "
	cQuery += " ,T9_XDTINVE "
	cQuery += " ,(SELECT TB_DETALHE FROM "+RetSqlName("STB")+" TB WHERE TB.D_E_L_E_T_=' ' AND TB.TB_CODBEM=T9.T9_CODBEM AND TB.TB_FILIAL=T9.T9_FILIAL AND TB_CARACTE='001') AS DETALHE "
	cQuery += " FROM "+RetSqlName("ST9")+" T9 "
	cQuery += " WHERE T9.D_E_L_E_T_  = ' ' AND T9.T9_CODFAMI BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
	IF MV_PAR03 = 1
	cQuery += " AND T9.T9_XTI = 'S'
	ENDIF	
	cQuery += " ORDER BY T9_CODBEM "
	
	
	If !Empty(Select(cAlias))
		DbSelectArea(cAlias)
		(cAlias)->(dbCloseArea())
	Endif
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)
	
	oReport:SetMeter(0)
	aFill(aDados,nil)
	oSection:Init()
	
	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())
	
	While !(cAlias)->(Eof())
		
		_nPos	:= At("-",(cAlias)->T9_CODBEM)
		_nCod	:= Val(SubStr((cAlias)->T9_CODBEM,_nPos+1,20))
		
		Aadd(_aDados,{(cAlias)->T9_FILIAL,_nCod,(cAlias)->T9_CODBEM,(cAlias)->T9_NOME,(cAlias)->T9_MODELO,(cAlias)->T9_SERIE,(cAlias)->T9_CODFAMI,;
			(cAlias)->T9_CHAPA,(cAlias)->T9_CCUSTO,(cAlias)->T9_XDESCL,(cAlias)->T9_SITBEM,(cAlias)->T9_XDESCL,(cAlias)->T9_XDTINVE,(cAlias)->DETALHE})
		
		/*
		aDados[1]	:=	(cAlias)->T9_FILIAL
		aDados[2]	:=	(cAlias)->T9_CODBEM
		aDados[3]	:=	(cAlias)->T9_NOME
		aDados[4]	:=	(cAlias)->T9_MODELO
		aDados[5]	:=	(cAlias)->T9_SERIE
		aDados[6]	:=	(cAlias)->T9_CODFAMI
		aDados[7]	:=	(cAlias)->T9_CHAPA
		aDados[8]	:=	(cAlias)->T9_CCUSTO
		aDados[9]	:=	(cAlias)->T9_XDESCL
		oSection:PrintLine()
		aFill(aDados,nil)
		*/
		(cAlias)->(DbSkip())
		
	EndDo
	
	ASORT(_aDados,,,{|x,y|x[7]+STRZERO(x[2],3)<y[7]+STRZERO(y[2],3)})
	
	For nX:=1 to Len(_aDados)
		
		aDados[1]	:=	_aDados[nX][1]
		aDados[2]	:=	_aDados[nX][3]
		aDados[3]	:=	_aDados[nX][4]
		aDados[4]	:=	_aDados[nX][5]
		aDados[5]	:=	_aDados[nX][6]
		aDados[6]	:=	_aDados[nX][7]
		aDados[7]	:=	_aDados[nX][8]
		aDados[8]	:=	_aDados[nX][9]
		aDados[9]	:=	_aDados[nX][10]
		aDados[10]	:=	_aDados[nX][11]
		aDados[11]	:=	_aDados[nX][12]
		aDados[12]	:=	_aDados[nX][13]
		aDados[13]	:=	_aDados[nX][14]
		oSection:PrintLine()
		aFill(aDados,nil)
		
	Next
	
	DbSelectArea(cAlias)
	(cAlias)->(dbCloseArea())
	
Return oReport
