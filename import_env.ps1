Get-Content .env | ForEach-Object {
  $line = $_.Trim()

  if ($line -eq "") { return }
  if ($line.StartsWith("#")) { return }

  $parts = $line.Split("=", 2)
  if ($parts.Count -ne 2) { return }

  $key = $parts[0].Trim()
  $val = $parts[1].Trim()

  Set-Item -Path ("Env:{0}" -f $key) -Value $val
}
