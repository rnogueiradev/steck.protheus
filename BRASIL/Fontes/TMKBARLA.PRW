#include 'Protheus.ch'
#include 'RwMake.ch'

/*====================================================================================\
|Programa  | TK271ROTM        | Autor | GIOVANI.ZAGO             | Data | 18/02/2013  |
|=====================================================================================|
|Descrição |  Ponto de Entrada                                                        |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | TK271ROTM                                                                |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*---------------------------------------------------*
User Function TMKBARLA()
*---------------------------------------------------*
Local aBotao:={} 
  
aBotao:= U_STTMK35A()  //Giovani Zago 27/03/2013
aadd(aBotao, {'SIMULACA',{||U_STFSVE39()},"Markup"              ,"Markup"})
aadd(aBotao, {'OBJETIVO',{||U_STFSVE30()},"Registro FATEC"      ,"Registro FATEC"})		
aadd(aBotao, {'CARGA'   ,{||U_STFATG03()},"Prazo de Entrega TNT","Prazo de Entrega TNT"})
aadd(aBotao, {'FORM'    ,{||U_STFSVE49()},"Carrega Descontos"   ,"Carrega Descontos"})
 
//U_STFSVE23()



Return aClone(aBotao)
