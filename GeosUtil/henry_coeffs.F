!------------------------------------------------------------------------------
!                  Harvard-NASA Emissions Component (HEMCO)                   !
!------------------------------------------------------------------------------
!BOP
!
! !MODULE: henry_coeffs.F
!
! !DESCRIPTION: Module HENRY\_COEFFS contains Henry coefficients for a
! suite of species.
!
! !INTERFACE: 
!
      MODULE HENRY_COEFFS
!
! !USES:
!
      IMPLICIT NONE
      PRIVATE
!
! !PUBLIC MEMBER FUNCTIONS:
!
      PUBLIC :: GET_HENRY_CONSTANT
!
! !REMARKS:
!  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
!  %%% NOTE: Module henry_coeffs.F is only needed for the HEMCO standalone %%%
!  %%% code.  When running within GEOS-Chem, HEMCO will get the Henry's    %%%
!  %%% law coefficients from the GEOS-Chem Species Database.  These are    %%%
!  %%% the stored in the following fields of the State_Chm object:         %%%
!  %%%                                                                     %%%
!  %%%    State_Chm%SpcData(N)%Info%Henry_K0                               %%%
!  %%%    State_Chm%SpcData(N)%Info%Henry_CR                               %%%
!  %%%    State_Chm%SpcData(N)%Info%Henry_pKa                              %%%
!  %%%                                                                     %%%
!  %%% If you add additional species to the HEMCO seaflux extension for    %%%
!  %%% use with the HEMCO standalone code, then you will need to add the   %%%
!  %%% additional Henry's law constants below.                             %%%
!  %%%                                                                     %%%
!  %%%    -- Bob Yantosca (07 Jan 2016)                                    %%%
!  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
!
! !REVISION HISTORY:
!  16 Apr 2013 - C. Keller   - Initial version
!  02 Dec 2014 - M. Yannetti - Added PRECISION_MOD
!  11 Dec 2014 - M. Yannetti - Reverted PRECISION changes due to hcoi_gc_main_mod
!EOP
!------------------------------------------------------------------------------
!BOC
!
! !PRIVATE TYPES:
!

      ! Constants to be used for each tracer
      INTEGER,           PARAMETER :: N = 4

      ! NOTE: GFORTRAN throws a hissy fit if the names in the array 
      ! constructor are not all the same length (bmy, 9/19/16)
      CHARACTER(LEN=31), PARAMETER :: NAME(N) = (/
     &  'H2O2',   ! Jacob et al. 2000 
     &  'CH3I',   ! Moore et al. 1995
     &  'DMS ',   ! De Bruyn et al. 1995
     &  'ACET' /) ! Benkelberg et al. 1995

      REAL*8,          PARAMETER :: K0(N)   = (/ 8.3d+4,  
     &                                           1.4d-1,
     &                                           4.8d-1, 
     &                                           27d+0   /)

      REAL*8,          PARAMETER :: CR(N)   = (/ 7.4d+3,  
     &                                           4.3d+3,
     &                                           3.1d+3,  
     &                                           5300d+0 /) 

      REAL*8,          PARAMETER :: PKa(N)  = (/ -999d+0, 
     &                                           -999d+0,
     &                                           -999d+0, 
     &                                           -999d+0 /) 

      CONTAINS
!EOC
!------------------------------------------------------------------------------
!                  Harvard-NASA Emissions Component (HEMCO)                   !
!------------------------------------------------------------------------------
!BOP
!
! !IROUTINE: GET_HENRY_CONSTANT
!
! !DESCRIPTION: Subroutine GET\_HENRY\_CONSTANT returns the Henry
! constants for the given species by name.
! K0 is the Henry constant @ 298K in [M/atm, liquid over gas], and CR is 
! the temperature dependency -d ln(kH) / d(1/T), following Sander (1999):
! http://www.mpch-mainz.mpg.de/~sander/res/henry.html
!\\
!\\
! !INTERFACE:
!
      SUBROUTINE GET_HENRY_CONSTANT ( NM, thisK0, thisCR, thispKa, RC )
!
! !INPUT/OUTPUT PARAMETERS:
!
      CHARACTER(LEN=*), INTENT(IN   )  :: NM
      REAL*8,           INTENT(  OUT)  :: thisK0      
      REAL*8,           INTENT(  OUT)  :: thisCR     
      REAL*8,           INTENT(  OUT)  :: thispKa    
      INTEGER,          INTENT(INOUT)  :: RC    
!
! !REVISION HISTORY:
!  16 Apr 2013 - C. Keller - Initial version
!EOP
!------------------------------------------------------------------------------
!BOC
!
! !LOCAL VARIABLES
!
      INTEGER :: I

      !=================================================================
      ! GET_HENRY_CONSTANT begins here!
      !=================================================================

      ! Init
      RC      = 0
      thisK0  = -999.0d+0
      thisCR  = -999.0d+0
      thisPKa = -999.0d+0

      ! Loop over all species
      DO I = 1,N
         IF ( TRIM(NAME(I)) == TRIM(NM) ) THEN
            thisK0  = K0(I)
            thisCR  = CR(I)
            thisPKa = pKA(I)
            RETURN
         ENDIF
      ENDDO
 
      END SUBROUTINE GET_HENRY_CONSTANT 
!EOC
      END MODULE HENRY_COEFFS
!EOM
