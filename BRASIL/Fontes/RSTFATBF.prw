#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  RSTFATBF     บAutor  ณGIOVANI.ZAGO    บ Data ณ  16/05/18     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio de MOVIMENTA ESTOQUE			              	  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-----------------------------*
User Function RSTFATBF()
*-----------------------------*
	Local   oReport
	Private cPerg 		:= "RFATBF"
	Private cTime       := Time()
	Private cHora       := SUBSTR(cTime, 1, 2)
	Private cMinutos    := SUBSTR(cTime, 4, 2)
	Private cSegundos   := SUBSTR(cTime, 7, 2)
	Private cAliasLif   := cPerg+cHora+ cMinutos+cSegundos
	Private lXlsHeader  := .F.
	Private lXmlEndRow  := .F.
	Private cPergTit 	:= cAliasLif
	
	
	xPutSx1(cPerg, "01", "Produto de:"		,"Produto de:" 	 	,"Produto de:" 			,"mv_ch1","C"		,15			,0		,0		,"G",""	,'SB1' 	,"","","mv_par01","","","","","","","","","","","","","","","","")
	xPutSx1(cPerg, "02", "Produto Ate:"	,"Produto Ate:"  	,"Produto Ate:"			,"mv_ch2","C"		,15			,0		,0		,"G",""	,'SB1' 	,"","","mv_par02","","","","","","","","","","","","","","","","")
	xPutSx1(cPerg, "03", "Faturamento de:"		,"Da Emissao:"	 	,"Da Emissao:"			,"mv_ch3","D"   	,08      	,0     ,0     ,"G",""    ,""	 	,"","","mv_par03","","","","","","","","","","","","","","","","")
	xPutSx1(cPerg, "04", "Faturamento ate:"	,"At้ a Emissao:"		,"At้ a Emissao:" 		,"mv_ch4","D"   	,08      	,0     ,0     ,"G",""    ,""	 	,"","","mv_par04","","","","","","","","","","","","","","","","")
	xPutSx1(cPerg, "05", "Grupo de:"		,"Produto de:" 	 	,"Produto de:" 			,"mv_ch5","C"		,15			,0		,0		,"G",""	,'SBM' 	,"","","mv_par05","","","","","","","","","","","","","","","","")
	xPutSx1(cPerg, "06", "Grupo Ate:"	,"Produto Ate:"  	,"Produto Ate:"			,"mv_ch6","C"		,15			,0		,0		,"G",""	,'SBM' 	,"","","mv_par06","","","","","","","","","","","","","","","","")
	xPutSx1(cPerg   ,"07"  ,"Origem"      ,"Origem"      ,"Origem"      ,"mv_ch7"    ,"C"   ,01      ,0       ,0      ,"C" ,""    ,""    ,""     ,"S"  ,"mv_par07"    ,"Comprado"        ,""      ,""      ,""                   ,"Importado"        ,""        ,""      ,"Fabricado"    ,""      ,""      ,"Todos"               ,""      ,""      ,""    ,""      ,""      ,  ,  ,)
	
	
 
	oReport		:= ReportDef()
	
	oReport:PrintDialog()
	
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ReportDef    บAutor  ณGiovani Zago    บ Data ณ  04/07/15     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio MMG 							                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-----------------------------*
Static Function ReportDef()
	*-----------------------------*
	Local oReport
	Local oSection
	
	oReport := TReport():New(cPergTit,"RELATำRIO de MOVIMENTA ESTOQUE",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irแ imprimir um relat๓rio para anแlise dos MOVIMENTA ESTOQUE")
	
	Pergunte(cPerg,.T.)
	
	oSection := TRSection():New(oReport,"Relat๓rio de MOVIMENTA ESTOQUE",{"SUA"})
	
	
	TRCell():New(oSection,"01",,"PRODUTO"		,,06,.F.,)
	TRCell():New(oSection,"02",,"DESC."			,,06,.F.,)
	TRCell():New(oSection,"03",,"GRUPO" 		,,06,.F.,)
	TRCell():New(oSection,"04",,"DESCR." 		,,06,.F.,)
	TRCell():New(oSection,"05",,"ORIGEM"		,,06,.F.,)
	TRCell():New(oSection,"06",,"FMR" 		    ,,06,.F.,)
	TRCell():New(oSection,"07",,"QUANTIDADE"	,"@E 99,999,999.99",14)
	TRCell():New(oSection,"08",,"MES"		    ,,06,.F.,)
	
		
	oSection:SetHeaderSection(.t.)
	oSection:Setnofilter("SUA")
	
Return oReport
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ReportPrint  บAutor  ณGiovani Zago    บ Data ณ  04/07/15     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio MMG 							                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*------------------------------------*
Static Function ReportPrint(oReport)
	*------------------------------------*
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
	
	oReport:SetTitle("SUA")// Titulo do relat๓rio
	
	oReport:SetMeter(0)
	aFill(aDados,nil)
	aFill(aDados1,nil)
	oSection:Init()
	
	Processa({|| StQuery(  ) },"Compondo Relatorio")
	
	DbSelectArea(cAliasLif)
	(cAliasLif)->(DbGoTop())
	If  Select(cAliasLif) > 0
		
		While 	(cAliasLif)->(!Eof())
			
			aDados1[01]	:=  (cAliasLif)->D2_COD
			aDados1[02]	:=  (cAliasLif)->B1_DESC
			aDados1[03]	:=  (cAliasLif)->BM_GRUPO
			aDados1[04]	:=  (cAliasLif)->BM_DESC
			aDados1[05]	:=  (cAliasLif)->B1_CLAPROD
			aDados1[06]	:=	(cAliasLif)->B1_XFMR
			aDados1[07]	:= 	(cAliasLif)->D2_QUANT
			aDados1[08]	:= 	(cAliasLif)->D2_EMISSAO
			

			oSection1:PrintLine()
			aFill(aDados1,nil)
			(cAliasLif)->(dbskip())
		End
		
		(cAliasLif)->(dbCloseArea())
	EndIf
	oReport:SkipLine()
Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  StQuery      บAutor  ณGiovani Zago    บ Data ณ  04/07/15     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio MMG 							                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-----------------------------*
Static Function StQuery(_ccod)
	*-----------------------------*
	
	Local cQuery     := ' '
		
	cQuery += " 	SELECT
	cQuery += " D2_COD,B1_DESC,BM_GRUPO,BM_DESC,B1_CLAPROD,B1_XFMR,SUM(D2_QUANT) AS D2_QUANT,SUBSTR(D2_EMISSAO,5,2) AS D2_EMISSAO
	cQuery += "   FROM "+RetSqlName("SD2")+" SD2
	cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SF4")+")SF4
	cQuery += " ON SF4.D_E_L_E_T_ = ' '
	cQuery += " AND F4_CODIGO = D2_TES
	cQuery += " AND F4_ESTOQUE = 'S'

	cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SB1")+")SB1
	cQuery += " ON SB1.D_E_L_E_T_ = ' '
	cQuery += " AND B1_COD = D2_COD

	cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SBM")+")SBM
	cQuery += " ON SBM.D_E_L_E_T_ = ' '
	cQuery += " AND BM_GRUPO = B1_GRUPO

	cQuery += " WHERE SD2.D_E_L_E_T_ = ' '
	cQuery += " AND D2_FILIAL = '"+cFilAnt+"'
	cQuery += " AND D2_EMISSAO BETWEEN '"+ dtos(MV_PAR03)+"' AND '"+ dtos(MV_PAR04)+"'
	cQuery += " AND BM_GRUPO   BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'
	cQuery += " AND D2_COD     BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' AND D2_CLIENTE <> '033467'
	cQuery += " AND D2_LOCAL <> '60' "//Chamado 008290 - Everson Santana - Armazem de troca de nota 

	DO CASE
	CASE MV_PAR07=1
		_cClaprod := 'C'
	CASE MV_PAR07=2
		_cClaprod := 'I'
	CASE MV_PAR07=3
		_cClaprod := 'F'
	ENDCASE
	If !(MV_PAR07=4)
		cQuery += " AND B1_CLAPROD = '"+_cClaprod+"'
	Endif

	cQuery += " GROUP BY D2_COD,B1_DESC,BM_GRUPO,BM_DESC,B1_CLAPROD,B1_XFMR, SUBSTR(D2_EMISSAO,5,2)
	cQuery += " ORDER BY   D2_COD, SUBSTR(D2_EMISSAO,5,2)
	
	//MemoWrite( "C:\Temp\MRP\RSTFATBF.txt", cQuery )
	
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf
	
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
	
