(define (problem problem_10_31)
(:domain blocksworld)
(:objects b1 b2 b3 b4 b5 b6 b7 b8 b9 b10)
(:init 
(handempty)
(on b1 b10)
(on b2 b3)
(clear b2)
(on b3 b6)
(on b4 b8)
(on b5 b7)
(on b6 b4)
(ontable b7)
(on b8 b1)
(on b9 b5)
(on b10 b9)
)
(:goal
(and
(on b1 b5)
(ontable b2)
(on b3 b9)
(on b4 b7)
(on b5 b8)
(on b6 b10)
(clear b6)
(on b7 b3)
(on b8 b2)
(on b9 b1)
(on b10 b4)

)

)
)