$path = [Environment]::GetEnvironmentVariable('PATH', 'User')
if (-not $path.EndsWith(';')) {
  $path += ';'
}
$path += $Args[0]
[Environment]::SetEnvironmentVariable('PATH', $path, 'User')
