(use judge)

(def sample (string/trim (slurp "../input/03.sample")))
(def input (string/trim (slurp "../input/03.input")))

## SHARED ######################################################################

(def peg
  ~{:mul (group (* "mul(" (number :d+) "," (number :d+) ")"))
    :main (some (+ :mul 1))})

(test (peg/match peg sample) @[@[2 4] @[5 5] @[11 8] @[8 5]])

## PART 1 ######################################################################

(defn part-1 [input]
  (def numbers (peg/match peg input))
  (sum (map product numbers)))

(test (part-1 sample) 161)
(test (part-1 input) 188741603)

## PART 2 ######################################################################

(defn part-2 [input]
  (def dos
    (string/join
      (map
        (fn [val] (first (string/split "don't()" val))) 
        (string/split "do()" input))))

  (def numbers (peg/match peg dos))
  (sum (map product numbers)))

(test (part-2 sample) 48)
(test (part-2 input) 67269798)
