#INCLUDE "PROTHEUS.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STPRESCOM  ºAutor  ³Joao Rinaldi       º Data ³  17/03/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Regra para indicação da Presença Comercial no Pedido       º±±
±±º          ³ de Venda executado a partir do gatilho do código do clienteº±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ STECK                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STPRESCOM()
	
	Local _aArea       := GetArea()
	Local _aAreaSA1    := SA1->( GetArea() )
	Local _aAreaSC5    := SC5->( GetArea() )
	Local _lRet        := .T.
	Local nVal         := 0
	Local _cGrpCli     := ""
	Local _cIndPres    := ""
	
	
	dbSelectArea("SA1")
	dbSetorder(1)//A1_FILIAL+A1_COD+A1_LOJA
	If ( Type("l410Auto") == "U" .OR. !l410Auto )
		If SA1->( dbSeek( xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI ))
			_cGrpCli := SA1->A1_GRPVEN
		Endif
		
		If cEmpAnt == '01'
			If Alltrim(_cGrpCli) = 'ST'
				_cIndPres = '0'
			ElseIf ( M->C5_TIPO $ "N")
				_cIndPres = '3'
			Else
				_cIndPres = '0'
			Endif
			
		ElseIf cEmpAnt == '03'
			If ( M->C5_TIPO $ "N")
				_cIndPres = '3'
			Else
				_cIndPres = '0'
			Endif
			
		Else
			_cIndPres = '0'
		Endif
	EndIf
	RestArea(_aArea)
	RestArea(_aAreaSC5)
	RestArea(_aAreaSA1)
	
Return _cIndPres
