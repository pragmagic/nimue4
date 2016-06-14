@echo off

set NIM_HOME=C:\Program Files (x86)\Nim\ rem change this
set NIMUE_HOME=C:\Users\jdoe\nimue4\ rem change this
set VS_HOME=C:\Program Files (x86)\Microsoft Visual Studio 14.0
set UE4_HOME=C:\Program Files (x86)\Epic Games\4.12

set PATH=%PATH%;%NIM_HOME%\bin\

call "%VS_HOME%\VC\bin\x86_amd64\vcvarsx86_amd64.bat"
nim %*
