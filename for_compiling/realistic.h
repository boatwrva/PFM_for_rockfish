/*
** svn $Id: estuary_test.h 831 2017-01-24 21:38:51Z arango $
*******************************************************************************
** Copyright (c) 2002-2017 The ROMS/TOMS Group                               **
**   Licensed under a MIT/X style license                                    **
**   See License_ROMS.txt                                                    **
*******************************************************************************
**
** Options for SD_TJRE
**
** Application flag:   SD_TJRE
** Input script:      ocean_SD_TJRE.in
**
**
*/




#define PERFECT_RESTART
                                           
#define SOLVE3D
#define MASKING  
#define WET_DRY  
#undef DIAGNOSTICS
#define UV_VIS2
#define TS_VIS2


#define UV_ADV
#define UV_LOGDRAG
#define UV_COR 
#define UV_U3HADVECTION
#define UV_C4VADVECTION
#define MIX_S_UV


#define RADIATION_2D


#define SPLINES_VDIFF
#define SPLINES_VVISC


#define TS_MPDATA  
#define TS_DIF2   
#undef T_PASSIVE  
#define SALINITY  
#define NONLIN_EOS 
#define MIX_S_TS


#define BULK_FLUXES 
#define LONGWAVE_OUT
#undef LONGWAVE       
#define SOLAR_SOURCE
#define EMINUSP


#undef SSH_TIDES 
#undef UV_TIDES  
#undef RAMP_TIDES 
#undef ADD_FSOBC
#undef ADD_M2OBC


#define GLS_MIXING  
#if defined GLS_MIXING || defined MY25_MIXING
# define KANTHA_CLAYSON
# undef  CANUTO_A
# define N2S2_HORAVG
# undef RI_SPLINES
#endif


#undef ANA_INITIAL
#undef ANA_SMFLUX
#undef ANA_STFLUX
#define ANA_BTFLUX
#undef ANA_SSFLUX
#define ANA_BSFLUX
#undef ANA_SPFLUX
#undef ANA_BPFLUX
#undef ANA_FSOBC
#undef ANA_M2OBC
#undef ANA_TOBC
