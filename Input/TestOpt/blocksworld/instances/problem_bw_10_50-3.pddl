; Optimality lenght is (:optlen 16)



(define (problem BW-rand-10)
(:domain blocksworld-4ops)
(:objects b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 )
(:init
(arm-empty)
(on-table b1)
(on b2 b7)
(on b3 b6)
(on-table b4)
(on-table b5)
(on-table b6)
(on b7 b8)
(on b8 b3)
(on-table b9)
(on b10 b4)
(clear b1)
(clear b2)
(clear b5)
(clear b9)
(clear b10)
)
(:goal
(and
(on b2 b1)
(on b3 b10)
(on b4 b8)
(on b6 b7)
(on b8 b5)
(on b9 b6)
(on b10 b2))
)
)