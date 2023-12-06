#INCLUDE "Protheus.ch"

/*/{Protheus.doc} A415TDOK
description
Ponto de Entrada TudpOK. Utilizado para tratar o prazo de entrega
chamado: 20200806005285
@type function
@version 
@author Valdemir Jose
@since 27/08/2020
@return return_type, return_description
/*/
USER FUNCTION A415TDOK()
    Local aArea1 	:= SCJ->(Getarea())
    Local aArea2  	:= TMP1->(Getarea())

    dbSelectArea("TMP1")
    TMP1->(dbGoTop())

    While TMP1->( !Eof() )
        // Valida Prazo Entrega
        FWMsgRun(,{|| u_STGTLPE4() }, 'Informação', 'Aguarde, validando prazo de entrega')

        //Pula para o proximo registro
        TMP1->(dbskip()) 
    EndDo

    RestArea(aArea1) //Volta o posicionamento da SCJ 	
    RestArea(aArea2) //Volta o posicionamento da TMP1 	

RETURN .T.