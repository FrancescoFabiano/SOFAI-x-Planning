(define (problem problem_3_12)
  (:domain hanoi)
(:objects peg1 peg2 peg3 d1 d2 d3)
  (:init 
(smaller peg1 d1)
(smaller peg1 d2)
(smaller peg1 d3)
(smaller peg2 d1)
(smaller peg2 d2)
(smaller peg2 d3)
(smaller peg3 d1)
(smaller peg3 d2)
(smaller peg3 d3)
(smaller d2 d1)
(smaller d3 d1)
(smaller d3 d2)
(on d1 d2)
(clear d1)
(on d2 peg3 )
(on d3 peg1 )
(clear d3)
(clear peg2)   
   
)

  (:goal (and 
  
(on d1 d3)
(clear d1)
(on d2 peg2 )
(clear d2)
(on d3 peg3 )
(clear peg1)  
  )
  )
  )
