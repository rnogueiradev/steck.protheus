#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "tbicode.ch"
#INCLUDE 'RESTFUL.CH'
#INCLUDE 'TBICONN.CH'

		
User Function STELIMRES(xPedidos)

	Local _nX			:= 0
	Local lContinua	:= .T.   
	//FR - 27/07/2022 - Flávia Rocha - Sigamat Consultoria
	//Ticket #20220608011805 - Implementar Procedimento / Rotina para cancelamento de pedidos rejeitados financeiro de forma automática. 
	//Esta função STELIMRES será chamada pelo job que verifica os pedidos com status "rejeitado" pelo Financeiro,
	//há mais de 7 dias úteis, nesse caso será feita a eliminação do resíduo desses pedidos automaticamente.
	//Local _aPedidos	:= {}
	
	Default xPedidos := {} 
	
	//FR - 27/07/2022 - Flávia Rocha - Sigamat Consultoria
	//Ticket #20220608011805 - Implementar Procedimento / Rotina para cancelamento de pedidos rejeitados financeiro de forma automática. 
	//Tratativa se a chamada não vier do job:	
	If Len(xPedidos)==0

		RpcSetType( 3 )
		RpcSetEnv( "11", "01",,,"FAT")	
	
		_aPedidos := {}	
AADD(_aPedidos,{'059578'})
AADD(_aPedidos,{'060163'})
AADD(_aPedidos,{'060230'})
AADD(_aPedidos,{'061770'})
AADD(_aPedidos,{'062205'})
AADD(_aPedidos,{'063436'})
AADD(_aPedidos,{'064004'})
AADD(_aPedidos,{'064197'})
AADD(_aPedidos,{'064310'})
AADD(_aPedidos,{'064885'})
AADD(_aPedidos,{'065935'})
AADD(_aPedidos,{'066912'})
AADD(_aPedidos,{'066917'})
AADD(_aPedidos,{'067810'})
AADD(_aPedidos,{'068609'})
AADD(_aPedidos,{'059578'})
AADD(_aPedidos,{'060163'})
AADD(_aPedidos,{'060230'})
AADD(_aPedidos,{'061585'})
AADD(_aPedidos,{'062205'})
AADD(_aPedidos,{'063436'})
AADD(_aPedidos,{'064004'})
AADD(_aPedidos,{'064197'})
AADD(_aPedidos,{'064310'})
AADD(_aPedidos,{'064885'})
AADD(_aPedidos,{'065935'})
AADD(_aPedidos,{'066917'})
AADD(_aPedidos,{'067810'})
AADD(_aPedidos,{'068609'})
AADD(_aPedidos,{'059578'})
AADD(_aPedidos,{'060163'})
AADD(_aPedidos,{'060230'})
AADD(_aPedidos,{'061585'})
AADD(_aPedidos,{'062205'})
AADD(_aPedidos,{'063436'})
AADD(_aPedidos,{'064004'})
AADD(_aPedidos,{'064197'})
AADD(_aPedidos,{'064310'})
AADD(_aPedidos,{'064753'})
AADD(_aPedidos,{'064885'})
AADD(_aPedidos,{'065935'})
AADD(_aPedidos,{'066917'})
AADD(_aPedidos,{'067810'})
AADD(_aPedidos,{'068609'})
AADD(_aPedidos,{'068643'})
AADD(_aPedidos,{'059578'})
AADD(_aPedidos,{'061585'})
AADD(_aPedidos,{'062205'})
AADD(_aPedidos,{'063436'})
AADD(_aPedidos,{'064004'})
AADD(_aPedidos,{'064081'})
AADD(_aPedidos,{'064197'})
AADD(_aPedidos,{'064310'})
AADD(_aPedidos,{'064885'})
AADD(_aPedidos,{'065935'})
AADD(_aPedidos,{'066917'})
AADD(_aPedidos,{'068609'})
AADD(_aPedidos,{'068643'})
AADD(_aPedidos,{'059578'})
AADD(_aPedidos,{'061585'})
AADD(_aPedidos,{'062205'})
AADD(_aPedidos,{'063436'})
AADD(_aPedidos,{'064004'})
AADD(_aPedidos,{'064197'})
AADD(_aPedidos,{'064310'})
AADD(_aPedidos,{'064885'})
AADD(_aPedidos,{'065935'})
AADD(_aPedidos,{'066917'})
AADD(_aPedidos,{'068527'})
AADD(_aPedidos,{'068609'})
AADD(_aPedidos,{'059578'})
AADD(_aPedidos,{'060071'})
AADD(_aPedidos,{'061585'})
AADD(_aPedidos,{'063436'})
AADD(_aPedidos,{'064004'})
AADD(_aPedidos,{'064197'})
AADD(_aPedidos,{'064310'})
AADD(_aPedidos,{'064885'})
AADD(_aPedidos,{'065935'})
AADD(_aPedidos,{'066917'})
AADD(_aPedidos,{'068609'})
AADD(_aPedidos,{'059578'})
AADD(_aPedidos,{'060230'})
AADD(_aPedidos,{'061585'})
AADD(_aPedidos,{'062205'})
AADD(_aPedidos,{'063436'})
AADD(_aPedidos,{'064004'})
AADD(_aPedidos,{'064197'})
AADD(_aPedidos,{'064310'})
AADD(_aPedidos,{'065935'})
AADD(_aPedidos,{'066917'})
AADD(_aPedidos,{'068609'})
AADD(_aPedidos,{'059578'})
AADD(_aPedidos,{'060230'})
AADD(_aPedidos,{'061585'})
AADD(_aPedidos,{'062205'})
AADD(_aPedidos,{'063436'})
AADD(_aPedidos,{'064004'})
AADD(_aPedidos,{'064197'})
AADD(_aPedidos,{'064310'})
AADD(_aPedidos,{'064885'})
AADD(_aPedidos,{'065935'})
AADD(_aPedidos,{'066917'})
AADD(_aPedidos,{'068609'})
AADD(_aPedidos,{'059578'})
AADD(_aPedidos,{'060230'})
AADD(_aPedidos,{'061585'})
AADD(_aPedidos,{'062205'})
AADD(_aPedidos,{'063436'})
AADD(_aPedidos,{'064004'})
AADD(_aPedidos,{'064197'})
AADD(_aPedidos,{'064885'})
AADD(_aPedidos,{'065935'})
AADD(_aPedidos,{'068609'})
AADD(_aPedidos,{'059578'})
AADD(_aPedidos,{'060230'})
AADD(_aPedidos,{'062205'})
AADD(_aPedidos,{'063436'})
AADD(_aPedidos,{'064004'})
AADD(_aPedidos,{'064197'})
AADD(_aPedidos,{'064310'})
AADD(_aPedidos,{'064885'})
AADD(_aPedidos,{'065935'})
AADD(_aPedidos,{'068609'})
AADD(_aPedidos,{'059578'})
AADD(_aPedidos,{'062205'})
AADD(_aPedidos,{'063436'})
AADD(_aPedidos,{'064004'})
AADD(_aPedidos,{'064197'})
AADD(_aPedidos,{'064310'})
AADD(_aPedidos,{'064885'})
AADD(_aPedidos,{'068609'})
AADD(_aPedidos,{'059578'})
AADD(_aPedidos,{'061585'})
AADD(_aPedidos,{'062205'})
AADD(_aPedidos,{'063436'})
AADD(_aPedidos,{'064004'})
AADD(_aPedidos,{'064197'})
AADD(_aPedidos,{'064310'})
AADD(_aPedidos,{'064885'})
AADD(_aPedidos,{'068609'})
AADD(_aPedidos,{'059578'})
AADD(_aPedidos,{'061585'})
AADD(_aPedidos,{'064004'})
AADD(_aPedidos,{'064197'})
AADD(_aPedidos,{'064310'})
AADD(_aPedidos,{'064885'})
AADD(_aPedidos,{'068609'})
AADD(_aPedidos,{'059578'})
AADD(_aPedidos,{'061585'})
AADD(_aPedidos,{'064004'})
AADD(_aPedidos,{'064197'})
AADD(_aPedidos,{'064885'})
AADD(_aPedidos,{'068609'})
AADD(_aPedidos,{'059578'})
AADD(_aPedidos,{'061585'})
AADD(_aPedidos,{'064004'})
AADD(_aPedidos,{'064197'})
AADD(_aPedidos,{'064310'})
AADD(_aPedidos,{'064885'})
AADD(_aPedidos,{'068609'})
AADD(_aPedidos,{'059578'})
AADD(_aPedidos,{'061585'})
AADD(_aPedidos,{'064004'})
AADD(_aPedidos,{'064197'})
AADD(_aPedidos,{'064310'})
AADD(_aPedidos,{'064885'})
AADD(_aPedidos,{'068609'})
AADD(_aPedidos,{'059578'})
AADD(_aPedidos,{'061585'})
AADD(_aPedidos,{'064004'})
AADD(_aPedidos,{'064197'})
AADD(_aPedidos,{'064310'})
AADD(_aPedidos,{'064885'})
AADD(_aPedidos,{'068609'})
AADD(_aPedidos,{'059578'})
AADD(_aPedidos,{'061585'})
AADD(_aPedidos,{'064004'})
AADD(_aPedidos,{'064197'})
AADD(_aPedidos,{'064310'})
AADD(_aPedidos,{'064885'})
AADD(_aPedidos,{'068609'})
AADD(_aPedidos,{'059578'})
AADD(_aPedidos,{'061585'})
AADD(_aPedidos,{'064004'})
AADD(_aPedidos,{'064310'})
AADD(_aPedidos,{'064885'})
AADD(_aPedidos,{'068609'})
AADD(_aPedidos,{'059578'})
AADD(_aPedidos,{'064004'})
AADD(_aPedidos,{'064197'})
AADD(_aPedidos,{'064885'})
AADD(_aPedidos,{'059578'})
AADD(_aPedidos,{'061585'})
AADD(_aPedidos,{'064004'})
AADD(_aPedidos,{'064885'})
AADD(_aPedidos,{'059578'})
AADD(_aPedidos,{'061585'})
AADD(_aPedidos,{'064004'})
AADD(_aPedidos,{'064885'})
AADD(_aPedidos,{'059578'})
AADD(_aPedidos,{'061585'})
AADD(_aPedidos,{'064004'})
AADD(_aPedidos,{'064885'})
AADD(_aPedidos,{'059578'})
AADD(_aPedidos,{'061585'})
AADD(_aPedidos,{'064004'})
AADD(_aPedidos,{'064885'})
AADD(_aPedidos,{'059578'})
AADD(_aPedidos,{'061585'})
AADD(_aPedidos,{'064004'})
AADD(_aPedidos,{'064885'})
AADD(_aPedidos,{'059578'})
AADD(_aPedidos,{'061585'})
AADD(_aPedidos,{'064004'})
AADD(_aPedidos,{'064885'})
AADD(_aPedidos,{'059578'})
AADD(_aPedidos,{'061585'})
AADD(_aPedidos,{'064004'})
AADD(_aPedidos,{'059578'})
AADD(_aPedidos,{'060071'})
AADD(_aPedidos,{'061585'})
AADD(_aPedidos,{'064004'})
AADD(_aPedidos,{'059578'})
AADD(_aPedidos,{'060071'})
AADD(_aPedidos,{'061585'})
AADD(_aPedidos,{'064004'})
AADD(_aPedidos,{'059578'})
AADD(_aPedidos,{'061585'})
AADD(_aPedidos,{'064004'})
AADD(_aPedidos,{'059578'})
AADD(_aPedidos,{'064004'})
AADD(_aPedidos,{'059578'})
AADD(_aPedidos,{'064004'})
AADD(_aPedidos,{'059578'})
AADD(_aPedidos,{'059578'})
AADD(_aPedidos,{'068643'})

	Else 
		_aPedidos := aClone(xPedidos)
	Endif 


	For _nX:=1 To Len(_aPedidos)

		DbSelectArea("SC5")
		SC5->(DbSetOrder(1))
		SC5->(DbGoTop())
		If Len(xPedidos)==0
			SC5->(DbSeek(xFilial("SC5")+_aPedidos[_nX][1]))
		Else 
			SC5->(DbSeek(xFilial("SC5")+_aPedidos[_nX]))
		Endif 
		IF SC5->(!Eof())
			//lContinua	:= U_Mt410Ace()
			lContinua := ExecBlock("M410VRES",.F.,.F.)
			If lContinua
		
				Begin Transaction
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Eliminacao de residuo                                ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					dbSelectArea("SC6")
					dbSetOrder(1)
					MsSeek(xFilial("SC6")+SC5->C5_NUM)
				
					While ( !Eof() .And. SC6->C6_FILIAL == xFilial("SC6") .And. SC6->C6_NUM 	== SC5->C5_NUM )
						lValido  := .T.
						If lValido .And. !Empty(SC5->C5_PEDEXP) .And. SuperGetMv("MV_EECFAT") // Integracao SIGAEEC
							If FindFunction("EECZERASALDO")
								lValido := EECZeraSaldo(,SC5->C5_PEDEXP,,.T.,SC5->C5_NUM)
							Else
								lValido := EECCancelPed(,SC5->C5_PEDEXP,,.T.,SC5->C5_NUM)
							EndIf
						EndIf
						If lValido .And. (SC6->C6_QTDVEN - SC6->C6_QTDENT) > 0
							MaResDoFat(,.T.,.F.)
						EndIf
						dbSelectArea("SC6")
						dbSkip()
					EndDo
					SC6->(MaLiberOk({SC5->C5_NUM},.T.))
				End Transaction
				
			EndIf
		EndIf

	Next
	
	MsgAlert("Finalizado")
	
	Return()


