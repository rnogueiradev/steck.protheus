#Include 'Protheus.ch'

/*/{Protheus.doc} MTCOLSE2
Ponto de entrada para alterar a data de vencimento do titulo na nota fiscal de entrada, caso o titulo já esteja vencido
@author Robson Mazzarotto
@since 29/06/2017
@version 1.0
Chamado 005629
/*/


User Function MTCOLSE2()

Local aSE2    := ParamIXB[1]
Local _dDtVc  := ParamIXB[1][1][2]
Local _cTime  := Time()
Local _dDtAtu := Date()

 // Ponto de chamada ConexãoNF-e sempre como primeira instrução.
    aSE2 := U_GTPE013()


if _dDtVc < _dDtAtu 

	If _cTime < "14:00:00"
		ParamIXB[1][1][2] := _dDtAtu 
	else
		ParamIXB[1][1][2] := DataValida(_dDtAtu + 1, .T.)
	Endif

Endif

Return aSE2

