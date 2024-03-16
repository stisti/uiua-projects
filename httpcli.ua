# Assume first arg is string like "https://httpbin.org/headers"
# (Scheme is actually ignored and this always uses port 443)
Url ← °□⊏1&args
&w $"Url=_\n" Url 2
# Split by /
Parts ← ⊜□≠@/.Url
# Assume first part is scheme, second is host
Host ← °□⊏1 Parts
&w $"Host=_\n" Host 2
Path ← /◇$"_/_"⊏+2⇡-2⧻.Parts
&w $"Path=_\n" Path 2
# tcp connection to host:443
&tcpc ⊂ Host ":443"
# drop host from Url and make request
&httpsw $"GET /_ HTTP/1.0" Path
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