//==============================================================================================//
//Programa: U_PVREJSEL
//Autoria : Flávia Rocha - Sigamat Consultoria
//Data    : 27/07/2022
//Objetivo: Job para selecionar os pedidos rejeitados pelo financeiro há mais de "60 dias corridos"
//          E enviar email avisando ao vendedor, copiando o Financeiro, esse job é só de aviso
//          O job que efetivamente cancela o PV é o PVREJCANN
//          No email informar que qdo completar 60 dias de rejeição, já cancela
//Filtro  : Desde que os campos C5_XFINCAN e C5_XCOMCAN estejam diferentes de '1'
//          1=Impede Cancelamento Automatico;2=Permite Cancelamento Automatico 
//==============================================================================================//
User Function PVREJSEL()	
Local cQuery 	:= ""	
Local dDataDe   := Ctod("  /  /    ")
Local dDataLIb  := Ctod("  /  /    ")
Local cDataDe   := ""
Local aPed60	:= {}
Local aPed15 	:= {}
Local aAviso60	:= {}
Local aAviso15  := {}

Local nTetoMax  := 0 
Local nTetoMin  := 0

/*
REGRA:

PEDIDOS COM A REJEIÇÃO I-LIMITE EXCEDIDO - 60 DIAS

PEDIDOS COM A CONDIÇAO DE PAGAMENTO 501 (A VISTA) - 60 DIAS

PEDIDOS COM OUTRAS REJEIÇÕES E CONDIÇÕES DE PAGAMENTO - 15 DIAS 

------------------
C9_BLCRED (campo)
-----------------
Código atribuído:

01 - Bloqueio de Crédito por Valor   

04 - Vencimento do Limite de Crédito - Data de Crédito Vencida 

05 - Bloqueio Manual/Estorno

09 - Liberação de Crédito Rejeitada

10 - Faturado

ZZ - Liberação Tardia
*/


