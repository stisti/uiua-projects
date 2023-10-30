# Count how many letters 'l' there are in "Hello"
# Make array of 'l' letters, compare to "Hello",
# true is 1, sum of 1s is the answer.
/+= ↯[5]@l "Hello"
# The string does not have to be of length 5.
# Discover the length of the string.
/+= ↯∶@l△. "Hello"
# Actually, we can just use rank polymorphism.
/+=@l "Hello"
