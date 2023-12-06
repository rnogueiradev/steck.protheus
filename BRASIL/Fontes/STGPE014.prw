#INCLUDE "Topconn.ch"
#INCLUDE "Protheus.ch"

/*/{Protheus.doc} u_STGPE014()

Relatórios de avaliação de experiência

@type function
@author Everson Santana
@since 07/04/2021
@version Protheus 12 - SigaGpe

@history ,Ticket 20210216002613 ,

/*/

User Function STGPE014()
	/*
	Declaracao de variaveis
	*/
	Private _oReport := Nil
	Private _oSecCab := Nil
	Private _cPerg 	 := PadR ("STGPE014", Len (SX1->X1_GRUPO))
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

	_cTitulo := "Relatórios de Avaliação de Experiência"

	_oReport := TReport():New("STGPE014"+Alltrim(StrTran(time(),":","")),_cTitulo,_cPerg,{|_oReport| PrintReport(_oReport)},_cTitulo)

	Pergunte("STGPE014",.F.)

	_oSecCab := TRSection():New( _oReport , _cTitulo, {"QRY"} )

	TRCell():New( _oSecCab, "Z49_FILIAL"	,,RetTitle("Z49_FILIAL")	,PesqPict('Z49',"Z49_FILIAL")	,TamSX3("Z49_FILIAL")[1]+20	,.F.,)//01
	TRCell():New( _oSecCab, "Z49_COD"		,,RetTitle("Z49_COD") 		,PesqPict('Z49',"Z49_COD")		,TamSX3("Z49_COD")[1]+20	,.F.,)//02
	TRCell():New( _oSecCab, "Z49_MAT"    	,,RetTitle("Z49_MAT") 		,PesqPict('Z49',"Z49_MAT")		,TamSX3("Z49_MAT")[1]+20	,.F.,)//03
	TRCell():New( _oSecCab, "Z49_NOME"    	,,RetTitle("Z49_NOME") 		,PesqPict('Z49',"Z49_NOME")		,TamSX3("Z49_NOME")[1]+70	,.F.,)//04
	TRCell():New( _oSecCab, "Z49_DATA"    	,,RetTitle("Z49_DATA") 		,PesqPict('Z49',"Z49_DATA")		,TamSX3("Z49_DATA")[1]+10	,.F.,)//04
	TRCell():New( _oSecCab, "Z49_C01"		,,RetTitle("Z49_C01")		,PesqPict('Z49',"Z49_C01")		,TamSX3("Z49_C01")[1]+70	,.F.,)//05
	TRCell():New( _oSecCab, "Z49_C02"		,,RetTitle("Z49_C02")		,PesqPict('Z49',"Z49_C02")		,TamSX3("Z49_C02")[1]+70	,.F.,)//05
	TRCell():New( _oSecCab, "Z49_C03"		,,RetTitle("Z49_C03")		,PesqPict('Z49',"Z49_C03")		,TamSX3("Z49_C03")[1]+70	,.F.,)//05
	TRCell():New( _oSecCab, "Z49_C04"    	,,RetTitle("Z49_C04")		,PesqPict('Z49',"Z49_C04")		,TamSX3("Z49_C04")[1]+70	,.F.,)//06
	TRCell():New( _oSecCab, "Z49_C05"    	,,RetTitle("Z49_C05")		,PesqPict('Z49',"Z49_C05")		,TamSX3("Z49_C05")[1]+70	,.F.,)//08
	TRCell():New( _oSecCab, "Z49_C06"  		,,RetTitle("Z49_C06")		,PesqPict('Z49',"Z49_C06")		,TamSX3("Z49_C06")[1]+70	,.F.,)//07
	TRCell():New( _oSecCab, "Z49_C07"    	,,RetTitle("Z49_C07")		,PesqPict('Z49',"Z49_C07")		,TamSX3("Z49_C07")[1]+70	,.F.,)//09
	TRCell():New( _oSecCab, "Z49_C08"   	,,RetTitle("Z49_C08")		,PesqPict('Z49',"Z49_C08")		,TamSX3("Z49_C08")[1]+70	,.F.,)//10
	TRCell():New( _oSecCab, "Z49_C09"   	,,RetTitle("Z49_C09")		,PesqPict('Z49',"Z49_C09")		,TamSX3("Z49_C09")[1]+70	,.F.,)//10
	TRCell():New( _oSecCab, "Z49_C10"   	,,RetTitle("Z49_C10")		,PesqPict('Z49',"Z49_C10")		,TamSX3("Z49_C10")[1]+70	,.F.,)//11
	TRCell():New( _oSecCab, "Z49_C11"   	,,RetTitle("Z49_C11")		,PesqPict('Z49',"Z49_C11")		,TamSX3("Z49_C11")[1]+70	,.F.,)//12
	TRCell():New( _oSecCab, "Z49_PON01"		,,RetTitle("Z49_PON01")		,PesqPict('Z49',"Z49_PON01")	,TamSX3("Z49_PON01")[1]		,.F.,)//13
	TRCell():New( _oSecCab, "Z49_PON02"		,,RetTitle("Z49_PON02")		,PesqPict('Z49',"Z49_PON02")	,TamSX3("Z49_PON02")[1]		,.F.,)//14
	TRCell():New( _oSecCab, "Z49_ORIENT"    ,,RetTitle("Z49_ORIENT")	,PesqPict('Z49',"Z49_ORIENT")	,TamSX3("Z49_ORIENT")[1]	,.F.,)//15
	TRCell():New( _oSecCab, "Z49_DECISA"    ,,RetTitle("Z49_DECISA")	,PesqPict('Z49',"Z49_DECISA")	,TamSX3("Z49_DECISA")[1]+70	,.F.,)//16
	TRCell():New( _oSecCab, "Z49_STATUS"    ,,RetTitle("Z49_STATUS") 	,PesqPict('Z49',"Z49_STATUS")	,TamSX3("Z49_STATUS")[1]+70	,.F.,)//17
	TRCell():New( _oSecCab, "Z49_APROV"   	,,RetTitle("Z49_APROV")		,PesqPict('Z49',"Z49_APROV")	,TamSX3("Z49_APROV")[1]+30	,.F.,)//18
	TRCell():New( _oSecCab, "Z49_DTAPRO"   	,,RetTitle("Z49_DTAPRO")	,PesqPict('Z49',"Z49_DTAPRO")	,TamSX3("Z49_DTAPRO")[1]+30	,.F.,)//19
	TRCell():New( _oSecCab, "Z49_TIMEAP"   	,,RetTitle("Z49_TIMEAP") 	,PesqPict('Z49',"Z49_TIMEAP")	,TamSX3("Z49_TIMEAP")[1]+30	,.F.,)//20
	TRCell():New( _oSecCab, "Z49_RHAPR"   	,,RetTitle("Z49_RHAPR")  	,PesqPict('Z49',"Z49_RHAPR")	,TamSX3("Z49_RHAPR")[1]+30	,.F.,)//21
	TRCell():New( _oSecCab, "Z49_RHDT"   	,,RetTitle("Z49_RHDT")		,PesqPict('Z49',"Z49_RHDT")		,TamSX3("Z49_RHDT")[1]+30	,.F.,)//22
	TRCell():New( _oSecCab, "Z49_RHHORA"   	,,RetTitle("Z49_RHHORA")	,PesqPict('Z49',"Z49_RHHORA")	,TamSX3("Z49_RHHORA")[1]+30	,.F.,)//23
	TRCell():New( _oSecCab, "Z49_EMAIL"   	,,RetTitle("Z49_EMAIL")		,PesqPict('Z49',"Z49_EMAIL")	,TamSX3("Z49_EMAIL")[1]		,.F.,)//24

