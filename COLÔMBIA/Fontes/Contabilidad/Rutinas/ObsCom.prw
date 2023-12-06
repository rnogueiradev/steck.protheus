#Include "Protheus.ch"
#Include "TopConn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ObsCom   �Autor  �			        � Data �   09/2019 ���
�������������������������������������������������������������������������͹��
Obtiene observaci�n de documento de entrada para llevar
a historial de la contabilidad
�������������������������������������������������������������������������͹��
���Uso       � Colombia\                                         		  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function ObsCom(cTab,cDoc,cSer,cProv,cTien,cTip)

Local cObs := ""
Local aArea:= getarea()

IF cTab=='SF1'
    Dbselectare("SF1")
    DBSetOrder(1)
    DbSeek(xFilial("SF1")+cDoc+cSer+cProv+cTien+cTip)
        cObs:= SF1->F1_XOBS
elseif cTab=='SF2'
    Dbselectare("SF2")
    DBSetOrder(1)
    DbSeek(xFilial("SF2")+cDoc+cSer+cProv+cTien+cTip)
        cObs:= SF2->F2_XOBS
Endif

RestArea(aArea)
Return(cObs)

// return()
