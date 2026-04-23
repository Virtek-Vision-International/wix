@echo off

setlocal
pushd %~dp0

REM Suppress some SDK checks (NETSDK1138)
set CheckEolTargetFramework=false
set CheckEolWorkloads=false

call .\devbuild.cmd Release

:end
popd
endlocal
