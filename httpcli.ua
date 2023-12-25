Url ← °□⊏1&args
Parts ← ⊜□≠@/.Url
Host ← °□⊢Parts
Path ← ↘⧻ Host Url
# tcp connection to host:443
&tcpc ⊂ Host ":443"
⊂⊂ "GET " Path " HTTP/1.0"
&httpsw
# drop carriage return
▽≠@\r.
# split by newline
⊜□≠@\n.
# print strings
≡(&p°□)
