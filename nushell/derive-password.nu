def main [domain: string, --length: int = 32, --expose] {
  print "Master password: "
  let master = if $expose { input } else { input -s }
  print "Deriving..."
  echo $master | argon2 $domain -d -t 16 -k 16777216 -p 16 -l $length -r -v 13 | wl-copy -n -o
  print "Password has been copied to the clipboard."
}