Return()

Static Function xPutSx1(cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,;
		cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,;
		cF3, cGrpSxg,cPyme,;
		cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,;
		cDef02,cDefSpa2,cDefEng2,;
		cDef03,cDefSpa3,cDefEng3,;
		cDef04,cDefSpa4,cDefEng4,;
		cDef05,cDefSpa5,cDefEng5,;
		aHelpPor,aHelpEng,aHelpSpa,cHelp)
	
	LOCAL aArea := GetArea()
	Local cKey
	Local lPort := .f.
	Local lSpa := .f.
	Local lIngl := .f.
	
	cKey := "P." + AllTrim( cGrupo ) + AllTrim( cOrdem ) + "."
	
	cPyme    := Iif( cPyme           == Nil, " ", cPyme          )
	cF3      := Iif( cF3           == NIl, " ", cF3          )
	cGrpSxg := Iif( cGrpSxg     == Nil, " ", cGrpSxg     )
	cCnt01   := Iif( cCnt01          == Nil, "" , cCnt01      )
	cHelp      := Iif( cHelp          == Nil, "" , cHelp          )
	
	dbSelectArea( "SX1" )
	dbSetOrder( 1 )
	
	// Ajusta o tamanho do grupo. Ajuste emergencial para valida็ใo dos fontes.
	// RFC - 15/03/2007
	cGrupo := PadR( cGrupo , Len( SX1->X1_GRUPO ) , " " )
	
	If !( DbSeek( cGrupo + cOrdem ))
		
		cPergunt:= If(! "?" $ cPergunt .And. ! Empty(cPergunt),Alltrim(cPergunt)+" ?",cPergunt)
		cPerSpa     := If(! "?" $ cPerSpa .And. ! Empty(cPerSpa) ,Alltrim(cPerSpa) +" ?",cPerSpa)
		cPerEng     := If(! "?" $ cPerEng .And. ! Empty(cPerEng) ,Alltrim(cPerEng) +" ?",cPerEng)
		/* Removido - 12/05/2023 - Nใo executa mais Recklock na X1 - Criar/alterar perguntas no configurador
		Reclock( "SX1" , .T. )
		
		Replace X1_GRUPO   With cGrupo
		Replace X1_ORDEM   With cOrdem
		Replace X1_PERGUNT With cPergunt
		Replace X1_PERSPA With cPerSpa
		Replace X1_PERENG With cPerEng
		Replace X1_VARIAVL With cVar
		Replace X1_TIPO    With cTipo
		Replace X1_TAMANHO With nTamanho
		Replace X1_DECIMAL With nDecimal
		Replace X1_PRESEL With nPresel
		Replace X1_GSC     With cGSC
		Replace X1_VALID   With cValid
		
		Replace X1_VAR01   With cVar01
		
		Replace X1_F3      With cF3
		Replace X1_GRPSXG With cGrpSxg
		
		If Fieldpos("X1_PYME") > 0
			If cPyme != Nil
				Replace X1_PYME With cPyme
			Endif
		Endif
		
		Replace X1_CNT01   With cCnt01
		If cGSC == "C"               // Mult Escolha
			Replace X1_DEF01   With cDef01
			Replace X1_DEFSPA1 With cDefSpa1
			Replace X1_DEFENG1 With cDefEng1
			
			Replace X1_DEF02   With cDef02
			Replace X1_DEFSPA2 With cDefSpa2
			Replace X1_DEFENG2 With cDefEng2
			
			Replace X1_DEF03   With cDef03
			Replace X1_DEFSPA3 With cDefSpa3
			Replace X1_DEFENG3 With cDefEng3
			
			Replace X1_DEF04   With cDef04
			Replace X1_DEFSPA4 With cDefSpa4
			Replace X1_DEFENG4 With cDefEng4
			
			Replace X1_DEF05   With cDef05
			Replace X1_DEFSPA5 With cDefSpa5
			Replace X1_DEFENG5 With cDefEng5
		Endif
		
		Replace X1_HELP With cHelp
		
		PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
		
		MsUnlock()
	Else
		
		lPort := ! "?" $ X1_PERGUNT .And. ! Empty(SX1->X1_PERGUNT)
		lSpa := ! "?" $ X1_PERSPA .And. ! Empty(SX1->X1_PERSPA)
		lIngl := ! "?" $ X1_PERENG .And. ! Empty(SX1->X1_PERENG)
		
		If lPort .Or. lSpa .Or. lIngl
			RecLock("SX1",.F.)
			If lPort
				SX1->X1_PERGUNT:= Alltrim(SX1->X1_PERGUNT)+" ?"
			EndIf
			If lSpa
				SX1->X1_PERSPA := Alltrim(SX1->X1_PERSPA) +" ?"
			EndIf
			If lIngl
				SX1->X1_PERENG := Alltrim(SX1->X1_PERENG) +" ?"
			EndIf
			SX1->(MsUnLock())
		EndIf*/
	Endif
	
	RestArea( aArea )
	
Return
