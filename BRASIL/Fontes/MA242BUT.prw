#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA242BUT   �Autor  �Cristiano Pereira � Data �  04/23/19   ���
�������������������������������������������������������������������������͹��
���Desc.     �Desmontagem do produto                                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MA242BUT()

	Local aBotao:={}

	aBotao := aClone(ParamIXB[2])

	aadd(aBotao, {'HISTORIC',{|| MA242AA()},"Rateio","Rateio"})

return(aBotao)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA242AA  �Autor  �Cristiano Pereira    � Data �  04/23/19   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rateio                                                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MA242AA()

	Local _nlin
	Local _cCusPrd  := 0
	Local _cCusPI   := 0
	Local _nCuTot   := 0
	Local _nCuUni   := 0


	DbSelectArea("SB2")
	DbSetOrder(1)
	If DbSeek(xFilial("SB2")+CPRODUTO+CLOCORIG)
		_cCusPrd := SB2->B2_CM1
	Endif


	For _nlin:=1 to len(aCols)

		DbSelectArea("SB2")
		DbSetOrder(1)
		If DbSeek(xFilial("SB2")+aCols[_nlin,1]+"01")
			 _nCuUni := SB2->B2_CM1

			If _nCuUni <=0 

				DbSelectArea("SB2")
				DbSetOrder(1)
				If DbSeek(xFilial("SB2")+aCols[_nlin,1]+"90")
					_nCuUni := SB2->B2_CM1
				Endif

			Endif
		Endif 
        _nCuTot += _nCuUni
	Next _nlin



	For _nlin:=1 to len(aCols)

		_cCusPI  := 0

		DbSelectArea("SB1")
		DbSetOrder(1)
		If DbSeek(xFilial("SB1")+aCols[_nlin,1])

			DbSelectArea("SB2")
			DbSetOrder(1)
			If DbSeek(xFilial("SB2")+aCols[_nlin,1]+"01")
				_cCusPI := SB2->B2_CM1

				If _cCusPI <=0 

					DbSelectArea("SB2")
					DbSetOrder(1)
					If DbSeek(xFilial("SB2")+aCols[_nlin,1]+"90")
						_cCusPI := SB2->B2_CM1
					Endif

				Endif
			Endif


			aCols[_nlin,8] := (_cCusPI /  _nCuTot) * 100
			aCols[_nlin,4]  := "50"
			aCols[_nlin,5]  := SB1->B1_CC


		Endif

	Next _nlin

return