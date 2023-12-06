#Include "Totvs.ch"

/*���������������������������������������������������������������������������
���Programa  �MT120OK	�Autor  �Renato Nogueira     � Data �  08/07/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �Fun��o utilizada segregar os acessos de inclus�o/altera��o  ���
���          �nos pedido de compras				    				      ���
�������������������������������������������������������������������������͹��
���Parametro � Nenhum                                                     ���
�������������������������������������������������������������������������ͼ��
���Retorno   � Nenhum                                                     ���
���������������������������������������������������������������������������*/

User Function MT120OK()

	Local _aArea		:= GetArea()
	Local _lRet			:= .F.
	Local _nGrpAprov	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C7_APROV"})
	//Local _nMotComp 	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C7_MOTIVO"})
	Local _nMotCC 		:= aScan(aHeader,{|x| AllTrim(x[2]) == "C7_CC"})
	Local _nX

	//	Adicionado para tratamento da Autoriza��o de Entrega - Eduardo Pereira 10/02/2021
	If IsInCallStack( "MATA122" )
		Return .T.
	EndIf

		//	Adicionado para tratamento da Medi��o de contrados - Leandro Godoy 01.04.2022
	If IsInCallStack( "CNTA121" )
		Return .T.
	EndIf	
	

	_lRet := U_STVLDPCS()

	If _lRet
		_lRet := U_STPCVLDTRANSFERPRICE()//Chamado 002767
	EndIf

	/*�����������������������������������������������������������������������ͼ��
	���Chamado   � 002612 - Automatizar Solicita��o de Compras                ���
	���Solic.    � Juliana Queiroz - Depto. Compras                           ���
	�������������������������������������������������������������������������ͼ*/

	// If Alltrim( FunName() ) <> 'U_STGerPC'
		If _lRet
			_lRet := U_STCOM027()
		EndIf
	// EndIf

	For _nX := 1 To Len(aCols)
		Do Case
			Case aCols[_nX][_nMotCC] $ "112104"
				aCols[_nX][_nGrpAprov] := "000006"
			Otherwise
				aCols[_nX][_nGrpAprov] := "000005"
		EndCase
	Next

	RestArea(_aArea)

Return _lRet
