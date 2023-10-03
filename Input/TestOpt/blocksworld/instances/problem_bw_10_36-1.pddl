; Optimality lenght is (:optlen 24)



(define (problem BW-rand-10)
(:domain blocksworld-4ops)
(:objects b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 )
(:init
(arm-empty)
(on b1 b8)
(on b2 b9)
(on b3 b6)
(on-table b4)
(on b5 b10)
(on b6 b5)
(on b7 b2)
(on b8 b4)
(on b9 b3)
(on-table b10)
(clear b1)
(clear b7)
)
(:goal
(and
(on b1 b5)
(on b3 b2)
(on b4 b1)
(on b5 b7)
(on b6 b9)
(on b7 b3)
(on b8 b10)
(on b9 b8))
)
)
