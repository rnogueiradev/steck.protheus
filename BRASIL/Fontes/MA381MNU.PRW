#INCLUDE "PROTHEUS.CH"
 
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA381MNU   �Autor  �Joao Rinaldi       � Data �  09/09/2015 ���
�������������������������������������������������������������������������͹��
���Desc.     �Este ponto de entrada tem por finalidade incluir novos      ���
���          �bot�es na rotina MATA381.PRX                                ���
�������������������������������������������������������������������������͹��
���Uso       � Steck Industria Eletrica Ltda.                             ���
�������������������������������������������������������������������������ͼ��
���Rotina    � MATA381.PRX                                                ���
���Nome      � Ajuste de Empenho Modelo 2                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MA381MNU()

	Local _cProgram := ALLTRIM(UPPER(funname()))
	Local _aInc     := {"Incluir"   ,"A381Manut"   ,0,3,0 ,nil}//"Incluir"
	Local _aAlt     := {"Alterar"   ,"A381Manut"   ,0,4,37,nil}//"Alterar"
	Local _aExc     := {"Excluir"   ,"A381Manut"   ,0,5,0 ,nil}//"Excluir"
	Local _aVis     := {"Visualizar","A381Manut"   ,0,2,0 ,nil}//"Visualizar"
	Local _aPesq    := {"Pesquisar" ,"AxPesqui"    ,0,1,0 ,.F.}//"Pesquisar"

	If !Empty(_cProgram)
		_cAlias    := 'ZZ3'
		aRotina    := U_STACESSOS(_cAlias,_cProgram,_aInc,_aAlt,_aExc,_aVis)

		aAdd(aRotina,_aPesq)
	Endif

Return(aRotina)