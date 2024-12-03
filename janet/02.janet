(use judge)

(def sample (string/trim (slurp "../input/02.sample")))
(def input (string/trim (slurp "../input/02.input")))

## SHARED #######################################

(def peg ~{
  :main (split "\n" (group :line))
  :line (split :s+ (number :d+))
  })

(test (peg/match peg sample)
  @[@[7 6 4 2 1]
    @[1 2 7 8 9]
    @[9 7 6 2 1]
    @[1 3 2 4 5]
    @[8 6 4 4 1]
    @[1 3 6 7 9]])

## PART 1 #######################################

(defn part-1 [input]
  (def lines (peg/match peg input))
  (var i 0)
  (while (< i (length lines))
      (print (get lines i))
      (++ i)))


## PART 2 #######################################

(defn part-2 [input] 0)

#################################################

(test (part-1 sample) 0)
(test (part-2 sample) 0)
