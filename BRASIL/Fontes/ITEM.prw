#Include 'Protheus.ch'

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    � ITEM      �Autor  � Robson Mazzarotto    � Data �16.02.2018 ���
��������������������������������������������������������������������������Ĵ��
���          �Ponto de entrada em MVC do cadastro de produto               ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Uso       � Generico                                                    ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/

User Function ITEM()

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
    

       If cIdPonto == 'MODELPOS'
             
            U_MT010ALT() 
     
		EndIf     
       
EndIf
 
Return xRet
 

