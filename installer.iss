[Setup]
#define MyAppVersion "1.0"
AppName=Spotube Optimisé
AppVersion={#MyAppVersion}
DefaultDirName={pf}\SpotubeOptimise
DefaultGroupName=Spotube Optimisé
OutputDir=Output
OutputBaseFilename=Spotube-Optimise-Setup
Compression=lzma
SolidCompression=yes

[Files]
Source: "build\windows\runner\Release\*"; DestDir: "{app}"; Flags: recursesubdirs

[Icons]
Name: "{group}\Spotube Optimisé"; Filename: "{app}\Spotube.exe"
Name: "{group}\Désinstaller Spotube Optimisé"; Filename: "{uninstallexe}"
Name: "{commondesktop}\Spotube Optimisé"; Filename: "{app}\Spotube.exe"
