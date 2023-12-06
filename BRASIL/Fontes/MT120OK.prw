#Include "Totvs.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณMT120OK	บAutor  ณRenato Nogueira     บ Data ณ  08/07/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo utilizada segregar os acessos de inclusใo/altera็ใo  บฑฑ
ฑฑบ          ณnos pedido de compras				    				      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametro ณ Nenhum                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบRetorno   ณ Nenhum                                                     บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function MT120OK()

	Local _aArea		:= GetArea()
	Local _lRet			:= .F.
	Local _nGrpAprov	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C7_APROV"})
	//Local _nMotComp 	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C7_MOTIVO"})
	Local _nMotCC 		:= aScan(aHeader,{|x| AllTrim(x[2]) == "C7_CC"})
	Local _nX

	//	Adicionado para tratamento da Autoriza็ใo de Entrega - Eduardo Pereira 10/02/2021
	If IsInCallStack( "MATA122" )
		Return .T.
	EndIf

		//	Adicionado para tratamento da Medi็ใo de contrados - Leandro Godoy 01.04.2022
	If IsInCallStack( "CNTA121" )
		Return .T.
	EndIf	
	

	_lRet := U_STVLDPCS()

	If _lRet
		_lRet := U_STPCVLDTRANSFERPRICE()//Chamado 002767
	EndIf

	/*ศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	ฑฑบChamado   ณ 002612 - Automatizar Solicita็ใo de Compras                บฑฑ
	ฑฑบSolic.    ณ Juliana Queiroz - Depto. Compras                           บฑฑ
	ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ*/

	// If Alltrim( FunName() ) <> 'U_STGerPC'
		If _lRet
			_lRet := U_STCOM027()
		EndIf
	// EndIf

	For _nX := 1 To Len(aCols)
		Do Case
			Case aCols[_nX][_nMotCC] $ "112104"
				aCols[_nX][_nGrpAprov] := "000006"
			Otherwise
				aCols[_nX][_nGrpAprov] := "000005"
		EndCase
	Next

	RestArea(_aArea)

Return _lRet
