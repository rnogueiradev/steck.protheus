#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RSTFAT35    ºAutor  ³Giovani Zago    º Data ³  10/07/13     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio de Lista de Preço                               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RSTFAT35()
	
	Local   oReport
	Private cPerg := "RFAT35"
	Private cTime           := Time()
	Private cHora           := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private lXlsHeader      := .f.
	Private lXmlEndRow      := .f.
	Private oGetDad                                                            //Inserido Jefferson Carlos 02/12/13
	
	Public n
	Public k            := 0
	Public aCols		:={}
	
	PutSx1( cPerg, "01","Grupo de?"   			,"","","mv_ch1","C",6,0,0,"G","","SBM","","","mv_par01","","","","","","","","","","","","","","","","")
	PutSx1( cPerg, "02","Grupo Até?"  			,"","","mv_ch2","C",6,0,0,"G","","SBM","","","mv_par02","","","","","","","","","","","","","","","","")
	PutSx1( cPerg, "03","Cliente(DISTRIBUIDOR)?","","","mv_ch3","C",6,0,0,"G","","SA1","","","mv_par03","","","","","","","","","","","","","","","","")
	PutSx1( cPerg, "04","Loja?"       			,"","","mv_ch4","C",2,0,0,"G","",""	  ,"","","mv_par04","","","","","","","","","","","","","","","","")
	PutSx1( cPerg, "05","Cond. Pag.?" 			,"","","mv_ch5","C",3,0,0,"G","","SE4_01","","","mv_par05","","","","","","","","","","","","","","","","")
	PutSx1( cPerg, "06","Obser."      			,"","","mv_ch6","C",99,0,0,"G","","","","","mv_par06","","","","","","","","","","","","","","","","")
	PutSx1( cPerg, "07","Tipo "       			,"","","mv_ch7","N",1,0,2,"C","","","","","mv_par07","Todos","","","","Lista","","","","","","","","","","","")
	PutSx1( cPerg, "08","Cliente(REVENDA)?"     ,"","","mv_ch8","C",6,0,0,"G","","SA1","","","mv_par08","","","","","","","","","","","","","","","","")
	PutSx1( cPerg, "09","Loja?"       			,"","","mv_ch9","C",2,0,0,"G","","","","","mv_par09","","","","","","","","","","","","","","","","")
	PutSx1( cPerg, "10","Cliente(MON.PAINEL)?"  ,"","","mv_chA","C",6,0,0,"G","","SA1","","","mv_par10","","","","","","","","","","","","","","","","")
	PutSx1( cPerg, "11","Loja?"       			,"","","mv_chB","C",2,0,0,"G","","","","","mv_par11","","","","","","","","","","","","","","","","")
	PutSx1( cPerg, "12","Cliente(CONSTRUTORA)?" ,"","","mv_chC","C",6,0,0,"G","","SA1","","","mv_par12","","","","","","","","","","","","","","","","")
	PutSx1( cPerg, "13","Loja?"       			,"","","mv_chD","C",2,0,0,"G","","","","","mv_par13","","","","","","","","","","","","","","","","")
	PutSx1( cPerg, "14","Cliente(INSTALADOR)?"  ,"","","mv_chE","C",6,0,0,"G","","SA1","","","mv_par14","","","","","","","","","","","","","","","","")
	PutSx1( cPerg, "15","Loja?"       			,"","","mv_chF","C",2,0,0,"G","","","","","mv_par15","","","","","","","","","","","","","","","","")
	PutSx1( cPerg, "16","Cliente(CONSUMIDOR)?"  ,"","","mv_chG","C",6,0,0,"G","","SA1","","","mv_par16","","","","","","","","","","","","","","","","")
	PutSx1( cPerg, "17","Loja?"       			,"","","mv_chH","C",2,0,0,"G","","","","","mv_par17","","","","","","","","","","","","","","","","")
	
	
	oReport		:= ReportDef()
	 oReport:PrintDialog()
	
Return

