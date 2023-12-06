#INCLUDE "Protheus.ch"
#INCLUDE "APVT100.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTEMBAM1   บAutor  ณRenato Nogueira     บ Data ณ  11/12/14  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณTela para bipar produtos do embarque	    		           บฑฑ
ฑฑบ          ณ					                                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametro ณ Nenhum                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบRetorno   ณ Nenhum 	    									              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function STEMBAM1()

	Local aOpcoes			:= {}
	Local aOpcoes2			:= {}
	Local aItensSel			:= {.T.,.T.}
	Local aItensSel2		:= {.T.,.T.}
	Local cTitulo			:= "Menu"
	Local cMsg				:= "Escolha a op็ใo desejada"
	Local cEtiqueta			:= space(48)
	Local lRet				:= .T.
	Local lEtiq				:= .F.
	Private bkey09
	Private nOpcao			:= 0
	Private nOpcao2			:= 0
	Private cNumEmb			:= ""
	Private cPallet			:= ""
	Private cVolume			:= ""
	Private cAglVol			:= ""
	Private cFilDest		:= space(2)
	Private cProduto		:= ""
	Private nQE				:= 0
	Private cLote			:= ""
	Private cNumSer			:= ""
	Private cOp				:= ""
	Private cLoteX			:= ""
	Private lGravou			:= .F.
	Private lAltera			:= .F.
	Private _lNewPallet		:= .F.
	Private _lVolMax		:= .F.
	Private _lContAglu		:= .F.
	Private _aVolMax		:= {}

	bkey09 := VTSetKey(09,{|| U_NEWPALLET()},"Novo Pallet")


	If cEmpAnt == "03"
		aOpcoes2	:= {"Steck","Schneider"}
	Elseif cEmpAnt == "01"
		aOpcoes2	:= {"Steck","Schneider"}
	Endif

	If Len(aOpcoes2) > 0

		aOpcoes	:= {"Incluir","Alterar","Estornar","Fechar","Aglutinacao"}
		nOpcao 	:= VTACHOICE(0, 0, 7, 19, aOpcoes, aItensSel)

		DO CASE

			//------------------------------------------------------------------------------------------------------------------------------------------
		CASE nOpcao == 1 //Inclusใo

			If CBYesNo("Deseja iniciar um novo embarque?",".:AVISO:.",.t.)

				cAglVol	:= "001"
				cVolume	:= "0001"
				cPallet	:= "001"
				//cNumEmb	:= GetSX8Num("ZZT","ZZT_NUMEMB")
				cNumEmb	:= "NOVO"

				VTCLEARBUFFER()
				VTCLEAR

				nOpcao2 	:= VTACHOICE(0, 0, 7, 19, aOpcoes2, aItensSel2)

				While lRet


					@ 0,0 VTSAY Padc("Embarque: "+cNumEmb,VTMaxCol())
					@ 2,0 VTSAY "Loja/Filial Destino"
					@ 3,0 VTGET cFilDest PICTURE "@!" VALID ;
						Iif ( nOpcao2==1,Iif(!(cFilDest $ "01#02#03#04#05#06" );
						,(VtAlert("Atencao, Loja diferente de 01-Fabrica, 06-CD,03-Itaquera,04 ou 05!"),.F.),.T.),;
						Iif(!(cFilDest $ "#09#10" );
						,(VtAlert("Atencao, Loja diferente de 09-CAJAMAR e 10-GUARAREMA!"),.F.),.T.))
					@ 4,0 VTSAY "Pallet"
					@ 5,0 VTGET cPallet PICTURE "@!" VALID STVERNUM(cPallet) WHEN .F.

					VTREAD

					If !Empty(cPallet)
						cPallet	:= PADL(ALLTRIM(cPallet),3,"0")
					EndIf

					If VTLASTKEY()==27
						If CBYesNo("Confirma saida?",".:AVISO:.",.t.)
							If !lGravou
								RollBackSX8()
							EndIf
							Return
						Endif
					Endif

					If Empty(cFilDest) .Or. Empty(cPallet)
						Loop
					Else
						Exit
					EndIf

				EndDo

				lRet	:= .T.

				While lRet

					VTCLEARBUFFER()
					VTCLEAR
					/*
					If !_lVolMax .and. cNumEmb == "NOVO"

						If CBYesNo("Deseja Iniciar um Embarque Aglutinado?",".:AVISO:.",.t.)

							_lVolMax := .T.

						EndIf

					EndIf
					*/

					IF _lVolMax

						@ 0,0  VTSAY Padc("Embarque Aglut Vol ",VTMaxCol())
					Else
						@ 0,0  VTSAY Padc("Embarque: "+cNumEmb,VTMaxCol())
					EndIf

					@ 1,0  VTSAY "Pallet: "
					@ 1,10 VTGET cPallet PICTURE "@!" VALID VldPallet() When .F.
					@ 2,0  VTSAY "Volume: "
					@ 2,10 VTGET cVolume PICTURE "@!" VALID VldVolume() When .F.

					IF _lVolMax

						@ 3,0  VTSAY "Vol. Aglut: "
						@ 3,12 VTGET cAglVol PICTURE "@!" VALID VldAglVol() When .F.

					EndIf

					@ 4,0  VTSAY "Etiqueta"
					@ 5,0  VTGET cEtiqueta PICTURE "@!" VALID lEtiq := STVALETQ(cEtiqueta)//Exemplo de Etiqueta SKB8G|084877|84

					//lEtiq := .t.
					//cProduto 	:= "N3076"
					//nQE  		:= 1

					VTREAD

					If VTLASTKEY()==27

						If _lVolMax

							If CBYesNo("Finalizar Aglutinacao?",".:AVISO:.",.t.)

								_lVolMax := .F.
								STGRVEMB(3)
								cVolume	:= Soma1(cVolume)
								cEtiqueta	:= space(48)

							EndIf
						Else
							If CBYesNo("Confirma saida ?",".:AVISO:.",.t.)
								If !lGravou
									RollBackSX8()
								EndIf
								Return
							EndIf
						Endif

					Endif


					If Empty(cEtiqueta)
						Loop
					EndIf

					If lEtiq

						STGRVEMB(3)

						IF !_lVolMax
							cVolume	:= Soma1(cVolume)
						EndIf

						IF _lVolMax
							cAglVol	:= Soma1(cAglVol)
						EndIf

						cEtiqueta	:= space(48)
					Else
						cEtiqueta	:= space(48)
					EndIf

					If VTLASTKEY()==27
						If CBYesNo("Confirma saida ?",".:AVISO:.",.t.)

							If !lGravou
								RollBackSX8()
							EndIf
							Return
						Endif
					Endif


				EndDo

				VTSetKey(09,bkey09)
				VTSetKey(05,VtAlert("Teste f4!"))

			Else

				RollBackSX8()
				VtAlert("Embarque cancelado!")

			EndIf

			//------------------------------------------------------------------------------------------------------------------------------------------
		CASE nOpcao == 2 //Altera็ใo

			lAltera	:=	.T.

			cNumEmb	:= space(6)
			cPallet	:= space(3)
			cVolume	:= space(4)
			cAglVol	:= Space(3)

			While lRet

				VTCLEARBUFFER()
				VTCLEAR

				@ 0,0 VTSAY Padc("ALTERACAO",VTMaxCol())
				@ 2,0 VTSAY "Embarque: "
				@ 3,0 VTGET cNumEmb PICTURE "@!" VALID CHKEXISTS("1")
				@ 4,0 VTSAY "Pallet:"
				@ 5,0 VTGET cPallet PICTURE "@!" VALID CHKEXISTS("2")
				@ 6,0 VTSAY "Volume:"
				@ 7,0 VTGET cVolume PICTURE "@!" VALID Iif(!Empty(cVolume),CHKEXISTS("3"),.T.)

				VTREAD

				If VTLASTKEY()==27
					If CBYesNo("Confirma saida?",".:AVISO:.",.t.)
						Return
					Endif
				Endif

				If Empty(cNumEmb) .Or. Empty(cPallet)
					Loop
				Else
					Exit
				EndIf

			EndDo

			ZZT->(DbSetOrder(1))
			If !ZZT->(DbSeek(xFilial("ZZT")+cNumEmb))
				VTALERT("Embarque nao encontrado!!!")
			EndIf

			If ZZT->ZZT_CLIENT=="012047" //Schneider
				nOpcao2 := 2
			Else
				nOpcao2 := 1
			EndIf

			lRet	:= .T.

			If Empty(cVolume) //Caso nใo tenha volume, vai incluir um volume novo

				While lRet

					VTCLEARBUFFER()
					VTCLEAR

					If Empty(cVolume) //Pegar novo volume
						GETPROXVOL()
					EndIf

					@ 0,0  VTSAY Padc("Embarque: "+cNumEmb,VTMaxCol())
					@ 1,0  VTSAY "Pallet: "
					@ 1,10 VTGET cPallet PICTURE "@!" VALID VldPallet() When .F.
					@ 2,0  VTSAY "Volume: "
					@ 2,10 VTGET cVolume PICTURE "@!" VALID VldVolume() When .F.
					@ 4,0  VTSAY "Etiqueta"
					@ 5,0  VTGET cEtiqueta PICTURE "@!" VALID lEtiq := STVALETQ(cEtiqueta)

					VTREAD

					If VTLASTKEY()==27
						If CBYesNo("Confirma saida?",".:AVISO:.",.t.)
							Exit
						Endif
					Endif

					If Empty(cEtiqueta)
						Loop
					EndIf

					If lEtiq
						STGRVEMB()
						cEtiqueta	:= space(48)
						GETPROXVOL()
					Else
						cEtiqueta	:= space(48)
					EndIf

					If VTLASTKEY()==27
						If CBYesNo("Confirma saida?",".:AVISO:.",.t.)
							Exit
						Endif
					Endif

				EndDo

			Else //Altera็ใo de volume existente

				While lRet

					VTCLEARBUFFER()
					VTCLEAR

					@ 0,0  VTSAY Padc("Embarque: "+cNumEmb,VTMaxCol())
					@ 1,0  VTSAY "Pallet: "
					@ 1,10 VTGET cPallet PICTURE "@!" VALID VldPallet() When .F.
					@ 2,0  VTSAY "Volume: "
					@ 2,10 VTGET cVolume PICTURE "@!" VALID VldVolume() When .F.
					@ 4,0  VTSAY "Etiqueta"
					@ 5,0  VTGET cEtiqueta PICTURE "@!" VALID lEtiq := STVALETQ(cEtiqueta)

					VTREAD

					If VTLASTKEY()==27
						If CBYesNo("Confirma saida?",".:AVISO:.",.t.)
							Exit
						Endif
					Endif

					If Empty(cEtiqueta)
						Loop
					EndIf

					If lEtiq

						STGRVEMB()
						GETPROXVOL()
						cEtiqueta	:= space(48)

					Else
						cEtiqueta	:= space(48)
					EndIf

					If VTLASTKEY()==27
						If CBYesNo("Confirma saida?",".:AVISO:.",.t.)
							Exit
						Endif
					Endif

					If !_lNewPallet
						Exit
					EndIf

				EndDo

			EndIf

			VTSetKey(09,bkey09)

			//------------------------------------------------------------------------------------------------------------------------------------------
		CASE nOpcao == 3 //Estornar

			cNumEmb	:= space(6)
			cPallet	:= space(3)
			cVolume	:= space(4)
			cAglVol := space(3)
			While lRet

				VTCLEARBUFFER()
				VTCLEAR

				@ 0,0 VTSAY Padc("ESTORNO",VTMaxCol())
				@ 2,0 VTSAY "Embarque: "
				@ 3,0 VTGET cNumEmb PICTURE "@!" VALID CHKEXISTS("1")
				@ 4,0 VTSAY "Pallet:"
				@ 5,0 VTGET cPallet PICTURE "@!" VALID Iif(!Empty(cVolume),CHKEXISTS("2"),.T.)
				@ 6,0 VTSAY "Volume:"
				@ 7,0 VTGET cVolume PICTURE "@!" VALID Iif(!Empty(cVolume),CHKEXISTS("3"),.T.)

				VTREAD

				If VTLASTKEY()==27
					If CBYesNo("Confirma saida?",".:AVISO:.",.t.)
						Return
					Endif
				Endif

				If Empty(cNumEmb)
					Loop
				Else
					Exit
				EndIf

			EndDo

			lRet	:=	.T.

			If !Empty(cNumEmb) .And. Empty(cPallet) .And. Empty(cVolume) //Estorno do embarque
				If CBYesNo("Deseja estornar o embarque: "+AllTrim(cNumEmb)+"?",".:AVISO:.",.t.)
					ZZT->(DbSeek(xFilial("ZZT")+cNumEmb))
					If !ZZT->ZZT_STATUS=="1"
						lRet	:= .F.
						VTALERT("Atencao, este embarque ja foi encerrado!")
						Return
					Else
						DELETEREG("1") //Deleta embarque todo
					EndIf
				EndIf
			ElseIf !Empty(cNumEmb) .And. !Empty(cPallet) .And. Empty(cVolume) //Estorno do pallet
				If CBYesNo("Deseja estornar o pallet: "+AllTrim(cPallet)+"?",".:AVISO:.",.t.)
					ZZT->(DbSeek(xFilial("ZZT")+cNumEmb))
					If !ZZT->ZZT_STATUS=="1"
						lRet	:= .F.
						VTALERT("Atencao, este embarque ja foi encerrado!")
						Return
					Else
						DELETEREG("2") //Deleta pallet todo
					EndIf
				EndIf
			ElseIf !Empty(cNumEmb) .And. !Empty(cPallet) .And. !Empty(cVolume) //Estorno do volume
				If CBYesNo("Deseja estornar o volume: "+AllTrim(cVolume)+"?",".:AVISO:.",.t.)
					ZZT->(DbSeek(xFilial("ZZT")+cNumEmb))
					If !ZZT->ZZT_STATUS=="1"
						lRet	:= .F.
						VTALERT("Atencao, este embarque ja foi encerrado!")
						Return
					Else
						DELETEREG("3") //Deleta volume
					EndIf
				EndIf
			EndIf

			//------------------------------------------------------------------------------------------------------------------------------------------
		CASE nOpcao == 4 //Fechar

			cNumEmb	:= space(6)
			cPallet	:= space(3)
			cVolume	:= space(4)
			cAglVol := space(3)

			While lRet

				VTCLEARBUFFER()
				VTCLEAR

				@ 0,0 VTSAY Padc("FECHAR",VTMaxCol())
				@ 2,0 VTSAY "Embarque: "
				@ 3,0 VTGET cNumEmb PICTURE "@!" VALID CHKEXISTS("1")

				VTREAD

				If VTLASTKEY()==27
					If CBYesNo("Confirma saida?",".:AVISO:.",.t.)
						Return
					Endif
				Endif

				If Empty(cNumEmb)
					Loop
				EndIf

				If ZZT->(DbSeek(xFilial("ZZT")+cNumEmb))
					If ZZT->ZZT_STATUS=="1"
						If CBYesNo("Deseja fechar o embarque "+AllTrim(cNumEmb),".:AVISO:.",.t.)
							ZZT->(RecLock("ZZT",.F.))
							ZZT->ZZT_STATUS	:= "2" //Fechado
							ZZT->(MsUnLock())
							VTALERT("Embarque fechado com sucesso!")
							Exit
						EndIf
					Else
						VTALERT("Embarque nao esta aberto, verifique!")
					EndIf
				EndIf

			EndDo
			//>> Ticket 20191204000023
		CASE nOpcao == 5 //Continuar Aglutina็ใo

			cNumEmb	:= space(6)
			cPallet	:= space(3)
			cVolume	:= space(4)
			cAglVol	:= Space(3)
			_lVolMax := .T.
			_lContAglu := .T.

			While lRet

				VTCLEARBUFFER()
				VTCLEAR

				@ 0,0 VTSAY Padc("CONTINUAR AGLUTINACAO",VTMaxCol())
				@ 2,0 VTSAY "Embarque: "
				@ 3,0 VTGET cNumEmb PICTURE "@!" VALID CHKEXISTS("1")
				@ 4,0 VTSAY "Pallet:"
				@ 5,0 VTGET cPallet PICTURE "@!" VALID CHKEXISTS("2")
				@ 6,0 VTSAY "Volume:"
				@ 7,0 VTGET cVolume PICTURE "@!" VALID Iif(!Empty(cVolume),CHKEXISTS("3"),.T.)

				VTREAD

				If VTLASTKEY()==27
					If CBYesNo("Confirma saida?",".:AVISO:.",.t.)
						Return
					Endif
				Endif

				If Empty(cNumEmb) .Or. Empty(cPallet) .Or. Empty(cVolume)
					Loop
				Else
					Exit
				EndIf

			EndDo

			lRet	:= .T.

			While lRet

				VTCLEARBUFFER()
				VTCLEAR

				@ 0,0  VTSAY Padc("Embarque: "+cNumEmb,VTMaxCol())
				@ 1,0  VTSAY "Pallet: "
				@ 1,10 VTGET cPallet PICTURE "@!" VALID VldPallet() When .F.
				@ 2,0  VTSAY "Volume: "
				@ 2,10 VTGET cVolume PICTURE "@!" VALID VldVolume() When .F.

				If _lContAglu
					PROXVLAG()
				EndIf
				@ 3,0  VTSAY "Vol. Aglut: "
				@ 3,12 VTGET cAglVol PICTURE "@!" VALID VldAglVol() When .F.

				@ 4,0  VTSAY "Etiqueta"
				@ 5,0  VTGET cEtiqueta PICTURE "@!" VALID lEtiq := STVALETQ(cEtiqueta)

				//lEtiq := .T.
				//cProduto 	:= "N3076"
				//nQE  		:= 1

				VTREAD

				If VTLASTKEY()==27

					If _lVolMax

						If CBYesNo("Finalizar Aglutinacao?",".:AVISO:.",.t.)

							_lVolMax := .F.
							STGRVEMB()
							Return
							//cVolume	:= Soma1(cVolume)
							//cEtiqueta	:= space(48)

						EndIf
					Else
						If CBYesNo("Confirma saida ?",".:AVISO:.",.t.)
							If !lGravou
								RollBackSX8()
							EndIf
							Return
						EndIf
					Endif

				Endif

				If Empty(cEtiqueta)
					Loop
				EndIf

				If lEtiq

					If _lVolMax

						STGRVEMB()
						/*
						IF !_lVolMax
							cVolume	:= Soma1(cVolume)
						EndIf
						*/
						IF _lVolMax
							cAglVol	:= Soma1(cAglVol)
						EndIf

					EndIf

					cEtiqueta	:= space(48)

				Else
					cEtiqueta	:= space(48)
				EndIf

				If VTLASTKEY()==27
					If CBYesNo("Confirma saida?",".:AVISO:.",.t.)
						If !lGravou
							RollBackSX8()
						EndIf
						Return
					Endif
				Endif
				/*
				If !_lNewPallet
					Exit
				EndIf
				*/
			EndDo

		ENDCASE
		//<< Ticket 20191204000023
	Else

		VtAlert("Aten็ใo, empresa nao autorizada a utilizar essa rotina!")

	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTVERNUM   บAutor  ณRenato Nogueira     บ Data ณ  11/12/14  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณVerifica se string cont้m n๚meros		    		           บฑฑ
