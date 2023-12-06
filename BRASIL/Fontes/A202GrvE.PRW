#INCLUDE "PROTHEUS.CH" 
#INCLUDE "TOPCONN.CH"

//--------------------------------------------------------------
/*/{Protheus.doc} Function AjusPeso
Description                                                     
Ponto de Entrada na gravação da estrutura. Rotina fara ajuste nos pesos
@author Valdemir Rabelo - valdemir.rabelo@sigamat.com.br                                             
@since 23/09/2019                                                   
/*/                                                             
//-------------------------------------
USER FUNCTION A202GrvE()

    //FWMsgRun(,{|| StaticCall (MTA202, AjusPeso ) },,"Aguarde, Validando e ajustando peso.")
      FWMsgRun(,{|| U_AjusPeso(SGG->GG_COD)  },,"Aguarde, Validando e ajustando peso.")

RETURN
