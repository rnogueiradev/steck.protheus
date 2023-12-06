#include "protheus.ch"

User Function PMSMONIT()

Local aRet := Paramixb[1]
Local _cEdtPai := AF9->AF9_EDTPAI
Local _cEdtDesc1 := Posicione("AFC",1,XFILIAL("AFC")+AF9->AF9_PROJET+AF9->AF9_REVISA+_cEdtPai,"AFC_DESCRI")
Local _cEdtn4    := Posicione("AFC",1,XFILIAL("AFC")+AF9->AF9_PROJET+AF9->AF9_REVISA+_cEdtPai,"AFC_EDTPAI")
Local _cEdtDesN4 := Posicione("AFC",1,XFILIAL("AFC")+AF9->AF9_PROJET+AF9->AF9_REVISA+_cEdtn4,"AFC_DESCRI")
Local _cEdtn3    := Posicione("AFC",1,XFILIAL("AFC")+AF9->AF9_PROJET+AF9->AF9_REVISA+_cEdtn4,"AFC_EDTPAI")
Local _cEdtDesN3 := Posicione("AFC",1,XFILIAL("AFC")+AF9->AF9_PROJET+AF9->AF9_REVISA+_cEdtn3,"AFC_DESCRI")
Local _cEdtn2    := Posicione("AFC",1,XFILIAL("AFC")+AF9->AF9_PROJET+AF9->AF9_REVISA+_cEdtn3,"AFC_EDTPAI")
Local _cEdtDesN2 := Posicione("AFC",1,XFILIAL("AFC")+AF9->AF9_PROJET+AF9->AF9_REVISA+_cEdtn2,"AFC_DESCRI")
Local _cEdtn1    := Posicione("AFC",1,XFILIAL("AFC")+AF9->AF9_PROJET+AF9->AF9_REVISA+_cEdtn2,"AFC_EDTPAI")
Local _cEdtDesN1 := Posicione("AFC",1,XFILIAL("AFC")+AF9->AF9_PROJET+AF9->AF9_REVISA+_cEdtn1,"AFC_DESCRI")

Aadd(aRet,{ "EDT Nivel 1", {_cEdtDesN1, CLR_BLACK} })
Aadd(aRet,{ "EDT Nivel 2", {_cEdtDesN2, CLR_BLACK} })
Aadd(aRet,{ "EDT Nivel 3", {_cEdtDesN3, CLR_BLACK} })
Aadd(aRet,{ "EDT Nivel 4", {_cEdtDesN4, CLR_BLACK} })
Aadd(aRet,{ "EDT da Tarefa", {_cEdtDesc1, CLR_BLACK} })

Return aRet

