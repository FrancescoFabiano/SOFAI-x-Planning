(define (problem problem_4_3)
(:domain blocksworld)
(:objects b1 b2 b3 b4)
(:init 
(handempty)
(on b1 b3)
(on b2 b4)
(clear b2)
(ontable b3)
(on b4 b1)
)
(:goal
(and
(ontable b1)
(on b2 b3)
(clear b2)
(ontable b3)
(on b4 b1)
(clear b4)

)

)
)