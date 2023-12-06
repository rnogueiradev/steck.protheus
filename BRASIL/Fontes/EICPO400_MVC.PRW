/****************************************
Ação.........: Ponto de Entrada na rotina de Manutenção do P.O.
.............: Inclusão da chamada do fonte de Manutenção da Data de Entrega - MSTECK21 
Desenvolvedor: Marcelo Klopfer Leme
Data.........: 13/07/2022
Chamado......: 20220429009114 - Oferta Logística
****************************************/
#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"

USER FUNCTION EICPO400()
LOCAL cParamixb := iif( type("paramixb") == "A" .and. len(paramixb) > 0 , paramixb[1] , paramixb )

  DO CASE
    CASE cParamixb == "AROTINA"
         AADD(aRotina,{ "Altera Data",{|| U_MSTECK21()}, 0, 9 })
  END CASE
 
RETURN
