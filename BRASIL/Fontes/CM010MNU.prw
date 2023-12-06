#INCLUDE "PROTHEUS.CH"

/*/{Protheus.doc} User Function CMO10MNU
    (long_description)
    Ponto de Entrada para adicionar nova opção de chamada
    Ticket: 20201113010557
    @type  Function
    @author user
    Valdemir José Rabelo
    @since 06/01/2021
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function CM010MNU()
    Local aRET := aClone(PARAMIXB[1])

    aAdd(aRET, { "Importar"	,"U_STIMPCMO"	,0 ,6 ,0 ,.F.})
      
Return aRET
