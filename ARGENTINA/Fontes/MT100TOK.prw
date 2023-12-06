#Include "Rwmake.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT100TOK    ºAutor  ³Cristiano Pereira  º Data ³  10/16/18  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada no momento do OK da factura de entrada    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT100TOK()

Local _nPrdPos    := Ascan(aHeader, {|x| AllTrim(x[2]) == "D1_COD" } )
Local _nRatPos    := Ascan(aHeader, {|x| AllTrim(x[2]) == "D1_RATEIO" } )
Local _nCC    := Ascan(aHeader, {|x| AllTrim(x[2]) == "D1_CC" } )


Local _nlin
Local _lRet       :=.T.


For _nlin:=1 to len(aCols)
	
	DbSelectArea("SB1")
	DbSetOrder(1)
	If DbSeek(xFilial("SB1")+aCols[_nlin,_nPrdPos])
		
		If SB1->B1_X_RAT =="S"
			DbSelectArea("SDE")
			DbSetOrder(1)
			If aCols[_nlin,_nRatPos]<>'1'
				_lRet :=.F.
				MsgInfo("Seleccione el prorrateo preconfigurado.")
				Exit
			Endif
		Endif
	Endif
	
	
	If (SubStr(aCols[_nlin,_nPrdPos],1,4)=="SERV" .Or. SubStr(aCols[_nlin,_nPrdPos],1,1)=="E" .Or. SubStr(aCols[_nlin,_nPrdPos],1,1)=="U") .And. Empty(aCols[_nlin,_nCC]) .And. aCols[_nlin,_nRatPos]<>"1"
			_lRet :=.F.
			MsgInfo("Introduzca el centro de coste..")
			Exit
	Endif
	
	
Next _nlin



return _lRet