RpcSetType( 3 )
RpcSetEnv( "11", "01",,,"FAT")	
 

//estipulei 30 dias porque daqui irei calcular se está rejeitado há mais de 7 dias úteis
dDataDe := dDatabase - 30
cDataDe := DtoS(dDataDe)

DbSelectArea("SC5")

nTetoMax := GetNewpar("STPVREJSE1" , 53) //COLOQUEI O TETO MÁXIMO DE DIAS CORRIDOS PARA O CASO SE ALGUM DIA QUISEREM MUDAR
nTetoMin := GetNewpar("STPVREJSE2" , 8 )

cQuery := "SELECT C9_FILIAL, C9_PEDIDO, C9_ITEM, C9_CLIENTE, C9_LOJA, C9_NFISCAL, C9_DATALIB, C9_BLCRED, A1_NOME " + CHR(13) + CHR(10)

cQuery += " ,C5_ZMOTREJ AS REJEICAOFIN "  + CHR(13) + CHR(10) //campo "Rejeição Fin." 
cQuery += " ,C5_CONDPAG AS CONDPAG "      + CHR(13) + CHR(10)
cQuery += " , ( '" + Dtos( dDatabase)  + "' - C9_DATALIB ) AS DIASCORRIDOS " + CHR(13) + CHR(10)
cQuery += " , C5_VEND1 "				  + CHR(13) + CHR(10)
cQuery += " , A3_EMAIL "				  + CHR(13) + CHR(10)

