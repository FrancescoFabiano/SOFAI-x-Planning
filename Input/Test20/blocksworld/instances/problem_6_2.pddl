(define (problem problem_6_2)
(:domain blocksworld)
(:objects b1 b2 b3 b4 b5 b6)
(:init 
(handempty)
(ontable b1)
(on b2 b4)
(ontable b3)
(clear b3)
(on b4 b5)
(on b5 b1)
(on b6 b2)
(clear b6)
)
(:goal
(and
(ontable b1)
(on b2 b3)
(on b3 b4)
(on b4 b1)
(ontable b5)
(clear b5)
(on b6 b2)
(clear b6)

)

)
)