"delete: " + $Args[0]
$user_path = [Environment]::GetEnvironmentVariable('PATH', 'User')
$paths = $Args[0].Split('^;')
$users = $user_path.Split(';')
foreach($path in $paths) {
  $users = $users -ne $path
}
[Environment]::SetEnvironmentVariable('PATH', $users   -join ';', 'User')

