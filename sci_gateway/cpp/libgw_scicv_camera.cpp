#include <wchar.h>
#include "libgw_scicv_camera.hxx"
extern "C"
{
#include "libgw_scicv_camera.h"
#include "addfunction.h"
}

#define MODULE_NAME L"libgw_scicv_camera"

int libgw_scicv_camera(wchar_t* _pwstFuncName)
{
    if(wcscmp(_pwstFuncName, L"cvCameraAuthStatus") == 0){ addCStackFunction(L"cvCameraAuthStatus", &sci_cvCameraAuthStatus, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"cvRequestCameraAccess") == 0){ addCStackFunction(L"cvRequestCameraAccess", &sci_cvRequestCameraAccess, MODULE_NAME); }

    return 1;
}
