#Include "Rwmake.ch"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FA200SEB     �Autor  �Cristiano Pereira� Data �  03/07/19   ���
�������������������������������������������������������������������������͹��
���Desc.     �Tratamentos para gerar as ocorr�ncias no t�tulos            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/                                                  
User Function FA200SEB()

Local _aArea := GetArea()  
Local _cOcorr := ""
 
 DbSelectArea("SE1")
 DbSetOrder(19)
 If DbSeek(rtrim(cNumTit))
 
      If Empty(SE1->E1_XINSTRU)
      _cOcorr :=ltrim(rtrim(SEB->EB_OCORR))+" "+ltrim(RTRIM(SEB->EB_DESCRI))+" "+Dtoc(ddatabase) 
      Else
      _cOcorr :=ltrim(RTRIM(SE1->E1_XINSTRU))+" "+CHR(10)+CHR(13)+" "+ltrim(rtrim(SEB->EB_OCORR))+" "+ltrim(RTRIM(SEB->EB_DESCRI))+" "+Dtoc(ddatabase) 
      Endif
      If Reclock("SE1",.F.)
          SE1->E1_XINSTRU:=  _cOcorr     
         MsUnlock()
      Endif
 Endif           
   
RestArea(_aArea)   
return
