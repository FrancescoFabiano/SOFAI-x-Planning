(define (problem problem_7_4)
(:domain blocksworld)
(:objects b1 b2 b3 b4 b5 b6 b7)
(:init 
(handempty)
(on b1 b6)
(clear b1)
(ontable b2)
(ontable b3)
(clear b3)
(on b4 b5)
(on b5 b2)
(on b6 b7)
(on b7 b4)
)
(:goal
(and
(on b1 b2)
(on b2 b3)
(on b3 b7)
(ontable b4)
(on b5 b1)
(clear b5)
(on b6 b4)
(clear b6)
(ontable b7)

)

)
)