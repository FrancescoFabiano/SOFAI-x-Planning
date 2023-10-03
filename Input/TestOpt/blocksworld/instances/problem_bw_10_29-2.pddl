; Optimality lenght is (:optlen 24)



(define (problem BW-rand-10)
(:domain blocksworld-4ops)
(:objects b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 )
(:init
(arm-empty)
(on b1 b9)
(on-table b2)
(on b3 b8)
(on-table b4)
(on b5 b2)
(on b6 b10)
(on b7 b1)
(on b8 b5)
(on b9 b4)
(on b10 b3)
(clear b6)
(clear b7)
)
(:goal
(and
(on b1 b3)
(on b2 b4)
(on b4 b8)
(on b5 b10)
(on b6 b5)
(on b7 b1)
(on b8 b7)
(on b9 b6))
)
)
