; Optimality lenght is (:optlen 23)

(define (problem problem_5_58)
  (:domain hanoi)
(:objects 
peg1 peg2 peg3 d1 d2 d3 d4 d5 )
  (:init 
(smaller peg1 d1)
(smaller peg1 d2)
(smaller peg1 d3)
(smaller peg1 d4)
(smaller peg1 d5)
(smaller peg2 d1)
(smaller peg2 d2)
(smaller peg2 d3)
(smaller peg2 d4)
(smaller peg2 d5)
(smaller peg3 d1)
(smaller peg3 d2)
(smaller peg3 d3)
(smaller peg3 d4)
(smaller peg3 d5)
(smaller d2 d1)
(smaller d3 d1)
(smaller d4 d1)
(smaller d5 d1)
(smaller d3 d2)
(smaller d4 d2)
(smaller d5 d2)
(smaller d4 d3)
(smaller d5 d3)
(smaller d5 d4)
(on d1 peg1 )
(clear d1)
(on d2 d3)
(clear d2)
(on d3 d4)
(on d4 d5)
(on d5 peg2 )
(clear peg3)   
)

  (:goal (and 
(on d1 d2)
(clear d1)
(on d2 d4)
(on d3 peg2 )
(clear d3)
(on d4 peg1 )
(on d5 peg3 )
(clear d5)  
  )
  )
  )

