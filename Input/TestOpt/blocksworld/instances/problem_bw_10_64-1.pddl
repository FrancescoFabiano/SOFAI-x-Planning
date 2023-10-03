; Optimality lenght is (:optlen 24)



(define (problem BW-rand-10)
(:domain blocksworld-4ops)
(:objects b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 )
(:init
(arm-empty)
(on b1 b9)
(on b2 b6)
(on b3 b7)
(on b4 b2)
(on-table b5)
(on b6 b8)
(on-table b7)
(on b8 b10)
(on b9 b3)
(on-table b10)
(clear b1)
(clear b4)
(clear b5)
)
(:goal
(and
(on b2 b6)
(on b4 b10)
(on b5 b1)
(on b6 b7)
(on b9 b8)
(on b10 b2))
)
)
