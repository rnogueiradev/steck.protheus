#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | STFAT460        | Autor | RENATO.OLIVEIRA           | Data | 06/10/2020  |
|=====================================================================================|
|Descri��o |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Hist�rico....................................|
\====================================================================================*/

User Function STFAT460()

	_cRet := cGetFile(;
	"Arquivos Imagem (*.jpg) |*.jpg|";
	+"Arquivos Imagem (*.jpeg) |*.jpeg|";
	+"Arquivos Imagem (*.png) |*.png|";
	+"Arquivos Imagem (*.bmp) |*.bmp|";
	,"Selecione o Arquivo",,,.T.,GETF_LOCALHARD+GETF_LOCALFLOPPY)

	If !MsgYesNo("Confirma a subida do arquivo "+AllTrim(_cRet)+"?")
		Return
	EndIf

	If CpyT2S(_cRet, "\arquivos\seb\imagens" )
		MsgAlert("Arquivo copiado com sucesso!")
	Else
		MsgAlert("Falha na c�pia do arquivo!")
	EndIf

Return()
