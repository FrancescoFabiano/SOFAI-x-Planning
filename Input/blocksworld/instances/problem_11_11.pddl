(define (problem problem_11_11)
(:domain blocksworld)
(:objects b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11)
(:init 
(handempty)
(ontable b1)
(on b2 b4)
(clear b2)
(on b3 b11)
(clear b3)
(ontable b4)
(ontable b5)
(on b6 b9)
(clear b6)
(on b7 b5)
(clear b7)
(ontable b8)
(clear b8)
(on b9 b1)
(ontable b10)
(clear b10)
(ontable b11)
)
(:goal
(and
(ontable b1)
(on b2 b1)
(on b3 b8)
(ontable b4)
(clear b4)
(on b5 b3)
(on b6 b7)
(on b7 b11)
(on b8 b6)
(on b9 b5)
(clear b9)
(ontable b10)
(clear b10)
(on b11 b2)

)

)
)