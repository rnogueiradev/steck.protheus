#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  RSTFAT61     บAutor  ณGiovani Zago    บ Data ณ  11/12/14     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio Produto mes a mes 			                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-----------------------------*
User Function RSTFAT61()
	*-----------------------------*
	Private   oReport
	Private cPerg 			:= "RFAT61"
	Private cTime           := Time()
	Private cHora           := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private c1AliasLif   	:= '1'+cAliasLif
	Private c2AliasLif   	:= '2'+cAliasLif
	Private c3AliasLif   	:= '3'+cAliasLif
	Private c4AliasLif   	:= '4'+cAliasLif
	Private lXlsHeader      := .f.
	Private lXmlEndRow      := .f.
	Private cPergTit 		:= cAliasLif
	Private aVetor   		:={}
	Private aVetor2   		:={}
	Private aVeDev   		:={}
	Private oDlg
	Private oLbx
	Private oOk	   			:= LoadBitmap( GetResources(), "LBOK" )
	Private oNo	   			:= LoadBitmap( GetResources(), "LBNO" )
	Private _nEst  			:=0
	Private oDt1
	Private cDt1            := '2016'
	Private oDt2
	Private cDt2            := '2017'
	Private oDt3
	Private cDt3            := Space(6)
	Private oDt4
	Private cDt4            := Space(6)
	Private _cVend     		:= ' '
	Private _nt13           := 0
	Private _nt14           := 0
	Private _nt15           := 0
	
	Private _nOp 			:= 0
	Private _cGrupx         := ' '
	Private _cU61           := GetMv("ST_RFAT61",,"000000")+'/000000/000645/'
	
	//	PutSx1(cPerg, "01"   ,"Da Emissao?         ","",""					,"mv_ch1","D"   ,08      ,0       ,0      , "G",""    ,""	 ,""         ,""   ,"mv_par01",""         ,""      ,""      ,""    ,""      ,""     ,""      ,""    ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""     ,""      ,""      ,""      ,"")
	//	PutSx1(cPerg, "02"   ,"At้ a Emissao?      ","",""  				,"mv_ch2","D"   ,08      ,0       ,0      , "G",""    ,""	 ,""         ,""   ,"mv_par02",""         ,""      ,""      ,""    ,""      ,""     ,""      ,""    ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""     ,""      ,""      ,""      ,"")
	If !(__cuserid $ _cU61)
		MsgInfo('Usuario sem permissใo, solicite permissao a Sra. Tereza ')
		Return()
	EndIf
	ESTADOS()
	If _nOp = 1
		oReport		:= ReportDef()
		oReport:PrintDialog()
	EndIf
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ReportDef    บAutor  ณGiovani Zago    บ Data ณ  21/02/14     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio ONE VOICE				                          บฑฑ
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
	
	oReport := TReport():New(cPergTit,"RELATำRIO LINHA DE PRODUTOS",' ',{|oReport| ReportPrint(oReport)},"Este programa irแ imprimir um relat๓rio LINHA DE PRODUTOS")
	
	Pergunte(cPerg,.F.)
	
	oSection := TRSection():New(oReport,"LINHA DE PRODUTOS",{"SD2"})
	
	
	TRCell():New(oSection,"01",,"CODIGO"		    ,,15,.F.,)
	TRCell():New(oSection,"02",,"TIPO"		    	,,01,.F.,)
	TRCell():New(oSection,"03",,"GRUPO"		    	,,04,.F.,)
	TRCell():New(oSection,"04",,"BLOQUEADO"		    	,,03,.F.,)
	
	oSection:SetHeaderSection(.t.)
	oSection:Setnofilter("SD2")
	
