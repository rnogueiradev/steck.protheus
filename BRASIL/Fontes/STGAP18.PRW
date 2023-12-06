#include 'Protheus.ch'
#include 'RwMake.ch'

/*====================================================================================\
|Programa  | STGAP18         | Autor | GIOVANI.ZAGO              | Data | 01/02/2013  |
|=====================================================================================|
|Descrição |  Validação do gatilho desconto adicional  e acrescimo adicional          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STGAP18                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function STGAP18()
*-----------------------------*

Local aArea         	:= GetArea()
Local nLinha        	:= 0
Local _nPosDesc 		:= aScan(aHeader, { |x| Alltrim(x[2]) == 	"UB_DESC"        })
Local _nPosTotItem  	:= aScan(aHeader, { |x| Alltrim(x[2]) ==   	"UB_VLRITEM" 	 })
Local _nPosPrcven   	:= aScan(aHeader, { |x| Alltrim(x[2]) ==  	"UB_VRUNIT"  	 })
Local _nPosQtdVen		:= aScan(aHeader, { |x| Alltrim(x[2]) ==  	"UB_QUANT" 		 })
Local _nPosProd     	:= aScan(aHeader, { |x| Alltrim(x[2]) ==   	"UB_PRODUTO"     })
Local _nPosTes      	:= aScan(aHeader, { |x| Alltrim(x[2]) ==   	"UB_TES"         })
Private	bFolderRefresh	:= {|| (IIf(!lTk271Auto,Tk273FRefresh(),""))}																	// Efetua o Refresh do Folder
Private bGDRefresh		:= {|| (IIf(!lTk271Auto,oGetTlv:oBrowse:Refresh(),"")) }														// Efetua o Refresh da GetDados
Private bRefresh		:= {|| (IIf(!lTk271Auto,((Tk273Refresh()),(Eval(bFolderRefresh)),Eval(bDoRefresh)),Tk273Refresh()))}	    	// Efetua o Refresh da NF
Private bListRefresh	:= {|| (MaFisToCols(aHeader,aCols,,"TMK271"),IIf(!lTk271Auto,(Eval(bRefresh),Eval(bGdRefresh)),""))}

If Empty(M->UA_XMSGCLI)
	
	MaFisAlt("NF_TPCLIFOR",M->UA_XTIPO)
	Tk273Refresh(.T.)
	If MaFisFound()
		
		For nLinha := 1 To Len(aCols)
			
			MaFisAlt("IT_QUANT"		,aCols[nLinha][_nPosQtdVen]		,nLinha)
			MaFisAlt("IT_PRCUNI"	,aCols[nLinha][_nPosPrcven]	    ,nLinha)
			MaFisAlt("IT_VALMERC"	,aCols[nLinha][_nPosTotItem]	,nLinha)
			
			Tk273Recalc(nLinha,.T.)
			
			If aCols[nLinha][_nPosDesc] > 0 .And. !Empty(aCols[nLinha][_nPosTes])
				SF4->(dbSetOrder(1))
				SF4->(dbseek(xFilial("SF4")+aCols[nLinha][_nPosTes]))
				If SF4->F4_IPI == "S" .And. SF4->F4_TPIPI == "B"
					MaFisAlt("IT_BASEIPI",MaFisRet(nLinha,"IT_BASEIPI") + aCols[nLinha][_nPosDesc],nLinha)
				EndIf
			EndIf
		Next nLinha
		Eval(bListRefresh)
		
	Endif
Endif
Restarea(aArea)
Return()

