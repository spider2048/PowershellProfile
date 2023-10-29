$global:hostname = hostname

function repath() {
	$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User") 
}

function addpath($p) {
	$env:path = ";$p;$env:PATH"
	echo "Added $p to path"
}

function path() {
	$env:path.split(";")
}

function stats() {
	$out = wc -l (Get-PSReadLineOption).HistorySavePath | cut -d " " -f 1
	echo "Total commands: $out" 
}

set-alias which where.exe
# Set-Alias find  $(which find).split('`n')[1]  # msys2's find
set-alias find D:\msys64\usr\bin\find.exe
set-alias cat bat.exe
set-alias c clear
set-alias npp notepad++
set-alias vim nvim-qt

function colorenum() {
	$colors = [enum]::GetValues([System.ConsoleColor])
	Foreach ($bgcolor in $colors){
		Foreach ($fgcolor in $colors) { Write-Host "$fgcolor|"  -ForegroundColor $fgcolor -BackgroundColor $bgcolor -NoNewLine }
		    Write-Host " on $bgcolor"
	}
}

function p_hostname() {
	$hostname = hostname
	Write-Host $env:UserName -ForegroundColor Green -NoNewline
	Write-Host '@' -NoNewLine
	Write-Host $hostname -ForegroundColor Cyan -NoNewLine
}

function p_returncode() {
	Write-Host " $ret" -ForegroundColor DarkGray -NoNewLine
}

function p_timetaken() {
	$command = Get-History -Count 1
	$time = [Math]::round(($command.endExecutionTime - $command.StartExecutionTime).Totalmilliseconds)

	$time = [float]($time / 1000)
	Write-Host " $time`s" -ForegroundColor Gray -NoNewline
}

function p_folder() {
	Write-Host "" $pwd -ForegroundColor Yellow
}

function p_prompt() {
	Write-Host "%" -ForegroundColor Cyan -NoNewline
	echo " "
}

function prompt() {
	$ret = $LASTEXITCODE

	Write-Host " "
	# p_hostname 
	# $hostname = hostname
	Write-Host $env:UserName -ForegroundColor Green -NoNewline
	Write-Host '@' -NoNewLine
	Write-Host $global:hostname -ForegroundColor Cyan -NoNewLine
	
	# p_returncode 
	Write-Host " $ret" -ForegroundColor DarkGray -NoNewLine
	# p_timetaken 
	$command = Get-History -Count 1
	$time = [Math]::round(($command.endExecutionTime - $command.StartExecutionTime).Totalmilliseconds)

	$time = [float]($time / 1000)
	Write-Host " $time`s" -ForegroundColor Gray -NoNewline	
	# p_folder 
	Write-Host "" $pwd -ForegroundColor Yellow
	# p_prompt 
	Write-Host "%" -ForegroundColor Cyan -NoNewline
	echo " "
}

function connect() {
    $cwd = $PWD.Path
    $cwd = $cwd.replace('C:', '/mnt/C')
    $cwd = $cwd.replace('D:', '/mnt/D')
    $cwd = $cwd.replace("\", '/')
    # plink.exe -load X11 -t "cd '$cwd' && export DISPLAY=192.168.100.1:0 && /bin/terminator"
	ssh 192.168.100.7 -t "cd '$cwd' && /bin/zsh -i"
}

function py2c($in, $out) {
	if (test-path $in) {
		iex "cython --embed -3 --cplus -o $in.cpp $in"
		iex "g++ -I $env:Pyclude $in.cpp -l python311.lib -L $env:Pylib -Ofast -march=native -o $out.exe"
		del "$in.cpp"
		del "$out.exp"
		del "$out.lib"
	} else {
		echo "DNE $in"
	}
}

function vs() {
	push-location
	& "D:\Program Files\Microsoft Visual Studio\2022\Community\Common7\Tools\Launch-VsDevShell.ps1" -Arch amd64
	pop-location
}

function vs32() {
	push-location
	& "C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\Tools\Launch-VsDevShell.ps1"
	pop-location
}

function vmup() {
	vboxmanage startvm arch --type=headless
}

function vmdown() {
	vboxmanage controlvm arch acpipowerbutton
}
