(define (problem problem_6_4)
(:domain blocksworld)
(:objects b1 b2 b3 b4 b5 b6)
(:init 
(handempty)
(on b1 b5)
(on b2 b1)
(clear b2)
(on b3 b4)
(clear b3)
(on b4 b6)
(ontable b5)
(ontable b6)
)
(:goal
(and
(on b1 b5)
(on b2 b1)
(clear b2)
(on b3 b4)
(clear b3)
(ontable b4)
(ontable b5)
(ontable b6)
(clear b6)

)

)
)