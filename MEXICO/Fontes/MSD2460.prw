/*
GRABAR OBSERVACIONES DESDE PEDIDO A FACTURACION
*/
                     
//001 -FUNCIONALIDAD PARA GRABAR OBSERVACIONES 17-01-22
User Function MSD2460()                                       
Local aAreaSF2   := SF2->(GetArea())  
Local aAreaSD2   := SD2->(GetArea())   
	RecLock("SD2",.F.)                                   

	IF  FUNNAME()=="MATA468N" .OR. FUNNAME()=="MATA461"
 // 		SD2->D2_FRACCA := SC6->C6_FRACCA   
 // 		SD2->D2_UNIADU := SC6->C6_UNIADU   
// 		SD2->D2_CONTA  := SC6->C6_CONTA   
//  		SD2->D2_CTADESC := SC6->C6_CTADESC 
  		SD2->D2_OBS := SC6->C6_OBS 	//001 
	Endif
	/*
	IF Empty(SD2->D2_FRACCA)
  		SD2->D2_FRACCA := SB1->B1_FRACCA   
  		SD2->D2_UNIADU := SB1->B1_UNIADU   
	ENDIF
		IF SF2->F2_TIPOPE=="2"
			SD2->D2_VALADU := SD2->D2_PRCVEN                    
			SD2->D2_USDADU := SD2->D2_TOTAL    
			SD2->D2_CANADU := SD2->D2_QUANT  
		Endif
 	IF !Empty(SD2->D2_LOTECTL)
		__aArea		:= GetArea()
		__aAreaSB8 	:= GetArea("SB8")
      	dbSelectArea("SB8")
    	dbSetOrder(3)
		If dbSeek(xFilial("SB8") +SD2->D2_COD +SD2->D2_LOCAL +SD2->D2_LOTECTL)
				SD2->D2_PEDISAT:= SB8->B8_PEDISAT
		Endif		
		RestArea(__aAreaSB8)
		RestArea(__aArea)
	ENDIF
	*/
	MsUnLock()  

RestArea(aAreaSF2)  
RestArea(aAreaSD2)  

Return()

/*
User Function M468SD2()                                       
Local aAreaSF2   := SF2->(GetArea())  
Local aAreaSD2   := SD2->(GetArea())   
	RecLock("SD2",.F.)                                   

	IF SF2->F2_MOEDA = 2  .AND. FUNNAME()=="MATA468N"
  		SD2->D2_FRACCA := SC6->C6_FRACCA   
  		SD2->D2_UNIADU := SC6->C6_UNIADU   
 		SD2->D2_CONTA  := SC6->C6_CONTA   
  		SD2->D2_CTADESC := SC6->C6_CTADESC 
	Endif
	 	SD2->D2_VALADU := SD2->D2_PRCVEN                    
	  	SD2->D2_USDADU := SD2->D2_TOTAL    
  		SD2->D2_CANADU := SD2->D2_QUANT  
 	IF !Empty(SD2->D2_LOTECTL)
		__aArea:= GetArea()
		__aAreaSB8 := GetArea("SB8")
      	dbSelectArea("SB8")
    	dbSetOrder(3)
		If dbSeek(xFilial("SB8") +SD2->D2_COD +SD2->D2_LOCAL +SD2->D2_LOTECTL)
				SD2->D2_PEDISAT:= SB8->B8_PEDISAT
		Endif		
		RestArea(__aAreaSB8)
		RestArea(__aArea)
	ENDIF
	MsUnLock()  

RestArea(aAreaSF2)  
RestArea(aAreaSD2)  

Return()
*/
