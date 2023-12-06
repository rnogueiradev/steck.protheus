#INCLUDE 'PROTHEUS.CH'
#INCLUDE "TOPCONN.CH"

/*====================================================================================\
|Programa  | MA120BUT        | Autor | RENATO.OLIVEIRA           | Data | 26/07/2018  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function MA120BUT()

	Local aButtons := {}

	Aadd(aButtons,{'DESTINOS',{|| SETINFOS() },"Completar infos","Completar infos"})
	aAdd(aButtons,{"xPrc.Steck" ,{|| u_PrcTrans()}	,"Prc.Steck","Prc.Steck"})

Return(aButtons)

/*====================================================================================\
|Programa  | SETINFOS        | Autor | RENATO.OLIVEIRA           | Data | 26/07/2018  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

Static Function SETINFOS()

	Local _aParamBox 	:= {}
	Local _aRet 		:= {}
	Local _cData		:= CTOD("  /  /    ")
	Local _nX			:= 0
	Local _nPosDtEnt 	:= Ascan(aHeader,{|x| AllTrim(Upper(x[2]))	== "C7_DATPRF"})
	Local _nPosObs 		:= Ascan(aHeader,{|x| AllTrim(Upper(x[2]))	== "C7_OBS"})
	Local _nPosTes 		:= Ascan(aHeader,{|x| AllTrim(Upper(x[2]))	== "C7_TES"})

	AADD(_aParamBox,{1,"Fch Entrega",_cData		,"@D","","",".T.",100,.F.})
	AADD(_aParamBox,{1,"Observac."  ,Space(30)	,"","","",".T." ,100,.F.})
	AADD(_aParamBox,{1,"TES"  		,Space(3)	,"","","SF4",".T." ,100,.F.})

	If !ParamBox(_aParamBox,"Información",@_aRet,,,.T.,,500)
		Return
	EndIf

	For _nX:=1 To Len(aCols)
		aCols[_nX][_nPosDtEnt] 	:= MV_PAR01
		aCols[_nX][_nPosObs] 	:= MV_PAR02
		aCols[_nX][_nPosTes] 	:= MV_PAR03
	Next

Return()



User Function PrcTrans( )
	//Local nPosXPrc	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C7_XPRCORC"})
	Local nPosPrc	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C7_PRECO"})
	Local nPProduto := aScan(aHeader,{|x| AllTrim(x[2]) == "C7_PRODUTO"})
	Local nPQtd 	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C7_QUANT"})
	Local nPosNumSc := ASCAN(aHeader,{|x| AllTrim(x[2]) == "C7_NUMSC"})
	Local nPosItSc  := ASCAN(aHeader,{|x| AllTrim(x[2]) == "C7_ITEMSC"})
	Local _nPosTot	:= ASCAN(aHeader,{|x| AllTrim(x[2]) == "C7_TOTAL"})
	Local nX        := 0
	Local _cMsg     := ' '
	Local _nTot 	:= 0
	Public l120Auto := .t.
	
	Public Altera:= .t.
	If  INCLUI
		 _nOld :=n
		For nX := 1 To Len(aCols)
			If  !(aCols[nX][Len(aCols[nX])])
				DbSelectArea("DA1")
				DA1->(DbSetOrder(1))
				If DA1->(DbSeek(xFilial("DA1")+'T04'+aCols[nX][nPProduto]))
				n:= nx
					aCols[nX][nPosPrc] :=  DA1->DA1_PRCVEN
					//aCols[nX][nPosXPrc]:=  DA1->DA1_PRCVEN
					
					
					//MaFisAlt("IT_PRCUNI",DA1->DA1_PRCVEN,nX)
					MaFisRef("IT_PRCUNI","MT120",DA1->DA1_PRCVEN)
					aCols[nX][_nPosTot] := NoRound(	aCols[nX][nPosPrc]*	aCols[nX][nPQtd],TamSX3("C7_TOTAL")[2])
					_nTot+=	aCols[nX][_nPosTot]
				   MaFisRef("IT_VALMERC","MT120",	aCols[nX][_nPosTot])
					//MaFisAlt("IT_VALMERC",aCols[nX][_nPosTot],nX)
					//MTA121TROP(nX)
					A120Total(	aCols[nX][_nPosTot])
				Else
					_cMsg += "Produto Sem Preço de Transferencia: "+aCols[nX][nPProduto] + CR
				EndIf
			EndIf
		Next nX
		n:= _nOld
	EndIf
	Altera:= .f.
	If !(Empty(Alltrim(_cMsg)))
		msginfo(_cMsg)
	EndIf
Return()	