cQuery += " FROM       " + RetSqlName("SC9") + " SC9 "	+ CHR(13) + CHR(10)
cQuery += " INNER JOIN " + RetSqlName("SC5") + " SC5 " 	+ CHR(13) + CHR(10)
cQuery += " ON  SC5.C5_FILIAL  = SC9.C9_FILIAL AND SC5.C5_NUM = SC9.C9_PEDIDO " 	+ CHR(13) + CHR(10)
cQuery += " AND SC5.C5_CLIENTE = SC9.C9_CLIENTE AND SC5.C5_LOJACLI = SC9.C9_LOJA "	+ CHR(13) + CHR(10)
cQuery += " AND SC5.D_E_L_E_T_ = '' "												+ CHR(13) + CHR(10)

cQuery += " INNER JOIN " + RetSqlName("SA1") + " SA1 " 	+ CHR(13) + CHR(10)
cQuery += " ON  SC5.C5_CLIENTE = SA1.A1_COD AND SC5.C5_LOJACLI = SA1.A1_LOJA "	+ CHR(13) + CHR(10)
cQuery += " AND SA1.D_E_L_E_T_ = '' "	

cQuery += " INNER JOIN " + RetSqlName("SA3") + " SA3 " 	+ CHR(13) + CHR(10)
cQuery += " ON  SC5.C5_VEND1 = SA3.A3_COD "	+ CHR(13) + CHR(10)
cQuery += " AND SA3.D_E_L_E_T_ = '' "										

//1=Impede Cancelamento Automatico;2=Permite Cancelamento Automatico
If FieldPos("C5_XFINCAN") > 0
	cQuery += " AND SC5.C5_XFINCAN <> '1' "  + CHR(13) + CHR(10) 
Endif 

If FieldPos("C5_XCOMCAN") > 0
	cQuery += " AND SC5.C5_XCOMCAN <> '1' "  + CHR(13) + CHR(10) 
Endif 

cQuery += " WHERE SC9.D_E_L_E_T_ = ' ' " 			+ CHR(13) + CHR(10)
cQuery += " AND C9_NFISCAL = ' ' " 					+ CHR(13) + CHR(10)
cQuery += " AND C9_BLCRED = '09' "    				+ CHR(13) + CHR(10)

cQuery += " AND C9_DATALIB >= '" + Dtos( (dDatabase) - nTetoMax ) + "' "

cQuery += " ORDER BY A3_COD, C9_PEDIDO "

MemoWrite("C:\TEMP\STPVREJ.TXT" , cQuery)


If ( SELECT("TRBXXX") ) > 0
	dbSelectArea("TRBXXX")
	TRBAC2->(dbCloseArea())
EndIf

cQuery := ChangeQuery(cQuery)

TcQuery cQuery Alias "TRBXXX" New

dbSelectArea("TRBXXX")
TRBXXX->(dbGoTop())

conta := 1 //teste

