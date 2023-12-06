#include 'Protheus.ch'
#include 'RwMake.ch'

/*====================================================================================\
|Programa  | STTMK_3_5_A      | Autor | GIOVANI.ZAGO             | Data | 14/01/2013  |
|=====================================================================================|
|Descrição |  Ponto de Entrada                                                        |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STTMK_3_5_A                                                              |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*---------------------------------------------------*
User Function STTMK35A(aBotao)
*---------------------------------------------------*

	Private aRetBot:=   {}
//aRetBot:= aclone(aBotao)           
                     

//aadd(aRetBot, {"HISTORIC",  {||U_STFSVE30()},"Registro FATEC"}) -> Comentado João Victor pois o botão de FATEC já está no fonte TMKBARLA.

//U_STFSVE23()

	aadd(aRetBot, {"CHAVE2",  {||U_STFTA001()},"UNICOM"})//João Victor inclui conforme solicitação de Everaldo Gallo em 27/02/2013.
 
	DbSelectArea('SA3')
	SA3->(DbSetOrder(7))
	If SA3->(dbSeek(xFilial('SA3')+__cuserid))
		If (ALLTRIM(SA3->A3_SUPER)=''   .or. ALLTRIM(SA3->A3_GEREN)='') .Or. __cUserId $ GetMv("ST_TRCVEND")
			aAdd(aRetBot,{ "EDIT"  , {|| U_STTMB35()} , "Troca Vendedor" })
		EndIf
	EndIf
   
	aAdd(aRetBot,{"DBG06"  , {|| U_STMENGAP07("1")} ,"Aplicar Desconto"})//gap 07
	aAdd(aRetBot,{"POSCLI"  , {|| U_STMENGAP07('2')} ,"Aplicar Acrescimo"})//gap 07
Return ( aRetBot )


/*====================================================================================\
|Programa  | STTMK_3_5_B       | Autor | GIOVANI.ZAGO             | Data | 14/01/2013 |
|=====================================================================================|
|Descrição |  Troca de Vendedor                                                       |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STTMK_3_5_B                                                              |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

*---------------------------------------------------*
User Function STMENGAP07(_xCtip)
*---------------------------------------------------*

	Local _nPorcen:= 0
	Local _cTitulo   := iif(_xCtip='1','Desconto','Acrescimo')
	Local i

	DEFINE MSDIALOG oDlgEmail TITLE OemToAnsi(_cTitulo+" Total") From 1,0 To 10,25 OF oMainWnd

	@ 05,04 SAY _cTitulo+' %' PIXEL OF oDlgEmail
	@ 15,04 MSGet _nPorcen  picture "@E 999.99"   Size 35,012  PIXEL OF oDlgEmail valid _nPorcen >= 0  .and. _nPorcen <= 100
//@ 35,04 SAY substr(Posicione("SA3",1,xFilial("SA3")+cVendNew,"A3_NOME"),1,30)  PIXEL OF oDlgEmail
	@ 053, 05 Button "Ok"      Size 28,12 Action Eval({||nOpca:=1,oDlgEmail:End()})  Pixel
	@ 053, 67 Button "Cancela" Size 28,12 Action Eval({||nOpca:=2,oDlgEmail:End()})  Pixel
	nOpca:=0

	ACTIVATE MSDIALOG oDlgEmail CENTERED

	If nOpca == 1
		For i:= 1 To Len(Acols)
		
			If !aCols[i,Len(aHeader)+1]
				U_STGAP07(_xCtip,i,_nPorcen)
			Endif
		Next i

	Endif

Return()
