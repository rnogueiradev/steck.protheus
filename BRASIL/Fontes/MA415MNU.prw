#INCLUDE "PROTHEUS.CH"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA415MNU  �Autor  �RGV Solucoes        � Data �  21/02/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MA415MNU 
 
Local nPosCopia := 0

//IF Upper(Alltrim(cUserName)) $ Upper(Alltrim(getmv("ST_USOUNIC")))
	Aadd(aRotina,{"Carrega Estrutura"	,"U_STFTPE01()"  	, 0 , 4, 0,.F.}) 
	Aadd(aRotina,{"Pesquisa Estrutura"	,"U_STPESQESTRU()"  , 0 , 4, 0,.F.}) 	 
	Aadd(aRotina,{"Copia Orc. Unicom"	,"U_STFTPE02()"  	, 0 , 4, 0,.F.})
 // 	Aadd(aRotina,{"Supervisao Unicom"	,"U_STFTA003()"  	, 0 , 4, 0,.F.})
	Aadd(aRotina,{"Liberar P/ Vendas"	,"U_STFTA02B()"  	, 0 , 4, 0,.F.})
	Aadd(aRotina,{"Observacao"	 		,"U_STFTA004()"  	, 0 , 4, 0,.F.})
	Aadd(aRotina,{"Onde � Usado"		,"MATR400()"  		, 0 , 4, 0,.F.})
	Aadd(aRotina,{"Estruturas"		,"MATA200()"  		, 0 , 4, 0,.F.})	 
//Endif	                                                        
   


Return                             

            
