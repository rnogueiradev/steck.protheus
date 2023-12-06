
#Include "Rwmake.ch"
#Include "Topconn.ch"
#Include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F677USERMENU �Autor  �Jorge Mendoza       �Fecha �  25/01/07 ���
���                       �Valid  �Karlo Zumaya        �Fecha �  11/03/09 ���
���                       �Modif  �Wheelock Orozco     �Fecha �  06/07/09 ���
���                       �Valid  �Karlo Zumaya        �Fecha �  10/07/09 ���
���                       �Modif  �Eloisa Jimenez      �Fecha �  12/06/14 ���
���                       �Modif  �EDUAR ANDIA         �Fecha �  19/07/16 ���
�������������������������������������������������������������������������͹��
���Uso       � Reporte para impresi�n de comprobantes contables.          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function F677USERMENU()

	Local aRotina:= {}

	AAdd(aRotina,{ "Baja pendencias"    ,"U_F67MENU()",0,4,0,NIL} )

Return aRotina

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F677USERMENU �Autor  �Jorge Mendoza       �Fecha �  25/01/07 ���
���                       �Valid  �Karlo Zumaya        �Fecha �  11/03/09 ���
���                       �Modif  �Wheelock Orozco     �Fecha �  06/07/09 ���
���                       �Valid  �Karlo Zumaya        �Fecha �  10/07/09 ���
���                       �Modif  �Eloisa Jimenez      �Fecha �  12/06/14 ���
���                       �Modif  �EDUAR ANDIA         �Fecha �  19/07/16 ���
�������������������������������������������������������������������������͹��
���Uso       � Reporte para impresi�n de comprobantes contables.          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function F67MENU()


	_cQuery  := ""

	If Select("TE5") > 0
		DbSelectArea("TE5")
		DbCloSeArea()
	Endif

	_cQuery  := " SELECT FLF.* "
	_cQuery  += " FROM "+RetSqlName("FLF")+" FLF                                           "
	_cQuery  += " WHERE FLF.FLF_FILIAL = '"+xFilial("FLF")+"'  AND                         "
	_cQuery  += "       FLF.D_E_L_E_T_ <> '*'   AND FLF.FLF_STATUS <> '8'                    "



	TCQUERY _cQuery NEW ALIAS "TE5"


	DbSelectArea("TE5")
	DbGoTop()

	While !TE5->(EOF())

		DbSelectArea("SE5")
		DbSetOrder(7)
		If DbSeek(xFilial("SE5")+"REE"+TE5->FLF_PRESTA)

			DbSelectArea("FLF")
			DbSetOrder(1)
			If DbSeek(xFilial("FLF")+"2"+TE5->FLF_PRESTA)

				If Reclock("FLF",.F.)
					FLF->FLF_DTFECH := SE5->E5_DATA
					FLF->FLF_STATUS := "8"
					FLF->FLF_PREFIX := SE5->E5_PREFIXO
					FLF->FLF_TIPTIT := "NF"
					FLF->FLF_TITULO := TE5->FLF_PRESTA
					FLF->FLF_DTBAIX  := SE5->E5_DATA
					MsUnlock()
				Endif

			Endif


			DbSelectArea("FO7")
			DbSetOrder(2)
			If DbSeek(xFilial("FO7")+TE5->FLF_TIPO+TE5->FLF_PRESTA )
				If Reclock("FO7",.F.)
					FO7->FO7_TITULO := FLF->FLF_PRESTA
					FO7->FO7_DTBAIX := SE5->E5_DATA
					MsUnlock()
				Endif
			Endif

		Endif

		DbSelectArea("TE5")
		DbSkip()
	Enddo

	MsgInfo("Processamento realizado , com sucesso!!","Aten��o")

return
