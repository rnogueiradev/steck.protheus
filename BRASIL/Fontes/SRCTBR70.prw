#include "totvs.ch"
#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CTBBRAIT �Autor  �Cristiano Pereira � Data �  06/12/12      ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida se a conta contabil gera item contabil              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Smb                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function CTBBRAIT(_cConta)

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

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CTBBRACC �Autor  �Cristiano Pereira � Data �  06/12/12      ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida se a conta contabil gera centro de custo            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Smb                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function CTBBRACC(_cConta)

Local _lRet := .F.

If ValType(_cConta)=="N"
_cConta := AllTrim(Str(_cConta))
Endif

DbSelectArea("CT1")
DbSetOrder(1)
If DbSeek(xFilial("CT1")+_cConta)
     If CT1->CT1_ACCUST=='1'
        _lRet  := .T.
     Endif
Endif

Return(_lRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CTBBRACL �Autor  �Cristiano Pereira � Data �  06/12/12      ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida se a conta contabil gera classe de valor            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Steck Industria                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function CTBBRACL(_cConta)

Local _lRet := .F.

If ValType(_cConta)=="N"
_cConta := AllTrim(Str(_cConta))
Endif

DbSelectArea("CT1")
DbSetOrder(1)
If DbSeek(xFilial("CT1")+_cConta)
     If CT1->CT1_ACCLVL=='1'
        _lRet  := .T.
     Endif
Endif

Return(_lRet)
