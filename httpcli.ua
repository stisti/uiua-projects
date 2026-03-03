# Assume first arg is string like "https://httpbin.org/headers"
# (Scheme is actually ignored and this always uses port 443)

UrlParts ← |1 ⊜□≠@/.
HostFromParts ← |1 °□⊏1
PathFromParts ← |1 /◇$"_/_"⊏+2⇡-2⧻.

# Stack contains url when this is called
HttpCli ← (|1.0
  &w $"Url=_\n" :2.
  UrlParts
  HostFromParts.
  &w $"Host=_\n" :2.
  ⊙PathFromParts
  ⊙(&w $"Path=_\n" :2.)
  # Stack: [path, host] (host on top)
  # Dup host: one for TLS address, one for Host header in request
  .
  &tlsc $"_:443"
  # Stack: [path, host, socket] (socket on top)
  # Build HTTP/1.0 request using path and host (dip to hide socket)
  # In right-to-left eval: : flips [path,host] so path is on top for first _
  ⊙($"GET /_ HTTP/1.0\r\nHost: _\r\n\r\n" :)
  # Stack: [request, socket] (socket on top)
  # Dup socket for write + read, rearrange: . ⊙: : → [socket, socket, request]
  °utf₈ &rb ∞ &w : ⊙: .
  # stack now contains the http reply, both headers and body
  &w ">>> Headers begin\n" 2
  # find the empty line that separates headers and body
  ⌕"\r\n\r\n".
  # result is mask where there is 1 where empty line begins
  # move the 1 right so it marks where body begins
  ⬚0↻¯4
  # propagate the 1 to end of mask
  \↥
  # get copies of http reply and mask (replaces deprecated ,,)
  ⟜⊙.
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

TestUrl2 ← "https://api.example.com/v1/data"
⍤.≍{"https:" "api.example.com" "v1" "data"} UrlParts TestUrl2
⍤.≍"api.example.com" HostFromParts UrlParts TestUrl2
⍤.≍"v1/data" PathFromParts UrlParts TestUrl2

TestUrl3 ← "https://example.com/a/b/c/d"
⍤.≍{"https:" "example.com" "a" "b" "c" "d"} UrlParts TestUrl3
⍤.≍"example.com" HostFromParts UrlParts TestUrl3
⍤.≍"a/b/c/d" PathFromParts UrlParts TestUrl3
---
