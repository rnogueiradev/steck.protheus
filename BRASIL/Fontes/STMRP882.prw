#INCLUDE "Topconn.ch"
#INCLUDE "Protheus.ch"
#DEFINE CR    chr(13)+chr(10)
/*/{Protheus.doc} u_STMRP882()

MRP - Steck   

@type function
@author Everson Santana
@since 04/12/18
@version Protheus 12 - SigaEst

@history ,Ticket 20200113000019 ,

/*/

User Function STMRP882()
	/*
	Declaracao de variaveis
	*/
	Private _oReport := Nil
	Private _oSecCab := Nil
	Private _cPerg 	 := PadR ("STMRP882", Len (SX1->X1_GRUPO))
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

	Local _nInd := 0
	Private _aFields := {}


	_cTitulo := "MRP - Steck"

	_oReport := TReport():New("STMRP882"+Alltrim(StrTran(time(),":","")),_cTitulo,_cPerg,{|_oReport| PrintReport(_oReport)},_cTitulo)

	Pergunte("STMRP882",.F.)
	
	_oSecCab := TRSection():New( _oReport , _cTitulo, {"QRY"} )

	TRCell():New( _oSecCab, "CZJ_PROD"		,,RetTitle("CZJ_PROD")	,PesqPict('CZJ',"CZJ_PROD")		,TamSX3("CZJ_PROD")[1]	,.F.,)//01
	TRCell():New( _oSecCab, "B1_DESC"		,,RetTitle("B1_DESC") 	,PesqPict('SB1',"B1_DESC")		,TamSX3("B1_DESC")[1]	,.F.,)//02
	TRCell():New( _oSecCab, "B1_UM"    		,,RetTitle("B1_UM") 	,PesqPict('SB1',"B1_UM")		,TamSX3("B1_UM")[1]		,.F.,)//03
	TRCell():New( _oSecCab, "B1_LE"    		,,RetTitle("B1_LE") 	,PesqPict('SB1',"B1_LE")		,TamSX3("B1_LE")[1]		,.F.,)//04
	TRCell():New( _oSecCab, "B1_ESTSEG"    	,,RetTitle("B1_ESTSEG")	,PesqPict('SB1',"B1_ESTSEG")	,TamSX3("B1_ESTSEG")[1]	,.F.,)//04
	TRCell():New( _oSecCab, "B1_EMIN"		,,RetTitle("B1_EMIN")	,PesqPict('SB1',"B1_EMIN")		,TamSX3("B1_EMIN")[1]	,.F.,)//05
	TRCell():New( _oSecCab, "B1_QE"			,,RetTitle("B1_QE ")	,PesqPict('SB1',"B1_QE ")		,TamSX3("B1_QE ")[1]	,.F.,)//05
	TRCell():New( _oSecCab, "B1_TIPO"		,,RetTitle("B1_TIPO")	,PesqPict('SB1',"B1_TIPO")		,TamSX3("B1_TIPO")[1]	,.F.,)//05
	TRCell():New( _oSecCab, "CZJ_NRMRP"		,,RetTitle("CZJ_NRMRP")	,PesqPict('CZJ',"CZJ_NRMRP")	,TamSX3("CZJ_NRMRP")[1]	,.F.,)//05

	For _nInd := 1 to Len(aPeriodos)

		TRCell():New( _oSecCab, "PER"+StrZero(_nInd,3)+"_CZK_QTSLES"    ,,"Per.: "+dtoc(aPeriodos[_nInd])+" - "+RetTitle("CZK_QTSLES"),PesqPict('CZK',"CZK_QTSLES")	,TamSX3("CZK_QTSLES")[1],.F.,,,.t.)//08
		TRCell():New( _oSecCab, "PER"+StrZero(_nInd,3)+"_CZK_QTENTR"  	,,RetTitle("CZK_QTENTR"),PesqPict('CZK',"CZK_QTENTR")	,TamSX3("CZK_QTENTR")[1],.F.,)//07
		TRCell():New( _oSecCab, "PER"+StrZero(_nInd,3)+"_CZK_QTSAID"    ,,RetTitle("CZK_QTSAID"),PesqPict('CZK',"CZK_QTSAID")	,TamSX3("CZK_QTSAID")[1],.F.,)//09
		TRCell():New( _oSecCab, "PER"+StrZero(_nInd,3)+"_CZK_QTSEST"   	,,RetTitle("CZK_QTSEST"),PesqPict('CZK',"CZK_QTSEST")	,TamSX3("CZK_QTSEST")[1],.F.,)//10
		TRCell():New( _oSecCab, "PER"+StrZero(_nInd,3)+"_CZK_QTSALD"   	,,RetTitle("CZK_QTSALD"),PesqPict('CZK',"CZK_QTSALD")	,TamSX3("CZK_QTSALD")[1],.F.,)//10
		TRCell():New( _oSecCab, "PER"+StrZero(_nInd,3)+"_CZK_QTNECE"   	,,RetTitle("CZK_QTNECE"),PesqPict('CZK',"CZK_QTNECE")	,TamSX3("CZK_QTNECE")[1],.F.,)//11
		TRCell():New( _oSecCab, "PER"+StrZero(_nInd,3)+"_CUSTO"   		,,"Valor"				,PesqPict('SB2',"B2_VATU1")		,TamSX3("B2_VATU1")[1],.F.,)//11
		
	Next _nInd

