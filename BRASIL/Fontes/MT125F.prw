#include "Protheus.ch"

/*/{Protheus.doc} MT125F
description
Ponto de Entrada após gravação e Controle Alçada
Ticket: 20210623010642
@type function
@version  
@author Valdemir Jose
@since 29/06/2021
@return variant, return_description
/*/
user function MT125F
    Local lObrig     := getmv("ST_OBRGANX",.F.,.T.)

	if Inclui
       FWMsgRun(,{|| sleep(3000)},'Aguarde','Por favor, anexar os documentos')
		U_STAnexoV('SC3', 'ContratoParceria', {'C3_FILIAL','C3_USER','NOUSER'},lObrig,SC3->C3_NUM)

	endif

Return
