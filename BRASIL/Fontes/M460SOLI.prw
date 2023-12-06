#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M410IPI ºAutor  ³Cristiano Pereira        º Data ³  12/11/09 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada , para recompor o IPI , operação Selia   mº±±
±±º          ³                                                            º±± 
±±º          ³                                                 			  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ STECK						                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function M460SOLI() 


Local _nVlIPI       := 0
Local  _nNfOr		:= SC6->C6_NFORI
Local  _nNfT		:= SC6->C6_VALOR
Local _nCli         := SC6->C6_CLI
Local _nLoj         := SC6->C6_LOJA
Local _nPrd         := SC6->C6_PRODUTO
Local _nAlIc        := 0
Local _nMargem      := 0
Local _aSolid       :={}
Local _cQuery       :=""


If  FUnName()=="MATA460" .Or. FUnName()=="MATA460A" .oR. FUnName()=="STNFSAIDA"

If Rtrim(SC6->C6_OPER) $ getmv("ST_CONSIG") 

DbSelectArea("SD2")
DbSetOrder(3)
If DbSeek(xFilial("SD2")+_nNfOr+"001"+_nCli+ _nLoj+_nPrd) 
ALIQIPI := SD2->D2_IPI
_nVlIPI   := BASEIPI *(ALIQIPI /100)
_nMargem  := SD2->D2_MARGEM
_nAlIc    := SD2->D2_PICM

aAdd(  _aSolid  , ((_nNfT+_nVlIPI)*(1+(_nMargem/100)))  )
aAdd(  _aSolid  , ((((_nNfT+_nVlIPI)*(1+(_nMargem/100))))*(_nAlIc/100))-(_nNfT*(_nAlIc/100))  )

else
    
        If Select("TSD2") > 0
         DbSelectArea("TSD2")
         DbCloSeArea()
    Endif
    
     _cQuery := " SELECT SD2.*                                      "  
    _cQuery += " FROM "+Alltrim(SuperGetMV("STALIASIND",,"UDBP12"))+".SD2010 SD2                            "
    _cQuery += " WHERE SD2.D2_FILIAL = '02'  AND   "
    _cQuery += "       SD2.D_E_L_E_T_ <> '*'                 AND   "
    _cQuery += "       SD2.D2_DOC = '"+_nNfOr+"'   AND   "
    _cQuery += "       SD2.D2_SERIE='001'                    AND   "
    _cQuery += "       SD2.D2_CLIENTE = '"+_ncli+"'          AND   "
    _cQuery += "       SD2.D2_LOJA    = '"+_nLoj+"'          AND   "
     _cQuery += "      SD2.D2_COD     = '"+_nPrd+"'  "

    
    TCQUERY _cQuery  NEW ALIAS "TSD2"
    _nRec   := 0
    DbEval({|| _nRec++  })

    If _nRec > 0
      DbSelectArea("TSD2")
       DbGotop()
  ALIQIPI := TSD2->D2_IPI
_nVlIPI   := BASEIPI *(ALIQIPI /100)
_nMargem  := TSD2->D2_MARGEM
_nAlIc    := TSD2->D2_PICM

If _nMargem  > 0

aAdd(  _aSolid  , ((_nNfT+_nVlIPI)*(1+(_nMargem/100)))  )
aAdd(  _aSolid  , ((((_nNfT+_nVlIPI)*(1+(_nMargem/100))))*(_nAlIc/100))-(_nNfT*(_nAlIc/100))  )
else
  aAdd(  _aSolid  , 0  )
aAdd(  _aSolid  , 0  )
Endif

Endif

Endif
Endif	
Endif

Return(_aSolid)
