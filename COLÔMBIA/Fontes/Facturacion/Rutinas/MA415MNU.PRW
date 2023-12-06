#INCLUDE "PROTHEUS.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMA415MNU  บAutor  ณRGV Solucoes        บ Data ณ  21/02/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
//------------------------------------------------------------------------------//
//Altera็๕es realizadas: 
//FR - #20211130025600 - Tela Markup para Col๔mbia
//     Adicionado no aRotina chamada para fun็ใo 'Tela MarkUp', 'U_COTMKSCK(.T.)
//-------------------------------------------------------------------------------//
User Function MA415MNU 
 
Local nPosCopia := 0

//IF Upper(Alltrim(cUserName)) $ Upper(Alltrim(getmv("ST_USOUNIC")))
	Aadd(aRotina,{"Carrega Estrutura"	,"U_STFTPE01()"  	, 0 , 4, 0,.F.}) 
	Aadd(aRotina,{"Pesquisa Estrutura"	,"U_STPESQESTRU()"  , 0 , 4, 0,.F.}) 	 
	Aadd(aRotina,{"Copia Orc. Unicom"	,"U_STFTPE02()"  	, 0 , 4, 0,.F.})
 // 	Aadd(aRotina,{"Supervisao Unicom"	,"U_STFTA003()"  	, 0 , 4, 0,.F.})
	Aadd(aRotina,{"Liberar P/ Vendas"	,"U_STFTA02B()"  	, 0 , 4, 0,.F.})
	Aadd(aRotina,{"Observacao"	 		,"U_STFTA004()"  	, 0 , 4, 0,.F.})
	Aadd(aRotina,{"Onde ้ Usado"		,"MATR400()"  		, 0 , 4, 0,.F.})
	Aadd(aRotina,{"Estruturas"		,"MATA200()"  		, 0 , 4, 0,.F.})	 
	aadd( aRotina, {"Importar CSV","U_FIMPCSVEXEC()",0,2,0,NIL} )	
//Endif	

Aadd(aRotina, {'Tela MarkUp', 'U_COTMKSCK(.T.)' , 0 , 2 , 0 , NIL })
   


Return                             

            
