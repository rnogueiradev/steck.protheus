#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"
#Include "FWBROWSE.CH"
#Include "FwMvcDef.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  RSTFATAB     บAutor  ณRENATO.NOGUEIRA บ Data ณ  16/02/2016   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio de fatec		 				              	  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function RSTFATAB()

	Local   oReport
	Private cPerg 		:= "RFATAB"
	Private cTime       := Time()
	Private cHora       := Substr(cTime, 1, 2)
	Private cMinutos    := Substr(cTime, 4, 2)
	Private cSegundos   := Substr(cTime, 7, 2)
	Private cAliasLif   := cPerg + cHora + cMinutos + cSegundos
	Private lXlsHeader  := .F.
	Private lXmlEndRow  := .F.
	Private cPergTit 	:= cAliasLif
	Private aStatus		:= {}
	Private cFilPC1		:= ""

	PutSx1(cPerg, "01", "Da Emissao:"		,"Da Emissao:"	 	,"Da Emissao:"	 	,"mv_ch1","D",08,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "02", "At้ a Emissao:"	,"At้ a Emissao:"	,"At้ a Emissao:"	,"mv_ch2","D",08,0,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","")

	oReport	:= ReportDef()
	oReport:PrintDialog()

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ReportDef    บAutor  ณGiovani Zago    บ Data ณ  04/07/15     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio MMG 							                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function ReportDef()

	Local oReport
	Local oSection

	oReport := TReport():New(cPergTit,"Relat๓rio de FATEC",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irแ imprimir um relat๓rio de fatecs")

	Pergunte(cPerg,.T.)

	oSection := TRSection():New(oReport,"Relat๓rio de FATEC",{"PC1"})

	TRCell():New(oSection,"01",,"NUMERO"			,,06,.F.,)
	TRCell():New(oSection,"02",,"NOME"				,,40,.F.,)
	TRCell():New(oSection,"03",,"TOTAL" 			,"@E 99,999,999.99",14)
	TRCell():New(oSection,"04",,"MOTIVO" 			,,40,.F.,)
	TRCell():New(oSection,"05",,"JUSTIFICATIVA" 	,,500,.F.,)
	TRCell():New(oSection,"06",,"PEDIDO REP" 		,,06,.F.,)
	TRCell():New(oSection,"07",,"EMISSAO" 			,,10,.F.,)
	TRCell():New(oSection,"08",,"TOTAL PED" 		,"@E 99,999,999.99",14)
	TRCell():New(oSection,"09",,"DIGITACAO" 		,,10,.F.,)
	TRCell():New(oSection,"10",,"EMITENTE" 			,,20,.F.,)
	TRCell():New(oSection,"11",,"VENDEDOR" 			,,20,.F.,)
	TRCell():New(oSection,"12",,"COD CLIENTE"		,,20,.F.,)
	TRCell():New(oSection,"13",,"LOJA CLIENTE"		,,20,.F.,)

	oSection:SetHeaderSection(.t.)
	oSection:Setnofilter("PC1")

Return oReport

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ReportPrint  บAutor  ณGiovani Zago    บ Data ณ  04/07/15     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio MMG 							                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function ReportPrint(oReport)
	Local cVend1    := ""
	Local oSection	:= oReport:Section(1)
	Local oSection1	:= oReport:Section(1)
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

	oReport:SetTitle("PC1")// Titulo do relat๓rio

	oReport:SetMeter(0)
	aFill(aDados,Nil)
	aFill(aDados1,Nil)
	oSection:Init()

	//Processa({|| StQuery(  ) },"Compondo Relatorio")
	Processa({|| FilStPc1(  ),StQuery(  ) },"Compondo Relatorio")//Fun็ใo FilStPc1 adicionada por Eduardo Matias - 16/08/18
	// ------ Valdemir Rabelo Ticket: 20201110010334  11/11/2020
	dbSelectArea("PC2")
	PC2->( dbSetOrder(1) )		
	dbSelectArea("SF2")
	SF2->( dbSetOrder(1) )
	// ------------------
	DbSelectArea(cAliasLif)
	(cAliasLif)->( dbGoTop() )
	If  Select(cAliasLif) > 0
		While 	(cAliasLif)->( !Eof() )
			
			cVend1 := getVend((cAliasLif)->NUMERO)						// Valdemir Rabelo Ticket: 20201110010334  11/11/2020
			aDados1[01]	:=  (cAliasLif)->NUMERO
			aDados1[02]	:=  (cAliasLif)->NOME
			aDados1[03]	:=  (cAliasLif)->TOTAL
			aDados1[04]	:=  (cAliasLif)->MOTIVO
			aDados1[05]	:=  (cAliasLif)->JUSTIFICATIVA
			aDados1[06]	:=	(cAliasLif)->PEDIDOREP
			aDados1[07]	:= 	DtoC(StoD((cAliasLif)->EMISSAO))
			aDados1[08]	:= 	(cAliasLif)->TOTALPED
			aDados1[09]	:= 	DtoC(StoD((cAliasLif)->DIGITACAO))
			aDados1[10]	:= 	(cAliasLif)->PC1_ATENDE

			aDados1[11]	:= 	cVend1							// Valdemir Rabelo Ticket: 20201110010334  11/11/2020
			aDados1[12]	:= 	(cAliasLif)->PC1_CODCLI
			aDados1[13]	:= 	(cAliasLif)->PC1_LOJA
			oSection1:PrintLine()
			aFill(aDados1,Nil)
			(cAliasLif)->( dbskip() )
		End
		oSection1:PrintLine()
		aFill(aDados1,Nil)
		(cAliasLif)->( dbCloseArea() )
	EndIf
	
	oReport:SkipLine()
	
Return oReport


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  StQuery      บAutor  ณGiovani Zago    บ Data ณ  04/07/15     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio  							                  	  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function StQuery(_ccod)

	Local cQuery     := ' '

	cQuery := " SELECT * FROM (
	cQuery += " SELECT NUMERO, NOME, DIGITACAO, TOTAL, PC1_MOTIVO,  
	cQuery += " NVL((SELECT X5_DESCRI FROM " + RetSqlName("SX5") + " X5 WHERE X5.D_E_L_E_T_=' ' AND X5_TABELA='SK' AND X5_CHAVE=PC1_MOTIVO),' ') MOTIVO,  
	cQuery += " PC1_PEDREP PEDIDOREP,  
	cQuery += " (CASE WHEN F1_DTDIGIT<>' ' THEN F1_DTDIGIT ELSE PC1_DTOCOR END) EMISSAO, 
	cQuery += " NVL((SELECT SUM(C6_VALOR) FROM " + RetSqlName("SC6") + " C6 WHERE C6.D_E_L_E_T_=' ' AND C6_FILIAL='02' AND C6_NUM=PC1_PEDREP),0) TOTALPED,  
	cQuery += " REPLACE(NVL((SELECT YP_TEXTO FROM " + RetSqlName("SYP") + " YP WHERE YP.D_E_L_E_T_=' ' AND YP_CHAVE=PC1_CODOBS AND YP_SEQ='001')  ,''),'\13\10','') JUSTIFICATIVA,
	cQuery += " PC1_ATENDE, PC1_CODCLI, PC1_LOJA   
	cQuery += " FROM 
	cQuery += " ( 
	cQuery += " SELECT PC1_NUMERO NUMERO, NVL(PC1_NOMCLI,' ') NOME, NVL(F1_DTDIGIT,' ') F1_DTDIGIT, NVL(PC1_DTOCOR,' ') PC1_DTOCOR, 
	cQuery += " NVL(F1_DTDIGIT,' ') DIGITACAO, 
	cQuery += " NVL(SUM(D1_TOTAL),0) TOTAL, PC1_MOTIVO, PC1_PEDREP, PC1_CODOBS, PC1_ATENDE, PC1_CODCLI, PC1_LOJA
	cQuery += " FROM " + RetSqlName("PC1") + " PC1  
	cQuery += " LEFT JOIN " + RetSqlName("SD1") + " D1  ON PC1_NUMERO=D1_XFATEC AND D1.D_E_L_E_T_=' ' 
	cQuery += " LEFT JOIN " + RetSqlName("SF1") + " F1  ON D1_FILIAL=F1_FILIAL AND D1_DOC=F1_DOC AND D1_FORNECE=D1_FORNECE AND D1_LOJA=F1_LOJA AND F1.D_E_L_E_T_=' ' AND F1_TIPO='D'
	cQuery += " LEFT JOIN " + RetSqlName("SA1") + " A1  ON A1_COD=F1_FORNECE AND A1_LOJA=F1_LOJA  AND A1.D_E_L_E_T_=' ' 
	// Removido devido ao chamado: Valdemir Rabelo Ticket: 20201110010334  11/11/2020
	//cQuery += " LEFT JOIN " + RetSqlName("PC2") + " PC2 ON PC2_NFATEC=PC1_NUMERO AND PC2.D_E_L_E_T_=' '         
    //cQuery += " LEFT JOIN " + RetSqlName("SF2") + " F2  ON F2_DOC=PC2_NFORIG AND F2_SERIE=PC2_SERIE  AND F2.D_E_L_E_T_=' '
	cQuery += " WHERE PC1.D_E_L_E_T_=' ' 
	
	If !Empty(cFilPC1)
		cQuery += " AND PC1_STATUS IN "+cFilPC1+" " + CRLF
	EndIf   	
	
	cQuery += " GROUP BY PC1_NOMCLI, PC1_DTOCOR, F1_DTDIGIT, PC1_NUMERO, PC1_MOTIVO, PC1_PEDREP, PC1_CODOBS, PC1_ATENDE, PC1_CODCLI, PC1_LOJA
	cQuery += " )
	cQuery += " ) XXX
	cQuery += " WHERE EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'

	If Select(cAliasLif) > 0
		(cAliasLif)->( dbCloseArea() )
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return

/*
Descri็ใo: Fun็ใo utilizada para apresentar filtro de status utilizado no campo PC1_STATUS
Autor	 : Eduardo Matias 
Data	 : 16/08/18
*/

Static Function FilStPc1()

	Local aCoors  	:= 	MsAdvSize()
	Local aObjects	:=	{}
	Local lFiltra	:=	.F.
	Local lItem   	:= .T.
	Local nX
	Private aPosObj 

	aAdd( aObjects, {100,100, .T., .T. } )
	aInfo 	 := {aCoors[1],aCoors[2],aCoors[3],aCoors[4],2,2}
	aPosObj  := MsObjSize( aInfo, aObjects, .T. , .F. )

	aAdd(aStatus,{.F.,'0','Elaboracao'		})
	aAdd(aStatus,{.F.,'1','Aberto'			})
	aAdd(aStatus,{.F.,'2','Autorizado'		})
	aAdd(aStatus,{.F.,'3','Recebido'		})
	aAdd(aStatus,{.F.,'4','Atend. S/ Dev.'	})
	aAdd(aStatus,{.F.,'5','Encerrado'		})

	oDlg1 := MsDialog():New( aCoors[7],aCoors[7], (aCoors[6]/100)*50, (aCoors[5]/100)*35, "Steck - Filtro por Status",,,.F.,,CLR_BLACK,CLR_WHITE,,,.T.,,,.T. )

	oFWL := FWLayer():New()
	oFWL:Init(oDlg1,.F.)
	oFWL:AddLine("L1",75,.F.)
	oFWL:AddLine("L2",25,.F.)
	oFWL:AddCollumn("C1",100,.T.,"L1")
	oFWL:AddCollumn("C1",100,.T.,"L2")
	oFWL:AddWindow("C1","oDlg1",'Status'	,100,.F.,.F.,,"L1",{||})
	oFWL:AddWindow("C1","oDlg1",''			,100,.F.,.F.,,"L2",{||})
	oPan1:= oFWL:GetWinPanel("C1","oDlg1","L1")
	oPan2:= oFWL:GetWinPanel("C1","oDlg1","L2")

	DEFINE FWBROWSE oBrw01 DATA ARRAY ARRAY aStatus OF oPan1

	oBrw01:DisableConfig()
	oBrw01:DisableLocate()
	oBrw01:DisableReport()	
	oBrw01:AddMarkColumns({||If(aStatus[oBrw01:At()][1],'LBOK','LBNO')},{||If(aStatus[oBrw01:At()][1],aStatus[oBrw01:At()][1] := .F.,aStatus[oBrw01:At()][1] := .T.),oBrw01:Refresh(.T.)},{||lFiltra :=	.T.})

	ADD COLUMN oColumn    DATA    { || aStatus[oBrw01:At()][3] }   TITLE " " SIZE TamSx3("A1_COD")[1] DECIMAL 2 ALIGN 1 OF oBrw01

	ACTIVATE FWBROWSE oBrw01

	oBtn0:=TButton():New((aPosObj[1][3]/100)*01,(aPosObj[1][4]/100)*0.5,"Processa",oPan2,{||oDlg1:End()},250,10,,,.F.,.T.,.F.,,.F.,,,.F.)

	oDlg1:Activate(,,,.T.,,, )

	cFilPC1 := ""

	For nX := 1 To Len(aStatus)
		If aStatus[nX,01]
			If lItem
				lItem := .F.
				cFilPC1 := aStatus[nX,02]
			Else
				cFilPC1 += ";" + aStatus[nX,02]
			EndIf			
		EndIf		
	Next

	If !Empty(cFilPC1)
		cFilPC1 := FormatIn(cFilPC1,";")
	EndIf

Return

/*/{Protheus.doc} getVend
description
   Rotina que irแ retornar os vendedores relacionados Ticket: 20201110010334
@type function
@version 
@author Valdemir Jose
@since 11/11/2020
@param pNumero, param_type, param_description
@return return_type, return_description
/*/
Static Function getVend(pNumero)
	Local cRET      := ""
	Local cAliasTMP := "TPC1"
	Local cQry := "SELECT F2_VEND1, PC2_NFATEC FROM " + RetSqlName("PC2") + " B " + CRLF
 		  cQry += "INNER JOIN " + RetSqlName("SF2") + " F2 " + CRLF
   		  cQry += "ON f2_doc = pc2_nforig  " + CRLF
      	  cQry += "AND f2_serie = pc2_serie  " + CRLF
 		  cQry += "AND F2.d_e_l_e_t_ = ' '  " + CRLF
  		  cQry += "WHERE B.D_E_L_E_T_ = ' ' " + CRLF
 		  cQry += " AND b.PC2_NFATEC='"+pNumero+"' " + CRLF
 		  cQry += " AND F2.F2_FILIAL = '" +xFilial('SF2')+ "' " + CRLF
 		  cQry += "GROUP BY F2_VEND1, PC2_NFATEC " + CRLF

	if Select("TPC1") > 0
	   TPC1->( dbCloseArea() )
	endif 

	TcQuery cQry New Alias "TPC1"

	While TPC1->( !Eof() )
	    if Empty(cRET)
		   cRET := TPC1->F2_VEND1
		else 
		   if !(TPC1->F2_VEND1 $ cRET)
		   	  cRET += "/"+TPC1->F2_VEND1
		   endif 
		endif 
		TPC1->( dbSkip() )
	EndDo

	TPC1->( dbCloseArea() )

Return cRET