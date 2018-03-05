/*
 * Launcher
 */

#include <stdlib.h>
#include <stdio.h>
#include <direct.h>
#include <windows.h>
#include <process.h>

// use ShellExecuteEx
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
    FILE * fp;
    int result;

    fp = fopen("log.txt","w");
    fprintf(fp,"start...\n");
    printf("this is printf\n");

    TCHAR szFileName[MAX_PATH + 1];
    GetModuleFileName(NULL, szFileName, MAX_PATH + 1);
    fprintf(fp,"@ %s\n", szFileName);

    chdir("system");
    getcwd(dir_path,512);
    fprintf(fp,"getcwd: %s\n",dir_path);
    snprintf(exe_path,512,"%s\\%s",dir_path,"mruby.exe");
    fprintf(fp,"%s\n",exe_path);

    result = launch(exe_path);

    if(result==-1) {
      fprintf(fp,"error %s\n", strerror(errno));
    }else{
      fprintf(fp,"%d\n", result);
    }

    fclose(fp);
    return 1;
}