Return Nil

/*
Processamento da Query
*/
Static Function PrintReport(_oReport)

	Local _cQuery     	:= ""
	Local _cProd	  	:= ""
	Local _aDados	  	:= {}
	Local _nInd,_nInd1,_nInd2,_nInd3,_nInd4,_nInd5,_nInd6,nPer	:= 0

	_cQuery += "               SELECT    CZJ.CZJ_PROD, "
	_cQuery += "                         SB1.B1_DESC,  "
	_cQuery += "                             SB1.B1_UM, "
	_cQuery += "                             SB1.B1_LE , "
	_cQuery += "                             SB1.B1_ESTSEG , "
	_cQuery += "                             SB1.B1_EMIN , "
	_cQuery += "                             SB1.B1_QE  , "
	_cQuery += "                             SB1.B1_TIPO, "
	_cQuery += " 							 SB2.B2_CM1, "
	_cQuery += "                             CZJ.CZJ_NRMRP, "
	_cQuery += "                             CZK.CZK_PERMRP, "
	_cQuery += "                             CZK.CZK_QTSLES, "
	_cQuery += "                             CZK.CZK_QTENTR, "
	_cQuery += "                             CZK.CZK_QTSAID, "
	_cQuery += "                             CZK.CZK_QTSEST, "
	_cQuery += "                             CZK.CZK_QTSALD, "
	_cQuery += "                             CZK.CZK_QTNECE, "
	_cQuery += "							 Nvl(CZK.CZK_QTNECE * SB2.B2_CM1,0) CUSTO "
	_cQuery += "                   FROM      "+RetSqlName("CZJ")+" CZJ "
	_cQuery += "                   	LEFT JOIN "+RetSqlName("SB1")+" SB1 "
	_cQuery += "                   		ON	SB1.B1_COD = CZJ.CZJ_PROD "
	_cQuery += "                   		AND	SB1.D_E_L_E_T_ = ' ' "
    _cQuery += "   				   	LEFT JOIN "+RetSqlName("SB2")+" SB2 "
    _cQuery += "          				ON	SB2.B2_COD = CZJ.CZJ_PROD "
    _cQuery += "             			AND SB2.B2_LOCAL = SB1.B1_LOCPAD"
	_cQuery += "						AND SB2.B2_FILIAL = '"+xFilial("SB2")+"' "
    _cQuery += "            			AND SB2.D_E_L_E_T_ = ' ', "
	_cQuery += "                             "+RetSqlName("CZK0")+" CZK "
	_cQuery += "                   WHERE     CZJ.CZJ_FILIAL = '"+xFilial("CZJ")+"' "
	_cQuery += "                   AND       CZJ.CZJ_PROD BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
	_cQuery += "                   AND       CZK.CZK_FILIAL = '"+xFilial("CZK")+"' "
	_cQuery += "                   AND       CZJ.R_E_C_N_O_ = CZK.CZK_RGCZJ "
	_cQuery += "                   AND       ( "
	_cQuery += "                                       CZK.CZK_QTNECE <> 0 "
	_cQuery += "                             OR        CZK.CZK_QTSAID <> 0 "
	_cQuery += "                             OR        CZK.CZK_QTSALD <> 0 "
	_cQuery += "                             OR        CZK.CZK_QTSEST <> 0 "
	_cQuery += "                             OR        CZK.CZK_QTENTR <> 0 "
	_cQuery += "                             OR        CZK.CZK_QTSLES <> 0 ) "
	_cQuery += "                   ORDER BY  CZJ.CZJ_PROD, "
	_cQuery += "                             CZJ.CZJ_OPCORD, "
	_cQuery += "                             CZJ.CZJ_NRRV, "
	_cQuery += "                             CZK.CZK_PERMRP

	If Select("QRY") > 0
		Dbselectarea("QRY")
		QRY->(DbClosearea())
	EndIf

	_cQuery := ChangeQuery(_cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"QRY",.T.,.T.)

