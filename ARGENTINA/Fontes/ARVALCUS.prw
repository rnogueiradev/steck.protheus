#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

#DEFINE CR    chr(13)+chr(10)

User Function ARVALCUS()

	Local _nCuStd	:= 0 
	Local _cMoeda	:= ""
	Local _nValMoe	:= 0
	Local cQuery1	:= ""
	Local _nCOD 	:= aScan(aHeader,{|x| AllTrim(x[2]) == "D3_COD"})
	Local _nCUSTO1 	:= aScan(aHeader,{|x| AllTrim(x[2]) == "D3_CUSTO1"})
	Local _nCUSRP1 	:= aScan(aHeader,{|x| AllTrim(x[2]) == "D3_CUSRP1"})
	Local _nQUANT 	:= aScan(aHeader,{|x| AllTrim(x[2]) == "D3_QUANT"})

	If INCLUI

		DbSelectArea("SB9")
		DbSetOrder(1)
		DbGotop()
		If !DbSeek(xFilial("SB9")+aCols[n][_nCOD])

			DbSelectArea("SB1")
			DbSetOrder(1)
			DbGotop()
			If DbSeek(xFilial("SB1")+aCols[n][_nCOD])

				If SB1->B1_MCUSTD  == "1"
				
					_nValMoe := SB1->B1_CUSTD

				Else
				
				If SELECT("TRB")>0
					TRB->(DBCLOSEAREA())
				ENDIF
				
				cQuery1:=""
				cQuery1+= " SELECT "+UPPER("M2_MOEDA"+Alltrim(SB1->B1_MCUSTD))+" MOEDA FROM "+RetSqlName("SM2")+" WHERE R_E_C_N_O_ = (SELECT MAX(R_E_C_N_O_) FROM "+RetSqlName("SM2")+" WHERE "+UPPER("M2_MOEDA"+Alltrim(SB1->B1_MCUSTD))+" > 0 AND  D_E_L_E_T_ = ' ') "
				
				tcquery cquery1 new alias "TRB"
				
				_nValMoe := SB1->B1_CUSTD * TRB->MOEDA
						
				EndIf

			EndIf

			_nCuStd := _nValMoe*aCols[n][_nQUANT]

			aCols[n][_nCUSRP1] := _nValMoe*aCols[n][_nQUANT]
			
			If _nValMoe = 0

				MsgAlert("Costo no informado sobre el registro del producto."+CR+CR+" Por favor solicite registro con el Comercial.","MT241LOK")

			EndIF
		EndIF

	EndIf

Return _nCuStd

User Function ARVALMOE(_cCampo)

	Local _lRet    		:= .F.
	Default _cCampo 	:= ""

	If Empty(_cCampo)
		_cCampo := PADR(StrTran(ReadVar(),"M->",""),10)
	Else
		_cCampo := PADR(_cCampo,10)
	EndIf

	If INCLUI .OR. ALTERA

		If Alltrim(_cCampo) $ "B1_MCUSTD"

			If Empty(&(UPPER("M->"+_cCampo))) 
				_lRet := .F.
			Else
				_lRet := .T.
			EndIf

		EndIf

	EndIf

Return(_lRet)
