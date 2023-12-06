#include "rwmake.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ'ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CORRECAOบAutor  ณANTONIO MOURA        บ Data ณ  22/08/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ AXATIVO                                                     ฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "Fileio.ch"
#include "Totvs.ch"

#Define CRLF Chr(13)+ Chr(10)

User Function LECSV()

Local cAlias:=""

RpcClearEnv()
RpcSetType(3)
RpcSetEnv("11","01",,,"FAT")	


cAlias := GetNextAlias()

cQuery := " SELECT SA2.A2_COD,SA2.A2_LOJA,SA2.A2_NOME,SA2.A2_MSBLQL,A2_DVCTA,A2_X_DVCTA,FIL_DVCTA,A2_X_DVAGE,A2_DVAGE,FIL_DVAGE "
cQuery += " FROM SA2110 SA2 "
cQuery += " LEFT JOIN FIL110 FIL ON FIL.FIL_FORNEC = SA2.A2_COD AND FIL.FIL_LOJA = SA2.A2_LOJA AND FIL_CONTA = SA2.A2_NUMCON AND FIL.D_E_L_E_T_ = ' ' "
cQuery += " WHERE SA2.D_E_L_E_T_ = ' '  "
cQuery += " AND ( ( A2_DVCTA= ' ' AND (A2_X_DVCTA<>' ' OR FIL_DVCTA<>' ' )) OR ( A2_DVAGE= ' ' AND (A2_X_DVAGE<>' ' OR FIL_DVAGE<>' ' )) ) "

DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAlias,.T.,.T.)
IF (cAlias)->( ! Eof())
   While (cAlias)->( ! Eof())
       SA2->(DBSETORDER(1))
	   IF SA2->(DBSEEK(XFILIAL('SA2')+(cAlias)->A2_COD+(cAlias)->A2_LOJA))

		  IF EMPTY(SA2->A2_DVCTA) 
		     IF ! EMPTY(SA2->A2_X_DVCTA)
			    SA2->(RECLOCK('SA2',.F.))
			    SA2->A2_DVCTA:=SA2->A2_X_DVCTA
	 	        SA2->(MSUNLOCK())
			 ELSEIF ! EMPTY((cAlias)->FIL_DVCTA)
		        SA2->(RECLOCK('SA2',.F.))
			    SA2->A2_DVCTA:=(cAlias)->FIL_DVCTA
	 	        SA2->(MSUNLOCK())
			 ENDIF	
		  ENDIF	 
          
		  IF EMPTY(SA2->A2_DVAGE) 
		     IF ! EMPTY(SA2->A2_X_DVAGE)
			    SA2->(RECLOCK('SA2',.F.))
			    SA2->A2_DVAGE:=SA2->A2_X_DVAGE
	 	        SA2->(MSUNLOCK())
			 ELSEIF ! EMPTY((cAlias)->FIL_DVAGE)
		        SA2->(RECLOCK('SA2',.F.))
			    SA2->A2_DVAGE:=(cAlias)->FIL_DVAGE
	 	        SA2->(MSUNLOCK())
			 ENDIF	
		  ENDIF	 

       ENDIF
   (cAlias)->(DBSKIP())
   ENDDO 
ENDIF

(cAlias)->( DbcloseArea())

Return()

