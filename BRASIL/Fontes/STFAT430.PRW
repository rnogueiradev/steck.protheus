#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | STFAT430        | Autor | RENATO.OLIVEIRA           | Data | 15/09/2020  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STFAT430()

	Local _aRet 		:= {}
	Local _aParamBox	:= {}

	AADD(_aParamBox,{1,"Pedido"		,Space(6)	,"","",""	,".T."	,100,.F.})
	//AADD(_aParamBox,{1,"Impressora" ,Space(6)	,"","","CB5",".T." 	,100,.F.})

	If !ParamBox(_aParamBox,"Impressão de etiqueta ML",@_aRet,,,.T.,,500)
		Return
	EndIf

	DbSelectArea("SC5")
	SC5->(DbSetOrder(1))
	If !SC5->(DbSeek(xFilial("SC5")+MV_PAR01))
		MsgAlert("Pedido não encontrado!")
		Return
	EndIf

	If !AllTrim(SC5->C5_XORIG)=="2"
		MsgAlert("Pedido não é de internet!")
		Return
	EndIf

	DbSelectArea("Z76")
	Z76->(DbSetOrder(1)) //Z76_FILIAL+Z76_PEDPAI+Z76_PEDFIL
	If Z76->(DbSeek(xFilial("Z76")+SC5->C5_XNUMWEB))

			_cToken := AllTrim(GetMv("ST_TOKPREC",,"dFA2M0dXWUxzVklOSWljTDY6"))
			_cUrl	:= AllTrim(GetMv("ST_URLPREC",,"https://www.replicade.com.br/api/v1/"))
			_cUrl   += "labels/generateLabels?orders="+AllTrim(Z76->Z76_PEDFIL)+"&responseType=zpl
	
			nTimeOut  := 60
			_aHeadOut := {}
			cHeadRet  := ""
			aAdd( _aHeadOut , "Authorization: Basic "+_cToken)
			aAdd( _aHeadOut , "Content-Type: application/zip")
	
			cHttpGet := HttpSGet(_cUrl,"","","","",nTimeOut,_aHeadOut,@cHeadRet)
	
		If !Empty(cHttpGet)
				
				oInfo := "" 
				_lRet := FWJsonDeserialize(cHttpGet,@oInfo)
				
			If _lRet
					MsgAlert("Atenção, problema ao imprimir etiqueta na PreCode, mensagem de erro: "+AllTrim(oInfo:MENSAGEM))
					Return
			EndIf
	
				cPortaImp := "LPT2"
	
				_cPstCli := GetTempPath()
				_cPstSer := "\arquivos\etq_mkp\"+SC5->C5_NUM+"\"
				_cFile   := DTOS(Date())+StrTran(Time(),":","")
	
				//MakeDir(_cPstCli)
				MakeDir(_cPstSer)
	
			If File(_cPstSer+_cFile+".zip")
					FErase(_cPstSer+_cFile+".zip")
			EndIf
	
			nHdlImp := FCreate(_cPstSer+_cFile+".zip")
			If nHdlImp <= 0
					MsgAlert("Falha na criação do arquivo")
					Return
			EndIf
				FWrite(nHdlImp,cHttpGet)
				FClose(nHdlImp)
	
			If File(_cPstCli+"Etiqueta de envio.txt")
					FErase(_cPstCli+"Etiqueta de envio.txt")
			EndIf
			If File(_cPstSer+"Etiqueta de envio.txt")
					FErase(_cPstSer+"Etiqueta de envio.txt")
			EndIf
	
			FUnZip(_cPstSer+_cFile+".zip",_cPstSer)
			__CopyFile(_cPstSer+"Etiqueta de envio.txt",cPortaImp)

			If MsgYesNo("A etiqueta foi impressa com sucesso?")
				SC5->(RecLock("SC5",.F.))
				SC5->C5_XDTETIQ := Date()
				SC5->C5_XUSETIQ	:= __cUserID
				SC5->(MsUnLock())
			EndIf
				
		EndIf

	EndIf
	
Return()
