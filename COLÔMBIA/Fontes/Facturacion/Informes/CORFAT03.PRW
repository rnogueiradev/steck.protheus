#INCLUDE "Protheus.ch"
#INCLUDE "Topconn.ch"
#include "TBICONN.CH"

/*/{Protheus.doc} CORFAT03

Totales Mensuales

@type function
@author Everson Santana
@since 12/09/18
@version Protheus 12 - Faturamento

@history , ,

/*/

User Function CORFAT03()

	/*
	Declaracao de variaveis
	*/
	Private _oReport := Nil
	Private _oSecCab := Nil
	Private _cPerg 	 := PadR ("CORFAT03B", Len (SX1->X1_GRUPO))
	Private _cTitulo := ""
	Private aDados   := {}
	Private aCABEC   := {}
	Private dDatIni  := ctod('')
	Private dDatFim  := ctod('')

	ValidPerg()

	Pergunte(_cPerg,.T.)

	dDatFim  := ctod('01/01/'+cValToChar(MV_PAR01+1))
	dDatIni  := ctod('01/01/'+cValToChar(MV_PAR01-1))

	/*
	Definicoes/preparacao para impressao
	*/
	ReportDef()
	_oReport:PrintDialog()

Return



/* {Protheus.doc} Function ReportDef
	Description
	Rotina para tratar campos a serem apresentados
	@author Valdemir Rabelo - valdemir.rabelo@sigamat.com.br
	@since 13/02/2020
*/
Static Function ReportDef()
	Local nX := 0

	AbreQry()

	If MV_PAR02 == 1
		_cTitulo := "Totales Mensuales - Facturado"
	Else
		_cTitulo := "Totales Mensuales - Captado"
	EndIF

	_oReport := TReport():New("CORFAT03",_cTitulo + " - " + Alltrim(aPergunta[1][1])+" : "+Alltrim(Str(MV_PAR01)),_cPerg,{|_oReport| PrintReport(_oReport)},_cTitulo)
	_oReport:cFontBody := 'Courier New'
	_oReport:nFontBody := 10

	_oReport:SetTotalInLine(.F.)
	_oSecCab := TRSection():New( _oReport , _cTitulo, {"QRY"} )
	_oSecCab:SetTotalInLine(.F.)
	

	For nX := 1 to Len(aCABEC)    
		if nX == 1
			TRCell():New( _oSecCab, "MES"		,,"Meses 		" ,"@!"	,20,.F.,)		
		else
		    if (MV_PAR02 == 2) .AND. nX == 2
			   TRCell():New( _oSecCab, aCABEC[nX] 	,,"% IVA" ,PesqPict('SC6',"C6_VALOR")	,TamSX3("C6_VALOR")[1]	,.F.,)
			   TRCell():SetTitle("% IVA")
			Endif
			TRCell():New( _oSecCab, aCABEC[nX] 	,,aCABEC[nX] ,PesqPict('SC6',"C6_VALOR")	,TamSX3("C6_VALOR")[1]	,.F.,)
		endif
	Next
	TRCell():New( _oSecCab, "PER"  		,,"  %  " ,PesqPict('SD2',"D2_TOTAL")	,TamSX3("D2_TOTAL")[1]	,.F.,)



	If MV_PAR02 == 1

		For nX := 2 to Len(aCABEC)    
			TRFunction():New(_oSecCab:Cell(aCABEC[nX]),"TOTAL"+cValToChar(nX),"SUM",,,,,.F.,.T.)
		Next

	Else

		For nX := 3 to Len(aCABEC)  
		    TRCell():New( _oSecCab, "TIVA"+aCABEC[nX]		,,"Tot.IVA "+aCABEC[nX] ,PesqPict('SC6',"C6_VALOR")	,TamSX3("C6_VALOR")[1]	,.F.,)
		Next
		TRCell():New( _oSecCab, "PER2"     ,," % " ,PesqPict('SC6',"C6_VALOR")	,TamSX3("C6_VALOR")[1]	,.F.,)

		//oBreak := TRBreak():New(_oSecCab, _oSecCab:Cell(aCABEC[2]), "Sub Total",,.F.)
		
		For nX := 3 to Len(aCABEC)    
			TRFunction():New(_oSecCab:Cell(aCABEC[nX]),"TOTAL","SUM",,,,,.F.,.T.)
			TRFunction():New(_oSecCab:Cell("TIVA"+cValToChar(aCABEC[nX])),NIL,"SUM",,,,,.F.,.T.)
		Next
	EndIf