Return Nil

/*
Processamento da Query
*/
Static Function PrintReport(_oReport)

	Local _cQuery     := ""

	_cQuery += " SELECT * FROM "+RetSqlName("Z49")+" Z49 "
	_cQuery += " WHERE Z49_FILIAL BETWEEN '"+MV_PAR03+" ' AND '"+MV_PAR04+"' "
	If MV_PAR05 <> 4
		_cQuery += " AND Z49_STATUS = '"+Alltrim(Str(MV_PAR05))+"' "
	else
		_cQuery += " AND Z49_DATA BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"' "
	EndIf
	_cQuery += " AND D_E_L_E_T_ = ' ' "

	If Select("QRY") > 0
		Dbselectarea("QRY")
		QRY->(DbClosearea())
	EndIf

	TcQuery _cQuery New Alias "QRY"

	dbSelectArea("QRY")
	QRY->(dbGoTop())

	While !QRY->(Eof())

		_oSecCab:Init()

		_oSecCab:Cell("Z49_FILIAL"):SetValue(QRY->Z49_FILIAL)
		_oSecCab:Cell("Z49_COD"):SetValue(QRY->Z49_COD)
		_oSecCab:Cell("Z49_MAT"):SetValue(QRY->Z49_MAT)
		_oSecCab:Cell("Z49_NOME"):SetValue(QRY->Z49_NOME)
		_oSecCab:Cell("Z49_DATA"):SetValue(Stod(QRY->Z49_DATA))
		_oSecCab:Cell("Z49_C01"):SetValue(DescCmb("Z49_C01",QRY->Z49_C01))
		_oSecCab:Cell("Z49_C02"):SetValue(DescCmb("Z49_C02",QRY->Z49_C02))
		_oSecCab:Cell("Z49_C03"):SetValue(DescCmb("Z49_C03",QRY->Z49_C03))
		_oSecCab:Cell("Z49_C04"):SetValue(DescCmb("Z49_C04",QRY->Z49_C04))
		_oSecCab:Cell("Z49_C05"):SetValue(DescCmb("Z49_C05",QRY->Z49_C05))
		_oSecCab:Cell("Z49_C06"):SetValue(DescCmb("Z49_C06",QRY->Z49_C06))
		_oSecCab:Cell("Z49_C07"):SetValue(DescCmb("Z49_C07",QRY->Z49_C07))
		_oSecCab:Cell("Z49_C08"):SetValue(DescCmb("Z49_C08",QRY->Z49_C08))
		_oSecCab:Cell("Z49_C09"):SetValue(DescCmb("Z49_C09",QRY->Z49_C09))
		_oSecCab:Cell("Z49_C10"):SetValue(DescCmb("Z49_C10",QRY->Z49_C10))
		_oSecCab:Cell("Z49_C11"):SetValue(DescCmb("Z49_C11",QRY->Z49_C11))
		_oSecCab:Cell("Z49_PON01"):SetValue(Alltrim(QRY->Z49_PON01))
		_oSecCab:Cell("Z49_PON02"):SetValue(Alltrim(QRY->Z49_PON02))
		_oSecCab:Cell("Z49_ORIENT"):SetValue(Alltrim(QRY->Z49_ORIENT))
		_oSecCab:Cell("Z49_DECISA"):SetValue(DescCmb("Z49_DECISA",QRY->Z49_DECISA))
		_oSecCab:Cell("Z49_STATUS"):SetValue(DescCmb("Z49_STATUS",QRY->Z49_STATUS) )
		_oSecCab:Cell("Z49_APROV"):SetValue(QRY->Z49_APROV)
		_oSecCab:Cell("Z49_DTAPRO"):SetValue(Stod(QRY->Z49_DTAPRO))
		_oSecCab:Cell("Z49_TIMEAP"):SetValue(QRY->Z49_TIMEAP)
		_oSecCab:Cell("Z49_RHAPR"):SetValue(QRY->Z49_RHAPR)
		_oSecCab:Cell("Z49_RHDT"):SetValue(Stod(QRY->Z49_RHDT))
		_oSecCab:Cell("Z49_RHHORA"):SetValue(QRY->Z49_RHHORA)
		_oSecCab:Cell("Z49_EMAIL"):SetValue(Alltrim(QRY->Z49_EMAIL))

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
	AADD(_aRegs,{_cPerg,"03","Da Filial? "		,"Da Filial "		,"Da Filial  "		,"mv_ch3","C",02,0,0,"G","          ","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(_aRegs,{_cPerg,"04","Ate Filial? "		,"Ate Filial "		,"Filial  "			,"mv_ch4","C",02,0,0,"G","          ","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(_aRegs,{_cPerg,"05","Status? "			,"Status "			,"Status  "			,"mv_ch5","C",02,0,0,"G","          ","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
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

Static Function DescCmb(cCampo, cConteudo)

	Local aArea       := GetArea()
	Local aCombo      := {}
	Local cDescri     := ""
	Local nAtual      := 1
	Default cChave    := ""
	Default cCampo    := ""
	Default cConteudo := ""

	If (Empty(cCampo) .OR. Empty(cConteudo))
		cDescri := ""
	Else
		aCombo := RetSX3Box(GetSX3Cache(cCampo, "X3_CBOX"),,,1)
		nAtual	  := aScan(aCombo,{|x| AllTrim(x[2]) == cConteudo})
		cDescri := aCombo[nAtual][3]
	EndIf

	RestArea(aArea)

Return(cDescri)