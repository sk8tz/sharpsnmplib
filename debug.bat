:: http://stackoverflow.com/questions/328017/path-to-msbuild
:: http://www.csharp411.com/where-to-find-msbuild-exe/
:: http://timrayburn.net/blog/visual-studio-2013-and-msbuild/
:: http://blogs.msdn.com/b/visualstudio/archive/2013/07/24/msbuild-is-now-part-of-visual-studio.aspx
for %%v in (2.0, 3.5, 4.0, 12.0, 14.0) do (
  for /f "usebackq tokens=2* delims= " %%c in (`reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\MSBuild\ToolsVersions\%%v" /v MSBuildToolsPath`) do (
    set msBuildExe=%%dMSBuild.exe
  )
)

rmdir /S /Q bin
mkdir bin
rmdir /S /Q SharpSnmpLib\obj
rmdir /S /Q Tests\obj
.nuget\nuget.exe restore SharpSnmpLib.Classic.sln
call "%MSBuildExe%" SharpSnmpLib.Classic.sln /t:clean /p:Configuration=Debug /p:OutputPath=..\bin\
call "%MSBuildExe%" SharpSnmpLib.Classic.sln /t:build /p:Configuration=Debug /p:OutputPath=..\bin\
call dotnet restore SharpSnmpLib.NetStandard.sln
call dotnet build SharpSnmpLib.NetStandard.sln /t:build /p:Configuration=Debug /p:OutputPath=..\bin\
@IF %ERRORLEVEL% NEQ 0 PAUSE