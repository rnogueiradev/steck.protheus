#Include 'Protheus.ch'
#Include "Rwmake.ch"
#Include "TopConn.ch"


/*/{Protheus.doc} RSTFAITC
(Consulta Cadastro de Obra)

@author jefferson.carlos
@since 21/04/2017
@version MP11

/*/

User Function RSTFAITC()
	
	Local   oReport
	Private cPerg 		:= "RFAITC"
	Private cTime        := Time()
	Private cHora        := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private lXlsHeader   := .F.
	Private lXmlEndRow   := .F.
	Private cPergTit 		:= cAliasLif
	
	
	PutSx1(cPerg, "01", "Da Area:"		,"Da Area:"	 	,"Da Area :"			,"mv_ch1","C"   	,06      	,0     ,0     ,"G",""    ,""	 	,"(existcpo('SA3',mv_par02)  .Or. Empty(mv_par02))","SA3","mv_par01","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "02", "At� Area:"	   , "At� Area:"		,"At� Area:" 		 	,"mv_ch2","C"   	,06      	,0     ,0     ,"G",""    ,""	 	,"","","mv_par02","","","","","","","","","","","","","","","","")
	
	
	oReport		:= ReportDef()
	oReport:PrintDialog()
	
Return



/*/{Protheus.doc} RSTFAITC
(Consulta Cadastro de Obra)

@author jefferson.carlos
@since 21/04/2017
@version MP11

/*/


Static Function ReportDef()
	
	Local oReport
	Local oSection
	
	oReport := TReport():New(cPergTit,"Consulta Obra ITC",cPerg,{|oReport| ReportPrint(oReport)},"Este programa ir� imprimir um relat�rio de Obras ITC")
	
	Pergunte(cPerg,.T.)
	
	oSection := TRSection():New(oReport,"Consulta Obra ITC",{"MOV"})
	
	
	
	TRCell():New(oSection,"01",,"FILIAL"			,,02,.F.,)
	TRCell():New(oSection,"02",,"CODIGO"			,,10,.F.,)
	TRCell():New(oSection,"03",,"OBRA" 			,,60,.F.,)
	TRCell():New(oSection,"04",,"ENDERE�O" 		,,60,.F.,)
	TRCell():New(oSection,"05",,"BAIRRO" 			,,70,.F.,)
	TRCell():New(oSection,"06",,"CIDADE"  			,,40,.F.,)
	TRCell():New(oSection,"07",,"AREA" 			,,06,.F.,)
	TRCell():New(oSection,"08",,"ESTAGIO" 			,,40,.F.,)
	TRCell():New(oSection,"09",,"INICIO"			,,08,.F.,)
	TRCell():New(oSection,"10",,"FASE"			   ,,30,.F.,)
	TRCell():New(oSection,"11",,"STATUS OBRA"	   ,,20,.F.,)
	TRCell():New(oSection,"12",,"CONTATO"	      ,,20,.F.,)
	TRCell():New(oSection,"13",,"EMPRESA"	 	  ,,20,.F.,)
	TRCell():New(oSection,"14",,"TELEFONE"	 	  ,,10,.F.,)
	TRCell():New(oSection,"15",,"E-MAIL"	 	  ,,30,.F.,)
	TRCell():New(oSection,"16",,"DT RETORNO" 	  ,,10,.F.,)
	
	oSection:SetHeaderSection(.t.)
	oSection:Setnofilter("MOV")
	
Return oReport


/*/{Protheus.doc} RSTFATAQ
(Consulta Movimenta��o de Estoque)

@author jefferson.carlos
@since 31/10/2016
@version MP11

/*/



Static Function ReportPrint(oReport)
	
	Local oSection	:= oReport:Section(1)
	Local oSection1	:= oReport:Section(1)
	Local nX		:= 0
	Local aDados[2]
	Local aDados1[99]
	
	oSection1:Cell("01") :SetBlock( { || aDados1[01] } )
	oSection1:Cell("02") :SetBlock( { || aDados1[02] } )
	oSection1:Cell("03") :SetBlock( { || aDados1[03] } )
	oSection1:Cell("04") :SetBlock( { || aDados1[04] } )
	oSection1:Cell("05") :SetBlock( { || aDados1[05] } )
	oSection1:Cell("06") :SetBlock( { || aDados1[06] } )
	oSection1:Cell("07") :SetBlock( { || aDados1[07] } )
	oSection1:Cell("08") :SetBlock( { || aDados1[08] } )
	oSection1:Cell("09") :SetBlock( { || aDados1[09] } )
	oSection1:Cell("10") :SetBlock( { || aDados1[10] } )
	oSection1:Cell("11") :SetBlock( { || aDados1[11] } )
	oSection1:Cell("12") :SetBlock( { || aDados1[12] } )
	oSection1:Cell("13") :SetBlock( { || aDados1[13] } )
	oSection1:Cell("14") :SetBlock( { || aDados1[14] } )
	oSection1:Cell("15") :SetBlock( { || aDados1[15] } )
	oSection1:Cell("16") :SetBlock( { || aDados1[15] } )
	
	oReport:SetTitle("MOV")// Titulo do relat�rio
	
	oReport:SetMeter(0)
	aFill(aDados,nil)
	aFill(aDados1,nil)
	oSection:Init()
	
	
	Processa({|| StQuery(  ) },"Compondo Relatorio")
	
	DbSelectArea(cAliasLif)
	(cAliasLif)->(DbGoTop())
	If  Select(cAliasLif) > 0
		
		While 	(cAliasLif)->(!Eof())
			
						
			aDados1[01]	:=  (cAliasLif)->FILIAL
			aDados1[02]	:=  (cAliasLif)->CODIGO
			aDados1[03]	:=  (cAliasLif)->OBRA                          //DTOC(STOD((cAliasLif)->DAT))
			aDados1[04]	:=  (cAliasLif)->ENDERECO
			aDados1[05]	:=  (cAliasLif)->BAIRRO
			aDados1[06]	:=	 (cAliasLif)->CIDADE
			aDados1[07]	:=  (cAliasLif)->AREA
			aDados1[08]	:= 	(cAliasLif)->ESTAGIO
			aDados1[09]	:=  DTOC(STOD((cAliasLif)->INICIO))
			aDados1[10]	:= 	(cAliasLif)->FASE
			aDados1[11]	:= 	(cAliasLif)->Status_Obra
			aDados1[12]	:= 	(cAliasLif)->CONTATO
			aDados1[13]	:= 	(cAliasLif)->FANT
			aDados1[14]	:= 	(cAliasLif)->TEL	
			aDados1[15]	:=  (cAliasLif)->MAIL
			aDados1[16]	:=  (cAliasLif)->DTRETO
			
			
			oSection1:PrintLine()
			aFill(aDados1,nil)
			(cAliasLif)->(dbskip())
		End
		
		oSection1:PrintLine()
		aFill(aDados1,nil)
		
		(cAliasLif)->(dbCloseArea())
	EndIf
	oReport:SkipLine()
Return oReport




/*/{Protheus.doc}RSTFAITC
Gera Consulta no Banco de Dados

@since 31/10/2016
@version MP11
/*/



Static Function StQuery(_ccod)


	Local cQuery1     := ' '
	
	cQuery1 += " SELECT ZZ5_FILIAL FILIAL, ZZ5_COD CODIGO, ZZ5_NOMEOB OBRA, ZZ5_ENDERE ENDERECO, ZZ5_BAIRRO BAIRRO, ZZ5_CIDADE CIDADE, ZZ5_AREA AREA,ZZ5_ESTAGI ESTAGIO, ZZ5_INICIO INICIO, ZZ5_FASE FASE,ZZ5_NOME CONTATO,ZZ5_NOFANT FANT,ZZ5_TEL1 TEL,ZZ5_EMAIL MAIL, ZZ5_DTRETO DTRETO, 
	cQuery1 += " CASE "
	cQuery1 += " WHEN ZZ5_STATUS = 'O' THEN 'Aguardando Visita' ELSE "
	cQuery1 += " CASE "
	cQuery1 += " WHEN ZZ5_STATUS = '1' THEN 'Somente Terreno' ELSE "
	cQuery1 += " CASE "
	cQuery1 += " WHEN ZZ5_STATUS = '2' THEN 'Limpeza Terreno' ELSE "
	cQuery1 += " CASE "
	cQuery1 += " WHEN ZZ5_STATUS = '3' THEN 'Stand         ' ELSE "
	cQuery1 += " CASE "
	cQuery1 += " WHEN ZZ5_STATUS = '4' THEN 'Fundacao' ELSE "
	cQuery1 += " CASE "
	cQuery1 += " WHEN ZZ5_STATUS = '5' THEN 'Em Construcao' ELSE "
	cQuery1 += " CASE "
	cQuery1 += " WHEN ZZ5_STATUS = '6' THEN 'Obra Parada' ELSE "
	cQuery1 += " CASE "
	cQuery1 += " WHEN ZZ5_STATUS = '7' THEN 'Obra Pronta' ELSE "
	cQuery1 += " CASE "
	cQuery1 += " WHEN ZZ5_STATUS = '8' THEN 'Outros' ELSE "
	cQuery1 += " CASE "
	cQuery1 += " WHEN ZZ5_STATUS = '9' THEN 'Finalizada' ELSE "
	cQuery1 += " ' 'END END END END END END END END END END
	cQuery1 += ' "Status_Obra"
	cQuery1 += " FROM "+RetSqlName("ZZ5")+" ZZ5 "
	cQuery1 += " WHERE "
	cQuery1 += " ZZ5_AREA BETWEEN '"+ MV_PAR01+"' AND '"+ MV_PAR02 +"' "
	cQuery1+= "  AND ZZ5_FILIAL= '"+xFilial("ZZ5")+"'"
	cQuery1+= "  AND D_E_L_E_T_=' ' "		
	
		
	
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery1),cAliasLif)

Return()
	
	
	
	
	