Return oReport
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ReportPrint  บAutor  ณGiovani Zago    บ Data ณ  21/02/14     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio Produtos em transito	                          บฑฑ
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
	
	Local nX		:= 0
	Local cQuery 	:= ""
	Local cAlias 	:= "QRYTEMP0"
	Local aDados[2]
	
	Local _cSta 	:= ''
	Local _cCod    := ' '
	Local _nQtdPr  := 0
	Local _aCust   := {}
	Local _nCust   := 0
	Local _aGrup   := {}
	Local _nPos    := 0
	Local _nPosGr  := 0
	Local cNum     := "04"
	Local _nQue := 4
	Local _nTot0113  := 0
	Local _nTot0114	 := 0
	Local _nTot0213  := 0
	Local _nTot0214  := 0
	Local _nTot0313  := 0
	Local _nTot0314  := 0
	Local _nTot0413  := 0
	Local _nTot0414  := 0
	Local _nTot0513  := 0
	Local _nTot0514  := 0
	Local _nTot0613  := 0
	Local _nTot0614	 := 0
	Local _nTot0713  := 0
	Local _nTot0714	 := 0
	Local _nTot0813  := 0
	Local _nTot0814  := 0
	Local _nTot0913  := 0
	Local _nTot0914  := 0
	Local _nTot1013  := 0
	Local _nTot1014  := 0
	Local _nTot1113  := 0
	Local _nTot1114  := 0
	Local _nTot1213  := 0
	Local _nTot1214	 := 0
	Local _nPos	  	 := 0
	Local i	:= 0
	
	Private _cMesEs:= ''
	Private oSection	:= oReport:Section(1)
	Private oSection1	:= oReport:Section(1)
	Private aDados1[99]
	Private _cNum := '04'
	FOR i:= 1 To Len(aVetor)
		If aVetor[i,1]
			_cMesEs+= substr(Alltrim(aVetor[i,3]),1,3)+'/'
			
			
			/*
			_cNum:=	Soma1(_cNum)
			TRCell():New(oSection,_cNum,,Alltrim(aVetor[i,3]) +" "+cDt1  		,"@E 99,999,999.99",14)
			_cNum:=	Soma1(_cNum)
			TRCell():New(oSection,_cNum,,Alltrim(aVetor[i,3]) +" "+cDt2  	    ,"@E 99,999,999.99",14)
			_cNum:=	Soma1(_cNum)
			TRCell():New(oSection,_cNum,,Alltrim(aVetor[i,3])+" %" 		,"@E 99,999,999.99",14)
			*/
			
			If i= 1
				TRCell():New(oSection,'05',,Alltrim(aVetor[i,3]) +" "+cDt1  		,"@E 99,999,999.99",14)
				
				TRCell():New(oSection,'06',,Alltrim(aVetor[i,3]) +" "+cDt2  	    ,"@E 99,999,999.99",14)
				
				TRCell():New(oSection,'07',,Alltrim(aVetor[i,3])+" %" 		,"@E 99,999,999.99",14)
			EndIf
			If i= 2
				TRCell():New(oSection,'08',,Alltrim(aVetor[i,3]) +" "+cDt1  		,"@E 99,999,999.99",14)
				
				TRCell():New(oSection,'09',,Alltrim(aVetor[i,3]) +" "+cDt2  	    ,"@E 99,999,999.99",14)
				
				TRCell():New(oSection,'10',,Alltrim(aVetor[i,3])+" %" 		,"@E 99,999,999.99",14)
			EndIf
			If i= 3
				TRCell():New(oSection,'11',,Alltrim(aVetor[i,3]) +" "+cDt1  		,"@E 99,999,999.99",14)
				
				TRCell():New(oSection,'12',,Alltrim(aVetor[i,3]) +" "+cDt2  	    ,"@E 99,999,999.99",14)
				
				TRCell():New(oSection,'13',,Alltrim(aVetor[i,3])+" %" 		,"@E 99,999,999.99",14)
			EndIf
			If i= 4
				TRCell():New(oSection,'14',,Alltrim(aVetor[i,3]) +" "+cDt1  		,"@E 99,999,999.99",14)
				
				TRCell():New(oSection,'15',,Alltrim(aVetor[i,3]) +" "+cDt2  	    ,"@E 99,999,999.99",14)
				
				TRCell():New(oSection,'16',,Alltrim(aVetor[i,3])+" %" 		,"@E 99,999,999.99",14)
			EndIf
			If i= 5
				TRCell():New(oSection,'17',,Alltrim(aVetor[i,3]) +" "+cDt1  		,"@E 99,999,999.99",14)
				
				TRCell():New(oSection,'18',,Alltrim(aVetor[i,3]) +" "+cDt2  	    ,"@E 99,999,999.99",14)
				
				TRCell():New(oSection,'19',,Alltrim(aVetor[i,3])+" %" 		,"@E 99,999,999.99",14)
			EndIf
			If i= 6
				TRCell():New(oSection,'20',,Alltrim(aVetor[i,3]) +" "+cDt1  		,"@E 99,999,999.99",14)
				
				TRCell():New(oSection,'21',,Alltrim(aVetor[i,3]) +" "+cDt2  	    ,"@E 99,999,999.99",14)
				
				TRCell():New(oSection,'22',,Alltrim(aVetor[i,3])+" %" 		,"@E 99,999,999.99",14)
			EndIf
			If i= 7
				TRCell():New(oSection,'23',,Alltrim(aVetor[i,3]) +" "+cDt1  		,"@E 99,999,999.99",14)
				
				TRCell():New(oSection,'24',,Alltrim(aVetor[i,3]) +" "+cDt2  	    ,"@E 99,999,999.99",14)
				
				TRCell():New(oSection,'25',,Alltrim(aVetor[i,3])+" %" 		,"@E 99,999,999.99",14)
			EndIf
			If i= 8
				TRCell():New(oSection,'26',,Alltrim(aVetor[i,3]) +" "+cDt1  		,"@E 99,999,999.99",14)
				
				TRCell():New(oSection,'27',,Alltrim(aVetor[i,3]) +" "+cDt2  	    ,"@E 99,999,999.99",14)
				
				TRCell():New(oSection,'28',,Alltrim(aVetor[i,3])+" %" 		,"@E 99,999,999.99",14)
			EndIf
			If i= 9
				TRCell():New(oSection,'29',,Alltrim(aVetor[i,3]) +" "+cDt1  		,"@E 99,999,999.99",14)
				
				TRCell():New(oSection,'30',,Alltrim(aVetor[i,3]) +" "+cDt2  	    ,"@E 99,999,999.99",14)
				
				TRCell():New(oSection,'31',,Alltrim(aVetor[i,3])+" %" 		,"@E 99,999,999.99",14)
			EndIf
			If i= 10
				TRCell():New(oSection,'32',,Alltrim(aVetor[i,3]) +" "+cDt1  		,"@E 99,999,999.99",14)
				
				TRCell():New(oSection,'33',,Alltrim(aVetor[i,3]) +" "+cDt2  	    ,"@E 99,999,999.99",14)
				
				TRCell():New(oSection,'34',,Alltrim(aVetor[i,3])+" %" 		,"@E 99,999,999.99",14)
			EndIf
			If i=11
				TRCell():New(oSection,'35',,Alltrim(aVetor[i,3]) +" "+cDt1  		,"@E 99,999,999.99",14)
				
				TRCell():New(oSection,'36',,Alltrim(aVetor[i,3]) +" "+cDt2  	    ,"@E 99,999,999.99",14)
				
				TRCell():New(oSection,'37',,Alltrim(aVetor[i,3])+" %" 		,"@E 99,999,999.99",14)
			EndIf
			If i= 12
				TRCell():New(oSection,'38',,Alltrim(aVetor[i,3]) +" "+cDt1  		,"@E 99,999,999.99",14)
				
				TRCell():New(oSection,'39',,Alltrim(aVetor[i,3]) +" "+cDt2  	    ,"@E 99,999,999.99",14)
				
				TRCell():New(oSection,'40',,Alltrim(aVetor[i,3])+" %" 		,"@E 99,999,999.99",14)
			EndIf
			
			
			
			
			
			
			
			
			_nPos++
			
		EndIf
		
	Next i
	
	_nt13:= (_nPos * 3)+5
	_nt14:= (_nPos * 3)+6
	_nt15:= (_nPos * 3)+7
	
	TRCell():New(oSection,PADl( CVALTOCHAR(_nt13), 2  , '0' )	,,'TOTAL'+" "+cDt1  	,"@E 99,999,999.99",14)
	TRCell():New(oSection,PADl( CVALTOCHAR(_nt14), 2  , '0' )	,,'TOTAL'+" "+cDt2  	,"@E 99,999,999.99",14)
	TRCell():New(oSection,PADl( CVALTOCHAR(_nt15), 2  , '0' )	,,'TOTAL'+" %" 		,"@E 99,999,999.99",14)
	oSection1:Cell(PADl( CVALTOCHAR(_nt13), 2  , '0' )	) :SetBlock( { || aDados1[_nt13] } )
	oSection1:Cell(PADl( CVALTOCHAR(_nt14), 2  , '0' )	) :SetBlock( { || aDados1[_nt14] } )
	oSection1:Cell(PADl( CVALTOCHAR(_nt15), 2  , '0' )	) :SetBlock( { || aDados1[_nt15] } )
	
	
	
	
	
	oSection1:Cell("01") :SetBlock( { || aDados1[01] } )
	oSection1:Cell("02") :SetBlock( { || aDados1[02] } )
	oSection1:Cell("03") :SetBlock( { || aDados1[03] } )
	oSection1:Cell("04") :SetBlock( { || aDados1[04] } )
	If    'JAN' $ Upper(Alltrim(_cMesEs)) // _nPos>= 1
		oSection1:Cell("05") :SetBlock( { || aDados1[05] } )
		oSection1:Cell("06") :SetBlock( { || aDados1[06] } )
		oSection1:Cell("07") :SetBlock( { || aDados1[07] } )
	EndIf
	If  'FEV' $ Upper(Alltrim(_cMesEs)) //_nPos>= 2
		oSection1:Cell("08") :SetBlock( { || aDados1[08] } )
		oSection1:Cell("09") :SetBlock( { || aDados1[09] } )
		oSection1:Cell("10") :SetBlock( { || aDados1[10] } )
	EndIf
	If  'MAR' $ Upper(Alltrim(_cMesEs)) //_nPos>= 3
		oSection1:Cell("11") :SetBlock( { || aDados1[11] } )
		oSection1:Cell("12") :SetBlock( { || aDados1[12] } )
		oSection1:Cell("13") :SetBlock( { || aDados1[13] } )
	EndIf
	If  'ABR' $ Upper(Alltrim(_cMesEs)) //_nPos>= 4
		oSection1:Cell("14") :SetBlock( { || aDados1[14] } )
		oSection1:Cell("15") :SetBlock( { || aDados1[15] } )
		oSection1:Cell("16") :SetBlock( { || aDados1[16] } )
	EndIf
	If  'MAI' $ Upper(Alltrim(_cMesEs)) //_nPos>= 5
		oSection1:Cell("17") :SetBlock( { || aDados1[17] } )
		oSection1:Cell("18") :SetBlock( { || aDados1[18] } )
		oSection1:Cell("19") :SetBlock( { || aDados1[19] } )
	EndIf
	If  'JUN' $ Upper(Alltrim(_cMesEs)) //_nPos>= 6
		oSection1:Cell("20") :SetBlock( { || aDados1[20] } )
		oSection1:Cell("21") :SetBlock( { || aDados1[21] } )
		oSection1:Cell("22") :SetBlock( { || aDados1[22] } )
	EndIf
	If  'JUL' $ Upper(Alltrim(_cMesEs)) //_nPos>= 7
		oSection1:Cell("23") :SetBlock( { || aDados1[23] } )
		oSection1:Cell("24") :SetBlock( { || aDados1[24] } )
		oSection1:Cell("25") :SetBlock( { || aDados1[25] } )
	EndIf
	If  'AGO' $ Upper(Alltrim(_cMesEs)) //_nPos>= 8
		oSection1:Cell("26") :SetBlock( { || aDados1[26] } )
		oSection1:Cell("27") :SetBlock( { || aDados1[27] } )
		oSection1:Cell("28") :SetBlock( { || aDados1[28] } )
	EndIf
	If  'SET' $ Upper(Alltrim(_cMesEs)) //_nPos>= 9
		oSection1:Cell("29") :SetBlock( { || aDados1[29] } )
		oSection1:Cell("30") :SetBlock( { || aDados1[30] } )
		oSection1:Cell("31") :SetBlock( { || aDados1[31] } )
	EndIf
	If  'OUT' $ Upper(Alltrim(_cMesEs)) //_nPos>= 10
		oSection1:Cell("32") :SetBlock( { || aDados1[32] } )
		oSection1:Cell("33") :SetBlock( { || aDados1[33] } )
		oSection1:Cell("34") :SetBlock( { || aDados1[34] } )
	EndIf
	If  'NOV' $ Upper(Alltrim(_cMesEs)) //_nPos>= 11
		oSection1:Cell("35") :SetBlock( { || aDados1[35] } )
		oSection1:Cell("36") :SetBlock( { || aDados1[36] } )
		oSection1:Cell("37") :SetBlock( { || aDados1[37] } )
	EndIf
	If  'DEZ' $ Upper(Alltrim(_cMesEs)) //_nPos>= 12
		oSection1:Cell("38") :SetBlock( { || aDados1[38] } )
		oSection1:Cell("39") :SetBlock( { || aDados1[39] } )
		oSection1:Cell("40") :SetBlock( { || aDados1[40] } )
	EndIf
	
	oReport:SetTitle("Produto")// Titulo do relat๓rio
	
	oReport:SetMeter(0)
	aFill(aDados,nil)
	aFill(aDados1,nil)
	oSection:Init()
	
	
	Processa({|| StQuery(  ) },"Compondo Relatorio")
	
	DbSelectArea(cAliasLif)
	(cAliasLif)->(DbGoTop())
	If  Select(cAliasLif) > 0
		
		While 	(cAliasLif)->(!Eof())
			_nPos    := aScan(aVeDev, { |x| Alltrim(x[1]) == Alltrim((cAliasLif)->CODIGO)   })
			If _nPos <> 0
				_nDev:=0
				aDados1[01]	:=	(cAliasLif)->CODIGO
				aDados1[02]	:=	(cAliasLif)->TIPO
				aDados1[03]	:=	(cAliasLif)->GRUPO
				aDados1[04]	:=	(cAliasLif)->UM
				_nQue:=4
				aDados1[_nt13]:=0
				aDados1[_nt14]:=0
				aDados1[_nt15]:=0
				FOR i:= 1 To Len(aVetor)
					If aVetor[i,1]
						_nDev++
						If i = 1
							aDados1[05]	:=	&("(cAliasLif)->"+ Alltrim(aVetor[i,3])+'13')
							aDados1[06]	:=	aVeDev[_nPos,_nDev+_nQue]
							aDados1[07]	:=	IiF(aDados1[06]= 0 .or. aDados1[05]= 0 ,0,aDados1[06]*100/aDados1[05]-100)
							_nTot0113 += aDados1[05]
							_nTot0114 += aDados1[06]
							aDados1[_nt13] += aDados1[05]
							aDados1[_nt14] += aDados1[06]
						EndIf
						If i= 2
							aDados1[08]	:=	&("(cAliasLif)->"+ Alltrim(aVetor[i,3])+'13')
							aDados1[09]	:=	aVeDev[_nPos,_nDev+_nQue]
							aDados1[10]	:=	IiF(aDados1[09]= 0 .or. aDados1[08]= 0 ,0,aDados1[09]*100/aDados1[08]-100)
							_nTot0213 += aDados1[08]
							_nTot0214 += aDados1[09]
							aDados1[_nt13] += aDados1[08]
							aDados1[_nt14] += aDados1[09]
						EndIf
						If i= 3
							aDados1[11]	:=	&("(cAliasLif)->"+ Alltrim(aVetor[i,3])+'13')
							aDados1[12]	:=	aVeDev[_nPos,_nDev+_nQue]
							aDados1[13]	:=	IiF(aDados1[11]= 0 .or. aDados1[12]= 0 ,0,aDados1[12]*100/aDados1[11]-100)
							_nTot0313 += aDados1[11]
							_nTot0314 += aDados1[12]
							aDados1[_nt13] += aDados1[11]
							aDados1[_nt14] += aDados1[12]
						EndIf
						If i= 4
							aDados1[14]	:=	&("(cAliasLif)->"+ Alltrim(aVetor[i,3])+'13')
							aDados1[15]	:=	aVeDev[_nPos,_nDev+_nQue]
							aDados1[16]	:=	IiF(aDados1[15]= 0 .or. aDados1[14]= 0 ,0,aDados1[15]*100/aDados1[14]-100)
							_nTot0413 += aDados1[14]
							_nTot0414 += aDados1[15]
							aDados1[_nt13] += aDados1[14]
							aDados1[_nt14] += aDados1[15]
						EndIf
						If i= 5
							aDados1[17]	:=	&("(cAliasLif)->"+ Alltrim(aVetor[i,3])+'13')
							aDados1[18]	:=	aVeDev[_nPos,_nDev+_nQue]
							aDados1[19]	:=	IiF(aDados1[18]= 0 .or. aDados1[17]= 0 ,0,aDados1[18]*100/aDados1[17]-100)
							_nTot0513 += aDados1[17]
							_nTot0514 += aDados1[18]
							aDados1[_nt13] += aDados1[17]
							aDados1[_nt14] += aDados1[18]
						EndIf
						If i= 6
							aDados1[20]	:=	&("(cAliasLif)->"+ Alltrim(aVetor[i,3])+'13')
							aDados1[21]	:=	aVeDev[_nPos,_nDev+_nQue]
							aDados1[22]	:=	IiF(aDados1[21]= 0 .or. aDados1[20]= 0 ,0,aDados1[21]*100/aDados1[20]-100)
							_nTot0613 += aDados1[20]
							_nTot0614 += aDados1[21]
							aDados1[_nt13] += aDados1[20]
							aDados1[_nt14] += aDados1[21]
						EndIf
						If i= 7
							aDados1[23]	:=	&("(cAliasLif)->"+ Alltrim(aVetor[i,3])+'13')
							aDados1[24]	:=	aVeDev[_nPos,_nDev+_nQue]
							aDados1[25]	:=	IiF(aDados1[24]= 0 .or. aDados1[23]= 0 ,0,aDados1[24]*100/aDados1[23]-100)
							_nTot0713 += aDados1[23]
							_nTot0714 += aDados1[24]
							aDados1[_nt13] += aDados1[23]
							aDados1[_nt14] += aDados1[24]
						EndIf
						If i= 8
							aDados1[26]	:=	&("(cAliasLif)->"+ Alltrim(aVetor[i,3])+'13')
							aDados1[27]	:=	aVeDev[_nPos,_nDev+_nQue]
							aDados1[28]	:=	IiF(aDados1[27]= 0 .or. aDados1[26]= 0 ,0,aDados1[27]*100/aDados1[26]-100)
							_nTot0813 += aDados1[26]
							_nTot0814 += aDados1[27]
							aDados1[_nt13] += aDados1[26]
							aDados1[_nt14] += aDados1[27]
						EndIf
						If i= 9
							aDados1[29]	:=	&("(cAliasLif)->"+ Alltrim(aVetor[i,3])+'13')
							aDados1[30]	:=	aVeDev[_nPos,_nDev+_nQue]
							aDados1[31]	:=	IiF(aDados1[30]= 0 .or. aDados1[29]= 0 ,0,aDados1[30]*100/aDados1[29]-100)
							_nTot0913 += aDados1[29]
							_nTot0914 += aDados1[30]
							aDados1[_nt13] += aDados1[29]
							aDados1[_nt14] += aDados1[30]
						EndIf
						If i= 10
							aDados1[32]	:=	&("(cAliasLif)->"+ Alltrim(aVetor[i,3])+'13')
							aDados1[33]	:=	aVeDev[_nPos,_nDev+_nQue]
							aDados1[34]	:=	IiF(aDados1[33]= 0 .or. aDados1[32]= 0 ,0,aDados1[33]*100/aDados1[32]-100)
							_nTot1013 += aDados1[32]
							_nTot1014 += aDados1[33]
							aDados1[_nt13] += aDados1[32]
							aDados1[_nt14] += aDados1[33]
						EndIf
						If i= 11
							aDados1[35]	:=	&("(cAliasLif)->"+ Alltrim(aVetor[i,3])+'13')
							aDados1[36]	:=	aVeDev[_nPos,_nDev+_nQue]
							aDados1[37]	:=	IiF(aDados1[36]= 0 .or. aDados1[35]= 0 ,0,aDados1[36]*100/aDados1[35]-100)
							_nTot1113 += aDados1[35]
							_nTot1114 += aDados1[36]
							aDados1[_nt13] += aDados1[35]
							aDados1[_nt14] += aDados1[36]
						EndIf
						If i= 12
							aDados1[38]	:=	&("(cAliasLif)->"+ Alltrim(aVetor[i,3])+'13')
							aDados1[39]	:=	aVeDev[_nPos,_nDev+_nQue]
							aDados1[40]	:=	IiF(aDados1[39]= 0 .or. aDados1[38]= 0 ,0,aDados1[39]*100/aDados1[38]-100)
							_nTot1213 += aDados1[38]
							_nTot1214 += aDados1[39]
							aDados1[_nt13] += aDados1[38]
							aDados1[_nt14] += aDados1[39]
						EndIf
						
						
						
					EndIf
				Next i
				
				aDados1[_nt15] := IiF(aDados1[_nt14]= 0 .or. aDados1[_nt13]= 0 ,0,aDados1[_nt14]*100/aDados1[_nt13]-100)
				oSection1:PrintLine()
				aFill(aDados1,nil)
			EndIf
			_cGrupx := (cAliasLif)->GRUPO
			(cAliasLif)->(dbskip())
			
			//End
			
			
			If (cAliasLif)->GRUPO <> _cGrupx  .Or. (cAliasLif)->(Eof())
				
				
				aDados1[04]	:=	'QUANTIDADE:'
				aDados1[_nt13]:=0
				aDados1[_nt14]:=0
				aDados1[_nt15]:=0
				FOR i:= 1 To Len(aVetor)
					If aVetor[i,1]
						
						If i = 1
							aDados1[05]	:=	_nTot0113
							aDados1[06]	:=	_nTot0114
							aDados1[07]	:=	IiF(aDados1[06]= 0 .or. aDados1[05]= 0 ,0,aDados1[06]*100/aDados1[05]-100)
							aDados1[_nt13] += aDados1[05]
							aDados1[_nt14] += aDados1[06]
						EndIf
						If i= 2
							aDados1[08]	:=	_nTot0213
							aDados1[09]	:=	_nTot0214
							aDados1[10]	:=	IiF(aDados1[08]= 0 .or. aDados1[09]= 0 ,0,aDados1[09]*100/aDados1[08]-100)
							aDados1[_nt13] += aDados1[08]
							aDados1[_nt14] += aDados1[09]
						EndIf
						If i= 3
							aDados1[11]	:=	_nTot0313
							aDados1[12]	:=	_nTot0314
							aDados1[13]	:=	IiF(aDados1[11]= 0 .or. aDados1[12]= 0 ,0,aDados1[12]*100/aDados1[11]-100)
							aDados1[_nt13] += aDados1[11]
							aDados1[_nt14] += aDados1[12]
						EndIf
						If i= 4
							aDados1[14]	:=	_nTot0413
							aDados1[15]	:=	_nTot0414
							aDados1[16]	:=	IiF(aDados1[15]= 0 .or. aDados1[14]= 0 ,0,aDados1[15]*100/aDados1[14]-100)
							aDados1[_nt13] += aDados1[14]
							aDados1[_nt14] += aDados1[15]
						EndIf
						If i= 5
							aDados1[17]	:=	_nTot0513
							aDados1[18]	:=	_nTot0514
							aDados1[19]	:=	IiF(aDados1[18]= 0 .or. aDados1[17]= 0 ,0,aDados1[18]*100/aDados1[17]-100)
							aDados1[_nt13] += aDados1[17]
							aDados1[_nt14] += aDados1[18]
						EndIf
						If i= 6
							aDados1[20]	:=	_nTot0613
							aDados1[21]	:=	_nTot0614
							aDados1[22]	:=	IiF(aDados1[21]= 0 .or. aDados1[20]= 0 ,0,aDados1[21]*100/aDados1[20]-100)
							aDados1[_nt13] += aDados1[20]
							aDados1[_nt14] += aDados1[21]
						EndIf
						If i= 7
							aDados1[23]	:=	_nTot0713
							aDados1[24]	:=	_nTot0714
							aDados1[25]	:=	IiF(aDados1[24]= 0 .or. aDados1[23]= 0 ,0,aDados1[24]*100/aDados1[23]-100)
							aDados1[_nt13] += aDados1[23]
							aDados1[_nt14] += aDados1[24]
						EndIf
						If i= 8
							aDados1[26]	:=	_nTot0813
							aDados1[27]	:=	_nTot0814
							aDados1[28]	:=	IiF(aDados1[27]= 0 .or. aDados1[26]= 0 ,0,aDados1[27]*100/aDados1[26]-100)
							aDados1[_nt13] += aDados1[26]
							aDados1[_nt14] += aDados1[27]
						EndIf
						If i= 9
							aDados1[29]	:=	_nTot0913
							aDados1[30]	:=	_nTot0914
							aDados1[31]	:=	IiF(aDados1[30]= 0 .or. aDados1[29]= 0 ,0,aDados1[30]*100/aDados1[29]-100)
							aDados1[_nt13] += aDados1[29]
							aDados1[_nt14] += aDados1[30]
						EndIf
						If i= 10
							aDados1[32]	:=	_nTot1013
							aDados1[33]	:=	_nTot1014
							aDados1[34]	:=	IiF(aDados1[33]= 0 .or. aDados1[32]= 0 ,0,aDados1[33]*100/aDados1[32]-100)
							aDados1[_nt13] += aDados1[32]
							aDados1[_nt14] += aDados1[33]
						EndIf
						If i= 11
							aDados1[35]	:=	_nTot1113
							aDados1[36]	:=	_nTot1114
							aDados1[37]	:=	IiF(aDados1[36]= 0 .or. aDados1[35]= 0 ,0,aDados1[36]*100/aDados1[35]-100)
							aDados1[_nt13] += aDados1[35]
							aDados1[_nt14] += aDados1[36]
						EndIf
						If i= 12
							aDados1[38]	:=	_nTot1213
							aDados1[39]	:=	_nTot1214
							aDados1[40]	:=	IiF(aDados1[39]= 0 .or. aDados1[38]= 0 ,0,aDados1[39]*100/aDados1[38]-100)
							aDados1[_nt13] += aDados1[38]
							aDados1[_nt14] += aDados1[39]
						EndIf
						
						
						
					EndIf
				Next i
				aDados1[_nt15] := IiF(aDados1[_nt14]= 0 .or. aDados1[_nt13]= 0 ,0,aDados1[_nt14]*100/aDados1[_nt13]-100)
				_nTot0113  := 0
				_nTot0114  := 0
				_nTot0213  := 0
				_nTot0214  := 0
				_nTot0313  := 0
				_nTot0314  := 0
				_nTot0413  := 0
				_nTot0414  := 0
				_nTot0513  := 0
				_nTot0514  := 0
				_nTot0613  := 0
				_nTot0614  := 0
				_nTot0713  := 0
				_nTot0714  := 0
				_nTot0813  := 0
				_nTot0814  := 0
				_nTot0913  := 0
				_nTot0914  := 0
				_nTot1013  := 0
				_nTot1014  := 0
				_nTot1113  := 0
				_nTot1114  := 0
				_nTot1213  := 0
				_nTot1214  := 0
				
				oSection1:PrintLine()
				aFill(aDados1,nil)
				
				
				aDados1[04]	:=	'VALOR:'
				aDados1[_nt13]:=0
				aDados1[_nt14]:=0
				aDados1[_nt15]:=0
				FOR i:= 1 To Len(aVetor)
					If aVetor[i,1]
						
						If i = 1
							aDados1[05]	:=	x2StQuery(cDt1+PadR(Alltrim(aVetor[i,2]),2)) - x3StQuery(cDt1+PadR(Alltrim(aVetor[i,2]),2))
							aDados1[06]	:=	x2StQuery(cDt2+PadR(Alltrim(aVetor[i,2]),2)) - x3StQuery(cDt2+PadR(Alltrim(aVetor[i,2]),2))
							aDados1[07]	:=	aDados1[06]*100/aDados1[05]-100
							aDados1[_nt13] += aDados1[05]
							aDados1[_nt14] += aDados1[06]
						EndIf
						If i= 2
							aDados1[08]	:=	x2StQuery(cDt1+PadR(Alltrim(aVetor[i,2]),2)) - x3StQuery(cDt1+PadR(Alltrim(aVetor[i,2]),2))
							aDados1[09]	:=	x2StQuery(cDt2+PadR(Alltrim(aVetor[i,2]),2)) - x3StQuery(cDt2+PadR(Alltrim(aVetor[i,2]),2))
							aDados1[10]	:=	aDados1[09]*100/aDados1[08]-100
							aDados1[_nt13] += aDados1[08]
							aDados1[_nt14] += aDados1[09]
						EndIf
						If i= 3
							aDados1[11]	:=	x2StQuery(cDt1+PadR(Alltrim(aVetor[i,2]),2)) - x3StQuery(cDt1+PadR(Alltrim(aVetor[i,2]),2))
							aDados1[12]	:=	x2StQuery(cDt2+PadR(Alltrim(aVetor[i,2]),2)) - x3StQuery(cDt2+PadR(Alltrim(aVetor[i,2]),2))
							aDados1[13]	:=	aDados1[12]*100/aDados1[11]-100
							aDados1[_nt13] += aDados1[11]
							aDados1[_nt14] += aDados1[12]
						EndIf
						If i= 4
							aDados1[14]	:=	x2StQuery(cDt1+PadR(Alltrim(aVetor[i,2]),2)) - x3StQuery(cDt1+PadR(Alltrim(aVetor[i,2]),2))
							aDados1[15]	:=	x2StQuery(cDt2+PadR(Alltrim(aVetor[i,2]),2)) - x3StQuery(cDt2+PadR(Alltrim(aVetor[i,2]),2))
							aDados1[16]	:=	aDados1[15]*100/aDados1[14]-100
							aDados1[_nt13] += aDados1[14]
							aDados1[_nt14] += aDados1[15]
						EndIf
						If i= 5
							aDados1[17]	:=	x2StQuery(cDt1+PadR(Alltrim(aVetor[i,2]),2)) - x3StQuery(cDt1+PadR(Alltrim(aVetor[i,2]),2))
							aDados1[18]	:=	x2StQuery(cDt2+PadR(Alltrim(aVetor[i,2]),2)) - x3StQuery(cDt2+PadR(Alltrim(aVetor[i,2]),2))
							aDados1[19]	:=	aDados1[18]*100/aDados1[17]-100
							aDados1[_nt13] += aDados1[17]
							aDados1[_nt14] += aDados1[18]
						EndIf
						If i= 6
							aDados1[20]	:=	x2StQuery(cDt1+PadR(Alltrim(aVetor[i,2]),2)) - x3StQuery(cDt1+PadR(Alltrim(aVetor[i,2]),2))
							aDados1[21]	:=	x2StQuery(cDt2+PadR(Alltrim(aVetor[i,2]),2)) - x3StQuery(cDt2+PadR(Alltrim(aVetor[i,2]),2))
							aDados1[22]	:=	aDados1[21]*100/aDados1[20]-100
							aDados1[_nt13] += aDados1[20]
							aDados1[_nt14] += aDados1[21]
						EndIf
						If i= 7
							aDados1[23]	:=	x2StQuery(cDt1+PadR(Alltrim(aVetor[i,2]),2)) - x3StQuery(cDt1+PadR(Alltrim(aVetor[i,2]),2))
							aDados1[24]	:=	x2StQuery(cDt2+PadR(Alltrim(aVetor[i,2]),2)) - x3StQuery(cDt2+PadR(Alltrim(aVetor[i,2]),2))
							aDados1[25]	:=	aDados1[24]*100/aDados1[23]-100
							aDados1[_nt13] += aDados1[23]
							aDados1[_nt14] += aDados1[24]
						EndIf
						If i= 8
							aDados1[26]	:=	x2StQuery(cDt1+PadR(Alltrim(aVetor[i,2]),2)) - x3StQuery(cDt1+PadR(Alltrim(aVetor[i,2]),2))
							aDados1[27]	:=	x2StQuery(cDt2+PadR(Alltrim(aVetor[i,2]),2)) - x3StQuery(cDt2+PadR(Alltrim(aVetor[i,2]),2))
							aDados1[28]	:=	aDados1[27]*100/aDados1[26]-100
							aDados1[_nt13] += aDados1[26]
							aDados1[_nt14] += aDados1[27]
						EndIf
						If i= 9
							aDados1[29]	:=	x2StQuery(cDt1+PadR(Alltrim(aVetor[i,2]),2)) - x3StQuery(cDt1+PadR(Alltrim(aVetor[i,2]),2))
							aDados1[30]	:=	x2StQuery(cDt2+PadR(Alltrim(aVetor[i,2]),2)) - x3StQuery(cDt2+PadR(Alltrim(aVetor[i,2]),2))
							aDados1[31]	:=	aDados1[30]*100/aDados1[29]-100
							aDados1[_nt13] += aDados1[29]
							aDados1[_nt14] += aDados1[30]
						EndIf
						If i= 10
							aDados1[32]	:=	x2StQuery(cDt1+PadR(Alltrim(aVetor[i,2]),2)) - x3StQuery(cDt1+PadR(Alltrim(aVetor[i,2]),2))
							aDados1[33]	:=	x2StQuery(cDt2+PadR(Alltrim(aVetor[i,2]),2)) - x3StQuery(cDt2+PadR(Alltrim(aVetor[i,2]),2))
							aDados1[34]	:=	aDados1[33]*100/aDados1[32]-100
							aDados1[_nt13] += aDados1[32]
							aDados1[_nt14] += aDados1[33]
						EndIf
						If i= 11
							aDados1[35]	:=	x2StQuery(cDt1+PadR(Alltrim(aVetor[i,2]),2)) - x3StQuery(cDt1+PadR(Alltrim(aVetor[i,2]),2))
							aDados1[36]	:=	x2StQuery(cDt2+PadR(Alltrim(aVetor[i,2]),2)) - x3StQuery(cDt2+PadR(Alltrim(aVetor[i,2]),2))
							aDados1[37]	:=	aDados1[36]*100/aDados1[35]-100
							aDados1[_nt13] += aDados1[35]
							aDados1[_nt14] += aDados1[36]
						EndIf
						If i= 12
							aDados1[38]	:=	x2StQuery(cDt1+PadR(Alltrim(aVetor[i,2]),2)) - x3StQuery(cDt1+PadR(Alltrim(aVetor[i,2]),2))
							aDados1[39]	:=	x2StQuery(cDt2+PadR(Alltrim(aVetor[i,2]),2)) - x3StQuery(cDt2+PadR(Alltrim(aVetor[i,2]),2))
							aDados1[40]	:=	aDados1[39]*100/aDados1[38]-100
							aDados1[_nt13] += aDados1[38]
							aDados1[_nt14] += aDados1[39]
						EndIf
						
						
						
					EndIf
				Next i
				
				aDados1[_nt15] := IiF(aDados1[_nt14]= 0 .or. aDados1[_nt13]= 0 ,0,aDados1[_nt14]*100/aDados1[_nt13]-100)
				
				oSection1:PrintLine()
				aFill(aDados1,nil)
				
				aDados1[04]	:=	'OP:'
				aDados1[_nt13]:=0
				aDados1[_nt14]:=0
				aDados1[_nt15]:=0
				FOR i:= 1 To Len(aVetor)
					If aVetor[i,1]
						
						If i = 1
							aDados1[05]	:=	x4StQuery(cDt1+PadR(Alltrim(aVetor[i,2]),2))
							aDados1[06]	:=	x4StQuery(cDt2+PadR(Alltrim(aVetor[i,2]),2))
							aDados1[07]	:=	aDados1[06]*100/aDados1[05]-100
							aDados1[_nt13] += aDados1[05]
							aDados1[_nt14] += aDados1[06]
						EndIf
						If i= 2
							aDados1[08]	:=	x4StQuery(cDt1+PadR(Alltrim(aVetor[i,2]),2))
							aDados1[09]	:=	x4StQuery(cDt2+PadR(Alltrim(aVetor[i,2]),2))
							aDados1[10]	:=	aDados1[09]*100/aDados1[08]-100
							aDados1[_nt13] += aDados1[08]
							aDados1[_nt14] += aDados1[09]
						EndIf
						If i= 3
							aDados1[11]	:=	x4StQuery(cDt1+PadR(Alltrim(aVetor[i,2]),2))
							aDados1[12]	:=	x4StQuery(cDt2+PadR(Alltrim(aVetor[i,2]),2))
							aDados1[13]	:=	aDados1[12]*100/aDados1[11]-100
							aDados1[_nt13] += aDados1[11]
							aDados1[_nt14] += aDados1[12]
						EndIf
						If i= 4
							aDados1[14]	:=	x4StQuery(cDt1+PadR(Alltrim(aVetor[i,2]),2))
							aDados1[15]	:=	x4StQuery(cDt2+PadR(Alltrim(aVetor[i,2]),2))
							aDados1[16]	:=	aDados1[15]*100/aDados1[14]-100
							aDados1[_nt13] += aDados1[14]
							aDados1[_nt14] += aDados1[15]
						EndIf
						If i= 5
							aDados1[17]	:=	x4StQuery(cDt1+PadR(Alltrim(aVetor[i,2]),2))
							aDados1[18]	:=	x4StQuery(cDt2+PadR(Alltrim(aVetor[i,2]),2))
							aDados1[19]	:=	aDados1[18]*100/aDados1[17]-100
							aDados1[_nt13] += aDados1[17]
							aDados1[_nt14] += aDados1[18]
						EndIf
						If i= 6
							aDados1[20]	:=	x4StQuery(cDt1+PadR(Alltrim(aVetor[i,2]),2))
							aDados1[21]	:=	x4StQuery(cDt2+PadR(Alltrim(aVetor[i,2]),2))
							aDados1[22]	:=	aDados1[21]*100/aDados1[20]-100
							aDados1[_nt13] += aDados1[20]
							aDados1[_nt14] += aDados1[21]
						EndIf
						If i= 7
							aDados1[23]	:=	x4StQuery(cDt1+PadR(Alltrim(aVetor[i,2]),2))
							aDados1[24]	:=	x4StQuery(cDt2+PadR(Alltrim(aVetor[i,2]),2))
							aDados1[25]	:=	aDados1[24]*100/aDados1[23]-100
							aDados1[_nt13] += aDados1[23]
							aDados1[_nt14] += aDados1[24]
						EndIf
						If i= 8
							aDados1[26]	:=	x4StQuery(cDt1+PadR(Alltrim(aVetor[i,2]),2))
							aDados1[27]	:=	x4StQuery(cDt2+PadR(Alltrim(aVetor[i,2]),2))
							aDados1[28]	:=	aDados1[27]*100/aDados1[26]-100
							aDados1[_nt13] += aDados1[26]
							aDados1[_nt14] += aDados1[27]
						EndIf
						If i= 9
							aDados1[29]	:=	x4StQuery(cDt1+PadR(Alltrim(aVetor[i,2]),2))
							aDados1[30]	:=	x4StQuery(cDt2+PadR(Alltrim(aVetor[i,2]),2))
							aDados1[31]	:=	aDados1[30]*100/aDados1[29]-100
							aDados1[_nt13] += aDados1[29]
							aDados1[_nt14] += aDados1[30]
						EndIf
						If i= 10
							aDados1[32]	:=	x4StQuery(cDt1+PadR(Alltrim(aVetor[i,2]),2))
							aDados1[33]	:=	x4StQuery(cDt2+PadR(Alltrim(aVetor[i,2]),2))
							aDados1[34]	:=	aDados1[33]*100/aDados1[32]-100
							aDados1[_nt13] += aDados1[32]
							aDados1[_nt14] += aDados1[33]
						EndIf
						If i= 11
							aDados1[35]	:=	x4StQuery(cDt1+PadR(Alltrim(aVetor[i,2]),2))
							aDados1[36]	:=	x4StQuery(cDt2+PadR(Alltrim(aVetor[i,2]),2))
							aDados1[37]	:=	aDados1[36]*100/aDados1[35]-100
							aDados1[_nt13] += aDados1[35]
							aDados1[_nt14] += aDados1[36]
						EndIf
						If i= 12
							aDados1[38]	:=	x4StQuery(cDt1+PadR(Alltrim(aVetor[i,2]),2))
							aDados1[39]	:=	x4StQuery(cDt2+PadR(Alltrim(aVetor[i,2]),2))
							aDados1[40]	:=	aDados1[39]*100/aDados1[38]-100
							aDados1[_nt13] += aDados1[38]
							aDados1[_nt14] += aDados1[39]
						EndIf
						
						
						
					EndIf
				Next i
				
				aDados1[_nt15] := IiF(aDados1[_nt14]= 0 .or. aDados1[_nt13]= 0 ,0,aDados1[_nt14]*100/aDados1[_nt13]-100)
				
				oSection1:PrintLine()
				aFill(aDados1,nil)
				
				oSection1:PrintLine()
				aFill(aDados1,nil)
				
			EndIf
		End
		
		
		
		//(cAliasLif)->(dbCloseArea())
	EndIf
	oReport:SkipLine()
