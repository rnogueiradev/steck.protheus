#INCLUDE "Topconn.ch"
#INCLUDE "Protheus.ch"

/*/{Protheus.doc} u_STAV3607()

Posição Hierárquica Por Gestor

@type function
@author Everson Santana
@since 21/09/2020
@version Protheus 12 - SigaGpe

@history , ,

/*/

User Function STAV3607()
	/*
	Declaracao de variaveis
	*/
	Private _oReport := Nil
	Private _oSecCab := Nil
	Private _cPerg 	 := " " //PadR ("STESTR06", Len (SX1->X1_GRUPO))
	Private _cTipo	 := ""
	Private _cTitulo := ""
	Private _oBreak

	//ValidPerg()

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

	_cTitulo := "Posição Hierárquica Por Gestor"

	_oReport := TReport():New("STAV3607"+Alltrim(StrTran(time(),":","")),_cTitulo,_cPerg,{|_oReport| PrintReport(_oReport)},_cTitulo)

	//Pergunte("STESTR06",.F.)

	_oSecCab := TRSection():New( _oReport , _cTitulo, {"QRY"} )

	TRCell():New( _oSecCab, "RA_XFILSUP"    ,,RetTitle("RA_XFILSUP")	,PesqPict('SRA',"RA_XFILSUP")	,TamSX3("RA_XFILSUP")[1]	,.F.,)//01
	TRCell():New( _oSecCab, "RA_XEMPSUP"	,,RetTitle("RA_XEMPSUP")	,PesqPict('SRA',"RA_XEMPSUP")	,TamSX3("RA_XEMPSUP")[1]	,.F.,)//02
	TRCell():New( _oSecCab, "RA_XMATSUP"    ,,RetTitle("RA_XMATSUP")	,PesqPict('SRA',"RA_XMATSUP")	,TamSX3("RA_XMATSUP")[1]	,.F.,)//03
	TRCell():New( _oSecCab, "RA_XUSRSUP"    ,,RetTitle("RA_XUSRSUP")	,PesqPict('SRA',"RA_XUSRSUP")	,TamSX3("RA_XUSRSUP")[1]	,.F.,)//03
	TRCell():New( _oSecCab, "RA_NOMESUP"    ,,RetTitle("RA_NOME")	    ,PesqPict('SRA',"RA_NOME")	    ,TamSX3("RA_NOME")[1]	    ,.F.,)//03
	TRCell():New( _oSecCab, "RA_FILIAL"		,,RetTitle("RA_FILIAL")		,PesqPict('SRA',"RA_FILIAL")	,TamSX3("RA_FILIAL")[1]		,.F.,)//03
	TRCell():New( _oSecCab, "RA_XEMP"    	,,RetTitle("RA_XEMP")	    ,PesqPict('SRA',"RA_XEMP")		,TamSX3("RA_XEMP")[1]		,.F.,)//03
	TRCell():New( _oSecCab, "RA_MAT"    	,,RetTitle("RA_MAT")    	,PesqPict('SRA',"RA_MAT")		,TamSX3("RA_MAT")[1]		,.F.,)//03
	TRCell():New( _oSecCab, "RA_XUSRCFG"    ,,RetTitle("RA_XUSRCFG")	,PesqPict('SRA',"RA_XUSRCFG")	,TamSX3("RA_XUSRCFG")[1]	,.F.,)//03
	TRCell():New( _oSecCab, "RA_NOME"    	,,RetTitle("RA_NOME")		,PesqPict('SRA',"RA_NOME")		,TamSX3("RA_NOME")[1]		,.F.,)//03
	TRCell():New( _oSecCab, "RA_CODFUNC"    ,,RetTitle("RA_CODFUNC")	,PesqPict('SRA',"RA_CODFUNC")	,TamSX3("RA_CODFUNC")[1]	,.F.,)//03
	TRCell():New( _oSecCab, "RJ_DESC"    	,,RetTitle("RJ_DESC")		,PesqPict('SRJ',"RJ_DESC")		,TamSX3("RJ_DESC")[1]		,.F.,)//03
	TRCell():New( _oSecCab, "RA_DEPTO"    	,,RetTitle("RA_DEPTO")		,PesqPict('SRA',"RA_DEPTO")		,TamSX3("RA_DEPTO")[1]		,.F.,)//03
	TRCell():New( _oSecCab, "QB_DESCRIC"    ,,RetTitle("QB_DESCRIC")	,PesqPict('SQB',"QB_DESCRIC")	,TamSX3("QB_DESCRIC")[1]	,.F.,)//03
	TRCell():New( _oSecCab, "RA_ADMISSA"    ,,RetTitle("RA_ADMISSA")	,PesqPict('SRA',"RA_ADMISSA")	,TamSX3("RA_ADMISSA")[1]	,.F.,)//03

