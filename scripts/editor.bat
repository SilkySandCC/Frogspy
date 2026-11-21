@echo off
if not defined GODOT set GODOT=C:\Godot_v4.7.2\Godot.exe
"%GODOT%" --path "%~dp0.." -e
