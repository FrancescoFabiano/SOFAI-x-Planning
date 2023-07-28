(define (problem problem_5_5)
(:domain blocksworld)
(:objects b1 b2 b3 b4 b5)
(:init 
(handempty)
(ontable b1)
(on b2 b4)
(on b3 b2)
(clear b3)
(on b4 b5)
(on b5 b1)
)
(:goal
(and
(on b1 b2)
(clear b1)
(ontable b2)
(ontable b3)
(clear b3)
(ontable b4)
(clear b4)
(ontable b5)
(clear b5)

)

)
)