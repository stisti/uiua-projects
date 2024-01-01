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
# Display thread starts with stack set to (now - 2) seconds.
# This forces Display on first call.
# Main thread will send array [<read byte count> <total byte count>]
# Display thread keeps running as long as <read byte count> >0
DisplayThread ← spawn(⍢((;:|now Display;) <¯0.1-now .:)(⊃(>0⊏0)(⊏1) recv 0) -2 now)
0 # initialize byte count
⍢∘(⊃⊃⊃(>0⧻)(send: DisplayThread [⊃⧻(+⧻)])(&w: STDOUT)(+⧻) &rb 4096 0)
&cl STDOUT
wait DisplayThread
;; # discard display thread stack
# Display might be out of date, so call it one last time
Display
# Sleep to allow any other shell pipeline processes to finish
# their output
&sl 1
# Output one final newline to prevent shell prompt from
# overwriting our progress display
&w "\n" 2

---
⍤.=5.3 Round 5.25
⍤.=5 Round 5
---