Static Function ReportDef()
	
	Local oReport
	Local oSection
	
	oReport := TReport():New(cAliasLif,"RELATÓRIO DE LISTA DE PREÇO",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório de Lista de Preço .")
	
	Pergunte(cPerg,.F.)
	
	oSection := TRSection():New(oReport,"Lista de Preço",{"DA1"})
	
	TRCell():New(oSection,"PRODUTO",,"PRODUTO",,20,.F.,)
	TRCell():New(oSection,"DESCRICAO",,"DESCRICAO",,20,.F.,)
	//TRCell():New(oSection,"GRUPO",,"GRUPO",,3,.F.,)
	//TRCell():New(oSection,"DESCR. GRUPO",,"DESCR. GRUPO",,20,.F.,)
	TRCell():New(oSection,"QTD.EMB.",,"QTD.EMB.","@E 999.99",6)
	TRCell():New(oSection,"CLAS.FISCAL",,"CLAS.FISCAL","@R 9999.99.99",11,.F.,)
	TRCell():New(oSection,"CST",,"CST",,3,.F.,)
	TRCell():New(oSection,"Prc.BASE",,"Prc.BASE","@E 99,999,999.99",14)
	TRCell():New(oSection,"%ICMS",,"%ICMS","@E 999.99",6)
	TRCell():New(oSection,"%DESC.",,"%DESC.","@E 999.99",6)
	TRCell():New(oSection,"PREÇO" ,,"PREÇO","@E 99,999,999.99",14)
	TRCell():New(oSection,"%IPI",,"%IPI","@E 999.99",6)
	TRCell():New(oSection,"IPI" ,,"IPI","@E 99,999,999.99",14)
	TRCell():New(oSection,"IVA",,"IVA","@E 999.99",6)
	TRCell():New(oSection,"ICMS ST",,"ICMS ST","@E 99,999,999.99",14)
	TRCell():New(oSection, "%ICMS ST",, "%ICMS ST","@E 999.99",6)
	TRCell():New(oSection,"DISTRIBUIDOR",,"DISTRIBUIDOR","@E 99,999,999.99",14)
	TRCell():New(oSection,"REVENDA",,"REVENDA","@E 99,999,999.99",14)
	TRCell():New(oSection,"D/R",,"D/R","@E 99,999,999.99",14)
	TRCell():New(oSection,"PAINEL",,"PAINEL","@E 99,999,999.99",14)
	TRCell():New(oSection,"D/P",,"D/P","@E 99,999,999.99",14)
	TRCell():New(oSection,"CONSTRUTORA",,"CONSTRUTORA","@E 99,999,999.99",14)
	TRCell():New(oSection,"D/CR",,"D/CR","@E 99,999,999.99",14)
	TRCell():New(oSection,"INSTALADOR",,"INSTALADOR","@E 99,999,999.99",14)
	TRCell():New(oSection,"D/I",,"D/I","@E 99,999,999.99",14)
	TRCell():New(oSection,"CONSUMIDOR",,"CONSUMIDOR","@E 99,999,999.99",14)
	TRCell():New(oSection,"D/C",,"D/C","@E 99,999,999.99",14)
	oSection:SetHeaderSection(.t.)
	oSection:Setnofilter("DA1")
	
Return oReport

Static Function ReportPrint(oReport)
	
	Local oSection	:= oReport:Section(1)
	Local oSection1	:= oReport:Section(1)
	Local nX			:= 0
	Local i			:= 0
	Local k			:= 0
	Local h			:= 0
	Local cQuery 	:= ""
	Local cAlias 		:= "QRYTEMP9"
	Local aDados[2]
	Local aDados1[27]
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
	Local	nPosCOMISS		    := 0
	Local _nPosDESC         := 0
	Local _cGrupProd        := ' '
	Private _aMonCols       := {}
	
	
	
	
	oSection1:Cell("PRODUTO")		:SetBlock( { || aDados1[01] } )
	oSection1:Cell("DESCRICAO")		:SetBlock( { || aDados1[02] } )
	//oSection1:Cell("GRUPO")			:SetBlock( { || aDados1[03] } )
	//oSection1:Cell("DESCR. GRUPO")	:SetBlock( { || aDados1[04] } )
	oSection1:Cell("QTD.EMB.")		:SetBlock( { || aDados1[05] } )
	oSection1:Cell("CLAS.FISCAL")	:SetBlock( { || aDados1[06] } )
	oSection1:Cell("CST")			:SetBlock( { || aDados1[07] } )
	oSection1:Cell("Prc.BASE")		:SetBlock( { || aDados1[08] } )
	oSection1:Cell("%ICMS")			:SetBlock( { || aDados1[09] } )
	oSection1:Cell("%DESC.")		:SetBlock( { || aDados1[10] } )
	oSection1:Cell("PREÇO")			:SetBlock( { || aDados1[11] } )
	oSection1:Cell("%IPI")			:SetBlock( { || aDados1[12] } )
	oSection1:Cell("IPI")			:SetBlock( { || aDados1[13] } )
	oSection1:Cell("IVA")			:SetBlock( { || aDados1[14] } )
	oSection1:Cell("ICMS ST")		:SetBlock( { || aDados1[15] } )
	oSection1:Cell("%ICMS ST")		:SetBlock( { || aDados1[16] } )
	oSection1:Cell("DISTRIBUIDOR")		:SetBlock( { || aDados1[17] } )
	oSection1:Cell("REVENDA")		:SetBlock( { || aDados1[18] } )
	oSection1:Cell("PAINEL")		:SetBlock( { || aDados1[19] } )
	oSection1:Cell("CONSTRUTORA")		:SetBlock( { || aDados1[20] } )
	oSection1:Cell("INSTALADOR")		:SetBlock( { || aDados1[21] } )
	oSection1:Cell("CONSUMIDOR")		:SetBlock( { || aDados1[22] } )
	oSection1:Cell("D/R")		:SetBlock( { || aDados1[23] } )
	oSection1:Cell("D/P")		:SetBlock( { || aDados1[24] } )
	oSection1:Cell("D/CR")		:SetBlock( { || aDados1[25] } )
	oSection1:Cell("D/I")		:SetBlock( { || aDados1[26] } )
	oSection1:Cell("D/C")		:SetBlock( { || aDados1[27] } )
	
	oReport:SetTitle("Lista de Preço")// Titulo do relatório
	
	
	
	
	
	oReport:SetMeter(0)
	aFill(aDados,nil)
	aFill(aDados1,nil)
	oSection:Init()
	
	For k:= 1 To 6
		strelquer()
		//strelFIS()
		rptstatus({|| xVALUSST('01') },"Compondo Relatorio")
		
		_nPosPrv  		:= aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_PRCVEN"})     // Preco de venda
		_nPosProd  		:= aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_PRODUTO"})    // Codigo do produto
		_nPosTes  		:= aScan(aHeader, {|x| Upper(AllTrim(x[2])) == 'TES'})     	// Valor Acrescimo Financeiro  _nPosTes
		nPValICMS		:= Ascan(aHeader,{|x| AllTrim(Upper(x[2]))	== "C6_ZVALICM"})			// Posicao do Valor do ICMS
		nPAliqICM  		:= Ascan(aHeader,{|x| AllTrim(Upper(x[2]))	== "C6_ZPICMS"})			// Posicao do Aliq. ICMS
		nPValICMSST		:= Ascan(aHeader,{|x| AllTrim(Upper(x[2]))	== "C6_ZVALIST"})			// Posicao do Valor do ICMS ST
		nPValIPI		:= Ascan(aHeader,{|x| AllTrim(Upper(x[2]))	== "C6_ZVALIPI"})			// Posicao do Valor do IPI
		nPosIpi		    := Ascan(aHeader,{|x| AllTrim(Upper(x[2]))	== "C6_ZIPI"})
		nPosList		:= Ascan(aHeader,{|x| AllTrim(Upper(x[2]))	== 'C6_PRCLIS'})
		_nPosDESC       := Ascan(aHeader,{|x| AllTrim(Upper(x[2]))	== 'C6_DESCRI'})
		_nPosDEXC		:= Ascan(aHeader,{|x| AllTrim(Upper(x[2]))	== 'C6_DESCONT'})
		nPosCOMISS		:= Ascan(aHeader,{|x| AllTrim(Upper(x[2]))	== "C6_COMISS"})
		
		
		
		For i:=1 To Len(Acols)
			
			
			dbSelectArea("SB1")
			SB1->(dbSetOrder(1))
			If SB1->(DbSeek(xFilial("SB1")+aCols[i][_nPosProd]))
				dbSelectArea("SBM")
				SBM->(DbSetOrder(1)) // Indice FILIAL + GRUPO
				SBM->(DbSeek(xFilial('SBM')+ SB1->B1_GRUPO))
				/*
				If _cGrupProd <> SB1->B1_GRUPO   .And. !Empty(Alltrim(_cGrupProd))
					_cGrupProd := SB1->B1_GRUPO
					oSection1:PrintLine()
					aFill(aDados1,nil)
					aDados1[01]	:='Grupo: '+alltrim(_cGrupProd)  +' - '+SBM->BM_DESC
					oSection1:PrintLine()
					aFill(aDados1,nil)
					
					oSection1:PrintLine()
					aFill(aDados1,nil)
					
				EndIf
				If 	Empty(Alltrim(_cGrupProd))
					aDados1[01]	:='Grupo: '+alltrim(_cGrupProd)  +' - '+SBM->BM_DESC
					oSection1:PrintLine()
					aFill(aDados1,nil)
					
					oSection1:PrintLine()
					aFill(aDados1,nil)
					_cGrupProd := SB1->B1_GRUPO
				EndIf
				*/
				dbSelectArea("SF4")
				SF4->(dbsetOrder(1))
				If	SF4->(DbSeek(xFilial("SF4")+ aCols[i,_nPosTES]))
					
					If 	aScan( _aMonCols, { |x| x[1] == aCols[i][_nPosProd] } ) == 0
						aadd(_aMonCols,{aCols[i][_nPosProd],;
							ALLTRIM(SB1->B1_DESC) ,;
							SB1->B1_QE,;
							Transform(SB1->B1_POSIPI,' @R 9999.99.99 '  ),;
							ALLTRIM(SB1->B1_ORIGEM),;
							ROUND(aCols[i][nPosList],2),;
							ROUND(aCols[i][nPAliqICM],2),;
							ROUND(aCols[i][_nPosDEXC],2),;
							ROUND(aCols[i][_nPosPrv],2),;
							Posicione('SF7',4,xFilial("SF7")+SB1->B1_GRTRIB+SA1->A1_GRPTRIB+SA1->A1_EST+aCols[i][_nPosDESC]  ,'F7_MARGEM'),;
							ROUND(aCols[i][nPosIpi],2)  ,;
							ROUND(aCols[i][nPValIPI],2) ,;
							ROUND(aCols[i][nPValICMSST],2),;
							ROUND(aCols[i][nPosCOMISS] ,2),;
							Round(aCols[i][_nPosPrv] +	aCols[i][nPValICMSST] +	aCols[i][nPValIPI] ,2)  ,;
							0,;//16
						0,;//17
						0,;//18
						0,;//19
						0})//20
					ElseIf aScan( _aMonCols, { |x| x[1] == aCols[i][_nPosProd] } ) > 0
						If k = 2
							_aMonCols[aScan( _aMonCols, { |x| x[1] == aCols[i][_nPosProd] } ),16] := Round(aCols[i][_nPosPrv] +	aCols[i][nPValICMSST] +	aCols[i][nPValIPI] ,2)
						ElseIf k = 3
							_aMonCols[aScan( _aMonCols, { |x| x[1] == aCols[i][_nPosProd] } ),17] := Round(aCols[i][_nPosPrv] +	aCols[i][nPValICMSST] +	aCols[i][nPValIPI] ,2)
							
						ElseIf k = 4
							_aMonCols[aScan( _aMonCols, { |x| x[1] == aCols[i][_nPosProd] } ),18] := Round(aCols[i][_nPosPrv] +	aCols[i][nPValICMSST] +	aCols[i][nPValIPI] ,2)
							
						ElseIf k = 5
							_aMonCols[aScan( _aMonCols, { |x| x[1] == aCols[i][_nPosProd] } ),19] := Round(aCols[i][_nPosPrv] +	aCols[i][nPValICMSST] +	aCols[i][nPValIPI] ,2)
							
						ElseIf k = 6
							_aMonCols[aScan( _aMonCols, { |x| x[1] == aCols[i][_nPosProd] } ),20] := Round(aCols[i][_nPosPrv] +	aCols[i][nPValICMSST] +	aCols[i][nPValIPI] ,2)
							
						EndIf
					EndIf
					/*
					aDados1[01]	:=	aCols[i][_nPosProd]
					aDados1[02]	:=	ALLTRIM(SB1->B1_DESC)
					aDados1[05]	:=	SB1->B1_QE
					aDados1[06]	:=  Transform(SB1->B1_POSIPI,' @R 9999.99.99 '  )
					aDados1[07]	:=	ALLTRIM(SB1->B1_ORIGEM)
					aDados1[08]	:=	ROUND(aCols[i][nPosList],2)
					aDados1[09]	:=  ROUND(aCols[i][nPAliqICM],2)
					aDados1[10]	:=	ROUND(aCols[i][_nPosDEXC],2)
					aDados1[11]	:=	ROUND(aCols[i][_nPosPrv],2)
					aDados1[14]	:=	Posicione('SF7',4,xFilial("SF7")+SB1->B1_GRTRIB+SA1->A1_GRPTRIB+SA1->A1_EST+aCols[i][_nPosDESC]  ,'F7_MARGEM')
					aDados1[12]	:= 	ROUND(aCols[i][nPosIpi],2)
					aDados1[13]	:=	ROUND(aCols[i][nPValIPI],2)
					aDados1[15]	:=	ROUND(aCols[i][nPValICMSST],2)
					aDados1[16]	:=	ROUND(aCols[i][nPosCOMISS] ,2)
					aDados1[17]	:=  Round(aCols[i][_nPosPrv] +	aCols[i][nPValICMSST] +	aCols[i][nPValIPI] ,2)
					
					
					
					
					oSection1:PrintLine()
					aFill(aDados1,nil)
					*/
				EndIf
			EndIf
		next i
		aCols:={}
	Next k
	
	For h:= 1 To len(_aMonCols)
		
		aDados1[01]	:=	_aMonCols[h,01]
		aDados1[02]	:=	_aMonCols[h,02]
		aDados1[05]	:=	_aMonCols[h,03]
		aDados1[06]	:=  _aMonCols[h,04]
		aDados1[07]	:=	_aMonCols[h,05]
		aDados1[08]	:=	_aMonCols[h,06]
		aDados1[09]	:= 	_aMonCols[h,07]
		aDados1[10]	:=	_aMonCols[h,08]
		aDados1[11]	:=	_aMonCols[h,09]
		aDados1[14]	:=	_aMonCols[h,10]
		aDados1[12]	:= 	_aMonCols[h,11]
		aDados1[13]	:=	_aMonCols[h,12]
		aDados1[15]	:=	_aMonCols[h,13]
		aDados1[16]	:=	_aMonCols[h,14]
		aDados1[17]	:=  _aMonCols[h,15]
		aDados1[18]	:= 	_aMonCols[h,16]
		aDados1[19]	:= 	_aMonCols[h,17]
		aDados1[20]	:= 	_aMonCols[h,18]
		aDados1[21]	:= 	_aMonCols[h,19]
		aDados1[22]	:= 	_aMonCols[h,20]
		
		aDados1[23]	:= 	((_aMonCols[h,16]*100)/_aMonCols[h,15])-100
		aDados1[24]	:= 	((_aMonCols[h,17]*100)/_aMonCols[h,15])-100
		aDados1[25]	:= 	((_aMonCols[h,18]*100)/_aMonCols[h,15])-100
		aDados1[26]	:= 	((_aMonCols[h,19]*100)/_aMonCols[h,15])-100
		aDados1[27]	:= 	((_aMonCols[h,20]*100)/_aMonCols[h,15])-100
		oSection1:PrintLine()
		aFill(aDados1,nil)
		
	next h
	
	
	oSection1:PrintLine()
	aFill(aDados1,nil)
	
	
	
	oReport:SkipLine()
	
	
	
	
	
	oSection1:PrintLine()
	aFill(aDados1,nil)
	
	
Return oReport


//SELECIONA OS PRODUTOS
Static Function strelquer()
	
	Local cQuery     := ' '
	
	
	cQuery := " SELECT DA1.DA1_CODPRO  ,DA1.DA1_PRCVEN ,SB1.B1_GRUPO  ,SB1.B1_DESC
	cQuery += " FROM "+RetSqlName("DA1")+" DA1 "
	
	cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SB1")+" ) SB1 "
	cQuery += " ON SB1.B1_COD = DA1.DA1_CODPRO
	cQuery += " AND SB1.D_E_L_E_T_ = ' '
	cQuery += " AND SB1.B1_TIPO = 'PA'
	cQuery += " AND SB1.B1_GRUPO BETWEEN  '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' "
	cQuery += " AND SB1.B1_FILIAL = '"+xFilial("SB1")+"'"
	cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SBM")+" ) SBM "
	cQuery += " ON SBM.BM_GRUPO =  SB1.B1_GRUPO
	cQuery += " AND SBM.D_E_L_E_T_ = ' '
	cQuery += " AND SBM.BM_FILIAL = '"+xFilial("SBM")+"'"
	if MV_PAR07 = 2
		cQuery += " WHERE DA1.DA1_XVISUA 	 = '1'
		cQuery += " AND DA1.D_E_L_E_T_     = ' '
	Else
		cQuery += " WHERE DA1.D_E_L_E_T_     = ' '
	EndIf
	cQuery += " AND DA1.DA1_FILIAL = '"+xFilial("DA1")+"'"
	cQuery += " AND DA1.DA1_CODTAB = '"+ ALLTRIM(GETMV("ST_TPRCFAT"))+"'"
	cQuery += " ORDER BY SB1.B1_GRUPO,SB1.B1_DESC
	
	
	
	
	
	cQuery := ChangeQuery(cQuery)
	
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf
	
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
	
