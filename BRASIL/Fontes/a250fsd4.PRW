#include "rwmake.ch"
#include "topconn.ch"
#include "COLORS.CH"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �a250fsd4  � Autor � RVG Solucoes - ESG � Data �  02/10/13   ���
�������������������������������������������������������������������������͹��
���Descricao � ajuste automatico dos empenhos via producao com Benef      ���
���          � externo                                                    ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico STECK                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function a250fsd4()
Local _lRet			:= .t.
Local _lMsg			:= .t.
Local _cString		:= ""
Local _cMensagem	:= ""
Local _cOper		:= ""
Local _cQuery		:= ""
 
//����������������������������������������Ŀ
//�Verifica o Somatorio ds Baixas Parciais �
//������������������������������������������
_cQuery	:= "SELECT SUM(D3_QUANT) QUANT FROM "+RetSqlName("SD3")+" WHERE D_E_L_E_T_ = ' ' AND D3_OP = '"+SD4->D4_OP+"' AND D3_ESTORNO = ' ' AND D3_CF = 'RE5' AND D3_COD = '"+SD4->D4_COD+"'  "
TCQUERY _cQuery NEW ALIAS "TRB"
TcSetField("TRB","QUANT","N",17,2)
TRB->(dbGotop())
_nTotal :=   TRB->QUANT
TRB->(DbCloseArea())
 
if _nTotal > 0
	
	_lret := .f.
	
else
	_lret := .t.
	
Endif

Return(_lRet)
