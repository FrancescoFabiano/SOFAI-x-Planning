(define (problem problem_6_5)
(:domain blocksworld)
(:objects b1 b2 b3 b4 b5 b6)
(:init 
(handempty)
(on b1 b6)
(ontable b2)
(on b3 b4)
(on b4 b1)
(on b5 b3)
(clear b5)
(on b6 b2)
)
(:goal
(and
(on b1 b5)
(on b2 b1)
(clear b2)
(on b3 b4)
(ontable b4)
(ontable b5)
(on b6 b3)
(clear b6)

)

)
)