Return Nil



/* {Protheus.doc} Function AbreQry
	Description
	Rotina para Abrir tabela conforme parametro
	@author Valdemir Rabelo - valdemir.rabelo@sigamat.com.br
	@since 13/02/2020
*/
Static Function AbreQry()
	Local _cQuery     := ""

    _cQuery  := MntQry()

 	if Select("QRY") > 0
		QRY->( dbCloseArea() )
	Endif

	TcQuery _cQuery new Alias "QRY"

	aStru := QRY->( dbStruct() )
	aEval(aStru, {|aField| aAdd(aCABEC, aField[1]) })

Return


/* {Protheus.doc} Function PrintReport
	Description
	Rotina para tratativas de campos para relatï¿½rio
	@author Valdemir Rabelo - valdemir.rabelo@sigamat.com.br
	@since 13/02/2020
*/
Static Function PrintReport(_oReport)

	Local _cPeriodo	  := ""
	Local _cCampo     := ""
	Local nPerc       := 0
	Local _nTIVA	  := 0
	Local _nTotal	  := 0
	Local nX    	  := 0

	If MV_PAR02 == 1
		dbSelectArea("QRY")

		QRY->(dbGoTop())

		While !QRY->(Eof())

			While !QRY->(Eof()) 
				nPerc := 0
				_oSecCab:Init()

				_oSecCab:Cell("MES"):SetValue(_cPeriodo)
				FOR nX := 1 TO LEN(aCABEC)
				    IF nX == 1
						_cPeriodo := MesEspEx( Val(QRY->&(aCABEC[nX])) )
						_oSecCab:Cell("MES"):SetValue(_cPeriodo)
					ELSE
					    _cCampo     := aCABEC[nX]
						_oSecCab:Cell(_cCampo):SetValue( QRY->(FieldGet(FieldPos(aCABEC[nX]))) )
					ENDIF
				NEXT
				if QRY->(FieldGet(FieldPos(aCABEC[3]))) > 0
					nPerc	  := (( ( QRY->(FieldGet(FieldPos(aCABEC[3]))) / QRY->(FieldGet(FieldPos(aCABEC[2]))) ) -1)*100)
				else
				    nPerc	  := -100
				Endif
				_oSecCab:Cell("PER"):SetValue(nPerc)
				
				_oSecCab:PrintLine()

				QRY->(DbSkip())

			EndDo
			_oReport:ThinLine()

		EndDo
		_oSecCab:Finish()
	Else

		dbSelectArea("QRY")
		QRY->(dbGoTop())

		While !QRY->(Eof())
		
			While !QRY->(Eof()) 
				nPerc := 0
				_oSecCab:Init()
				_oSecCab:Cell("MES"):SetValue(_cPeriodo)
				FOR nX := 1 TO LEN(aCABEC)
				    IF nX == 1
						_cPeriodo := MesEspEx( Val(QRY->&(aCABEC[nX])) )
						_oSecCab:Cell("MES"):SetValue(_cPeriodo)
					ELSE
					    _cCampo     := aCABEC[nX]
						_oSecCab:Cell(_cCampo):SetValue( QRY->(FieldGet(FieldPos(aCABEC[nX]))) )
					ENDIF
				NEXT
				if QRY->(FieldGet(FieldPos(aCABEC[4]))) > 0
					nPerc	  := (100-( (QRY->(FieldGet(FieldPos(aCABEC[3])))*100)/QRY->(FieldGet(FieldPos(aCABEC[4]))) ) )
				else
					nPerc	  := -100
				endif
				_oSecCab:Cell("PER"):SetValue(nPerc)				

				cFormula := "(100-("
				FOR nX := 3 TO LEN(aCABEC)
					_nTIVA  := ((QRY->(FieldGet(FieldPos(aCABEC[nX]))) * QRY->Aliq)/100)
					_nTotal := _nTIVA+QRY->(FieldGet(FieldPos(aCABEC[nX])))
					_oSecCab:Cell("TIVA"+aCABEC[nX]):SetValue(_nTIVA)
				Next
				if _oSecCab:Cell("TIVA"+aCABEC[4]):GetValue() > 0
					nPer2 := (100-(_oSecCab:Cell("TIVA"+aCABEC[3]):GetValue()*100)/_oSecCab:Cell("TIVA"+aCABEC[4]):GetValue())
				else
					nPer2 := -100
				endif
				_oSecCab:Cell("PER2"):SetValue(nPer2)
				
				_oSecCab:PrintLine()

				QRY->(DbSkip())

			EndDo
			
		EndDo
		_oSecCab:Finish()

	EndIF


