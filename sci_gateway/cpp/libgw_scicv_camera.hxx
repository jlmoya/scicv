#ifndef __LIBGW_SCICV_CAMERA_GW_HXX__
#define __LIBGW_SCICV_CAMERA_GW_HXX__

#ifdef _MSC_VER
#ifdef LIBGW_SCICV_CAMERA_GW_EXPORTS
#define LIBGW_SCICV_CAMERA_GW_IMPEXP __declspec(dllexport)
#else
#define LIBGW_SCICV_CAMERA_GW_IMPEXP __declspec(dllimport)
#endif
#else
#define LIBGW_SCICV_CAMERA_GW_IMPEXP
#endif

extern "C" LIBGW_SCICV_CAMERA_GW_IMPEXP int libgw_scicv_camera(wchar_t* _pwstFuncName);



#endif /* __LIBGW_SCICV_CAMERA_GW_HXX__ */
