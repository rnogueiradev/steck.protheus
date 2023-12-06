#INCLUDE "Totvs.ch"

/*====================================================================================\
|Programa  | XGETCEST       | Autor | giovani.zago            | Data | 23/03/2016  |
|=====================================================================================|
|Descrição | Fonte utilizado para retornar o CEST baseado no NCM                      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   |                                                                          |
|=====================================================================================|
|Uso       | Customização para Steck                                                  |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function XGETCEST(_cNcm)
	
	Local _cCest	:= ""
	Local _aCest	:= {}
	Local _nX		:= 0
	
	_cNcm := AllTrim(_cNcm)
	
	//Se precisar atualizar utilizar no excel =CONCATENAR("AADD(_aCest,{'";A2;"','";C2;"'})")
	//NCM,CEST
	AADD(_aCest,{'32149000','1000300'})
	AADD(_aCest,{'39162000','1000500'})
	AADD(_aCest,{'39169090','1000500'})
	AADD(_aCest,{'39171029','1000600'})
	AADD(_aCest,{'39172300','1000600'})
	AADD(_aCest,{'39172900','1000600'})
	AADD(_aCest,{'39173100','1000600'})
	AADD(_aCest,{'39173900','1000600'})
	AADD(_aCest,{'39174090','1000600'})
	AADD(_aCest,{'39191000','1000900'})
	AADD(_aCest,{'39199000','1000900'})
	AADD(_aCest,{'39201010','1000900'})
	AADD(_aCest,{'39201099','1000900'})
	AADD(_aCest,{'39202090','1000900'})
	AADD(_aCest,{'39205900','1000900'})
	AADD(_aCest,{'39206100','1000900'})
	AADD(_aCest,{'39206219','1000900'})
	AADD(_aCest,{'39209990','1000900'})
	AADD(_aCest,{'39211200','1000900'})
	AADD(_aCest,{'39211900','1000900'})
	AADD(_aCest,{'39219019','1000900'})
	AADD(_aCest,{'39222000','1001300'})
	AADD(_aCest,{'39229000','1001300'})
	AADD(_aCest,{'39241000','1001400'})
	AADD(_aCest,{'39249000','1001400'})
	AADD(_aCest,{'39252000','1001800'})
	AADD(_aCest,{'39253000','1001900'})
	AADD(_aCest,{'39259090','1001700'})
	AADD(_aCest,{'39269010','1002000'})
	AADD(_aCest,{'39269021','1002000'})
	AADD(_aCest,{'39269040','1002000'})
	AADD(_aCest,{'39269090','1002000'})
	AADD(_aCest,{'70072900','1003700'})
	AADD(_aCest,{'72131000','1004300'})
	AADD(_aCest,{'72172090','1004500'})
	AADD(_aCest,{'73071920','1004600'})
	AADD(_aCest,{'73071990','1004600'})
	AADD(_aCest,{'73072900','1004600'})
	AADD(_aCest,{'73079200','1004600'})
	AADD(_aCest,{'73079900','1004600'})
	AADD(_aCest,{'73084000','1004800'})
	AADD(_aCest,{'73089010','1004800'})
	AADD(_aCest,{'73089090','1004800'})
	AADD(_aCest,{'73141400','1005300'})
	AADD(_aCest,{'73144900','1005300'})
	AADD(_aCest,{'73151290','1005500'})
	AADD(_aCest,{'73158200','1005600'})
	AADD(_aCest,{'73170090','1005700'})
	AADD(_aCest,{'73181200','1005800'})
	AADD(_aCest,{'73181300','1005800'})
	AADD(_aCest,{'73181400','1005800'})
	AADD(_aCest,{'73181500','1005800'})
	AADD(_aCest,{'73181600','1005800'})
	AADD(_aCest,{'73181900','1005800'})
	AADD(_aCest,{'73182100','1005800'})
	AADD(_aCest,{'73182200','1005800'})
	AADD(_aCest,{'73182300','1005800'})
	AADD(_aCest,{'73182900','1005800'})
	AADD(_aCest,{'73231000','1005900'})
	AADD(_aCest,{'73239100','1005900'})
	AADD(_aCest,{'73259990','1006100'})
	AADD(_aCest,{'73261900','1006200'})
	AADD(_aCest,{'73269090','1006200'})
	AADD(_aCest,{'74071010','1006300'})
	AADD(_aCest,{'74071029','1006300'})
	AADD(_aCest,{'74072110','1006300'})
	AADD(_aCest,{'74072910','1006300'})
	AADD(_aCest,{'74111010','1006400'})
	AADD(_aCest,{'74122000','1006500'})
	AADD(_aCest,{'74130000','1200600'})
	AADD(_aCest,{'74152900','1006600'})
	AADD(_aCest,{'74153900','1006600'})
	AADD(_aCest,{'76090000','1007000'})
	AADD(_aCest,{'76161000','1007100'})
	AADD(_aCest,{'76169900','1007100'})
	AADD(_aCest,{'83011000','1007500'})
	AADD(_aCest,{'83014000','1007500'})
	AADD(_aCest,{'83015000','1007500'})
	AADD(_aCest,{'83016000','1007500'})
	AADD(_aCest,{'83111000','1007800'})
	AADD(_aCest,{'83119000','1007800'})
	AADD(_aCest,{'84812090','1007900'})
	AADD(_aCest,{'84818092','1007900'})
	AADD(_aCest,{'84818096','1007900'})
	AADD(_aCest,{'84819010','1007900'})
	AADD(_aCest,{'85041000','1200100'})
	AADD(_aCest,{'85043111','1200100'})
	AADD(_aCest,{'85043119','1200100'})
	AADD(_aCest,{'85043211','1200100'})
	AADD(_aCest,{'85043221','1200100'})
	AADD(_aCest,{'85043300','1200100'})
	AADD(_aCest,{'85045000','1200100'})
	AADD(_aCest,{'85168090','1200200'})
	AADD(_aCest,{'85311090','2111400'})
	AADD(_aCest,{'85318000','2111500'})
	AADD(_aCest,{'85319000','2111300'})
	AADD(_aCest,{'85353011','1200300'})
	AADD(_aCest,{'85354090','1200300'})
	AADD(_aCest,{'85359000','1200300'})
	AADD(_aCest,{'85361000','1200400'})
	AADD(_aCest,{'85362000','1200400'})
	AADD(_aCest,{'85363000','1200400'})
	AADD(_aCest,{'85364100','1200400'})
	AADD(_aCest,{'85364900','1200400'})
	AADD(_aCest,{'85365020','1200400'})
	AADD(_aCest,{'85365090','1200400'})
	AADD(_aCest,{'85366100','1200400'})
	AADD(_aCest,{'85366910','1200400'})
	AADD(_aCest,{'85366990','1200400'})
	AADD(_aCest,{'85369040','1200400'})
	AADD(_aCest,{'85369090','1200400'})
	AADD(_aCest,{'85381000','1200500'})
	AADD(_aCest,{'85389010','1200500'})
	AADD(_aCest,{'85389020','1200500'})
	AADD(_aCest,{'85389090','1200500'})
	AADD(_aCest,{'85441990','1200700'})
	AADD(_aCest,{'85444200','1200700'})
	AADD(_aCest,{'85444900','1200700'})
	AADD(_aCest,{'85447090','1200700'})
	AADD(_aCest,{'85469000','1200800'})
	AADD(_aCest,{'85479000','1200900'})

	For _nX:=1 To Len(_aCest)
		If AllTrim(_aCest[_nX][1])==AllTrim(_cNcm)
			_cCest	:= _aCest[_nX][2]
		EndIf
	Next
	
Return(_cCest)

User Function XGETCES1()

	RpcSetType( 3 )
	RpcSetEnv("01","01",,,"FAT")
	
	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))
	While SB1->(!Eof())
	
		Conout("["+cEmpAnt+"] - Atualizando produto: "+SB1->B1_COD)
		
		SB1->(RecLock("SB1",.F.))
		SB1->B1_CEST := U_XGETCEST(SB1->B1_POSIPI)
		SB1->(MsUnLock())
	 
		SB1->(DbSkip())
	EndDo
	
	MsgAlert("Rotina Finalizada!")
	
Return()

User Function XGETCES2()

	RpcSetType( 3 )
	RpcSetEnv("03","01",,,"FAT")
	
	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))
	While SB1->(!Eof())
	
		Conout("["+cEmpAnt+"] - Atualizando produto: "+SB1->B1_COD)
		
		SB1->(RecLock("SB1",.F.))
		SB1->B1_CEST := U_XGETCEST(SB1->B1_POSIPI)
		SB1->(MsUnLock())
	 
		SB1->(DbSkip())
	EndDo
	
	MsgAlert("Rotina Finalizada!")
	
Return()