# Forçar SSL
switch("d", "ssl")
switch("d", "useOpenssl")

# Flags de compilação
switch("opt", "speed")
switch("passL", "-lssl -lcrypto")

# Para release
when defined(release):
  switch("d", "release")
  switch("opt", "speed")
