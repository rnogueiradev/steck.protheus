#include 'Protheus.ch'
#include 'RwMake.ch'
 
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � A260LOC  � Autor � Everaldo Gallo-RVG    � Data �29.07.2016���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Ponto de entrada que verifica se existe saldo do SB2 e se  ���
���          � nao houver cria com saldo 0                                ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � A260LOC (Expc1,Expc2,ExpN1)                                ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 = Produto                                            ���
���          � Expc2 = Armazem                                            ���
���          � Expn1 = Tipo 1=Saida e 2=Entrada                           ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
 
User Function A260LOC

Local __aArea	 := GetArea()
Local __aAreaSB2 := SB2->(GetArea())
Local __cProduto := Alltrim(PARAMIXB[1])                                   
Local __cLocal   := Alltrim(PARAMIXB[2])                                    
Local __nTipo    := PARAMIXB[3]                                    

dbSelectArea("SB2")
SB2->(Dbsetorder(1))
If !SB2->(dbSeek(xFilial("SB2")+ Alltrim(__cProduto) + Alltrim(__cLocal))) .And. !(Empty(Alltrim(__cLocal))) //giovani zago 01/06/2017 ta criando sb2 sem local
	CriaSB2(Alltrim(__cProduto),Alltrim(__cLocal))
EndIf
 
SB2->(RestArea(__aAreaSB2)) 
RestArea(__aArea) 

Return 