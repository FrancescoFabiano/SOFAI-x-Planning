; Optimality lenght is (:optlen 32)



(define (problem BW-rand-10)
(:domain blocksworld-4ops)
(:objects b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 )
(:init
(arm-empty)
(on b1 b2)
(on-table b2)
(on b3 b6)
(on b4 b3)
(on b5 b4)
(on b6 b10)
(on-table b7)
(on b8 b9)
(on b9 b5)
(on b10 b1)
(clear b7)
(clear b8)
)
(:goal
(and
(on b2 b8)
(on b3 b1)
(on b4 b10)
(on b5 b9)
(on b7 b3)
(on b8 b6)
(on b9 b7)
(on b10 b2))
)
)
