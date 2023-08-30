(define (problem problem_5_3)
(:domain blocksworld)
(:objects b1 b2 b3 b4 b5)
(:init 
(handempty)
(on b1 b5)
(on b2 b4)
(on b3 b1)
(clear b3)
(ontable b4)
(on b5 b2)
)
(:goal
(and
(ontable b1)
(ontable b2)
(clear b2)
(on b3 b1)
(on b4 b3)
(on b5 b4)
(clear b5)

)

)
)