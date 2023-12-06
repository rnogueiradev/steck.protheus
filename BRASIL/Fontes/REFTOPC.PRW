#INCLUDE "TOTVS.CH"
User Function REFTOC()
	
	cBase := ""

	cStrBase:= AllTrim(cBase)
	cStrSrv	:= AllTrim(cServer)
	cStrPort:= AllTrim(cPorta)
	cStrLnk	:= cStrBase + "@" + cStrSrv + ":" + cStrPort

TcLink()
TCRefresh("SC5")
 TcUnlink()

Return(  )