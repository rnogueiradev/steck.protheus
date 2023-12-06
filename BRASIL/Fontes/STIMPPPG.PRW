#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"

/*====================================================================================\
|Programa  | STIMPPPG         | Autor | Renato Nogueira            | Data | 25/08/2020|
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 			                                                              |
|=====================================================================================|
|Uso       | Especifico Steck                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STIMPPPG()

	Local _nX
	Local _aDados 	:= {}
	Local _cQuery1  := ""
	Local _cAlias1  := ""

	RpcSetType( 3 )
	RpcSetEnv("01","02",,,"FAT")
	
	_cAlias1 := GetNextAlias()

	AADD(_aDados,{'CHP38TP1MP63',38.03})
	AADD(_aDados,{'CHP38TP16M1',38.03})
	AADD(_aDados,{'CHP38TP25M1P6',38.03})
	AADD(_aDados,{'CHP38TP5M2P5',38.03})
	AADD(_aDados,{'CHP38T1M4',38.03})
	AADD(_aDados,{'CHP38T1P5M6',38.03})
	AADD(_aDados,{'CHP38T2M8',38.03})
	AADD(_aDados,{'CHP38T3M10',38.03})
	AADD(_aDados,{'CHP38T4M13',38.03})
	AADD(_aDados,{'CHP38T5M18',38.03})
	AADD(_aDados,{'CHP38T7P5M25',38.03})
	AADD(_aDados,{'CHP38T10M32',38.03})
	AADD(_aDados,{'CHP38T15M40',38.03})
	AADD(_aDados,{'CHP95T15M40',38.03})
	AADD(_aDados,{'CHP95T20M50',38.03})
	AADD(_aDados,{'CHP95T25M65',38.03})
	AADD(_aDados,{'CHP95T30M80',38.03})
	AADD(_aDados,{'CHP95T35M93',38.03})
	AADD(_aDados,{'CHP38TP16QP63',38.03})
	AADD(_aDados,{'CHP38TP25Q1',38.03})
	AADD(_aDados,{'CHP38TP5Q1P6',38.03})
	AADD(_aDados,{'CHP38T1Q2P5',38.03})
	AADD(_aDados,{'CHP38T2Q4',38.03})
	AADD(_aDados,{'CHP38T3Q6',38.03})
	AADD(_aDados,{'CHP38T4Q8',38.03})
	AADD(_aDados,{'CHP38T5Q10',38.03})
	AADD(_aDados,{'CHP38T7P5Q13',38.03})
	AADD(_aDados,{'CHP38T10Q18',38.03})
	AADD(_aDados,{'CHP38T15Q25',38.03})
	AADD(_aDados,{'CHP38T20Q32',38.03})
	AADD(_aDados,{'CHP38T25Q40',38.03})
	AADD(_aDados,{'CHP95T25Q40',38.03})
	AADD(_aDados,{'CHP95T30Q50',38.03})
	AADD(_aDados,{'CHP95T40Q65',38.03})
	AADD(_aDados,{'CHP95T50Q80',38.03})
	AADD(_aDados,{'CHP95T60Q93',38.03})

	DbSelectArea("PPG")
	
	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))
	
	DbSelectArea("SBM")
	SBM->(DbSetOrder(1))	

	For _nX:=1 To Len(_aDados)
	
		_cQuery1 := " SELECT PPG.R_E_C_N_O_ PPGREC
		_cQuery1 += " FROM "+RetSqlName("PPG")+" PPG
		_cQuery1 += " WHERE PPG.D_E_L_E_T_=' ' AND PPG_PROD='"+AllTrim(_aDados[_nX][1])+"'
		_cQuery1 += " AND PPG_NUM='000001' AND PPG_GRPVEN=' '
		
		If !Empty(Select(_cAlias1))
			DbSelectArea(_cAlias1)
			(_cAlias1)->(dbCloseArea())
		Endif
	
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)
	
		dbSelectArea(_cAlias1)
		(_cAlias1)->(dbGoTop())
	
		If (_cAlias1)->(!Eof())
			PPG->(DbGoTo((_cAlias1)->PPGREC))
			PPG->(RecLock("PPG",.F.))
		Else
			PPG->(RecLock("PPG",.T.))
		EndIf
		
		If !SB1->(DbSeek(xFilial("SB1")+PADR(AllTrim(_aDados[_nX][1]),TamSx3("B1_COD")[1])))
			MsgAlert("Código "+AllTrim(_aDados[_nX][1])+" não encontrado!")
			Loop
		EndIf
		
		If !SBM->(DbSeek(xFilial("SBM"+SB1->B1_GRUPO)))
			MsgAlert("Grupo "+AllTrim(_aDados[_nX][1])+" não encontrado!")
			Loop
		EndIf
		
		PPG->PPG_NUM 	:= "000001"
		PPG->PPG_PROD	:= SB1->B1_COD
		PPG->PPG_NPROD  := SB1->B1_DESC
		PPG->PPG_GRUPO 	:= SB1->B1_GRUPO
		PPG->PPG_NGRUPO	:= SBM->BM_DESC
		PPG->PPG_VALOR 	:= _aDados[_nX][2]
		
		PPG->(MsUnLock())

	Next
	
	MsgAlert("Rotina finalizada")

Return()