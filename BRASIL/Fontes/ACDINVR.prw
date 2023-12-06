#INCLUDE "Topconn.ch"
#INCLUDE "Protheus.ch"

/*/{Protheus.doc} u_ACDINVR()

Itens Inventariados na Expedição.

@type function
@author Everson Santana
@since 04/12/18
@version Protheus 12 - SigaAcd

@history ,Chamado 008247 ,

/*/

User Function ACDINVR()
	/*
	Declaracao de variaveis
	*/
	Private _oReport := Nil
	Private _oSecCab := Nil
	Private _oSecCab2 := Nil
	Private _cPerg 	 := PadR ("ACDINVR", Len (SX1->X1_GRUPO))
	Private _cTipo	 := ""
	Private _cTitulo := ""
	Private _oBreak

	ValidPerg()

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

	_cTitulo := "O.S INVENTARIO EXPED"

	_oReport := TReport():New("ACDINVR"+Alltrim(StrTran(time(),":","")),_cTitulo,_cPerg,{|_oReport| PrintReport(_oReport)},_cTitulo)

	Pergunte("ACDINVR",.F.)

	_oSecCab := TRSection():New( _oReport , _cTitulo, {"QRY"} )

	TRCell():New( _oSecCab, "CB7_PEDIDO"	,,"Pedido 		" 								,PesqPict('CB7',"CB7_PEDIDO")	,TamSX3("CB7_PEDIDO")[1]	,.F.,)//01
	TRCell():New( _oSecCab, "CB7_ORDSEP"	,,"Ordem Sep.	" 								,PesqPict('CB74',"CB7_ORDSEP")	,TamSX3("CB7_ORDSEP")[1]	,.F.,)//02
	TRCell():New( _oSecCab, "QTD_VOLUME"    ,,"Qtd Vol. Invent" 							,PesqPict('SB2',"B2_QATU")		,TamSX3("B2_QATU")[1]		,.F.,)//04
	TRCell():New( _oSecCab, "QTD_VOLEMB"    ,,"Qtd Vol. OS  " 								,PesqPict('SB2',"B2_QATU")		,TamSX3("B2_QATU")[1]		,.F.,)//03

	TRCell():New( _oSecCab, "Inv_x_OS"    	,,"Inv x OS" 									,'@!'							,20							,.F.,)//03
	TRCell():New( _oSecCab, "Resolvido"    	,,"Resolvido" 									,'@!'							,20							,.F.,)//03
	TRCell():New( _oSecCab, "Ocorrencia"   	,,"Ocorrência" 									,'@!'							,20							,.F.,)//03		

	TRCell():New( _oSecCab, "CB7_XDFEM"    	,,"Dt.Final.Embal " 							,PesqPict('CB7',"CB7_XDFEM")	,TamSX3("CB7_XDFEM")[1]		,.F.,)//09
	TRCell():New( _oSecCab, "CB7_XHFEM"    	,,"Hr.Final.Embal " 							,PesqPict('CB7',"CB7_XHFEM")	,TamSX3("CB7_XHFEM")[1]		,.F.,)//09
	TRCell():New( _oSecCab, "CB7_NOTA"   	,,"Nota 	    " 								,PesqPict('CB7',"CB7_NOTA")		,TamSX3("CB7_NOTA")[1]		,.F.,)//10
	TRCell():New( _oSecCab, "F2_EMISSAO"   	,,"Dt Emissão	" 								,PesqPict('SF2',"F2_EMISSAO")	,TamSX3("F2_EMISSAO")[1]	,.F.,)//11
	TRCell():New( _oSecCab, "F2_XCODROM"   	,,"Num. Romaneio" 								,PesqPict('SF2',"F2_XCODROM")	,TamSX3("F2_XCODROM")[1]	,.F.,)//12
	TRCell():New( _oSecCab, "F2_TRANSP"		,,"Transp.      " 								,PesqPict('SF2',"F2_TRANSP")	,TamSX3("F2_TRANSP")[1]		,.F.,)//13
	TRCell():New( _oSecCab, "A4_NOME"		,,"Nome Transp. " 								,PesqPict('SA4',"A4_NOME")		,TamSX3("A4_NOME")[1]		,.F.,)//14
	TRCell():New( _oSecCab, "C5_VEND1"    	,,"Vendedor     " 								,PesqPict('SC5',"C5_VEND1")		,TamSX3("C5_VEND1")[1]		,.F.,)//15
	TRCell():New( _oSecCab, "A3_NOME"    	,,"Nome Vend    " 								,PesqPict('SA3',"A3_NOME")		,TamSX3("A3_NOME")[1]		,.F.,)//16

	TRCell():New( _oSecCab, "Z14_DTINV"		,,"Dt Invet		" 								,PesqPict('Z14',"Z14_DTINV")	,TamSX3("Z14_DTINV")[1]		,.F.,)//05
	TRCell():New( _oSecCab, "Z14_USR"    	,,"Usuario Invet.	" 							,PesqPict('Z14',"Z14_USR")		,TamSX3("Z14_USR")[1]		,.F.,)//06
	TRCell():New( _oSecCab, "Z14_HRINV"    	,,"Hr Invet	    " 								,PesqPict('Z14',"Z14_HRINV")	,TamSX3("Z14_HRINV")[1]		,.F.,)//08
	TRCell():New( _oSecCab, "Z5_ENDEREC"  	,,"Localização Na Expedição 	"				,PesqPict('SZ5',"Z5_ENDEREC")	,TamSX3("Z5_ENDEREC")[1]	,.F.,)//07
	TRCell():New( _oSecCab, "C5_XALERTF"    ,,"Alerta Faturamento " 						,PesqPict('SC5',"C5_XALERTF")	,TamSX3("C5_XALERTF")[1]	,.F.,)//17
	TRCell():New( _oSecCab, "PD1_OBS"   	,,"Observação da tela de gerar romaneio 	" 	,PesqPict('PD1',"PD1_OBS")		,254						,.F.,)//18


	_oSecCab2 := TRSection():New( _oReport , "Itens Localizados na Expedição", {"QRY1"} )

	TRCell():New( _oSecCab2, "CB7_PEDIDO"	,,"Pedido 		" 								,PesqPict('CB7',"CB7_PEDIDO")	,TamSX3("CB7_PEDIDO")[1]	,.F.,)//01
	TRCell():New( _oSecCab2, "CB7_ORDSEP"	,,"Ordem Sep.	" 								,PesqPict('CB74',"CB7_ORDSEP")	,TamSX3("CB7_ORDSEP")[1]	,.F.,)//02
	TRCell():New( _oSecCab2, "QTD_VOLUME"   ,,"Qtd Vol. Invent" 							,PesqPict('SB2',"B2_QATU")		,TamSX3("B2_QATU")[1]		,.F.,)//04
	TRCell():New( _oSecCab2, "QTD_VOLEMB"   ,,"Qtd Vol. OS  " 								,PesqPict('SB2',"B2_QATU")		,TamSX3("B2_QATU")[1]		,.F.,)//03

	TRCell():New( _oSecCab2, "Inv_x_OS"    	,,"Inv x OS  " 									,'@!'							,20							,.F.,)//03	
	TRCell():New( _oSecCab2, "Resolvido"    	,,"Resolvido" 									,'@!'							,20							,.F.,)//03
	TRCell():New( _oSecCab2, "Ocorrencia"   	,,"Ocorrência" 									,'@!'							,20							,.F.,)//03		

	TRCell():New( _oSecCab2, "CB7_XDFEM"    ,,"Dt.Final.Embal " 							,PesqPict('CB7',"CB7_XDFEM")	,TamSX3("CB7_XDFEM")[1]		,.F.,)//09
	TRCell():New( _oSecCab2, "CB7_XHFEM"    	,,"Hr.Final.Embal " 						,PesqPict('CB7',"CB7_XHFEM")	,TamSX3("CB7_XHFEM")[1]		,.F.,)//09	
	TRCell():New( _oSecCab2, "CB7_NOTA"   	,,"Nota 	    " 								,PesqPict('CB7',"CB7_NOTA")		,TamSX3("CB7_NOTA")[1]		,.F.,)//10
	TRCell():New( _oSecCab2, "F2_EMISSAO"   ,,"Dt Emissão	" 								,PesqPict('SF2',"F2_EMISSAO")	,TamSX3("F2_EMISSAO")[1]	,.F.,)//11
	TRCell():New( _oSecCab2, "F2_XCODROM"   ,,"Num. Romaneio" 								,PesqPict('SF2',"F2_XCODROM")	,TamSX3("F2_XCODROM")[1]	,.F.,)//12
	TRCell():New( _oSecCab2, "F2_TRANSP"	,,"Transp.      " 								,PesqPict('SF2',"F2_TRANSP")	,TamSX3("F2_TRANSP")[1]		,.F.,)//13
	TRCell():New( _oSecCab2, "A4_NOME"		,,"Nome Transp. " 								,PesqPict('SA4',"A4_NOME")		,TamSX3("A4_NOME")[1]		,.F.,)//14
	TRCell():New( _oSecCab2, "C5_VEND1"    	,,"Vendedor     " 								,PesqPict('SC5',"C5_VEND1")		,TamSX3("C5_VEND1")[1]		,.F.,)//15
	TRCell():New( _oSecCab2, "A3_NOME"    	,,"Nome Vend    " 								,PesqPict('SA3',"A3_NOME")		,TamSX3("A3_NOME")[1]		,.F.,)//16

	TRCell():New( _oSecCab2, "Z14_DTINV"	,,"Dt Invet		" 								,PesqPict('Z14',"Z14_DTINV")	,TamSX3("Z14_DTINV")[1]		,.F.,)//05
	TRCell():New( _oSecCab2, "Z14_USR"    	,,"Usuario Invet.	" 							,PesqPict('Z14',"Z14_USR")		,TamSX3("Z14_USR")[1]		,.F.,)//06
	TRCell():New( _oSecCab2, "Z14_HRINV"    ,,"Hr Invet	    " 								,PesqPict('Z14',"Z14_HRINV")	,TamSX3("Z14_HRINV")[1]		,.F.,)//08
	TRCell():New( _oSecCab2, "Z5_ENDEREC"  	,,"Localização Na Expedição 	"				,PesqPict('SZ5',"Z5_ENDEREC")	,TamSX3("Z5_ENDEREC")[1]	,.F.,)//07
	TRCell():New( _oSecCab2, "C5_XALERTF"   ,,"Alerta Faturamento " 						,PesqPict('SC5',"C5_XALERTF")	,TamSX3("C5_XALERTF")[1]	,.F.,)//17
	TRCell():New( _oSecCab2, "PD1_OBS"   	,,"Observação da tela de gerar romaneio 	" 	,PesqPict('PD1',"PD1_OBS")		,254						,.F.,)//18

