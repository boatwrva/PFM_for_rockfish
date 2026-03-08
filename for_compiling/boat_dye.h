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

#define ROMS_MODEL
#define SWAN_MODEL
#define MCT_LIB

#define PERFECT_RESTART
                                             
#define SOLVE3D 
#define MASKING 
#define WET_DRY
#define CURVEGRID
#undef AVERAGES 
#undef DIAGNOSTICS_UV
#undef DIAGNOSTICS_TS
#undef DIAGNOSTICS
				   
#define UV_ADV
#define UV_LOGDRAG 
#define UV_COR
#define UV_U3HADVECTION
#define UV_C4VADVECTION

#define UV_VIS2
#define TS_DIF2
#define MIX_S_UV
#define MIX_S_TS
                              
#define RADIATION_2D
#define SPLINES_VDIFF
#define SPLINES_VVISC


#define TS_MPDATA
#define SALINITY
#define NONLIN_EOS

/* 
** Falk had: 
** 
** #define WEC_VF
** #define WDISS_WAVEMOD
**
*/

/* defining wave variables for v3.8 coawst */
#undef  WEC_MELLOR
#define WEC_VF
#define WDISS_WAVEMOD
#define UV_KIRBY
#undef  UV_BANIHASHEMI
#define SWAN_SINGLESPEC
#undef  WAVE_PARTITION
/* delayed momentum transfer for fraction of breaking waves. not done in 2021 coawst - keeping similar to matt by turning off */
#undef ROLLER_RENIERS


#define BULK_FLUXES 
#define LONGWAVE_OUT
#define SOLAR_SOURCE
#define EMINUSP


#define GLS_MIXING 
#if defined GLS_MIXING || defined MY25_MIXING
#define KANTHA_CLAYSON
#define ZOS_HSIG
#define TKE_WAVEDISS 
# undef  CANUTO_A
#define N2S2_HORAVG
# undef RI_SPLINES
#endif

#define T_PASSIVE
#define ANA_PASSIVE

#undef ANA_INITIAL
#undef ANA_SEDIMENT
#undef ANA_SMFLUX

#define ANA_STFLUX
#define ANA_BTFLUX
#undef ANA_SSFLUX 
#define ANA_BSFLUX
#define ANA_SPFLUX
#define ANA_BPFLUX
#undef ANA_FSOBC
#undef ANA_M2OBC
#undef ANA_TOBC

#undef ANA_TCLIMA
#undef ANA_NUDGCOEF