Return Nil



/* {Protheus.doc} Function ValidPerg
	Description
	Rotina para chamada do pergunte
	@author Valdemir Rabelo - valdemir.rabelo@sigamat.com.br
	@since 13/02/2020
*/
Static Function ValidPerg()

	Local _sAlias 	:= GetArea()
	Local _aRegs  	:= {}
	Local i 		:= 0
	Local j 		:= 0

	_cPerg         	:= PADR(_cPerg,10)

	aadd(_aRegs, {_cPerg, "01", "Año de referencia", "Año de referencia", "Año de referencia", "mv_ch1", "N", 04, 0, 0, "G", " ", "mv_par01", ""         , ""         , ""         , "", "", ""       , ""       , ""       , "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
	aadd(_aRegs, {_cPerg, "02", "Tipo ? "          , "Tipo ? "          , "Tipo ? "          , "mv_ch2", "N", 01, 0, 0, "C", " ", "MV_PAR02", "Facturado", "Facturado", "Facturado", "", "", "Captado", "Captado", "Captado", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})

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


/* {Protheus.doc} Function MntQry
	Description
	Rotina para Montar Querys
	@author Valdemir Rabelo - valdemir.rabelo@sigamat.com.br
	@since 13/02/2020
*/
Static Function MntQry()
	Local _cQuery	:= ""
	Local nAnos    	:= YEAR(dDatFim)-YEAR(dDatIni)
	Local cAnos    	:= ""
	Local cTMP     	:= cValToChar(YEAR(dDatIni))
	Local cNomTot   := ""
	Local nX		:= 0

	// Pego os anos envovlidos
	For nX := 1 to nAnos
	   if nX > 1
	      cAnos += ","
	   endif
	    cAnos += cTMP
		cTMP := soma1(cTMP)
	Next

	_cQuery     := "SELECT *  FROM ( " + CRLF

	if MV_PAR02 == 1
	    cNomTot    := "FATURAMENTO"

	    _cQuery     += "SELECT" + CRLF
	    _cQuery     += "    ANO," + CRLF
	    _cQuery     += "    MES," + CRLF
	    _cQuery     += "    SUM(faturado) FATURAMENTO" + CRLF
	    _cQuery     += " FROM   (" + CRLF
	    _cQuery     += "    SELECT" + CRLF
	    _cQuery     += "        Substr(d2_emissao, 1, 4)    ANO," + CRLF
	    _cQuery     += "        Substr(d2_emissao, 5, 2)    MES," + CRLF
	    _cQuery     += "        SD2.d2_total                FATURADO" + CRLF
	    _cQuery     += "    FROM " + RetSqlName("SD2") + " SD2" + CRLF
	    _cQuery     += "    INNER   JOIN " + RetSqlName("SA1") + " SA1 ON ( A1_COD = D2_CLIENTE    AND A1_LOJA = D2_LOJA   AND A1_GRPVEN <> 'ST'   AND SA1.D_E_L_E_T_ = ' ' )" + CRLF
	    _cQuery     += "    INNER   JOIN " + RetSqlName("SF4") + " SF4 ON ( F4_CODIGO = D2_TES     AND F4_TIPO = 'S'       AND F4_DUPLIC = 'S'     AND F4_ESTOQUE = 'S' AND SF4.D_E_L_E_T_ = ' ' )" + CRLF
	    _cQuery     += "	WHERE  SD2.d_e_l_e_t_ = ' '" + CRLF
	    _cQuery     += "    AND D2_SERIE <> 'R'" + CRLF
	    _cQuery     += "    AND D2_ESPECIE = 'NF'" + CRLF
	    _cQuery     += "    AND D2_EMISSAO BETWEEN '" + DTOS(dDatIni) + "' AND '" + DTOS(dDatFim) + "'" + CRLF
	    _cQuery     += " UNION ALL" + CRLF
	    _cQuery     += "    SELECT"   + CRLF
	    _cQuery     += "        Substr(d1_emissao, 1, 4)    ANO," + CRLF
	    _cQuery     += "        Substr(d1_dtdigit, 5, 2)    MES," + CRLF
	    _cQuery     += "        ( ( SD1.d1_total ) *- 1 )   FATURADO" + CRLF
	    _cQuery     += "    FROM " + RetSqlName("SD1") + " SD1" + CRLF
	    _cQuery     += "	INNER   JOIN " + RetSqlName("SF4") + " SF4 ON ( F4_CODIGO = D1_TES AND F4_DUPLIC = 'S' AND SF4.d_e_l_e_t_ = ' ' )" + CRLF
	    _cQuery     += "    WHERE SD1.d_e_l_e_t_ = ' '" + CRLF
	    _cQuery     += "    AND D1_DTDIGIT BETWEEN '" + DTOS(dDatIni) + "' AND '" + DTOS(dDatFim) + "'" + CRLF
	    _cQuery     += "	AND D1_CF       IN ( '112' )" + CRLF
	    _cQuery     += "    AND D1_TIPO     IN ( 'D' )" + CRLF
	    _cQuery     += "    AND D1_ESPECIE  IN ( 'NCC' )" + CRLF
	    _cQuery     += "    AND D1_TP       = 'PA' ) TMPFAT" + CRLF
	    _cQuery     += " GROUP BY MES,ANO" + CRLF
	    _cQuery     += " ORDER BY MES,ANO" + CRLF
	    _cQuery     += ")" + CRLF

/*
		_cQuery     += "				SELECT ANO, " + CRLF
		_cQuery     += "						MES, 				" + CRLF
		_cQuery     += "						SUM(faturado) FATURAMENTO 	" + CRLF
		_cQuery     += "						FROM   (SELECT  Substr(d2_emissao, 1, 4) ANO, 	" + CRLF
		_cQuery     += "										Substr(d2_emissao, 5, 2) MES, 	" + CRLF
		_cQuery     += "										SD2.d2_total   AS FATURADO 		" + CRLF
		_cQuery     += "								FROM   "+RETSQLNAME("SD2")+" SD2 				" + CRLF
		_cQuery     += "								INNER JOIN (SELECT * 							" + CRLF
		_cQuery     += "											FROM "+RETSQLNAME("SF4")+" ) SF4 	" + CRLF
		_cQuery     += "											ON F4_CODIGO = D2_TES AND SF4.d_e_l_e_t_ = ' '  " + CRLF
		_cQuery     += "											AND F4_TIPO = 'S' " + 				CRLF
		_cQuery     += "											AND F4_DUPLIC = 'S' " + 			CRLF
		_cQuery     += "											AND F4_ESTOQUE = 'S' "  + 			CRLF
		_cQuery     += "											WHERE  SD2.d_e_l_e_t_ = ' ' 	" + CRLF
		_cQuery     += "						 					AND d2_serie <> 'R' 			" + CRLF
		_cQuery     += "						 					AND d2_especie = 'NF' 			" + CRLF
		_cQuery     += "						 					AND d2_cliente NOT IN ( '001073', '001074', '001082', '001104' ) 			" + CRLF
		_cQuery     += "						 					AND d2_emissao >= '" +DTOS(dDatIni)+ "' AND d2_emissao <= '" +DTOS(dDatFim)+ "' 	" + CRLF
		_cQuery     += "				UNION ALL 		" + CRLF
		_cQuery     += "				SELECT  Substr(d1_emissao, 1, 4) ANO,		" + CRLF
		_cQuery     += "						Substr(d1_dtdigit, 5, 2)  MES, 		" + CRLF
		_cQuery     += "						( ( SD1.d1_total ) *- 1 ) FATURADO 	" + CRLF
		_cQuery     += "				FROM   " + RETSQLNAME("SD1")+" SD1 			" + CRLF
		_cQuery     += "				INNER JOIN(SELECT * 	" + CRLF
		_cQuery     += "						   FROM " + RETSQLNAME("SF4") + ") SF4 " + CRLF
		_cQuery     += "				ON SF4.d_e_l_e_t_ = ' ' AND f4_codigo = d1_tes AND f4_duplic = 'S' " + CRLF
		_cQuery     += "				WHERE  d1_dtdigit >='" +DTOS(dDatIni)+ "' AND d1_dtdigit <='" +DTOS(dDatFim)+ "' 	" + CRLF
		_cQuery     += "				 AND d1_cf IN( '112' )  	" + CRLF
		_cQuery     += "				 AND d1_tipo IN( 'D' )  	" + CRLF
		_cQuery     += "				 AND d1_especie IN( 'NCC' ) " + CRLF
		_cQuery     += "				 AND d1_tp = 'PA' 			" + CRLF
		_cQuery     += "				 AND SD1.d_e_l_e_t_ = ' ') TMPFAT " + CRLF
		_cQuery     += "GROUP BY MES,ANO  				  " + CRLF
		_cQuery     += "ORDER BY MES,ANO 				  " + CRLF
		_cQuery     += ")               				  " + CRLF
*/
	Else
	
	    cNomTot := "CAPTADO"

		_cQuery += "SELECT ANO, MES, ALIQ, SUM(TOTAL) CAPTADO" + CRLF
		_cQuery += " FROM (" + CRLF
		_cQuery += "    SELECT" + CRLF
		_cQuery += "        SUBSTR(SC5.c5_emissao,1,4)      ANO," + CRLF
		_cQuery += "        Substr(SC5.c5_emissao, 5, 2)    MES," + CRLF
		_cQuery += "        FB.FB_Aliq                      ALIQ," + CRLF
		_cQuery += "        C6_VALOR TOTAL" + CRLF
		_cQuery += "    FROM " + RetSqlName("SC5") + " SC5" + CRLF
		_cQuery += "	INNER   JOIN " + RetSqlName("SC6") + " SC6 ON ( C5_FILIAL = C6_FILIAL AND C5_NUM = C6_NUM AND SC6.D_E_L_E_T_ = ' ' )" + CRLF
		_cQuery += "    INNER   JOIN " + RetSqlName("SA1") + " SA1 ON ( A1_COD = C5_CLIENTE AND A1_LOJA = C5_LOJACLI AND A1_GRPVEN <> 'ST' AND SA1.D_E_L_E_T_ = ' ' )" + CRLF
		_cQuery += "	INNER   JOIN " + RetSqlName("SF4") + " SF4 ON ( F4_CODIGO = C6_TES AND F4_TIPO = 'S' AND F4_DUPLIC = 'S' AND F4_ESTOQUE = 'S' AND SF4.D_E_L_E_T_ = ' ' )" + CRLF
		_cQuery += "	LEFT    JOIN " + RetSqlName("SFB") + " FB  ON ( FB_FILIAL = ' ' AND FB_CODIGO = 'IVA' AND FB.D_E_L_E_T_ = ' ' )" + CRLF
		_cQuery += "    WHERE SC5.D_E_L_E_T_ = ' '" + CRLF
		_cQuery += "    AND C5_TIPO = 'N'" + CRLF
		_cQuery += "	AND C5_EMISSAO BETWEEN '" + dtos(dDatIni) + "' AND '" + dtos(dDatFim) + "' ) TMP" + CRLF         
        _cQuery += " GROUP BY ANO,MES,ALIQ"  + CRLF
		_cQuery += ") " + CRLF
	Endif
	
	_cQuery     += "PIVOT (SUM("+cNomTot+")			  " + 	CRLF
	_cQuery     += "		FOR ANO IN ("+cAnos+")  " +		CRLF
	_cQuery     += ")    							  " + 	CRLF
	_cQuery     += "ORDER  BY 1,2	 " + CRLF

Return _cQuery



/* {Protheus.doc} Function MesEspEx
	Description
	Rotina para apresentar os meses em espanhol
	@author Valdemir Rabelo - valdemir.rabelo@sigamat.com.br
	@since 13/02/2020
*/
Static Function MesEspEx(nMes)
	Local aRET := {;
					'Enero',;
					'Febrero',;
					'Marzo',;
					'Abril',;
					'Mayo',;
					'Junio',;
					'Julio',;
					'Agosto',;
					'Septiembre',;
					'Octubre',;
					'Noviembre',;
					'Diciembre'}
Return aRET[nMes]
