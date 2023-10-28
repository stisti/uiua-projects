# Check if matrix is an x-matrix
# (it has non-zeros on diagonal and zero everywhere else)
Xmatrix ← (
  # create identity matrix
  # (1 on diagonal, 0 elsewhere)
  .   # dup the argument on stack
  ⧻   # get length of array side
  +1⇡ # array of 1..(length of side)
  ⊞=. # combine with itself
  ⇌.  # make a copy and "rotate"
  ↥   # max
  # top of stack now is the identity matrix
  ∶  # flip
  ↧1 # argument matrix is now on top, min(1, arg)
  ≍  # is the result equal to identity matrix
)

Xmatrix . [2_0_0_1 0_3_1_0 0_5_2_0 4_0_0_2]
