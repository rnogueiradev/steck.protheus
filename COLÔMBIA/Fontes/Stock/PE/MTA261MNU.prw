#include "rwmake.ch"
#include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTA261MNU    ºAutor  ³Cristiano Pereira º Data ³  03/18/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Montagem de bota na tela , rotina transferencia mod II      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MTA261MNU()
	aAdd(aRotina,{"cargar productos","u_M261MNU()", 0, 2, 0, Nil })
return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M261B    ºAutor  ³Cristiano Pereira º Data ³  03/18/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Montagem de bota na tela , rotina transferencia mod II      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function M261MNU()

	Private _cNF := Space(13),oNF
	Private _cArmz := Space(2),oArmz

	Define MsDialog oMTRMT43 Title "cargar productos" From 9,0 To 20,55


	DEFINE FONT oFont1 NAME "Arial" SIZE 0,-20 BOLD
	DEFINE FONT oFont2 NAME "Arial" SIZE 0,-15 BOLD

	@ 020,002 To 100,300

	@ 012,010 Say "Introduce la factura " Color CLR_HRED Of oMTRMT43 PIXEL FONT oFont1
	@ 012,110 Say "Deposito de destino " Color CLR_HRED Of oMTRMT43 PIXEL FONT oFont1

	@ 040,010 MSGET oNF  VAR _cNF   SIZE 50,8 PIXEL Of oMTRMT43   Valid NAOVAZIO() When .t.
	@ 040,0110 MSGET oArmz  VAR _cArmz   SIZE 20,8 PIXEL Of oMTRMT43   Valid NAOVAZIO() When .t.


	oSButton1 := SButton():New( 070,60,1,{||u_xBusca()},oMTRMT43 ,.T.,,)
	oSButton1 := SButton():New( 070,110,2,{|| Close(oMTRMT43)},oMTRMT43 ,.T.,,)

	Activate MsDialog oMTRMT43 Centered

return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M261B    ºAutor  ³Cristiano Pereira º Data ³  03/18/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Montagem de bota na tela , rotina transferencia mod II      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function xBusca()

	Local aAuto := {}
	Local aItem := {}
	Local aLinha := {}
	Local nX:=1

	Local nOpcAuto := 3

	Private lMsErroAuto := .F.

	DbSelectArea("SD1")
	DbSetOrder(1)
	If DbSeek(xFilial("SD1")+_cNF )


		//Cabecalho a Incluir
		aadd(aAuto,{GetSxeNum("SD3","D3_DOC"),dDataBase}) //Cabecalho
		//Itens a Incluir
		aItem := {}

		While !SD1->(EOF()) .AND. _cNF== SD1->D1_DOC .And. SD1->D1_FILIAL == xFilial("SD1")

			aLinha := {}

			DbSelectArea("SB2")
			DbSetOrder(1)
			If DbSeek(xFilial("SB2")+SD1->D1_COD+"03")

				//Origem
				SB1->(DbSeek(xFilial("SB1")+PadR(SD1->D1_COD, tamsx3('D3_COD') [1])))
				aadd(aLinha,{"ITEM",'00'+cvaltochar(nX),Nil})
				aadd(aLinha,{"D3_COD", SB1->B1_COD, Nil}) //Cod Produto origem
				aadd(aLinha,{"D3_DESCRI", SB1->B1_DESC, Nil}) //descr produto origem
				aadd(aLinha,{"D3_UM", SB1->B1_UM, Nil}) //unidade medida origem
				aadd(aLinha,{"D3_LOCAL", "02", Nil}) //armazem origem
				aadd(aLinha,{"D3_LOCALIZ", "",Nil}) //Informar endereço origem

				//Destino
				SB1->(DbSeek(xFilial("SB1")+PadR(SD1->D1_COD, tamsx3('D3_COD') [1])))
				aadd(aLinha,{"D3_COD", SB1->B1_COD, Nil}) //cod produto destino
				aadd(aLinha,{"D3_DESCRI", SB1->B1_DESC, Nil}) //descr produto destino
				aadd(aLinha,{"D3_UM", SB1->B1_UM, Nil}) //unidade medida destino
				aadd(aLinha,{"D3_LOCAL", "03", Nil}) //armazem destino
				aadd(aLinha,{"D3_LOCALIZ", "",Nil}) //Informar endereço destino

				aadd(aLinha,{"D3_NUMSERI", "", Nil}) //Numero serie
				aadd(aLinha,{"D3_LOTECTL", "", Nil}) //Lote Origem
				aadd(aLinha,{"D3_NUMLOTE", "", Nil}) //sublote origem
				aadd(aLinha,{"D3_DTVALID", '', Nil}) //data validade
				aadd(aLinha,{"D3_POTENCI", 0, Nil}) // Potencia
				aadd(aLinha,{"D3_QUANT", SD1->D1_QUANT, Nil}) //Quantidade
				aadd(aLinha,{"D3_QTSEGUM", 0, Nil}) //Seg unidade medida
				aadd(aLinha,{"D3_ESTORNO", "", Nil}) //Estorno
				aadd(aLinha,{"D3_NUMSEQ", "", Nil}) // Numero sequencia D3_NUMSEQ

				aadd(aLinha,{"D3_LOTECTL", "", Nil}) //Lote destino
				aadd(aLinha,{"D3_NUMLOTE", "", Nil}) //sublote destino
				aadd(aLinha,{"D3_DTVALID", '', Nil}) //validade lote destino
				aadd(aLinha,{"D3_ITEMGRD", "", Nil}) //Item Grade

				aadd(aLinha,{"D3_CODLAN", "", Nil}) //cat83 prod origem
				aadd(aLinha,{"D3_CODLAN", "", Nil}) //cat83 prod destino

				nX++

			aAdd(aAuto,aLinha)

			else
             Msgalert("El deposito de destino no existe para el producto "+SD1->D1_COD,"Atenção")
			Endif

			DbSelectArea("SD1")
			DbSkip()
		Enddo



		MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto)

		If lMsErroAuto
			MostraErro()
		else
			MsgInfo("Transferencia realizada con éxito.","Atención")
		EndIf

	Endif



	Close(oMTRMT43)
return

