#INCLUDE "PROTHEUS.CH"
 
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �STACESSOS  �Autor  �Joao Rinaldi       � Data �  09/09/2015 ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o para liberar as op��es de acesso de Inclus�o,       ���
���          � Altera��o, Exclus�o e Visualiza��o por Grupo de Usu�rio    ���
���          � onde o programa STACESSOS � chamado pelo Menu de Acesso do ���
���          � Programa acessado pelo usu�rio                             ���
�������������������������������������������������������������������������͹��
���Uso       � Steck Industria Eletrica Ltda.                             ���
�������������������������������������������������������������������������ͼ��
���_cAlias   � Tabela ZZ3 - Acessos X Botoes Rotinas                      ���
���_cProgram � Nome do Programa acessado pelo usu�rio                     ���
���_aInc     � Array contendo o bot�o de Inclus�o                         ���
���_aAlt     � Array contendo o bot�o de Altera��o                        ���
���_aExc     � Array contendo o bot�o de Exclus�o                         ���
���_aVis     � Array contendo o bot�o de Visualiza��o                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function STACESSOS(_cAlias,_cProgram,_aInc,_aAlt,_aExc,_aVis)

	Local _aGrupos  := {}
	Local _cGrupo   := ''
	

	PswOrder(1)
	If PswSeek(__cUserId,.T.)
		_aGrupos   := PswRet()
		_cGrupo    := _aGrupos[1][10][1]
	EndIf

	Dbselectarea(_cAlias)
	(_cAlias)->(DbSetOrder(1))//ZZ3_FILIAL+ZZ3_PROGRA
	(_cAlias)->(DbGoTop())
	If DbSeek(xFilial(_cAlias)+_cProgram)
		If (_cProgram) = Alltrim(UPPER((_cAlias)->ZZ3_PROGRA))
		
			aRotina := {}
			
			If  _cGrupo $ Alltrim((_cAlias)->ZZ3_GRPINC)
				If len(_aInc) >= 4 .And. Findfunction(_aInc[2])
					aAdd(aRotina,_aInc)
				Endif
			Endif
			
			If  _cGrupo $ Alltrim((_cAlias)->ZZ3_GRPALT)
				If len(_aAlt) >= 4 .And. Findfunction(_aAlt[2])
					aAdd(aRotina,_aAlt)
				Endif
			Endif
			
			If  _cGrupo $ Alltrim((_cAlias)->ZZ3_GRPEXC)
				If len(_aExc) >= 4 .And. Findfunction(_aExc[2])
					aAdd(aRotina,_aExc)
				Endif
			Endif
			
			If  _cGrupo $ Alltrim((_cAlias)->ZZ3_GRPVIS)
				If len(_aVis) >= 4 .And. Findfunction(_aVis[2])
					aAdd(aRotina,_aVis)
				Endif
			Endif
			
		Endif
	Endif
	(_cAlias)->(dbCloseArea())

Return (aRotina)
