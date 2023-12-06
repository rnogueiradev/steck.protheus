#INCLUDE "rwmake.ch"
#include "totvs.ch"
#include "protheus.ch"
#include 'topconn.ch'
#INCLUDE "TbiConn.ch"
#include 'parmtype.ch'

#include 'fileio.ch'

/* **********************************************************

         _.-'~~~~~~'-._            | Funcion: 		xcondoso()                                        
        /      ||      \           |                                        
       /       ||       \          | Descripcion: 	funcion para disparar y validar el consecutivo de documento soporte
      |        ||        |         | 				        de costos y gastos en operaciones con NO obligados a expedir factura o documento equivalente                  
      | _______||_______ |         |                                        
      |/ ----- \/ ----- \|         | Parametros:    	                                        
     /  (     )  (     )  \        | 				                                       
    / \  ----- () -----  / \       |                                        
   /   \      /||\      /   \      | Retorno:       	                                        
  /     \    /||||\    /     \     |
 /       \  /||||||\  /       \    |                                        
/_        \o========o/        _\   | Autor:  Daniel Mira                                     
  '--...__|'-._  _.-'|__...--'     |                                        
          |    ''    |             |
************************************************************** */


User Function xcondoso(cSerdoc)
  Local aAreaAnt := GETAREA()
  Local aRes     := strtokarr ( GETMV("MV_XRESDOS"), "|" )
  Local cRet     := ''
  Local cSerie   := aRes[4]
  //Nro Res   |data res|data vld|serie|num ini|num fin   
  //1234567890|20210101|20211231|DOCS |1      |1000         
  if alltrim(cSerdoc)==alltrim(cSerie)
    cRet := buscanum(cSerie)

    if cRet== ''
      cRet := PADL( cRet, 12, '0' )+aRes[5]
    endif

    if val(cRet)>val(aRes[6])
      msginfo("Numero de documento por fuera del rango")
      cRet        := CriaVar("F1_XDOC", .F.)
      M->F1_SERIE := '   '
    endif
    // cRet:=PADL( cRet, 13, '0')

    if !(M->F1_EMISSAO>=stod(aRes[2]) .AND. M->F1_EMISSAO<=stod(aRes[3]))
      msginfo("Numero de documento por fuera de la fecha de validez")
      cRet        := CriaVar("F1_XDOC", .F.)
      M->F1_SERIE := '   '
    endif
    
  endif

  RESTAREA(aAreaAnt)
return cRet

Static function buscanum(cSerie)
  Local cRet      := ''
  Local cAliasAux := GetNextAlias()
  Local cQuery    := ''

  cQuery += " SELECT MAX(F1_XDOC) AS F1_XDOC FROM " + RetSQLName( 'SF1' ) + " SF1 (NOLOCK) WHERE D_E_L_E_T_ = '' AND F1_FILIAL= '" + xFilial("SF1") + "' "
  cQuery += " AND F1_SERIE= '" + cSerie + "' "

  //TCQuery cQuery New Alias &cAliasAux

  cQuery := changequery(cQuery)
  dbUsearea(.T.,"TOPCONN",TCGenQry(,,cQuery), cAliasAux,.F.,.T.)

  DbSelectArea((cAliasAux))
  (cAliasAux)->(dbgotop())
  while (cAliasAux)->(!EOF())
    cRet := soma1((cAliasAux)->F1_XDOC)
    (cAliasAux)->(dbskip())
  END

  (cAliasAux)->(dbCloseArea()) 

Return cRet
