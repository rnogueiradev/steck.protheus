#INCLUDE "Topconn.ch"
#INCLUDE "Protheus.ch"

/*/{Protheus.doc} STGPE008

Turnos de Trabalho

@type function
@author Everson Santana
@since 01/02/19
@version Protheus 12 - Faturamento

@history , ,

/*/

User Function STGPE008()

	/*
	Declaracao de variaveis
	*/
	Private _oReport := Nil
	Private _oSecCab := Nil
	Private _cPerg 	 := PadR ("STGPE008", Len (SX1->X1_GRUPO))
	Private _cTipo	 := ""
	Private _cTitulo := ""

	ValidPerg()

	//Pergunte(_cPerg,.T.)

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

	_cTitulo := "Turnos de Trabalho"

	_oReport := TReport():New("STGPE008",_cTitulo,_cPerg,{|_oReport| PrintReport(_oReport)},_cTitulo)

	_oSecCab := TRSection():New( _oReport , "_cTitulo", {"QRY"} )

	TRCell():New( _oSecCab, "RA_FILIAL"		,,"Filial 		" ,PesqPict('SRA',"RA_FILIAL")	,TamSX3("RA_FILIAL")[1],.F.,)
	TRCell():New( _oSecCab, "RA_MAT"		,,"Matricula	" ,PesqPict('SRA',"RA_MAT")		,TamSX3("RA_MAT")[1],.F.,)
	TRCell():New( _oSecCab, "RA_NOME"		,,"Nome			" ,PesqPict('SRA',"RA_NOME")	,TamSX3("RA_NOME")[1],.F.,)
	TRCell():New( _oSecCab, "RA_CC"  		,,"C Custo      " ,PesqPict('SRA',"RA_CC")		,TamSX3("RA_CC")[1]	,.F.,)
	TRCell():New( _oSecCab, "RA_TNOTRAB"   	,,"Turno        " ,PesqPict('SRA',"RA_TNOTRAB")	,TamSX3("RA_TNOTRAB")[1],.F.,)
	TRCell():New( _oSecCab, "R6_DESC"   	,,"Desc Turno   " ,PesqPict('SR6',"R6_DESC")	,TamSX3("R6_DESC")[1]	,.F.,)

Return Nil
/*
Processamento da Query
*/
Static Function PrintReport(_oReport)

	Local _cQuery     := ""
	Local _cCliente	  := ""
	Local _nLin		  := 0
	Local _nTIVA	  := 0
	Local _nTotal	  := 0
	Local _cMoeda	  := ""

	_cQuery += " SELECT RA_FILIAL ,RA_MAT,RA_NOME,RA_CC ,RA_TNOTRAB , R6.R6_DESC 
	_cQuery += " FROM "+RetSqlName("SRA")+" RA 
	_cQuery += " LEFT JOIN "+RetSqlName("SR6")+ " R6
	_cQuery += " ON R6.R6_TURNO = RA.RA_TNOTRAB
	_cQuery += " AND R6.D_E_L_E_T_ = ' '
	_cQuery += " WHERE 
	_cQuery += " RA_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'
	_cQuery += " AND RA_MAT BETWEEN '"+MV_PAR03+ "' AND '"+MV_PAR04+"'
	_cQuery += " AND RA_CC BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'"
	_cQuery += " AND RA_DEMISSA = ' '"
	_cQuery += " AND RA.D_E_L_E_T_ = ' ' "

	//_cQuery := ChangeQuery(_cQuery)

	If Select("QRY") > 0
		Dbselectarea("QRY")
		QRY->(DbClosearea())
	EndIf

	TcQuery _cQuery New Alias "QRY"

	dbSelectArea("QRY")
	QRY->(dbGoTop())

	_nLin := 70
	While !QRY->(Eof())

		_oSecCab:Init()

		_oSecCab:Cell("RA_FILIAL"):SetValue(QRY->RA_FILIAL)
		_oSecCab:Cell("RA_MAT"):SetValue(QRY->RA_MAT)
		_oSecCab:Cell("RA_NOME"):SetValue(QRY->RA_NOME)
		_oSecCab:Cell("RA_CC"):SetValue(QRY->RA_CC)
		_oSecCab:Cell("RA_TNOTRAB"):SetValue(QRY->RA_TNOTRAB)
		_oSecCab:Cell("R6_DESC"):SetValue(QRY->R6_DESC)

		_oSecCab:PrintLine()

		_nLin += 15

		QRY->(DbSkip())

	EndDo
	
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

	AADD(_aRegs,{_cPerg,"01","Da Filial?  	 "	,"Da Filial? "		,"Da Filial?  "	,"mv_ch1","C",02,0,0,"G","          ","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(_aRegs,{_cPerg,"02","Ate Filial?   "	,"Ate Filial? "		,"Ate Filial? " ,"mv_ch2","C",02,0,0,"G","          ","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(_aRegs,{_cPerg,"03","Da Matricula?	 "	,"Da Matricula? "	,"Da Matricula?","mv_ch3","C",06,0,0,"G","          ","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(_aRegs,{_cPerg,"04","Ate Matricula? "	,"Ate Matricula? "	,"Ate Matricula?","mv_ch4","C",06,0,0,"G","         ","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(_aRegs,{_cPerg,"05","Do CCusto?	 "	,"Do CCusto? "		,"Do CCusto?"	,"mv_ch5","C",09,0,0,"G","          ","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(_aRegs,{_cPerg,"06","Ate CCusto? "		,"Ate CCusto? "		,"Ate CCusto?"	,"mv_ch6","C",09,0,0,"G","          ","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","",""})


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