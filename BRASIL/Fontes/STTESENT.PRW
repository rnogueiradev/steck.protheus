#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT100CLA	ºAutor  ³Renato Nogueira     º Data ³  15/08/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada na chamada da classificação da nota		  º±±
±±º          ³	    							 	 				      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRetorno   ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STTESENT()

	Local _aArea		:= GetArea()
	Local _nPosTes		:= aScan(aHeader,{|x| Trim(x[2])=="D1_TES"})
	Local _nPosxOper	:= aScan(aHeader,{|x| Trim(x[2])=="D1_XOPER"})
	Local _nPosOper		:= aScan(aHeader,{|x| Trim(x[2])=="D1_OPER"})
	Local _nPosProd		:= aScan(aHeader,{|x| Trim(x[2])=="D1_COD"})
	Local _nPosCf		:= aScan(aHeader,{|x| Trim(x[2])=="D1_CF"})
	Local _nPosLoja		:= aScan(aHeader,{|x| Trim(x[2])=="D1_LOJA"})
	Local _nX			:= 0
	Local _nOld			:= 0

	_nOld	:= n

	If ( Type("l103Auto") == "U" .OR. !l103Auto )
	
		For _nX:=1 To Len(aCols)
	
			n	:= _nX
		
			aCols[_nX][_nPosxOper]	:= "01"
			aCols[_nX][_nPosOper]	:= "01"
		//aCols[_nX][_nPosTes]  	:= MaTesInt(1,"01",cA100For,cLoja,If(cTipo$"DB","C","F"),aCols[_nX][_nPosProd])
		
			DbSelectArea("SFM")
			SFM->(DbSetOrder(2))
			SFM->(DbGoTop())
			If SFM->(DbSeek(xFilial("SFM")+"01"+Space(8)+cA100For+aCols[_nX][_nPosLoja]+Space(3)+aCols[_nX][_nPosProd]))
				aCols[_nX][_nPosTes]	:= SFM->FM_TE
			EndIf
		
		//aCols[_nX][_nPosTes]  	:= MaTesInt(1,"01",cA100For,"01",If(cTipo$"DB","C","F"),aCols[_nX][_nPosProd]) //Chamado 002313 - Pegar sempre loja 01 para não ter que cadastrar novamente - Solicitado por Edvaldo Ferreira
		
			DbSelectArea("SF4")
			SF4->(DbSetOrder(1))
			SF4->(DbGoTop())
			SF4->(DbSeek(xFilial("SF4")+aCols[_nX][_nPosTes]))
		
			aCols[_nX][_nPosCf]   := SF4->F4_CF
				
			If MaFisFound("IT",_nX)
				MaFisAlt("IT_TES",aCols[_nX][_nPosTes],_nX)
				MaFisRef("IT_TES","MT100",aCols[_nX][_nPosTes])
				RunTrigger(2,_nX,Nil,,"M->D1_OPER")
			//oGetDados:oBrowse:Refresh()
			EndIf
		
		Next
	
	EndIf

	n	:= _nOld

	RestArea(_aArea)

Return(.T.)
