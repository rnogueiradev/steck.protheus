#Include "Protheus.ch"
#Include "rwmake.ch"
#Include "Protheus.ch"

// ---------+-------------------+------------------------------------------------
// Projeto  : STECK
// Autor    : Cristiano Pereira - SigaMat
// Modulo   : SIGACOM
// Função   : STSCH001
// Descrição: Ajustar precos de beneficiamento - carga Schneider
// Retorno  : Nenhum.
// ---------+-------------------+--------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+--------------------------------------------------
// 19/03/20 | Cristiano Pereira  | Desenvolvimento da rotina.
// ---------+-------------------+--------------------------------------------------

User Function STSCH001()

	Private oDlg
	Private nOpc:=0
	Private bOk :={||nOpc:=1,ST001A()}
	Private bCancel := {||oDlg:End()}
	Private _cNFrem     := Space(9)
	Private _cProduto   := Space(15)
	Private _nPreco   := 0
	Private _nQtd     := 0
	Private _cLojFor  :=Space(8)



	DEFINE MSDIALOG oDlg TITLE "Nota remessa - Schneider" FROM 7,0.5 TO 26,79.5 OF oMainWnd

	@ 50,05 SAY "NF Remessa: " PIXEL
	@ 50,65 msGET _cNFrem   SIZE 50,08 of oDlg Pixel

	@ 70,05 SAY "Produto: " PIXEL
	@ 70,65 msGET  _cProduto F3 "SB1"   SIZE 50,08   of oDlg    Pixel

	@ 90,05 SAY "Preço: " PIXEL
	@ 90,65 msGET   _nPreco PICTURE "@E 999,999.99999"  SIZE 50,08 of oDlg Pixel

	@ 110,05 SAY "Quantidade: " PIXEL
	@ 110,65 msGET   _nQtd  PICTURE "@E 999,999,999.99"  SIZE 50,08 of oDlg Pixel

	@ 130,05 SAY "Fornecedor/Loja: " PIXEL
	@ 130,65 msGET   _cLojFor   PICTURE "@!"  SIZE 50,08 of oDlg Pixel



	//@ 30,05 GET cImport MEMO SIZE 300,105 OF oDlg PIXEL HSCROLL

	ACTIVATE MSDIALOG oDlg ON INIT (EnchoiceBar(oDlg,bOk,bCancel)) CENTERED


return


// ---------+-------------------+------------------------------------------------
// Projeto  : STECK
// Autor    : Cristiano Pereira - SigaMat
// Modulo   : SIGACOM
// Função   : STSCH001
// Descrição: Ajustar precos de beneficiamento - carga Schneider
// Retorno  : Nenhum.
// ---------+-------------------+--------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+--------------------------------------------------
// 19/03/20 | Cristiano Pereira  | Desenvolvimento da rotina.
// ---------+-------------------+--------------------------------------------------

Static function ST001A()

	Local _aArea      := GetArea()
	Local _nValBru    := 0


	If Len(rtrim(_cNFrem) )<9
		MsgAlert("Digite a nota fiscal de remessa com 9 dígitos, adicione 0 a esquerda..")
		return
	Endif

	DbSelectArea("SF2")
	DbSetOrder(1)
	If DbSeek(xFilial("SF2")+_cNFrem+"SCH")
		If SF2->F2_SERIE<>"SCH"
			MsgAlert("Nota fiscal de remessa não faz parte do processo de carga Schneider.. ")
			return
		Endif
	else
		MsgAlert("Nota fiscal de remessa não existe. ")
		return
	Endif


	DbSelectArea("SD2")
	DbSetOrder(3)
	If DbSeek(xFilial("SD2")+_cNFrem+"SCH"+_cLojFor+_cProduto)

		//Ajusta D2
		If Reclock("SD2",.F.)
			SD2->D2_TOTAL := (SD2->D2_QUANT+_nQtd) * _nPreco
            SD2->D2_PRCVEN := _nPreco
			SD2->D2_QUANT  := SD2->D2_QUANT+_nQtd 
			MsUnlock()
		Endif

		//Ajusta B6

		DbSelectArea("SB6")
		DbSetOrder(3)
		If DbSeek(xFilial("SB6")+SD2->D2_IDENTB6+SD2->D2_COD+"R")
			If Reclock("SB6",.F.)
			    SB6->B6_QUANT  := (SB6->B6_QUANT+_nQtd)
				SB6->B6_PRUNIT :=  _nPreco
				SB6->B6_SALDO  := SB6->B6_SALDO +_nQtd
				MsUnlock()
			Endif
		Endif

		DbSelectArea("SD2")
		DbSetOrder(3)
		If DbSeek(xFilial("SD2")+_cNFrem+"SCH")

			While !SD2->(EOF()) .And. xFilial("SD2")+_cNFrem+"SCH"==SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE
				_nValBru+=SD2->D2_TOTAL
				DbSelectArea("SD2")
				DbSkip()
			Enddo


            //Ajusta F2
			DbSelectArea("SF2")
			DbSetOrder(1)
			If DbSeek(xFilial("SF2")+_cNFrem+"SCH")
				If Reclock("SF2",.F.)
					SF2->F2_VALBRUT :=  _nValBru
					SF2->F2_VALMERC :=  _nValBru
					MsUnlock()
				Endif
			Endif

		Endif
    else
           MsgAlert("Produto não existe nas remessas de carga Schneider . ")
		    return    
	Endif

     MsgInfo("Preço atualizado com sucesso...")
     oDlg:End()

	RestArea(_aArea)


return
