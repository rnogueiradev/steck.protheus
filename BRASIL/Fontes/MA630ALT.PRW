#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMA630ALT()บAutor  ณMicrosiga           บ Data ณ  11/11/2014 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ PONTO DE ENTRADA NA ROTINA DE ATUALIZACAO DO ROTEIRO DE    บฑฑ
ฑฑบ          ณ OPERACAO PARA ENVIO DE E-MAIL AS PESSOAS RESPONSAVEIS      บฑฑ
ฑฑบ          ณ QUANDO UM DETERMINADO ROTEIRO SOBRER ATUALIZACAO.          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MA630ALT()

	Private _aOpera := aClone(aCols)
	Private _cAtiv  := ""
 
 
	EnvMail(SG2->G2_CODIGO,SG2->G2_PRODUTO,_aOpera)

 
Return(.t.)
          

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMA630GRV  บAutor  ณMicrosiga           บ Data ณ  11/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
                         
User Function MailRot(_cCodigo,_cProduto,_xAcols)

	Local cMailConta	:= GETMV("MV_RELACNT")
	Local cMailServer	:= GETMV("MV_RELSERV")
	Local cMailSenha	:= GETMV("MV_RELPSW")
	Local lAuth 		:= GetMv("MV_RELAUTH",,.F.)

	Local lOk			:= .F.
	Local cMensagem
	Local nx			:= 0
	Local  nWidth := 0
	Local cError
	local _aAttach := {}
	Local _cCaminho:=''
	Local _nIni:=1
	Local _nFim:=100
	Local titulo := "Alteracao de roteiro de operacoes"
	Local _cEmailFor := supergetmv("ST_EMAILQA",,"")
  
 
	cMensagem := '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">'
	cMensagem += '<HTML><HEAD>'
	cMensagem += '<META content="text/html; charset=iso-8859-1" http-equiv=Content-Type>'
	cMensagem += '<META content="MSHTML 5.00.2920.0" name=GENERATOR></HEAD>'
	cMensagem += '<BODY aLink=#ff0000 bgColor=#ffffff link=#0000ee text=#000000 '
	cMensagem += 'vLink=#551a8b><B>'
	cMensagem += '<table style="width: 100%;" nowrap="1" background="" border="2" bordercolor="#cccccc" cellpadding="0" cellspacing="0">'
	cMensagem += ' <tr>'
	cMensagem += '  <td>'
	cMensagem += "<br><font Face='CALIBRI' >" + "Evento: " + "</font></br>"
	cMensagem += '  </td>'
	cMensagem += '  <td>'
	cMensagem += "<br><font Face='CALIBRI' >" + " Alteracao de Roteiro "+ "</font></br>"
	cMensagem += '  </td>'
	cMensagem += ' </tr>'
	cMensagem += ' <tr>'
	cMensagem += '  <td>'
	cMensagem += "<br><font Face='CALIBRI' >" + "Alterado por: "   + "</font></br>"
	cMensagem += '  </td>'
	cMensagem += '  <td>'
	cMensagem += "<br><font Face='CALIBRI' >" +   UsrFullName(RetCodUsr()) + "</font></br>"
	cMensagem += '  </td>'
	cMensagem += ' </tr>'
	cMensagem += ' <tr>'
	cMensagem += '  <td>'
	cMensagem += "<br><font Face='CALIBRI' >" + "Roteiro: "   + "</font></br>"
	cMensagem += '  </td>'
	cMensagem += '  <td>'
	cMensagem += "<br><font Face='CALIBRI' >"   + _cCodigo + "</font></br>"
	cMensagem += '  </td>'
	cMensagem += ' </tr>'
	cMensagem += ' <tr>'
	cMensagem += '  <td>'
	cMensagem += "<br><font Face='CALIBRI' >" + "Produto: "   + "</font></br>"
	cMensagem += '  </td>'
	cMensagem += '  <td>'
	cMensagem += "<br><font Face='CALIBRI' >" +  _cProduto + "-" + Posicione("SB1",1,xFilial("SB1")+_cProduto ,'B1_DESC') + "</font></br>"
	cMensagem += '  </td>'
	cMensagem += ' </tr>'
	cMensagem += ' <tr>'
	cMensagem += '  <td>'
	cMensagem += "<br><font Face='CALIBRI' >" + "Data: "  + "</font></br>"
	cMensagem += '  </td>'
	cMensagem += '  <td>'
	cMensagem += "<br><font Face='CALIBRI' >" +  dtoc(date())  + "-"+ time()+ "</font></br>"
	cMensagem += '  </td>'
	cMensagem += ' </tr>'
	cMensagem += '</table

	cMensagem += '</B>'
	cMensagem += '<BR>&nbsp;</BR>'

	cMensagem += "</CENTER>"
	cMensagem += '</body>'
 

 
// Envia e-mail com os dados necessarios
  
	U_STMAILTES(_cEmailFor, ,titulo,cMensagem,_aAttach,_cCaminho)
    

Return