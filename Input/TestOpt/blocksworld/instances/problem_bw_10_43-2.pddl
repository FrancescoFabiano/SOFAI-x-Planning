; Optimality lenght is (:optlen 24)



(define (problem BW-rand-10)
(:domain blocksworld-4ops)
(:objects b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 )
(:init
(arm-empty)
(on-table b1)
(on b2 b6)
(on-table b3)
(on b4 b7)
(on b5 b8)
(on b6 b5)
(on b7 b10)
(on-table b8)
(on b9 b1)
(on b10 b3)
(clear b2)
(clear b4)
(clear b9)
)
(:goal
(and
(on b4 b9)
(on b5 b2)
(on b6 b7)
(on b7 b4)
(on b8 b3)
(on b9 b10)
(on b10 b8))
)
)
