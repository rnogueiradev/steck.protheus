#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �TPCTACC   � Autor � Carlos Miranda        � Data � 26.10.09 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Centro de Custo                                            ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � RDMake ( DOS e Windows )                                   ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico para STECK                                      ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���            �        �      �                                          ���
���            �        �      �                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/



***********
* Debito  *
***********

user function DEBCONT()

cConta := space(20)

calias := GetArea()

dbselectarea("CTT")
dbseek(xfilial("CTT")+SRZ->RZ_CC)

do CASE
   case CTT->CTT_REFCTA == '1'

      cConta := FDESC("SRV",SRZ->RZ_PD,"RV_DBADM")
      if trim(cConta) = ""
         msgalert("Conta Debito nao existe na verba " + SRZ->RZ_PD + " para o grupo ADMINISTRATIVO") 
      endif

   case CTT->CTT_REFCTA == '2'

      cConta := FDESC("SRV",SRZ->RZ_PD,"RV_DBVENDA")
      if trim(cConta) = ""
         msgalert("Conta Debito nao existe na verba " + SRZ->RZ_PD + " para o grupo VENDAS") 
      endif

   case CTT->CTT_REFCTA == '3'

      cConta := FDESC("SRV",SRZ->RZ_PD,"RV_DCUSDIR")
      if trim(cConta) = ""
         msgalert("Conta Debito nao existe na verba " + SRZ->RZ_PD + " para o grupo CUSTO DIRETO") 
      endif

   case CTT->CTT_REFCTA == '4'

      cConta := FDESC("SRV",SRZ->RZ_PD,"RV_DCUSIND")
      if trim(cConta) = ""
         msgalert("Conta Debito nao existe na verba " + SRZ->RZ_PD + " para o grupo CUSTO INDIRETO") 
      endif

   case CTT->CTT_REFCTA == '5'

      cConta := FDESC("SRV",SRZ->RZ_PD,"RV_DATIVIM")
      if trim(cConta) = ""
         msgalert("Conta Debito nao existe na verba " + SRZ->RZ_PD + " para o grupo ATIVO IMOBILIZADO") 
      endif

endcase         

RestArea(calias)

return(cConta)    

***********
* Credito *
***********
user function CREDCONT()

cConta := space(20)

calias := GetArea()

dbselectarea("CTT")
dbseek(xfilial("CTT")+SRZ->RZ_CC)

do CASE
   case CTT->CTT_REFCTA == '1'

      cConta := FDESC("SRV",SRZ->RZ_PD,"RV_CRADM")
      if trim(cConta) = ""
         msgalert("Conta Credito nao existe na verba " + SRZ->RZ_PD + " para o grupo ADMINISTRATIVO") 
      endif   

   Case CTT->CTT_REFCTA == '2'

      cConta := FDESC("SRV",SRZ->RZ_PD,"RV_CRVENDA")  
      if trim(cConta) = ""
        msgalert("Conta Credito nao existe na verba " + SRZ->RZ_PD + " para o grupo VENDAS")
      endif


   Case CTT->CTT_REFCTA == '3'

      cConta := FDESC("SRV",SRZ->RZ_PD,"RV_CCUSDIR")
      if trim(cConta) = ""
         msgalert("Conta Credito nao existe na verba " + SRZ->RZ_PD + " para o grupo CUSTO DIRETO") 
      endif  

   Case CTT->CTT_REFCTA == '4'

      cConta := FDESC("SRV",SRZ->RZ_PD,"RV_CCUSIND")
      if trim(cConta) = ""
         msgalert("Conta Credito nao existe na verba " + SRZ->RZ_PD + " para o grupo CUSTO INDIRETO") 
      endif

  Case CTT->CTT_REFCTA == '5'

      cConta := FDESC("SRV",SRZ->RZ_PD,"RV_CATIVIM")
      if trim(cConta) = ""
         msgalert("Conta Credito nao existe na verba " + SRZ->RZ_PD + " para o grupo ATIVO IMOBILIZADO") 
      endif
      

endcase

RestArea(calias)

return(cConta)         

 
********************************
* Centro de Custo Debito  *
*******************************
user function DEBCCC()

cCC := space(9)

cConta := FDESC("SRV",SRZ->RZ_PD,"RV_DBADM","RV_DBVENDAS","RV_DCUSDIR","RV_DCUSIND","RV_DATIVIM")

cRecebCC := fdesc("CT1",cConta,"CT1_CCOBRG")

IF cRecebCC = "S"
       cCC:= SRZ->RZ_CC
endif 

return(cCC)    

*********************************
*  Centro de Custo Credito *
*********************************
user function CRECCC()

cCC := space(9)

cConta := FDESC("SRV",SRZ->RZ_PD,"RV_CRADM","RV_CRVENDAS","RV_CCUSDIR","RV_CCUSIND","RV_CATIVIM")

  
cRecebCC := fdesc("CT1",cConta,"CT1_CCOBRG")

IF cRecebCC = "S"
    cCC:= SRZ->RZ_CC
   endif 

return(cCC)    

//  IF SUBSTR(cConta,1,1) $ "3-4"
//    cCC:= SRZ->RZ_CC
//  endif 





