
#INCLUDE "Topconn.ch"
#INCLUDE "Protheus.ch"

/*/{Protheus.doc} ARSTREST01

Listado de Remitos

@type function
@author Everson Santana
@since 14/06/18
@version Protheus 12 - Stock/Costos

@history , ,

/*/

User Function ARSTREST01()

/*
Declaracao de variaveis
*/
Private _oReport := Nil
Private _oSecCab := Nil
Private _cPerg 	 := PadR ("AARSTREST01", Len (SX1->X1_GRUPO))

ValidPerg()

/*
Definicoes/preparacao para impressao
*/
ReportDef()
_oReport:PrintDialog()

Return
/*
Definio da estrutura do relatrio.
*/
Static Function ReportDef()

//_oReport:SetLandScape(.T.)
_oReport := TReport():New("ARSTREST01","Listado de Remitos",_cPerg,{|_oReport| PrintReport(_oReport)},"Listado de Remitos")

_oSecCab := TRSection():New( _oReport , "Remitos", {"QRY"} )

TRCell():New( _oSecCab, "F2_EMISSAO"	,,"Fch Emision  " ,PesqPict('SF2',"F2_EMISSAO")	,TamSX3("F2_EMISSAO")[1],.F.,)
TRCell():New( _oSecCab, "F2_DTDIGIT"	,,"Fch. Digitación" ,PesqPict('SF2',"F2_DTDIGIT")	,TamSX3("F2_DTDIGIT")[1],.F.,)
TRCell():New( _oSecCab, "F2_DOC"		,,"Num. Remito  " ,PesqPict('SF2',"F2_DOC")	    ,TamSX3("F2_DOC")[1],.F.,)
TRCell():New( _oSecCab, "F2_SERIE"		,,"Serie. Remito  " ,PesqPict('SF2',"F2_SERIE")	    ,TamSX3("F2_SERIE")[1],.F.,)
TRCell():New( _oSecCab, "F2_CLIENTE"    ,,"Cliente      " ,PesqPict('SF2',"F2_CLIENTE")	,TamSX3("F2_CLIENTE")[1],.F.,)
TRCell():New( _oSecCab, "A1_NOME"     	,,"Nombre       " ,PesqPict('SA1',"A1_NOME")	,TamSX3("A1_NOME")[1]	,.F.,)
TRCell():New( _oSecCab, "F2_LOJA"   	,,"Tienda       " ,PesqPict('SF2',"F2_LOJA")	,TamSX3("F2_LOJA")[1]	,.F.,)
TRCell():New( _oSecCab, "F2_HORA"  		,,"Hora         " ,PesqPict('SF2',"F2_HORA")	,TamSX3("F2_HORA")[1]	,.F.,)
TRCell():New( _oSecCab, "F2_TRANSP"    	,,"Transp.      " ,PesqPict('SF2',"F2_TRANSP")	,TamSX3("F2_TRANSP")[1]	,.F.,) 
TRCell():New( _oSecCab, "A4_NOME"     	,,"Nombre       " ,PesqPict('SA4',"A4_NOME")	,TamSX3("A4_NOME")[1]	,.F.,) 
TRCell():New( _oSecCab, "A1_END"   		,,"Direccion    " ,PesqPict('SA1',"A1_END")		,TamSX3("A1_END")[1]	,.F.,)
TRCell():New( _oSecCab, "A1_MUN"   		,,"Municipio    " ,PesqPict('SA1',"A1_MUN")		,TamSX3("A1_MUN")[1]	,.F.,)
TRCell():New( _oSecCab, "F2_PBRUTO"   	,,"Peso         " ,PesqPict('SF2',"F2_PBRUTO")	,TamSX3("F2_PBRUTO")[1]	,.F.,)
TRCell():New( _oSecCab, "F2_VALBRUT"   	,,"Valor Bruto  " ,PesqPict('SF2',"F2_VALBRUT")	,TamSX3("F2_VALBRUT")[1],.F.,)

Return Nil
/*
Processamento da Query
*/
Static Function PrintReport(_oReport)

Local _cQuery     := ""

Pergunte(_cPerg,.F.)

