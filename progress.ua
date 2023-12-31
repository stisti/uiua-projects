# Copy stdin to stdout while printing progress info
#
# Uiua assumes handle 1 is always used with utf-8 encoded strings.
# Re-open stdout to work around that.
STDOUT ← &fc "/dev/stdout"
TerminalWidth ← |0 ⊏1&ts
StartTime ← |0 now
Round ← |1 ÷10⁅×10°□
# When Display is called, stack contains the total number of bytes read.
Display ← (|1.0
  ÷[1 1024 ×.1024]    # multipliers for bytes, kB and MB
  ∵⊂-StartTime now    # join elapsed time
  :≡/÷.               # calculate speed
  ⍜⍉⊂                 # join speed
  ⍜⍉⊂:{"B" "kB" "MB"} # join unit names
  # Make candidate status lines
  ≡(
    ⊃⊃⊃⊃(Round⊏1)(°□⊏3)(Round⊏0)(Round⊏2)(°□⊏3)
    □$"Total: _ _ | Elapsed: _ s | Speed: _ _/s"
  )
  °□⊢⊏⊚=/↧.≡⧻.      # pick the status line that is shortest
  -:TerminalWidth⧻. # calculate required fill
  ⊂⬚@ ↙:""          # fill with spaces
  &w :2             # write to stderr
  &w "\r" 2
)
DisplayThread ← spawn(⍢(Display .+)(>0. recv 0) 0)
⍢∘(⊃⊃(>0⧻)(send: DisplayThread ⧻)(&w: STDOUT) &rb 4096 0)
&cl STDOUT
# Discard stack from display thread
;;wait DisplayThread
# Sleep to allow any other shell pipeline processes to finish
# their output
&sl 1
# Output one final newline to prevent shell prompt from
# overwriting our progress display
&w "\n" 2
