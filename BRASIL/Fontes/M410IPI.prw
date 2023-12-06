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

User Function M410IPI() 


Local _nVlIpi  := VALORIPI 
Local  _nNfOr		:= aScan(aHeader,{|w| AllTrim(w[2])=="C6_NFORI"})
Local  _nProd       := aScan(aHeader,{|w| AllTrim(w[2])=="C6_PRODUTO"})
Local  _nTp       := aScan(aHeader,{|w| AllTrim(w[2])=="C6_OPER"})
Local  _ncli       := M->C5_CLIENTE
Local  _nLoj       := M->C5_LOJACLI


Local _cQuery       := ""


If FUnName()=="MATA410"


If Rtrim(aCols[n, _nTp]) $ getmv("ST_CONSIG") 

DbSelectArea("SD2")
DbSetOrder(3)
If DbSeek(xFilial("SD2")+aCols[n, _nNfOr]+"001"+_ncli+_nLoj+aCols[n,_nProd]) 
ALIQIPI := SD2->D2_IPI
_nVlIpi := BASEIPI *(ALIQIPI /100)
else
    
    If Select("TSD2") > 0
         DbSelectArea("TSD2")
         DbCloSeArea()
    Endif
    
    _cQuery := " SELECT SD2.*                                      "  
    _cQuery += " FROM "+Alltrim(SuperGetMV("STALIASIND",,"UDBP12"))+".SD2010 SD2                            "
    _cQuery += " WHERE SD2.D2_FILIAL = '02'  AND   "
    _cQuery += "       SD2.D_E_L_E_T_ <> '*'                 AND   "
    _cQuery += "       SD2.D2_DOC = '"+aCols[n, _nNfOr]+"'   AND   "
    _cQuery += "       SD2.D2_SERIE='001'                    AND   "
    _cQuery += "       SD2.D2_CLIENTE = '"+_ncli+"'          AND   "
    _cQuery += "       SD2.D2_LOJA    = '"+_nLoj+"'          AND   "
     _cQuery += "      SD2.D2_COD     = '"+aCols[n,_nProd]+"'   "

    
    
    TCQUERY _cQuery  NEW ALIAS "TSD2"
    _nRec   := 0
    DbEval({|| _nRec++  })

    If _nRec 
       DbSelectArea("TSD2")
       DbGotop()
       ALIQIPI := TSD2->D2_IPI
      _nVlIpi := BASEIPI *(ALIQIPI /100)
    Endif

Endif
Endif	
Endif


Return _nVlIpi 