ฑฑบ          ณ					                                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametro ณ cPallet                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบRetorno   ณ L๓gico 	    									              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function STVERNUM(cPallet)

	Local lRet			:= .T.
	Local i := 0

	For i := Len(cPallet) To 1 Step -1
		If !SubStr(cPallet,i,1) $ "0123456789"
			lRet	:= .F.
		EndIf
	Next

	If !lRet
		VTALERT("Atencao, utilize somente numeros!")
	EndIf

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTVALETQ   บAutor  ณRenato Nogueira     บ Data ณ  11/12/14  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValida etiqueta lida						    		           บฑฑ
ฑฑบ          ณ					                                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametro ณ cEtiqueta                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบRetorno   ณ L๓gico 	    									              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function STVALETQ(cEtiqueta)

	Local lRet			:= .T.
	Local aRet			:= {}


	If Alltrim(cEtiqueta) == 'AG'


		_lVolMax := .T.

		Return

	ElseIf Alltrim(cEtiqueta) == 'P'

		U_NEWPALLET()

		Return

	EndIF

	cEtiqueta	:= AllTrim(cEtiqueta)
	cEtiqueta	:=	U_STAVALET(cEtiqueta) //Rotina para avaliar etiqueta e ajustar para padrใo de leitura do CBRETIEAN - Renato Nogueira - 01/12/2014
	aRet := CBRetEtiEan(cEtiqueta)

	If	Empty(aRet)
		VTALERT("Etiqueta invalida","Aviso")
		lRet	:= .F.
		Return
	EndIf

	DbSelectArea("SB1")
	SB1->(DbGoTop())
	SB1->(DbSetOrder(1))
	If !SB1->(DbSeek(xFilial("SB1")+aRet[01]))
		CBAlert("Produto invalido!",".:AVISO:.",.t.,2000,1)
		Return .f.
	Endif

	If Rastro(aRet[01]) .AND. Empty(aRet[03])
		CBAlert("Produto controla rastreabilidade! Lote nao informado!",".:AVISO:.",.t.,3000,1)
		VTKeyBoard(chr(20))
		Return .f.
	ElseIf !Rastro(aRet[01]) .AND. !Empty(aRet[03])
		CBAlert("Produto nao controla rastreabilidade! Lote informado!",".:AVISO:.",.t.,3000,1)
		VTKeyBoard(chr(20))
		Return .f.
	Endif

	//Verifica se existe saldo disponivel do produto
	SB2->(DbSetOrder(1)) //B2_FILIAL+B2_COD+B2_LOCAL
	If !SB2->(DbSeek(xFilial("SB2")+SB1->(B1_COD)+SuperGetMV("ST_LOCESC",,"15")))
		CBAlert("Produto nao possui saldo disponivel!",".:AVISO:.",.t.,3000,1)
		VTKeyBoard(chr(20))
		Return .f.
	Endif
	nSldDisp := SB2->B2_QATU//SaldoSb2() //GIOVANI ZAGO NAO PRECISA VER O SALDO(B2_QATU-B2_RESERVA) DA B2 NO ARMAZEM 15, SOMENTE SE TEM QUANTIDADE NO ENDEREวO.
	If nSldDisp < aRet[2]
		CBAlert("Produto nao possui saldo disponivel!",".:AVISO:.",.t.,3000,1)
		VTKeyBoard(chr(20))
		Return .f.
	Endif

	If lAltera
		ZZU->(DbSetOrder(1))
		If ZZU->(DbSeek(xFilial("ZZU")+cNumEmb+cPallet+cVolume))
			If !( AllTrim(aRet[1]) == AllTrim(ZZU->ZZU_PRODUT))
				If !VTYESNO("Produto bipado: "+aRet[1]+" Produto atual: "+ZZU->ZZU_PRODUT+" deseja alterar (S/N)")
					lRet	:= .F.
					Return
				EndIf
			EndIf
		EndIf
	EndIf

	If lAltera
		ZZU->(DbSetOrder(1))
		If ZZU->(DbSeek(xFilial("ZZU")+cNumEmb+cPallet+cVolume))
			If !(aRet[2]==ZZU->ZZU_QTDE)
				If !VTYESNO("Qtde bipada: "+CVALTOCHAR(aRet[2])+" Qtde atual: "+CVALTOCHAR(ZZU->ZZU_QTDE)+" deseja alterar (S/N)")
					lRet	:= .F.
					Return
				EndIf
			EndIf
		EndIf
	EndIf

	cProduto 	:= aRet[1]
	nQE  		:= aRet[2]
	cLote  		:= aRet[3]
	cNumSer 	:= aRet[5]
	cLoteX 		:= U_RetLoteX()
	cOp			:= SubStr(cLoteX,1,8)

	If Empty(cOp)
		lRet	:= .F.
		VTALERT("OP nao preenchida","Aviso")
	EndIf

	//Consulta saldo da OP
	If !STSLDOP()
		lRet	:= .F.
		Return
	EndIf

	If	Empty(nQE)
		VTALERT("Quantidade invalida","Aviso")
		lRet	:= .F.
		Return
	EndIf
	conout ('[TELNET] - Antes de acessa a Rotina CONSSALDO')
	If !CONSSALDO()
		lRet	:= .F.
		conout ('[TELNET] - Depois de acessa a Rotina CONSSALDO')
		Return
	EndIf

	If !QTDITENS()
		lRet	:= .F.
		VTALERT("Limite de itens atingido - 200","Aviso")
		Return
	EndIf

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTGRVEMB   บAutor  ณRenato Nogueira     บ Data ณ  11/12/14  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGrava informa็๕es nas tabelas			    		           บฑฑ
ฑฑบ          ณ					                                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametro ณ 			                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบRetorno   ณ 		 	    									              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function STGRVEMB(_nOpc)

	Local _cQuery1 := ""
	Local _cAlias1 := GetNextAlias()
	//>Ticket 20200207000424
	Local _cQuery2 := ""
	Local _cAlias2 := GetNextAlias()
	//<<
	//>Ticket 20191204000023
	Local _cQuery3 := ""
	Local _cAlias3 := GetNextAlias()
	//<<

	Local _n
	Local _cCvhVirt := ""
	Local _cVirt	:= ""

	Default _nOpc := 4

	If _nOpc==3 .And. cNumEmb=="NOVO"

		_cQuery1 := " SELECT ZZT_NUMEMB
		_cQuery1 += " FROM "+RetSqlName("ZZT")+" ZZT
		_cQuery1 += " WHERE ZZT.D_E_L_E_T_=' ' AND ZZT_FILIAL='"+xFilial("ZZT")+"'
		_cQuery1 += " ORDER BY ZZT_NUMEMB DESC

		If !Empty(Select(_cAlias1))
			DbSelectArea(_cAlias1)
			(_cAlias1)->(dbCloseArea())
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

		dbSelectArea(_cAlias1)
		(_cAlias1)->(dbGoTop())

		If (_cAlias1)->(!Eof())
			cNumEmb := Soma1((_cAlias1)->ZZT_NUMEMB)
		Else
			cNumEmb := "000001"
		EndIf

	EndIf

	Begin Transaction

		DbSelectArea("ZZT") //Cabe็alho
		ZZT->(DbSetOrder(1))
		ZZT->(DbGoTop())

		If !ZZT->(DbSeek(xFilial("ZZT")+cNumEmb))

			ZZT->(RecLock("ZZT",.T.))
			ZZT->ZZT_FILIAL	:= xFilial("ZZT")
			ZZT->ZZT_NUMEMB	:= cNumEmb
			ZZT->ZZT_STATUS	:= "1"
			ZZT->ZZT_DTEMIS	:= DDATABASE
			ZZT->ZZT_HRINI	:= SubStr(Time(),1,5)
			ZZT->ZZT_FILDES	:= cFilDest
			ZZT->ZZT_USERIN	:= USRRETNAME(RETCODUSR())
			ZZT->ZZT_CLIENT	:= IIf(nOpcao2==1,"033467","012047")
			ZZT->(MsUnLock())

			ConfirmSX8()

		EndIf

		DbSelectArea("ZZU")  //Itens
		ZZU->(DbSetOrder(1)) //ZZU_FILIAL+ZZU_NUMEMB+ZZU_PALLET+ZZU_VOLUME+ZZU_PRODUT+ZZU_OP
		ZZU->(DbGoTop())

		If !ZZU->(DbSeek(xFilial("ZZU")+cNumEmb+cPallet+cVolume))//+cProduto))

			If _lVolMax

				aadd(_aVolMax,{cNumEmb,cPallet,cVolume,cProduto,nQE,DDATABASE,SubStr(Time(),1,5),USRRETNAME(RETCODUSR()),cLoteX,cOp,cNumEmb+cPallet+cVolume+cAglVol,"S"})

			Else

				If Len(_aVolMax) > 0 .AND. !_lVolMax

					nQE := 0

					For _n := 1 To Len(_aVolMax)

						ZZU->(RecLock("ZZU",.T.))
						ZZU->ZZU_FILIAL	:= xFilial("ZZU")
						ZZU->ZZU_NUMEMB	:= _aVolMax[_n][01]
						ZZU->ZZU_PALLET	:= _aVolMax[_n][02]
						ZZU->ZZU_VOLUME	:= _aVolMax[_n][03]
						ZZU->ZZU_PRODUT	:= _aVolMax[_n][04]
						ZZU->ZZU_QTDE	:= _aVolMax[_n][05]
						ZZU->ZZU_DTEMIS	:= _aVolMax[_n][06]
						ZZU->ZZU_HRINI	:= _aVolMax[_n][07]
						ZZU->ZZU_USERIN	:= _aVolMax[_n][08]
						ZZU->ZZU_LOTEX	:= _aVolMax[_n][09]
						ZZU->ZZU_OP		:= _aVolMax[_n][10]
						ZZU->ZZU_CHVVIR	:= _aVolMax[_n][11]
						ZZU->ZZU_VIRTUA := _aVolMax[_n][12]
						ZZU->(MsUnLock())

						_cCvhVirt := _aVolMax[_n][11]

						nQE		  += 1
					Next _n

					cProduto := "AGLUTINADO"
					_cVirt := "N"
					_aVolMax := {}

				EndIf

				ZZU->(RecLock("ZZU",.T.))
				ZZU->ZZU_FILIAL	:= xFilial("ZZU")
				ZZU->ZZU_NUMEMB	:= cNumEmb
				ZZU->ZZU_PALLET	:= cPallet
				ZZU->ZZU_VOLUME	:= cVolume
				ZZU->ZZU_PRODUT	:= cProduto
				ZZU->ZZU_QTDE	:= nQE
				ZZU->ZZU_DTEMIS	:= DDATABASE
				ZZU->ZZU_HRINI	:= SubStr(Time(),1,5)
				ZZU->ZZU_USERIN	:= USRRETNAME(RETCODUSR())
				ZZU->ZZU_LOTEX	:= cLoteX
				ZZU->ZZU_OP		:= cOp

				ZZU->ZZU_VIRTUA := _cVirt

				ZZU->ZZU_CHVVIR	:= _cCvhVirt
				ZZU->(MsUnLock())

				_cVirt := ""

			Endif

		Else

			//>>Ticket 20191204000023
			If _lVolMax

				_lContAglu := .F.

				aadd(_aVolMax,{cNumEmb,cPallet,cVolume,cProduto,nQE,DDATABASE,SubStr(Time(),1,5),USRRETNAME(RETCODUSR()),cLoteX,cOp,cNumEmb+cPallet+cVolume+cAglVol,"S"})

			Else

				If Len(_aVolMax) > 0 .AND. !_lVolMax

					nQE := 0

					For _n := 1 To Len(_aVolMax)

						ZZU->(RecLock("ZZU",.T.))
						ZZU->ZZU_FILIAL	:= xFilial("ZZU")
						ZZU->ZZU_NUMEMB	:= _aVolMax[_n][01]
						ZZU->ZZU_PALLET	:= _aVolMax[_n][02]
						ZZU->ZZU_VOLUME	:= _aVolMax[_n][03]
						ZZU->ZZU_PRODUT	:= _aVolMax[_n][04]
						ZZU->ZZU_QTDE	:= _aVolMax[_n][05]
						ZZU->ZZU_DTEMIS	:= _aVolMax[_n][06]
						ZZU->ZZU_HRINI	:= _aVolMax[_n][07]
						ZZU->ZZU_USERIN	:= _aVolMax[_n][08]
						ZZU->ZZU_LOTEX	:= _aVolMax[_n][09]
						ZZU->ZZU_OP		:= _aVolMax[_n][10]
						ZZU->ZZU_CHVVIR	:= _aVolMax[_n][11]
						ZZU->ZZU_VIRTUA := _aVolMax[_n][12]
						ZZU->(MsUnLock())

						_cCvhVirt := _aVolMax[_n][11]

						nQE		  += 1
					Next _n

					cProduto := "AGLUTINADO"
					_cVirt := "N"
					_aVolMax := {}

				EndIf
				//<<Ticket 20191204000023

				ZZU->(DbSeek(xFilial("ZZU")+cNumEmb+cPallet+cVolume+cProduto))
				ZZU->(RecLock("ZZU",.F.))
				ZZU->ZZU_PRODUT	:= cProduto
				ZZU->ZZU_QTDE	:= ZZU->ZZU_QTDE+nQE
				ZZU->ZZU_USERIN	:= USRRETNAME(RETCODUSR())
				ZZU->ZZU_OP		:= cOp
				ZZU->ZZU_VIRTUA := _cVirt
				ZZU->ZZU_CHVVIR	:= _cCvhVirt
				//Chamado 002701 Abre
				ZZU->ZZU_DTEMIS	:= DDATABASE
				ZZU->ZZU_HRINI	:= SubStr(Time(),1,5)
				ZZU->ZZU_LOTEX	:= cLoteX
				//Chamado 002701 Fecha
				ZZU->(MsUnLock())

			EndIf

			//>>Ticket  20200207000424 Atualizar o Volume na ZZT

			_cQuery2 := ""

			If cEmpAnt = '03'

				_cQuery2 += " "

				_cQuery2 += " MERGE INTO "+RetSqlName("ZZT")+" ZZT "
				_cQuery2 += " USING ( "
				_cQuery2 += " SELECT COUNT(ZZU_VOLUME) ZZUVOL,ZZU_NUMEMB ZZUEMB FROM "+RetSqlName("ZZU")
				_cQuery2 += " WHERE ZZU_NUMEMB = '"+cNumEmb+"' "
				_cQuery2 += " AND ZZU_VIRTUA <> 'S' "
				_cQuery2 += " AND D_E_L_E_T_ = ' ' "
				_cQuery2 += " GROUP BY ZZU_NUMEMB "
				_cQuery2 += " ) XXX "
				_cQuery2 += " ON (ZZT.ZZT_NUMEMB =XXX.ZZUEMB) "
				_cQuery2 += " WHEN MATCHED THEN UPDATE "
				_cQuery2 += " SET ZZT.ZZT_VOLUME = XXX.ZZUVOL "

				TcSQLExec(_cQuery2)

			ENDIF

			//<<

			If _lVolMax
				lGravou	:= .F.
			Else
				lGravou	:= .T.
			EndIf
		ENDIF

	End Transaction

	//chamado 003069 ENVIAR WF PARA ITENS SEM COMPROMISSO NO ATO DO EMBARQUE
	If !_lVolMax
		If cEmpAnt = '03'
			u_STCOMPEMB(cProduto,cNumEmb)
		EndIf
	Endif

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNEWPALLET   บAutor  ณRenato Nogueira     บ Data ณ  11/12/14 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGera novo n๚mero de pallet				    		           บฑฑ
ฑฑบ          ณ					                                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametro ณ 			                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบRetorno   ณ 		 	    									              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function NEWPALLET()

	Local cQuery 	:= ""
	Local cAlias1	:= "QRYTEMP"

	If !CBYesNo("Confirma novo pallet?",".:AVISO:.",.t.)
		Return
	Endif

	cQuery := " SELECT ZZU_FILIAL, ZZU_NUMEMB, ZZU_PALLET "
	cQuery += " FROM "+RetSqlName("ZZU")+" ZU "
	cQuery += " WHERE ZU.D_E_L_E_T_=' ' AND ZZU_FILIAL='"+cFilAnt+"' AND ZZU_NUMEMB='"+cNumEmb+"' "
	cQuery += " ORDER BY ZZU_FILIAL, ZZU_NUMEMB, ZZU_PALLET DESC "

	If !Empty(Select(cAlias1))
		DbSelectArea(cAlias1)
		(cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias1,.T.,.T.)

	dbSelectArea(cAlias1)
	(cAlias1)->(dbGoTop())

	cPallet	:= Soma1((cAlias1)->ZZU_PALLET)
	cVolume	:= "0001"
	cAglVol := "001"
	_lNewPallet	:= .T.

	VTGetRefresh("cPallet")
	VTGetRefresh("cVolume")
	VTGetRefresh("cAglVol")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVldPallet   บAutor  ณRenato Nogueira     บ Data ณ  11/12/14 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValida pallet								    		           บฑฑ
