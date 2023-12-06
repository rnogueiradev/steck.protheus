#Include "Protheus.ch"

/*
???????????????????????????????????????
??rograma  ?T105LOK    ?utor  ?oberto Lagunas   ?echa ? 04/01/10   ??
??                      ?alid  ?arlo Zumaya      ?echa ? 04/01/10   ??
?                        ?odif  ?u@nG@briel		 ?echa ? 19/11/13   ??
???????????????????????????????????????
??so       ?SIGACTB                                                    ??
???????????????????????????????????????
??esc.     ?rograma, que permite la inclusion de la descripcion de las ??
??         ?uenta contable en los documentos Contables                 ??
??????????????????????????????????????? 
*/

User Function CT105LOK
Local cArea := GetArea()
Local lRet	:= .T.
/*	  
TMP->CT2_DESC   := Posicione("CT1",1,xFilial("CT1")+TMP->CT2_DEBITO	,"CT1_DESC01")                         
TMP->CT2_ABODES := Posicione("CT1",1,xFilial("CT1")+TMP->CT2_CREDIT	,"CT1_DESC01")	
TMP->CT2_CCDEB	:= Posicione("CTT",1,xFilial("CTT")+TMP->CT2_CCD	,"CTT_DESC01")
TMP->CT2_CCCRE 	:= Posicione("CTT",1,xFilial("CTT")+TMP->CT2_CCC	,"CTT_DESC01")
TMP->CT2_ITDEB  := Posicione("CTD",1,xFilial("CTD")+TMP->CT2_ITDEB	,"CTD_DESC01")
TMP->CT2_ITCRE 	:= Posicione("CTD",1,xFilial("CTD")+TMP->CT2_ITCRE	,"CTD_DESC01")
	
If !Empty(TMP->CT2_EC05DB)
	TMP->CT2_NITDEB := Posicione("CV0",2,xFilial("CV0")+TMP->CT2_EC05DB,"CV0_DESC")
Else
	TMP->CT2_NITDEB := ""
Endif
	
If !Empty(TMP->CT2_EC05CR)
	TMP->CT2_NITCRE := Posicione("CV0",2,xFilial("CV0")+TMP->CT2_EC05CR,"CV0_DESC")
Else
	TMP->CT2_NITCRE := ""
Endif
	
//TMP->CT2_DEDB01 := IIF(ALLTRIM(SUBSTR(TMP->CT2_ORIGEM,1,3))$"650|660",SF1->F1_DOCINT,"")
//TMP->CT2_DEDB01 := IIF(ALLTRIM(SUBSTR(TMP->CT2_ORIGEM,1,3))$"610|620","NFS-"+SUBSTR(SF2->F2_DOC,7,7),"")
//TMP->CT2_DEDB01 := IIF(ALLTRIM(SUBSTR(TMP->CT2_ORIGEM,1,3))$"560|561|562|563",SE5->E5_DOCUMEN,"")
//TMP->CT2_DEDB01 := IIF(ALLTRIM(SUBSTR(TMP->CT2_ORIGEM,1,3))$"570","PAG-0"+SUBSTR(SEK->EK_ORDPAGO,1,6),"")
//TMP->CT2_DEDB01 := IIF(ALLTRIM(SUBSTR(TMP->CT2_ORIGEM,1,3))$"575|576","COB-0"+SUBSTR(SEL->EL_RECIBO,1,6),"")
	       
	
//????????????????????????????????
//?Valida que el NIT (Tercero) exista en la CV0                 ?
//????????????????????????????????
If TMP->CT2_DC == "1"
	If !Empty(TMP->CT2_EC05DB)	
		   	
	   	DbselectArea("CV0")
	   	DbSetOrder(1)
	   	If DbSeek(xFilial("CV0")+"01"+TMP->CT2_EC05DB)			   
	    	lRet := .T.
	    Else  
	    	lRet := .F.  
	     	MsgInfo("El NIT " +TMP->CT2_EC05DB + " en d?ito de la linea " +TMP->CT2_LINHA +" no existe")
	    EndIf   
    EndIf	   
Endif 
 	
If TMP->CT2_DC == "2"   
	If !Empty(TMP->CT2_EC05CR)	
	   	DbselectArea("CV0")
	   	DbSetOrder(1)
	   	If DbSeek(xFilial("CV0")+"01"+TMP->CT2_EC05CR)			   
	    	lRet := .T.
	 	Else  
	  		lRet := .F.  
	        MsgInfo("El NIT " +TMP->CT2_EC05CR + " en cr?ito de la linea " +TMP->CT2_LINHA +" no existe")
		EndIf   
	 EndIf
Endif
   	*/
RestArea(cArea)
Return(lRet)
