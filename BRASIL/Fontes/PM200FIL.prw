#Include 'Protheus.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  PM200FIL     �Autor  �Robson Mazzarotto � Data �  08/03/2017 ���
�������������������������������������������������������������������������͹��
���Desc.     �Filtro dos projetos por Gerente do Projeto logado no sistema���
�������������������������������������������������������������������������͹��
���Uso       � PMS                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function PM200FIL()
Local _cPrj    := ""

dbSelectArea("AF8")
dbGoTop()

while !EOF()


PswOrder(1)

If PswSeek(__cUserId,.T.)
	_aGrupos	:= PswRet()
EndIf

If _aGrupos[1][10][1] $ "000211#000210#000209#000000"
	
	
	if AF8->AF8_TPPRJ = "0003" 
		_cPrj += AF8->AF8_PROJET
	Endif

else

	if AF8->AF8_TPPRJ <> "0003" 
		_cPrj += AF8->AF8_PROJET
	Endif

Endif



dbSkip()
Enddo

cFiltBrw := "AF8_PROJET $ '"+_cPrj+"'"

Return(cFiltBrw)