ฑฑบ          ณ					                                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametro ณ 			                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบRetorno   ณ 		 	    									              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VldPallet()

	VTGetRefresh("cPallet")

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVldVolume   บAutor  ณRenato Nogueira     บ Data ณ  11/12/14 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValida volume								    		           บฑฑ
ฑฑบ          ณ					                                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametro ณ 			                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบRetorno   ณ 		 	    									              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VldVolume()

	VTGetRefresh("cVolume")

Return .T.

Static Function VldAglVol()

	VTGetRefresh("cAglVol")

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCONSSALDO   บAutor  ณRenato Nogueira     บ Data ณ  11/12/14 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณVerifica se possui saldo em aberto sufiente  		           บฑฑ
ฑฑบ          ณ					                                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametro ณ 			                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบRetorno   ณ 		 	    									              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CONSSALDO()

	Local lRet		:= .T.
	Local cQuery 	:= ""
	Local cAlias1	:= "QRYTEMP"


	If lAltera
		DbSelectArea("ZZT") //Cabe็alho
		ZZT->(DbSetOrder(1))
		ZZT->(DbGoTop())
		If !(ZZT->(DbSeek(xFilial("ZZT")+cNumEmb)))
			VTALERT("Filial de Destino do Embarque: "+cNumEmb+" nao encontrada","Aviso")
			lRet := .F.
		Endif
	EndIf

	If lRet
		cQuery := " SELECT B1_COD, "
		cQuery += " NVL(SUM(C6_QTDVEN-C6_QTDENT),0)- "
		cQuery += " (SELECT NVL(SUM(ZZU_QTDE),0) "
		cQuery += " FROM "+RetSqlName("ZZU")+" ZU "
		cQuery += " LEFT JOIN "+RetSqlName("ZZT")+" ZT "
		cQuery += " ON ZT.ZZT_FILIAL=ZU.ZZU_FILIAL AND ZT.ZZT_NUMEMB=ZU.ZZU_NUMEMB "
		cQuery += " WHERE ZU.D_E_L_E_T_=' ' AND ZT.D_E_L_E_T_=' ' AND ZZT_STATUS IN ('1','2') AND ZZU_PRODUT='"+cProduto+"' AND ZZU_VIRTUA <> 'N' "
		cQuery += " AND ZZT_CLIENT='"+Iif(nOpcao==2 .OR. nOpcao==5 ,ZZT->ZZT_CLIENT,IIf(nOpcao2==1,"033467","012047"))+"' "
		cQuery += " AND ZZT_FILDES='"+Iif(nOpcao==2 .OR. nOpcao==5 ,ZZT->ZZT_FILDES,cFilDest)+"' ) "
		cQuery += " AS SALDO "
		cQuery += " FROM "+RetSqlName("SB1")+" B1 "
		cQuery += " LEFT JOIN "+RetSqlName("SC6")+" C6 ON C6.C6_PRODUTO=B1.B1_COD AND C6.D_E_L_E_T_=' ' "
		cQuery += " AND C6_CLI='"+Iif(nOpcao==2 .OR. nOpcao==5,ZZT->ZZT_CLIENT,IIf(nOpcao2==1,"033467","012047"))+"' AND C6_LOJA='"+Iif(nOpcao==2 .OR. nOpcao==5 ,ZZT->ZZT_FILDES,cFilDest)+"' AND C6_BLQ=' ' 

		If cEmpAnt=="01"
			If nOpcao2==2
				cQuery += " AND C6_OPER= '01'
			Else
				cQuery += " AND C6_OPER= '"+SuperGetMV("ST_OPEREMB",.F.,"15")+"'"
			EndIf
		Else
			cQuery += " AND C6_OPER= '"+SuperGetMV("ST_OPEREMB",.F.,"15")+"'"
		EndIf
		
		cQuery += " LEFT JOIN "+RetSqlName("SC5")+" C5 ON C5.C5_FILIAL=C6.C6_FILIAL AND C5.C5_NUM=C6.C6_NUM  "
		cQuery += " AND C5.C5_CLIENTE=C6.C6_CLI AND C5.C5_LOJACLI=C6.C6_LOJA AND C5.D_E_L_E_T_=' ' AND C5_EMISSAO>='20141215' "
		cQuery += " WHERE B1.D_E_L_E_T_=' ' AND B1_COD='"+cProduto+"' "
		cQuery += " GROUP BY B1_COD "

		If !Empty(Select(cAlias1))
			DbSelectArea(cAlias1)
			(cAlias1)->(dbCloseArea())
		Endif

		//MemoWrite( "C:\temp\telnet.txt", cQuery )


		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias1,.T.,.T.)

		dbSelectArea(cAlias1)
		(cAlias1)->(dbGoTop())

		If (cAlias1)->SALDO < nQE
			conout ('zaggo')
			conout (cvaltochar(nQE))
			conout (cvaltochar((cAlias1)->SALDO))
			VTALERT("Nao possui saldo suficiente em aberto, saldo atual : "+CVALTOCHAR((cAlias1)->SALDO),"Aviso 1151")
			lRet	:= .F.
			Conout(cQuery)
		EndIf
	Endif

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCHKEXISTS   บAutor  ณRenato Nogueira     บ Data ณ  11/12/14 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณVerifica se cadastro existe na base		 		           บฑฑ
ฑฑบ          ณ					                                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametro ณ 			                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบRetorno   ณ 		 	    									              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CHKEXISTS(cTipo)

	Local lRet			:= .T.

	DbSelectArea("ZZT")
	ZZT->(DbSetOrder(1))
	ZZT->(DbGoTop())

	If ZZT->(DbSeek(xFilial("ZZT")+cNumEmb))
		If !ZZT->ZZT_STATUS=="1"
			VTALERT("Atencao, este embarque nao esta mais aberto")
			lRet	:= .F.
		EndIf
	EndIf

	DbSelectArea("ZZU")
	ZZU->(DbSetOrder(1))
	ZZU->(DbGoTop())

	DO CASE

	CASE cTipo=="1" //Embarque
		If ZZU->(!DbSeek(xFilial("ZZU")+cNumEmb))
			VTALERT("Atencao, embarque nao encontrado!")
			lRet	:= .F.
		EndIf
	CASE cTipo=="2" //Pallet
		If ZZU->(!DbSeek(xFilial("ZZU")+cNumEmb+cPallet))
			VTALERT("Atencao, pallet nao encontrado!")
			lRet	:= .F.
		EndIf
	CASE cTipo=="3" //Volume
		If ZZU->(!DbSeek(xFilial("ZZU")+cNumEmb+cPallet+cVolume))
			VTALERT("Atencao, volume nao encontrado!")
			lRet	:= .F.
		EndIf
	ENDCASE

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGETPROXVOL  บAutor  ณRenato Nogueira     บ Data ณ  11/12/14 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPegar pr๓ximo volume							 		           บฑฑ
ฑฑบ          ณ					                                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametro ณ 			                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบRetorno   ณ 		 	    									              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GETPROXVOL()

	Local cQuery 	:= ""
	Local cAlias1	:= "QRYTEMP"

	cQuery := " SELECT ZZU_FILIAL, ZZU_NUMEMB, ZZU_PALLET, ZZU_VOLUME "
	cQuery += " FROM "+RetSqlName("ZZU")+" ZU "
	cQuery += " WHERE ZU.D_E_L_E_T_=' ' AND ZZU_FILIAL='"+cFilAnt+"' AND ZZU_NUMEMB='"+cNumEmb+"' AND ZZU_PALLET='"+cPallet+"' "
	cQuery += " ORDER BY ZZU_FILIAL, ZZU_NUMEMB, ZZU_PALLET, ZZU_VOLUME DESC "

	If !Empty(Select(cAlias1))
		DbSelectArea(cAlias1)
		(cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias1,.T.,.T.)

	dbSelectArea(cAlias1)
	(cAlias1)->(dbGoTop())

	cVolume	:= Soma1((cAlias1)->ZZU_VOLUME)

