#include 'Protheus.ch'
#include 'FWMVCDEF.ch'
#Define CR chr(13)+chr(10)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FT080MNU �Autor  �Renato Nogueira      � Data �  13/07/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada para retirar op��es do menu de regra de    ���
���          �desconto                                                    ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function FT080MNU()
	Local _cUser := GetMv("ST_FATA080",,"000000/000645/000231")
	
	aRotina	:= {}
	If __cuserid $ _cUser
		
		aRotina := {	{ "Pesquisar","AxPesqui"		,0,1,0,.F.},;	// "Pesquisar"
		{ "Visualizar","Ft080RDes"	,0,2,0,NIL},;	// "Visualizar"
		{ "Incluir",""		,0,3,0,NIL},;			// "Incluir"
		{ "Alterar","Ft080RDes"		,0,4,0,NIL},;	// "Alterar"
		{ "Excluir","Ft080RDes"		,0,5,0,NIL},;	// "Excluir"
		{ "Copiar","Ft080Copia"		,0,6,0,NIL}}	// "Copiar"
		
	Else
		aAdd(aRotina,{"Pesquisa"  	, "AxPesqui"    , 0 , 1, 0, .F.})
		aAdd(aRotina,{"Visualizar"  , "Ft080RDes"   , 0 , 2, 0,    })
	EndIf
Return()


