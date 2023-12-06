#INCLUDE "TOTVS.CH"
#INCLUDE "RWMAKE.CH"

/*/{Protheus.doc} STTIRAGR
@name STTIRAGR
@type User Function
@desc retirar caracteres especiais
@author Renato Nogueira
@since 29/05/2018
/*/

User Function STTIRAGR(_cStrRec)

Default _cStrRec := ""

   _cStrRec = StrTran (_cStrRec, "á", "a")
   _cStrRec = StrTran (_cStrRec, "é", "e")
   _cStrRec = StrTran (_cStrRec, "í", "i")
   _cStrRec = StrTran (_cStrRec, "ó", "o")
   _cStrRec = StrTran (_cStrRec, "ú", "u")
   _cStrRec = StrTran (_cStrRec, "Á", "A")
   _cStrRec = StrTran (_cStrRec, "É", "E")
   _cStrRec = StrTran (_cStrRec, "Í", "I")
   _cStrRec = StrTran (_cStrRec, "Ó", "O")
   _cStrRec = StrTran (_cStrRec, "Ú", "U")
   _cStrRec = StrTran (_cStrRec, "ã", "a")
   _cStrRec = StrTran (_cStrRec, "õ", "o")
   _cStrRec = StrTran (_cStrRec, "Ã", "A")
   _cStrRec = StrTran (_cStrRec, "Õ", "O")
   _cStrRec = StrTran (_cStrRec, "â", "a")
   _cStrRec = StrTran (_cStrRec, "ê", "e")
   _cStrRec = StrTran (_cStrRec, "î", "i")
   _cStrRec = StrTran (_cStrRec, "ô", "o")
   _cStrRec = StrTran (_cStrRec, "û", "u")
   _cStrRec = StrTran (_cStrRec, "Â", "A")
   _cStrRec = StrTran (_cStrRec, "Ê", "E")
   _cStrRec = StrTran (_cStrRec, "Î", "I")
   _cStrRec = StrTran (_cStrRec, "Ô", "O")
   _cStrRec = StrTran (_cStrRec, "Û", "U")
   _cStrRec = StrTran (_cStrRec, "ç", "c")
   _cStrRec = StrTran (_cStrRec, "Ç", "C")
   _cStrRec = StrTran (_cStrRec, "à", "a")
   _cStrRec = StrTran (_cStrRec, "À", "A")
   _cStrRec = StrTran (_cStrRec, "º", ".")
   _cStrRec = StrTran (_cStrRec, "ª", ".")
   _cStrRec = StrTran (_cStrRec, chr (9), " ")
   _cStrRec = StrTran (_cStrRec, "Ø", "")
   _cStrRec = StrTran (_cStrRec, "ø", "")
   _cStrRec = StrTran (_cStrRec, '"', '')
   _cStrRec = StrTran (_cStrRec, '”', '')
   _cStrRec = StrTran (_cStrRec, "&", "E")
   
   _cStrRet := _cStrRec

Return(_cStrRet)
