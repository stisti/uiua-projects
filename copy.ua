# Copy stdin to stdout
#
# Uiua assumes handle 1 is always used with utf-8 encoded strings.
# Re-open stdout to work around it.
STDOUT ← &fc "/dev/stdout"
# Reading more bytes from handle 0 than are available produces an error.
# Opening a new handle behaves better, it just returns the bytes it has.
STDIN ← &fo "/dev/stdin"
BUFSIZ ← 4096
⍢(|1 ⧻⟜&w &rb BUFSIZ STDIN STDOUT ◌)(=BUFSIZ) BUFSIZ
&cl STDOUT
◌ # number bytes read is still on the stack
