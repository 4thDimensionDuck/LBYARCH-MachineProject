# LBYARCH-MachineProject
An implementation of Average Filtering on Assembly and C

# Files Included

 - app.c
 - average_filter.asm
 - compile.bat

# Compiling
Open CMD or Powershell and input the following in the repo directory

`nasm -f win32 average_filter.asm`

`gcc -c app.c -o app.obj -m32 -std=gnu11`

`gcc app.obj average_filter.obj -o app.exe -m32 -std=gnu11`

Alternatively, run the compile.bat file in PowerShell.
