(use judge)

(def sample (string/trim (slurp "../input/03.sample")))
(def input (string/trim (slurp "../input/03.input")))

## PART 1 #######################################

(def peg-1 ~{
  :main (some (+ :mul 1))
  :mul (group (* "mul(" (number :d+) "," (number :d+) ")"))
  })

(test (peg/match peg-1 sample) @[@[2 4] @[5 5] @[11 8] @[8 5]])

(defn part-1 [input]
  (def numbers (peg/match peg-1 input))
  (sum (map product numbers)))

## PART 2 #######################################

(defn part-2 [input] 0)

#################################################

(test (part-1 sample) 161)
(test (part-1 input) 188741603)

(test (part-2 sample) 0)
(test (part-2 input) 0)
