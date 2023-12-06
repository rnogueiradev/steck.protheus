#INCLUDE "Topconn.ch"
#INCLUDE "Protheus.ch"

#DEFINE CR    chr(13)+chr(10)

/*/{Protheus.doc} u_STFATR15()

Relatorio de Embarques AM

@type function
@author Everson Santana
@since 18/11/19
@version Protheus 12 - SIGAFAT

@history ,Ticket 20191114000016 ,

/*/

User Function STFATR15()
	/*
	Declaracao de variaveis
	*/
	Private _oReport := Nil
	Private _oSecCab := Nil
	Private _oSecCab2 := Nil
	Private _cPerg 	 := PadR ("STFATR15", Len (SX1->X1_GRUPO))
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

	_cTitulo := "Relatorio de Embarque AM"

	_oReport := TReport():New("STFATR15"+Alltrim(StrTran(time(),":","")),_cTitulo,_cPerg,{|_oReport| PrintReport(_oReport)},_cTitulo)

	Pergunte("STFATR15",.F.)

	_oSecCab := TRSection():New( _oReport , _cTitulo, {"QRY"} )

Return Nil

/*
Processamento da Query
*/
Static Function PrintReport(_oReport)

	Local _cQuery     := ""
	
	TRCell():New( _oSecCab, "ZZT_NUMEMB"	,,"Num. Embarque" 								,PesqPict('ZZ7',"ZZT_NUMEMB")	,TamSX3("ZZT_NUMEMB")[1]	,.F.,)//01
	TRCell():New( _oSecCab, "ZZT_DTEMIS"	,,"Dt. Emissão	" 								,PesqPict('ZZ7',"ZZT_DTEMIS")	,TamSX3("ZZT_DTEMIS")[1]	,.F.,)//02
	TRCell():New( _oSecCab, "ZZT_HRINI"    	,,"Hr. Inicio  " 								,PesqPict('ZZ7',"ZZT_HRINI")	,TamSX3("ZZT_HRINI")[1]		,.F.,)//03
	TRCell():New( _oSecCab, "ZZT_HRFIM"    	,,"Hr. Final" 									,PesqPict('ZZ7',"ZZT_HRFIM")	,TamSX3("ZZT_HRFIM")[1]		,.F.,)//04
	TRCell():New( _oSecCab, "ZZT_RHTOT"    	,,"Hr. Total" 									,PesqPict('ZZ7',"ZZT_HRFIM")	,TamSX3("ZZT_HRFIM")[1]		,.F.,)//04
	TRCell():New( _oSecCab, "ZZT_SERIEN"	,,"Serie Nota Fiscal	" 						,PesqPict('ZZ7',"ZZT_SERIEN")	,TamSX3("ZZT_SERIEN")[1]	,.F.,)//05
	TRCell():New( _oSecCab, "ZZT_NF"		,,"Num. Nota Fiscal	" 							,PesqPict('ZZ7',"ZZT_NF")		,TamSX3("ZZT_NF")[1]		,.F.,)//06
	If MV_PAR03 = 1
		TRCell():New( _oSecCab, "ZZU_PRODUT"	,,"Codigo	"		 							,PesqPict('ZZU',"ZZU_PRODUT")	,TamSX3("ZZU_PRODUT")[1]		,.F.,)//06	
		TRCell():New( _oSecCab, "B1_DESC"		,,"Descrição	" 								,PesqPict('SB1',"B1_DESC")		,TamSX3("B1_DESC")[1]		,.F.,)//06
	EndIf	
	TRCell():New( _oSecCab, "ZZT_MODAL"    	,,"Modal	" 									,PesqPict('ZZ7',"ZZT_MODAL")	,TamSX3("ZZT_MODAL")[1]		,.F.,)//07
	TRCell():New( _oSecCab, "ZZT_FILDES"    ,,"Filial Destino	    "						,PesqPict('ZZ7',"ZZT_FILDES")	,TamSX3("ZZT_FILDES")[1]	,.F.,)//08
	TRCell():New( _oSecCab, "ZZT_TRANSP"  	,,"Cod. Transp.	"								,PesqPict('ZZ7',"ZZT_TRANSP")	,TamSX3("ZZT_TRANSP")[1]	,.F.,)//09
	TRCell():New( _oSecCab, "ZZT_NTRANS"  	,,"Nome Transp." 								,PesqPict('ZZ7',"ZZT_NTRANS")	,TamSX3("ZZT_NTRANS")[1]	,.F.,)//10
	TRCell():New( _oSecCab, "ZZU_VOLUME"  	,,"Qtd. Volume" 								,PesqPict('ZZU',"ZZU_VOLUME")	,TamSX3("ZZU_VOLUME")[1]	,.F.,)//11
	TRCell():New( _oSecCab, "F2_VALBRUT"  	,,"Vlr. Nota Fiscal"							,PesqPict('SF2',"F2_VALBRUT")	,TamSX3("F2_VALBRUT")[1]	,.F.,)//12

	

	_cQuery += " SELECT ZZT_NUMEMB,ZZT_DTEMIS,ZZT_HRINI,ZZT_HRFIM,ZZT_SERIEN,ZZT_NF,ZZT_MODAL,ZZT_FILDES,ZZT_TRANSP,ZZT_NTRANS,ZZT_CLIENT, " + CR
	_cQuery += " (SELECT COUNT(*) FROM "+RetSqlName("ZZU")+ " ZZU WHERE ZZU_NUMEMB = ZZT.ZZT_NUMEMB AND ZZU_VIRTUA <> 'S' AND ZZU.D_E_L_E_T_ = ' ') ZZU_VOLUME, " + CR
	_cQuery += " NVL((SELECT F2_VALBRUT FROM "+RetSqlName("SF2")+" SF2 WHERE F2_DOC = ZZT.ZZT_NF AND F2_SERIE = ZZT.ZZT_SERIEN AND F2_CLIENT = ZZT.ZZT_CLIENT AND SF2.D_E_L_E_T_ = ' ' ),0) F2_VALBRUT " + CR

	If MV_PAR03 = 1	
		_cQuery += ", ZZU.ZZU_PRODUT,SB1.B1_DESC" + CR
	EndIf

	_cQuery += " FROM "+RetSqlName("ZZT")+" ZZT " + CR

	If MV_PAR03 = 1

		_cQuery += " LEFT JOIN "+RetSqlName("ZZU")+" ZZU "+ CR
		_cQuery += " ON ZZU.ZZU_FILIAL = ZZT.ZZT_FILIAL "+ CR
		_cQuery += " AND ZZU.ZZU_NUMEMB = ZZT.ZZT_NUMEMB "+ CR
		_cQuery += "	AND ZZU.D_E_L_E_T_ = ' ' "+ CR
		_cQuery += " LEFT JOIN "+RetSqlName("SB1")+" SB1 "+ CR
		_cQuery += " ON SB1.B1_COD = ZZU.ZZU_PRODUT "+ CR
		_cQuery += " AND SB1.D_E_L_E_T_ = ' ' "+ CR

	EndIf

	_cQuery += " WHERE ZZT_DTEMIS BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"' " + CR
	_cQuery += "	AND ZZT.D_E_L_E_T_ = ' ' " + CR

	If Select("QRY") > 0
		Dbselectarea("QRY")
		QRY->(DbClosearea())
	EndIf

	TcQuery _cQuery New Alias "QRY"

	dbSelectArea("QRY")
	QRY->(dbGoTop())

	_oSecCab:Init()

	While !QRY->(Eof())

		_oSecCab:Cell("ZZT_NUMEMB"):SetValue(QRY->ZZT_NUMEMB)
		_oSecCab:Cell("ZZT_DTEMIS"):SetValue(Stod(QRY->ZZT_DTEMIS))
		_oSecCab:Cell("ZZT_HRINI"):SetValue(SubStr(QRY->ZZT_HRINI,1,5))
		_oSecCab:Cell("ZZT_HRFIM"):SetValue(SubStr(QRY->ZZT_HRFIM,1,5))
		_oSecCab:Cell("ZZT_RHTOT"):SetValue(SubStr(ELAPTIME( SubStr(QRY->ZZT_HRINI,1,5)+":00", SubStr(QRY->ZZT_HRFIM,1,5)+":00" ),1,5))
		_oSecCab:Cell("ZZT_SERIEN"):SetValue(QRY->ZZT_SERIEN)
		_oSecCab:Cell("ZZT_NF"):SetValue(QRY->ZZT_NF)
		
		If MV_PAR03 = 1
			_oSecCab:Cell("ZZU_PRODUT"):SetValue(QRY->ZZU_PRODUT)
			_oSecCab:Cell("B1_DESC"):SetValue(QRY->B1_DESC)
		EndIf
		
		_oSecCab:Cell("ZZT_MODAL"):SetValue(QRY->ZZT_MODAL)
		_oSecCab:Cell("ZZT_FILDES"):SetValue(QRY->ZZT_FILDES)
		_oSecCab:Cell("ZZT_TRANSP"):SetValue(QRY->ZZT_TRANSP)
		_oSecCab:Cell("ZZT_NTRANS"):SetValue(QRY->ZZT_NTRANS)
		_oSecCab:Cell("ZZU_VOLUME"):SetValue(QRY->ZZU_VOLUME)
		_oSecCab:Cell("F2_VALBRUT"):SetValue(QRY->F2_VALBRUT)

		_oSecCab:PrintLine()

		QRY->(DbSkip())

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
	AADD(_aRegs,{_cPerg,"01","De Dt Emissao? "	,"De Dt Emissao "	,"De Dt Emissao  "	,"mv_ch1","D",08,0,0,"G","          ","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(_aRegs,{_cPerg,"02","Ate Dt Emissao? "	,"Ate Dt Emissao "	,"De Dt Emissao  "	,"mv_ch2","D",08,0,0,"G","          ","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(_aRegs,{_cPerg,"03","Imprimi Detalhes? "	,"Imprimi Detalhes? "	,"Imprimi Detalhes? "	,"mv_ch3","C",01,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
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