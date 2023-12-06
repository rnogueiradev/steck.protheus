#include 'Protheus.ch'
#include 'RwMake.ch'

/*====================================================================================\
|Programa  | STLEG410         | Autor | GIOVANI.ZAGO             | Data | 25/03/2013  |
|=====================================================================================|
|Descrição |  STLEG410     atualiza sc5 apos gravação da N.F.                         |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STLEG410                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function STLEG410()
	*-----------------------------*
	Local _xAlias    := GetArea()
	Local _xAliasSD2 := SD2->(GetArea())
	Local _xAliasSC5 := SC5->(GetArea())
	Local _xAliasSC6 := SC6->(GetArea())
	Local _xAliasSF2 := SF2->(GetArea())
	Local _aNunPed   := {}
	Local _cPedNum   := ''
	Local _lParcial  := .T.
	Local i  := 0
	
	
	DbSelectArea("SC6")
	SC6->(DbSetOrder(4))
	If SC6->(DbSeek(xFilial("SC6")+SF2->F2_DOC+SF2->F2_SERIE))
		_cPedNum:=SC6->C6_NUM
		aadd(_aNunPed,{SC6->C6_NUM})
		While SC6->(!Eof()) .and. SC6->C6_FILIAL = xFilial("SC6").and. SC6->C6_NOTA = SF2->F2_DOC
			If _cPedNum <> SC6->C6_NUM
				aadd(_aNunPed,{SC6->C6_NUM})
			EndIf
			_cPedNum:=SC6->C6_NUM
			SC6->(DBSKIP())
		END
	EndIf
	
	For i:=1 To Len(_aNunPed)
		if _lParcial
			DbSelectArea("SC6")
			SC6->(DbSetOrder(1))
			If SC6->(DbSeek(xFilial("SC6")+_aNunPed[i,1]))
				
				While SC6->(!Eof()) .and. SC6->C6_FILIAL = xFilial("SC6")    .and. SC6->C6_NUM = _aNunPed[i,1]
					If SC6->C6_QTDENT <> SC6->C6_QTDVEN
						_lParcial:= .F.
					EndIf
					SC6->(DBSKIP())
				END
			EndIf
			DbSelectArea("SC5")
			SC5->(DbSetOrder(1))
			If SC5->(DbSeek(xFilial("SC5")+_aNunPed[i,1]))
				
				SC5->(RecLock("SC5",.F.))
				SC5->C5_ZFATBLQ  := iif(_lParcial,'1','2')
				
				/*	If !_lParcial //150413 incluir status totalmente faturado renato
				
				SC5->C5_XSTARES	:= ""
				
			EndIf */
			
			SC5->(MsUnlock())
			SC5->( DbCommit() )
		EndIf
		_lParcial  := .T.
	EndIf
Next i

RestArea(_xAliasSF2)
RestArea(_xAliasSC6)
RestArea(_xAliasSC5)
RestArea(_xAliasSD2)
RestArea(_xAlias)

Return()

