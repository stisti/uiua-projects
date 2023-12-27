# Copy stdin to stdout while printing progress info
# 
# Uiua assumes handle 1 is always used with utf-8 encoded strings.
# Re-open stdout to work around it.
STDOUT ← &fc "/dev/stdout"
StartTime ← now
# When Display is called, stack contains the
# the total number of bytes read.
Display ← (
  &w "Total: " 2
  &w °⋕, 2
  &w " B | Elapsed: " 2
  &w °⋕⌊- StartTime now 2
  &w " s | Speed: " 2
  &w °⋕ ⌊÷- StartTime now :2.
  &w " B/s       \r" 2
)
DisplayThread ← spawn(⍢(Display +)(>0. recv 0) 0)
⍢∘(>0 send: DisplayThread .⧻ &w: STDOUT . &rb 4096 0)
&cl STDOUT
# Discard stack from display thread
;;wait DisplayThread
# Sleep to allow any other shell pipeline processes to finish
# their output
&sl 1
# Output one final newline to prevent shell prompt from
# overwriting our progress display
&w "\n" 2
