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
	
	If ( Type("l410Auto") == "U" .OR. !l410Auto )
		If paramixb[8] = 1
			nDesc := u_STGAP01(cProduto,cCliente,cLoja,cTabPreco,nFaixa,cCondPg,cFormPg,nTipo,aProds,aExc )  //Calculo generico
		EndIf
	EndIf
	RestArea( aArea )
Return (nDesc)
