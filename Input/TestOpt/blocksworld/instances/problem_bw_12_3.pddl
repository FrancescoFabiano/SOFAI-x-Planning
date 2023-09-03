; Optimality lenght is (:optlen -1)



(define (problem BW-rand-12)
(:domain blocksworld-4ops)
(:objects b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 )
(:init
(arm-empty)
(on b1 b10)
(on b2 b7)
(on b3 b4)
(on b4 b9)
(on-table b5)
(on b6 b8)
(on-table b7)
(on b8 b2)
(on b9 b1)
(on b10 b11)
(on b11 b5)
(on b12 b6)
(clear b3)
(clear b12)
)
(:goal
(and
(on b4 b1)
(on b5 b11)
(on b8 b9)
(on b9 b2)
(on b11 b10)
(on b12 b6))
)
)
