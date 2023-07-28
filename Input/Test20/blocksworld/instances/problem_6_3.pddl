(define (problem problem_6_3)
(:domain blocksworld)
(:objects b1 b2 b3 b4 b5 b6)
(:init 
(handempty)
(on b1 b4)
(ontable b2)
(ontable b3)
(clear b3)
(ontable b4)
(on b5 b2)
(clear b5)
(on b6 b1)
(clear b6)
)
(:goal
(and
(on b1 b6)
(on b2 b5)
(clear b2)
(ontable b3)
(on b4 b1)
(on b5 b4)
(on b6 b3)

)

)
)