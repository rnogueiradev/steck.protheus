#Include 'Protheus.ch'

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FA200POS º Autor ³ Vitor Merguizo	 º Data ³  30/03/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de Entrada para bloqueio do cliente quando ocorrenciaº±±
±±º          ³ de retorno igual a 19                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function FA200POS()

	Local _aParam	:=	PARAMIXB[1]
	Local _cMotBan	:=	" "
	Local _aArea	:=	GetArea()
	Local _aAreaE1	:=	SE1->(GetArea())
	Local _aAreaA1	:=	SA1->(GetArea())
	Local _lBlq		:= .F.
	Local _lSituaca	:= .F.
	Local _cSit		:= ""

	_cMotBan	:=	IIF(!Empty(_aParam) .And. Len(_aParam)>14,_aParam[15],"")

	If mv_par06="341"
		If AllTrim(cOcorr)$"03|23|32" //"19|23|32" //Robson Mazzarotto chamado 001651.
			_lBlq := .T.
			If AllTrim(cOcorr)="23"
				_lSituaca := .T.
				_cSit := "F"
			ElseIf AllTrim(cOcorr)="32"
				_lSituaca := .T.
				_cSit := "F"
			ElseIf AllTrim(cOcorr)="03" //Robson Mazzaorrot chamado 001651.
				_lSituaca := .T.
				_cSit := "0"
			EndIf
		EndIf
	ElseIf mv_par06="237"
		If AllTrim(cOcorr)$"23" .Or. (AllTrim(cOcorr)="10" .And. Alltrim(_cMotBan)="14") //"19|23"
			_lBlq := .T.
			If AllTrim(cOcorr)="23"
				_lSituaca := .T.
				_cSit := "F"
			ElseIf AllTrim(cOcorr)="10" .And. Alltrim(_cMotBan)="14"
				_lSituaca := .T.
				_cSit := "F"
			EndIf
		EndIf
	EndIf

	If _lBlq .Or. _lSituaca
		dbSelectArea("SE1")
		SE1->(dbSetOrder(16))
		If SE1->(dbSeek(xFilial("SE1")+cNumTit))
			If _lSituaca
				RecLock("SE1",.F.)
				SE1->E1_SITUACA	:= _cSit
				SE1->E1_NUMBOR	:= " "
				MsUnLock()
			EndIf
			If _lBlq
				dbSelectArea("SA1")
				SA1->(dbSetOrder(1))
				If SA1->(dbSeek(xFilial("SA1")+SE1->E1_CLIENTE))
					While SA1->(!Eof()) .And. SA1->(A1_FILIAL+A1_COD) = xFilial("SA1")+SE1->E1_CLIENTE
						If SA1->(A1_FILIAL+A1_COD) = xFilial("SA1")+SE1->E1_CLIENTE
							RecLock("SA1",.F.)
							//SA1->A1_MSBLQL	:=	'1'
							SA1->A1_XBLOQF	:= "B"
							SA1->A1_XBLQFIN	:= "1" // CHAMADO 004358 THIAGO GODINHO EM 31/08/16 11:12
							MsUnLock()
						EndIf
						SA1->(DbSkip())
					End
				EndIf
				
				//Robson Mazzarotto chamado 001651.
				dbSelectArea("SEA")
				SEA->(dbSetOrder(1))
			
				If SEA->(dbSeek(xFilial("SEA")+SE1->E1_NUMBOR+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO))
					SEA->( RecLock("SEA",.F.) )
					SEA->( dbDelete() )
					SEA->( MsUnlock() )
				EndIf
			
			EndIf
		EndIf
	EndIf

	RestArea(_aArea)
	RestArea(_aAreaE1)
	RestArea(_aAreaA1)

Return