Return()


*-----------------------------*
Static Function   xVALUSST(_cOper)
	*-----------------------------*
	Local _lRet   		:= .F.
	Local _nOld   		:= 1
	Local _nPosOper     := 0
	Local _nPosProd     := 0
	Local _nPosTES      := 0
	Local _nPosClas     := 0
	Local _nPosPrc    	:= 0
	Local _nPosDESC     := 0
	Local _nPosDEXC     := 0
	Local _nICMPAD	    :=_nICMPAD2 :=0
	Local _nDescPad		:=0
	Local _nPis 		:=0
	Local _nCofis		:=0
	Local _nIcms    	:= SA1->A1_CONTRIB
	Local _cEst			:= SA1->A1_EST
	Local _nOpcao 		:= 3
	Local _xAlias 		:= GetArea()
	Local aFields 		:= {}
	Local aCpoEnch		:= {}
	Local aTam  		:= {}
	Local aNoEnch		:= {"C5_NUM","C5_CLIENTE"}
	Local oDlg
	Local _cCodAut  	:= GetMv("ST_CODFIS",,'000000')
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Tipos das Opcoes						  ³
	//³ _nOpcao == 1 -> Incluir					  ³
	//³ _nOpcao == 2 -> Visualizar                ³
	//³ _nOpcao == 3 -> Alterar                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	Local bCampoSC5		:= { |nCPO| Field(nCPO) }
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Arrays de controle dos campos que deverao ser alterados  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local aCposAlt 		:= {}
	
	Local _nValAcre     := Posicione("SE4",1,xFilial("SE4")+MV_PAR05,"E4_XACRESC")
	Local _cTesOcide    := GetMv('ST_TESOCI',,'827/828/829/830/831')	//Giovani Zago 11/02/2014 Reajuste Amazonia Ocidental     (chamado 000161)
	Local _nCounx       := 0
	Local nCntFor := 0
	Local _ni:= 0
	Local i:= 0
	Public aHeader 		:= {}
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria variaveis M->????? da Enchoice                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ            c
	For nCntFor := 1 TO FCount()
		M->&(EVAL(bCampoSC5,nCntFor)) := FieldGet(nCntFor)
	Next nCntFor
	
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria aHeader e aCols da GetDados                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nUsado:=0
	
	
	//				  1-Campo    , 2-Tipo, 3-Tam	, 4-Dec	, 5-Titulo		, 6-Validacao  											, 7-ComboBox
	aTam := TamSX3("C6_PRODUTO")
	AAdd( aFields, { 'C6_PRODUTO', 'C'	, aTam[1]	, 0		, 'PRODUTO'		, " "													, ''				  					} )
	aTam := TamSX3('C6_DESCRI')
	AAdd( aFields, { 'C6_DESCRI' , 'C'	, aTam[1]	, 0		, 'DESCRIÇÃO'	, " "													, ''				  					} )
	aTam := TamSX3('C6_ITEM')
	AAdd( aFields, { 'C6_ITEM' 	 , 'C'	, aTam[1]	, 0		, 'ITEM	 '  	, " "													, ''				  					} )
	aTam := TamSX3('C6_OPER')
	AAdd( aFields, { 'TPOPER'	 , 'C'	, aTam[1]   , 0		, 'Tp.Oper.	 ' 	, " "				   									, ''				   					} )
	aTam := TamSX3('C6_TES')
	AAdd( aFields, { 'TES'	     , 'C'	, aTam[1]   , 0		, 'TES	 ' 		, " "				   									, ''				   					} )
	aTam := TamSX3("C6_CF")
	AAdd( aFields, { 'CFOP' 	 , 'C'	, aTam[1]   , 0		, 'Cod. Fiscal'	, " "	  							   					, ''  									} )
	aTam := TamSX3("C6_CLASFIS")
	AAdd( aFields, { 'CLASSI' 	 , 'C'	, aTam[1]   , 0		, 'Sit. Trib.'	, " "	  							   					, ''  									} )
	AAdd( aFields, { 'RECNO' 	 , 'N'	, 20   		, 0		, 'RECNO'   	, " "	  							   					, ''  									} )
	AAdd( aFields, { 'C6_PRCVEN'  , 'N'	, 14   	, 0		, 'PRECO'   	, " "	  							   					, ''  									} )
	AAdd( aFields, { 'C6_PRCLIS'  , 'N'	, 14   	, 0		, 'PRECOLIST'   	, " "	  							   					, ''  									} )
	AAdd( aFields, { 'C6_ZVALICM'  , 'N'	, 14   	, 0		, 'VALICM'   	, " "	  							   					, ''  									} )
	AAdd( aFields, { "C6_ZPICMS"  , 'N'	, 14   	, 0		, 'ICMPOR'   	, " "	  							   					, ''  									} )
	AAdd( aFields, { "C6_ZVALIST"  , 'N'	, 14   	, 0		, 'ICMSST'   	, " "	  							   					, ''  									} )
	AAdd( aFields, { "C6_ZVALIPI"  , 'N'	, 14   	, 0		, 'VALIPI'   	, " "	  							   					, ''  									} )
	AAdd( aFields, { "C6_ZIPI"  , 'N'	, 14   	, 0		, 'IPIPOR'   	, " "	  							   					, ''  									} )
	AAdd( aFields, { "BM_DESC"  , 'C'	, 20   	, 0		, 'DESC'   	, " "	  							   					, ''  									} )
	AAdd( aFields, { 'C6_DESCONT'  , 'N'	, 14   	, 0		, 'C6DESC'   	, " "	  							   					, ''  									} )
	AAdd( aFields, { 'C6_COMISS'  , 'N'	, 14   	, 0		, 'C6_COMISS'   	, " "	  							   					, ''  									} )
	
	
	aHeader := {}	// Monta Cabecalho do aHeader. A ordem dos elementos devem obedecer a sequencia da estrutura dos campos logo acima. aFields[0,6]
	// 	01-Titulo			   			        , 02-Campo		, 03-Picture, 04-Tamanho	, 05-Decimal, 06-Valid		, 07-Usado	, 08-Tipo		, 09-F3		, 10-Contexto	, 11-ComboBox	, 12-Relacao	, 13-When		  , 14-Visual	, 15-Valid Usuario
	aAdd( aHeader, {	aFields[01,5]+Space(20)	, aFields[01,1]	, '@!'		, aFields[01,3]	, 0			, aFields[01,6]	, ''		, aFields[01,2]	, ''		, 'R'			, aFields[01,7]	, ''			, ''   			  , 'V'		, ''				} )
	aAdd( aHeader, {	aFields[02,5]+Space(20)	, aFields[02,1]	, '@!'		, aFields[02,3]	, 0			, aFields[02,6]	, ''		, aFields[02,2]	, ''		, 'R'			, aFields[02,7]	, ''			, ''  			  , 'V'		, ''				} )
	aAdd( aHeader, {	aFields[03,5]+Space(20)	, aFields[03,1]	, '@!'		, aFields[03,3]	, 0			, aFields[03,6]	, ''		, aFields[03,2]	, ''		, 'R'			, aFields[03,7]	, ''			, '' 			  , 'V'		, ''				} )
	aAdd( aHeader, {	aFields[04,5]+Space(20)	, aFields[04,1]	, '@!'		, aFields[04,3]	, 0			, aFields[04,6]	, ''		, aFields[04,2]	, 'DJ'		, 'R'			, aFields[04,7]	, ''			, 'U_STRWHENOPE()', ''		, 'U_VALUSST(M->TPOPER)'				} )
	aAdd( aHeader, {	aFields[05,5]+Space(20)	, aFields[05,1]	, '@!'		, aFields[05,3]	, 0			, aFields[05,6]	, ''		, aFields[05,2]	, 'SF4'		, 'R'			, aFields[05,7]	, ''			, ''			  , ''		, ''				} )
	aAdd( aHeader, {	aFields[06,5]+Space(20)	, aFields[06,1]	, '@!'		, aFields[06,3]	, 0			, aFields[06,6]	, ''		, aFields[06,2]	, '13'		, 'R'			, aFields[06,7]	, ''			, ''			  , ''		, ''				} )
	aAdd( aHeader, {	aFields[07,5]+Space(20)	, aFields[07,1]	, '@!'		, aFields[07,3]	, 0			, aFields[07,6]	, ''		, aFields[07,2]	, ''		, 'R'			, aFields[07,7]	, ''			, ''			  , ''		, ''				} )
	aAdd( aHeader, {	aFields[08,5]+Space(20)	, aFields[08,1]	, ''		, aFields[08,3]	, 0			, aFields[08,6]	, ''		, aFields[08,2]	, ''		, 'R'			, aFields[08,7]	, ''			, '.F.'			  , 'V'		, ''				} )
	aAdd( aHeader, {	aFields[09,5]+Space(20)	, aFields[09,1]	, '@E 999,999,999.99'		, aFields[09,3]	, 0			, aFields[09,6]	, ''		, aFields[09,2]	, ''		, 'R'			, aFields[09,7]	, ''			, '.F.'			  , 'V'		, ''				} )
	aAdd( aHeader, {	aFields[10,5]+Space(20)	, aFields[10,1]	, '@E 999,999,999.99'		, aFields[10,3]	, 0			, aFields[10,6]	, ''		, aFields[10,2]	, ''		, 'R'			, aFields[10,7]	, ''			, '.F.'			  , 'V'		, ''				} )
	aAdd( aHeader, {	aFields[11,5]+Space(20)	, aFields[11,1]	, '@E 999,999,999.99'		, aFields[11,3]	, 0			, aFields[11,6]	, ''		, aFields[11,2]	, ''		, 'R'			, aFields[11,7]	, ''			, '.F.'			  , 'V'		, ''				} )
	aAdd( aHeader, {	aFields[12,5]+Space(20)	, aFields[12,1]	, '@E 999,999,999.99'		, aFields[12,3]	, 0			, aFields[12,6]	, ''		, aFields[12,2]	, ''		, 'R'			, aFields[12,7]	, ''			, '.F.'			  , 'V'		, ''				} )
	aAdd( aHeader, {	aFields[13,5]+Space(20)	, aFields[13,1]	, '@E 999,999,999.99'		, aFields[13,3]	, 0			, aFields[13,6]	, ''		, aFields[13,2]	, ''		, 'R'			, aFields[13,7]	, ''			, '.F.'			  , 'V'		, ''				} )
	aAdd( aHeader, {	aFields[14,5]+Space(20)	, aFields[14,1]	, '@E 999,999,999.99'		, aFields[14,3]	, 0			, aFields[14,6]	, ''		, aFields[14,2]	, ''		, 'R'			, aFields[14,7]	, ''			, '.F.'			  , 'V'		, ''				} )
	aAdd( aHeader, {	aFields[15,5]+Space(20)	, aFields[15,1]	, '@E 999,999,999.99'		, aFields[15,3]	, 0			, aFields[15,6]	, ''		, aFields[15,2]	, ''		, 'R'			, aFields[15,7]	, ''			, '.F.'			  , 'V'		, ''				} )
	aAdd( aHeader, {	aFields[16,5]+Space(20)	, aFields[16,1]	, '@!'		, aFields[16,3]	, 0			, aFields[16,6]	, ''		, aFields[16,2]	, ''		, 'R'			, aFields[16,7]	, ''			, ''			  , ''		, ''				} )
	aAdd( aHeader, {	aFields[17,5]+Space(20)	, aFields[17,1]	, '@E 999,999,999.99'		, aFields[17,3]	, 0			, aFields[17,6]	, ''		, aFields[17,2]	, ''		, 'R'			, aFields[17,7]	, ''			, '.F.'			  , 'V'		, ''				} )
	aAdd( aHeader, {	aFields[18,5]+Space(20)	, aFields[18,1]	, '@E 999,999,999.99'		, aFields[18,3]	, 0			, aFields[18,6]	, ''		, aFields[18,2]	, ''		, 'R'			, aFields[18,7]	, ''			, '.F.'			  , 'V'		, ''				} )
	
	
	nUsado:=len(aHeader)
	aCols:={}
	dbSelectArea(cAliasLif)
	(cAliasLif)->(dbgotop())
	If  Select(cAliasLif) > 0
		
		While 	(cAliasLif)->(!Eof())
			
			
			AADD(aCols,Array(nUsado+1))
			For _ni:=1 to nUsado
				If aHeader[_ni,2] = 'TES'
					aCols[Len(aCols),_ni]:=""
				ElseIf aHeader[_ni,2] = 'CFOP'
					aCols[Len(aCols),_ni]:=""
				ElseIf aHeader[_ni,2] = 'TPOPER'
					aCols[Len(aCols),_ni]:=""
				ElseIf aHeader[_ni,2] = 'CLASSI'
					aCols[Len(aCols),_ni]:=""
				ElseIf aHeader[_ni,2] = 'RECNO'
					aCols[Len(aCols),_ni]:=0
				ElseIf aHeader[_ni,2] = 'C6_PRODUTO'
					aCols[Len(aCols),_ni]:=	(cAliasLif)->DA1_CODPROD
				ElseIf aHeader[_ni,2] = 'C6_PRCVEN'
					aCols[Len(aCols),_ni]:=	(cAliasLif)->DA1_PRCVEN
				ElseIf aHeader[_ni,2] = 'C6_PRCLIS'
					aCols[Len(aCols),_ni]:=	(cAliasLif)->DA1_PRCVEN
				EndIf
			Next
			aCols[Len(aCols),nUsado+1]:=.F.
			
			(cAliasLif)->(dbskip())
			
		End
		
		M->C5_TIPO    := 'C'
		If k = 1
			M->C5_CLIENTE := MV_PAR03
			M->C5_LOJACLI := MV_PAR04
			msginfo('DISTRIBUIDOR')
		ElseIf  k = 2
			M->C5_CLIENTE := MV_PAR08
			M->C5_LOJACLI := MV_PAR09
			msginfo("REVENDA")
		ElseIf  k = 3
			M->C5_CLIENTE := MV_PAR10
			M->C5_LOJACLI := MV_PAR11
			msginfo("PAINEL")
		ElseIf  k = 4
			M->C5_CLIENTE := MV_PAR12
			M->C5_LOJACLI := MV_PAR13
			msginfo("CONSTRUTORA")
		ElseIf  k = 5
			M->C5_CLIENTE := MV_PAR14
			M->C5_LOJACLI := MV_PAR15
			msginfo("INSTALADOR")
		ElseIf  k = 6
			M->C5_CLIENTE := MV_PAR16
			M->C5_LOJACLI := MV_PAR17
			msginfo("CONSUMIDOR")
		EndIf
		
		
		DbSelectArea("SA1")
		SA1->(dbSetOrder(1))
		SA1->(DbSeek(xFilial("SA1")+ M->C5_CLIENTE + M->C5_LOJACLI ))
		M->C5_TIPOCLI := SA1->A1_TIPO
		M->C5_ZCONSUM := ''
		M->C5_TIPO    := 'N'
		M->C5_XCONDPG := MV_PAR05
		U_STTESTEL()
		
		DbSelectArea("SA1")
		SA1->(dbSetOrder(1))
		SA1->(DbSeek(xFilial("SA1")+ M->C5_CLIENTE + M->C5_LOJACLI ))
		
		_nIcms    	:= SA1->A1_CONTRIB
		_cEst		:= SA1->A1_EST
		
	EndIf
	
	
	_nPosOper     := aScan(aHeader, { |x| Alltrim(x[2]) == 'TPOPER'    })
	_nPosProd     := aScan(aHeader, { |x| Alltrim(x[2]) == 'C6_PRODUTO'    })
	_nPosTES      := aScan(aHeader, { |x| Alltrim(x[2]) == 'TES'    })
	_nPosClas     := aScan(aHeader, { |x| Alltrim(x[2]) == 'CLASSI'    })
	_nPosPrc      := aScan(aHeader, { |x| Alltrim(x[2]) == 'C6_PRCVEN'    })
	_nPosDESC     := aScan(aHeader, { |x| Alltrim(x[2]) == 'C6_DESCRI'    })
	_nPosDEXC     := aScan(aHeader, { |x| Alltrim(x[2]) == 'C6_DESCONT'    })
	SetRegua(Len(Acols))
	
	For i:=1 To Len(Acols)
		IncRegua( "Analisando Produto: "+aCols[i,_nPosProd] )
		n:=i
		aCols[i,_nPosOper]:= _cOper
		u_STTESINTELIGENTE()
		
		dbSelectArea("SB1")
		SB1->(dbSetOrder(1))
		If SB1->(DbSeek(xFilial("SB1")+aCols[i][_nPosProd]))
			dbSelectArea("SBM")
			SBM->(DbSetOrder(1)) // Indice FILIAL + GRUPO
			SBM->(DbSeek(xFilial('SBM')+ SB1->B1_GRUPO))
			dbSelectArea("SF4")
			SF4->(dbsetOrder(1))
			If	SF4->(DbSeek(xFilial("SF4")+ aCols[i,_nPosTES]))
				aCols[i][_nPosClas]:=SB1->B1_ORIGEM+SF4->F4_SITTRIB
			EndIf
			aCols[i][_nPosDEXC]:=	u_STGAP01()
			aCols[i][_nPosPrc]:=  round(aCols[i][_nPosPrc]-(aCols[i][_nPosPrc]*(aCols[i][_nPosDEXC]/100)),2)    //regra de desconto
			
			//__usei a rotina do donizete ____________________________________________________________________________________________________________________
			nPrcVen := aCols[n,_nPosPrc]
			_nICMPAD2:= xMafis()//busca o icms do cliente/produto para aplicar o diferencial
			
			If cEmpAnt == '01'//STECK SAO PAULO
				_nICMPAD  	:= SuperGetMv("MV_ICMPAD",,"") // Parâmetro com ICMS da Empresa dentro do Estado
			Else
				_nICMPAD  	:= 18
			Endif
			
			IF  _nIcms == "1" //Calcula o somente quando o cliente é Contribuinte = 1
				IF SA1->A1_ZDIFPC == "1" // Diferencial de PIS/Cofins
					IIF (_nPis 		== 0,_nPis		:=SuperGetMv("MV_TXPIS"  ,,""),)
					IIF (_nCofins 	== 0,_nCofins	:=SuperGetMv("MV_TXCOFIN",,""),)
				//	_nDescPad	:= (1-((100 - (_nICMPAD+_nPis+_nCofins))/((100 -_nICMPAD2) +_nPis+_nCofis)))*100   // Ex. SP: (1-((100-18+1.65+7.60)/(100-(12+1.65+7.60))))*100
					_nDescPad	:=  (1-((100 - (_nICMPAD+_nPis+_nCofins))/(100-(_nICMPAD2+_nPis+_nCofins))))*100
				else
					_nDescPad	:= (1-((100 - _nICMPAD)/(100 - _nICMPAD2 )))*100   // (1-((100-18)/(100-12)))*100
				Endif
			EndIf
			
			// Calcula o desconto somente quando o cliente é Contribuinte = 1 e Estado Diferente de SP
			if  _nIcms == "1" .and. _cEst != "SP"
				_nDescUnit:= nPrcVen * ( _nDescPad/100)
			else
				_nDescUnit:=0
			Endif
			
			
			aCols[i][_nPosPrc]:=	ROUND(aCols[n,_nPosPrc] - _nDescUnit,2)
			
			aCols[i][_nPosPrc]:= round(aCols[i][_nPosPrc]+(aCols[i][_nPosPrc]*(_nValAcre/100)),2)
			
			aCols[i][_nPosDESC]:=   M->C5_TIPOCLI
			If  aCols[i,_nPosTES]  $  _cTesOcide
				aCols[i][_nPosPrc]:= OciPreco(aCols[i][_nPosPrc])
			EndIf
			
			
			
			xretmafis()
			
			//________________________________________________________________________________________________________________________
		EndIf
		
		
		
	Next i
	n:= _nOld
	_lRet   := .T.
	
