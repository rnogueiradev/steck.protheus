#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STTMKR03	 ºAutor ³Everson Santana    º Data ³  08/03/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatorio De Campanha MKT										 º±±
±±º          ³		                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±± 
±±ºAlteração³ Giovani Zago 21/10/13 query bichada sem os xfilial  dei tapaº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STTMKR03()

	Local oReport
	Private _cPerg 	 := PadR ("STTMKR03", Len (SX1->X1_GRUPO))
	
	ValidPerg()

	oReport		:= ReportDef()
	oReport		:PrintDialog()

Return

Static Function ReportDef()

	Local oReport
	Local oSection

	oReport := TReport():New("STTMKR03","Relatorio De Campanha",_cPerg,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório De Campanha.")
 
	Pergunte(_cPerg,.F.)

	oSection := TRSection():New(oReport,"Relatorio De Campanha",{"PPE"})

	TRCell():New(oSection,"01",,"Numero      " ,PesqPict('PPE',"PPE_NUM")		,TamSX3("PPE_NUM")[1]	,.F.,)
	TRCell():New(oSection,"02",,"Cliente     " ,PesqPict('PPE',"PPE_CLIENT")	,TamSX3("PPE_CLIENT")[1]	,.F.,)
	TRCell():New(oSection,"03",,"Loja        " ,PesqPict('PPE',"PPE_LOJA")	,TamSX3("PPE_LOJA")[1]	,.F.,)
	TRCell():New(oSection,"04",,"Nome        " ,PesqPict('PPE',"PPE_NOME")	,TamSX3("PPE_NOME")[1]	,.F.,)
	TRCell():New(oSection,"05",,"Produto     " ,PesqPict('PPG',"PPG_PROD")	,TamSX3("PPG_PROD")[1]	,.F.,)
	TRCell():New(oSection,"06",,"Desc.Produto" ,PesqPict('PPG',"PPG_NPROD")	,TamSX3("PPG_NPROD")[1]	,.F.,)
	TRCell():New(oSection,"07",,"Grupo       " ,PesqPict('PPG',"PPG_GRUPO")	,TamSX3("PPG_GRUPO")[1]	,.F.,)
	TRCell():New(oSection,"08",,"Desc.Grupo  " ,PesqPict('PPG',"PPG_NGRUPO")	,TamSX3("PPG_NGRUPO")[1]	,.F.,)
	TRCell():New(oSection,"09",,"Percentual  " ,PesqPict('PPG',"PPG_VALOR")	,TamSX3("PPG_VALOR")[1]	,.F.,)

	oSection:SetHeaderSection(.T.)

//oSection:Setnofilter("SC5")

Return oReport

Static Function ReportPrint(oReport)

	Local oSection	:= oReport:Section(1)
	Local _cQuery 	:= ""
	Local _cAlias		:= ""
//Local cAlias 	:= "QRYTEMP"
//Local cQuery1 	:= ""
//Local cAlias1 	:= "QRYTEMP1"
	Local aDados[99]

	oSection:Cell("01"):SetBlock( { || aDados[1] } )
	oSection:Cell("02"):SetBlock( { || aDados[2] } )
	oSection:Cell("03"):SetBlock( { || aDados[3] } )
	oSection:Cell("04"):SetBlock( { || aDados[4] } )
	oSection:Cell("05"):SetBlock( { || aDados[5] } )
	oSection:Cell("06"):SetBlock( { || aDados[6] } )
	oSection:Cell("07"):SetBlock( { || aDados[7] } )
	oSection:Cell("08"):SetBlock( { || aDados[8] } )
	oSection:Cell("09"):SetBlock( { || aDados[9] } )

	oReport:SetTitle("Relatorio De Campanha")// Titulo do relatório

	_cAlias := GetNextAlias()
	_cQuery := " SELECT  PPE_NUM,PPE_CLIENT,PPE_LOJA,PPE_NOME,PPG_PROD,PPG_NPROD,PPG_GRUPO,PPG_NGRUPO,PPG_VALOR  "
	_cQuery += "	FROM "+RetSqlName("PPD")+" PPD "
	_cQuery += "	    INNER JOIN(SELECT * FROM "+RetSqlName("PPE")+") PPE  "
	_cQuery += "	        ON PPE_NUM = PPD_NUM "
	_cQuery += "         AND PPE.PPE_CLIENT BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR05+"' "
	_cQuery += "         AND PPE.PPE_LOJA BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR06+"' "
	_cQuery += "         AND PPE.D_E_L_E_T_ = ' ' "
	_cQuery += "     INNER JOIN(SELECT * FROM "+RetSqlName("PPG")+") PPG "
	_cQuery += "         ON PPE_NUM = PPG_NUM "
	_cQuery += "         AND PPG.PPG_PROD BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' "
	_cQuery += "         AND PPG.PPG_GRUPO BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"' "
	_cQuery += "         AND PPG.D_E_L_E_T_ = ' ' "
	_cQuery += " WHERE PPD.PPD_NUM BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
	_cQuery += "     AND PPD.D_E_L_E_T_ = ' ' "

	If Select(_cAlias) > 0
		(_cAlias)->(dbCloseArea())
	EndIf

	_cQuery := ChangeQuery(_cQuery)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.T.,.T.)

	oReport:SetMeter(0)
	aFill(aDados,nil)
	oSection:Init()

	dbSelectArea(_cAlias)
	(_cAlias)->(dbGoTop())

	While !(_cAlias)->(Eof())
	
		aDados[1]	:=	(_cAlias)->PPE_NUM
		aDados[2]	:=	(_cAlias)->PPE_CLIENT
		aDados[3]	:=	(_cAlias)->PPE_LOJA
		aDados[4]	:=	(_cAlias)->PPE_NOME
		aDados[5]	:=	(_cAlias)->PPG_PROD
		aDados[6]	:=	(_cAlias)->PPG_NPROD
		aDados[7]	:=	(_cAlias)->PPG_GRUPO
		aDados[8]	:=	(_cAlias)->PPG_NGRUPO
		aDados[9]	:=	(_cAlias)->PPG_VALOR
	
		oSection:PrintLine()
		aFill(aDados,nil)
	
		(_cAlias)->(DbSkip())
	
	EndDo