Return Nil

/*
Processamento da Query
*/
Static Function PrintReport(_oReport)

	Local _cQuery     := ""
	Local _nLin		  := 0

	_cQuery := " SELECT "
	_cQuery += "  SQB.QB_FILRESP RA_XFILSUP, "
	_cQuery += "  SRASUP.RA_XEMPSUP RA_XEMPSUP, "
	_cQuery += "  SQB.QB_MATRESP RA_XMATSUP, "
	_cQuery += "  SRASUP.RA_XUSRCFG RA_XUSRSUP, "
	_cQuery += "  SRASUP.RA_NOME RA_NOMESUP, "
	_cQuery += "  SRA.RA_FILIAL, "
	_cQuery += "  SRA.RA_XEMP,  "
	_cQuery += "  SRA.RA_MAT, "
	_cQuery += "  SRA.RA_XUSRCFG, "
	_cQuery += "  SRA.RA_NOME, "
	_cQuery += "  SRA.RA_CODFUNC,  "
	_cQuery += "  SRJ.RJ_DESC, "
	_cQuery += "  SRA.RA_DEPTO,  "
	_cQuery += "  SQB.QB_DESCRIC, "
	_cQuery += "  SRA.RA_ADMISSA "
	_cQuery += " FROM   "+RetSqlName("SRA")+" SRA "
	_cQuery += " LEFT JOIN "+RetSqlName("SRJ")+" SRJ "
	_cQuery += "    ON SRJ.RJ_FILIAL = ' ' "
	_cQuery += "        AND SRJ.RJ_FUNCAO = SRA.RA_CODFUNC "
	_cQuery += "        AND SRJ.D_E_L_E_T_ = ' ' "
	_cQuery += " LEFT JOIN "+RetSqlName("SQB")+" SQB "
	_cQuery += "    ON SQB.QB_FILIAL = ' ' "
	_cQuery += "        AND SQB.QB_DEPTO = SRA.RA_DEPTO "
	_cQuery += "        AND Sqb.D_E_L_E_T_ = ' ' "
	_cQuery += " LEFT JOIN "+RetSqlName("SRA")+" SRASUP "
	_cQuery += "    ON SRASUP.RA_FILIAL = SQB.QB_FILRESP "
	_cQuery += "        AND SRASUP.RA_MAT = SQB.QB_MATRESP "
	_cQuery += "        AND SRASUP.D_E_L_E_T_ = ' ' "
	_cQuery += " WHERE SRA.RA_XAV360 = '1' "
	_cQuery += "   AND SRA.RA_DEMISSA = ' ' "
	_cQuery += "   AND SRA.D_E_L_E_T_ = ' ' "
	_cQuery += " ORDER BY RA_XFILSUP, RA_XEMPSUP, RA_XMATSUP, RA_XUSRSUP, RA_DEPTO "

	If Select("QRY") > 0
		Dbselectarea("QRY")
		QRY->(DbClosearea())
	EndIf

	TcQuery _cQuery New Alias "QRY"

	dbSelectArea("QRY")
	QRY->(dbGoTop())

	While !QRY->(Eof())

		_oSecCab:Init()

		_oSecCab:Cell("RA_XFILSUP"):SetValue(QRY->RA_XFILSUP)
		_oSecCab:Cell("RA_XEMPSUP"):SetValue(QRY->RA_XEMPSUP)
		_oSecCab:Cell("RA_XMATSUP"):SetValue(QRY->RA_XMATSUP)
		_oSecCab:Cell("RA_XUSRSUP"):SetValue(QRY->RA_XUSRSUP)
		_oSecCab:Cell("RA_NOMESUP"):SetValue(QRY->RA_NOMESUP)
		_oSecCab:Cell("RA_FILIAL"):SetValue(QRY->RA_FILIAL)
		_oSecCab:Cell("RA_XEMP"):SetValue(QRY->RA_XEMP)
		_oSecCab:Cell("RA_MAT"):SetValue(QRY->RA_MAT)
		_oSecCab:Cell("RA_XUSRCFG"):SetValue(QRY->RA_XUSRCFG)
		_oSecCab:Cell("RA_NOME"):SetValue(QRY->RA_NOME)
		_oSecCab:Cell("RA_CODFUNC"):SetValue(QRY->RA_CODFUNC)
		_oSecCab:Cell("RJ_DESC"):SetValue(QRY->RJ_DESC)
		_oSecCab:Cell("RA_DEPTO"):SetValue(QRY->RA_DEPTO)
		_oSecCab:Cell("QB_DESCRIC"):SetValue(QRY->QB_DESCRIC)
		_oSecCab:Cell("RA_ADMISSA"):SetValue(Stod(QRY->RA_ADMISSA))

		_oSecCab:PrintLine()

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