If TRBXXX->( !EOF() )
	While TRBXXX->( !EOF() )

		cVend := TRBXXX->C5_VEND1

		While Alltrim(TRBXXX->C5_VEND1) == Alltrim(cVend)
		
			dDataLIb := STOD(TRBXXX->C9_DATALIB)
			//se dias decorridos for maior igual a 53 ( aqui entra na faixa dos 60 dias, é que o aviso é enviado 7 dias antes)
			//nTetoMax := GetNewpar("STPVREJSE1" , 53) //COLOQUEI O TETO MÁXIMO DE DIAS CORRIDOS PARA O CASO SE ALGUM DIA QUISEREM MUDAR
			//nTetoMin := GetNewpar("STPVREJSE2" , 8 )

			If TRBXXX->DIASCORRIDOS >= nTetoMax

				If "I-LIMITE EXCEDIDO" $ Alltrim(TRBXXX-> REJEICAOFIN)
				//se for limite excedido ou cond.pagto à vista, pega os pedidos rejeitados de 53 dias de hoje pra trás
				
					If Ascan(aPed60, TRBXXX->C9_PEDIDO) == 0
						Aadd(aPed60, TRBXXX->C9_PEDIDO)
						Aadd(aAviso60  , { TRBXXX->C9_FILIAL, TRBXXX->C9_PEDIDO, TRBXXX->C9_CLIENTE, TRBXXX->C9_LOJA, TRBXXX->A1_NOME, TRBXXX->C9_DATALIB, TRBXXX->C5_VEND1, Alltrim(TRBXXX->A3_EMAIL)} )
					Endif

				Elseif TRBXXX->CONDPAG == "501"

					If Ascan(aPed60, TRBXXX->C9_PEDIDO) == 0
						Aadd(aPed60, TRBXXX->C9_PEDIDO)
						Aadd(aAviso60  , { TRBXXX->C9_FILIAL, TRBXXX->C9_PEDIDO, TRBXXX->C9_CLIENTE, TRBXXX->C9_LOJA, TRBXXX->A1_NOME, TRBXXX->C9_DATALIB, TRBXXX->C5_VEND1, Alltrim(TRBXXX->A3_EMAIL)} )
					Endif

				Endif 

			//se dias decorridos for maior igual a 8
			ElseIf TRBXXX->DIASCORRIDOS >= nTetoMin
				
				//se for outras condições de pagamento e não for rejeição por limite excedido, o prazo de aviso diminui para 8 dias
				If  TRBXXX->CONDPAG <> "501"
					
					If !"I-LIMITE EXCEDIDO" $ TRBXXX-> REJEICAOFIN 
						
						If Ascan(aPed15, TRBXXX->C9_PEDIDO) == 0
							Aadd(aPed15, TRBXXX->C9_PEDIDO)
							Aadd(aAviso15  , { TRBXXX->C9_FILIAL, TRBXXX->C9_PEDIDO, TRBXXX->C9_CLIENTE, TRBXXX->C9_LOJA, TRBXXX->A1_NOME, TRBXXX->C9_DATALIB, TRBXXX->C5_VEND1, Alltrim(TRBXXX->A3_EMAIL)} )
						Endif
						
					Endif

				Endif  
			
			Endif 
			TRBXXX->(Dbskip())
		Enddo
		
		//envia o aviso dos pedidos com rejeição a partir de 60 dias avisando que vai cancelar
		If Len(aPed60) > 0
			PVREJMAIL(aAviso60,"60 Dias","1")
		Endif 

			//envia o aviso dos pedidos com rejeição a partir de 15 dias avisando que vai cancelar
		If Len(aPed15) > 0
			PVREJMAIL(aAviso15,"15 Dias","1")
		Endif

		//limpa os arrays para o próximo vendedor 
		aPed60   := {}
		aPed15   := {}
		aAviso60 := {}
		aAviso15 := {}

	Enddo 
	
	//U_STELIMRES(aPed60)  //NÃO CANCELA SÓ AVISA
	//U_STELIMRES(aPed15)  //NÃO CANCELA SÓ AVISA
	
Endif  //se não for EOF

//reseta o ambiente
RstMvBuff()
DelClassIntf()
RpcClearEnv()
RESET ENVIRONMENT

Return

//==============================================================================================//
//Programa: U_PVREJCAN
//Autoria : Flávia Rocha - Sigamat Consultoria
//Data    : 27/07/2022
//Objetivo: Job para CANCELAR os pedidos rejeitados pelo financeiro há mais de 53 dias corridos
//          E enviar email avisando ao vendedor, copiando o Financeiro,
//          No email informar que qdo completar 60 dias de rejeição, já cancela
//Filtro  : Desde que os campos C5_XFINCAN e C5_XCOMCAN estejam diferentes de '1'
//          1=Impede Cancelamento Automatico;2=Permite Cancelamento Automatico 
//==============================================================================================//
User Function PVREJCAN()	

Local cQuery 	:= ""	
Local dDataDe   := Ctod("  /  /    ")
Local dDataLIb  := Ctod("  /  /    ")
Local cDataDe   := ""
Local aPed60	:= {}
Local aPed15 	:= {}
Local aAviso60	:= {}
Local aAviso15  := {}

Local nTetoMax  := 0 
Local nTetoMin  := 0 

/*
REGRA:

PEDIDOS COM A REJEIÇÃO I-LIMITE EXCEDIDO - 60 DIAS

PEDIDOS COM A CONDIÇAO DE PAGAMENTO 501 (A VISTA) - 60 DIAS

PEDIDOS COM OUTRAS REJEIÇÕES E CONDIÇÕES DE PAGAMENTO - 15 DIAS 

------------------
C9_BLCRED (campo)
-----------------
Código atribuído:

01 - Bloqueio de Crédito por Valor   

04 - Vencimento do Limite de Crédito - Data de Crédito Vencida 

05 - Bloqueio Manual/Estorno

09 - Liberação de Crédito Rejeitada

10 - Faturado

ZZ - Liberação Tardia
*/


RpcSetType( 3 )
RpcSetEnv( "11", "01",,,"FAT")	
 

//estipulei 30 dias porque daqui irei calcular se está rejeitado há mais de 7 dias úteis
dDataDe := dDatabase - 30
cDataDe := DtoS(dDataDe)

DbSelectArea("SC5")

nTetoMax := GetNewpar("STPVREJCA1" , 60) //COLOQUEI O TETO MÁXIMO DE DIAS CORRIDOS PARA O CASO SE ALGUM DIA QUISEREM MUDAR
nTetoMin := GetNewpar("STPVREJCA2" , 15)


cQuery := "SELECT C9_FILIAL, C9_PEDIDO, C9_ITEM, C9_CLIENTE, C9_LOJA, C9_NFISCAL, C9_DATALIB, C9_BLCRED, A1_NOME " + CHR(13) + CHR(10)

