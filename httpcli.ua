Url ← °□⊏1&args
# Split by /, take first
Host ← °□⊢⊜□≠@/.Url
# tcp connection to host:443
&tcpc ⊂ Host ":443"
# drop host from Url and
# make request first line
⊂⊂ "GET " ↘⧻ Host Url " HTTP/1.0"
&httpsw
# drop carriage return
▽≠@\r.
&p
