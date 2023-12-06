#Include "Protheus.ch"
/*/{Protheus.doc} MA123BUT
Coloca Dolar en la Purchase Order de Imprtacion a la fecha de la digitación 
@type function
@version 
@author Axel Diaz
@since 10/8/2020
@return return_type, return_description
/*/
User Function MA123BUT
	If UPPER(Funname()) == "MATA123"
		If Inclui
			nMoedaPed     := 2	//Dolar
			cDescMoed     := SuperGetMv("MV_MOEDA"+AllTrim(Str(nMoedaPed,2)))
			nTXMoeda      := POSICIONE("SM2",1,dDatabase,"M2_MOEDA2") // 	SM2->M2_MOEDA2
		Endif
	Endif
Return Nil