cQuery += " ,C5_ZMOTREJ AS REJEICAOFIN "  + CHR(13) + CHR(10) //campo "Rejeição Fin." 
cQuery += " ,C5_CONDPAG AS CONDPAG "      + CHR(13) + CHR(10)
cQuery += " , ( '" + Dtos( dDatabase)  + "' - C9_DATALIB ) AS DIASCORRIDOS " + CHR(13) + CHR(10)
cQuery += " , C5_VEND1 "				  + CHR(13) + CHR(10)
cQuery += " , A3_EMAIL "				  + CHR(13) + CHR(10)

cQuery += " FROM       " + RetSqlName("SC9") + " SC9 "	+ CHR(13) + CHR(10)
cQuery += " INNER JOIN " + RetSqlName("SC5") + " SC5 " 	+ CHR(13) + CHR(10)
cQuery += " ON  SC5.C5_FILIAL  = SC9.C9_FILIAL AND SC5.C5_NUM = SC9.C9_PEDIDO " 	+ CHR(13) + CHR(10)
cQuery += " AND SC5.C5_CLIENTE = SC9.C9_CLIENTE AND SC5.C5_LOJACLI = SC9.C9_LOJA "	+ CHR(13) + CHR(10)
cQuery += " AND SC5.D_E_L_E_T_ = '' "												+ CHR(13) + CHR(10)

cQuery += " INNER JOIN " + RetSqlName("SA1") + " SA1 " 	+ CHR(13) + CHR(10)
cQuery += " ON  SC5.C5_CLIENTE = SA1.A1_COD AND SC5.C5_LOJACLI = SA1.A1_LOJA "	+ CHR(13) + CHR(10)
cQuery += " AND SA1.D_E_L_E_T_ = '' "	

cQuery += " INNER JOIN " + RetSqlName("SA3") + " SA3 " 	+ CHR(13) + CHR(10)
cQuery += " ON  SC5.C5_VEND1 = SA3.A3_COD "	+ CHR(13) + CHR(10)
cQuery += " AND SA3.D_E_L_E_T_ = '' "										

//1=Impede Cancelamento Automatico;2=Permite Cancelamento Automatico
If FieldPos("C5_XFINCAN") > 0
	cQuery += " AND SC5.C5_XFINCAN <> '1' "  + CHR(13) + CHR(10) 
Endif 

If FieldPos("C5_XCOMCAN") > 0
	cQuery += " AND SC5.C5_XCOMCAN <> '1' "  + CHR(13) + CHR(10) 
Endif 

cQuery += " WHERE SC9.D_E_L_E_T_ = ' ' " 			+ CHR(13) + CHR(10)
cQuery += " AND C9_NFISCAL = ' ' " 					+ CHR(13) + CHR(10)
cQuery += " AND C9_BLCRED = '09' "    				+ CHR(13) + CHR(10)

cQuery += " AND C9_DATALIB >= '" + Dtos( (dDatabase) - nTetoMax ) + "' "

cQuery += " ORDER BY A3_COD, C9_PEDIDO "

MemoWrite("C:\TEMP\STPVREJ.TXT" , cQuery)


If ( SELECT("TRBXXX") ) > 0
	dbSelectArea("TRBXXX")
	TRBAC2->(dbCloseArea())
EndIf

cQuery := ChangeQuery(cQuery)

TcQuery cQuery Alias "TRBXXX" New

dbSelectArea("TRBXXX")
TRBXXX->(dbGoTop())

conta := 1 //teste

If TRBXXX->( !EOF() )
	While TRBXXX->( !EOF() )

		cVend := TRBXXX->C5_VEND1

		While Alltrim(TRBXXX->C5_VEND1) == Alltrim(cVend)
		
			dDataLIb := STOD(TRBXXX->C9_DATALIB)
			
			//nTetoMax := GetNewpar("STPVREJSE1" , 53) //COLOQUEI O TETO MÁXIMO DE DIAS CORRIDOS PARA O CASO SE ALGUM DIA QUISEREM MUDAR
			//nTetoMin := GetNewpar("STPVREJSE2" , 8 )

			If TRBXXX->DIASCORRIDOS >= nTetoMax

				If "I-LIMITE EXCEDIDO" $ Alltrim(TRBXXX-> REJEICAOFIN)
				//se for limite excedido ou cond.pagto à vista, pega os pedidos rejeitados de 53 dias de hoje pra trás
				
					If Ascan(aPed60, TRBXXX->C9_PEDIDO) == 0
						Aadd(aPed60, TRBXXX->C9_PEDIDO)
						Aadd(aAviso60  , { TRBXXX->C9_FILIAL, TRBXXX->C9_PEDIDO, TRBXXX->C9_CLIENTE, TRBXXX->C9_LOJA, TRBXXX->A1_NOME, TRBXXX->C9_DATALIB, TRBXXX->C5_VEND1, Alltrim(TRBXXX->A3_EMAIL)} )
					Endif

				Elseif TRBXXX->CONDPAG == "501"

					If Ascan(aPed60, TRBXXX->C9_PEDIDO) == 0
						Aadd(aPed60, TRBXXX->C9_PEDIDO)
						Aadd(aAviso60  , { TRBXXX->C9_FILIAL, TRBXXX->C9_PEDIDO, TRBXXX->C9_CLIENTE, TRBXXX->C9_LOJA, TRBXXX->A1_NOME, TRBXXX->C9_DATALIB, TRBXXX->C5_VEND1, Alltrim(TRBXXX->A3_EMAIL)} )
					Endif

				Endif 

			//se dias decorridos for maior igual a 8
			ElseIf TRBXXX->DIASCORRIDOS >= nTetoMin
				
				//se for outras condições de pagamento e não for rejeição por limite excedido, o prazo de aviso diminui para 8 dias
				If  TRBXXX->CONDPAG <> "501"
					
					If !"I-LIMITE EXCEDIDO" $ TRBXXX-> REJEICAOFIN 
						
						If Ascan(aPed15, TRBXXX->C9_PEDIDO) == 0
							Aadd(aPed15, TRBXXX->C9_PEDIDO)
							Aadd(aAviso15  , { TRBXXX->C9_FILIAL, TRBXXX->C9_PEDIDO, TRBXXX->C9_CLIENTE, TRBXXX->C9_LOJA, TRBXXX->A1_NOME, TRBXXX->C9_DATALIB, TRBXXX->C5_VEND1, Alltrim(TRBXXX->A3_EMAIL)} )
						Endif
						
					Endif

				Endif  
			
			Endif 
			TRBXXX->(Dbskip())
		Enddo
		
		//envia o aviso dos pedidos com rejeição a partir de 60 dias avisando que vai cancelar
		If Len(aPed60) > 0
			PVREJMAIL(aAviso60,"60 Dias","2")
		Endif 

			//envia o aviso dos pedidos com rejeição a partir de 15 dias avisando que vai cancelar
		If Len(aPed15) > 0
			PVREJMAIL(aAviso15,"15 Dias","2")
		Endif

		//limpa os arrays para o próximo vendedor 
		aPed60   := {}
		aPed15   := {}
		aAviso60 := {}
		aAviso15 := {}

	Enddo 
	
	U_STELIMRES(aPed60)  //aqui cancela mesmo
	U_STELIMRES(aPed15)  //aqui cancela mesmo
	
