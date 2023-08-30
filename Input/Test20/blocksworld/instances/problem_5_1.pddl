(define (problem problem_5_1)
(:domain blocksworld)
(:objects b1 b2 b3 b4 b5)
(:init 
(handempty)
(on b1 b3)
(on b2 b1)
(on b3 b5)
(on b4 b2)
(clear b4)
(ontable b5)
)
(:goal
(and
(on b1 b3)
(on b2 b1)
(clear b2)
(on b3 b5)
(ontable b4)
(clear b4)
(ontable b5)

)

)
)