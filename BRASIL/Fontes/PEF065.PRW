#INCLUDE "TOTVS.CH"
#INCLUDE "RWMAKE.CH"

/*/{Protheus.doc} PEF065
@name PEF065
@type User Function
@desc portal do fornecedor - alterar campos dos itens
@author Renato Nogueira
@since 29/05/2018
/*/

User Function PEF065()

	Local cParam  := PARAMIXB[1]
	Local aReturn := {}

	Do Case
		Case cParam == 1 // Cabecalho

		aAdd(aReturn,"C8_TPFRETE")
		aAdd(aReturn,"C8_COND")
		aAdd(aReturn,"C8_VALIDA")
		aAdd(aReturn,"C8_XNOMENT")
		aAdd(aReturn,"C8_XENDENT")
		aAdd(aReturn,"C8_XCIDENT")
		aAdd(aReturn,"C8_XCEPENT")
		aAdd(aReturn,"C8_XCGCFOR")
		aAdd(aReturn,"C8_XNOMFOR")
		aAdd(aReturn,"C8_XENDFOR")

		Case cParam == 2 //Itens

		aAdd( aReturn, { "PROPOSALID",			"N", 0, .F. } )
		aAdd( aReturn, { "SEQUENTIALID",		"N", 0, .F. } )
		aAdd( aReturn, { "PRODUCTCODE",			"N", 0, .F. } )
		aAdd( aReturn, { "DESCRIPTIONPRODUCT",	"N", 0, .F. } )
		aAdd( aReturn, { "MEASUREUNIT",			"N", 2, .F. } )
		aAdd( aReturn, { "QUANTITY",			"N", 3, .F. } )
		aAdd( aReturn, { "UNITPRICE",			"N", 9, .T. } )
		aAdd( aReturn, "C8_SEGUM" )
		aAdd( aReturn, "C8_QTSEGUM")
		aAdd( aReturn, "C8_XVL2UM")
		aAdd( aReturn, "C8_XTAXA")
		aAdd( aReturn, { "TOTALVALUE",			"N", 2, .F. } )
		aAdd( aReturn, { "TAXRATE",				"N", 5, .T. } )
		aAdd( aReturn, { "DISCOUNTPERCENT",		"N", 3, .T. } )
		aAdd( aReturn, "C8_XDESENH")
		aAdd(aReturn,  "C8_PICM")
		aAdd(aReturn,  "C8_PRAZO")
		aAdd(aReturn,  "C8_VALFRE")

	EndCase

Return(aReturn)

/*/{Protheus.doc} WsUsrField
@name WsUsrField
@type User Function
@desc portal do fornecedor - alterar campos dos itens
@author Renato Nogueira
@since 29/05/2018
/*/

User Function WsUsrField()

	Local cAlias := PARAMIXB[1]
	Local aReturn := {}

	Do Case
		Case cAlias == "SC8"
		
		//Cabeçalho
		aAdd(aReturn,"C8_TPFRETE")
		aAdd(aReturn,"C8_COND")
		aAdd(aReturn,"C8_VALIDA")
		aAdd(aReturn,"C8_XNOMENT")
		aAdd(aReturn,"C8_XENDENT")
		aAdd(aReturn,"C8_XCIDENT")
		aAdd(aReturn,"C8_XCEPENT")
		aAdd(aReturn,"C8_XCGCFOR")
		aAdd(aReturn,"C8_XNOMFOR")
		aAdd(aReturn,"C8_XENDFOR")

		//Itens
		aAdd(aReturn,"C8_XDESENH")
		aAdd(aReturn,"C8_NUMPED")
		aAdd(aReturn,"C8_XVL2UM")
		aAdd(aReturn,"C8_XTAXA")
		aAdd(aReturn,"C8_SEGUM")
		aAdd(aReturn,"C8_QTSEGUM")
		aAdd(aReturn,"C8_PICM")
		aAdd(aReturn,"C8_PRAZO")
		aAdd(aReturn,"C8_VALFRE")

		Case cAlias == "SC7"
		aAdd(aReturn,"C7_XDATPRF")
		aAdd(aReturn,"C7_TPFRETE")
	EndCase

Return(aReturn)