//	TcQuery _cQuery New Alias "QRY"

	dbSelectArea("QRY")
	QRY->(dbGoTop())

	_nInd2 := 1

	While !QRY->(Eof())

		AADD(_aDados,{	QRY->CZJ_PROD,;
			QRY->B1_DESC,;
			QRY->B1_UM,;
			QRY->B1_LE,;
			QRY->B1_ESTSEG,;
			QRY->B1_EMIN,;
			QRY->B1_QE ,;
			QRY->B1_TIPO,;
			QRY->CZJ_NRMRP;
			})

		_nInd6 := Len(_aDados[_nInd2])+1
		For _nInd := 1 to Len(aPeriodos)

			For _nInd1 := 1 to 7
				AADD(_aDados[_nInd2],0)
			Next

		Next _nInd

		_cProd  := QRY->CZJ_PROD

		While QRY->CZJ_PROD = _cProd

			If QRY->CZK_PERMRP == "001"
				_nInd3 := _nInd6 //Sempre que incluir um campo novo aumentar
			Else
				nPer := Val(QRY->CZK_PERMRP) - 1
				nPer := nPer * 7
				_nInd3 := _nInd6 + nPer
			EndIf

			_aDados[_nInd2][_nInd3]    := QRY->CZK_QTSLES
			_aDados[_nInd2][_nInd3+=1] := QRY->CZK_QTENTR
			_aDados[_nInd2][_nInd3+=1] := QRY->CZK_QTSAID
			_aDados[_nInd2][_nInd3+=1] := QRY->CZK_QTSEST
			_aDados[_nInd2][_nInd3+=1] := QRY->CZK_QTSALD
			_aDados[_nInd2][_nInd3+=1] := QRY->CZK_QTNECE
			_aDados[_nInd2][_nInd3+=1] := QRY->CUSTO

			QRY->(DbSkip())

		End

		_nInd2 += 1
		//_nInd6 := 0
	EndDo

	_oSecCab:Init()

	For _nInd3 := 1 to len(_aDados)

		_oSecCab:Cell("CZJ_PROD"):SetValue(_aDados[_nInd3][01])
		_oSecCab:Cell("B1_DESC"):SetValue(_aDados[_nInd3][02])
		_oSecCab:Cell("B1_UM"):SetValue(_aDados[_nInd3][03])
		_oSecCab:Cell("B1_LE"):SetValue(_aDados[_nInd3][04])
		_oSecCab:Cell("B1_ESTSEG"):SetValue(_aDados[_nInd3][05])
		_oSecCab:Cell("B1_EMIN"):SetValue(_aDados[_nInd3][06])
		_oSecCab:Cell("B1_QE"):SetValue(_aDados[_nInd3][07])
		_oSecCab:Cell("B1_TIPO"):SetValue(_aDados[_nInd3][08])
		_oSecCab:Cell("CZJ_NRMRP"):SetValue(_aDados[_nInd3][09])
		_nInd5 := 1
		For _nInd4 := _nInd6 to Len(_aDados[_nInd3])
			_oSecCab:Cell("PER"+StrZero(_nInd5,3)+"_CZK_QTSLES"):SetValue(_aDados[_nInd3][_nInd4])
			_oSecCab:Cell("PER"+StrZero(_nInd5,3)+"_CZK_QTENTR"):SetValue(_aDados[_nInd3][_nInd4+=1])
			_oSecCab:Cell("PER"+StrZero(_nInd5,3)+"_CZK_QTSAID"):SetValue(_aDados[_nInd3][_nInd4+=1])
			_oSecCab:Cell("PER"+StrZero(_nInd5,3)+"_CZK_QTSEST"):SetValue(_aDados[_nInd3][_nInd4+=1])
			_oSecCab:Cell("PER"+StrZero(_nInd5,3)+"_CZK_QTSALD"):SetValue(_aDados[_nInd3][_nInd4+=1])
			_oSecCab:Cell("PER"+StrZero(_nInd5,3)+"_CZK_QTNECE"):SetValue(_aDados[_nInd3][_nInd4+=1])
			_oSecCab:Cell("PER"+StrZero(_nInd5,3)+"_CUSTO"):SetValue(_aDados[_nInd3][_nInd4+=1])
			_nInd5 += 1
		Next _nInd4

		_oSecCab:PrintLine()

	Next _nInd3

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