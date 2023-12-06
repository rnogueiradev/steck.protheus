#include 'Protheus.ch'
#include 'RwMake.ch'

/*====================================================================================\
|Programa  | STCUSTO1            | Autor | ANTONIO MOURA         | Data | 31/05/2023  |
|=====================================================================================|
|Descrição |  Retorna CUSTO DO PRODUTO		                                          |
|=====================================================================================|
|Sintaxe   | STCUSTO1                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

*---------------------------*

User Function STCUSTO1(_cProd)

	Local _aArea	:= GetArea()
	Local nCusto    :=0
    Local cOriFabX  :=''
	Local cQuery    :=""
	Local cGua      :=""
    Local cMao      :=""
	Local cEmp      :=""  
	Local cAliasCM	:= GetNextAlias()	
	Local cFilGua   := SuperGetMV("ES_FILGUA",,"05") 
	Local cFilMao   := SuperGetMV("ES_FILMAO",,"01") 

    cOriFabX  := AllTrim(U_STORIG(_cProd))

    cQuery := " SELECT B9_CM1 CM1 "
	IF cOriFabX == 'GUA'
	   cGua+= " FROM "+AllTrim(GetMv("STTMKG0311",,"UDBD02"))+".SB9010 SB9 "
	   cGua+= " INNER JOIN "+AllTrim(GetMv("STTMKG0311",,"UDBD02"))+".SB1010 SB1 ON SB1.B1_COD = SB9.B9_COD "
	   cGua+= " AND SB1.D_E_L_E_T_ = ' ' AND SB9.B9_LOCAL = SB1.B1_LOCPAD "
	   cGua+= " WHERE SB9.B9_FILIAL = '"+cFilgua+"' "
       cQuery+=cGua	
	ELSEIF cOriFabX =='MAO'
       cMao+= " FROM "+AllTrim(GetMv("STTMKG0311",,"UDBD02"))+".SB9030 SB9 "
	   cMao+= " INNER JOIN "+AllTrim(GetMv("STTMKG0311",,"UDBD02"))+".SB1030 SB1 ON SB1.B1_COD = SB9.B9_COD "
	   cMao+= " AND SB1.D_E_L_E_T_ = ' ' AND SB9.B9_LOCAL = SB1.B1_LOCPAD "
	   cMao+= " WHERE SB9.B9_FILIAL = '"+cFilMao+"' "
	   cQuery+=cMao
    ELSE 
       cEmp+= " FROM "+RETSQLNAME('SB9')+" SB9 " 
	   cEmp+= " INNER JOIN "+RETSQLNAME('SB1')+" SB1  ON SB1.B1_COD = SB9.B9_COD "
	   cEmp+= " AND SB1.D_E_L_E_T_ = ' ' AND SB9.B9_LOCAL = SB1.B1_LOCPAD "
	   cEmp+= " WHERE SB9.B9_FILIAL = '"+XFILIAL('SB9')+"' "
	   cQuery+=cEmp
    ENDIF
    cQuery+= " AND SB9.B9_COD = '"+_cProd+"' "
    cQuery+= " AND SB9.D_E_L_E_T_ = ' ' "
    cQuery+= " AND SB9.B9_DATA = ( SELECT MAX(SB9.B9_DATA) DATA "
    IF cOriFabX == 'GUA'
	   cQuery+=cGua 
	ELSEIF cOriFabX == 'MAO'    
       cQuery+=cMao
	ELSE    
       cQuery+=cEmp
	ENDIF   
    cQuery+= "  AND SB9.B9_COD    = '"+_cProd+"' "
    cQuery+= "  AND SB9.D_E_L_E_T_ = ' ' ) 

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasCM)
	dbSelectArea(cAliasCM)
	If  Select(cAliasCM) > 0
  	    (cAliasCM)->(dbgotop())
		nCusto  := (cAliasCM)->CM1
	EndIf
    (cAliasCM)->(dbCloseArea())	
    
    RestArea(_aArea) 

Return(round(nCusto,2))

