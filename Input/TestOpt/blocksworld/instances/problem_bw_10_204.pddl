; Optimality lenght is (:optlen 16)



(define (problem BW-rand-10)
(:domain blocksworld-4ops)
(:objects b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 )
(:init
(arm-empty)
(on-table b1)
(on b2 b9)
(on b3 b6)
(on-table b4)
(on-table b5)
(on b6 b1)
(on b7 b10)
(on b8 b4)
(on b9 b3)
(on-table b10)
(clear b2)
(clear b5)
(clear b7)
(clear b8)
)
(:goal
(and
(on b2 b6)
(on b4 b1)
(on b6 b7)
(on b7 b3)
(on b8 b2))
)
)
