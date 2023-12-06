#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  RSTFAT22     บAutor  ณGiovani Zago    บ Data ณ  29/01/14     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio de Vendedor INterno Por Linha de Produto        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-----------------------------*
User Function RSTFAT22()
	*-----------------------------*
	Local   oReport
	Private cPerg 			:= "RFAT22"
	Private cTime           := Time()
	Private cHora           := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private lXlsHeader      := .f.
	Private lXmlEndRow      := .f.
	Private _cVenTp         := ''
	
	PutSx1(cPerg, "01", "Mes de:"      	,"Mes de:" 			,"Mes de:" 			,"mv_ch1","C",2,0,0,"G","",''    ,"","","mv_par01","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "02", "Ano de:"     	,"Ano de:" 	   		,"Ano de:" 			,"mv_ch2","C",4,0,0,"G","",''    ,"","","mv_par02","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "03", "Mes At้:"     	,"Mes At้:" 		,"Mes At้:"			,"mv_ch3","C",2,0,0,"G","",''    ,"","","mv_par03","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "04", "Ano At้:"     	,"Ano At้:"  		,"Ano At้:"  		,"mv_ch4","C",4,0,0,"G","",''    ,"","","mv_par04","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "05", "Do Vendedor:"  ,"Do Vendedor: ?" 	,"Do Vendedor: ?" 	,"mv_ch5","C",6,0,0,"G","u_STVALSA3(mv_par05)",'SA3' ,"","","mv_par05","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "06", "Ate Vendedor:" ,"Ate Vendedor: ?" 	,"Ate Vendedor: ?" 	,"mv_ch6","C",6,0,0,"G","u_STVALSA3(mv_par06)",'SA3' ,"","","mv_par06","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "07", "Do Grupo:"  	,"Do Grupo: ?" 		,"Do Grupo: ?" 		,"mv_ch7","C",4,0,0,"G","",'SBM' ,"","","mv_par07","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "08", "Ate Grupo:" 	,"Ate Grupo: ?" 	,"Ate Grupo: ?" 	,"mv_ch8","C",4,0,0,"G","",'SBM' ,"","","mv_par08","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "09", "Faturamento:"  ,"Faturamento :"	,"Faturamento   :"  ,"mv_ch9","C",1,0,0,"C","",''    ,'','',"mv_par09","Ambos","","","","Digitado","","","Captado","","","","","","","")
	PutSx1(cPerg, "10", "Do Agrupamento:"  	,"Do Grupo: ?" 		,"Do Grupo: ?" 		,"mv_cha","C",4,0,0,"G","",'ZZ' ,"","","mv_par10","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "11", "Ate Agrupamento:" 	,"Ate Grupo: ?" 	,"Ate Grupo: ?" 	,"mv_chb","C",4,0,0,"G","",'ZZ' ,"","","mv_par11","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "12", "Do Produto:" 		,"Da Data: ?" 		,"Da Data: ?" 		,"mv_chc","C",15,0,0,"G","",'SB1'    ,"","","mv_par12","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "13", "Ate Produto:" 		,"Ate Data: ?" 		,"Ate Data: ?" 		,"mv_chd","C",15,0,0,"G","",'SB1'    ,"","","mv_par13","","","","","","","","","","","","","","","","")
	
	
	oReport		:= ReportDef()
	oReport:PrintDialog()
	
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  RSTFAT22     บAutor  ณGiovani Zago    บ Data ณ  29/01/14     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio de Vendedor INterno Por Linha de Produto        บฑฑ
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
	Local _n := 0
	
	oReport := TReport():New(cAliasLif,"RELATำRIO Vendedor Interno p/ Linha",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irแ imprimir um relat๓rio de Vendedor Interno p/ Linha")
	
	Pergunte(cPerg,.F.)
	
	oSection := TRSection():New(oReport,"Vendedor Interno por Linha",{"ZZI"})
	
	TRCell():New(oSection,"Vendedor"	  	,,"Vendedor"	,,35,.F.,)
	TRCell():New(oSection,"Linha"	  		,,"Linha"		,,30,.F.,)
	
	oSection:SetHeaderSection(.t.)
	oSection:Setnofilter("ZZI")
	
Return oReport
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  RSTFAT22     บAutor  ณGiovani Zago    บ Data ณ  29/01/14     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio de Vendedor INterno Por Linha de Produto        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*---------------------------------------*
Static Function ReportPrint(oReport)
	*---------------------------------------*
	Local oSection	:= oReport:Section(1)
	Local oSection1	:= oReport:Section(1)
	Local nX			:= 0
	Local cQuery 	:= ""
	Local cAlias 		:= "QRYTEMP9"
	Local aDados[2]
	Local aDados1:={}
	Local _cVen := ''
	Local _aImp :={}
	Local _cChave:=''
	Local _nMes  := 13-val(mv_par01)
	Local _nMes2 := val(mv_par03)
	Local _cMeses:= mv_par01
	Local _cAnos:=  mv_par02
	Local _nCount :=2
	Local _cMeses2:= mv_par03
	Local _cAnos2:=  mv_par04
	Local _aMes  := {}
	Local _nCell  :=0
	Local l:= 0
	Local h:= 0
	Local k:= 0
	
	
	rptstatus({|| strelquer( ) },"Compondo Relatorio")
	
	aadd(aDados1,'')
	oSection1:Cell("Vendedor")    	:SetBlock( { || aDados1[01] } )
	aadd(aDados1,'')
	oSection1:Cell("Linha")	    	:SetBlock( { || aDados1[02] } )
	If _cAnos2 <> _cAnos
		For l:=1 To 12
			If l <= _nMes
				aadd(aDados1,0)
				aadd(_aMes,{_cAnos+_cMeses})
				TRCell():New(oSection,_cMeses+'/'+_cAnos,,_cMeses+'/'+_cAnos	    ,"@E 99,999,999.99",14)
				If l = 1
					oSection1:Cell(_cMeses+'/'+_cAnos)	    	:SetBlock( { || aDados1[ 03] } )
				ElseIf l = 2
					oSection1:Cell(_cMeses+'/'+_cAnos)	    	:SetBlock( { || aDados1[ 04] } )
				ElseIf l = 3
					oSection1:Cell(_cMeses+'/'+_cAnos)	    	:SetBlock( { || aDados1[ 05] } )
				ElseIf l = 4
					oSection1:Cell(_cMeses+'/'+_cAnos)	    	:SetBlock( { || aDados1[ 06] } )
				ElseIf l = 5
					oSection1:Cell(_cMeses+'/'+_cAnos)	    	:SetBlock( { || aDados1[ 07] } )
				ElseIf l = 6
					oSection1:Cell(_cMeses+'/'+_cAnos)	    	:SetBlock( { || aDados1[ 08] } )
				ElseIf l = 7
					oSection1:Cell(_cMeses+'/'+_cAnos)	    	:SetBlock( { || aDados1[ 09] } )
				ElseIf l = 8
					oSection1:Cell(_cMeses+'/'+_cAnos)	    	:SetBlock( { || aDados1[ 10] } )
				ElseIf l = 9
					oSection1:Cell(_cMeses+'/'+_cAnos)	    	:SetBlock( { || aDados1[ 11] } )
				ElseIf l = 10
					oSection1:Cell(_cMeses+'/'+_cAnos)	    	:SetBlock( { || aDados1[ 12] } )
				ElseIf l = 11
					oSection1:Cell(_cMeses+'/'+_cAnos)	    	:SetBlock( { || aDados1[ 13] } )
				ElseIf l = 12
					oSection1:Cell(_cMeses+'/'+_cAnos)	    	:SetBlock( { || aDados1[ 14] } )
				EndIf
				
				_cMeses:= soma1(_cMeses)
				_nCount++
				
			ElseIf _cAnos2 <>_cAnos
				If _nMes +_nMes2 >= l
					_nCell:=l+2
					aadd(aDados1,0)
					aadd(_aMes,{_cAnos2+_cMeses2})
					TRCell():New(oSection,_cMeses2+'/'+_cAnos2,,_cMeses2+'/'+_cAnos2	    ,"@E 99,999,999.99",14)
					If l = 1
						oSection1:Cell(_cMeses2+'/'+_cAnos2)	    	:SetBlock( { || aDados1[ 03] } )
					ElseIf l = 2
						oSection1:Cell(_cMeses2+'/'+_cAnos2)	    	:SetBlock( { || aDados1[ 04] } )
					ElseIf l = 3
						oSection1:Cell(_cMeses2+'/'+_cAnos2)	    	:SetBlock( { || aDados1[ 05] } )
					ElseIf l = 4
						oSection1:Cell(_cMeses2+'/'+_cAnos2)	    	:SetBlock( { || aDados1[ 06] } )
					ElseIf l = 5
						oSection1:Cell(_cMeses2+'/'+_cAnos2)	    	:SetBlock( { || aDados1[ 07] } )
					ElseIf l = 6
						oSection1:Cell(_cMeses2+'/'+_cAnos2)	    	:SetBlock( { || aDados1[ 08] } )
					ElseIf l = 7
						oSection1:Cell(_cMeses2+'/'+_cAnos2)	    	:SetBlock( { || aDados1[ 09] } )
					ElseIf l = 8
						oSection1:Cell(_cMeses2+'/'+_cAnos2)	    	:SetBlock( { || aDados1[ 10] } )
					ElseIf l = 9
						oSection1:Cell(_cMeses2+'/'+_cAnos2)	    	:SetBlock( { || aDados1[ 11] } )
					ElseIf l = 10
						oSection1:Cell(_cMeses2+'/'+_cAnos2)	    	:SetBlock( { || aDados1[ 12] } )
					ElseIf l = 11
						oSection1:Cell(_cMeses2+'/'+_cAnos2)	    	:SetBlock( { || aDados1[ 13] } )
					ElseIf l = 12
						oSection1:Cell(_cMeses2+'/'+_cAnos2)	    	:SetBlock( { || aDados1[ 14] } )
					EndIf
					
					_cMeses2:= soma1(_cMeses2)
					_nCount++
				EndIf
			EndIf
		Next l
	Else
		For l:=1 To (val(_cMeses2) - val(_cMeses)+1)
			
			aadd(aDados1,0)
			aadd(_aMes,{_cAnos+_cMeses})
			TRCell():New(oSection,_cMeses+'/'+_cAnos,,_cMeses+'/'+_cAnos	    ,"@E 99,999,999.99",14)
			If l = 1
				oSection1:Cell(_cMeses+'/'+_cAnos)	    	:SetBlock( { || aDados1[ 03] } )
			ElseIf l = 2
				oSection1:Cell(_cMeses+'/'+_cAnos)	    	:SetBlock( { || aDados1[ 04] } )
			ElseIf l = 3
				oSection1:Cell(_cMeses+'/'+_cAnos)	    	:SetBlock( { || aDados1[ 05] } )
			ElseIf l = 4
				oSection1:Cell(_cMeses+'/'+_cAnos)	    	:SetBlock( { || aDados1[ 06] } )
			ElseIf l = 5
				oSection1:Cell(_cMeses+'/'+_cAnos)	    	:SetBlock( { || aDados1[ 07] } )
			ElseIf l = 6
				oSection1:Cell(_cMeses+'/'+_cAnos)	    	:SetBlock( { || aDados1[ 08] } )
			ElseIf l = 7
				oSection1:Cell(_cMeses+'/'+_cAnos)	    	:SetBlock( { || aDados1[ 09] } )
			ElseIf l = 8
				oSection1:Cell(_cMeses+'/'+_cAnos)	    	:SetBlock( { || aDados1[ 10] } )
			ElseIf l = 9
				oSection1:Cell(_cMeses+'/'+_cAnos)	    	:SetBlock( { || aDados1[ 11] } )
			ElseIf l = 10
				oSection1:Cell(_cMeses+'/'+_cAnos)	    	:SetBlock( { || aDados1[ 12] } )
			ElseIf l = 11
				oSection1:Cell(_cMeses+'/'+_cAnos)	    	:SetBlock( { || aDados1[ 13] } )
			ElseIf l = 12
				oSection1:Cell(_cMeses+'/'+_cAnos)	    	:SetBlock( { || aDados1[ 14] } )
			EndIf
			
			_cMeses:= soma1(_cMeses)
			_nCount++
			
			
		Next l
		
		
	EndIf
	
	oReport:SetTitle("Faturamento Vend.Interno P/ Linha")// Titulo do relat๓rio
	
	oReport:SetMeter(0)
	aFill(aDados,nil)
	oSection:Init()
	
	
	dbSelectArea(cAliasLif)
	(cAliasLif)->(dbgotop())
	If  Select(cAliasLif) > 0
		
		While 	(cAliasLif)->(!Eof())
			_cChave:=(cAliasLif)->(VENDEDOR+GRUPO)
			
			If aScan(_aImp,{|aX|aX[1]+aX[2]==_cChave})==0
				aAdd(_aImp, {(cAliasLif)->VENDEDOR,(cAliasLif)->GRUPO,0,0,0,0,0,0,0,0,0,0,0,0,0})
			EndIf
			If aScan(_aImp,{|aX|aX[1]+aX[2]==_cChave}) <> 0
				
				_aImp[aScan(_aImp,{|aX|aX[1]+aX[2]==_cChave}),  aScan(_aMes,{|aX|aX[1]==(cAliasLif)->EMISSAO})+2] := (cAliasLif)->TOTAL
				
			EndIf
			(cAliasLif)->(dbskip())
		End
		
		
	EndIf
	For k:= 1 To Len(_aImp)
		
		aDados1[01]	:=	_aImp[k,1]
		aDados1[02]	:=_aImp[k,2]
		
		For h:=1 To Len(_aMes)
			aDados1[h+2]	:=_aImp[k,h+2]
		Next h
		
		_cVen :=_aImp[k,1]
		oSection1:PrintLine()
		aFill(aDados1,nil)
	Next k
	oReport:SkipLine()
Return oReport



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  RSTFAT22     บAutor  ณGiovani Zago    บ Data ณ  29/01/14     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio de Vendedor INterno Por Linha de Produto        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*---------------------------------------*
Static Function strelquer()
	*---------------------------------------*
	Local aAreaSM0   := SM0->(GETAREA())
	Local cQuery     := ' '
	Local cEmpresas  := ''
	SetRegua(4)
	
	dbSelectArea("SM0")
	SM0->(dbGotop())
	While !SM0->(Eof())
		If Empty(SM0->M0_CGC)
			SM0->(dbSkip())
			Loop
		EndIf
		If len(cEmpresas)>1
			cEmpresas += "','"
		EndIf
		cEmpresas += AllTrim(SM0->M0_CGC)
		SM0->(dbSkip())
	End
	
	RestArea(aAreaSM0)
	
	
	IncRegua(   )
	
	IncRegua(   )
	
	If MV_PAR05 <> MV_PAR06
		cQuery := "  SELECT
		
		cQuery += "  SUBSTR(SF2.F2_EMISSAO,1,6) 		AS EMISSAO   ,
		cQuery += "  SB1.B1_GRUPO||' - '||RTRIM(LTRIM(SBM.BM_DESC))  						AS GRUPO     ,
		cQuery += "  SA3.A3_COD ||' - '|| RTRIM(LTRIM(SA3.A3_NOME))						AS VENDEDOR  ,
		//	cQuery += "  SUM(SD2.D2_PRCVEN*SD2.D2_QUANT) 	AS TOTAL
		cQuery += "  SUM(SD2.D2_VALBRUT-SD2.D2_VALIMP5-SD2.D2_VALIMP6-D2_DIFAL-D2_ICMSCOM-SD2.D2_VALICM )	AS TOTAL
		cQuery += "  FROM "+RetSqlName("SD2")+"  SD2 "
		
		cQuery += "  INNER JOIN (SELECT * FROM "+RetSqlName("SF2")+" )SF2 "
		cQuery += "  ON SUBSTR(SF2.F2_EMISSAO,1,6) BETWEEN '" + MV_PAR02 + MV_PAR01+ "' AND '" + MV_PAR04+ MV_PAR03 + "' "
		cQuery += "  AND SF2.D_E_L_E_T_ = ' '
		cQuery += "  AND SF2.F2_DOC = SD2.D2_DOC
		cQuery += "  AND SD2.D2_SERIE = SF2.F2_SERIE
		cQuery += "  AND SF2.F2_FILIAL = '"+xFilial("SF2")+"'"
		If Mv_par09 = 1
			cQuery += "  AND (SF2.F2_VEND1 BETWEEN '" + MV_PAR05+ "' AND '" + MV_PAR06 + "' "
			cQuery += "  OR   SF2.F2_VEND2 BETWEEN '" + MV_PAR05+ "' AND '" + MV_PAR06 + "' ) "
		ElseIf Mv_par09 = 2
			cQuery += "  AND SF2.F2_VEND2 BETWEEN '" + MV_PAR05+ "' AND '" + MV_PAR06 + "'   "
		ElseIf Mv_par09 = 3
			cQuery += "  AND SF2.F2_VEND1 BETWEEN '" + MV_PAR05+ "' AND '" + MV_PAR06 + "' "
		EndIf
		
		cQuery += " INNER JOIN(SELECT * FROM SA1010) SA1
		cQuery += " ON SA1.D_E_L_E_T_   = ' '
		cQuery += " AND SA1.A1_COD = SF2.F2_CLIENTE
		cQuery += " AND SA1.A1_LOJA = SF2.F2_LOJA
		cQuery += " AND SA1.A1_FILIAL = ' '
		cQuery += " AND SA1.A1_CGC NOT IN  ('" + cEmpresas + "')
		
		
		cQuery += "   INNER JOIN(SELECT * FROM "+RetSqlName("SB1")+" )SB1 "
		cQuery += "   ON SB1.B1_COD = SD2.D2_COD
		cQuery += "   AND SB1.D_E_L_E_T_ = ' '
		cQuery += "   AND SB1.B1_GRUPO BETWEEN '" + MV_PAR07+ "' AND '" + MV_PAR08 + "' "
		cQuery += "   AND SB1.B1_FILIAL = '"+xFilial("SB1")+"'"
		cQuery += "   AND SB1.B1_COD BETWEEN '" + MV_PAR12+ "' AND '" + MV_PAR13 + "' "
		
		cQuery += "  INNER JOIN(SELECT * FROM "+RetSqlName("SBM")+" )SBM "
		cQuery += "  ON SBM.BM_GRUPO =  SB1.B1_GRUPO
		cQuery += "  AND SBM.D_E_L_E_T_ = ' '
		cQuery += "  AND SBM.BM_FILIAL = '"+xFilial("SBM")+"'"
		cQuery += "   AND SBM.BM_XAGRUP BETWEEN '" + MV_PAR10+ "' AND '" + MV_PAR11 + "' "
		
		cQuery += "  INNER JOIN (SELECT * from "+RetSqlName("SA3")+" )SA3 "
		cQuery += "  ON  SA3.D_E_L_E_T_ = ' '
		cQuery += "  AND SA3.A3_FILIAL = '"+xFilial("SA3")+"'"
		
		If Mv_par09 = 1
			cQuery += "  AND (SA3.A3_COD = SF2.F2_VEND2 OR SA3.A3_COD = SF2.F2_VEND1)
		ElseIf Mv_par09 = 2
			cQuery += "  AND SA3.A3_COD = SF2.F2_VEND2
		ElseIf Mv_par09 = 3
			cQuery += "  AND SA3.A3_COD = SF2.F2_VEND1
		EndIf
		
		cQuery += "  AND SA3.A3_TPVEND = 'I'
		
		cQuery += "  WHERE SD2.D_E_L_E_T_ = ' '
		cQuery += "  AND SD2.D2_FILIAL = '"+xFilial("SD2")+"'"
		cQuery += " AND SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102')
		cQuery += " AND SA1.A1_GRPVEN <> 'ST'
		cQuery += " AND SA1.A1_GRPVEN <> 'SC'
		cQuery += " AND SA1.A1_EST    <> 'EX'
		cQuery += "  GROUP BY    SUBSTR(SF2.F2_EMISSAO,1,6),SB1.B1_GRUPO,SA3.A3_COD,SA3.A3_NOME,SBM.BM_DESC
		cQuery += "  ORDER BY  SA3.A3_COD, SUBSTR(SF2.F2_EMISSAO,1,6),SB1.B1_GRUPO
	Else
		cQuery := "  SELECT
		
		cQuery += "  SUBSTR(SF2.F2_EMISSAO,1,6) 		AS EMISSAO   ,
		cQuery += "  SB1.B1_GRUPO||' - '||RTRIM(LTRIM(SBM.BM_DESC))  						AS GRUPO     ,
		cQuery += "  SA3.A3_COD ||' - '|| RTRIM(LTRIM(SA3.A3_NOME))						   AS VENDEDOR  ,
		//	cQuery += "  SUM(SD2.D2_PRCVEN*SD2.D2_QUANT) 	AS TOTAL
		cQuery += "  SUM(SD2.D2_VALBRUT-SD2.D2_VALIMP5-SD2.D2_VALIMP6-D2_DIFAL-D2_ICMSCOM-SD2.D2_VALICM)	AS TOTAL
		cQuery += "  FROM "+RetSqlName("SD2")+"  SD2 "
		
		cQuery += "  INNER JOIN (SELECT * FROM "+RetSqlName("SF2")+" )SF2 "
		cQuery += "  ON SUBSTR(SF2.F2_EMISSAO,1,6) BETWEEN '" + MV_PAR02 + MV_PAR01+ "' AND '" + MV_PAR04+ MV_PAR03 + "' "
		cQuery += "  AND SF2.D_E_L_E_T_ = ' '
		cQuery += "  AND SF2.F2_DOC = SD2.D2_DOC
		cQuery += "  AND SD2.D2_SERIE = SF2.F2_SERIE
		cQuery += "  AND SF2.F2_FILIAL = '"+xFilial("SF2")+"'"
		If Mv_par09 = 1
			cQuery += "  AND (SF2.F2_VEND1 BETWEEN '" + MV_PAR05+ "' AND '" + MV_PAR06 + "' "
			cQuery += "  OR   SF2.F2_VEND2 BETWEEN '" + MV_PAR05+ "' AND '" + MV_PAR06 + "' ) "
		ElseIf Mv_par09 = 2
			cQuery += "  AND SF2.F2_VEND2 BETWEEN '" + MV_PAR05+ "' AND '" + MV_PAR06 + "'   "
		ElseIf Mv_par09 = 3
			cQuery += "  AND SF2.F2_VEND1 BETWEEN '" + MV_PAR05+ "' AND '" + MV_PAR06 + "' "
		EndIf
		
		cQuery += " INNER JOIN(SELECT * FROM SA1010) SA1
		cQuery += " ON SA1.D_E_L_E_T_   = ' '
		cQuery += " AND SA1.A1_COD = SF2.F2_CLIENTE
		cQuery += " AND SA1.A1_LOJA = SF2.F2_LOJA
		cQuery += " AND SA1.A1_FILIAL = ' '
		cQuery += " AND SA1.A1_CGC NOT IN  ('" + cEmpresas + "')
		
		cQuery += "   INNER JOIN(SELECT * FROM "+RetSqlName("SB1")+" )SB1 "
		cQuery += "   ON SB1.B1_COD = SD2.D2_COD
		cQuery += "   AND SB1.D_E_L_E_T_ = ' '
		cQuery += "   AND SB1.B1_GRUPO BETWEEN '" + MV_PAR07+ "' AND '" + MV_PAR08 + "' "
		cQuery += "   AND SB1.B1_FILIAL = '"+xFilial("SB1")+"'"
		cQuery += "   AND SB1.B1_COD BETWEEN '" + MV_PAR12+ "' AND '" + MV_PAR13 + "' "
		
		cQuery += "  INNER JOIN(SELECT * FROM "+RetSqlName("SBM")+" )SBM "
		cQuery += "  ON SBM.BM_GRUPO =  SB1.B1_GRUPO
		cQuery += "  AND SBM.D_E_L_E_T_ = ' '
		cQuery += "  AND SBM.BM_FILIAL = '"+xFilial("SBM")+"'"
		cQuery += "   AND SBM.BM_XAGRUP BETWEEN '" + MV_PAR10+ "' AND '" + MV_PAR11 + "' "
		
		cQuery += "  INNER JOIN (SELECT * from "+RetSqlName("SA3")+" )SA3 "
		cQuery += "  ON  SA3.D_E_L_E_T_ = ' '
		cQuery += "  AND SA3.A3_FILIAL = '"+xFilial("SA3")+"'"
		
		
		cQuery += "  AND SA3.A3_COD = SF2.F2_VEND1
		
		cQuery += "  WHERE SD2.D_E_L_E_T_ = ' '
		cQuery += " AND SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102')
		cQuery += " AND SA1.A1_GRPVEN <> 'ST'
		cQuery += " AND SA1.A1_GRPVEN <> 'SC'
		cQuery += " AND SA1.A1_EST    <> 'EX'
		cQuery += "  AND SD2.D2_FILIAL = '"+xFilial("SD2")+"'"
		cQuery += "  GROUP BY    SUBSTR(SF2.F2_EMISSAO,1,6),SB1.B1_GRUPO,SA3.A3_COD,SA3.A3_NOME,SBM.BM_DESC
		cQuery += "  ORDER BY  SA3.A3_COD, SUBSTR(SF2.F2_EMISSAO,1,6),SB1.B1_GRUPO
	EndIf
	
	//SELECT SUBSTR(SF2.F2_EMISSAO,1,6) AS EMISSAO,SB1.B1_GRUPO AS GRUPO,RTRIM(LTRIM(SBM.BM_DESC)) AS DESCRICAO,SA3.A3_COD AS VENDEDOR,RTRIM(LTRIM(SA3.A3_NOME)) AS NOME,SUM(SD2.D2_PRCVEN*SD2.D2_QUANT) AS TOTAL FROM SD2010 SD2 INNER JOIN (SELECT * FROM SF2010 ) SF2 ON SUBSTR(SF2.F2_EMISSAO,1,6) BETWEEN '201301' AND '201306' AND SF2.D_E_L_E_T_ = ' ' AND SF2.F2_DOC = SD2.D2_DOC AND SD2.D2_SERIE = SF2.F2_SERIE AND SF2.F2_FILIAL = '02' AND (SF2.F2_VEND1 BETWEEN '      ' AND 'zzzzzz' OR SF2.F2_VEND2 BETWEEN '      ' AND 'zzzzzz' ) INNER JOIN(SELECT * FROM SB1010 ) SB1 ON SB1.B1_COD = SD2.D2_COD AND SB1.D_E_L_E_T_ = ' ' AND SB1.B1_GRUPO BETWEEN '    ' AND 'zzzz' AND SB1.B1_FILIAL = '  ' INNER JOIN(SELECT * FROM SBM010 ) SBM ON SBM.BM_GRUPO = SB1.B1_GRUPO AND SBM.D_E_L_E_T_ = ' ' AND SBM.BM_FILIAL = '  ' INNER JOIN (SELECT * FROM SA3010 ) SA3 ON SA3.D_E_L_E_T_ = ' ' AND SA3.A3_FILIAL = '  ' AND (SA3.A3_COD = SF2.F2_VEND2 OR SA3.A3_COD = SF2.F2_VEND1) AND SA3.A3_TPVEND = 'I'  WHERE  SD2.D_E_L_E_T_ = ' ' AND SD2.D2_FILIAL = '02' GROUP BY SUBSTR(SF2.F2_EMISSAO,1,6),SB1.B1_GRUPO,SA3.A3_COD,SA3.A3_NOME,SBM.BM_DESC  ORDER BY  SA3.A3_COD, SUBSTR(SF2.F2_EMISSAO,1,6),SB1.B1_GRUPO
	cQuery := ChangeQuery(cQuery)
	
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf
	
	IncRegua()
	
	
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
	
	
	
	IncRegua()
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  STVALSA3     บAutor  ณGiovani Zago    บ Data ณ  29/01/14     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio de Vendedor INterno Por Linha de Produto        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*------------------------------*
User Function STVALSA3(_cVen)
	*------------------------------*
	Local _lSa3:= .T.
	
	DbSelectArea('SA3')
	SA3->(DbSetOrder(7))
	If SA3->(dbSeek(xFilial('SA3')+__cUserId))
		If SA3->A3_TPVEND = 'I'  .And. !(Empty(Alltrim(SA3->A3_SUPER))) .And. !(Empty(Alltrim(SA3->A3_GEREN)))
			If _cVen <> SA3->A3_COD
				_lSa3:= .F.
				MsgInfo('Utilize Seu Codigo de Vendedor!!!!!')
			EndIf
		EndIf
	EndIf
	
	
	
Return(_lSa3)
