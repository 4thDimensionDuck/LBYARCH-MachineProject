# LBYARCH-MachineProject
An implementation of Average Filtering on Assembly and C

# Compiling
Open CMD or Powershell and input the following in the repo directory

`nasm -f win32 average_filter.asm`

`gcc -c app.c -o app.obj -m32 -std=c99`

`gcc app.c average_filter.obj -o app.exe -m32 -std=c99`
