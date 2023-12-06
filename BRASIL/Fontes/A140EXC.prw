#INCLUDE "PROTHEUS.CH"

/*/{Protheus.doc} A140EXC
description
Ponto de Entrada Exclusão da Pre Nota
Ticket: 20210111000540
@type function
@version  
@author Valdemir Jose
@since 16/02/2021
@return return_type, return_description
/*/
User Function A140EXC()
    Local lRet := .T.
    Local aAreaZ9 := GetArea()

    // Ponto de chamada ConexãoNF-e sempre como primeira instrução.
    lRet := U_GTPE003()

    dbSelectArea("SZ9")
    dbSetorder(1)
    if dbSeek(xFilial("SZ9")+SF1->F1_CHVNFE)
       RecLock("SZ9",.F.)
       SZ9->Z9_DOC   := ""
       SZ9->Z9_GEROU := ""
       MsUnLock()
    endif

    RestArea( aAreaZ9 )
    
Return lRet
