#INCLUDE "PROTHEUS.CH" 
#INCLUDE "TOPCONN.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Ajustse   �Autor  �Ricardo Posman      � Data �  03/22/10   ���
�������������������������������������������������������������������������͹��
���Desc.     � Atualiza campo E2_Hist com dados do campo E2_RHMEMO        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function Ajustse()


Local aArea:=GetArea()


dbSelectArea( "SE2" )
dbSetOrder( 1 )

While !Eof()

    If !empty(E2_HMEMO)

       RecLock( "SE2" )
       SE2->E2_HIST := SE2->E2_HMEMO
      MsUnLock()
    EndIf
    dbSkip()

EndDo

RETURN()