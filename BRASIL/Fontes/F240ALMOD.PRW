#Include 'Protheus.ch'
#Include "Rwmake.ch"
#Include "TopConn.ch"


/*/{Protheus.doc} F240ALMOD
(Ponto de Entrada para geração de SISPAG GNRE)

@author jefferson.carlos
@since 31/08/2017
@version MP11

/*/



User Function F240ALMOD()  
 

Local cModelo := ParamIxb[1]

If cModelo == "91"  // GNRE

   cModelo := "13"  // Modelo 13

EndIf

Return cModelo 


