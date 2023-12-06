#Include "Rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RCVarCam    �Autor  �EDUAR ANDIA       � Data �  13/01/2016 ���
�������������������������������������������������������������������������͹��
���Desc.     � Diferencia en Cambio en Recibos de Caja                    ���
���          � Baja de Titulo                                             ���
�������������������������������������������������������������������������͹��
���Uso       � Colombia\Q&C                                      		  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RCVarCam
Local aArea 	:= GetArea()
Local aAreaSE1  := SE1->(GetArea())
Local nVlDifCb 	:= 0
Local nxVlHoy 	:= 0 

DbSelectArea("SE1")
SE1->(DbSetOrder(1))
If SE1->(DbSeek(xFilial("SE1")+SEL->EL_PREFIXO+SEL->EL_NUMERO+SEL->EL_PARCELA+SEL->EL_TIPO))	
	                           
	If ALLTRIM(SEL->EL_TIPODOC) $ "TB" .AND. ALLTRIM(SEL->EL_TIPO) $ "NF|NDC" .AND. SEL->EL_MOEDA=="02"
		nxVlHoy := SEL->EL_VLMOED1
		
		/*** Verifica la �ltima Diferencia en C�lculo ***/
		If SE1->E1_TXMDCOR > 0
			If E1_DTVARIA <> SEL->EL_EMISSAO
				nVUltCor := SEL->EL_VALOR * SE1->E1_TXMDCOR
				nVlDifCb := nxVlHoy - nVUltCor
			Endif
		Else
			//No tiene correcci�n cambiaria
			nVlDifCb := nxVlHoy - (SEL->EL_VALOR * SE1->E1_TXMOEDA)
		Endif
	Endif    	
Endif

RestArea(aAreaSE1)
RestArea(aArea)

Return(nVlDifCb)
