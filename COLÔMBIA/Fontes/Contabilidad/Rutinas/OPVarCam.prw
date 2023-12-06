#Include "Rwmake.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProgram   ³           ºAuthor ³                   º Date ³  08/09/2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Rutina que es cargada en los asientos estándar 570        º±±
±±º          ³  para obtener el valor de la paridad cambiaria en las      º±±
±±º          ³  ordenes de pago a proveedores.                            º±±
±±º																		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUse       ³ AP           - SIGACTB                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function OPVarCam()
Local aArea := getArea()
Local nVal1 := 0
Local nVal2 := 0

DbSelectArea("SE2")
SE2->(DbSetOrder(1))
If SE2->(DbSeek(xFilial("SE2")+SEK->EK_PREFIXO+SEK->EK_NUM+SEK->EK_PARCELA+SEK->EK_TIPO+SEK->EK_FORNECE+SEK->EK_LOJA))	
	                           
	//FACTURAS Y NOTAS DEBITO PROVEEDOR
	If ALLTRIM(SEK->EK_TIPODOC) $ "TB".AND. ALLTRIM(SEK->EK_TIPO)$"NF/NDC"
		If SEK->EK_MOEDA $ "2"   
		    If SE2->E2_TXMDCOR>0   
		     //  nVal2 := ((SEK->EK_TXMOE02 - SE2->E2_TXMDCOR)*SEK->EK_VALOR)                     
			 	nVal2 := (((SEK->EK_VLMOED1/SEK->EK_VALOR)-SE2->E2_TXMDCOR)*SEK->EK_VALOR)                     
		    Else
	  		   //	nVal2 := ((SEK->EK_TXMOE02-SE2->E2_TXMOEDA)*SEK->EK_VALOR)
	  		     	nVal2 := (((SEK->EK_VLMOED1/SEK->EK_VALOR)-SE2->E2_TXMOEDA)*SEK->EK_VALOR)
		    EndIf
		Else
			If SEK->EK_MOEDA $ "3" 
			     If SE2->E2_TXMDCOR>0
			       //	nVal2 := ((SEK->EK_TXMOE03-SE2->E2_TXMDCOR)*SEK->EK_VALOR) 
			         	nVal2 := (((SEK->EK_VLMOED1/SEK->EK_VALOR)-SE2->E2_TXMDCOR)*SEK->EK_VALOR) 
			     Else 
			      //  nVal2 := ((SEK->EK_TXMOE03-SE2->E2_TXMOEDA)*SEK->EK_VALOR)
			           	nVal2 := (((SEK->EK_VLMOED1/SEK->EK_VALOR)-SE2->E2_TXMOEDA)*SEK->EK_VALOR)
			     Endif 	
			Else
				If SEK->EK_MOEDA $ "4"    
			    	  If SE2->E2_TXMDCOR>0
					      //	nVal2 := ((SEK->EK_TXMOE04-SE2->E2_TXMDCOR)*SEK->EK_VALOR)
					      nVal2 := (((SEK->EK_VLMOED1/SEK->EK_VALOR)-SE2->E2_TXMDCOR)*SEK->EK_VALOR) 
				      Else
				      	 //	nVal2 := ((SEK->EK_TXMOE04-SE2->E2_TXMOEDA)*SEK->EK_VALOR)
				      	 	nVal2 := (((SEK->EK_VLMOED1/SEK->EK_VALOR)-SE2->E2_TXMOEDA)*SEK->EK_VALOR)
				      Endif 	
				Else
					nVal2 := 0
				EndIf
			EndIf
		EndIf
	Else
		              
	
	//NOTAS CREDITO PROVEEDOR Y ANTICIPOS
	If ALLTRIM(SEK->EK_TIPODOC) $ "TB".AND. ALLTRIM(SEK->EK_TIPO)$"NCP/PA"
		If SEK->EK_MOEDA $ "2"   
		    If SE2->E2_TXMDCOR>0   
		     //  nVal2 := ((SEK->EK_TXMOE02 - SE2->E2_TXMDCOR)*SEK->EK_VALOR)                     
			 	nVal2 := (((SEK->EK_VLMOED1/SEK->EK_VALOR)-SE2->E2_TXMDCOR)*SEK->EK_VALOR)                     
		    Else
	  		   //	nVal2 := ((SEK->EK_TXMOE02-SE2->E2_TXMOEDA)*SEK->EK_VALOR)
	  		     	nVal2 := (((SEK->EK_VLMOED1/SEK->EK_VALOR)-SE2->E2_TXMOEDA)*SEK->EK_VALOR)
		    EndIf
		Else
			If SEK->EK_MOEDA $ "3" 
			     If SE2->E2_TXMDCOR>0
			       //	nVal2 := ((SEK->EK_TXMOE03-SE2->E2_TXMDCOR)*SEK->EK_VALOR) 
			         	nVal2 := (((SEK->EK_VLMOED1/SEK->EK_VALOR)-SE2->E2_TXMDCOR)*SEK->EK_VALOR) 
			     Else 
			      //  nVal2 := ((SEK->EK_TXMOE03-SE2->E2_TXMOEDA)*SEK->EK_VALOR)
			           	nVal2 := (((SEK->EK_VLMOED1/SEK->EK_VALOR)-SE2->E2_TXMOEDA)*SEK->EK_VALOR)
			     Endif 	
			Else
				If SEK->EK_MOEDA $ "4"    
			    	  If SE2->E2_TXMDCOR>0
					      //	nVal2 := ((SEK->EK_TXMOE04-SE2->E2_TXMDCOR)*SEK->EK_VALOR)
					      nVal2 := (((SEK->EK_VLMOED1/SEK->EK_VALOR)-SE2->E2_TXMDCOR)*SEK->EK_VALOR) 
				      Else
				      	 //	nVal2 := ((SEK->EK_TXMOE04-SE2->E2_TXMOEDA)*SEK->EK_VALOR)
				      	 	nVal2 := (((SEK->EK_VLMOED1/SEK->EK_VALOR)-SE2->E2_TXMOEDA)*SEK->EK_VALOR)
				      Endif 	
				Else
					nVal2 := 0
				EndIf
			EndIf
		EndIf
	Else
		nVal2 := 0
	EndIf

Endif	
		
	
EndIf
If nVal2 <> 0
	nVal1 := Round(nVal2,2)
EndIf
RestArea(aArea)
Return (nVal1)      
