BEGIN {
  m["font-size:10.5px"]="font-size:14px"
  m["font-size:11px"]="font-size:14px"
  m["font-size:11.5px"]="font-size:15px"
  m["font-size:12px"]="font-size:15px"
  m["font-size:12.5px"]="font-size:16px"
  m["font-size:13px"]="font-size:16px"
  m["font-size:13.5px"]="font-size:17px"
  m["font-size:14px"]="font-size:17px"
  m["font-size:15px"]="font-size:18px"
}
{
  for (k in m) gsub(k, "@@" substr(k,11) "@@")
  for (k in m) gsub("@@" substr(k,11) "@@", m[k])
  print
}
