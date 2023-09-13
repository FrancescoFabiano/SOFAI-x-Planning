; Optimality lenght is (:optlen 24)



(define (problem BW-rand-10)
(:domain blocksworld-4ops)
(:objects b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 )
(:init
(arm-empty)
(on b1 b7)
(on b2 b9)
(on b3 b10)
(on b4 b1)
(on-table b5)
(on b6 b3)
(on b7 b2)
(on-table b8)
(on b9 b5)
(on b10 b8)
(clear b4)
(clear b6)
)
(:goal
(and
(on b2 b8)
(on b3 b5)
(on b4 b3)
(on b5 b9)
(on b6 b1)
(on b7 b4)
(on b9 b10))
)
)
