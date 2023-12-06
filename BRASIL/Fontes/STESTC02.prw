#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#Include "TopConn.ch"

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    � STESTC02      �Autor  � Renato Nogueira  � Data �06.08.2013 ���
��������������������������������������������������������������������������Ĵ��
���          �Mostrar o usu�rio que fez o endere�amento de produto         ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Uso       � Generico                                                    ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/

User Function STESTC02()

Local aArea     := GetArea()
Local aAreaSDA  := SDA->(GetArea())
Local aAreaSDB  := SDB->(GetArea())

cStrAlt     := SDA->DA_USERLGA
cStrInc     := SDA->DA_USERLGI
cNStrAlt 	:= Embaralha(cStrAlt, 1) // parametro 0 embaralha, 1 desembaralha
cNStrInc 	:= Embaralha(cStrInc, 1) // parametro 0 embaralha, 1 desembaralha
cUsuAlt     := SubStr(cNStrAlt,3,6) //usuario que alterou
cUsuInc     := SubStr(cNStrInc,3,6) //usuario que alterou

nDiasAlt    := Load2in4(SubStr(cNStrAlt,16))
nDiasInc    := Load2in4(SubStr(cNStrInc,16))
dDataAlt    := CtoD("01/01/96","DDMMYY") + nDiasAlt
dDataInc    := CtoD("01/01/96","DDMMYY") + nDiasInc

	cMensagem	:= 	"Incluido por "+Alltrim(UsrRetName(cUsuInc))+" em "+DtoC(dDataInc)+(CHR(13)+CHR(10))
	cMensagem	+=  (CHR(13)+CHR(10))
	cMensagem	+=  "Alterado por "+Alltrim(UsrRetName(cUsuAlt))+" em "+DtoC(dDataAlt)

MsgInfo(cMensagem,"Log")

RestArea(aAreaSDA)
RestArea(aAreaSDB)
RestArea(aArea)

Return()