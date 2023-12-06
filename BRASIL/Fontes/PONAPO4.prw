#INCLUDE "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � PONAPO4  �Autor  � Adilson Silva      � Data � 15/04/2010  ���
�������������������������������������������������������������������������͹��
���Desc.     � Alterar os Apontamentos de Faltas e Atrasos Conforme a     ���
���          � Regra dos Estagiarios.                                     ���
�������������������������������������������������������������������������͹��
���Uso       � MP10                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function PONAPO4()

 Local cFilSp9 := xFilial( "SP9" )
 Local aOldAtu
 Local aOldSp9
 Local nX
 
 If SRA->RA_CATFUNC $ "EG" .And. Len( aEventos ) > 0

    aOldAtu := GETAREA()
    aOldSp9 := SP9->(GETAREA())

    SP9->(dbSetOrder( 1 ))
 
    For nX := 1 To Len( aEventos )
        If SP9->(dbSeek( cFilSp9 + aEventos[nX,2] ))
           If !Empty( SP9->P9_PDESTAG )
              aEventos[nX,2] := SP9->P9_PDESTAG
           EndIf
        EndIf
    Next nX
  
    RESTAREA( aOldSp9 )
    RESTAREA( aOldAtu )

 EndIf

Return