Return oReport


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  StQuery      บAutor  ณGiovani Zago    บ Data ณ  21/02/14     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio COMISSAO				                          บฑฑ
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
	Local _cEst := ' '
	Local _nt := 0
	Local aVetorCab := {}
	Local i		:= 0
	Local _nSa3 := 0
	Local l		:= 0
	If !(Empty(Alltrim(cDt3)))
		
		
		dbSelectArea("SA3")
		SA3->(dbGoTop())
		While SA3->(!Eof())
			If SA3->A3_SUPER = cDt3
				_nSa3++
				If _nSa3 = 1
					_cVend:= SA3->A3_COD
				Else
					_cVend+="','"+SA3->A3_COD
				EndIf
			EndIf
			SA3->(dbSkip())
		End
		
	ElseIf !(Empty(Alltrim(cDt4)))
		_cVend     := cDt4
	EndIf
	
	cQuery := " SELECT"
	
	cQuery += " SB1.B1_COD"
	cQuery += '"CODIGO",'
	cQuery += "SB1.B1_CLAPROD"
	cQuery += '"TIPO",'
	cQuery += "SB1.B1_GRUPO"
	cQuery += '"GRUPO",'
	cQuery += "CASE WHEN B1_MSBLQL='1'THEN'Bloq.'ELSE'Libe.'END"
	cQuery += '"UM"'
	
	
	FOR i:= 1 To Len(aVetor)
		If aVetor[i,1]
			cQuery += ",NVL((SELECT sum(D2_QUANT)FROM "+RetSqlName("SD2")+" SD2
			
			If !(Empty(Alltrim(cDt3))) .Or. !(Empty(Alltrim(cDt4)))
				cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SF2")+") SF2
				cQuery += " ON SF2.D_E_L_E_T_ = ' '
				cQuery += " AND SF2.F2_FILIAL = SD2.D2_FILIAL
				cQuery += " AND SF2.F2_DOC   = SD2.D2_DOC
				cQuery += " AND SF2.F2_SERIE = SD2.D2_SERIE
				cQuery += " AND SF2.F2_VEND1 IN ('"+_cVend+"')
			EndIf
			
			cQuery += " WHERE SD2.D_E_L_E_T_=' ' AND D2_FILIAL IN('01','02')AND  D2_EST<>'EX' AND D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102') AND D2_COD=B1_COD AND SUBSTR(D2_EMISSAO,1,6)="
			cQuery += "'"+cDt1+PadR(Alltrim(aVetor[i,2]),2)+"'"
			cQuery += "),0)-NVL((SELECT sum(D1_QUANT)FROM "+RetSqlName("SD1")+" SD1
			
			
			If !(Empty(Alltrim(cDt3))) .Or. !(Empty(Alltrim(cDt4)))
				cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SF2")+") SF2
				cQuery += " ON SF2.D_E_L_E_T_ = ' '
				cQuery += " AND SF2.F2_DOC = D1_NFORI AND SF2.F2_SERIE = D1_SERIORI AND SF2.F2_FILIAL = D1_FILIAL
				cQuery += " AND SF2.F2_VEND1 IN ('"+_cVend+"')
			EndIf
			
			cQuery += " WHERE  SD1.D_E_L_E_T_=' ' AND D1_FILIAL IN('01','02')AND D1_CF IN('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204') AND D1_COD=B1_COD AND SUBSTR(D1_DTDIGIT,1,6)="
			cQuery += "'"+cDt1+PadR(Alltrim(aVetor[i,2]),2)+"'"
			cQuery += "),0)"
			cQuery += ' "'+ Alltrim(aVetor[i,3])+'13"'
			
			
		EndIf
	Next i
	
	cQuery += " FROM "+RetSqlName("SB1")+" SB1"
	
	cQuery += " WHERE SB1.D_E_L_E_T_=' '"
	cQuery += " AND B1_TIPO='PA'"
	//cQuery += " AND    B1_MSBLQL     = '2'
	cQuery += " AND B1_GRUPO IN ("
	FOR l:= 1 To Len(aVetor2)
		If aVetor2[l,1]
			_nT++
			If _nT = 1
				cQuery += "'"+aVetor2[l,2]+"'
			Else
				cQuery += ",'"+aVetor2[l,2]+"'
			EndIf
			
		EndIf
	Next l
	cQuery += ")
	cQuery += " AND EXISTS (SELECT * FROM SD2010 SD2
	If !(Empty(Alltrim(cDt3))) .Or. !(Empty(Alltrim(cDt4)))
		cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SF2")+") SF2
		cQuery += " ON SF2.D_E_L_E_T_ = ' '
		cQuery += " AND SF2.F2_FILIAL = SD2.D2_FILIAL
		cQuery += " AND SF2.F2_DOC   = SD2.D2_DOC
		cQuery += " AND SF2.F2_SERIE = SD2.D2_SERIE
		cQuery += " AND SF2.F2_VEND1 IN ('"+_cVend+"')
	EndIf
	cQuery += " WHERE  SD2.D_E_L_E_T_ = ' '  AND SD2.D2_EST <> 'EX'  AND (SD2.D2_FILIAL = '02' OR SD2.D2_FILIAL = '01')  AND SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102') AND SD2.D2_COD = SB1.B1_COD AND SUBSTR(SD2.D2_EMISSAO,1,4) BETWEEN
	cQuery += " '"+cDt1+"' AND '"+cDt2+"' AND exists(SELECT * FROM SA1010 SA1 where SA1.D_E_L_E_T_ = ' ' AND SA1.A1_COD = SD2.D2_CLIENTE AND SA1.A1_LOJA = SD2.D2_LOJA AND SA1.A1_FILIAL = '  ' AND SA1.A1_GRPVEN <> 'ST' AND SA1.A1_GRPVEN <> 'SC' AND SA1.A1_EST <> 'EX' ))
	cQuery += " GROUP BY B1_GRUPO,B1_COD,B1_CLAPROD,B1_MSBLQL order by B1_GRUPO"
	
	
	//cQuery := ChangeQuery(cQuery)
	
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf
	
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
	_nT:=0
	cQuery := " SELECT"
	
	cQuery += " SB1.B1_COD"
	cQuery += '"CODIGO",'
	cQuery += "SB1.B1_CLAPROD"
	cQuery += '"TIPO",'
	cQuery += "SB1.B1_GRUPO"
	cQuery += '"GRUPO",'
	cQuery += "CASE WHEN B1_MSBLQL='1'THEN'Bloq.'ELSE'Libe.'END"
	cQuery += '"UM"'
	
	
	FOR i:= 1 To Len(aVetor)
		If aVetor[i,1]
			
			cQuery += ",NVL((SELECT sum(D2_QUANT)FROM "+RetSqlName("SD2")+" SD2
			If !(Empty(Alltrim(cDt3))) .Or. !(Empty(Alltrim(cDt4)))
				cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SF2")+") SF2
				cQuery += " ON SF2.D_E_L_E_T_ = ' '
				cQuery += " AND SF2.F2_FILIAL = SD2.D2_FILIAL
				cQuery += " AND SF2.F2_DOC   = SD2.D2_DOC
				cQuery += " AND SF2.F2_SERIE = SD2.D2_SERIE
				cQuery += " AND SF2.F2_VEND1 IN ('"+_cVend+"')
			EndIf
			
			cQuery += " WHERE SD2.D_E_L_E_T_=' 'AND D2_FILIAL IN('01','02')AND D2_EST<>'EX' AND D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102') AND D2_COD=B1_COD AND SUBSTR(D2_EMISSAO,1,6)="
			cQuery += " '"+cDt2+PadR(Alltrim(aVetor[i,2]),2)+"'"
			cQuery += "),0)-NVL((SELECT sum(D1_QUANT)FROM "+RetSqlName("SD1")+" SD1
			
			If !(Empty(Alltrim(cDt3))) .Or. !(Empty(Alltrim(cDt4)))
				cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SF2")+") SF2
				cQuery += " ON SF2.D_E_L_E_T_ = ' '
				cQuery += " AND SF2.F2_DOC = D1_NFORI AND SF2.F2_SERIE = D1_SERIORI AND SF2.F2_FILIAL = D1_FILIAL
				cQuery += " AND SF2.F2_VEND1 IN ('"+_cVend+"')
			EndIf
			
			
			cQuery += " WHERE  SD1.D_E_L_E_T_=' ' AND D1_FILIAL IN('01','02')AND D1_CF IN('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204') AND D1_COD=B1_COD AND SUBSTR(D1_DTDIGIT,1,6)="
			cQuery += " '"+cDt2+PadR(Alltrim(aVetor[i,2]),2)+"'
			cQuery += "),0)"
			cQuery += ' "'+ Alltrim(aVetor[i,3])+'14"'
			aadd(aVetorCab, Alltrim(aVetor[i,3])+'14')
			
		EndIf
	Next i
	
	cQuery += " FROM "+RetSqlName("SB1")+" SB1"
	
	cQuery += " WHERE SB1.D_E_L_E_T_=' '"
	cQuery += " AND B1_TIPO='PA'"
	//cQuery += " AND    B1_MSBLQL     = '2'
	cQuery += " AND B1_GRUPO IN ("
	FOR l:= 1 To Len(aVetor2)
		If aVetor2[l,1]
			_nT++
			If _nT = 1
				cQuery += "'"+aVetor2[l,2]+"'
			Else
				cQuery += ",'"+aVetor2[l,2]+"' "
			EndIf
			
		EndIf
	Next l
	cQuery += ")
	cQuery += " AND EXISTS (SELECT * FROM SD2010 SD2
	If !(Empty(Alltrim(cDt3))) .Or. !(Empty(Alltrim(cDt4)))
		cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SF2")+") SF2
		cQuery += " ON SF2.D_E_L_E_T_ = ' '
		cQuery += " AND SF2.F2_FILIAL = SD2.D2_FILIAL
		cQuery += " AND SF2.F2_DOC   = SD2.D2_DOC
		cQuery += " AND SF2.F2_SERIE = SD2.D2_SERIE
		cQuery += " AND SF2.F2_VEND1 IN ('"+_cVend+"')
	EndIf
	cQuery += " WHERE  SD2.D_E_L_E_T_ = ' '  AND SD2.D2_EST <> 'EX'  AND (SD2.D2_FILIAL = '02' OR SD2.D2_FILIAL = '01')  AND SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102') AND SD2.D2_COD = SB1.B1_COD AND SUBSTR(SD2.D2_EMISSAO,1,4) BETWEEN
	cQuery += " '"+cDt1+"' AND '"+cDt2+"' AND exists(SELECT * FROM SA1010 SA1 where SA1.D_E_L_E_T_ = ' ' AND SA1.A1_COD = SD2.D2_CLIENTE AND SA1.A1_LOJA = SD2.D2_LOJA AND SA1.A1_FILIAL = '  ' AND SA1.A1_GRPVEN <> 'ST' AND SA1.A1_GRPVEN <> 'SC' AND SA1.A1_EST <> 'EX' ))
	cQuery += " GROUP BY B1_GRUPO,B1_COD,B1_CLAPROD,B1_MSBLQL order by B1_GRUPO"
	
	
	
	
	If Select(c1AliasLif) > 0
		(c1AliasLif)->(dbCloseArea())
	EndIf
	
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),c1AliasLif)
	_nT:=0
	FOR i:= 1 To Len(aVetor)
		If aVetor[i,1]
			
			_nT++
		EndIf
	Next i
	
	
	DbSelectArea(c1AliasLif)
	(c1AliasLif)->(DbGoTop())
	If  Select(c1AliasLif) > 0
		
		While 	(c1AliasLif)->(!Eof())
			
			Aadd(aVeDev,{;
				(c1AliasLif)->CODIGO,;
				(c1AliasLif)->TIPO,;
				(c1AliasLif)->GRUPO,;
				(c1AliasLif)->UM,;
				iif(_nT >= 01,&("(c1AliasLif)->"+ Alltrim(aVetorCab[01 ])),0),;
				iif(_nT >= 02,&("(c1AliasLif)->"+ Alltrim(aVetorCab[02 ])),0),;
				iif(_nT >= 03,&("(c1AliasLif)->"+ Alltrim(aVetorCab[03 ])),0),;
				iif(_nT >= 04,&("(c1AliasLif)->"+ Alltrim(aVetorCab[04 ])),0),;
				iif(_nT >= 05,&("(c1AliasLif)->"+ Alltrim(aVetorCab[05 ])),0),;
				iif(_nT >= 06,&("(c1AliasLif)->"+ Alltrim(aVetorCab[06 ])),0),;
				iif(_nT >= 07,&("(c1AliasLif)->"+ Alltrim(aVetorCab[07 ])),0),;
				iif(_nT >= 08,&("(c1AliasLif)->"+ Alltrim(aVetorCab[08 ])),0),;
				iif(_nT >= 09,&("(c1AliasLif)->"+ Alltrim(aVetorCab[09 ])),0),;
				iif(_nT >= 10,&("(c1AliasLif)->"+ Alltrim(aVetorCab[10 ])),0),;
				iif(_nT >= 11,&("(c1AliasLif)->"+ Alltrim(aVetorCab[11 ])),0),;
				iif(_nT >= 12,&("(c1AliasLif)->"+ Alltrim(aVetorCab[12 ])),0);
				})
			
			
			
			
			
			(c1AliasLif)->(dbskip())
			
		End
	EndIF
	
