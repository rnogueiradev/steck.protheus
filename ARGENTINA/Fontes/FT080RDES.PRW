#include 'Protheus.ch'
#include 'RwMake.ch'

/*====================================================================================\
|Programa  | FT080RDES        | Autor | GIOVANI.ZAGO             | Data | 28/01/2013  |
|=====================================================================================|
|Descrição |   P.E. FT080RDES Regra de desconto  	                                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | FT080RDES                                                                |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function FT080RDES( cProduto,cCliente,cLoja,cTabPreco,nFaixa,cCondPg,cFormPg,nTipo,aProds,aExc )
	*-----------------------------*
	Local nDesc     := 0
	Local aArea    	:= GetArea()
	Local _nPosDesc := aScan(aHeader,{|x| UPPER(ALLTRIM(X[2])) == IIf(IsInCallStack("MATA415"),"CK_DESCONT","C6_DESCONT") })

	If ( Type("l410Auto") == "U" .OR. !l410Auto ) 
		If paramixb[8] = 1
			If IsInCallStack("MATA415")
				nDesc := u_STGAP01(cProduto,cCliente,cLoja,cTabPreco,nFaixa,cCondPg,cFormPg,nTipo,aProds,aExc )  //Calculo generico
			Else
				If aCols[n][_nPosDesc]>0
					nDesc := aCols[n][_nPosDesc]
				Else
					nDesc := u_STGAP01(cProduto,cCliente,cLoja,cTabPreco,nFaixa,cCondPg,cFormPg,nTipo,aProds,aExc )  //Calculo generico
				EndIf
			EndIf
		EndIf
	Else 
		SB1->(DBSELECTAREA("SB1"))
		SB1->(DBSETORDER(1))
		SB1->(DBSEEK(XFILIAL("SB1")+paramixb[1]))
		SA1->(DBSELECTAREA("SA1"))
		SA1->(DBSETORDER(1))
		SA1->(DBSEEK(XFILIAL("SA1")+paramixb[2]+paramixb[3]))
		DA0->(DBSELECTAREA("DA0"))
		DA0->(DBSETORDER(1))
		DA0->(DBSEEK(XFILIAL("DA0")+paramixb[4]))
		//paramixb[8] := 1
		If paramixb[8] = 1
			If IsInCallStack("MATA415")
				nDesc := u_STGAP01(cProduto,cCliente,cLoja,cTabPreco,nFaixa,cCondPg,cFormPg,nTipo,aProds,aExc )  //Calculo generico
			Else
				If aCols[n][_nPosDesc]>0
					nDesc := aCols[n][_nPosDesc]
				Else
					nDesc := u_STGAP01(cProduto,cCliente,cLoja,cTabPreco,nFaixa,cCondPg,cFormPg,nTipo,aProds,aExc )  //Calculo generico
				EndIf
			EndIf
		EndIf	
	Endif
	RestArea( aArea ) 
Return (nDesc)
