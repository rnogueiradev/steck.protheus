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

   _cStrRec = StrTran (_cStrRec, "�", "a")
   _cStrRec = StrTran (_cStrRec, "�", "e")
   _cStrRec = StrTran (_cStrRec, "�", "i")
   _cStrRec = StrTran (_cStrRec, "�", "o")
   _cStrRec = StrTran (_cStrRec, "�", "u")
   _cStrRec = StrTran (_cStrRec, "�", "A")
   _cStrRec = StrTran (_cStrRec, "�", "E")
   _cStrRec = StrTran (_cStrRec, "�", "I")
   _cStrRec = StrTran (_cStrRec, "�", "O")
   _cStrRec = StrTran (_cStrRec, "�", "U")
   _cStrRec = StrTran (_cStrRec, "�", "a")
   _cStrRec = StrTran (_cStrRec, "�", "o")
   _cStrRec = StrTran (_cStrRec, "�", "A")
   _cStrRec = StrTran (_cStrRec, "�", "O")
   _cStrRec = StrTran (_cStrRec, "�", "a")
   _cStrRec = StrTran (_cStrRec, "�", "e")
   _cStrRec = StrTran (_cStrRec, "�", "i")
   _cStrRec = StrTran (_cStrRec, "�", "o")
   _cStrRec = StrTran (_cStrRec, "�", "u")
   _cStrRec = StrTran (_cStrRec, "�", "A")
   _cStrRec = StrTran (_cStrRec, "�", "E")
   _cStrRec = StrTran (_cStrRec, "�", "I")
   _cStrRec = StrTran (_cStrRec, "�", "O")
   _cStrRec = StrTran (_cStrRec, "�", "U")
   _cStrRec = StrTran (_cStrRec, "�", "c")
   _cStrRec = StrTran (_cStrRec, "�", "C")
   _cStrRec = StrTran (_cStrRec, "�", "a")
   _cStrRec = StrTran (_cStrRec, "�", "A")
   _cStrRec = StrTran (_cStrRec, "�", ".")
   _cStrRec = StrTran (_cStrRec, "�", ".")
   _cStrRec = StrTran (_cStrRec, chr (9), " ")
   _cStrRec = StrTran (_cStrRec, "�", "")
   _cStrRec = StrTran (_cStrRec, "�", "")
   _cStrRec = StrTran (_cStrRec, '"', '')
   _cStrRec = StrTran (_cStrRec, '�', '')
   _cStrRec = StrTran (_cStrRec, "&", "E")
   
   _cStrRet := _cStrRec

Return(_cStrRet)
