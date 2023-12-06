#INCLUDE "PROTHEUS.CH"
#DEFINE _DEBUG   .F.   // Flag para Debuggear el codigo
#DEFINE _NOMIMPOST 01
#DEFINE _ALIQUOTA  02
#DEFINE _BASECALC  03
#DEFINE _IMPUESTO  04
#DEFINE _TES_CFO   10
#DEFINE _RATEOFRET 11
#DEFINE _IMPFLETE  12
#DEFINE _RATEODESP 13
#DEFINE _IMPGASTOS 14
#DEFINE _VLRTOTAL  3
#DEFINE _FLETE     4
#DEFINE _GASTOS    5
#DEFINE _ALIQDESG  19

User Function xM100xiva(cCalculo,nItem,aInfo,cXFisRap)        // incluido pelo assistente de conversao do AP5 IDE em 09/09/99

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local lXFis,xRet,nOrdSFC,nRegSFC,nBase
Local _nMoeda	:= 1
Local nDocOri := 0

SetPrvt("CALIASROT,CORDEMROT,AITEMINFO,AIMPOSTO,NPOSROW,_CPROCNAME")
SetPrvt("_CZONCLSIGA,_LAGENTE,_LEXENTO,AFISCAL,_LCALCULAR,_LESLEGAL")
SetPrvt("_NALICUOTA,_NVALORMIN,_NREDUCIR,NPOS1,NPOS2,ACOLS,_NALICDESG")
SetPrvt("_NImportex,_LTABLA")

Default cXFisRap := ""

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funcion   ¦M100xIVA  ¦ Autor ¦ Jose Luis Otermin      ¦Fecha ¦ 21.07.99¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descrip.  ¦ Programa que Calcula   IVA                                 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ MATA100, llamado por un punto de entrada                   ¦¦¦
¦¦+-----------------------------------------------------------------------¦¦¦
¦¦¦         ACTUALIZACIONES EFECTUADAS DESDE LA CODIFICACION INICIAL      ¦¦¦
¦¦+-----------------------------------------------------------------------¦¦¦
¦¦¦Programador ¦ Fecha  ¦ BOPS ¦  Motivo de la Alteracion                 ¦¦¦
¦¦+------------+--------+------+------------------------------------------¦¦¦
¦¦¦            ¦  /  /  ¦      ¦                                          ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
//-----------------------------------------------------
// Nota:
// Debe registrarse al Cliente en la Tabla SFH en caso
// que sea Agente de Percepcion o este Exento en una ZF.
// Se utiliza el parametro MV_AGENTE
// Significado de las posiciones de MV_AGENTE
// SUBSTR(MV_AGENTE,1,1) = Agente Retencion Ganancias? (S/N)
// SUBSTR(MV_AGENTE,2,1) = Agente Retencion IVA?       (S/N)
// SUBSTR(MV_AGENTE,3,1) = Agente Retencion IB?        (S/N)
// SUBSTR(MV_AGENTE,4,1) = Agente Percepcion IVA?      (S/N)
// SUBSTR(MV_AGENTE,5,1) = Agente Percepcion IB?       (S/N)
//-----------------------------------------------------
// Nota:
// Debe utilizarse el parametro MV_EXENTO
// Significado de las posiciones de MV_EXENTO
// SUBSTR(MV_EXENTO,1,1) = Exento Retencion Ganancias? (S/N)
// SUBSTR(MV_EXENTO,2,1) = Exento Retencion IVA?       (S/N)
// SUBSTR(MV_EXENTO,3,1) = Exento Retencion IB?        (S/N)
// SUBSTR(MV_EXENTO,4,1) = Exento Percepcion IVA?      (S/N)
// SUBSTR(MV_EXENTO,5,1) = Exento Percepcion IB?       (S/N)
//-----------------------------------------------------


