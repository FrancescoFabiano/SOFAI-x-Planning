; Optimality lenght is (:optlen 3)

(define (problem problem_2_74)
  (:domain hanoi)
(:objects 
peg1 peg2 peg3 d1 d2 )
  (:init 
(smaller peg1 d1)
(smaller peg1 d2)
(smaller peg2 d1)
(smaller peg2 d2)
(smaller peg3 d1)
(smaller peg3 d2)
(smaller d2 d1)
(on d1 peg1 )
(clear d1)
(on d2 peg2 )
(clear d2)
(clear peg3)   
)

  (:goal (and 
(on d1 d2)
(clear d1)
(on d2 peg1 )
(clear peg2)
(clear peg3)  
  )
  )
  )

