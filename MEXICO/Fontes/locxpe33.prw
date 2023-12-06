#INCLUDE "Rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLOCXPE33  บ                            บ Data ณ  04/04/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ CAMBIA LA PROPIEDAD DEL CAMPO OBSERVACIONES EN FACTURA DE   ฑฑ   
ฑฑบ          ณ ENTRADA                                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function LOCXPE33()
aCposFact 	:= {}         
aCposFact 	:= Paramixb[1]
_cTipoDoc 	:= Paramixb[2]


IF OAPP:CMODNAME == "SIGAFAT"                                                                              
    IF aCposFact[1][2] <> 'F1_FORNECE' .AND. nNFTipo == 50 
//      aAdd(aCposFact,{NIL,"F2_ORDENC",NIL,NIL,NIL,"",NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,".T."})  
      aAdd(aCposFact,{NIL,"F2_ORDENC",NIL            ,NIL            ,NIL            ,""  ,NIL          ,NIL         ,NIL   ,NIL            ,NIL,NIL,NIL,NIL,NIL, ""   ,".T."})  
      aAdd(aCposFact,{NIL,"F2_TIPOENT",NIL            ,NIL            ,NIL            ,""  ,NIL          ,NIL         ,NIL   ,NIL            ,NIL,NIL,NIL,NIL,NIL, "Z1"   ,".T."})  
      aAdd(aCposFact,{NIL,"F2_PAQUET" ,NIL            ,NIL            ,NIL            ,""  ,NIL          ,NIL         ,NIL   ,NIL            ,NIL,NIL,NIL,NIL,NIL, "Z2"   ,".T."})  
      aAdd(aCposFact,{NIL,"F2_TIPOSER",NIL            ,NIL            ,NIL            ,""  ,NIL          ,NIL         ,NIL   ,NIL            ,NIL,NIL,NIL,NIL,NIL,        ,".T."})  
      aAdd(aCposFact,{NIL,"F2_CONVENI",NIL            ,NIL            ,NIL            ,""  ,NIL          ,NIL         ,NIL   ,NIL            ,NIL,NIL,NIL,NIL,NIL,        ,".T."})  
      aAdd(aCposFact,{NIL,"F2_DESTINO",NIL            ,NIL            ,NIL            ,""  ,NIL          ,NIL         ,NIL   ,NIL            ,NIL,NIL,NIL,NIL,NIL,        ,".T."})  
      //	{X3Titulo()  ,"F2_CAI"  ,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,cVld,SX3->X3_USADO,SX3->X3_TIPO, "SF2",SX3->X3_CONTEXT,   ,   ,   ,   ,   ,SX3->X3_F3,cWhen}

    Endif

Endif
Return(aCposFact)    

