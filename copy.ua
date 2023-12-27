# Copy stdin to stdout
#
# Uiua assumes handle 1 is always used with utf-8 encoded strings.
# Re-open stdout to work around it.
STDOUT ← &fc "/dev/stdout"
⍢∘(>0⧻&w: STDOUT . &rb 4096 0)
&cl STDOUT
