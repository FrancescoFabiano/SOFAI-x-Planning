(define (problem problem_4_2)
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
(on b1 b2)
(ontable b2)
(on b3 b1)
(on b4 b3)
(clear b4)

)

)
)