Return()


Static Function ESTADOS()
	Local aSize     := MsAdvSize(, .F., 400)
	Local aInfo 	:= {aSize[1],aSize[2],aSize[3],aSize[4]-12, 1, 1 }
	Local aObjects 	:= {{100, 100,.T.,.T. }}
	Local aPosObj 	:= MsObjSize( aInfo, aObjects,.T. )
	
	DbSelectArea("SX5")
	SX5->(dbSetOrder(1))
	SX5->(dbSeek(xFilial("SX5") + 'ZU'))
	Do While SX5->(!EOF()) .and. xFilial("SX5") = SX5->X5_FILIAL .And. SX5->X5_TABELA  = 'ZU'
		
		AADD(aVetor,{.F.,ALLTRIM(SX5->X5_CHAVE),SUBSTR(ALLTRIM(SX5->X5_DESCRI),1,3)})
		
		SX5->(DbSkip())
	EndDo
	
	DbSelectArea("SBM")
	SBM->(dbSetOrder(1))
	
	Do While SBM->(!EOF()) .and. xFilial("SBM") = SBM->BM_FILIAL
		If SBM->BM_XAGRUP <> ' '
			
			AADD(aVetor2,{.F.,ALLTRIM(SBM->BM_GRUPO),ALLTRIM(SBM->BM_DESC)})
		EndIf
		SBM->(DbSkip())
	EndDo
	_nTr:= 35
	
	DEFINE MSDIALOG oDlg TITLE "Parametros" FROM aSize[7],000 To aSize[6]-60,aSize[5]-140 of GetWndDefault() Pixel
	
	@ 005+_nTr,200 Say "Ano 01 :" PIXEL of oDlg
	@ 020+_nTr,200 MsGet oDt1 Var cDt1 PIXEL of oDlg SIZE 060,08
	@ 040+_nTr,200 Say "Ano 02:" PIXEL of oDlg
	@ 055+_nTr,200 MsGet oDt2 Var cDt2 PIXEL of oDlg SIZE 060,08
	
	
	@ 085+_nTr,200 Say "Coordenador:" PIXEL of oDlg
	@ 100+_nTr,200 MsGet oDt3 Var cDt3 PIXEL of oDlg SIZE 060,08 f3 "SA3" Valid Empty(Alltrim(cDt3)) .Or. (((existcpo("SA3",cDt3))  ) .And. Substr(Alltrim(cDt3),1,1) = 'S')
	@ 120+_nTr,200 Say "Vendedor:" PIXEL of oDlg
	@ 135+_nTr,200 MsGet oDt4 Var cDt4 PIXEL of oDlg SIZE 060,08 f3 "SA3" Valid Empty(Alltrim(cDt4)) .Or. ((existcpo("SA3",cDt4))  )
	
	
	
	
	
	
	@ 1+_nTr,1 LISTBOX oLbx FIELDS HEADER ;
		' ','Ref.','Mes' ;
		SIZE 150,250 OF oDlg PIXEL ON dblClick(aVetor[oLbx:nAt,1] := !aVetor[oLbx:nAt,1])
	
	//Exibe o Array no browse
	oLbx:SetArray( aVetor )
	
	oLbx:bLine := {|| {Iif(	aVetor[oLbx:nAt,1],oOk,oNo),;
		aVetor[oLbx:nAt,2],;
		aVetor[oLbx:nAt,3];
		}}
	
	@ 1+_nTr,350 LISTBOX oLbx2 FIELDS HEADER ;
		' ','Grupo','Descri็ใo' ;
		SIZE 150,250 OF oDlg PIXEL ON dblClick(aVetor2[oLbx2:nAt,1] := !aVetor2[oLbx2:nAt,1])
	
	//Exibe o Array no browse
	oLbx2:SetArray( aVetor2 )
	
	oLbx2:bLine := {|| {Iif(	aVetor2[oLbx2:nAt,1],oOk,oNo),;
		aVetor2[oLbx2:nAt,2],;
		aVetor2[oLbx2:nAt,3];
		}}
	oLbx2:Refresh()
	oLbx:Refresh()
	oDlg:Refresh()
	
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| _nOp:=1,oDlg:End() },{||oDlg:End()},,)
	
	
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  StQuery      บAutor  ณGiovani Zago    บ Data ณ  21/02/14     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio COMISSAO				                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-----------------------------*
Static Function x2StQuery(_cDatx)
	*-----------------------------*
	
	Local cQuery     := ' '
	Local _nRetx := 0
	Local _nT := 0
	Local _aQuery		:= {}
	
	cQuery := " SELECT NVL(SUM(SD2.D2_TOTAL-SD2.D2_VALIMP5-SD2.D2_VALIMP6-D2_DIFAL-D2_ICMSCOM-SD2.D2_VALICM ),0)
	cQuery += ' "VALOR"
	cQuery += " FROM "+RetSqlName("SD2")+" SD2
	
	If !(Empty(Alltrim(cDt3))) .Or. !(Empty(Alltrim(cDt4)))
		cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SF2")+") SF2
		cQuery += " ON SF2.D_E_L_E_T_ = ' '
		cQuery += " AND SF2.F2_FILIAL = SD2.D2_FILIAL
		cQuery += " AND SF2.F2_DOC   = SD2.D2_DOC
		cQuery += " AND SF2.F2_SERIE = SD2.D2_SERIE
		cQuery += " AND SF2.F2_VEND1 IN ('"+_cVend+"')
	EndIf
	
	
	
	cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SA1")+" )SA1 ON SA1.D_E_L_E_T_ = ' ' AND SA1.A1_COD = SD2.D2_CLIENTE AND SA1.A1_LOJA = SD2.D2_LOJA AND SA1.A1_FILIAL = '  '   WHERE  SD2.D_E_L_E_T_ = ' '  AND (SD2.D2_FILIAL = '02' OR SD2.D2_FILIAL = '01')  AND SA1.A1_GRPVEN <> 'ST' AND SA1.A1_GRPVEN <> 'SC' AND SA1.A1_EST <> 'EX' AND SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102')
	cQuery += " AND (
	cQuery += "  SD2.D2_GRUPO = '"+_cGrupx+"'
	cQuery += " ) AND SUBSTR(SD2.D2_EMISSAO,1,6) = '"+_cDatx+"'
	
	
	
	//cQuery := ChangeQuery(cQuery)
	
	If Select(c2AliasLif) > 0
		(c2AliasLif)->(dbCloseArea())
	EndIf
	
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),c2AliasLif)
	
	
	If  Select(c2AliasLif) > 0
		(c2AliasLif)->(dbgotop())
		_nRetx :=	(c2AliasLif)->VALOR
	EndIf
	
