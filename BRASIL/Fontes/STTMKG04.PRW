#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"

/*/{Protheus.doc} STTMKG04
Funcao para calculos data e parametros transito, financeiro, etc.
Utilizado no E2E e OTDC
@type function
@version  1.0
@author Kleber Ribeiro - CRM Services 
@since 02/05/2022
/*/

User Function STTMKG04(dtEntre,lSubtrai)
LOCAL nPEntPro  := IF(!Type("aHeader") == "U",aScan(aHeader, {|X| ALLTRIM(X[2])=="C6_ZENTR1C"}),' ')
LOCAL dD1C      := Ctod("  /  /    ")
LOCAL nDiasTra	:= 0
LOCAL nDiasFin	:= 0
LOCAL nDiasCom	:= 0
LOCAL nDiasLog	:= 0
LOCAL nDiasExp	:= 0
LOCAL nTotPrazo := 0
LOCAL fr        := 0

//// Dias de Translado para a entrega Tabela CC2
nDiasTra := U_STFATCC2(.T.)				

//// Dias de operação para o Financeiro
//nDiasFin := GetNewPar("STDIASFIN",2)

//// Dias de operação para o Comercial
nDiasCom := GetNewPar("STDIASCOM",0)

//// Dias de operação para a Logistica 
nDiasLog := GetNewPar("STDIASLOG",4)
							
//// Dias de operação para a Expedição
nDiasExp := GetNewPar("STDIASEXP",2)

If nDiasTra > 0
    dD1C   := Ctod("  /  /    ")
	//// Soma os dias que compõe a opreação total 
	nTotPrazo := nDiasTra + nDiasFin + nDiasCom + nDiasLog + nDiasExp

	dD1C   := DataValida(dtEntre)			
					
	/****************************
	Modificado para a variavel FR = 2 pois o dia de início de operação não deve ser contado na soma
	****************************/
	fr := 2
	IF lSubtrai //quando executado via gatilho do campo C5_XDTENPR
		While fr <= nTotPrazo
			//vai somando de 1 em 1 e vendo se cai sábado ou domingo, então adiciona sempre mais um dia até ficar dia útil 
			dD1C := DataValida(dD1C - 1,.F.)
			fr++										
		Enddo

		if dD1C <= date()
			dD1c := Ctod("  /  /    ")
		endif
					
	ELSE
		While fr <= nTotPrazo
			//vai somando de 1 em 1 e vendo se cai sábado ou domingo, então adiciona sempre mais um dia até ficar dia útil 
			dD1C := DataValida(dD1C + 1,.T.)
			fr++										
		Enddo
						
		IF TYPE ("aCols") == "A"
			aCols[n][nPEntPro] := dD1C
		ENDIF
	ENDIF

endif			


Return dD1C
