#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STCOM02A	ºAutor  ³Renato Nogueira     º Data ³  07/11/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Fonte utilizado para verificar a tolerância da entrada da	  º±±
±±º          ³nota em relação aos pedidos de compra   				      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³ 		                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRetorno   ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STCOM02A()

	Local _aArea 		:= GetArea()
	Local _aAreaSD1		:= SD1->(GetArea())
	Local _aAreaSF1		:= SF1->(GetArea())
	Local _aAreaSC7		:= SC7->(GetArea())
	Local _lRet			:= .T.
	Local _cQuery 		:= ""
	Local _cAlias 		:= "QRYTEMP"
	Local _nX			:= 0
	Local _lValida		:= .T.
	Local _nPosCfop		:= aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D1_CF"})
	Local _nPosCod		:= aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D1_COD"})
	Local _nPosQtd		:= aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D1_QUANT"})

	If IsInCallStack("MATA920")
		Return(.T.)
	EndIf

	For _nX:=1 To Len(aCols)
		If AllTrim(aCols[_nX][_nPosCfop]) $ GetMv("ST_CFOPTST")
			_lValida	:= .F.
		EndIf
	Next

	_cLog:= "RELATÓRIO DE PRODUTOS COM TOLERÂNCIA ACIMA DO PERMITIDO "+CHR(13)+CHR(10)

	If AllTrim(CA100FOR)=="005866" .And. AllTrim(CTIPO)=="N" .And. cEmpAnt == "01" .And. _lValida //Notas vindas da Steck Manaus
	
		For _nX:=1 To Len(aCols)
		
			_cQuery	:= " SELECT C7_FILIAL, C7_PRODUTO, SUM(C7_QUANT-C7_QUJE) AS SALDO "
			_cQuery += " FROM "+RetSqlName("SC7")+" C7 "
			_cQuery += " WHERE C7.D_E_L_E_T_=' ' AND C7_QUANT-C7_QUJE>0 AND C7_FORNECE='"+CA100FOR+"' "
			_cQuery += " AND C7_LOJA='"+CLOJA+"' AND C7_PRODUTO='"+aCols[_nX][_nPosCod]+"' AND C7_FILIAL='"+cFilAnt+"' AND C7_RESIDUO=' ' "
			_cQuery += " GROUP BY C7_FILIAL, C7_PRODUTO "
		
			If !Empty(Select(_cAlias))
				DbSelectArea(_cAlias)
				(_cAlias)->(dbCloseArea())
			Endif
		
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.T.,.T.)
		
			dbSelectArea(_cAlias)
			(_cAlias)->(dbGoTop())
		
			If (_cAlias)->(!Eof())
			
				If (_cAlias)->SALDO<aCols[_nX][_nPosQtd]
				
					_lRet	:= .F.
					_cLog	+= "Código: "+AllTrim(aCols[_nX][_nPosCod])+" Qtd NF: "+;
						CVALTOCHAR(aCols[_nX][_nPosQtd])+" Saldo PC: "+CVALTOCHAR((_cAlias)->SALDO)+CHR(13)+CHR(10)
				
				EndIf
			
			Else
			
				_lRet	:= .F.
				_cLog	+= "Código: "+AllTrim(aCols[_nX][_nPosCod])+" Qtd NF: "+;
					CVALTOCHAR(aCols[_nX][_nPosQtd])+" Saldo PC: 0 "+CHR(13)+CHR(10)
			
			EndIf
		
		Next
	
	EndIf

	If !_lRet
	
		@ 000, 000 TO 230, 350 DIALOG oDlg TITLE 'Relatorio de Inconsistencias '
		@ 005,005 Get _clOG Size 167,080 MEMO Object oMemo
		@ 92,135 BMPBUTTON TYPE 1 ACTION Close(oDlg)
		ACTIVATE DIALOG oDlg CENTERED
	
	EndIf

	RestArea(_aAreaSC7)
	RestArea(_aAreaSF1)
	RestArea(_aAreaSD1)
	RestArea(_aArea)

Return(_lRet)
