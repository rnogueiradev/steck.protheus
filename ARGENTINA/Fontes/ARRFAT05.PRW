#INCLUDE "Topconn.ch"
#INCLUDE "Protheus.ch"

/*/{Protheus.doc} ARRFAT05

Ventas por Artículo/Grupo

@type function
@author Everson Santana
@since 19/09/18
@version Protheus 12 - Faturamento

@history , ,

/*/

User Function ARRFAT05()

	/*
	Declaracao de variaveis
	*/
	Private _oReport := Nil
	Private _oSecCab := Nil
	Private _cPerg 	 := PadR ("ARRFAT05", Len (SX1->X1_GRUPO))
	//Private _cTipo	 := ""
	//Private _cTipo1	 := ""
	Private _cTitulo := ""

	ValidPerg()

	Pergunte(_cPerg,.T.)

	/*
	Definicoes/preparacao para impressao
	*/
	ReportDef()
	_oReport:PrintDialog()

Return
/*
Definição da estrutura do relatório.
*/
Static Function ReportDef()

	If MV_PAR03 == 1
		_cTitulo := "Ventas por Artículo"
	Else
		_cTitulo := "Ventas por Grupo"
	EndIF

	_oReport := TReport():New("ARRFAT05",_cTitulo+" - "+Alltrim(aPergunta[1][1])+" : "+StrZero(MV_PAR01,2)+" "+Alltrim(aPergunta[2][1])+" : "+Alltrim(Str(MV_PAR02)),_cPerg,{|_oReport| PrintReport(_oReport)},_cTitulo)

	//If MV_PAR03 == 1

	_oSecCab := TRSection():New( _oReport , _cTitulo, {"QRY"} )

	If MV_PAR03 = 1
		TRCell():New( _oSecCab, "PRODUTOATU"	,,"Produto		"	,PesqPict('SB1',"B1_COD")	,TamSX3("B1_COD")[1],.F.,)
		TRCell():New( _oSecCab, "DESCRI"		,,"Descrição	" 	,PesqPict('SB1',"B1_DESC")	,TamSX3("B1_DESC")[1],.F.,)
	Else

		TRCell():New( _oSecCab, "PRODUTOATU"	,,"Grupo		"	,PesqPict('SBM',"BM_GRUPO")	,TamSX3("BM_GRUPO")[1],.F.,)
		TRCell():New( _oSecCab, "DESCRI"		,,"Descrição	" 	,PesqPict('SBM',"BM_DESC")	,TamSX3("BM_DESC")[1],.F.,)
	EndIF

	TRCell():New( _oSecCab, "MESATU"  		,,"Mes Atual		" ,"@!"	,2	,.F.,)
	TRCell():New( _oSecCab, "ANOATU"  		,,"Ano Atual		" ,"@!" ,4,.F.,)
	TRCell():New( _oSecCab, "QTDFATATU"  	,,"Qtd Atual 		" ,PesqPict('SD2',"D2_QUANT")	,TamSX3("D2_QUANT")[1]	,.F.,)
	TRCell():New( _oSecCab, "VLRFATATU"  	,,"Vlr Atual 		" ,PesqPict('SD2',"D2_TOTAL")	,TamSX3("D2_TOTAL")[1]	,.F.,)
	TRCell():New( _oSecCab, "MESANT"  		,,"Mes Anterior		" ,"@!"	,2	,.F.,)
	TRCell():New( _oSecCab, "ANOANT"  		,,"Ano Anterior		" ,"@!"	,4,.F.,)
	TRCell():New( _oSecCab, "QTDFATANT"  	,,"Qtd Anterior		" ,PesqPict('SD2',"D2_QUANT")	,TamSX3("D2_QUANT")[1]	,.F.,)
	TRCell():New( _oSecCab, "VLRFATANT"  	,,"Vlr Anterior		" ,PesqPict('SD2',"D2_TOTAL")	,TamSX3("D2_TOTAL")[1]	,.F.,)

	TRFunction():New(_oSecCab:Cell("QTDFATATU"),NIL,"SUM",,,,,.F.,.T.)
	TRFunction():New(_oSecCab:Cell("VLRFATATU"),NIL,"SUM",,,,,.F.,.T.)
	TRFunction():New(_oSecCab:Cell("QTDFATANT"),NIL,"SUM",,,,,.F.,.T.)
	TRFunction():New(_oSecCab:Cell("VLRFATANT"),NIL,"SUM",,,,,.F.,.T.)