Endif  //se não for EOF

//reseta o ambiente
RstMvBuff()
DelClassIntf()
RpcClearEnv()
RESET ENVIRONMENT

Return


/*/{Protheus.doc} zDiasUteis
Função que retorna a quantidade de dias úteis entre duas datas
@author Atilio
@since 25/10/2016
@version 1.0
@type function
    @param dDtIni, date, Data inicial a ser considerada
    @param dDtFin, date, Data final a ser considerada
    @example u_zDiasUteis(sToD("20161001"), sToD("20161025"))
    u_zDiasUteis(FirstDate(dDataBase), LastDate(dDataBase))
    @obs Quanto as feriados, eles devem estar cadastrados na SX5, tabela "63"
/*/
 
User Function zDiasUteis(dDtIni, dDtFin)
    Local aArea    := GetArea()
    Local nDias    := 0
    Local dDtAtu   := sToD("")
    Default dDtIni := dDataBase
    Default dDtFin := dDataBase
     
    //Enquanto a data atual for menor ou igual a data final
    dDtAtu := dDtIni
    While dDtAtu <= dDtFin
        //Se a data atual for uma data Válida
        If dDtAtu == DataValida(dDtAtu) 
            nDias++
        EndIf
         
        dDtAtu := DaySum(dDtAtu, 1)
    EndDo
     
    RestArea(aArea)
Return nDias


//----------------------------------------------------------------------------//
//Função : PVREJMAIL
//Autoria: Flávia Rocha - 04/08/2022 - Sigamat Consultoria
//Esta função envia o aviso ao vendedor copiando o Financeiro,
//Aviso de que daqui a 7 dias vai cancelar o pedido
//----------------------------------------------------------------------------//
Static Function PVREJMAIL(aAviso,cTipo,cTipoMail)

Local cMailTo := ""
Local cCopia  := ""
Local cAssun  := ""
Local cCorpo  := ""
Local cAnexo  := ""
Local fr      := 0

//Aadd(aAviso15  , { TRBXXX->C9_FILIAL, TRBXXX->C9_PEDIDO, TRBXXX->C9_CLIENTE, TRBXXX->C9_LOJA, TRBXXX->A1_NOME, TRBXXX->C9_DATALIB, TRBXXX->C5_VEND1, Alltrim(TRBXXX->A3_EMAIL)} )

cMailto := GetNewPar("STPVREJ", "daniel.santos@steck.com.br;david.souza@steck.com.br")  //quem recebe o email aviso de pedidos cancelados
//cMailTo += ";flah.rocha@sigamat.com.br"  //retirar
//cMailTo += ";aAviso[1,8]  //retirar
		
