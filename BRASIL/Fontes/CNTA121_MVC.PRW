/****************************************
Defini��o....: Ponto de entrada na rotina de Medi��o de Contrato - Encerramento de contrato
.............: Foi criado o ponto de entrada para que ap�s o encerramento da medi��o seja chamada a rotina de impress�o de pedido de comrpa "RSTFAT92"
Desenvolvedor: Marcelo Klopfer Leme
Data.........: 12/07/2022
Chamado......: 20220630013160
*************************************/
#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "TOPCONN.CH"
#DEFINE CL CHR(13)+CHR(10)

USER FUNCTION CNTA121()
LOCAL aParam     := PARAMIXB
LOCAL oObj       := ""
LOCAL cIdPonto   := ""
LOCAL cIdModel   := ""

IF aParam <> NIL
      
  oObj       := aParam[1]
  cIdPonto   := aParam[2]
  cIdModel   := aParam[3]
             
  /*********************
  Efetua as valida��es para saber se o pedido foi gerado, se foi chamado atrav�s da rotina de encerramento.
  Rotina de encerramento: "CN121Encerr"
  "CNDMASTER" - Estou utilizando esta chamada para saber que est� no cabe�alho do pedido e n�o ficar gerando v�rias impress�es.
  *********************/
  IF cIdPonto == "FORMCOMMITTTSPRE" .AND. IsInCallStack("CN121Encerr") = .T. .AND. !EMPTY(SC7->C7_NUM) .AND. cIdModel = "CNDMASTER"
    U_RSTFAT92(.F.)
  ENDIF
ENDIF


RETURN .T.
