#INCLUDE "PROTHEUS.CH"
/*---------------------------------------------------------------------------+
!                       FICHA TECNICA DEL PROGRAMA                           !
+----------------------------------------------------------------------------+
!DATOS DEL PROGRAMA                                                          !
+------------------+---------------------------------------------------------+
!Tipo              ! PE Adicion de Campo Generacion de NF                    !
+------------------+---------------------------------------------------------+
!Modulo            ! FACTURACION                                             !
+------------------+---------------------------------------------------------+
!Descripcion       !  Punto de entrada que adiciona campo virutal en         !
!                  !  el browse de seleccion de Pedidos para generacion de   !
!                  !  NF                                                     !
!                  !                                                         !
!                  !  Iicializador en Browse para indicar el detalle         !
!                  !  del uso del pedido de venta                            !
!                  !                                                         !
!                  !  Uso: STECK Colombia       						     ! 
!                  ! 						                                 !
!                  !                                                         !
!                  !                                                         !
+------------------+---------------------------------------------------------+
!Autor             ! Gabriel Alejandro Pulido                                !
+------------------+---------------------------------------------------------+
!Fecha creacion    ! 12/2021                                                        !
+------------------+---------------------------------------------------------+
!   ATUALIZACIONES                                                           !
+-------------------------------------------+-----------+-----------+--------+
!Descripcion detallada de la actualizacion  !Nombre del ! Analista  !FEcha de!
!                                           !Solicitante! Respons.  !Atualiz.!
+-------------------------------------------+-----------+-----------+--------+
!                                           !           !           !        !
!                                           !           !           !        !
!                                           !           !           !        !
+-------------------------------------------+-----------+-----------+--------+
|________________________________________________________________________________________|
|   //////  //////  //////  //    //  //////  | Developed For Protheus by TOTVS          |
|    //    //  //    //     //   //  //       | ADVPL                                    |
|   //    //  //    //      // //   //////    | TOTVS Technology                         |
|  //    //  //    //       ////       //     | Gabriel Alejandro Pulido -TOTVS Colombia.|
| //    //////    //        //    //////      | gabriel.pulido@totvs.com                 |
|_____________________________________________|__________________________________________|
|                          _==/                             \==                          |
|                         /XX/            |\___/|            \XX\                        |
|                       /XXXX\            |XXXXX|            /XXXX\                      |
|                      |XXXXXX\_         _XXXXXXX_         _/XXXXXX|                     |
|                      XXXXXXXXXXXxxxxxxxXXXXXXXXXXXxxxxxxxXXXXXXXXXXX                   |
|                     |XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX|                  |
|                     XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                  |
|                     |XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX|                  |
|                      XXXXXX/^^^^"\XXXXXXXXXXXXXXXXXXXXX/^^^^^\XXXXXX                   |
|                      |XXX|       \XXX/^^\XXXXX/^^\XXX/       |XXX|                     |
|                        \XX\       \X/    \XXX/    \X/       /XX/                       |
|                           "\       "      \X/      "       /"                          |
|________________________________________________________________________________________|
|                          //       ////    //   //   //////   //                        |
|                        // //     //  //   //  //   //  //   //                         |
|                       //  //    //  //    // //   //////   //                          | 
|                      ///////   //  //     ////   //       //                           | 
|                     //    //  ////        //    //       ///////                       |
|_______________________________________________________________________________________*/

User Function M468PED()
	Local aCampos := { "C9_XTPEDI" } 
Return aCampos


//Fin Punto de entrada
//Inicializador en Browse para listar el detalle del tipo del pedido.

USer Function uXInTped()
	Local cDato:= ""
	Local cBrw := ""
	cDato := POSICIONE("SC5",1,XFILIAL("SC5")+SC9->C9_PEDIDO,"C5_XTPED")
	If cDato == "B"
		cBrw := "Back to Back"
	ElseIF cDato == "N"
		cBrw := "Venta Nacional"
	ElseIF cDato == "E"
		cBrw := "Venta de Exportacion"
	ElseIF cDato == "O"
		cBrw := "Obsequio"
	EndIF
Return (alltrim(cBrw))
