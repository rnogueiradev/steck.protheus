#INCLUDE "RWMAKE.CH"

User function AcOpRes
       

Dbselectarea("SC2")
DbGotop()

Do While !eof()

	Dbselectarea("CB7")
	CB7->(DbSetOrder(5))
	CB7->(DbSeek(xFilial("CB7")+SC2->(C2_NUM+C2_ITEM+C2_SEQUEN)) )
	 
	IF EOF()     
		Dbselectarea("SC2")
	    U_MTA381GRV()
	ENDIF

	Dbselectarea("SC2")
	Dbskip()

Enddo