Return(_nRetx)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  StQuery      บAutor  ณGiovani Zago    บ Data ณ  21/02/14     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio COMISSAO				                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-----------------------------*
Static Function x3StQuery(_cDatx)
	*-----------------------------*
	
	Local cQuery     := ' '
	Local _nRetx := 0
	Local _nT := 0
	
	
	cQuery += " SELECT NVL(SUM(D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.D1_VALICM),0)
	cQuery += ' "VALOR"
	cQuery += " FROM "+RetSqlName("SD1")+" SD1 INNER JOIN(SELECT * FROM "+RetSqlName("SA1")+" )SA1 ON SA1.D_E_L_E_T_ = ' ' AND SD1.D1_TIPO = 'D' AND SA1.A1_COD = SD1.D1_FORNECE AND SA1.A1_LOJA = SD1.D1_LOJA AND SA1.A1_FILIAL = '  ' INNER JOIN(SELECT * FROM "+RetSqlName("SF2")+" )SF2 ON SF2.D_E_L_E_T_ = ' ' AND SF2.F2_VEND1 IN ('"+_cVend+"') AND SF2.F2_DOC = D1_NFORI AND SF2.F2_SERIE = D1_SERIORI AND SF2.F2_FILIAL = D1_FILIAL and SF2.F2_EST <> 'EX' WHERE  SD1.D_E_L_E_T_ = ' '   AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204') AND (D1_FILIAL = '02' OR D1_FILIAL = '01')
	cQuery += " AND (
	cQuery += "  SD1.D1_GRUPO  = '"+_cGrupx+"'
	cQuery += " ) AND SUBSTR(SD1.D1_DTDIGIT,1,6) = '"+_cDatx+"'
	
	
	
	cQuery := ChangeQuery(cQuery)
	
	If Select(c3AliasLif) > 0
		(c3AliasLif)->(dbCloseArea())
	EndIf
	
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),c3AliasLif)
	If  Select(c3AliasLif) > 0
		(c3AliasLif)->(dbgotop())
		_nRetx :=	(c3AliasLif)->VALOR
	EndIf
	
