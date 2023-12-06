#include "totvs.ch"
#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CTBBRIT �Autor  �Cristiano Pereira � Data �  06/12/12      ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida se a conta contabil gera item contabil              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Smb                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function CTBBRIT(_cConta)

Local _lRet := .F.

If ValType(_cConta)=="N"
_cConta := AllTrim(Str(_cConta))
Endif

DbSelectArea("CT1")
DbSetOrder(1)
If DbSeek(xFilial("CT1")+_cConta)
     If CT1->CT1_ACITEM=='1'
        _lRet  := .T.
     Endif
Endif

Return(_lRet)