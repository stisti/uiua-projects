# Grouping of identical card values
# ⊕□⊛."A2A23"

# HandType: sorted count of identical card values.
# e.g. "Full House" = [3 2]
HandType ← ⊏⍖.⊕⧻⊛.
HandTypes ← {[5] [4 1] [3 2] [3 1 1] [2 2 1] [2 1 1 1] [1 1 1 1 1]}
HandNames ← {"Five Of A Kind" "Four Of A Kind" "Full House" "Three Of A Kind" "Two Pair" "One Pair" "High Card"}

IdentifyHand ← °□⊢▽:HandNames =HandTypes □HandType
# IdentifyHand "AAAAA"
# IdentifyHand "56789"

# Get numeric strength of hand. 7 highest, 0 lowest
# (identify HandType, then find its index in HandTypes)
HandStrength ← -:7⊗:HandTypes □HandType

# HandStrength "KK677"
# ⊏⍏≡HandStrength. ["32T3K" "T55J5" "KK677" "KTJJT" "QQQJA"]
# ≡HandStrength. ["32T3K" "T55J5" "KK677" "KTJJT" "QQQJA"]

# When multiple hands have same strength, they are sorted by
# comparing individual card values going left-to-right.

# CardValue as number. 2=lowest, 14=highest
CardValue ← +2⊗:"23456789TJQKA"
# CardValue "2"
# CardValue "9"
# CardValue "T"
# CardValue "A"
# CardValue "32T3K"

# ⍏ . [5_1 5_0 2_3 4_5]
# ⍉.⊟ [1 2 3] [4 5 6]

# ⍉⊂ ⊙(⍉CardValue) ≡HandStrength. ["32T3K" "T55J5" "KK677" "KTJJT" "QQQJA"]
# ⊏⍏CardValue. ["32T3K" "T55J5" "KK677" "KTJJT" "QQQJA"]

# Sorting hands:
# 1. get array of hand strengths
# 2. get matrix of card values
# 3. join hand strength as first column into matrix
# 4. normal sorting
HandSort ← ⊏⍖ ⍉⊂ ⊙(⍉CardValue) ≡HandStrength..

HandSort .["32T3K" "T55J5" "KK677" "KTJJT" "QQQJA"]
