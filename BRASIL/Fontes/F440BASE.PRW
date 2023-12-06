#include "RWMAKE.CH"
#include "PROTHEUS.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  F440CBASE  º Autor ³ Giovani Zago        º Data ³  19/12/12  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ comissao                                                   º±±
±±º  Tipo    ³ Ponto de Entrada                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ STECK                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function F440BASE()
Local _aBase440	  := {}
Local _cPedComi   := ''
Local _cPedSer    := ''
Local _cPedTitu   := ''
Local _nValComi   := 0
Local _nValBase   := 0
Local _aXret	  := {}
Local _nPorBase   := 0
Local _nitemBase  := 0
Local _Lmomat     := (IsInCallSteck("MATA460") .Or. IsInCallSteck("MATA460A"))
Local _cComiss    := GETMV("ST_COMISS",,'01')

_cPedComi   := SE1->E1_PEDIDO
_cPedSer    := SE1->E1_SERIE
_cPedTitu   := SE1->E1_NUM
If _Lmomat 
_aBase440	  := Paramixb[1]
	DbSelectArea("SC6")
	SC6->(DbSetOrder(4))
	IF SC6->(DbSeek(xFilial("SC6")+_cPedTitu+_cPedSer))
		
		While SC6->(!Eof()) .and. SC6->C6_FILIAL = xFilial("SC6") .And.SC6->C6_NOTA = _cPedTitu    .And. SC6->C6_SERIE = _cPedSer
			_nitemBase++
			If SC6->C6_OPER $ _cComiss  
			_nValBase += SC6->C6_VALOR
			_nPorBase += SC6->C6_COMIS1 
			EndIf
			SC6->(DbSkip())
		End
		//cVendedor,;ParamIXB[2]SE1->E1_VLCRUZ,;ParamIXB[3]nBaseEmis,;ParamIXB[4]nBaseBaix,;ParamIXB[5]nVlrEmis,;ParamIXB[6]nVlrBaix,;ParamIXB[7]nPerComis
		aadd(_aXret,{ _aBase440[1],;  //VENDEDOR
		_aBase440[2],;  //VALOR CRUZ
		_nValBase   ,;     //BASE EMISSAO
		_aBase440[4],;  //BASE BAIXA
		_nValBase*(_aBase440[7]/100),; //VALOR EMISSA
		_aBase440[6],;  //VALOR BAIXA
		_nPorBase/_nitemBase })    //_aBase440[7]})  //PERCENTUAL
		
	Else
		_aXret := aclone(_aBase440)
	EndIf
Else
	_aXret := Paramixb
EndIf
Return (_aXret)


