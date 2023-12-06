#Include 'Protheus.ch'

/*/{Protheus.doc} STALTDTPE
Função para verificar a permissão de manipulação da data de entrega do pedido de compra.
@author Robson Mazzarotto
@since 26/09/2017
@version 1.0
/*/

User Function STALTDTPE()

Local nRet := .F.

if INCLUI .AND. __cuserid $ Getmv("ST_ALTPC",,"")                           

nRet := .T.

ELSEIF ALTERA .AND. SC7->C7_FORNECE = "000032" // SOMENTE PARA CECIL

nRet := .T.

ENDIF

Return nRet

