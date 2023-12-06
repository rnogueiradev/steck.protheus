#Include "Protheus.ch" 


/*�����������������������������������������������������������������������������
�����������������������������������������������������������������������������������
�������������������������������������������������������������������ͻ
�����Programa  �CTB102MB  �Autor  �Microsiga           � Data �  15/12/09   ������
����������������������������������������������������������������������͹�����
Desc.     � Exemplo de ponto de entrada a ser utilizado para filtro na ������       
   � tela
 principal dos lanc cont automaticos (mbrowse)         ���������������������������
 �����������
 ��������������������������������������͹�����Uso       � AP                                                        
����������������������������������������������������������������������������ͼ
����������������������������������
����������������������������������������������������������������������������������
�������������������������������
���������*/


User Function CTB102MB()

Local cFiltro   := ""



If cusername$GetMV("ST_APCTBN1")

 If Pergunte("XCTB102",.T.,"Aprova��o cont�bil")

     #IFDEF TOP	

      If MV_PAR03==1
       cFiltro := " CT2_FILIAL =='"+xFilial("CT2")+"' .AND. CT2_ROTINA=='CTBA102' .AND. CT2_TPSALD=='9' .And. CT2_DATA>='"+Dtos(mv_par01)+"' .And. CT2_DATA<='"+Dtos(mv_par02)+"'  "  
      ElseIf  MV_PAR03==2
       cFiltro := " CT2_FILIAL =='"+xFilial("CT2")+"' .AND. CT2_ROTINA=='CTBA102' .AND. CT2_TPSALD=='1' .And. CT2_DATA>='"+Dtos(mv_par01)+"' .And. CT2_DATA<='"+Dtos(mv_par02)+"'  "  
      Endif       
       //aqui usuario coloca a condicao desejada em sintaxe sql
     #ENDIF
 Endif

Endif

Return(cFiltro)
