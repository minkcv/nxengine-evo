#prepare
mkdir release
cd release
wget http://www.cavestory.org/downloads/cavestoryen.zip -outfile cavestoryen.zip
7z x .\cavestoryen.zip
rm .\cavestoryen.zip
mkdir NXEngine

#prepare and copy data
if ($env:PLATFORM -eq "x86") {
  cp ..\bin\Win32\Release\extract_Win32.exe .\CaveStory\extract.exe
  cp ..\bin\Win32\Release\nx_Win32.exe .\NXEngine\nx.exe
} else {
  cp ..\bin\x64\Release\extract_x64.exe .\CaveStory\extract.exe
  cp ..\bin\x64\Release\nx_x64.exe .\NXEngine\nx.exe
}

cd .\CaveStory\
.\extract.exe
cd ..

cp -r .\CaveStory\data\ .\NXEngine\
cp -r .\CaveStory\org\ .\NXEngine\
cp -r .\CaveStory\pxt\ .\NXEngine\
cp .\CaveStory\stage.dat .\NXEngine\
cp .\CaveStory\wavetable.dat .\NXEngine\
cp -r -force ..\data\ .\NXEngine\
cp ..\font.ttf .\NXEngine\
cp ..\smallfont.bmp .\NXEngine\
cp ..\sprites.sif .\NXEngine\
cp ..\tilekey.dat .\NXEngine\


if ($env:PLATFORM -eq "x86") {
  #bundle libs
  cp ..\win32\ext\runtime\x86\* .\NXEngine\

  #create zip
  $name = "NXEngine-$env:APPVEYOR_REPO_TAG_NAME-Win32.zip"
  7z a $name .\NXEngine\

  Push-AppveyorArtifact $name

  #upload
  invoke-webrequest -UseBasicParsing -method put -infile ".\$name" https://transfer.sh/$name
} else {
  #bundle libs
  cp ..\win32\ext\runtime\x64\* .\NXEngine\

  #create zip
  $name = "NXEngine-$env:APPVEYOR_REPO_TAG_NAME-Win64.zip"
  7z a $name .\NXEngine\

  Push-AppveyorArtifact $name

  #upload
  invoke-webrequest -UseBasicParsing -method put -infile ".\$name" https://transfer.sh/$name

}