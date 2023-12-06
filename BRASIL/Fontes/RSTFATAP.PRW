#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"


/*/{Protheus.doc} RSTFATAP
(Consulta Pedidos Faturados)

@author jefferson.carlos
@since 24/03/2017
@version MP11

/*/

User Function RSTFATAP()
	
	Local   oReport
	Private cPerg 		:= "RFATAP"
	Private cTime        := Time()
	Private cHora        := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private lXlsHeader   := .F.
	Private lXmlEndRow   := .F.
	Private cPergTit 		:= cAliasLif
	
	
	PutSx1(cPerg, "01", "Da Emissao:"		,"Da Emissao:"	 	,"Da Emissao:"			,"mv_ch1","D"   	,08      	,0     ,0     ,"G",""    ,""	 	,"","","mv_par01","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "02", "Até a Emissao:"	,"Até a Emissao:"		,"Até a Emissao:" 		,"mv_ch2","D"   	,08      	,0     ,0     ,"G",""    ,""	 	,"","","mv_par02","","","","","","","","","","","","","","","","")
	
	
	oReport		:= ReportDef()
	oReport:PrintDialog()
	
Return



/*/{Protheus.doc} RSTFATAP
(Consulta Pedidos Faturados)

@author jefferson.carlos
@since 24/03/2017
@version MP11

/*/


Static Function ReportDef()
	
	Local oReport
	Local oSection
	
	oReport := TReport():New(cPergTit,"Consulta Pedidos Faturados",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório de Pedidos Faturados")
	
	Pergunte(cPerg,.T.)
	
	oSection := TRSection():New(oReport,"Consulta Pedidos Faturados",{"MOV"})
	
	
	
	TRCell():New(oSection,"01",,"FILIAL"			,,02,.F.,)
	TRCell():New(oSection,"02",,"PEDIDO"			,,06,.F.,)
	TRCell():New(oSection,"03",,"CLIENTE" 			,,06,.F.,)
	TRCell():New(oSection,"04",,"LOJA" 			,,02,.F.,)
	TRCell():New(oSection,"05",,"EMISSA0" 			,,08,.F.,)
	TRCell():New(oSection,"06",,"DT_CLIENTE"  	,,08,.F.,)
	TRCell():New(oSection,"07",,"NF" 			    ,,09,.F.,)
	TRCell():New(oSection,"08",,"ORDEM_CLI" 	    ,,10,.F.,)
	TRCell():New(oSection,"09",,"STATUS PEDIDO"	 ,,20,.F.,)
	
	
	
	oSection:SetHeaderSection(.t.)
	oSection:Setnofilter("MOV")
	
Return oReport


/*/{Protheus.doc} RSTFATAP
(Consulta Pedidos Faturados)

@author jefferson.carlos
@since 23/03/2017
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
	
	
	
	oReport:SetTitle("MOV")// Titulo do relatório
	
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
			aDados1[02]	:=  (cAliasLif)->PEDIDO
			aDados1[03]	:=  (cAliasLif)->CLIENTE
			aDados1[04]	:=  (cAliasLif)->LOJA
			aDados1[05]	:=  DTOC(STOD((cAliasLif)->EMISSAO))
			aDados1[06]	:=	DTOC(STOD((cAliasLif)->DT_CLIENTE))
			aDados1[07]	:= (cAliasLif)->NF
			aDados1[08]	:= 	(cAliasLif)->ORDEM_CLI
			aDados1[09]	:= (cAliasLif)->Status_Pedido
				
			
			
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




/*/{Protheus.doc}RSTFATAP
Gera Consulta no Banco de Dados

@since 23/03/2017
@version MP11
/*/



Static Function StQuery(_ccod)


	Local cQuery1     := ' '
	
	cQuery1+= " SELECT C5_FILIAL FILIAL,C5_NUM PEDIDO,C5_CLIENTE CLIENTE,C5_LOJACLI LOJA, C5_EMISSAO AS EMISSAO, C5_ZDTCLI DT_CLIENTE, C5_NOTA NF,  C5_XORDEM ORDEM_CLI,
   	cQuery1+= " CASE "
	cQuery1+= " WHEN C5_ZFATBLQ = '1' THEN 'Faturamento_Total' ELSE "
	cQuery1+= " CASE "
	cQuery1+= " WHEN C5_ZFATBLQ = '2' THEN 'Faturamento_Parcial' ELSE "
	cQuery1+= " CASE "
	cQuery1+= " WHEN C5_ZFATBLQ = '3' THEN 'Liberado_Financeiro' ELSE "
	cQuery1+= " ' 'END END END 
	cQuery1+= ' "Status_Pedido"
	cQuery1+= " FROM "+RetSqlName("SC5")+" SC5 "
	cQuery1+= " WHERE " 
	cQuery1+= " C5_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
	cQuery1+= " AND C5_FILIAL= '"+xFilial("SC5")+"'"
	cQuery1+= " AND D_E_L_E_T_=' ' "
	
		
	
	
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery1),cAliasLif)

Return()
	
	
	
	
	