Return Nil
/*
Processamento da Query
*/
Static Function PrintReport(_oReport)

	Local _cQuery     := ""

	_cQuery += "        SELECT * FROM    "
	_cQuery += "           ( SELECT PRODUTOATU,DESCATU,MESATU, ANOATU, SUM(QTDFATATU) QTDFATATU,SUM(VLRFATATU) VLRFATATU  "

	_cQuery += "                 FROM (             "

	If MV_PAR03 = 1
		_cQuery += "                        SELECT SD2.D2_COD PRODUTOATU,SB1.B1_DESC DESCATU,SUBSTR(SD2.D2_EMISSAO,5,2) MESATU, SUBSTR(SD2.D2_EMISSAO,1,4) ANOATU,SD2.D2_QUANT QTDFATATU,SD2.D2_TOTAL AS VLRFATATU "
	Else
		_cQuery += " 						SELECT SB1.B1_GRUPO PRODUTOATU,SBM.BM_DESC DESCATU,SUBSTR(SD2.D2_EMISSAO,5,2) MESATU, SUBSTR(SD2.D2_EMISSAO,1,4) ANOATU,SD2.D2_QUANT QTDFATATU,SD2.D2_TOTAL AS VLRFATATU "
	EndIf
	_cQuery += "                             FROM " + RetSqlName("SD2") +" SD2 "
	_cQuery += "                                 INNER JOIN(SELECT * FROM " + RetSqlName("SF4") +") SF4 "
	_cQuery += "                                     ON SF4.D_E_L_E_T_ = ' ' "
	_cQuery += "                                     AND F4_CODIGO = D2_TES "
	_cQuery += "                                     AND F4_DUPLIC = 'S' "
	_cQuery += "                                     AND F4_CF IN('612') "
	_cQuery += "                                INNER JOIN " + RetSqlName("SB1") + " SB1 "
	_cQuery += "                                     ON SB1.B1_COD = SD2.D2_COD "
	_cQuery += "                                     AND SB1.D_E_L_E_T_ = ' ' "

	If MV_PAR03 = 2

		_cQuery += "                                INNER JOIN " + RetSqlName("SBM") + " SBM "
		_cQuery += "                                     ON SBM.BM_GRUPO = SB1.B1_GRUPO "
		_cQuery += "                                     AND SBM.D_E_L_E_T_ = ' ' "

	EndIF

	_cQuery += "                             WHERE SD2.D_E_L_E_T_ = ' ' "
	_cQuery += "                                 AND SD2.D2_SERIE <> 'R' "
	_cQuery += "                                 AND SD2.D2_ESPECIE = 'NF' "
	_cQuery += "                                 AND SUBSTR(SD2.D2_EMISSAO,5,2) = '"+ StrZero(MV_PAR01,2) + "' "
	_cQuery += "                                 AND SUBSTR(SD2.D2_EMISSAO,1,4) = '"+ Alltrim(Str(MV_PAR02)) + "' "

	_cQuery += " UNION ALL "

	If MV_PAR03 = 1
		_cQuery += "        SELECT SD1.D1_COD PRODUTOATU,SB1.B1_DESC DESCATU,SUBSTR(SD1.D1_DTDIGIT,5,2) MESATU, SUBSTR(SD1.D1_DTDIGIT,1,4) ANOATU,((SD1.D1_QUANT)*-1) QTDFATATU,((SD1.D1_TOTAL)*-1) AS VLRFATATU "
	Else
		_cQuery += "    	SELECT SB1.B1_GRUPO PRODUTOANT,SBM.BM_DESC DESCRICAOANT,SUBSTR(SD1.D1_DTDIGIT,5,2) MESANT, SUBSTR(SD1.D1_DTDIGIT,1,4) ANOANT,((SD1.D1_QUANT)*-1) QTDFATANT,((SD1.D1_TOTAL)*-1) AS VLRFATANT "
	EndIf


	_cQuery += "			FROM "+RetSqlName("SD1")+" SD1 " 	
	_cQuery += "                                         INNER JOIN(SELECT * FROM "+RetSqlName("SF4")+") SF4 "  
	_cQuery += "                                             ON SF4.D_E_L_E_T_ = ' ' " 
	_cQuery += "                                                 AND F4_CODIGO = D1_TES " 
	_cQuery += "                                                     AND F4_DUPLIC = 'S' " 
	_cQuery += "                                         INNER JOIN "+RetSqlName("SB1")+" SB1 "                                      
	_cQuery += "                                            ON SB1.B1_COD = SD1.D1_COD "                                      
	_cQuery += "                                            AND SB1.D_E_L_E_T_ = ' ' "  
	
	If MV_PAR03 = 2

		_cQuery += "                                INNER JOIN " + RetSqlName("SBM") + " SBM "
		_cQuery += "                                     ON SBM.BM_GRUPO = SB1.B1_GRUPO "
		_cQuery += "                                     AND SBM.D_E_L_E_T_ = ' ' "

	EndIF
	      
	_cQuery += "			WHERE   SUBSTR(SD1.D1_DTDIGIT,5,2) = '"+ StrZero(MV_PAR01,2) + "' "                                  
	_cQuery += "				AND SUBSTR(SD1.D1_DTDIGIT,1,4) = '"+ Alltrim(Str(MV_PAR02)) + "' "  
	_cQuery += "    			AND D1_CF IN('112') " 
	_cQuery += "				AND D1_TIPO IN('D') " 
	_cQuery += "				AND D1_ESPECIE IN('NCC') " 
	_cQuery += "				AND D1_TP = 'PA' " 					
	_cQuery += "				AND SD1.D_E_L_E_T_ = ' ' "

	_cQuery += "                 ) TMPFAT "
	_cQuery += "            GROUP BY PRODUTOATU,DESCATU,MESATU, ANOATU          "
	_cQuery += "            ) ANOATU "
	_cQuery += "            LEFT JOIN  "
	_cQuery += "            (SELECT PRODUTOANT,DESCRICAOANT, MESANT, ANOANT, SUM(QTDFATANT) QTDFATANT,SUM(VLRFATANT) VLRFATANT  "
	_cQuery += "                 FROM (             "

	If MV_PAR03 = 1
		_cQuery += "                        SELECT SD2.D2_COD PRODUTOANT,SB1.B1_DESC DESCRICAOANT,SUBSTR(SD2.D2_EMISSAO,5,2) MESANT, SUBSTR(SD2.D2_EMISSAO,1,4) ANOANT,SD2.D2_QUANT QTDFATANT,SD2.D2_TOTAL AS VLRFATANT "
	Else
		_cQuery += " 						SELECT SB1.B1_GRUPO PRODUTOANT,SBM.BM_DESC DESCRICAOANT,SUBSTR(SD2.D2_EMISSAO,5,2) MESANT, SUBSTR(SD2.D2_EMISSAO,1,4) ANOANT,SD2.D2_QUANT QTDFATANT,SD2.D2_TOTAL AS VLRFATANT "
	EndIf
	_cQuery += "                             FROM " + RetSqlName("SD2") + " SD2 "
	_cQuery += "                                 INNER JOIN(SELECT * FROM " + RetSqlName("SF4") + " ) SF4 "
	_cQuery += "                                     ON SF4.D_E_L_E_T_ = ' ' "
	_cQuery += "                                     AND F4_CODIGO = D2_TES "
	_cQuery += "                                     AND F4_CF IN('612') "
	_cQuery += "                                INNER JOIN " + RetSqlName("SB1") +" SB1 "
	_cQuery += "                                     ON SB1.B1_COD = SD2.D2_COD "
	_cQuery += "                                     AND SB1.D_E_L_E_T_ = ' ' "
	If MV_PAR03 = 2

		_cQuery += "                                INNER JOIN " + RetSqlName("SBM") + " SBM "
		_cQuery += "                                     ON SBM.BM_GRUPO = SB1.B1_GRUPO "
		_cQuery += "                                     AND SBM.D_E_L_E_T_ = ' ' "

	EndIF

	_cQuery += "                             WHERE SD2.D_E_L_E_T_ = ' ' "
	_cQuery += "                                 AND SD2.D2_SERIE <> 'R' "
	_cQuery += "                                 AND SD2.D2_ESPECIE = 'NF' "
	_cQuery += "                                 AND SUBSTR(SD2.D2_EMISSAO,5,2) = '"+ StrZero(MV_PAR01,2) + "' "
	_cQuery += "                                 AND SUBSTR(SD2.D2_EMISSAO,1,4) = '"+ AllTrim(Str(MV_PAR02 - 1)) + "' " 
	
	_cQuery += " UNION ALL "

	If MV_PAR03 = 1
		_cQuery += "        SELECT SD1.D1_COD PRODUTOATU,SB1.B1_DESC DESCATU,SUBSTR(SD1.D1_DTDIGIT,5,2) MESATU, SUBSTR(SD1.D1_DTDIGIT,1,4) ANOATU,((SD1.D1_QUANT)*-1) QTDFATATU,((SD1.D1_TOTAL)*-1) AS VLRFATATU "
	Else
		_cQuery += "    	SELECT SB1.B1_GRUPO PRODUTOANT,SBM.BM_DESC DESCRICAOANT,SUBSTR(SD1.D1_DTDIGIT,5,2) MESANT, SUBSTR(SD1.D1_DTDIGIT,1,4) ANOANT,((SD1.D1_QUANT)*-1) QTDFATANT,((SD1.D1_TOTAL)*-1) AS VLRFATANT "
	EndIf


	_cQuery += "			FROM "+RetSqlName("SD1")+" SD1 " 	
	_cQuery += "                                         INNER JOIN(SELECT * FROM "+RetSqlName("SF4")+") SF4 "  
	_cQuery += "                                             ON SF4.D_E_L_E_T_ = ' ' " 
	_cQuery += "                                                 AND F4_CODIGO = D1_TES " 
	_cQuery += "                                                     AND F4_DUPLIC = 'S' " 
	_cQuery += "                                         INNER JOIN "+RetSqlName("SB1")+" SB1 "                                      
	_cQuery += "                                            ON SB1.B1_COD = SD1.D1_COD "                                      
	_cQuery += "                                            AND SB1.D_E_L_E_T_ = ' ' "  
	
	If MV_PAR03 = 2

		_cQuery += "                                INNER JOIN " + RetSqlName("SBM") + " SBM "
		_cQuery += "                                     ON SBM.BM_GRUPO = SB1.B1_GRUPO "
		_cQuery += "                                     AND SBM.D_E_L_E_T_ = ' ' "

	EndIF
	      
	_cQuery += "			WHERE   SUBSTR(SD1.D1_DTDIGIT,5,2) = '"+ StrZero(MV_PAR01,2) + "' "                                  
	_cQuery += "				AND SUBSTR(SD1.D1_DTDIGIT,1,4) = '"+ Alltrim(Str(MV_PAR02 - 1)) + "' "  
	_cQuery += "    			AND D1_CF IN('112') " 
	_cQuery += "				AND D1_TIPO IN('D') " 
	_cQuery += "				AND D1_ESPECIE IN('NCC') " 
	_cQuery += "				AND D1_TP = 'PA' " 					
	_cQuery += "				AND SD1.D_E_L_E_T_ = ' ' "
	
	
	
	_cQuery += "                 ) TMPFAT "
	_cQuery += "            GROUP BY PRODUTOANT,DESCRICAOANT,MESANT, ANOANT ) ANOANT "
	_cQuery += "            ON ANOATU.PRODUTOATU = ANOANT.PRODUTOANT "
	_cQuery += "			ORDER BY PRODUTOATU "

	If Select("QRY") > 0
		Dbselectarea("QRY")
		QRY->(DbClosearea())
	EndIf

	TcQuery _cQuery New Alias "QRY"

	dbSelectArea("QRY")
	QRY->(dbGoTop())

	While !QRY->(Eof())

		While !QRY->(Eof()) 

			_oSecCab:Init()

			_oSecCab:Cell("PRODUTOATU"):SetValue(QRY->PRODUTOATU)
			_oSecCab:Cell("DESCRI"):SetValue(Alltrim(QRY->DESCATU))
			_oSecCab:Cell("MESATU"):SetValue(QRY->MESATU)
			_oSecCab:Cell("ANOATU"):SetValue(QRY->ANOATU)
			_oSecCab:Cell("QTDFATATU"):SetValue(QRY->QTDFATATU)
			_oSecCab:Cell("VLRFATATU"):SetValue(QRY->VLRFATATU)
			_oSecCab:Cell("MESANT"):SetValue(QRY->MESANT)
			_oSecCab:Cell("ANOANT"):SetValue(QRY->ANOANT)
			_oSecCab:Cell("QTDFATANT"):SetValue(QRY->QTDFATANT)
			_oSecCab:Cell("VLRFATANT"):SetValue(QRY->VLRFATANT)


			_oSecCab:PrintLine()

			QRY->(DbSkip())

		EndDo
		_oReport:ThinLine()

	EndDo
	_oSecCab:Finish()


