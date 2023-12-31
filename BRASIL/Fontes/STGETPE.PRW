#include 'Protheus.ch'
#include 'RwMake.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �STGETPE	�Autor  �Renato Nogueira     � Data �  04/05/15  ���
�������������������������������������������������������������������������͹��
���Desc.     �Retornar lead time	 										   	���
��																					���	    					    		   	 				        
�������������������������������������������������������������������������͹��
���Parametro � Nenhum                                                     ���
�������������������������������������������������������������������������ͼ��
���Retorno   � Nenhum                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function STGETPE()

	Local _nLt		:= 0
	
	DbSelectArea("SBM")
	SBM->(DbSetOrder(1))
	SBM->(DbGoTop())
	SBM->(DbSeek(xFilial("SBM")+M->B1_GRUPO))

	Do Case
	Case AllTrim(M->B1_CLAPROD)=="I" //Importado
		If AllTrim(M->B1_XFMR)=="F"
			_nLt	:= SBM->BM_XDAYIF
		ElseIf AllTrim(M->B1_XFMR)=="M"
			_nLt	:= SBM->BM_XDAYIM
		ElseIf AllTrim(M->B1_XFMR)=="R"
			_nLt	:= SBM->BM_XDAYIR
		ElseIf AllTrim(M->B1_XFMR)=="RR"
			_nLt	:= SBM->BM_XDAYIRR
		ElseIf AllTrim(M->B1_XFMR)=="O"
			_nLt	:= SBM->BM_XDAYIO
		ElseIf AllTrim(M->B1_XFMR)=="X"
			_nLt	:= SBM->BM_XDAYIX
		ElseIf AllTrim(M->B1_XFMR)=="N"
			_nLt	:= SBM->BM_XDAYIN
		EndIf
	Case cEmpAnt = "01" .And. AllTrim(M->B1_CLAPROD)=="F" .Or. AllTrim(STCLAAM(M->B1_COD))=="F" //Fabricado
		If AllTrim(M->B1_XFMR)=="F"
			_nLt	:= SBM->BM_XDAYFF
		ElseIf AllTrim(M->B1_XFMR)=="M"
			_nLt	:= SBM->BM_XDAYFM
		ElseIf AllTrim(M->B1_XFMR)=="R"
			_nLt	:= SBM->BM_XDAYFR
		ElseIf AllTrim(M->B1_XFMR)=="RR"
			_nLt	:= SBM->BM_XDAYFRR
		ElseIf AllTrim(M->B1_XFMR)=="O"
			_nLt	:= SBM->BM_XDAYFO
		ElseIf AllTrim(M->B1_XFMR)=="X"
			_nLt	:= SBM->BM_XDAYFX
		ElseIf AllTrim(M->B1_XFMR)=="N"
			_nLt	:= SBM->BM_XDAYFN
		EndIf
	Case cEmpAnt = "01" .And. AllTrim(M->B1_CLAPROD)=="C" .And. !(AllTrim(STCLAAM(M->B1_COD))=="F") //Comprado
		If AllTrim(M->B1_XFMR)=="F"
			_nLt	:= SBM->BM_XDAYCF
		ElseIf AllTrim(M->B1_XFMR)=="M"
			_nLt	:= SBM->BM_XDAYCM
		ElseIf AllTrim(M->B1_XFMR)=="R"
			_nLt	:= SBM->BM_XDAYCR
		ElseIf AllTrim(M->B1_XFMR)=="RR"
			_nLt	:= SBM->BM_XDAYCRR
		ElseIf AllTrim(M->B1_XFMR)=="O"
			_nLt	:= SBM->BM_XDAYCO
		ElseIf AllTrim(M->B1_XFMR)=="X"
			_nLt	:= SBM->BM_XDAYCX
		ElseIf AllTrim(M->B1_XFMR)=="N"
			_nLt	:= SBM->BM_XDAYCN
		EndIf
	EndCase

Return(_nLt)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �STCLAAM	�Autor  �Renato Nogueira     � Data �  18/03/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Fonte utilizado para verificar classifica��o do produto em  ���
���          �Manaus								 				      ���
�������������������������������������������������������������������������͹��
���Parametro � C�digo do produto                                          ���
�������������������������������������������������������������������������ͼ��
���Retorno   � Classifica��o em Manaus                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function STCLAAM(_cCod)

	Local _cBkpEmp	:= cEmpAnt
	Local _cClaProd	:= ""
	Local _aAreaSB1	:= SB1->(GetArea())
	
	cEmpAnt	:= "03"
	
	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))
	SB1->(DbGoTop())
	If SB1->(DbSeek(xFilial("SB1")+_cCod))
		_cClaProd	:= SB1->B1_CLAPROD
	EndIf
		
	cEmpAnt	:= _cBkpEmp
	
	RestArea(_aAreaSB1)

Return(_cClaProd)