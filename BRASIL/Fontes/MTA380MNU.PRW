#INCLUDE "PROTHEUS.CH"
 
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MTA380MNU  �Autor  �Joao Rinaldi       � Data �  09/09/2015 ���
�������������������������������������������������������������������������͹��
���Desc.     �Este ponto de entrada tem por finalidade incluir novos      ���
���          �bot�es na rotina MATA380.PRX                                ���
�������������������������������������������������������������������������͹��
���Uso       � Steck Industria Eletrica Ltda.                             ���
�������������������������������������������������������������������������ͼ��
���Rotina    � MATA380.PRX                                                ���
���Nome      � Ajuste de Empenho Modelo 1                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MTA380MNU()

	Local _cProgram := ALLTRIM(UPPER(funname()))
	Local _aInc     := {"Incluir"   ,"A380Inclui"   , 0 , 3,0 ,nil}//"Incluir"
	Local _aAlt     := {"Alterar"   ,"A380Altera"   , 0 , 4,37,nil}//"Alterar"
	Local _aExc     := {"Excluir"   ,"A380Exclui"   , 0 , 5,0 ,nil}//"Excluir"
	Local _aVis     := {"Visualizar","A380Visual"   , 0 , 2,0 ,nil}//"Visualizar"
	Local _aPesq    := {"Pesquisar" ,"AxPesqui"     , 0 , 1,0 ,.F.}//"Pesquisar"

	If !Empty(_cProgram)
		_cAlias    := 'ZZ3'
		aRotina    := U_STACESSOS(_cAlias,_cProgram,_aInc,_aAlt,_aExc,_aVis)

		aAdd(aRotina,_aPesq)
	Endif

Return(aRotina)