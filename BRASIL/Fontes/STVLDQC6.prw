#Include "Protheus.ch"
#Include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STVLDQC6  ºAutor  ³Renato Nogueira     º Data ³  23/10/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função utilizada para validar quantidade disponível em     º±±
±±º          ³ estoque			                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STVLDQC6()

Local aArea     	:= GetArea()
Local aAreaSC5  	:= SC5->(GetArea())
Local aAreaSC6  	:= SC6->(GetArea())
Local cST_IBLTRAN	:= SuperGetMV("ST_IBLTRAN",,"")
Local _nPosItem     := aScan(aHeader, { |x| Alltrim(x[2]) == "C6_ITEM"    })
Local _nPosProd     := aScan(aHeader, { |x| Alltrim(x[2]) == "C6_PRODUTO" })
Local _nPosLoc      := aScan(aHeader, { |x| Alltrim(x[2]) == "C6_LOCAL"   })
Local _nPosQtdVen	:= aScan(aHeader, { |x| Alltrim(x[2]) == "C6_QTDVEN"  })
Local _nPosOper	    := aScan(aHeader, { |x| Alltrim(x[2]) == "C6_OPER"    })
Local _nVaPed       := 0
Local _cOper        := GetMv("ST_IBLTRAN",,'88,89,94')
Local _lRet			:= .T.
Local _nSaldoItem	:= 0

If Alltrim(aCols[n][5]) $ Alltrim(_cOper)
	
	_nSaldoItem	:=	u_versaldo(aCols[n,_nPosProd])
	
	If aCols[n,_nPosQtdVen] > _nSaldoItem .And. aCols[n,_nPosLoc] $ "01#03"
		
		_lRet	:= .F.
		MsgInfo('A quantidade digitada para o produto '+Alltrim(aCols[n][2])+' não está disponível. A quantidade disponível é: '+cvaltochar(_nSaldoItem))
		
	EndIf
	
EndIf

RestArea(aAreaSC5)
RestArea(aAreaSC6)
RestArea(aArea)

Return(_lRet)