Return(_nRetx)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  StQuery      บAutor  ณGiovani Zago    บ Data ณ  21/02/14     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio COMISSAO				                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-----------------------------*
Static Function x4StQuery(_cDatx)
	*-----------------------------*
	
	Local cQuery     := ' '
	Local _nRetx := 0
	Local _nT := 0
	
	
	cQuery += "   SELECT  NVL( SUM(D3_QUANT),0)
	cQuery += ' "VALOR"
	cQuery += " FROM "+RetSqlName("SD3")+" WHERE      D3_FILIAL IN ('01','02','04')  AND D_E_L_E_T_ = ' '  AND D3_OP <> ' ' AND D3_CF  LIKE 'RE%' AND D3_ESTORNO = ' '
	cQuery += " AND (
	cQuery += "  D3_GRUPO  = '"+_cGrupx+"'
	
	cQuery += " ) AND SUBSTR(D3_EMISSAO,1,6) =  '"+_cDatx+"'
	
	
	
	cQuery := ChangeQuery(cQuery)
	
	If Select(c4AliasLif) > 0
		(c4AliasLif)->(dbCloseArea())
	EndIf
	
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),c4AliasLif)
	If  Select(c4AliasLif) > 0
		(c4AliasLif)->(dbgotop())
		_nRetx :=	(c4AliasLif)->VALOR
	EndIf
	
Return(_nRetx)





