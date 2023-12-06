#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} GT1ITEM
// Ponto de entrada do Importador XML para carregar campos para o Documento de Entrada.
@author ConexãoNF-e
@since 19/05/2022
@version undefined

@type function
/*/
User Function GT1ITEM()
Local aParam  := PARAMIXB
Local aAdItem := {}
Local _nPosDesc := aScan(aHeader, {|x| AllTrim(x[2]) == _cCmp2 + "_DESC"})
Local _nPosUM := aScan(aHeader, {|x| AllTrim(x[2]) == _cCmp2 + "_UMF"})
Local _nPosQtde := aScan(aHeader, {|x| AllTrim(x[2]) == _cCmp2 + "_QUANT1"})

	If _nPosDesc > 0
		aAdd(aAdItem, {"D1_XDESC2" , SubStr(aParam[_nPosDesc], TamSX3("A5_CODPRF")[1] + 3), Nil}) // Descrição
	EndIf

	If _nPosUM > 0
		aAdd(aAdItem, {"D1_XUM" , aParam[_nPosUM], Nil}) // UM
	EndIf

	If _nPosQtde > 0
		aAdd(aAdItem, {"D1_XQTDE" , aParam[_nPosQtde], Nil}) // Quantidade
	EndIf

Return(aAdItem)
