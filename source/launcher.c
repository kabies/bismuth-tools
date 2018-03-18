/*
 * Launcher
 */

#include <stdlib.h>
#include <stdio.h>
#include <direct.h>
#include <windows.h>
#include <process.h>

int launch(char *exe_path)
{
    SHELLEXECUTEINFO sinfo;
    sinfo.cbSize       = sizeof(SHELLEXECUTEINFO);
    sinfo.hwnd         = NULL;
    sinfo.fMask        = SEE_MASK_NOCLOSEPROCESS;
    sinfo.lpParameters = "-b main.mrb";
    sinfo.nShow        = SW_SHOW;
    sinfo.lpDirectory  = NULL;
    sinfo.hInstApp     = NULL;
    sinfo.lpFile       = exe_path;
    sinfo.lpVerb       = "open";
    sinfo.nShow        = SW_NORMAL;

    return ShellExecuteEx(&sinfo);
}

int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow)
{
    char dir_path[512];
    char exe_path[512];
    int result;

    TCHAR szFileName[MAX_PATH + 1];
    GetModuleFileName(NULL, szFileName, MAX_PATH + 1);

    chdir("system");
    getcwd(dir_path,512);
    snprintf(exe_path,512,"%s\\%s",dir_path,"mruby.exe");

    result = launch(exe_path);

    return result;
}
