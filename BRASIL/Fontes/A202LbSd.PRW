#include "RWMAKE.CH"
#include "Protheus.CH"
#include "Topconn.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �  A202LbSd  | Autor � FlexPro             � Data �12.03.2013���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Libera SD unicom                                           ���
�������������������������������������������������������������������������Ĵ��
���Parametros� Nenhum                                                     ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Nenhum                                                     ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATA202                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
User Function A202LbSd()

Local aArea    :=GetArea()

Local aAreaSX3:=SX3->(GetArea())
//��������������������������������������������������������������Ŀ
//� Variavel lPyme utilizada para Tratamento do Siga PyME        �
//����������������������������������������������������������������
Local lPyme:= Iif(Type("__lPyme") <> "U",__lPyme,.F.)


cQuery := ""         
cQuery += " SELECT  R_E_C_N_O_ AS REGSS      "
cQuery += " FROM " + RetSqlName("PP8")
cQuery += " WHERE PP8_FILIAL = '" + xFilial("PP8") + "' "
cQuery += " AND PP8_PROD = '" + SGG->GG_COD+ "' "
cQuery += " AND PP8_STATUS = 'E' " 
cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"CAD",.T.,.T.)

TcSetField("CAD","REGSS","N",9,0)



Dbselectarea("CAD")
Dbgotop()
IF EOF()
   MsgSTop("Nao existem Unicos com este codigo a Liberar, Verifique !!! ")
Else 
    If MsgYesno("Confirma liberacao de SD para Comercial !!! ")
	 	While CAD->(!EOF())
	          DBselectarea("PP8")  
	          DbGoto(CAD->REGSS)
	          RecLock("PP8",.f.)
	          PP8->PP8_STATUS 	:= "Z"
	          PP8->PP8_DTENG 	:= DDATABASE
	          PP8->PP8_USENG 	:= CUSERNAME
	          MSUNLOCK()
			  Dbselectarea("CAD")
		      Dbskip()
	    EndDo
    Endif
Endif

Dbselectarea("CAD")
DbCloseArea("CAD")

RestArea(aArea)
       
Return    