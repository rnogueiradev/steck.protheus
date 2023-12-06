/****************************************
Definição....: Ponto de entrada na rotina de Medição de Contrato - Encerramento de contrato
.............: Foi criado o ponto de entrada para que após o encerramento da medição seja chamada a rotina de impressão de pedido de comrpa "RSTFAT92"
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
  Efetua as validações para saber se o pedido foi gerado, se foi chamado através da rotina de encerramento.
  Rotina de encerramento: "CN121Encerr"
  "CNDMASTER" - Estou utilizando esta chamada para saber que está no cabeçalho do pedido e não ficar gerando várias impressões.
  *********************/
  IF cIdPonto == "FORMCOMMITTTSPRE" .AND. IsInCallStack("CN121Encerr") = .T. .AND. !EMPTY(SC7->C7_NUM) .AND. cIdModel = "CNDMASTER"
    U_RSTFAT92(.F.)
  ENDIF
ENDIF


RETURN .T.
