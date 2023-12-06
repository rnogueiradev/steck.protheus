#Include "Protheus.ch"


/*�����������������������������������������������������������������������������
�����������������������������������������������������������������������������������
�������������������������������������������������������������������ͻ
�����Programa  �CT105TOK �Autor  �Microsiga           � Data �  15/12/09   ������
����������������������������������������������������������������������͹�����
Desc.     � Valida��o do TOK, na grava��o dos lan�amentos cont�beis     ������       
   � tela
 principal dos lanc cont automaticos (mbrowse)         ���������������������������
 �����������
 ��������������������������������������͹�����Uso       � AP                                                        
����������������������������������������������������������������������������ͼ
����������������������������������
����������������������������������������������������������������������������������
�������������������������������
���������*/


User Function CT105CHK()

Local _lRet  := .t.


DbSelectArea("TMP")
DbGotop()

While !TMP->(EOF())
    
   If Empty(TMP->CT2_XCLASS) .And. TMP->CT2_ORIGEM=="CTBA102"
        _lRet := .F.
        MsgInfo("Por favor, informar a classifica��o do lan�amento.!!","Aten��o")    
        Exit 
   Endif

   DbSelectArea("TMP")
   DbSkip()
Enddo


If FunName()<>"CTBA102"
_lRet  := .t.
Endif

Return(_lRet)
