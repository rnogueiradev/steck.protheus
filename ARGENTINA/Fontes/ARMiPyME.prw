#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"

User Function ARMiPyME()

	Processa( {||MiPyME() }, "Aguarde...", ,.F.)

Return()

Static Function MiPyME()

	Local cArquivo := ""
	Local aDados   := {}
	Local aCampos  := {}
	Local lPrim	   := .T.
	Local _cLog	   := ""
	Local i:=0
	Local x:=0

	DbSelectArea("SA1")
	SA1->(DbSetOrder(3))

	cArquivo := cGetFile("Arquivos CSV  (*.CSV)  | *.CSV  ","",1,"C:\",.T.,GETF_LOCALHARD,.T.,.T.)

	If Empty(cArquivo)
		Return
	EndIf

	FT_FUSE(cArquivo)                   	
	ProcRegua(FT_FLASTREC())             	
	FT_FGOTOP()                          	

	While !FT_FEOF()                     

		cLinha := FT_FREADLN()           

		If lPrim
			aCampos := Separa(cLinha,";",.T.)
			lPrim := .F.
		Else

			If SA1->(dbSeek(xFilial("SA1") + Left(cLinha,11) ))
				SA1->(RecLock("SA1",.F.))
				SA1->A1_TAMEMP	:= "4"
				SA1->(MsUnLock())
			Endif

		EndIf

		FT_FSKIP()
		IncProc("Procesando Archivo...")
	EndDo

	MsgAlert("Procesamiento de archivo terminado!")

Return()
