#Include 'Protheus.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MATA632()�Autor  �Robson Mazzarotto    � Data �  23/03/2018 ���
�������������������������������������������������������������������������͹��
���Desc.     � PONTO DE ENTRADA NA ROTINA DE ATUALIZACAO DO ROTEIRO DE    ���
���          � OPERACAO PARA ENVIO DE E-MAIL AS PESSOAS RESPONSAVEIS      ���
���          � QUANDO UM DETERMINADO ROTEIRO SOBRER ATUALIZACAO.          ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function MATA632()

Local aParam     := PARAMIXB
Local xRet       := .T.
Local oObj       := ''
Local cIdPonto   := ''
Local cIdModel   := ''
Local lIsGrid    := .F.

If aParam <> NIL
      
       oObj       := aParam[1]
       cIdPonto   := aParam[2]
       cIdModel   := aParam[3]
       lIsGrid    := ( Len( aParam ) > 3 )
      
     //  If lIsGrid
      //       nQtdLinhas := oObj:GetQtdLine()
       //      nLinha     := oObj:nLine
       //EndIf
             
       If cIdPonto == 'FORMCOMMITTTSPOS'
			
			U_MailRot(SG2->G2_CODIGO,SG2->G2_PRODUTO) // Rotina de envio de email no fonte MA630ALT.
           
            
       EndIf
 
EndIf
 
Return xRet



