#include 'Protheus.ch'
#include 'RwMake.ch'

/*/{Protheus.doc} MA030ROT
(Inclusão de novas rotinas Menu Clientes)

@author jefferson.carlos
@since 10/06/2019
@version 1.0
@return

/*/
*-----------------------------*
User Function MA030ROT(  )
*-----------------------------*

	Local aMenust  := {}
	Local _cGIMPA1 := GetMv("ST_GIMPA1 ",,"000013")

	AAdd( aMenust, { 'Copiar', "U_ARCOPCLI()", 3, 0 } )

	If __cUserId $ _cGIMPA1

		AAdd( aMenust, { 'Importação CSV', "U_ARGIMPA1()", 9, 0 } )

	Endif

Return(aMenust)