Return  ()

*-----------------------------*
Static Function xMafis()
	*-----------------------------*
	
	Local _nPosPrv  	:= aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_PRCVEN"})     // Preco de venda
	Local _nPosProd  	:= aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_PRODUTO"})    // Codigo do produto
	Local _nPosTes  	:= aScan(aHeader, {|x| Upper(AllTrim(x[2])) == 'TES'})     	// Valor Acrescimo Financeiro  _nPosTes
	Local _nTotPed 		:= 0
	Local nAliqICM 		:= 0
	Local nValICms		:= 0
	Local nCnt 			:= 0
	Local nAliqIPI 		:= 0
	Local nValIPI 		:= 0
	Local nValICMSST 	:= 0
	Local nValPis		:= 0
	Local nValCof		:= 0
	
	MaFisSave()
	MaFisEnd()
	MaFisIni(M->C5_CLIENTE,;// 1-Codigo Cliente/Fornecedor
	M->C5_LOJACLI,;		// 2-Loja do Cliente/Fornecedor
	IIf(M->C5_TIPO$'DB',"F","C"),;				// 3-C:Cliente , F:Fornecedor
	M->C5_TIPO,;				// 4-Tipo da NF
	M->C5_TIPOCLI,;		// 5-Tipo do Cliente/Fornecedor
	Nil,;
		Nil,;
		Nil,;
		Nil,;
		"MATA461")
	
	MaFisAdd(aCols[n,_nPosProd],;                                                     // 1-Codigo do Produto ( Obrigatorio )
	aCols[n,_nPosTes],;                                                                           // 2-Codigo do TES ( Opcional )
	1,;                                                           // 3-Quantidade ( Obrigatorio )
	aCols[n,_nPosPrv],;                                                            // 4-Preco Unitario ( Obrigatorio )
	0,;                // 5-Valor do Desconto ( Opcional )
	,;                                                                                                                             // 6-Numero da NF Original ( Devolucao/Benef )
	,;                                                                                                                             // 7-Serie da NF Original ( Devolucao/Benef )
	,;                                                                                          // 8-RecNo da NF Original no arq SD1/SD2
	0,;                                                                                                           // 9-Valor do Frete do Item ( Opcional )
	0,;                                                                                                           // 10-Valor da Despesa do item ( Opcional )
	0,;                                                                           // 11-Valor do Seguro do item ( Opcional )
	0,;                                                                                                           // 12-Valor do Frete Autonomo ( Opcional )
	aCols[n,_nPosPrv],;// 13-Valor da Mercadoria ( Obrigatorio )
	0,;                                                                                                           // 14-Valor da Embalagem ( Opiconal )
	0,;                                                                                           // 15-RecNo do SB1
	0)                                                                                                            // 16-RecNo do SF4
	
	
	nAliqICM 	:= round(MaFisRet(1,'IT_ALIQICM',5,2) ,2 )
	
	mafisend()
	
	
	
