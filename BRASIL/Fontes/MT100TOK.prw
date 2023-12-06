#Include "Protheus.ch"

/*���������������������������������������������������������������������������
���Programa  �MT100TOK  �Autor  �Luiz Enrique        � Data �  12/11/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada no MATA103, na confirmacao da Nota Fiscal ���
���          � de Entrada que tem como finalidade, consistir os Itens e   ���
���			 � quantidades da Nota fiscal de Devolucao com os itens 		  ��� 
���          � correspondentes existentes na FATEC (PC2)					  	  ���
�������������������������������������������������������������������������͹��
���Uso       � Steck						                                      ���
���������������������������������������������������������������������������*/

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
         If !IsInCallStack("U_STCIAP03")  // Ticket 20210729014100 - Emiss�o nota CIAP -- Eduardo Pereira Sigamat -- 29.07.2021 -- Incluso apenas a linha 37 e 44 para tratar a emiss�o automatica da NF CIAP
            /* Comentado para ajustar a valida�a� conforme chamado: 20220801014928 apenas dar a mensagem se os 2 campos estiverem vazios.
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
        // Ponto de chamada Conex�oNF-e sempre como �ltima instru��o.
        lRet := U_GTPE005()
EndIf


Return lRet
