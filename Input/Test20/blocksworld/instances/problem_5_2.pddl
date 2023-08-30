(define (problem problem_5_2)
(:domain blocksworld)
(:objects b1 b2 b3 b4 b5)
(:init 
(handempty)
(on b1 b3)
(on b2 b5)
(on b3 b2)
(on b4 b1)
(clear b4)
(ontable b5)
)
(:goal
(and
(on b1 b5)
(clear b1)
(ontable b2)
(ontable b3)
(clear b3)
(on b4 b2)
(clear b4)
(ontable b5)

)

)
)