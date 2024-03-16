# Assume first arg is string like "https://httpbin.org/headers"
# (Scheme is actually ignored and this always uses port 443)

UrlParts ← |1 ⊜□≠@/.
HostFromParts ← |1 °□⊏1
PathFromParts ← |1 /◇$"_/_"⊏+2⇡-2⧻.

# Stack contains url when this is called
HttpCli ← (|1.0
  &w $"Url=_\n" :2.
  UrlParts
  &w $"Host=_\n" :2 HostFromParts.
  # tcp connection to host:443
  &tcpc $"_:443" HostFromParts.
  PathFromParts:
  &w $"Path=_\n" :2.
  # drop host from Url and make request
  &httpsw $"GET /_ HTTP/1.0"
  # stack now contains the http reply, both headers and body
  &w ">>> Headers begin\n" 2
  # find the empty line that separates headers and body
  ⌕"\r\n\r\n".
  # result is mask where there is 1 where empty line begins
  # move the 1 right so it marks where body begins
  ⬚0↻¯4
  # propagate the 1 to end of mask
  \↥
  # get a copy of http reply and mask
  ,,
  # flip the mask to keep header
  ▽¬
  # drop carriage returns and print
  ▽≠@\r.
  &w:2
  &w "<<< Headers end\n" 2
  # now the stack has http reply and mask for body
  &w:1 ▽
)

HttpCli °□⊏1&args
---
TestUrl ← "http://example.com/pa/th"
⍤.≍{"http:" "example.com" "pa" "th"} UrlParts TestUrl
⍤.≍"example.com" HostFromParts UrlParts TestUrl
⍤.≍"pa/th" PathFromParts UrlParts TestUrl
---
