#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  RSTFAT60     บAutor  ณGiovani Zago    บ Data ณ  11/12/14     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio ABNER  						                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-----------------------------*
User Function RSTFAT60()
*-----------------------------*
	Local   oReport
	Private cPerg 			:= "RFAT60"
	Private cTime           := Time()
	Private cHora           := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private lXlsHeader      := .f.
	Private lXmlEndRow      := .f.
	Private cPergTit 		:= cAliasLif
	Private aVetor   		:={}
	Private oDlg
	Private oLbx
	Private oOk	   			:= LoadBitmap( GetResources(), "LBOK" )
	Private oNo	   			:= LoadBitmap( GetResources(), "LBNO" )
    Private _nEst  			:=0
    Private oDt1
    Private dDt1            := ddatabase
    Private oDt2
    Private dDt2            := ddatabase+1
    Private _nOp 			:= 0
    
	PutSx1(cPerg, "01"   ,"Da Emissao?         ","",""					,"mv_ch1","D"   ,08      ,0       ,0      , "G",""    ,""	 ,""         ,""   ,"mv_par01",""         ,""      ,""      ,""    ,""      ,""     ,""      ,""    ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""     ,""      ,""      ,""      ,"")
	PutSx1(cPerg, "02"   ,"At้ a Emissao?      ","",""  				,"mv_ch2","D"   ,08      ,0       ,0      , "G",""    ,""	 ,""         ,""   ,"mv_par02",""         ,""      ,""      ,""    ,""      ,""     ,""      ,""    ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""     ,""      ,""      ,""      ,"")
 
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


	TRCell():New(oSection,"01",,"GRUPO"		    ,,06,.F.,)
	TRCell():New(oSection,"02",,"NOME"		    ,,30,.F.,)
	
	TRCell():New(oSection,"03",,"QTD_E" 		,"@E 99,999,999.99",14)
	TRCell():New(oSection,"04",,"VAL_E"		    ,"@E 99,999,999.99",14)
	TRCell():New(oSection,"05",,"CUST_E"		,"@E 99,999,999.99",14)
	TRCell():New(oSection,"06",,"MARKUP_E"		,"@E 99,999,999.99",14)

	TRCell():New(oSection,"07",,"QTD_D" 		,"@E 99,999,999.99",14)
	TRCell():New(oSection,"08",,"VAL_D"		    ,"@E 99,999,999.99",14)
	TRCell():New(oSection,"09",,"CUST_D"		,"@E 99,999,999.99",14)
	TRCell():New(oSection,"10",,"MARKUP_D"		,"@E 99,999,999.99",14)
	
	TRCell():New(oSection,"11",,"QTD_R" 		,"@E 99,999,999.99",14)
	TRCell():New(oSection,"12",,"VAL_R"		    ,"@E 99,999,999.99",14)
	TRCell():New(oSection,"13",,"CUST_R"		,"@E 99,999,999.99",14)
	TRCell():New(oSection,"14",,"MARKUP_R"		,"@E 99,999,999.99",14)
	
	TRCell():New(oSection,"15",,"QTD_I" 		,"@E 99,999,999.99",14)
	TRCell():New(oSection,"16",,"VAL_I"		    ,"@E 99,999,999.99",14)
	TRCell():New(oSection,"17",,"CUST_I"		,"@E 99,999,999.99",14)
	TRCell():New(oSection,"18",,"MARKUP_I"		,"@E 99,999,999.99",14)
	
	TRCell():New(oSection,"19",,"QTD_TOTAL" 		,"@E 99,999,999.99",14)
	TRCell():New(oSection,"20",,"VAL_TOTAL"		    ,"@E 99,999,999.99",14)
	TRCell():New(oSection,"21",,"CUST_TOTAL"		,"@E 99,999,999.99",14)
	TRCell():New(oSection,"22",,"MARKUP_TOTAL"		,"@E 99,999,999.99",14)



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
	Local oSection	:= oReport:Section(1)
	Local oSection1	:= oReport:Section(1)
	Local nX		:= 0
	Local cQuery 	:= ""
	Local cAlias 	:= "QRYTEMP0"
	Local aDados[2]
	Local aDados1[99]
	Local _cSta 	:= ''
	Local _cCod    := ' '
	Local _nQtdPr  := 0
	Local _aCust   := {}
	Local _nCust   := 0
	Local _aGrup   := {}
	Local _nPos    := 0
	Local _nPosGr  := 0
		Local h		:= 0
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
	oSection1:Cell("16") :SetBlock( { || aDados1[16] } )

	oSection1:Cell("17") :SetBlock( { || aDados1[17] } )
	oSection1:Cell("18") :SetBlock( { || aDados1[18] } )
	oSection1:Cell("19") :SetBlock( { || aDados1[19] } )
	oSection1:Cell("20") :SetBlock( { || aDados1[20] } )
	oSection1:Cell("21") :SetBlock( { || aDados1[21] } )
	oSection1:Cell("22") :SetBlock( { || aDados1[22] } )


	oReport:SetTitle("UNICON")// Titulo do relat๓rio

	oReport:SetMeter(0)
	aFill(aDados,nil)
	aFill(aDados1,nil)
	oSection:Init()


	Processa({|| StQuery(  ) },"Compondo Relatorio")

	DbSelectArea(cAliasLif)
	(cAliasLif)->(DbGoTop())
	If  Select(cAliasLif) > 0
	
		While 	(cAliasLif)->(!Eof())
			If (cAliasLif)->PRODUTO <> _cCod
				_cCod :=(cAliasLif)->PRODUTO
				_nCust := 0
				If (cAliasLif)->C_MANAUS  <> 0
					_nCust := (cAliasLif)->C_MANAUS
				Else
					_nCust := U_STCUSTO((cAliasLif)->PRODUTO)
				EndIf
			EndIf
			
			_nPos	:= aScan(_aCust,{|x| Upper(Alltrim(x[01]))+Upper(Alltrim(x[02]))== "T"+Upper(Alltrim((cAliasLif)->GRUPO))  })
			If _nPos == 0
				aadd(_aCust,{  "T",;
					(cAliasLif)->GRUPO,;
					(cAliasLif)->NOME,;
					(cAliasLif)->QUANT,;
					(cAliasLif)->VALOR,;
					Round(((cAliasLif)->QUANT*_nCust),2) ,    ;
					IIF(Round(((cAliasLif)->QUANT*_nCust),2)=0,(cAliasLif)->VALOR,0);
					})
			Else
				_aCust[_nPos,4]:= 	_aCust[_nPos,4]+(cAliasLif)->QUANT
				_aCust[_nPos,5]:= 	_aCust[_nPos,5]+(cAliasLif)->VALOR
				_aCust[_nPos,6]:= 	_aCust[_nPos,6]+Round(((cAliasLif)->QUANT*_nCust),2)
				_aCust[_nPos,7]:= 	_aCust[_nPos,7]+IIF(Round(((cAliasLif)->QUANT*_nCust),2)=0,(cAliasLif)->VALOR,0)
			EndIf
	
			_nPos	:= aScan(_aCust,{|x| Upper(Alltrim(x[01]))+Upper(Alltrim(x[02]))== Upper(Alltrim((cAliasLif)->CLIENTE))+Upper(Alltrim((cAliasLif)->GRUPO))  })
			If _nPos == 0
				aadd(_aCust,{  (cAliasLif)->CLIENTE,;
					(cAliasLif)->GRUPO,;
					(cAliasLif)->NOME,;
					(cAliasLif)->QUANT,;
					(cAliasLif)->VALOR,;
					Round(((cAliasLif)->QUANT*_nCust),2) ,    ;
					IIF(Round(((cAliasLif)->QUANT*_nCust),2)=0,(cAliasLif)->VALOR,0);
					})
			Else
				_aCust[_nPos,4]:= 	_aCust[_nPos,4]+(cAliasLif)->QUANT
				_aCust[_nPos,5]:= 	_aCust[_nPos,5]+(cAliasLif)->VALOR
				_aCust[_nPos,6]:= 	_aCust[_nPos,6]+Round(((cAliasLif)->QUANT*_nCust),2)
				_aCust[_nPos,7]:= 	_aCust[_nPos,7]+IIF(Round(((cAliasLif)->QUANT*_nCust),2)=0,(cAliasLif)->VALOR,0)
			EndIf
	 
			_nPosGr	:= aScan(_aGrup,{|x| Upper(Alltrim(x[01])) ==  Upper(Alltrim((cAliasLif)->GRUPO))  })
			If _nPosGr == 0
				aadd(_aGrup,{ (cAliasLif)->GRUPO,(cAliasLif)->NOME })
			EndIf
	
	 
			(cAliasLif)->(dbskip())
		End
		
		
		
		
		aSort(_aGrup,,,{|x,y| x[1]<y[1]})
		For h:=1 To Len(_aGrup)
	 
		
			aDados1[01]	:=  _aGrup[h,1]
			aDados1[02]	:=  _aGrup[h,2]
			
			_nPos	:= aScan(_aCust,{|x| Upper(Alltrim(x[01]))+Upper(Alltrim(x[02]))== "E"+ ALLTRIM(_aGrup[h,1])  })
			If _nPos <> 0
				
				aDados1[03]	:=  _aCust[_nPos,4]
				aDados1[04]	:=  _aCust[_nPos,5]
				aDados1[05]	:=  _aCust[_nPos,6]
				aDados1[06]	:=	(_aCust[_nPos,5]-_aCust[_nPos,7])/_aCust[_nPos,6]
			Else
				aDados1[03]	:=  0
				aDados1[04]	:=  0
				aDados1[05]	:=  0
				aDados1[06]	:=	0
			EndIf
			
			_nPos	:= aScan(_aCust,{|x| Upper(Alltrim(x[01]))+Upper(Alltrim(x[02]))== "D"+ ALLTRIM(_aGrup[h,1])  })
			If _nPos <> 0
				
				aDados1[07]	:=  _aCust[_nPos,4]
				aDados1[08]	:=  _aCust[_nPos,5]
				aDados1[09]	:=  _aCust[_nPos,6]
				aDados1[10]	:=	(_aCust[_nPos,5]-_aCust[_nPos,7])/_aCust[_nPos,6]
			Else
				aDados1[07]	:=  0
				aDados1[08]	:=  0
				aDados1[09]	:=  0
				aDados1[10]	:=	0
			EndIf
			
			_nPos	:= aScan(_aCust,{|x| Upper(Alltrim(x[01]))+Upper(Alltrim(x[02]))== "R"+ ALLTRIM(_aGrup[h,1])  })
			If _nPos <> 0
				
				aDados1[11]	:=  _aCust[_nPos,4]
				aDados1[12]	:=  _aCust[_nPos,5]
				aDados1[13]	:=  _aCust[_nPos,6]
				aDados1[14]	:=	(_aCust[_nPos,5]-_aCust[_nPos,7])/_aCust[_nPos,6]
			Else
				aDados1[11]	:=  0
				aDados1[12]	:=  0
				aDados1[13]	:=  0
				aDados1[14]	:=	0
			EndIf
			
			_nPos	:= aScan(_aCust,{|x| Upper(Alltrim(x[01]))+Upper(Alltrim(x[02]))== "I"+ ALLTRIM(_aGrup[h,1])  })
			If _nPos <> 0
				
				aDados1[15]	:=  _aCust[_nPos,4]
				aDados1[16]	:=  _aCust[_nPos,5]
				aDados1[17]	:=  _aCust[_nPos,6]
				aDados1[18]	:=	(_aCust[_nPos,5]-_aCust[_nPos,7])/_aCust[_nPos,6]
			Else
				aDados1[15]	:=  0
				aDados1[16]	:=  0
				aDados1[17]	:=  0
				aDados1[18]	:=	0
			EndIf

			_nPos	:= aScan(_aCust,{|x| Upper(Alltrim(x[01]))+Upper(Alltrim(x[02]))== "T"+ ALLTRIM(_aGrup[h,1])  })
			If _nPos <> 0
				
				aDados1[19]	:=  _aCust[_nPos,4]
				aDados1[20]	:=  _aCust[_nPos,5]
				aDados1[21]	:=  _aCust[_nPos,6]
				aDados1[22]	:=	(_aCust[_nPos,5]-_aCust[_nPos,7])/_aCust[_nPos,6]
			Else
				aDados1[19]	:=  0
				aDados1[20]	:=  0
				aDados1[21]	:=  0
				aDados1[22]	:=	0
			EndIf

		
			oSection1:PrintLine()
			aFill(aDados1,nil)
		NEXT h
		oSection1:PrintLine()
		aFill(aDados1,nil)
	
		(cAliasLif)->(dbCloseArea())
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
		Local j		:= 0
	
	
	cQuery := " SELECT
	cQuery += " SUBSTR(SA1.A1_GRPVEN,1,1)
	cQuery += ' AS "CLIENTE",
	cQuery += " SD2.D2_COD
	cQuery += ' AS "PRODUTO",
	cQuery += " SBM.BM_GRUPO
	cQuery += ' AS "GRUPO",
	cQuery += " TRIM(SBM.BM_DESC)
	cQuery += ' AS "NOME" ,
	cQuery += " NVL(SD2.D2_QUANT,0)
	cQuery += ' AS "QUANT",
	cQuery += " NVL(SD2.D2_TOTAL-SD2.D2_VALIMP5-SD2.D2_VALIMP6-D2_DIFAL-D2_ICMSCOM-SD2.D2_VALICM ,0)
	cQuery += ' "VALOR",
	cQuery += " SB1.B1_CLAPROD
	cQuery += ' "TIPO",
	cQuery += " NVL(SB1.B1_XPCSTK,0)
	cQuery += ' "C_MANAUS"

	cQuery += " FROM "+RetSqlName("SD2")+" SD2 "

	cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SA1")+" )SA1 "
	cQuery += " ON SA1.D_E_L_E_T_ = ' '
	cQuery += " AND SA1.A1_COD = SD2.D2_CLIENTE
	cQuery += " AND SA1.A1_LOJA = SD2.D2_LOJA
	cQuery += " AND SA1.A1_FILIAL = '  '


	cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SB1")+" )SB1 "
	cQuery += " ON SB1.D_E_L_E_T_ = ' '
	cQuery += " AND SD2.D2_COD = SB1.B1_COD


	cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SBM")+" )SBM "
	cQuery += " ON SBM.D_E_L_E_T_ = ' '
	cQuery += " AND SD2.D2_GRUPO = SBM.BM_GRUPO
	cQuery += " AND SBM.BM_XAGRUP <> ' '


	cQuery += " WHERE  SD2.D_E_L_E_T_ = ' '
	cQuery += " AND (SD2.D2_FILIAL = '02' OR SD2.D2_FILIAL = '01')
	cQuery += " AND SA1.A1_GRPVEN <> 'ST'
	cQuery += " AND SA1.A1_GRPVEN <> 'SC'
	cQuery += " AND SA1.A1_EST <> 'EX'
	
	For j:=1 To Len(aVetor)
		If aVetor[j,1]
		_nEst++
			If Empty(Alltrim(_cEst))
				_cEst:= "'"+aVetor[j,2]+"'"
			Else
				_cEst:= _cEst+",'"+aVetor[j,2]+"'"
			EndIf
		EndIf
	Next j
	If ! (Empty(Alltrim(_cEst)))
		cQuery += " AND SA1.A1_EST in ("+_cEst+")"
	EndIf
	cQuery += " AND SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102')
	cQuery += " AND SD2.D2_EMISSAO BETWEEN '" + dTos(dDt1) + "' AND '" + dTos(dDt2) + "' "
	cQuery += " AND SUBSTR(SA1.A1_GRPVEN,1,1) IN ('E','D','R','I')

	cQuery += " ORDER BY SD2.D2_COD




	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()


