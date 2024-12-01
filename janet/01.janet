(use judge)

(def sample (slurp "../inputs/01.sample"))
(def input (slurp "../inputs/01.input"))

## SHARED ######################################################################

(def peg ~{
  :main (split "\n" :line)
  :line (split "   " :locations)
  :locations (* (at-least 2 (number :d+)))
  })

(test (peg/match peg sample) 11)

## PART 1 ######################################################################

(defn part-1 [input] input)

## PART 2 ######################################################################

(defn part-2 [input] input)

################################################################################

(test (part-1 sample) 11)
(test (part-2 sample) 31)