Return  (nAliqICM)
/*====================================================================================\
|Programa  | xretmafis        | Autor | GIOVANI.ZAGO             | Data | 14/01/2013  |
|=====================================================================================|
|Descrição |  xretmafis                                                               |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | xretmafis                                                                |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
Static Function xretmafis()
	*-----------------------------*
	Local   _nPosPrv  		:= aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_PRCVEN"})     // Preco de venda
	Local   _nPosProd  		:= aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_PRODUTO"})    // Codigo do produto
	Local   _nPosTes  		:= aScan(aHeader, {|x| Upper(AllTrim(x[2])) == 'TES'})     	// Valor Acrescimo Financeiro  _nPosTes
	Local	nPValICMS		:= Ascan(aHeader,{|x| AllTrim(Upper(x[2]))	== "C6_ZVALICM"})			// Posicao do Valor do ICMS
	Local	nPAliqICM  		:= Ascan(aHeader,{|x| AllTrim(Upper(x[2]))	== "C6_ZPICMS"})			// Posicao do Aliq. ICMS
	Local	nPValICMSST		:= Ascan(aHeader,{|x| AllTrim(Upper(x[2]))	== "C6_ZVALIST"})			// Posicao do Valor do ICMS ST
	Local	nPValIPI		:= Ascan(aHeader,{|x| AllTrim(Upper(x[2]))	== "C6_ZVALIPI"})			// Posicao do Valor do IPI
	Local	nPosIpi		    := Ascan(aHeader,{|x| AllTrim(Upper(x[2]))	== "C6_ZIPI"})
	Local	nPosCOMISS		    := Ascan(aHeader,{|x| AllTrim(Upper(x[2]))	== "C6_COMISS"})
	Local   _nTotPed 		:= 0
	Local	nAliqICM 		:= 0
	Local	nValICms		:= 0
	Local   nCnt 			:= 0
	Local	nAliqIPI 		:= 0
	Local	nValIPI 		:= 0
	Local	nValICMSST 		:= 0
	Local	nValPis			:= 0
	Local  naliqICMSST      := 0
	Local	nValCof			:= 0
	Local   nQuant			:= 1  //SEMPRE 1 QUANTIDADE DE PRODUTO
	MaFisSave()
	MaFisEnd()
	MaFisIni(M->C5_CLIENTE,;// 1-Codigo Cliente/Fornecedor
	M->C5_LOJACLI,;		// 2-Loja do Cliente/Fornecedor
	IIf(M->C5_TIPO$'DB',"F","C"),;				// 3-C:Cliente , F:Fornecedor
	M->C5_TIPO,;				// 4-Tipo da NF
	M->C5_TIPOCLI,;		// 5-Tipo do Cliente/Fornecedor
	Nil,;
		Nil,;
		Nil,;
		Nil,;
		"MATA461")
	// 10-Nome da rotina que esta utilizando a funcao
	MaFisAdd(aCols[n,_nPosProd],;                                                     // 1-Codigo do Produto ( Obrigatorio )
	aCols[n,_nPosTes],;                                                                           // 2-Codigo do TES ( Opcional )
	nQuant,;                                                           // 3-Quantidade ( Obrigatorio )
	aCols[n,_nPosPrv],;                                                            // 4-Preco Unitario ( Obrigatorio )
	0,;                // 5-Valor do Desconto ( Opcional )
	,;                                                                                                                             // 6-Numero da NF Original ( Devolucao/Benef )
	,;                                                                                                                             // 7-Serie da NF Original ( Devolucao/Benef )
	,;                                                                                          // 8-RecNo da NF Original no arq SD1/SD2
	0,;                                                                                                           // 9-Valor do Frete do Item ( Opcional )
	0,;                                                                                                           // 10-Valor da Despesa do item ( Opcional )
	0,;                                                                           // 11-Valor do Seguro do item ( Opcional )
	0,;                                                                                                           // 12-Valor do Frete Autonomo ( Opcional )
	aCols[n,_nPosPrv],;// 13-Valor da Mercadoria ( Obrigatorio )
	0,;                                                                                                           // 14-Valor da Embalagem ( Opiconal )
	0,;                                                                                           // 15-RecNo do SB1
	0)                                                                                                            // 16-RecNo do SF4
	
	
	
	nAliqICM 	:= round(MaFisRet(1,'IT_ALIQICM',5,2) ,2 )
	nValICms	:= round(MaFisRet(1,'IT_VALICM',14,2) ,2 )
	
	nAliqIPI 	:= round(MaFisRet(1,"IT_ALIQIPI",5,2) ,2 )
	nValIPI 	:= round(MaFisRet(1,"IT_VALIPI",14,2) ,2 )
	
	nValICMSST 	:= round(MaFisRet(1,'IT_VALSOL',14,2) ,2 )
	naliqICMSST 	:= nValICMSST*100/round(MaFisRet(1,'IT_BASEICM',14,2) ,2 )
	
	
	nValPis		:= round(MaFisRet(1,"IT_VALPS2",14,2) ,2 )
	nValCof		:= round(MaFisRet(1,"IT_VALCF2",14,2) ,2 )
	
	
	
	
	
	
	mafisend()
	
	
	//Retornar Valores Unitários
	
	aCols[n][nPValICMS]		:=  round(nValICMS 	/ nQuant      ,2)
	aCols[n][nPAliqICM]		:=	nAliqICM
	aCols[n][nPValICMSST]	:=  round(nValICMSST	/ nQuant   ,2   )
	aCols[n][nPValIPI] 		:=  round(nValIPI		/ nQuant   ,2   )
	aCols[n][nPosIpi]		:= 	 nAliqIPI
	aCols[n][nPosCOMISS]	:=  naliqICMSST
Return


/*====================================================================================\
|Programa  | OciPreco            | Autor | GIOVANI.ZAGO          | Data | 11/02/2014  |
|=====================================================================================|
|Descrição |  Reajuste de preço amazonia ocidental				                      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | OciPreco                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

*---------------------------------------------------*
Static Function OciPreco(_nPrcTes)
	*---------------------------------------------------*
	Local _nReajus:= 0
	Local _nPosProd := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_PRODUTO"})    // Codigo do produto
	Local _aArea1 	:= GetArea()
	
	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))
	If SB1->(DbSeek(xFilial("SB1")+aCols[n,_nPosProd]))
		
		If ALLTRIM(SB1->B1_GRUPO) $ "066/068/160/161/162/166/167/173/178/183"
			_nReajus:= 3
		ElseIf   ALLTRIM(SB1->B1_GRUPO) $ "049/050/063/064/149/150/152/153/176/075/159/170/171/175/177/184/186/158"
			_nReajus:= 5
		ElseIf   ALLTRIM(SB1->B1_GRUPO) $ "154"
			_nReajus:= 7
		ElseIf   ALLTRIM(SB1->B1_GRUPO) $ "048/148/151"
			_nReajus:= 8
		ElseIf   ALLTRIM(SB1->B1_GRUPO) $ "015/020/069/070/071/072/073"
			_nReajus:= 12
		EndIf
		If _nReajus > 0
			_nPrcTes:= (_nPrcTes+(_nPrcTes*(_nReajus/100)))
		EndIf
	EndIf
	RestArea(_aArea1)
Return  (_nPrcTes)

