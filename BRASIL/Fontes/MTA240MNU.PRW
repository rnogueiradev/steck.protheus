#INCLUDE "PROTHEUS.CH"
 
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MTA240MNU  �Autor  �Joao Rinaldi       � Data �  09/09/2015 ���
�������������������������������������������������������������������������͹��
���Desc.     �Este ponto de entrada tem por finalidade incluir novos      ���
���          �bot�es na rotina MATA240.PRX                                ���
�������������������������������������������������������������������������͹��
���Uso       � Steck Industria Eletrica Ltda.                             ���
�������������������������������������������������������������������������ͼ��
���Rotina    � MATA240.PRX                                               ���
���Nome      � Movimentos Internos                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MTA240MNU()

	Local _cProgram := ALLTRIM(UPPER(funname()))
	Local _aInc     := {"Incluir"   ,"A240Inclui"  , 0 , 3,0,Nil}//"Incluir"
	Local _aAlt     := {}
	Local _aExc     := {"Estornar"  ,"A240Estorn"  , 0 , 5,0,Nil}//"Estornar"
	Local _aVis     := {"Visualizar","A240Visual"  , 0 , 2,0,Nil}//"Visualizar"
	Local _aPesq    := {"Pesquisar" ,"AxPesqui"    , 0 , 1,0,.F.}//"Pesquisar"
	Local _aLeg     := {"Legenda"   ,"A240Legenda" , 0 , 2,0,.F.}//"Legenda"


	If !Empty(_cProgram)
		_cAlias    := 'ZZ3'
		aRotina    := U_STACESSOS(_cAlias,_cProgram,_aInc,_aAlt,_aExc,_aVis)

		aAdd(aRotina,_aPesq)
		aAdd(aRotina,_aLeg)
	Endif

Return(aRotina)