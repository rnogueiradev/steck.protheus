#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  RSTFAT25     บAutor  ณGiovani Zago    บ Data ณ  21/02/14     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio  OS X LINHA			                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RSTFAT25()

	Local   oReport
	Private cPerg 			:= "RFAT25"
	Private cTime           := Time()
	Private cHora           := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private lXlsHeader      := .f.
	Private lXmlEndRow      := .f.
	Private cPergTit 		:= cAliasLif

	xPutSx1(cPerg, "01", "Da Data:" 			,"Da Data: ?" 			,"Da Data: ?" 				,"mv_ch1","D",8,0,0,"G","",''    ,"","","mv_par01","","","","","","","","","","","","","","","","")
	xPutSx1(cPerg, "02", "Ate Data:" 			,"Ate Data: ?" 			,"Ate Data: ?" 				,"mv_ch2","D",8,0,0,"G","",''    ,"","","mv_par02","","","","","","","","","","","","","","","","")
	xPutSx1(cPerg, "03", "Do Pedido:" 			,"Do Pedido: ?" 		,"Do Pedido: ?" 			,"mv_ch3","C",6,0,0,"G","",'SC5' ,"","","mv_par03","","","","","","","","","","","","","","","","")
	xPutSx1(cPerg, "04", "Ate Pedido:" 			,"Ate Pedido: ?" 		,"Ate Pedido: ?" 			,"mv_ch4","C",6,0,0,"G","",'SC5' ,"","","mv_par04","","","","","","","","","","","","","","","","")
	xPutSx1(cPerg, "05", "Da OS.:" 				,"Da OS.: ?" 			,"Da OS.: ?" 				,"mv_ch5","C",6,0,0,"G","",'CB7' ,"","","mv_par05","","","","","","","","","","","","","","","","")
	xPutSx1(cPerg, "06", "Ate OS.:" 			,"Ate OS.: ?" 			,"Ate OS.: ?" 				,"mv_ch6","C",6,0,0,"G","",'CB7' ,"","","mv_par06","","","","","","","","","","","","","","","","")
	xPutSx1(cPerg, "07", "Do Separador:" 		,"Do Separador: ?" 		,"Do Separador: ?" 			,"mv_ch7","C",6,0,0,"G","",'CB1' ,"","","mv_par07","","","","","","","","","","","","","","","","")
	xPutSx1(cPerg, "08", "Ate Separador:" 		,"Ate Separador: ?" 	,"Ate Separador: ?" 		,"mv_ch8","C",6,0,0,"G","",'CB1' ,"","","mv_par08","","","","","","","","","","","","","","","","")
	xPutSx1(cPerg, "09", "Do Status:" 			,"Do Status: ?" 		,"Do Status: ?" 		  	,"mv_ch9","C",6,0,0,"G","",'' 	 ,"","","mv_par09","","","","","","","","","","","","","","","","")
	xPutSx1(cPerg, "10", "Ate Status:" 			,"Ate Status: ?" 		,"Ate Status: ?" 		   	,"mv_chA","C",6,0,0,"G","",'' 	 ,"","","mv_par10","","","","","","","","","","","","","","","","")
	xPutSx1(cPerg, "11", "Tipo de Relat๓rio:" 	,"Tipo de Relat๓rio:" 	,"Tipo de Relat๓rio:" 		,"mv_chB","N",1,0,0,"C","",'' 	 ,"","","mv_par11","Sint้tico","Sint้tico","Syntheti","","Analํtico","Analํtico","Analytical","","","","","","","","","")
	//PutSx1(cPerg, "11", "Ordenar Por  :","Ordenar Por  :","Ordenar Por   :"             ,"mv_chB","N",1,0,0,"C","",''    ,'','',"mv_par11","Desconto","","","","Aprovador","","","Cliente","","","","","","","")

	oReport		:= ReportDef()

	oReport:PrintDialog()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ReportDef     บAutor  ณGiovani Zago    บ Data ณ  21/02/14     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Monta Cab./Itens do Relแtorio	                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ReportDef()

	Local oReport
	Local oSection

	oReport := TReport():New(cPergTit,"RELATำRIO Os x Linha",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irแ imprimir um relat๓rio de Os x Linha.")

	Pergunte(cPerg,.F.)

	oSection := TRSection():New(oReport,"Os x Linha",{"SC5"})


	TRCell():New(oSection,"PEDIDO"	  	,,"PEDIDO"			,					,6	,.F.,)
	TRCell():New(oSection,"OP"	  		,,"OP"				,					,13	,.F.,)
	TRCell():New(oSection,"GRUPO"	  	,,"GRUPO"			,					,20	,.F.,)
	TRCell():New(oSection,"OS"			,,"OS"				,					,6	,.F.,)
	TRCell():New(oSection,"STATUS"  	,,"STATUS"			,					,20	,.F.,)
	TRCell():New(oSection,"OPERADOR"  	,,"OPERADOR"		,					,35	,.F.,)
	TRCell():New(oSection,"NOMOPER"  	,,"NOMOPER" 		,					,35	,.F.,)    // Valdemir Rabelo 04/11/2020 Ticket: 20201103009892
	TRCell():New(oSection,"Dt_INICIO"  	,,"Dt_INICIO"		,					,10	,.F.,)
	TRCell():New(oSection,"H_INICIO"  	,,"H_INICIO"		,					,5	,.F.,)
	TRCell():New(oSection,"Dt_FIM"  	,,"Dt_FIM"			,					,10	,.F.,)
	TRCell():New(oSection,"H_FIM"  		,,"H_FIM"			,					,5	,.F.,)
	TRCell():New(oSection,"H_TOTAL"		,,"H_TOTAL"			,					,5	,.F.,)
	TRCell():New(oSection,"ANO_OP"		,,"ANO_OP"			,					,4	,.F.,)    // Valdemir Rabelo 04/11/2020 Ticket: 20201103009892
	TRCell():New(oSection,"LINHAS"      ,,"LINHAS"			,"@E 99,999,999.99"	,14		 )
	TRCell():New(oSection,"QTD"     	,,"QTD"				,"@E 99,999,999.99"	,14		 )
	TRCell():New(oSection,"SEP_LINHAS"  ,,"SEP_LINHAS"		,"@E 99,999,999.99"	,14		 )
	TRCell():New(oSection,"SEP_QTD"     ,,"SEP_QTD"			,"@E 99,999,999.99"	,14		 )
	TRCell():New(oSection,"EMBALADOR"  	,,"EMBALADOR"		,					,35	,.F.,)
	TRCell():New(oSection,"Dt_Ini_Emb"  ,,"Dt_Ini_Emb"		,					,10	,.F.,)
	TRCell():New(oSection,"H_Ini_Emb"  	,,"H_Ini_Emb"		,					,5	,.F.,)
	TRCell():New(oSection,"Dt_Fim_Emb"  ,,"Dt_Fim_Emb"		,					,10	,.F.,)
	TRCell():New(oSection,"H_Fim_Emb"  	,,"H_Fim_Emb"		,					,5	,.F.,)
	TRCell():New(oSection,"VOLUME"      ,,"VOLUME"			,"@E 99,999,999.99"	,14		 )
	TRCell():New(oSection,"DT_OS"  		,,"DT_OS"			,					,10	,.F.,)
	TRCell():New(oSection,"QTD_OP"  	,,"QTD_OP"			,"@E 99,999,999.99"	,14		 )
	
	oSection:SetHeaderSection(.t.)
	oSection:Setnofilter("SC5")

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ReportPrint     บAutor  ณGiovani Zago    บ Data ณ  21/02/14  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Imprimi resultado da Query  	                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ReportPrint(oReport)

	Local oSection	:= oReport:Section(1)
	Local oSection1	:= oReport:Section(1)
	Local nX			:= 0
	Local cQuery 	:= ""
	Local cAlias 		:= "QRYTEMP0"
	Local aDados[2]
	Local aDados1[99]
	Local _cSta := ''
	Local _cDifHr	:= ""

	oSection1:Cell("PEDIDO")       	:SetBlock( { || aDados1[01] } )
	oSection1:Cell("OS")	  		:SetBlock( { || aDados1[02] } )
	oSection1:Cell("STATUS")  		:SetBlock( { || aDados1[03] } )
	oSection1:Cell("OPERADOR")  	:SetBlock( { || aDados1[04] } )
	oSection1:Cell("Dt_INICIO")	  	:SetBlock( { || aDados1[05] } )
	oSection1:Cell("H_INICIO")     	:SetBlock( { || aDados1[06] } )
	oSection1:Cell("Dt_FIM")       	:SetBlock( { || aDados1[07] } )
	oSection1:Cell("H_FIM")	  		:SetBlock( { || aDados1[08] } )
	oSection1:Cell("H_TOTAL")	  	:SetBlock( { || aDados1[09] } )
	oSection1:Cell("LINHAS")  		:SetBlock( { || aDados1[10] } )
	oSection1:Cell("QTD")  			:SetBlock( { || aDados1[11] } )
	oSection1:Cell("SEP_LINHAS")	:SetBlock( { || aDados1[12] } )
	oSection1:Cell("SEP_QTD")       :SetBlock( { || aDados1[13] } )
	oSection1:Cell("EMBALADOR")	  	:SetBlock( { || aDados1[14] } )
	oSection1:Cell("Dt_Ini_Emb")  	:SetBlock( { || aDados1[15] } )
	oSection1:Cell("H_Ini_Emb")  	:SetBlock( { || aDados1[16] } )
	oSection1:Cell("Dt_Fim_Emb")	:SetBlock( { || aDados1[17] } )
	oSection1:Cell("H_Fim_Emb")     :SetBlock( { || aDados1[18] } )
	oSection1:Cell("VOLUME")     	:SetBlock( { || aDados1[19] } )
	oSection1:Cell("DT_OS")     	:SetBlock( { || aDados1[20] } )
	oSection1:Cell("OP")     		:SetBlock( { || aDados1[21] } )
	oSection1:Cell("QTD_OP")     	:SetBlock( { || aDados1[22] } )
	oSection1:Cell("GRUPO")     	:SetBlock( { || aDados1[23] } )
	oSection1:Cell("NOMOPER")  		:SetBlock( { || aDados1[24] } )         //  Valdemir Rabelo 04/11/2020 -  Ticket: 20201103009892
	oSection1:Cell("ANO_OP")  		:SetBlock( { || aDados1[25] } )         //  Valdemir Rabelo 04/11/2020 -  Ticket: 20201103009892

	oReport:SetTitle("Os x Linha")// Titulo do relat๓rio

	oReport:SetMeter(0)
	aFill(aDados,nil)
	aFill(aDados1,nil)
	oSection:Init()

	If	MV_PAR11 == 1

		Processa({|| StQuery( ) },"Compondo Relatorio Sint้tico")

	ElseIf MV_PAR11 == 2

		Processa({|| StQueryAn( ) },"Compondo Relatorio Analํtico")

	EndIf

	dbSelectArea(cAliasLif)
	(cAliasLif)->(dbgotop())
	If  Select(cAliasLif) > 0

		While 	(cAliasLif)->(!Eof())
			If   Alltrim((cAliasLif)->xSTATUS) = '0'
				//0-Inicio;1-Separando;2-Sep.Final;3-Embalando;4-Emb.Final;5-Gera Nota;6-Imp.nota;7-Imp.Vol;8-Embarcado;9-Embarque Finalizado
				_cSta:= 'Inicio'
			ElseIf   Alltrim((cAliasLif)->xSTATUS) = '1'
				_cSta:= 'Separando'
			ElseIf   Alltrim((cAliasLif)->xSTATUS) = '2'
				_cSta:= 'Sep.Final'
			ElseIf   Alltrim((cAliasLif)->xSTATUS) = '3'
				_cSta:= 'Embalando'
			ElseIf   Alltrim((cAliasLif)->xSTATUS) = '4'
				_cSta:= 'Emb.Final'
			ElseIf   Alltrim((cAliasLif)->xSTATUS) = '8'
				_cSta:= 'Embarcado'
			ElseIf   Alltrim((cAliasLif)->xSTATUS) = '9'
				_cSta:= 'Embarque Finalizado'
			EndIf

			aDados1[01]	:= 	(cAliasLif)->PEDIDO
			aDados1[02]	:=  (cAliasLif)->OS
			aDados1[03]	:= Alltrim(	(cAliasLif)->xSTATUS)+' - '+ Alltrim(_cSta)

			DbSelectArea('CB1')
			CB1->(DbSetOrder(1))

			If CB1->(DbSeek(xFilial('CB1')+(cAliasLif)->OPERADOR))

				aDados1[24]	:= Alltrim(CB1->CB1_NOME)
				aDados1[04] := Alltrim((cAliasLif)->OPERADOR)		// Valdemir Rabelo 04/11/2020 -  Ticket: 20201103009892

			Else

				aDados1[04]	:=	(cAliasLif)->OPERADOR
				aDados1[24]	:= "Nใo Localizado no Cadastro Operadores (CB1)"

			EndIf

			aDados1[05]	:=	(cAliasLif)->INICIO
			aDados1[06]	:=	(cAliasLif)->HINICIO

			aDados1[07]	:= 	(cAliasLif)->FIM
			aDados1[08]	:=  (cAliasLif)->HFIM

			If (cAliasLif)->INICIO <> (cAliasLif)->FIM .AND. cEmpAnt = '03'

				If (cAliasLif)->HINICIO >= "07:00:00" .AND. (cAliasLif)->HINICIO <= "16:18:00"

					_cDifHr := ELAPTIME( (cAliasLif)->HINICIO, "16:18:00")

					If (cAliasLif)->HFIM >= "07:00:00" .AND. (cAliasLif)->HFIM <= "22:00:00"

						_cDifHr := SomaHoras( _cDifHr, ELAPTIME( "07:00:00", (cAliasLif)->HFIM))

					EndIF

				ElseIf (cAliasLif)->HINICIO >= "16:18:00" .AND. (cAliasLif)->HINICIO <= "22:00:00"

					_cDifHr := ELAPTIME( (cAliasLif)->HINICIO, "22:00:00")

					If (cAliasLif)->HFIM >= "07:00:00" .AND. (cAliasLif)->HFIM <= "22:00:00"

						_cDifHr := SomaHoras( _cDifHr, ELAPTIME( "07:00:00", (cAliasLif)->HFIM))

					EndIF

				EndIF

				aDados1[09] := incTime(StrTran(transform(_cDifHr,"@ 99.99"),".",":"))
				_cDifHr := ""

			Else

				aDados1[09]	:=  ELAPTIME( (cAliasLif)->HINICIO, (cAliasLif)->HFIM)

			EndIf

			aDados1[10]	:=	(cAliasLif)->LINHAS
			aDados1[11]	:=	(cAliasLif)->QTD
			aDados1[12]	:=	(cAliasLif)->SEPLINHAS
			aDados1[13]	:=	(cAliasLif)->SEPQTD

			DbSelectArea('CB1')
			CB1->(DbSetOrder(1))

			If CB1->(DbSeek(xFilial('CB1')+(cAliasLif)->EMBALADOR))

				aDados1[14]	:=Alltrim((cAliasLif)->EMBALADOR)+' - '+Alltrim(CB1->CB1_NOME)

			Else

				aDados1[14]	:=  (cAliasLif)->EMBALADOR

			EndIf

			aDados1[15]	:=	(cAliasLif)->EMBINICIO
			aDados1[16]	:=	(cAliasLif)->EMBHINICIO
			aDados1[17]	:=	(cAliasLif)->EMBFIM
			aDados1[18]	:=	(cAliasLif)->EMBHFIM
			aDados1[19]	:=	(cAliasLif)->VOLUME
			aDados1[20]	:=	(cAliasLif)->DT_OS
			aDados1[21]	:=	(cAliasLif)->OP
			aDados1[22]	:=	(cAliasLif)->QTDOP
			aDados1[23]	:=	Posicione('SBM',1,xFilial('SBM')+Posicione('SB1',1,xFilial('SB1')+Posicione('SC2',1,xFilial('SC2')+(cAliasLif)->OP,'C2_PRODUTO'),'B1_GRUPO'),'BM_DESC')
			aDados1[25] :=  (cAliasLif)->ANO_OP					// Valdemir Rabelo 04/11/2020 - Ticket: 20201103009892
			oSection1:PrintLine()
			aFill(aDados1,nil)

			(cAliasLif)->(dbskip())

		End

	EndIf

	oReport:SkipLine()

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  StQuery      บAutor  ณGiovani Zago    บ Data ณ  21/02/14     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Retorna Resultado da Query	Sintetica                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function StQuery()

	Local cQuery     := ' '


	cQuery := " SELECT
	cQuery += " 	substr(CB7.CB7_DTEMIS,7,2)||'/'||substr(CB7.CB7_DTEMIS,5,2)||'/'||substr(CB7.CB7_DTEMIS,1,4)
	cQuery += ' 	"DT_OS" ,
	cQuery += ' 	CB7.CB7_PEDIDO "PEDIDO" ,
	cQuery += ' 	CB7.CB7_OP "OP" ,
	cQuery += ' 	CB7.CB7_ORDSEP "OS" ,
	cQuery += ' 	CB7.CB7_STATUS "xSTATUS"  ,
	cQuery += '	 	CB7_CODOPE     "OPERADOR",
	cQuery += " 	substr(CB7.CB7_DTINIS,7,2)||'/'||substr(CB7.CB7_DTINIS,5,2)||'/'||substr(CB7.CB7_DTINIS,1,4)
	cQuery += ' 	"INICIO" ,
	cQuery += " 	substr(CB7.CB7_HRINIS,1,2)||':'||substr(CB7.CB7_HRINIS,3,2)||':'||SUBSTR(CB7.CB7_HRINIS,5,2)
	cQuery += ' 	"HINICIO"   ,
	cQuery += " 	substr(CB7.CB7_DTFIMS,7,2)||'/'||substr(CB7.CB7_DTFIMS,5,2)||'/'||substr(CB7.CB7_DTFIMS,1,4)
	cQuery += ' 	"FIM" ,
	cQuery += " 	substr(CB7.CB7_HRFIMS,1,2)||':'||substr(CB7.CB7_HRFIMS,3,2)||':'||SUBSTR(CB7.CB7_HRFIMS,5,2)
	cQuery += ' 	"HFIM" ,

	cQuery += " 	(SELECT COUNT( * )
	cQuery += " 		FROM "+RetSqlName("CB8")+" CB8 "
	cQuery += " 		WHERE CB8.CB8_FILIAL    = CB7.CB7_FILIAL
	cQuery += " 		AND CB8.D_E_L_E_T_      = ' '
	cQuery += ' 		AND CB8.CB8_ORDSEP      = CB7.CB7_ORDSEP ) "LINHAS",

	cQuery += " 	(SELECT SUM(CB8_QTDORI)
	cQuery += " 		FROM "+RetSqlName("CB8")+" CB8 "
	cQuery += " 		WHERE CB8.CB8_FILIAL    = CB7.CB7_FILIAL
	cQuery += " 		AND CB8.D_E_L_E_T_      = ' '
	cQuery += ' 		AND CB8.CB8_ORDSEP      = CB7.CB7_ORDSEP ) "QTD",

	cQuery += " 	(SELECT COUNT( * )
	cQuery += " 		FROM "+RetSqlName("CB8")+" CB8 "
	cQuery += " 		WHERE CB8.CB8_FILIAL    = CB7.CB7_FILIAL
	cQuery += " 		AND CB8.D_E_L_E_T_      = ' '
	cQuery += " 		AND CB8.CB8_ORDSEP      = CB7.CB7_ORDSEP
	cQuery += ' 		AND CB8.CB8_SALDOS      = 0) "SEPLINHAS",

	cQuery += " 	(SELECT SUM(CB8.CB8_QTDORI - CB8.CB8_SALDOS)
	cQuery += " 		FROM "+RetSqlName("CB8")+" CB8 "
	cQuery += " 		WHERE CB8.CB8_FILIAL    = CB7.CB7_FILIAL
	cQuery += " 		AND CB8.D_E_L_E_T_      = ' '
	cQuery += ' 		AND CB8.CB8_ORDSEP      = CB7.CB7_ORDSEP ) "SEPQTD" ,
	cQuery += ' 		CB6.CB6_XOPERA "EMBALADOR",
	cQuery += " 		substr(CB7.CB7_XDIEM ,7,2)||'/'||substr(CB7.CB7_XDIEM ,5,2)||'/'||substr(CB7.CB7_XDIEM ,1,4)
	cQuery += ' 		"EMBINICIO" ,
	cQuery += ' 		substr(CB7.CB7_XHIEM,1,5) "EMBHINICIO"   ,
	cQuery += " 		substr(CB7.CB7_XDFEM,7,2)||'/'||substr(CB7.CB7_XDFEM,5,2)||'/'||substr(CB7.CB7_XDFEM,1,4)
	cQuery += ' 		"EMBFIM" ,
	cQuery += ' 		substr(CB7.CB7_XHFEM,1,5) "EMBHFIM" ,

	cQuery += ' 	( SELECT  COUNT( * )
	cQuery += "   		FROM "+RetSqlName("CB6")+" CB6 "
	cQuery += '   		WHERE  CB6.CB6_XORDSE    = CB7.CB7_ORDSEP
	cQuery += '   		AND CB6.CB6_FILIAL    = CB7.CB7_FILIAL
	cQuery += "   		AND CB6.D_E_L_E_T_    = ' ' )
	cQuery += '   		"VOLUME"

	cQuery += " , NVL(( SELECT C2_QUANT FROM "+RetSqlName("SC2")+" SC2
	cQuery += "   		WHERE SC2.D_E_L_E_T_ = ' '
	cQuery += "   		AND SC2.C2_NUM =   SUBSTR(CB7.CB7_OP,1,6)
	cQuery += "   		AND SC2.C2_ITEM =   SUBSTR(CB7.CB7_OP,7,2)
	cQuery += "   		AND SC2.C2_SEQUEN =   SUBSTR(CB7.CB7_OP,9,3)),0)
	cQuery += '   		"QTDOP"

	cQuery += " , ( SELECT substr(SC2.C2_EMISSAO,1,4) FROM "+RetSqlName("SC2")+" SC2
	cQuery += "   		WHERE SC2.D_E_L_E_T_ = ' '
	cQuery += "   		AND SC2.C2_NUM =   SUBSTR(CB7.CB7_OP,1,6)
	cQuery += "   		AND SC2.C2_ITEM =   SUBSTR(CB7.CB7_OP,7,2)
	cQuery += "   		AND SC2.C2_SEQUEN =   SUBSTR(CB7.CB7_OP,9,3) )
	cQuery += '   		"ANO_OP" 

	cQuery += " FROM "+RetSqlName("CB7")+" CB7 "

	cQuery += " LEFT JOIN(SELECT  DISTINCT CB6_XORDSE,CB6_FILIAL,D_E_L_E_T_,CB6_XOPERA  FROM "+RetSqlName("CB6")+" )CB6 "
	cQuery += " ON  CB6.CB6_XORDSE    = CB7.CB7_ORDSEP
	cQuery += " AND CB6.CB6_FILIAL    = CB7.CB7_FILIAL
	cQuery += " AND CB6.D_E_L_E_T_    = ' '

	cQuery += " WHERE CB7.D_E_L_E_T_  = ' '
	cQuery += " 	AND CB7.CB7_DTINIS BETWEEN   '" + dTos(MV_PAR01) + "' AND '" + dTos(MV_PAR02) + "' "
	cQuery += " 	AND CB7.CB7_FILIAL = '"+xFilial("CB7")+"'"
	cQuery += " 	AND CB7.CB7_ORDSEP BETWEEN   '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' "
	cQuery += " 	AND CB7.CB7_PEDIDO BETWEEN   '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "
	cQuery += " 	AND CB7.CB7_CODOPE BETWEEN   '" + MV_PAR07 + "' AND '" + MV_PAR08 + "' "
	cQuery += " 	AND CB7.CB7_STATUS BETWEEN   '" + MV_PAR09 + "' AND '" + MV_PAR10 + "' "

	cQuery += " ORDER BY CB7_ORDSEP

	cQuery := ChangeQuery(cQuery)

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  StQueryAn   บAutor  ณRenan Rosario    บ Data ณ  18/04/19      บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Retorna Resultado da Query		                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function StQueryAn()

	Local cQuery     := ' '

	cQuery := 		 " SELECT DISTINCT substr(CB7.CB7_DTEMIS,7,2)||'/'||substr(CB7.CB7_DTEMIS,5,2)||'/'||substr(CB7.CB7_DTEMIS,1,4) AS DT_OS , "
	cQuery += CRLF + " 	CB7.CB7_PEDIDO AS PEDIDO , 	CB7.CB7_OP AS OP , 	CB7.CB7_ORDSEP AS OS , 	CB7.CB7_STATUS AS xSTATUS  ,	 CB7_CODOPE AS OPERADOR,"
	cQuery += CRLF + "	substr(CB7.CB7_DTINIS,7,2)||'/'||substr(CB7.CB7_DTINIS,5,2)||'/'||substr(CB7.CB7_DTINIS,1,4) AS INICIO ,"
	cQuery += CRLF + "	substr(CB7.CB7_HRINIS,1,2)||':'||substr(CB7.CB7_HRINIS,3,2) AS HINICIO   ,
	cQuery += CRLF + "	substr(CB7.CB7_DTFIMS,7,2)||'/'||substr(CB7.CB7_DTFIMS,5,2)||'/'||substr(CB7.CB7_DTFIMS,1,4) AS FIM , "
	cQuery += CRLF + "	substr(CB7.CB7_HRFIMS,1,2)||':'||substr(CB7.CB7_HRFIMS,3,2) AS HFIM , CB8.CB8_QTDORI AS QTD,"

	cQuery += CRLF + "	(SELECT COUNT( * ) "
	cQuery += CRLF + "		FROM "+RetSqlName("CB8")+" CB8 "
	cQuery += CRLF + "		WHERE CB8.CB8_FILIAL    = CB7.CB7_FILIAL "
	cQuery += CRLF + "		AND CB8.D_E_L_E_T_    	<> '*' "
	cQuery += CRLF + "		AND CB8.CB8_ORDSEP      = CB7.CB7_ORDSEP ) AS LINHAS, "

	cQuery += CRLF + "	(SELECT COUNT( * ) "
	cQuery += CRLF + "		FROM "+RetSqlName("CB8")+" CB8"
	cQuery += CRLF + "		WHERE CB8.CB8_FILIAL    = CB7.CB7_FILIAL "
	cQuery += CRLF + "		AND CB8.D_E_L_E_T_      <> '*'"
	cQuery += CRLF + "		AND CB8.CB8_ORDSEP      = CB7.CB7_ORDSEP "
	cQuery += CRLF + "		AND CB8.CB8_SALDOS      = 0) AS SEPLINHAS, "



	cQuery += CRLF + "	CB6.CB6_XOPERA AS EMBALADOR, "
	cQuery += CRLF + "	substr(CB7.CB7_XDIEM ,7,2)||'/'||substr(CB7.CB7_XDIEM ,5,2)||'/'||substr(CB7.CB7_XDIEM ,1,4) AS EMBINICIO , "
	cQuery += CRLF + "	substr(CB7.CB7_XHIEM,1,5) AS EMBHINICIO, "
	cQuery += CRLF + "	substr(CB7.CB7_XDFEM,7,2)||'/'||substr(CB7.CB7_XDFEM,5,2)||'/'||substr(CB7.CB7_XDFEM,1,4) AS EMBFIM , "
	cQuery += CRLF + "	substr(CB7.CB7_XHFEM,1,5) AS EMBHFIM ,"


	cQuery += CRLF + "		NVL(( SELECT C2_QUANT "
	cQuery += CRLF + "				FROM "+RetSqlName("SC2")+" SC2 "
	cQuery += CRLF + "				WHERE SC2.D_E_L_E_T_    <> '*'  "
	cQuery += CRLF + "				AND SC2.C2_NUM 		    =   SUBSTR(CB7.CB7_OP,1,6)  "
	cQuery += CRLF + "				AND SC2.C2_ITEM     	=   SUBSTR(CB7.CB7_OP,7,2)  "
	cQuery += CRLF + "				AND SC2.C2_SEQUEN 	    =   SUBSTR(CB7.CB7_OP,9,3)),0) AS QTDOP, "

	cQuery += CRLF + "		( SELECT substr(SC2.C2_EMISSAO,1,4) "
	cQuery += CRLF + "				FROM "+RetSqlName("SC2")+" SC2 "
	cQuery += CRLF + "				WHERE SC2.D_E_L_E_T_    <> '*'  "
	cQuery += CRLF + "				AND SC2.C2_NUM 		    =   SUBSTR(CB7.CB7_OP,1,6)  "
	cQuery += CRLF + "				AND SC2.C2_ITEM     	=   SUBSTR(CB7.CB7_OP,7,2)  "
	cQuery += CRLF + "				AND SC2.C2_SEQUEN 	    =   SUBSTR(CB7.CB7_OP,9,3) ) AS ANO_OP "

	cQuery += CRLF + "	FROM "+RetSqlName("CB7")+"  CB7  "

	cQuery += CRLF + "	LEFT JOIN "
	cQuery += CRLF + "		(SELECT  DISTINCT CB6_XORDSE,CB6_FILIAL,D_E_L_E_T_,CB6_XOPERA  "
	cQuery += CRLF + "			FROM "+RetSqlName("CB6")+" )CB6  ON  "

	cQuery += CRLF + "		CB6.CB6_XORDSE    		= CB7.CB7_ORDSEP "
	cQuery += CRLF + "		AND CB6.CB6_FILIAL    	= CB7.CB7_FILIAL "
	cQuery += CRLF + "		AND CB6.D_E_L_E_T_    	<> '*' "

	cQuery += CRLF + "      INNER JOIN "+RetSqlName("CB6")+" CB6 ON "
	cQuery += CRLF + "      CB6.CB6_XORDSE          = CB7.CB7_ORDSEP "
	cQuery += CRLF + "		AND CB6.CB6_FILIAL      = CB7.CB7_FILIAL   "
	cQuery += CRLF + "		AND CB6.D_E_L_E_T_      <> '*' "

	cQuery += CRLF + "      INNER JOIN "+RetSqlName("CB8")+" CB8 ON "
	cQuery += CRLF + "      CB8.CB8_FILIAL    		= CB7.CB7_FILIAL "
	cQuery += CRLF + "		AND CB8.D_E_L_E_T_    	<> '*' 	"
	cQuery += CRLF + "		AND CB8.CB8_ORDSEP      = CB7.CB7_ORDSEP "

	cQuery += CRLF + "	WHERE CB7.D_E_L_E_T_  <> '*'"
	cQuery += CRLF + "		AND CB7.CB7_DTINIS BETWEEN    '" + dTos(MV_PAR01) + "' AND '" + dTos(MV_PAR02) + "' "
	cQuery += CRLF + "		AND CB7.CB7_FILIAL = '"+xFilial("CB7")+"'"
	cQuery += CRLF + "		AND CB7.CB7_ORDSEP BETWEEN   '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' "
	cQuery += CRLF + "		AND CB7.CB7_PEDIDO BETWEEN   '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "
	cQuery += CRLF + "		AND CB7.CB7_CODOPE BETWEEN   '" + MV_PAR07 + "' AND '" + MV_PAR08 + "' "
	cQuery += CRLF + "		AND CB7.CB7_STATUS BETWEEN   '" + MV_PAR09 + "' AND '" + MV_PAR10 + "' "

	cQuery += CRLF + "	ORDER BY CB7_ORDSEP "

	cQuery := ChangeQuery(cQuery)

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()

/*====================================================================================\
|Programa  | xPutSx1	     | Autor | RENATO.OLIVEIRA           | Data | 13/02/2019  |
|=====================================================================================|
|Descri็ใo |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Hist๓rico....................................|
\====================================================================================*/

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
