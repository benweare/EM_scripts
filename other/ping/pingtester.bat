:: Search for arbitary domains using the command line
:: ctrl + c to kill script
ECHO ON
::declare variables
set domain=weare
set control_ping=google.com
set input=pingin.txt
set output=pingout.txt
::test a stable domain
ping %control_ping% -n 1 -w 1000 | find "TTL=" >nul
if errorlevel 1 (
		echo %control_ping%, 0 >>%output%
	) else (
		echo %control_ping%, 1 >>%output%
	)
)
::run through list of domains
for /f "tokens=* delims=<space> " %%A in (%input%) do (
	ping %domain%%%A -n 1 -w 1000 | find "TTL=" >nul
	if errorlevel 1 (
		echo %domain%%%A, 0 >>%output%
	) else (
		echo %domain%%%A, 1 >>%output%
	)
)