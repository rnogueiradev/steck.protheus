#include "PROTHEUS.CH"
#include "RWMAKE.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M462GRV ºAutor  ³Alejandro de los Reyes ºFecha ³ 29/07/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Graba Datos En Remision Automática                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Facturacion                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function M462GRV()
__aArea:= Getarea()
    _aHeadSF2	:=PARAMIXB[1]
    aSF2		:=PARAMIXB[2]  
    _nx			:=PARAMIXB[7] 

    Private nPosDoc			:= ASCAN(PARAMIXB[1],{|_nx| Alltrim(_nx) == "F2_DOC"  })  
    Private nPosSerie		:= ASCAN(PARAMIXB[1],{|_nx| Alltrim(_nx) == "F2_SERIE"  })  
    Private nPosCliente		:= ASCAN(PARAMIXB[1],{|_nx| Alltrim(_nx) == "F2_CLIENTE"  })  
    Private nPosLoja		:= ASCAN(PARAMIXB[1],{|_nx| Alltrim(_nx) == "F2_LOJA"  })  
    Private nPosTipE        := ASCAN(PARAMIXB[1],{|_nx| Alltrim(_nx) == "F2_TIPOENT"  })  
    Private nPosPaquet		:= ASCAN(PARAMIXB[1],{|_nx| Alltrim(_nx) == "F2_PAQUET"  })  
    Private nPosTipS		:= ASCAN(PARAMIXB[1],{|_nx| Alltrim(_nx) == "F2_TIPOSER"  })  
    Private nPosDestino		:= ASCAN(PARAMIXB[1],{|_nx| Alltrim(_nx) == "F2_DESTINO"  })  
    Private nPosConveni		:= ASCAN(PARAMIXB[1],{|_nx| Alltrim(_nx) == "F2_CONVENI"  })  
 
    cDocSF2	:= PARAMIXB[2][_nx][nPosDoc] 
    cSerSF2	:= PARAMIXB[2][_nx][nPosSerie]
    cCliente:= PARAMIXB[2][_nx][nPosCliente]
    cTienda	:= PARAMIXB[2][_nx][nPosLoja]
    cNombre	:= SA1->A1_NOME 

    cTipoEnt            := SC5->C5_TIPOENT
    cPaquet             := SC5->C5_PAQUET
    cTipoSer            := SC5->C5_TIPOSER
    cDestino            := SC5->C5_DESTINO
    cConveni            := SC5->C5_CONVENI

    aSF2[_nx][nPosTipE]		:=cTipoEnt
    aSF2[_nx][nPosPaquet]	:=cPaquet
    aSF2[_nx][nPosTipS]		:=cTipoSer
    aSF2[_nx][nPosDestino]	:=cDestino
    aSF2[_nx][nPosConveni]	:=cConveni

    MsgStop("Se ha Generado la Remision: "+cSerSF2+" "+cDocSF2+ " Cliente: "+cNombre)

RestArea(__aArea)
Return  



//GRABA DATOS DEL FOLIO GRABADO EN LA REMISION HACIA EL MOVIMIENTO DEL LOTE
//ESE FOLIO VIENE DESDE SC5 HACIA LA SF2
USER FUNCTION MTGRVSD5
    _cDoc   := SD5->D5_DOC
    _cSerie := SD5->D5_SERIE
    _aAreaSF2  := Getarea("SF2")
    DbSelectArea("SF2")
    DbSetOrder(1)
    IF DbSeek(xFilial("SF2")+_cDoc+_cSerie)
        DbSelectArea("SD5")
        Reclock("SD5",.F.)
        SD5->D5_FOLIO := SF2->F2_FOLIO
        Msunlock()
    Endif
    Restarea(_aAreaSF2)
Return