If !Empty(cMailTo)

	cCopia  := ""
	cAssun  := "AVISO de Cancelamento Automático de Pedidos Rejeitados pelo FINANCEIRO - " + cTipo
				
	cCorpo  := "Olá " + aAviso[1,8] + "," + CHR(13) + CHR(10) + CHR(13) + CHR(10) 

	cCopia  := aAviso[1,8]  //email do vendedor

	If cTipoMail == "1" //só aviso que vai cancelar
		
		cCorpo  += "Informamos que o(s) seguinte(s) pedido(s) Será(ão) cancelado(s) por eliminação de Resíduo em 7 Dias, " + CHR(13) + CHR(10)
		cCorpo  += "caso o motivo de rejeição informado pelo financeiro não seja solucionado, " + CHR(13) + CHR(10)
		
	Else 
		cCorpo  += "Informamos que O(s) Seguinte(s) Pedido(s) Foi(ram) Cancelado(s) Por Eliminação de Resíduo, " + CHR(13) + CHR(10)		
	Endif

	cCorpo  += CHR(13) + CHR(10)
	cCorpo  += "Motivo: Pedido(s) Rejeitado(s) Pelo Financeiro: "+ CHR(13) + CHR(10)
	cCorpo  += CHR(13) + CHR(10)
	cAnexo  := ""
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Definicao do cabecalho do email                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cMsg := ""
	cMsg := cCorpo + CHR(13) + CHR(10)
	cMsg += '<html>'
	cMsg += '<head>'
	cMsg += '<title>' + cAssun + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
	cMsg += '</head>'
	cMsg += '<body>'
	cMsg += '<HR Width=90% Size=3 Align=Centered Color=Red> <P>'
	cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=90%>'
	cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + cAssun +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
	//cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + cCorpo + '</FONT> </Caption>'

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Definicao do texto/detalhe do email                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cMsg += '<TR BgColor=#FFFFFF>'

	//cabeçalho da msg:  
	cMsg += '<TD align=center><B><Font Color=#000000 Size="2" Face="Arial">FILIAL</Font></B></TD>'
	cMsg += '<TD align=center><B><Font Color=#000000 Size="2" Face="Arial">PEDIDO</Font></B></TD>'
	cMsg += '<TD align=center><B><Font Color=#000000 Size="2" Face="Arial">CLIENTE</Font></B></TD>'
	cMsg += '<TD align=center><B><Font Color=#000000 Size="2" Face="Arial">NOME CLIENTE</Font></B></TD>'
	cMsg += '<TD align=center><B><Font Color=#000000 Size="2" Face="Arial">DATA REJEIÇÃO</Font></B></TD>'
	
	For fr := 1 to Len(aAviso)
		If (fr/2) == Int( fr/2 )
			cMsg += '<TR BgColor=#B0E2FF>'
		Else
			cMsg += '<TR BgColor=#FFFFFF>'
		EndIf
		
		cMsg += '<TD align=center><Font Color=#000000 Size="2" Face="Arial">' + aAviso[fr,1] + ' </Font></TD>'
		cMsg += '<TD align=center><Font Color=#000000 Size="2" Face="Arial">' + aAviso[fr,2] + ' </Font></TD>'
		cMsg += '<TD align=center><Font Color=#000000 Size="2" Face="Arial">' + aAviso[fr,3] + "/" + aAviso[fr,4] 	+ ' </Font></TD>'
		cMsg += '<TD align=center><Font Color=#000000 Size="2" Face="Arial">' + aAviso[fr,5] + ' </Font></TD>'
		cMsg += '<TD align=center><Font Color=#000000 Size="2" Face="Arial">' + Dtoc(StoD(aAviso[fr,6] )) 			+ ' </Font></TD>'
					
		Next
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do rodape do email                                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		cMsg += '</Table>'
		cMsg += '<P>'
		cMsg += '<Table align="center">'
		cMsg += '<tr>'
		cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">(PVREJMAIL)</td>'
		cMsg += '</tr>'
		cMsg += '</Table>'
		cMsg += '<HR Width=90% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '</body>'
		cMsg += '</html>'				

	//FRSendMail(cMailTo, cCopia, cAssun, cMsg, cAnexo )	//para testes retirar
	U_STMAILTES(cMailTo, cCopia, cAssun, cMsg, cAnexo)		//envia email ao término do processo
	
Endif 

Return



/*==========================================================================
|Funcao    | FRSendMail          | Flávia Rocha          | Data | 12/08/2015|
============================================================================
|Descricao | Envia um email                              				   | 
|                                   	  						           |
============================================================================
|Observações: Genérico      											   |
==========================================================================*/
//FUNÇÃO FR PARA TESTES
Static Function FRSendMail(cMailTo, cCopia, cAssun, cCorpo, cAnexo )

//Local cEmailCc  := cCopia
Local lResult   := .F. 
Local lEnviado  := .F.
Local cError    := ""


//Local cAccount	:= GetMV( "MV_RELACNT" )
//Local cPassword 	:= GetMV( "MV_RELPSW"  )
//Local cServer		:= GetMV( "MV_RELSERV" )
//Local cFrom		:= GetMV( "MV_RELACNT" )   


Local cAccount	:= "wfprotheus7@steck.com.br" 
Local cPassword := "Teste123"  
Local cServer	:= "smtp.office365.com"
Local cFrom		:= "wfprotheus7@steck.com.br"

//Local cAttach 	:= cAnexo

CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword RESULT lResult

if lResult
	
	//MailAuth( GetMV( "MV_RELACNT" ), GetMV( "MV_RELPSW"  ) ) //realiza a autenticacao no servidor de e-mail.
	MailAuth( cAccount, cPassword ) //realiza a autenticacao no servidor de e-mail.

	SEND MAIL FROM cFrom;
	TO cMailTo;
	CC cCopia;
	SUBJECT cAssun;
	BODY cCorpo;
	ATTACHMENT cAnexo RESULT lEnviado
	
	if !lEnviado
		//Erro no envio do email
		GET MAIL ERROR cError
		Help(" ",1,"ATENCAO",,cError,4,5)
		//Msgbox("E-mail não enviado...")	
	//else
		//MsgInfo("E-mail Enviado com Sucesso!")
	endIf
	
	DISCONNECT SMTP SERVER
	
else
	//Erro na conexao com o SMTP Server
	GET MAIL ERROR cError
	Help(" ",1,"ATENCAO",,cError,4,5)
endif

Return(lResult .And. lEnviado )