Static Function ESTADOS()
Local aSize     := MsAdvSize(, .F., 400)
Local aInfo 	:= {aSize[1],aSize[2],aSize[3],aSize[4]-12, 1, 1 }
Local aObjects 	:= {{100, 100,.T.,.T. }}
Local aPosObj 	:= MsObjSize( aInfo, aObjects,.T. )

	DbSelectArea("SX5")
	SX5->(dbSetOrder(1))
	SX5->(dbSeek(xFilial("SX5") + '12'))
	Do While SX5->(!EOF()) .and. xFilial("SX5") = SX5->X5_FILIAL .And. SX5->X5_TABELA  = '12'
		If ALLTRIM(SX5->X5_CHAVE)<> 'EX'
		AADD(aVetor,{.F.,ALLTRIM(SX5->X5_CHAVE),ALLTRIM(SX5->X5_DESCRI)})
		EndIf
		SX5->(DbSkip())
	EndDo

	DEFINE MSDIALOG oDlg TITLE "Estados" FROM aSize[7],000 To aSize[6]-60,aSize[5]-140 of GetWndDefault() Pixel
	    @ 005,200 Say "Data de :" PIXEL of oDlg
		@ 020,200 MsGet oDt1 Var dDt1 PIXEL of oDlg SIZE 060,08 
		@ 040,200 Say "Data ate:" PIXEL of oDlg
		@ 055,200 MsGet oDt2 Var dDt2 PIXEL of oDlg SIZE 060,08 
	
	@ 1,1 LISTBOX oLbx FIELDS HEADER ;
		' ','SIGLA','ESTADO' ;
		SIZE 150,250 OF oDlg PIXEL ON dblClick(aVetor[oLbx:nAt,1] := !aVetor[oLbx:nAt,1])
	
	//Exibe o Array no browse
	oLbx:SetArray( aVetor )

	oLbx:bLine := {|| {Iif(	aVetor[oLbx:nAt,1],oOk,oNo),;
		aVetor[oLbx:nAt,2],;
		aVetor[oLbx:nAt,3];
		}}
	oLbx:Refresh()
	oDlg:Refresh()
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| _nOp:=1,oDlg:End() },{||oDlg:End()},,)

	
Return()
	
	