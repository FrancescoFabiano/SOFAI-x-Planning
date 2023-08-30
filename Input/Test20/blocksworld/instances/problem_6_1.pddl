(define (problem problem_6_1)
(:domain blocksworld)
(:objects b1 b2 b3 b4 b5 b6)
(:init 
(handempty)
(on b1 b2)
(clear b1)
(on b2 b4)
(on b3 b5)
(on b4 b3)
(on b5 b6)
(ontable b6)
)
(:goal
(and
(ontable b1)
(clear b1)
(ontable b2)
(on b3 b4)
(clear b3)
(on b4 b5)
(on b5 b2)
(ontable b6)
(clear b6)

)

)
)