Return Nil
/*
Criacao e apresentacao das perguntas
*/
Static Function ValidPerg()
	Local _sAlias := GetArea()
	Local _aRegs  := {}
	Local i := 0
	Local j := 0
	_cPerg         := PADR(_cPerg,10)
	AADD(_aRegs,{_cPerg,"01","Mes ?"	,"Mes ?"	,"Mes ? "	,"mv_ch1","N",02,0,0,"G","          ","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(_aRegs,{_cPerg,"02","Año ?"	,"Año ?"	,"Año ? "	,"mv_ch2","N",04,0,0,"G","          ","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(_aRegs,{_cPerg,"03","Tipo ?"	,"Tipo ? "	,"Tipo ?  "	,"mv_ch3","N",01,0,0,"C","          ","mv_par03","Articulo","Articulo","Articulo","","","Grupo","Grupo","Grupo","","","","","","","","","","","","","","","","","",""})
	//AADD(_aRegs,{_cPerg,"04","Do Vendedor ? "	,"Do Vendedor ? "	,"Do Vendedor ?","mv_ch4","C",06,0,0,"G","          ","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	//AADD(_aRegs,{_cPerg,"05","Ate Vendedor?"	,"Ate Vendedor?"	,"Ate Vendedor?","mv_ch5","C",06,0,0,"G","          ","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})

	dbSelectArea("SX1")
	SX1->(dbSetOrder(1))
	for i := 1 to len(_aRegs)
		If !SX1->(dbSeek(_cPerg+_aRegs[i,2]))
			RecLock("SX1",.T.)
			for j := 1 to FCount()
				If j <= Len(_aRegs[i])
					FieldPut(j,_aRegs[i,j])
				Else
					Exit
				EndIf
			next
			MsUnlock()
		EndIf
	next
	RestArea(_sAlias)


Return