Return Nil

/*
Processamento da Query
*/
Static Function PrintReport(_oReport)

	Local _cQuery     := ""
	Local _cQuery1    := ""
	Local _cCliente	  := ""
	Local _nLin		  := 0
	Local _nTIVA	  := 0
	Local _nTotal	  := 0
	Local _cMoeda	  := ""
	Local aDados	  := {}
	Local aDados1	  := {}
	Local _Nx		  := 0
	Local _nOS		  := 0

	_cQuery += " SELECT CB7.CB7_FILIAL ,CB7.CB7_PEDIDO,CB7.CB7_ORDSEP, ' ' Z14_DTINV,CB7.CB7_STATUS,CB7.CB7_XDFEM,CB7.CB7_XHFEM,CB7.CB7_NOTA,CB7.CB7_SERIE,SF2.F2_EMISSAO,SF2.F2_XCODROM,SF2.F2_TRANSP,SA4.A4_NOME,SC5.C5_VEND1,SA3.A3_NOME, ' ' Z14_QTDVOL, ' ' Z14_USR, ' ' Z14_HRINV,SC5.C5_XALERTF,utl_raw.cast_to_varchar2(dbms_lob.substr(PD1.PD1_OBS)) PD1_OBS, "
	_cQuery += " (SELECT Count(*)  FROM "+RetSqlName("CB6")+" CB6 WHERE  CB6_FILIAL = '"+xFilial("CB6")+"' AND CB6_XORDSE = CB7.CB7_ORDSEP AND D_E_L_E_T_ = ' ') AS  CB6_QTEEMB "
	_cQuery += " FROM "+RetSqlName("CB7")+" CB7 "
	_cQuery += "  LEFT JOIN "+RetSqlName("SF2")+" SF2 "
	_cQuery += " 	ON SF2.F2_FILIAL = CB7.CB7_FILIAL "
	_cQuery += " 	AND SF2.F2_DOC = CB7.CB7_NOTA "
	_cQuery += "    AND SF2.D_E_L_E_T_ = ' ' "
	_cQuery += " LEFT JOIN "+RetSqlName("SC5")+" SC5 "
	_cQuery += " ON SC5.C5_FILIAL = '"+xFilial("SC5")+ "' "
	_cQuery += " AND SC5.C5_NUM = CB7.CB7_PEDIDO "
	_cQuery += " AND SC5.D_E_L_E_T_ = ' ' "	
	_cQuery += "  LEFT JOIN "+RetSqlName("SA3")+" SA3	"
	_cQuery += " 	ON SA3.A3_FILIAL = '"+xFilial("SA3")+ "' "
	_cQuery += "	AND SA3.A3_COD = SC5.C5_VEND1 "
	_cQuery += "	AND SA3.D_E_L_E_T_ = ' ' "
	_cQuery += "  LEFT JOIN "+RetSqlName("SA4")+" SA4 "
	_cQuery += "	ON SA4.A4_FILIAL = '"+xFilial("SA4")+ "' "
	_cQuery += " 	AND SA4.A4_COD = SF2.F2_TRANSP "
	_cQuery += " 	AND SA4.D_E_L_E_T_ = ' ' "
	_cQuery += " LEFT JOIN "+RetSqlName("PD1")+" PD1"
	_cQuery += " ON PD1.PD1_FILIAL = '"+xFilial("PD1")+ "' "
	_cQuery += " AND PD1.PD1_CODROM = SF2.F2_XCODROM "
	_cQuery += " AND PD1.D_E_L_E_T_ = ' ' "
	_cQuery += " WHERE CB7.CB7_DTEMIS BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"' "
	_cQuery += "	AND CB7.CB7_FILIAL = '"+xFilial("CB7")+"' "
	_cQuery += "    AND CB7.CB7_STATUS = '4' " //Embalagem Finalizada
	_cQuery += "	AND CB7.D_E_L_E_T_ = ' ' "
	_cQuery += " 	ORDER BY CB7.CB7_ORDSEP "

	If Select("QRY") > 0
		Dbselectarea("QRY")
		QRY->(DbClosearea())
	EndIf

	TcQuery _cQuery New Alias "QRY"

	dbSelectArea("QRY")
	QRY->(dbGoTop())

	_nLin := 70

	While !QRY->(Eof())


		Aadd(aDados,{ 	QRY->CB7_PEDIDO,; 		//01
						QRY->CB7_ORDSEP,;		//02
						QRY->CB6_QTEEMB,;		//03
						0				,;		//04
						Stod(QRY->Z14_DTINV),;	//05
						Stod(QRY->CB7_XDFEM),;	//06
						QRY->CB7_XHFEM,;		//07
						''					,;  //08
						QRY->CB7_NOTA,;			//09
						Stod(QRY->F2_EMISSAO),;	//10
						QRY->F2_XCODROM,;		//11
						QRY->F2_TRANSP,;		//12
						QRY->A4_NOME,;			//13
						QRY->C5_VEND1,;			//14
						QRY->A3_NOME,;			//15
						UsrRetName(QRY->Z14_USR),;//16
						QRY->Z14_HRINV,;		//17
						Alltrim(QRY->C5_XALERTF),;//18
						QRY->PD1_OBS			,; //19
		}	)

		dbSelectArea("SZ5")
		dbSetOrder(1)
		dbGotop()
		If(dbSeek(xFilial("SZ5")+QRY->CB7_ORDSEP))

			While !EOF() .AND. SZ5->Z5_FILIAL = xFilial("SZ5") .AND. SZ5->Z5_ORDSEP == QRY->CB7_ORDSEP

				_nOS := aScan(aDados,{|x| AllTrim(x[2]) == QRY->CB7_ORDSEP	} )

				If _nOS > 0

					If Empty(aDados[_nOS][08])

						aDados[_nOS][08] :=  Alltrim(SZ5->Z5_ENDEREC)

					Else

						aDados[_nOS][08] :=  aDados[_nOS][08]+"/"+Alltrim(SZ5->Z5_ENDEREC)

					EndIF

				EndIf
				_nOS := 0

				SZ5->(dbSkip())

			End

		EndIf

		QRY->(DbSkip())

	EndDo

	_nOS := 0

	_cQuery1 := " SELECT CB7.CB7_FILIAL ,CB7.CB7_PEDIDO,Z14.Z14_ORDSEP, Z14.Z14_DTINV,CB7.CB7_STATUS,CB7.CB7_XDFEM,CB7.CB7_XHFEM,CB7.CB7_NOTA,CB7.CB7_SERIE,SF2.F2_EMISSAO,SF2.F2_XCODROM,SF2.F2_TRANSP,SA4.A4_NOME,SC5.C5_VEND1,SA3.A3_NOME, Z14.Z14_QTDVOL, Z14.Z14_USR, Z14.Z14_HRINV,SC5.C5_XALERTF,utl_raw.cast_to_varchar2(dbms_lob.substr(PD1.PD1_OBS)) PD1_OBS, "
	_cQuery1 += " (SELECT Count(*)  FROM "+RetSqlName("CB6")+" CB6 WHERE  CB6_FILIAL = '"+xFilial("CB6")+"' AND CB6_XORDSE = Z14.Z14_ORDSEP AND D_E_L_E_T_ = ' ') AS  CB6_QTEEMB "
	_cQuery1 += " FROM "+RetSqlName("Z14")+" Z14 "
	_cQuery1 += " LEFT JOIN "+RetSqlName("CB7")+" CB7 "
	_cQuery1 += "         ON CB7.CB7_FILIAL = Z14.Z14_FILIAL "
	_cQuery1 += "             AND CB7.CB7_ORDSEP = Z14.Z14_ORDSEP "
	_cQuery1 += "             AND CB7.D_E_L_E_T_ = ' ' "
	_cQuery1 += "  LEFT JOIN "+RetSqlName("SC5")+" SC5 "
	_cQuery1 += " 		ON SC5.C5_FILIAL = '"+xFilial("SC5")+ "' "
	_cQuery1 += " 			AND SC5.C5_NUM = CB7.CB7_PEDIDO "
	_cQuery1 += " 			AND SC5.D_E_L_E_T_ = ' ' "	
	_cQuery1 += "  LEFT JOIN "+RetSqlName("SF2")+" SF2 "
	_cQuery1 += " 		ON SF2.F2_FILIAL = CB7.CB7_FILIAL "
	_cQuery1 += " 			AND SF2.F2_DOC = CB7.CB7_NOTA "
	_cQuery1 += "    		AND SF2.D_E_L_E_T_ = ' ' "
	_cQuery1 += "  LEFT JOIN "+RetSqlName("SA3")+" SA3	"
	_cQuery1 += " 		ON SA3.A3_FILIAL = '"+xFilial("SA3")+ "' "
	_cQuery1 += "			AND SA3.A3_COD = SC5.C5_VEND1 "
	_cQuery1 += "			AND SA3.D_E_L_E_T_ = ' ' "
	_cQuery1 += "  LEFT JOIN "+RetSqlName("SA4")+" SA4 "
	_cQuery1 += "		ON SA4.A4_FILIAL = '"+xFilial("SA4")+ "' "
	_cQuery1 += " 			AND SA4.A4_COD = SF2.F2_TRANSP "
	_cQuery1 += " 			AND SA4.D_E_L_E_T_ = ' ' "

	_cQuery1 += " LEFT JOIN "+RetSqlName("PD1")+" PD1"
	_cQuery1 += " 		ON PD1.PD1_FILIAL = '"+xFilial("PD1")+ "' "
	_cQuery1 += " 			AND PD1.PD1_CODROM = SF2.F2_XCODROM "
	_cQuery1 += " 			AND PD1.D_E_L_E_T_ = ' ' "
	_cQuery1 += " WHERE Z14.Z14_DTINV BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"' "
	_cQuery1 += "     AND Z14.D_E_L_E_T_ = ' ' "
	_cQuery1 += " ORDER BY Z14.Z14_ORDSEP "

	If Select("QRY1") > 0
		Dbselectarea("QRY1")
		QRY1->(DbClosearea())
	EndIf

	TcQuery _cQuery1 New Alias "QRY1"

	dbSelectArea("QRY1")
	QRY1->(dbGoTop())

	While !QRY1->(Eof())

		_nOS := aScan(aDados,{|x| AllTrim(x[2]) == QRY1->Z14_ORDSEP	} )

		If _nOS > 0

			aDados[_nOS][04] :=  QRY1->Z14_QTDVOL
			aDados[_nOS][05] :=  Stod(QRY1->Z14_DTINV)
			aDados[_nOS][16] :=  UsrRetName(QRY1->Z14_USR)
			aDados[_nOS][17] :=  QRY1->Z14_HRINV

		Else

			Aadd(aDados1,{ QRY1->CB7_PEDIDO,; 	//01
			QRY1->Z14_ORDSEP,;					//02
			QRY1->CB6_QTEEMB,;					//03
			QRY1->Z14_QTDVOL     ,;				//04
			Stod(QRY1->Z14_DTINV),;				//05
			Stod(QRY1->CB7_XDFEM),;				//06
			QRY1->CB7_XHFEM,;					//07
			''					,;  			//08
			QRY1->CB7_NOTA,;					//09
			Stod(QRY1->F2_EMISSAO),;			//10
			QRY1->F2_XCODROM,;					//11
			QRY1->F2_TRANSP,;					//12
			QRY1->A4_NOME,;						//13
			QRY1->C5_VEND1,;					//14
			QRY1->A3_NOME,;						//15
			UsrRetName(QRY1->Z14_USR),;			//16
			QRY1->Z14_HRINV,;					//17
			Alltrim(QRY1->C5_XALERTF),;			//18
			QRY1->PD1_OBS			,; 			//19
			}	)

			dbSelectArea("SZ5")
			dbSetOrder(1)
			dbGotop()
			If(dbSeek(xFilial("SZ5")+QRY1->Z14_ORDSEP))

				While !EOF() .AND. SZ5->Z5_FILIAL = xFilial("SZ5") .AND. SZ5->Z5_ORDSEP == QRY1->Z14_ORDSEP

					_nOS := aScan(aDados1,{|x| AllTrim(x[2]) == QRY1->Z14_ORDSEP	} )

					If _nOS > 0

						If Empty(aDados1[_nOS][08])

							aDados1[_nOS][08] :=  Alltrim(SZ5->Z5_ENDEREC)

						Else

							aDados1[_nOS][08] :=  aDados1[_nOS][08]+"/"+Alltrim(SZ5->Z5_ENDEREC)

						EndIF

					EndIf

					_nOS := 0

					SZ5->(dbSkip())

				End

			EndIf

		EndIf

		_nOS := 0


		QRY1->(DbSkip())

	EndDo


	For _Nx := 1 to Len(aDados)

		_oSecCab:Init()

		_oSecCab:Cell("CB7_PEDIDO"):SetValue(aDados[_Nx][01])
		_oSecCab:Cell("CB7_ORDSEP"):SetValue(aDados[_Nx][02])
		_oSecCab:Cell("QTD_VOLEMB"):SetValue(aDados[_Nx][03])
		_oSecCab:Cell("QTD_VOLUME"):SetValue(aDados[_Nx][04])
		_oSecCab:Cell("Z14_DTINV"):SetValue(aDados[_Nx][05])
		_oSecCab:Cell("CB7_XDFEM"):SetValue(aDados[_Nx][06])
		_oSecCab:Cell("CB7_XHFEM"):SetValue(aDados[_Nx][07])
		_oSecCab:Cell("Z5_ENDEREC"):SetValue(aDados[_Nx][08])
		_oSecCab:Cell("CB7_NOTA"):SetValue(aDados[_Nx][09])
		_oSecCab:Cell("F2_EMISSAO"):SetValue(aDados[_Nx][10])
		_oSecCab:Cell("F2_XCODROM"):SetValue(aDados[_Nx][11])
		_oSecCab:Cell("F2_TRANSP"):SetValue(aDados[_Nx][12])
		_oSecCab:Cell("A4_NOME"):SetValue(aDados[_Nx][13])
		_oSecCab:Cell("C5_VEND1"):SetValue(aDados[_Nx][14])
		_oSecCab:Cell("A3_NOME"):SetValue(aDados[_Nx][15])
		_oSecCab:Cell("Z14_USR"):SetValue(aDados[_Nx][16])
		_oSecCab:Cell("Z14_HRINV"):SetValue(aDados[_Nx][17])
		_oSecCab:Cell("C5_XALERTF"):SetValue(aDados[_Nx][18])
		_oSecCab:Cell("PD1_OBS"):SetValue(aDados[_Nx][19])

		_oSecCab:PrintLine()

	Next


	For _Nx := 1 to Len(aDados1)

		_oSecCab2:Init()

		_oSecCab2:Cell("CB7_PEDIDO"):SetValue(aDados1[_Nx][01])
		_oSecCab2:Cell("CB7_ORDSEP"):SetValue(aDados1[_Nx][02])
		_oSecCab2:Cell("QTD_VOLEMB"):SetValue(aDados1[_Nx][03])
		_oSecCab2:Cell("QTD_VOLUME"):SetValue(aDados1[_Nx][04])
		_oSecCab2:Cell("Z14_DTINV"):SetValue(aDados1[_Nx][05])
		_oSecCab2:Cell("CB7_XDFEM"):SetValue(aDados1[_Nx][06])
		_oSecCab2:Cell("CB7_XHFEM"):SetValue(aDados1[_Nx][07])
		_oSecCab2:Cell("Z5_ENDEREC"):SetValue(aDados1[_Nx][08])
		_oSecCab2:Cell("CB7_NOTA"):SetValue(aDados1[_Nx][09])
		_oSecCab2:Cell("F2_EMISSAO"):SetValue(aDados1[_Nx][10])
		_oSecCab2:Cell("F2_XCODROM"):SetValue(aDados1[_Nx][11])
		_oSecCab2:Cell("F2_TRANSP"):SetValue(aDados1[_Nx][12])
		_oSecCab2:Cell("A4_NOME"):SetValue(aDados1[_Nx][13])
		_oSecCab2:Cell("C5_VEND1"):SetValue(aDados1[_Nx][14])
		_oSecCab2:Cell("A3_NOME"):SetValue(aDados1[_Nx][15])
		_oSecCab2:Cell("Z14_USR"):SetValue(aDados1[_Nx][16])
		_oSecCab2:Cell("Z14_HRINV"):SetValue(aDados1[_Nx][17])
		_oSecCab2:Cell("C5_XALERTF"):SetValue(aDados1[_Nx][18])
		_oSecCab2:Cell("PD1_OBS"):SetValue(aDados1[_Nx][19])

		_oSecCab2:PrintLine()

	Next

	_oSecCab2:Finish()

	_oReport:ThinLine()

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
	AADD(_aRegs,{_cPerg,"01","De Dt Emissao? "	,"De Dt Emissao "	,"De Dt Emissao  "	,"mv_ch1","D",08,0,0,"G","          ","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(_aRegs,{_cPerg,"02","Ate Dt Emissao? "	,"Ate Dt Emissao "	,"De Dt Emissao  "	,"mv_ch2","D",08,0,0,"G","          ","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
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