/*/

// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 09/09/99 ==> #DEFINE _DEBUG   .F.   // Flag para Debuggear el codigo


// Indices de aImposto
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 09/09/99 ==> #DEFINE _NOMIMPOST 01
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 09/09/99 ==> #DEFINE _ALIQUOTA  02
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 09/09/99 ==> #DEFINE _BASECALC  03
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 09/09/99 ==> #DEFINE _IMPUESTO  04
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 09/09/99 ==> #DEFINE _TES_CFO   10
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 09/09/99 ==> #DEFINE _RATEOFRET 11
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 09/09/99 ==> #DEFINE _IMPFLETE  12
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 09/09/99 ==> #DEFINE _RATEODESP 13
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 09/09/99 ==> #DEFINE _IMPGASTOS 14

// Subindices de aItemINFO
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 09/09/99 ==> #DEFINE _VLRTOTAL  3
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 09/09/99 ==> #DEFINE _FLETE     4
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 09/09/99 ==> #DEFINE _GASTOS    5

lXfis:=(MaFisFound()  .And. ProcName(1)<>"EXECBLOCK")
cAliasRot  := Alias()
cOrdemRot  := IndexOrd()
_NImportex := 0
_lTabla    := .F.

If !lXFis
	aItemINFO  := ParamIxb[1]
	aImposto   := ParamIxb[2]
	nPosRow    := ParamIxb[3]
	xRet:=aImposto
Else
	xRet:=0
Endif

_cProcName := "M100xIVA"

_cZonClSIGA:= SM0->M0_ESTCOB // Zona Fiscal del Cliente SIGA
_lAgente   := .F.     // En este impuesto el Proveedor Siempre cobra IVA.
_lExento   := .F.     // En esta empresa Siempre paga IVA Compras.

//aFiscal    := ExecBlock("u__xImpge",.F.,.F.,{If(lXFis,{cCalculo,nItem,aInfo},ParamIxb), _cProcName, _lAgente,_cZonClSIGA,lXFis},.T.)
aFiscal    := ExecBlock("IMPGENER",.F.,.F.,{If(lXFis,{cCalculo,nItem,aInfo},ParamIxb), _cProcName, _lAgente,_cZonClSIGA,lXFis},.T.)

_lCalcular :=  aFiscal[1]
_lEsLegal  :=  aFiscal[2]
_nAlicuota :=  aFiscal[3]
_nValorMin :=  aFiscal[4]
_nReducir  :=  aFiscal[5]
_nMoeda    :=  aFiscal[7]
_nAlicDesg :=  aFiscal[11]

IF _DEBUG
	msgstop(_lCalcular, "Calcular - "+_cProcName)
	msgstop(_lEslegal , "Es Legal - "+_cProcName)
	msgstop(_nAlicuota, "Alicuota - "+_cProcName)
	msgstop(_nValorMin, "ValorMin - "+_cProcName)
	msgstop(_nReducir , "Reducir  - "+_cProcName)
ENDIF

// NO se tiene en cuenta el valor _lCalcular porque este impuesto SIEMPRE
// Se cobra.

IF  _lEsLegal
	
	If !lXFis
		aImposto[_RATEOFRET] := aItemINFO[_FLETE]      // Rateio do Frete
		aImposto[_RATEODESP] := aItemINFO[_GASTOS]     // Rateio de Despesas
		aImposto[_ALIQUOTA]  := _nAlicuota // Alicuota de Zona Fiscal del Proveedor
		aImposto[_BASECALC]  := aItemINFO[_VLRTOTAL]+aItemINFO[_FLETE]+aItemINFO[_GASTOS] // Base de Cálculo
		aImposto[_ALIQDESG]  := _nAlicDesg
		
		If Subs(aImposto[5],4,1) == "S"  .And. Len(AIMPOSTO) >= 18 .And. ValType(aImposto[18])=="N"
			aImposto[_BASECALC]	-=	aImposto[18]
		Endif
		
		IF _DEBUG
			msgstop(aImposto[_ALIQUOTA], "aImposto[_ALIQUOTA] - "+_cProcName)
			msgstop(aImposto[_BASECALC], "aImposto[_BASECALC] - "+_cProcName)
		ENDIF
		
		//+---------------------------------------------------------------+
		//¦ Efectua el Cálculo del Impuesto                               ¦
		//+---------------------------------------------------------------+
		//		aImposto[_IMPUESTO]  := round(aImposto[_BASECALC] * aImposto[_ALIQUOTA]/100 ,2)
		If _nAlicDesg > 0
			aImposto[_IMPUESTO]  := round(aImposto[_BASECALC] * aImposto[_ALIQUOTA]/100 ,MsDecimais(_nMoeda))
			aImposto[_IMPUESTO]  := aImposto[_IMPUESTO] - ((aImposto[_IMPUESTO] * aImposto[_ALIQDESG]) / 100)
		Else
			aImposto[_IMPUESTO]  := round(aImposto[_BASECALC] * aImposto[_ALIQUOTA]/100 ,MsDecimais(_nMoeda))
		EndIf
		
		//+---------------------------------------------------------------+
		//¦ Efetua o Cálculo do Imposto sobre Frete                       ¦
		//+---------------------------------------------------------------+
		aImposto[_IMPFLETE]  := ROUND(aImposto[_RATEOFRET] * aImposto[_ALIQUOTA]/100,MsDecimais(_nMoeda))
		If Type("aHeader")=="A"
			nPos1 := Ascan(aHeader,{|x| AllTrim(x[2])=="D1_IVAFRET"})
			nPos2 := Ascan(aHeader,{|x| AllTrim(x[2])=="D1_BAIVAFR"})
			If (nPos1 * nPos2) <> 0
				aCols[nPosRow][nPos1]:= aImposto[_IMPFLETE]
				aCols[nPosRow][nPos2]:= aImposto[_RATEOFRET]
			Endif
		Endif
		IF _DEBUG
			msgstop(aImposto[_IMPFLETE], "aImposto[_IMPFLETE] - "+_cProcName)
			msgstop(aImposto[_RATEOFRET], "aImposto[_RATEOFRET] - "+_cProcName)
		ENDIF
		
		//+---------------------------------------------------------------+
		//¦ Efetua o Cálculo do Imposto sobre Despesas                    ¦
		//+---------------------------------------------------------------+
		aImposto[_IMPGASTOS] := ROUND(aImposto[_RATEODESP] * aImposto[_ALIQUOTA]/100,MsDecimais(_nMoeda))
		If Type("aHeader")=="A"
			nPos1 := Ascan(aHeader,{|x| AllTrim(x[2])=="D1_IVAGAST"})
			nPos2 := Ascan(aHeader,{|x| AllTrim(x[2])=="D1_BAIVAGA"})
			If (nPos1 * nPos2) <> 0
				aCols[nPosRow][nPos1]:= aImposto[_IMPGASTOS]
				aCols[nPosRow][nPos2]:= aImposto[_RATEODESP]
			Endif
		Endif
		
		IF _DEBUG
			msgstop(aImposto[_IMPGASTOS], "aImposto[_IMPGASTOS] - "+_cProcName)
			msgstop(aImposto[_RATEODESP], "aImposto[_RATEODESP] - "+_cProcName)
		ENDIF
		
		xRet:=aImposto
		
	Else
		If Type("aHeader")=="A"
			nDocOri := Ascan(aHeader,{|x| AllTrim(x[2])=="D1_NFORI"})
		EndIf
		
		
		//####################################################################
		//Calculo dos valores de acordo com a Faixa do Imposto - Steck -ARG  #
		//####################################################################
		DbSelectArea("SFF")
		DbSetOrder(10)
		If DbSeek(xFilial("SFF")+"GAN"+aFiscal[13])
			
			While !SFF->(EOF()) .And. Rtrim(SFF->FF_FILIAL+SFF->FF_IMPOSTO+SFF->FF_CFO_C) == Rtrim(xFilial("SFF")+"GAN"+aFiscal[13])
				
				If SFF->FF_ITEM==SA2->A2_AGREGAN
					
					If SFF->FF_ESCALA == "D" .And.  MaFisRet(nItem,"IT_VALMERC")  > SFF->FF_VALMIN
						_nValorMin  := SFF->FF_IMPORTE
						_nAlicuota := SFF->FF_PERC   
						_NImportex  := 0
						Exit
					Else
						
						
						_nValorMin  := _nValorMin+SFF->FF_IMPORTE
						If SFF->FF_ESCALA == "A"
							_lTabla  := .T.
						Endif
					Endif
				Else
					
					If SubStr(SFF->FF_CONCEPT,1,6)=="ESCALA"
						If (MaFisRet(nItem,"IT_VALMERC")-_nValorMin)   >= SFF->FF_FXDE  .And.  (MaFisRet(nItem,"IT_VALMERC")-_nValorMin)   <= SFF->FF_FXATE .And. 	_lTabla 
							_nValorMin := _nValorMin+SFF->FF_EXCEDE
							_nAlicuota := SFF->FF_PERC
							_NImportex  := SFF->FF_IMPORTE
						Endif
					Endif
					
				Endif
				
				DbSelectArea("SFF")
				DbSkip()
			Enddo
			
		Endif
		
		
		If !Empty(cXFisRap)
			
			If MaFisRet(nItem,"IT_VALMERC") > _nValorMin
				nBase:=MaFisRet(nItem,"IT_VALMERC")-_nValorMin
			Else
				nBase:=MaFisRet(nItem,"IT_VALMERC")
			Endif
			
			//Tira os descontos se for pelo liquido   '
			nOrdSFC:=(SFC->(IndexOrd()))
			nRegSFC:=(SFC->(Recno()))
			SFC->(DbSetOrder(2))
			If (SFC->(DbSeek(xFilial("SFC")+MaFisRet(nItem,"IT_TES")+aInfo[1])))
				If !(nDocOri>0 .and. !Empty(aCols[nItem][nDocOri]) .and. cEspecie $ ("NCC"))
					If SFC->FC_LIQUIDO=="S"
						nBase -= MaFisRet(nItem,"IT_DESCONTO")
					Endif
				Endif
			Endif
			xRet := {nBase,	_nAlicuota,0}
			If "V" $ cXFisRap
				If SFC->FC_CALCULO=="T"
					nBase:=MaRetBasT(aInfo[2],nItem,_nAlicuota)
				EndIf
				xRet[3] := Round(nBase * (_nAlicuota / 100),MsDecimais(_nMoeda))+_NImportex
				If _nAlicDesg > 0
					xRet[3] := xRet[3] - ((xRet[3] *_nAlicDesg) / 100)
				EndIf
			Endif
			SFC->(DbSetOrder(nOrdSFC))
			SFC->(DbGoto(nRegSFC))
		Else
			If MaFisRet(nItem,"IT_VALMERC")>_nValorMin
				nBase:=MaFisRet(nItem,"IT_VALMERC")-_nValorMin
			Else
				nBase:=MaFisRet(nItem,"IT_VALMERC")
			Endif
			//Tira os descontos se for pelo liquido
			nOrdSFC:=(SFC->(IndexOrd()))
			nRegSFC:=(SFC->(Recno()))
			SFC->(DbSetOrder(2))
			If (SFC->(DbSeek(xFilial("SFC")+MaFisRet(nItem,"IT_TES")+aInfo[1])))
				If !(nDocOri>0 .and. !Empty(aCols[nItem][nDocOri]) .and. cEspecie $ ("NCC"))
					If SFC->FC_LIQUIDO=="S"
						nBase -= MaFisRet(nItem,"IT_DESCONTO")
					Endif
				Endif
			Endif
			Do Case
				Case cCalculo=="A"
					xRet:=	_nAlicuota
				Case cCalculo=="B"
					xRet:=	nBase
				Case cCalculo=="V"
					If SFC->FC_CALCULO=="T"
						nBase:=MaRetBasT(aInfo[2],nItem,_nAlicuota)
					EndIf
					xRet:=	Round(nBase * (_nAlicuota / 100),MsDecimais(_nMoeda))+_NImportex
					If _nAlicDesg > 0
						xRet:= xRet - ((xRet *_nAlicDesg) / 100)
					EndIf
			Endcase
			SFC->(DbSetOrder(nOrdSFC))
			SFC->(DbGoto(nRegSFC))
		Endif
	Endif
ENDIF

dbSelectArea( cAliasRot )
dbSetOrder( cOrdemRot )

Return( xRet )        // incluido pelo assistente de conversao do Siga Advanced Protheus IDE em 30/08/99
