#include 'Protheus.ch'
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STTMP03 ºAutor  ³Cristiano Pereira    º Data ³  10/24/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Correção data da aprovação do lançamento contábil          º±±
±±º          ³ Manaus x distribuidora                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STTMP03()

Local aPergs  := {}
Local aRet    := {}
PRIVATE cDATA1 := Ctod(Space(8))
PRIVATE cDATA2 := Ctod(Space(8))


aAdd( aPergs ,{1,"Data de",  cDATA1   ,"@D 99/99/9999"	   ,'.T.'    ,''   ,'.T.',50,.F.}) 
aAdd( aPergs ,{1,"Data até", cDATA2    ,"@D 99/99/9999"	   ,'.T.'    ,''   ,'.T.',50,.F.}) 

ParamBox(aPergs ,"Entre com os dados", @aRet)  

Processa( {|| U_STP03A() } )
return


user Function STP03A()



	Local _cQryCT2   :=  ""



	If Select("TCT2") > 0
		DbSelectArea("TCT2")
		DbCloseArea()
	Endif

	_cQryCT2 :=   " SELECT CT2.R_E_C_N_O_ AS RECNO ,CT2.*              "
	_cQryCT2 +=   " FROM "+RetSqlName("CT2")+ "  CT2                   "
	_cQryCT2 +=   " WHERE CT2.CT2_FILIAL = '"+xFilial("CT2")+"' AND    "
	_cQryCT2 +=   "       CT2.D_E_L_E_T_ <> '*'                 AND    "
	_cQryCT2 +=   "       CT2.CT2_DATA >='"+DTOS(MV_PAR01)+"'         AND    "
	_cQryCT2 +=   "       CT2.CT2_DATA <='"+DTOS(MV_PAR02)+"'             "


	TCQUERY _cQryCT2  NEW ALIAS "TCT2"

	_nRec   := 0
	DbEval({|| _nRec++  })
  
    ProcRegua(_nRec)

	DbSelectArea("TCT2")
	DbGotop()

	While !TCT2->(EOF())



	   IncProc("Processando lançamento contábil ........."+TCT2->CT2_FILIAL+TCT2->CT2_DATA+TCT2->CT2_LOTE+TCT2->CT2_SBLOTE+TCT2->CT2_DOC+TCT2->CT2_LINHA+TCT2->CT2_TPSALD+TCT2->CT2_EMPORI+TCT2->CT2_FILORI+TCT2->CT2_MOEDLC)

		DbSelectArea("CT2")
		DbSetOrder(1)
		If DbSeek(TCT2->CT2_FILIAL+TCT2->CT2_DATA+TCT2->CT2_LOTE+TCT2->CT2_SBLOTE+TCT2->CT2_DOC+TCT2->CT2_LINHA+TCT2->CT2_TPSALD+TCT2->CT2_EMPORI+TCT2->CT2_FILORI+TCT2->CT2_MOEDLC)


			If Rtrim(CT2->CT2_ROTINA)=='CTBA102'

				If Empty(CT2->CT2_XDATAP) .Or. ( CT2->CT2_DATA>=Ctod("01/01/2023") .And.  CT2->CT2_XDATAP < Ctod("01/01/2023") ) .Or. Rtrim(CT2->CT2_XRESP1) <> "marcio.caldeira" .Or.  CT2->CT2_XDATAP < CT2->CT2_DATA
					If Reclock("CT2",.F.)
						CT2->CT2_XDATAP := CT2->CT2_DATA+1
						CT2->CT2_XRESP1 := "marcio.caldeira"
						CT2->CT2_XNOME1 := "marcio.caldeira"
						CT2->CT2_X_USER := FWLeUserlg("CT2_USERGI",1)
						MsUnlock()
					Endif
				else
					If Reclock("CT2",.F.)
						If Rtrim(FWLeUserlg("CT2_USERGI",1))=="erika.anjos"
							CT2->CT2_X_USER := "hista.oliveira"
						Else
							CT2->CT2_X_USER := FWLeUserlg("CT2_USERGI",1)
						endif
						MsUnlock()
					Endif
				Endif
			else

				If Rtrim(CT2->CT2_ROTINA)<>'CTBA102'

				   If Reclock("CT2",.F.)
						CT2->CT2_XDATAP := Ctod(Space(8))
						CT2->CT2_XDATA2 := Ctod(Space(8))
						CT2->CT2_XHORA1 := "  :  "
						CT2->CT2_XHORA2 := "  :  "
						CT2->CT2_XRESP1 := ""
						CT2->CT2_XRESP2 := ""
						CT2->CT2_XNOME1 := ""
						CT2->CT2_XNOME2 := ""
						CT2->CT2_X_USER := FWLeUserlg("CT2_USERGI",1)
						MsUnlock()
					Endif

				Endif

			Endif
		Endif

		DbSelectArea("TCT2")
		DbSkip()
	Enddo

	MsgInfo("Processo concluído com sucesso!!!","Atenção")


return