Return()

Static Function PROXVLAG()

	Local cQuery 	:= ""
	Local cAlias1	:= "QRYTEMP"

	cQuery := " SELECT ZZU_FILIAL, ZZU_NUMEMB, ZZU_PALLET, ZZU_VOLUME,ZZU_CHVVIR "
	cQuery += " FROM "+RetSqlName("ZZU")+" ZU "
	cQuery += " WHERE ZU.D_E_L_E_T_=' ' AND ZZU_FILIAL='"+cFilAnt+"' AND ZZU_NUMEMB='"+cNumEmb+"' AND ZZU_PALLET='"+cPallet+"' AND ZZU_VOLUME = '"+cVolume+"' AND ZZU_VIRTUA = 'N'  "
	cQuery += " ORDER BY ZZU_FILIAL, ZZU_NUMEMB, ZZU_PALLET, ZZU_VOLUME DESC "

	If !Empty(Select(cAlias1))
		DbSelectArea(cAlias1)
		(cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias1,.T.,.T.)

	dbSelectArea(cAlias1)
	(cAlias1)->(dbGoTop())

	If !Empty((cAlias1)->ZZU_CHVVIR)

		_lVolMax := .t.

		cAglVol	:= Soma1(SubStr((cAlias1)->ZZU_CHVVIR,14,3))

	EndIf

Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDELETEREG   บAutor  ณRenato Nogueira     บ Data ณ  11/12/14 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEstorno dos registros						 		           บฑฑ
ฑฑบ          ณ					                                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametro ณ 			                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบRetorno   ณ 		 	    									              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function DELETEREG(cTipo)

	Local aAreaZZT	:= ZZT->(GetArea())
	Local aAreaZZU	:= ZZU->(GetArea())

	DbSelectArea("ZZT")
	ZZT->(DbSetOrder(1))
	ZZT->(DbGoTop())
	ZZT->(DbSeek(xFilial("ZZT")+cNumEmb))

	DbSelectArea("ZZU")
	ZZU->(DbSetOrder(1))
	ZZU->(DbGoTop())

	Begin Transaction

		DO CASE

		CASE cTipo=="1" //Embarque

			If ZZT->(!Eof()) .And. AllTrim(ZZT->ZZT_NUMEMB)==AllTrim(cNumEmb)
				ZZT->(RecLock("ZZT",.F.))
				ZZT->(DbDelete())
				ZZT->(MsUnLock())
			EndIf

			ZZU->(DbSeek(xFilial("ZZU")+cNumEmb))
			While ZZU->(!Eof()) .And. AllTrim(ZZU->ZZU_NUMEMB)==AllTrim(cNumEmb)
				ZZU->(RecLock("ZZU",.F.))
				ZZU->(DbDelete())
				ZZU->(MsUnLock())
				ZZU->(DbSkip())
			EndDo

			VTALERT("Embarque "+AllTrim(cNumEmb)+" excluido com sucesso")

		CASE cTipo=="2" //Pallet

			ZZU->(DbSeek(xFilial("ZZU")+cNumEmb+cPallet))
			While ZZU->(!Eof()) .And. AllTrim(ZZU->ZZU_NUMEMB)==AllTrim(cNumEmb) .And. AllTrim(ZZU->ZZU_PALLET)==AllTrim(cPallet)
				ZZU->(RecLock("ZZU",.F.))
				ZZU->(DbDelete())
				ZZU->(MsUnLock())
				ZZU->(DbSkip())
			EndDo

			If STDELALL()
				ZZT->(RecLock("ZZT",.F.))
				ZZT->(DbDelete())
				ZZT->(MsUnLock())
			EndIf

			VTALERT("Pallet "+AllTrim(cPallet)+" excluido com sucesso")

		CASE cTipo=="3" //Volume

			ZZU->(DbSeek(xFilial("ZZU")+cNumEmb+cPallet+cVolume))
			While ZZU->(!Eof()) .And. AllTrim(ZZU->ZZU_NUMEMB)==AllTrim(cNumEmb) .And. AllTrim(ZZU->ZZU_PALLET)==AllTrim(cPallet);
					.And. AllTrim(ZZU->ZZU_VOLUME)==AllTrim(cVolume)
				ZZU->(RecLock("ZZU",.F.))
				ZZU->(DbDelete())
				ZZU->(MsUnLock())
				ZZU->(DbSkip())
			EndDo

			If STDELALL()
				ZZT->(RecLock("ZZT",.F.))
				ZZT->(DbDelete())
				ZZT->(MsUnLock())
			EndIf

			VTALERT("Volume "+AllTrim(cVolume)+" excluido com sucesso")

		ENDCASE

	End Transaction

	RestArea(aAreaZZU)
	RestArea(aAreaZZT)

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCONSSALDO   บAutor  ณRenato Nogueira     บ Data ณ  11/12/14 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณVerifica se possui saldo em aberto sufiente  		           บฑฑ
ฑฑบ          ณ					                                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametro ณ 			                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบRetorno   ณ 		 	    									              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function STSLDOP()

	Local lRet		:= .T.
	Local cQuery 	:= ""
	Local cAlias1	:= "QRYTEMP"

	cQuery := " SELECT NVL(SUM(BF_QUANT),0) "
	cQuery += " - (SELECT NVL(SUM(ZZU_QTDE),0) FROM "+RetSqlName("ZZU")+" ZU "
	cQuery += " LEFT JOIN "+RetSqlName("ZZT")+" ZT ON ZT.ZZT_FILIAL=ZU.ZZU_FILIAL AND "
	cQuery += " ZT.ZZT_NUMEMB=ZU.ZZU_NUMEMB WHERE ZU.D_E_L_E_T_=' ' AND ZT.D_E_L_E_T_=' ' AND ZZU_VIRTUA <> 'N' "
	cQuery += " AND ZT.ZZT_STATUS IN ('1','2')
	//cQuery += " AND ZU.ZZU_OP='"+cOp+"' "
	cQuery += " AND ZU.ZZU_PRODUT='"+cProduto+"') SALDO "
	cQuery += " FROM "+RetSqlName("SBF")+" BF "
	cQuery += " WHERE BF.D_E_L_E_T_=' ' AND BF_FILIAL='"+cFilAnt+"'
	//cQuery += " AND C2_NUM='"+SubStr(cOp,1,6)+"' "
	//cQuery += " AND C2_ITEM='"+SubStr(cOp,7,2)+"'
	cQuery += " AND BF_PRODUTO='"+cProduto+"' "
	cQuery += " AND BF_LOCAL = '"+SuperGetMV("ST_LOCESC",,"15")+"' "
	cQuery += " GROUP BY BF_PRODUTO"

	If !Empty(Select(cAlias1))
		DbSelectArea(cAlias1)
		(cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias1,.T.,.T.)

	dbSelectArea(cAlias1)
	(cAlias1)->(dbGoTop())

	If (cAlias1)->SALDO<nQE
		VTALERT("Nao possui saldo nos enderecos, saldo atual: "+CVALTOCHAR((cAlias1)->SALDO),"Aviso")
		lRet	:= .F.
	EndIf

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCONSSALDO   บAutor  ณRenato Nogueira     บ Data ณ  11/12/14 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณVerifica se possui saldo em aberto sufiente  		           บฑฑ
ฑฑบ          ณ					                                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametro ณ 			                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบRetorno   ณ 		 	    									              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function QTDITENS()

	Local lRet		:= .T.
	Local cQuery 	:= ""
	Local cAlias1	:= "QRYTEMP"

	//cQuery := " SELECT COUNT(*) CONTADOR "
	//cQuery += " FROM "+RetSqlName("ZZU")+" ZU "
	//cQuery += " WHERE ZU.D_E_L_E_T_=' ' AND ZU.ZZU_FILIAL='"+cFilAnt+"' AND ZU.ZZU_NUMEMB='"+cNumEmb+"' "

	cQuery := " SELECT SUM(COUNT(DISTINCT(ZZU_PRODUT))) AS CONTADOR
	cQuery += " FROM "+RetSqlName("ZZU")+" ZU "
	cQuery += " WHERE ZU.D_E_L_E_T_=' ' AND ZU.ZZU_FILIAL='"+cFilAnt+"' AND ZU.ZZU_NUMEMB='"+cNumEmb+"' "
	cQuery += " GROUP BY ZZU_PRODUT

	If !Empty(Select(cAlias1))
		DbSelectArea(cAlias1)
		(cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias1,.T.,.T.)

	dbSelectArea(cAlias1)
	(cAlias1)->(dbGoTop())

	If (cAlias1)->CONTADOR>=GETMV("MV_NUMITEN")
		lRet	:= .F.
	EndIf

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTDELALL   บAutor  ณRenato Nogueira     บ Data ณ  11/12/14  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณVerifica todos os registros da ZZU foram deletados          บฑฑ
ฑฑบ          ณ					                                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametro ณ 			                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบRetorno   ณ 		 	    									          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function STDELALL()

	Local lTudoDel	:= .F.

	ZZU->(DbGoTop())
	If !ZZU->(DbSeek(xFilial("ZZU")+cNumEmb))
		lTudoDel	:= .T.
	EndIf

