#INCLUDE "RWMAKE.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � MATA200  � Autor � Fernando Joly/Eduardo � Data �19.05.1999���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Manuten��o na Estrutura dos produtos                       ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � Mata200(ExpA1,ExpA2,ExpN1)                                 ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpA1 = (ROT.AUT) Array do cabecalho dos campos            ���
���          � ExpA2 = (ROT.AUT) Array dos campos                         ���
���          � ExpN1 = (ROT.AUT) Numero da opcao selecionada              ���
�������������������������������������������������������������������������Ĵ��
*/
user function m200text()

Local _cArea := getarea()

_ctexto := paramixb[1]
_cpai:= paramixb[2]
_cTrt:= paramixb[3]
_cComp:= paramixb[4]
_nQuant:= paramixb[5]


Dbselectarea('SB1')
_cAreab1 := getarea()
Dbsetorder(1)
Dbseek(xfilial('SB1')+_cComp)

If alltrim(_cpai) <> alltrim(_ccomp)
	
	_cTexto := alltrim(_cTexto)+' '+sb1->b1_um
	
Endif

RestArea(_cAreab1)

RestArea(_cArea)

return _cTexto


 
