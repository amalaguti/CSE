@echo off
start "" /b /w cmd /c salt-call --local test.sleep 30 --out=quiet
salt-call --local environ.get windir --out=newline_values_only --out-file=%TEMP%\test.txt
