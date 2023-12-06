#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "AP5MAIL.CH"

#DEFINE FRETE 04 // Valor total do Frete
#DEFINE CR chr(13)+chr(10)

/*====================================================================================\
|Programa  | MT140TOK        | Autor | RENATO.OLIVEIRA           | Data | 13/08/2018  |
|=====================================================================================|
|Descrição | VALIDAR INCLUSÃO DA PRE NOTA			                                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function MT140TOK()

	Local _lRet := .T.

	Local _nPosIpi		:= aScan(aHeader,{|x| AllTrim(x[2])=="D1_VALIPI"})
	Local _nPosIcms		:= aScan(aHeader,{|x| AllTrim(x[2])=="D1_VALICM"})
	Local _nPosAIpi		:= aScan(aHeader,{|x| AllTrim(x[2])=="D1_IPI"})
	Local _nPosAIcms	:= aScan(aHeader,{|x| AllTrim(x[2])=="D1_PICM"})
	Local _nPosItemP	:= aScan(aHeader,{|x| AllTrim(x[2])=="D1_ITEMPC"})
	Local _nPosItemN	:= aScan(aHeader,{|x| AllTrim(x[2])=="D1_ITEM"})
	Local _nPosQtde		:= aScan(aHeader,{|x| AllTrim(x[2])=="D1_QUANT"})
	Local _nPosPedC		:= aScan(aHeader,{|x| AllTrim(x[2])=="D1_PEDIDO"})
	Local _nPosPrec		:= aScan(aHeader,{|x| AllTrim(x[2])=="D1_VUNIT"})
	Local _nPosQtde		:= aScan(aHeader,{|x| AllTrim(x[2])=="D1_QUANT"})
	Local _nPosCod		:= aScan(aHeader,{|x| AllTrim(x[2])=="D1_COD"})
	Local _nFretPed		:= 0
	Local _nFretNf		:= 0
	Local _nTotIpi		:= 0
	Local _nTotIcms		:= 0
	Local nX			:= 0
	Local _cLog 		:= ""
	Local _cItem		:= "0000"

	
	  // Ponto de chamada ConexãoNF-e sempre como primeira instrução.
    _lRet := U_GTPE011()
	If _lRet .And. !FwIsInCallStack('U_GATI001') .Or. !l103Auto


	If !GetMv("ST_NFEXPC",,.F.)
		Return(.T.)
	EndIf

	DbSelectArea("SC7")
	SC7->(DbSetOrder(1))

	For nX:=1 to len(aCols)

		_cItem := Soma1(_cItem)

		If SC7->(DbSeek(xFilial("SC7")+aCols[nX][_nPosPedC]+aCols[nX][_nPosItemP]))

			_nFretPed += SC7->C7_VALFRE

			If !(SC7->C7_IPI==aCols[nX][_nPosAIpi])
				_cLog += "Item "+_cItem+" | IPI nota: "+CVALTOCHAR(aCols[nX][_nPosAIpi])+" | IPI pedido: "+CVALTOCHAR(SC7->C7_IPI)+CHR(13)+CHR(10)
			EndIf
			If !(SC7->C7_PICM==aCols[nX][_nPosAIcms])
				_cLog += "Item "+_cItem+" | ICMS nota: "+CVALTOCHAR(aCols[nX][_nPosAIcms])+" | ICMS pedido: "+CVALTOCHAR(SC7->C7_PICM)+CHR(13)+CHR(10)
			EndIf
			If !(SC7->C7_PRECO==aCols[nX][_nPosPrec])
				_cLog += "Item "+_cItem+" | Preço nota: "+CVALTOCHAR(aCols[nX][_nPosPrec])+" | Preço pedido: "+CVALTOCHAR(SC7->C7_PRECO)+CHR(13)+CHR(10)
			EndIf

			//Tolerância
			_nDifQtd := aCols[nX][_nPosQtde]-SC7->C7_QUANT
			_nDifQtd := Abs(_nDifQtd)
			_nDifQtd := _nDifQtd/SC7->C7_QUANT

			If _nDifQtd*100 > GetMv("ST_TOLENT",,10)
				_cLog += "Item "+_cItem+" | Qtde nota: "+CVALTOCHAR(aCols[nX][_nPosQtde])+" | Qtde pedido: "+CVALTOCHAR(SC7->C7_QUANT)+CHR(13)+CHR(10)
			EndIf

		EndIf

	Next

	If !(a140Desp[FRETE]==_nFretPed)
		_cLog += " Frete nota: "+CVALTOCHAR(a140Desp[FRETE])+" | Frete pedido: "+CVALTOCHAR(_nFretPed)+CHR(13)+CHR(10)
	EndIf

	If !Empty(_cLog)

		_lRet := .F.

		@ 000, 000 TO 230, 350 DIALOG oDlg TITLE 'Relatório de divergências'
		@ 005,005 Get _cLog Size 167,080 MEMO Object oMemo
		@ 92,135 BMPBUTTON TYPE 1 ACTION Close(oDlg)
		ACTIVATE DIALOG oDlg CENTERED

	EndIf
ENDIF

Return(_lRet)
