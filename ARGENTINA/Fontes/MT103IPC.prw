#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE 'FWMVCDef.ch'

#DEFINE CR    chr(13)+chr(10)

/*/{Protheus.doc} MT103IPC

Atualizar aCols do lote na entrada do remito

@type function
@author Everson Santana
@since 06/05/2021
@version Protheus 12 - Compras

@history ,Ticket 20210427006817 ,

/*/

User Function MT103IPC()

Local _Nx := Len(aCols)

aCols[_Nx,aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="D1_LOTECTL" })]:= M->F1_XLOTE
aCols[_Nx,aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="D1_LOCALIZ" })]:= M->F1_XEND
aCols[_Nx,aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="D1_LOCAL" })]:= M->F1_XLOCAL

Return 


