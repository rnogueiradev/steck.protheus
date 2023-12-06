#Include "Totvs.ch"

/*/{Protheus.doc} CH_PEDTES
@author Ihorran Milholi
@since 17/05/2021
@version 1.0
/*/

User Function CH_PEDTES(oPedido,aCabec,aItem)

Local nPosClient:= aScan(aCabec,{|x| Alltrim(x[1]) == "C5_CLIENTE"})
Local nPosLoja  := aScan(aCabec,{|x| Alltrim(x[1]) == "C5_LOJACLI"})
Local nPosTipo  := aScan(aCabec,{|x| Alltrim(x[1]) == "C5_TIPO"})
Local nPosProd  := aScan(aItem,{|x| Alltrim(x[1]) == "C6_PRODUTO"})
Local nPosOper  := aScan(aItem,{|x| Alltrim(x[1]) == "C6_OPER"})
Local nPosLocal	:= aScan(aItem,{|x| Alltrim(x[1]) == "C6_LOCAL"})
Local cTes      := ""
Local i

Private aHeader 	:= {}
Private aCols		:= {{}}
Private n			:= 1

aAdd(aHeader,{"","TES"})
aAdd(aHeader,{"","CFOP"})
aAdd(aHeader,{"","TPOPER"})
aAdd(aHeader,{"","C6_PRODUTO"})
aAdd(aHeader,{"","C6_LOCAL"})

aAdd(aCols[1],"")
aAdd(aCols[1],"")
aAdd(aCols[1],aItem[nPosOper][2])
aAdd(aCols[1],aItem[nPosProd][2])
aAdd(aCols[1],aItem[nPosLocal][2])

For i := 1 to Len(aCabec)
	M->&(AllTrim(aCabec[i][1])) := aCabec[i][2]
Next

If (aCabec[nPosTipo][2] == 'N')
	SA1->(dbSetOrder(1))
	If SA1->(dbSeek(xFilial("SA1")+aCabec[nPosClient][2]+aCabec[nPosLoja][2]))
		M->C5_TIPOCLI := SA1->A1_TIPO
		M->C5_ZCONSUM := ""
		//informacoes padrao
		If ("EBAZAR" $ Alltrim(SA1->A1_NOME))
			M->C5_ZCONSUM := "2"
		EndIf
	EndIf
EndIf

U_STTESINTELIGENTE()
cTes := aCols[1][1]

Return cTes
