#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"

/*====================================================================================\
|Programa  | STQIE010         | Autor | Renato Nogueira            | Data | 07/11/2018|
|=====================================================================================|
|Descrição | Validar data digitada                                                    |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 			                                                              |
|=====================================================================================|
|Uso       | Especifico Steck..                                                    |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STQIE010()

	Local _lRet 	:= .T.
	Local _nPosFil	:= aScan(aHeader,{|x| Upper(AllTrim(x[2])) == "D7_FILIAL"})
	Local _nPosDoc	:= aScan(aHeader,{|x| Upper(AllTrim(x[2])) == "D7_DOC"})
	Local _nPosSer	:= aScan(aHeader,{|x| Upper(AllTrim(x[2])) == "D7_SERIE"})
	Local _nPosFor	:= aScan(aHeader,{|x| Upper(AllTrim(x[2])) == "D7_FORNECE"})
	Local _nPosLoj	:= aScan(aHeader,{|x| Upper(AllTrim(x[2])) == "D7_LOJA"})
	Local _nPosNum	:= aScan(aHeader,{|x| Upper(AllTrim(x[2])) == "D7_NUMERO"})
	Local _nPosDt	:= aScan(aHeader,{|x| Upper(AllTrim(x[2])) == "D7_DATA"})
	Local _cQuery1  := ""
	Local _cAlias1  := GetNextAlias()
	Local _nX

	If GetMv("STQIE010",,.T.)

		For _nX:=1 To Len(aCols)

			_cQuery1 := " SELECT D3_EMISSAO
			_cQuery1 += " FROM "+RetSqlName("SD3")+" D3
			_cQuery1 += " LEFT JOIN "+RetSqlName("SC2")+" C2
			_cQuery1 += " ON C2_FILIAL=D3_FILIAL AND C2_NUM||C2_ITEM||C2_SEQUEN=D3_OP
			_cQuery1 += " WHERE D3.D_E_L_E_T_=' ' AND D3_FILIAL='"+xFilial("SD3")+"' AND D3_FILIAL||D3_OP = (
			_cQuery1 += " SELECT DISTINCT D1_FILIAL||D1_OP
			_cQuery1 += " FROM "+RetSqlName("SD1")+" D1
			_cQuery1 += " WHERE D1.D_E_L_E_T_=' '
			_cQuery1 += " AND D1_FILIAL='"+xFilial("SD1")+"' AND D1_DOC='"+aCols[_nX][_nPosDoc]+"' AND
			_cQuery1 += " D1_SERIE='"+aCols[_nX][_nPosSer]+"' AND D1_FORNECE='"+aCols[_nX][_nPosFor]+"'
			_cQuery1 += " AND D1_LOJA='"+aCols[_nX][_nPosLoj]+"' AND D1_NUMCQ='"+aCols[_nX][_nPosNum]+"'
			_cQuery1 += " ) AND D3_CF='PR0'
			_cQuery1 += " AND C2.D_E_L_E_T_=' ' AND C2_QUANT-C2_QUJE<=0

			If !Empty(Select(_cAlias1))
				DbSelectArea(_cAlias1)
				(_cAlias1)->(dbCloseArea())
			Endif

			dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

			dbSelectArea(_cAlias1)
			(_cAlias1)->(dbGoTop())

			If (_cAlias1)->(!Eof())
				If STOD((_cAlias1)->D3_EMISSAO)<=aCols[_nX][_nPosDt]
					MsgAlert("Atenção, data digitada menor ou igual que a data de apontamento da OP ("+DTOC(STOD((_cAlias1)->D3_EMISSAO))+"), verifique!")
					_lRet := .F.
				EndIf
			EndIf

		Next

	EndIf

Return(_lRet)