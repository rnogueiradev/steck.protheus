#Include "Protheus.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณMT100TOK  บAutor  ณLuiz Enrique        บ Data ณ  12/11/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ponto de Entrada no MATA103, na confirmacao da Nota Fiscal บฑฑ
ฑฑบ          ณ de Entrada que tem como finalidade, consistir os Itens e   บฑฑ
ฑฑณ			 ณ quantidades da Nota fiscal de Devolucao com os itens 		  บฑฑ 
ฑฑบ          ณ correspondentes existentes na FATEC (PC2)					  	  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck						                                      บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function MT100TOK()

   Local lRet     := .F.
   Local lTipoRet := .T.
   Local nItem

	If IsInCallStack("MATA920")
		Return(.T.)
	EndIf


      If !FwIsInCallStack('U_GATI001') .Or. IIf(Type('l103Auto') == 'U',.T.,!l103Auto)
 
   
   lRet := U_STFSRE11()

   lRet := U_STCOM028()

	If lRet
      lRet := U_STCOM02A()
	EndIf

	If lRet
      lRet := U_STCOM01A()
	EndIf

   // Valdemir Rabelo - Ticket: 20200903006846 - 18/05/2021
	If (cTipo == "I") .And. lRet
      nICMSRET := aScan(aHeader, {|X| alltrim(X[2])=="D1_ICMSRET"} )
      nICMS    := aScan(aHeader, {|X| alltrim(X[2])=="D1_VALICM"} )
		For nItem := 1 to Len(aCols)
         If !IsInCallStack("U_STCIAP03")  // Ticket 20210729014100 - Emissใo nota CIAP -- Eduardo Pereira Sigamat -- 29.07.2021 -- Incluso apenas a linha 37 e 44 para tratar a emissใo automatica da NF CIAP
            /* Comentado para ajustar a valida็a๕ conforme chamado: 20220801014928 apenas dar a mensagem se os 2 campos estiverem vazios.
            If (aCols[nItem, nICMSRET] == 0) 
               lTipoRet := .F.
            EndIf
            If (aCols[nItem, nICMS] == 0)
               lTipoRet := .F.
            EndIf
            */

            If (aCols[nItem, nICMS] == 0) .And. (aCols[nItem, nICMSRET] == 0) 
               lTipoRet := .F.
            Endif
         EndIf
		Next
      If !lTipoRet
         MsgInfo("Para tipo nota 'Complemento de ICMS', precisa ser informado os campos: ICMS SOLID e ICMS", "Informativo")
      EndIf
      lRet := lTipoRet
	EndIf
  
Endif

If lRet
        // Ponto de chamada ConexใoNF-e sempre como ๚ltima instru็ใo.
        lRet := U_GTPE005()
EndIf


Return lRet
