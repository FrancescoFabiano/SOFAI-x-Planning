; Optimality lenght is (:optlen 24)



(define (problem BW-rand-10)
(:domain blocksworld-4ops)
(:objects b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 )
(:init
(arm-empty)
(on b1 b6)
(on-table b2)
(on b3 b9)
(on b4 b2)
(on b5 b10)
(on-table b6)
(on b7 b4)
(on b8 b5)
(on b9 b1)
(on b10 b3)
(clear b7)
(clear b8)
)
(:goal
(and
(on b2 b6)
(on b4 b9)
(on b5 b1)
(on b8 b2)
(on b9 b10)
(on b10 b3))
)
)
