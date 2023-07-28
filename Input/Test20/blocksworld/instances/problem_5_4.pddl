(define (problem problem_5_4)
(:domain blocksworld)
(:objects b1 b2 b3 b4 b5)
(:init 
(handempty)
(on b1 b2)
(clear b1)
(on b2 b4)
(ontable b3)
(clear b3)
(ontable b4)
(ontable b5)
(clear b5)
)
(:goal
(and
(ontable b1)
(on b2 b3)
(on b3 b1)
(on b4 b5)
(clear b4)
(on b5 b2)

)

)
)