//oReport:SkipLine()
	*/
//	If Select(_cAlias) > 0
//		(_cAlias)->(dbCloseArea())
//	EndIf


/*
DbSelectArea(cAlias1)
(cAlias1)->(dbCloseArea())
*/
Return oReport
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ValidPerg  ºAutor  ³Everson Santana   º Data ³  22/01/18     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Criacao e apresentacao das perguntas						    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ STECK                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ValidPerg()

	Local _sAlias := GetArea()
	Local _aRegs  := {}
	Local i := 0
	Local j := 0

	_cPerg         := PADR(_cPerg,10)
//               01    02    03                   04                05                  06       07  08 09 10 11  12 13          14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38
	AADD(_aRegs,{_cPerg, "01", "Da Campanha ?" 	,"Da Campanha ?" 	 ,"Da Campanha ?" 	,"MV_CH1","C",06, 0, 0,"G","","mv_par01" ,"","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(_aRegs,{_cPerg, "02", "Ate Campanha ?" 	,"Ate Campanha ?"	 ,"Ate Campanha ?"	,"MV_CH2","C",06, 0, 0,"G","","mv_par02" ,"","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(_aRegs,{_cPerg, "03", "Do Cliente ?"		,"Do Cliente ?"	 ,"Do Cliente ?"		,"MV_CH3","C",06, 0, 0,"G","","mv_par03" ,"","","","","","","","","","","","","","","","","","","","","","","","","SA1"})
	AADD(_aRegs,{_cPerg, "04", "Da Loja ?"			,"Da Loja ?"	 	 ,"Da Loja ?"			,"MV_CH4","C",02, 0, 0,"G","","mv_par04" ,"","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(_aRegs,{_cPerg, "05", "Ate Cliente ?"	,"Ate Cliente ?"	 ,"Ate Cliente ?"		,"MV_CH5","C",06, 0, 0,"G","","mv_par05" ,"","","","","","","","","","","","","","","","","","","","","","","","","SA1"})
	AADD(_aRegs,{_cPerg, "06", "Ate Loja ?"		,"Ate Loja ?"	 	 ,"Ate Loja ?"		,"MV_CH6","C",02, 0, 0,"G","","mv_par06" ,"","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(_aRegs,{_cPerg, "07", "Do Produto ?"		,"Do Produto ?" 	 ,"Do Produto ?"		,"MV_CH7","C",15, 0, 0,"G","","mv_par07" ,"","","","","","","","","","","","","","","","","","","","","","","","","SB1"})
	AADD(_aRegs,{_cPerg, "08", "Ate Produto ?"	,"Ate Produto ?" 	 ,"Ate Produto ?"		,"MV_CH8","C",15, 0, 0,"G","","mv_par08" ,"","","","","","","","","","","","","","","","","","","","","","","","","SB1"})
	AADD(_aRegs,{_cPerg, "09", "Do Grupo ?"		,"Do Grupo ?" 	 ,"Do Grupo ?"		,"MV_CH9","C",03, 0, 0,"G","","mv_par09" ,"","","","","","","","","","","","","","","","","","","","","","","","","SBM"})
	AADD(_aRegs,{_cPerg, "10", "Ate Grupo ?"		,"Ate Grupo ?" 	 ,"Ate Grupo ?"		,"MV_CHA","C",03, 0, 0,"G","","mv_par10" ,"","","","","","","","","","","","","","","","","","","","","","","","","SBM"})
	
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

return