_cQuery += " SELECT F2.F2_EMISSAO,F2.F2_DTDIGIT,F2.F2_SERIE,F2.F2_DOC,F2.F2_CLIENTE,A1.A1_NOME,F2.F2_LOJA,F2.F2_HORA,F2.F2_TRANSP,A4.A4_NOME,A1.A1_END,A1.A1_MUN,F2.F2_PBRUTO,F2.F2_VALBRUT "
_cQuery += "  FROM " + RetSqlName("SF2") + " F2 "
_cQuery += "  LEFT JOIN " + RetSqlName("SA1") + " A1 "
_cQuery += "  ON A1.A1_COD = F2.F2_CLIENTE "
_cQuery += " AND A1.A1_LOJA = F2.F2_LOJA "
_cQuery += " AND A1.D_E_L_E_T_ = ' ' "
_cQuery += "  LEFT JOIN " + RetSqlName("SA4") + " A4 "
_cQuery += " ON A4.A4_COD = F2.F2_TRANSP "
_cQuery += " AND F2.D_E_L_E_T_ = ' ' "
_cQuery += " WHERE F2.F2_EMISSAO BETWEEN '"+dtos(MV_PAR03)+"' AND '"+dtos(MV_PAR04)+"' "
_cQuery += " AND F2.F2_DOC BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "	
_cQuery += " AND F2.F2_SERIE BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' "
_cQuery += " AND F2.F2_DTDIGIT BETWEEN '"+dtos(MV_PAR01)+"' AND '"+dtos(MV_PAR02)+"' "
_cQuery += " AND F2.D_E_L_E_T_ = ' ' "
_cQuery += " AND A4.D_E_L_E_T_ = ' ' "
_cQuery += " Order By F2.F2_DOC,F2.F2_DTDIGIT "

MemoWrite("C:\LOG\QUERYREMITO.TXT", _cQuery)

//_cQuery := ChangeQuery(_cQuery)

If Select("QRY") > 0
	Dbselectarea("QRY")
	QRY->(DbClosearea())
EndIf

TcQuery _cQuery New Alias "QRY"

dbSelectArea("QRY")
QRY->(dbGoTop())

	While !QRY->(Eof())
	
		_oSecCab:Init()
		_oSecCab:Cell("F2_EMISSAO"):SetValue(Stod(QRY->F2_EMISSAO))
        _oSecCab:Cell("F2_DTDIGIT"):SetValue(Stod(QRY->F2_DTDIGIT))
		_oSecCab:Cell("F2_DOC"):SetValue(QRY->F2_DOC)
        _oSecCab:Cell("F2_SERIE"):SetValue(QRY->F2_SERIE)
		_oSecCab:Cell("F2_CLIENTE"):SetValue(QRY->F2_CLIENTE)
		_oSecCab:Cell("A1_NOME"):SetValue(QRY->A1_NOME)
		_oSecCab:Cell("F2_LOJA"):SetValue(QRY->F2_LOJA)
		_oSecCab:Cell("F2_HORA"):SetValue(QRY->F2_HORA)
		_oSecCab:Cell("F2_TRANSP"):SetValue(QRY->F2_TRANSP)
		_oSecCab:Cell("A4_NOME"):SetValue(QRY->A4_NOME)
		_oSecCab:Cell("A1_END"):SetValue(QRY->A1_END)
		_oSecCab:Cell("A1_MUN"):SetValue(QRY->A1_MUN)
		_oSecCab:Cell("F2_PBRUTO"):SetValue(QRY->F2_PBRUTO)
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
AADD(_aRegs,{_cPerg,"01","De DT Digitacao  ?  	","De Fch Digit ","Issue Date  ","mv_ch1","D",TamSX3("F2_EMISSAO")[1],0,0,"G","          ","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(_aRegs,{_cPerg,"02","Ate DT Digitacao  ?  ","Ate Fch  Digit ","Issue Date  ","mv_ch2","D",TamSX3("F2_EMISSAO")[1],0,0,"G","          ","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(_aRegs,{_cPerg,"03","De DT Emissao  ?  "	,"De Fch Emision  ","Issue Date  ","mv_ch3","D",TamSX3("F2_EMISSAO")[1],0,0,"G","          ","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(_aRegs,{_cPerg,"04","Ate DT Emissao ?  "	,"Ate Fch Emision ","Issue Date  ","mv_ch4","D",TamSX3("F2_EMISSAO")[1],0,0,"G","          ","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(_aRegs,{_cPerg,"05","Do Remito  ?  "		,"Do Remito ","Issue Date  ","mv_ch5","C",TamSX3("F2_DOC")[1],0,0,"G","          ","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(_aRegs,{_cPerg,"06","Ate Remito  ?  "		,"Do Remito ","Issue Date  ","mv_ch6","C",TamSX3("F2_DOC")[1],0,0,"G","          ","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(_aRegs,{_cPerg,"07","Da Serie  ?  "		,"Da Serie ","Issue Date  ","mv_ch7","C",TamSX3("F2_SERIE")[1],0,0,"G","          ","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(_aRegs,{_cPerg,"08","Ate a Serie  ?  "		,"Ate Serie","Issue Date  ","mv_ch7","C",TamSX3("F2_SERIE")[1],0,0,"G","          ","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","",""})


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