Return(lTudoDel)

User Function STCOMPEMB(cProduto,cNumEmb)

	Local aArea 	:= GetArea()
	Local _cFrom   := "protheus@steck.com.br"
	Local _cAssunto:= 'Produto s/ Compromisso'
	Local cFuncSent:= "STCOMPEMB"
	Local i        := 0
	Local cArq     := ""
	Local cMsg     := ""
	Local _nLin    := 0
	Local _cCopia  := ' '
	Local cAttach  := ''
	Local _aMsg  := {}
	Local cAliasLif := 'STCOMPEMB'
	Local cQuery    := ' '
	Local _lReEm    := .T.
	//return()

	cQuery := " SELECT * FROM ZZJ010 WHERE D_E_L_E_T_ = ' ' AND ZZJ_COD = '"+cProduto+"'  AND ZZJ_DATA > '"+ dtos(dDataBase)+"'

	cQuery := ChangeQuery(cQuery)

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
	dbSelectArea(cAliasLif)

	If  Select(cAliasLif) > 0
		(cAliasLif)->(dbgotop())

		While !(cAliasLif)->(Eof())

			_lReEm:= .F.

			(cAliasLif)->(dbSkip())
		End
	EndIf

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	_cEmail  := 'marcella.martins@steck.com.br'// ;tiago.brandao@steck.com.br  ' //Ticket 20200818005841
	If !_lReEm
		Return()
	EndIf

	aadd(_aMsg ,{ 'Produto' 	,cProduto })
	aadd(_aMsg ,{ 'Embarque' 	,cNumEmb  })

	If ( Type("l410Auto") == "U" .OR. !l410Auto ) .And. Len(_aMsg) > 1

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Definicao do cabecalho do email                                             ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		cMsg := ""
		cMsg += '<html>'
		cMsg += '<head>'
		cMsg += '<title>' + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
		cMsg += '</head>'
		cMsg += '<body>'
		//cMsg += '<Img Src="C:/AP5/SIGAADV/LGRL01.BMP"><BR>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
		cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Definicao do texto/detalhe do email                                         ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		For _nLin := 1 to Len(_aMsg)
			IF (_nLin/2) == Int( _nLin/2 )
				cMsg += '<TR BgColor=#B0E2FF>'
			Else
				cMsg += '<TR BgColor=#FFFFFF>'
			EndIF
			cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></TD>'
			cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
			cMsg += '</TR>'
		Next
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Definicao do rodape do email                                                ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		cMsg += '</Table>'
		cMsg += '<P>'
		cMsg += '<Table align="center">'
		cMsg += '<tr>'
		cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">('+cFuncSent+')</td>'
		cMsg += '</tr>'
		cMsg += '</Table>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		//cMsg += '<B><Font Color=#000000 Size="2" Face="Arial"> Atenciosamente </Font></B><BR>'
		//cMsg += '<B><Font Color=#000000 Size="2" Face="Arial">' + SM0->M0_NOMECOM + '</Font></B><BR>'
		//cMsg += '<Img Src="C:/AP5/SIGAADV/LGRL01.BMP">'
		cMsg += '</body>'
		cMsg += '</html>'

		If GetMv("STCOMPEMB1",,.F.) //20200901006645
			If !(   U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,cAttach) )
				MsgInfo("Email nใo Enviado..!!!!")
			EndIf
		EndIf

	EndIf
	RestArea(aArea)

Return()
