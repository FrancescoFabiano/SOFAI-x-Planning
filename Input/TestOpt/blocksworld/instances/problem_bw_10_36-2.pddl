; Optimality lenght is (:optlen 28)



(define (problem BW-rand-10)
(:domain blocksworld-4ops)
(:objects b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 )
(:init
(arm-empty)
(on-table b1)
(on b2 b4)
(on b3 b6)
(on b4 b5)
(on b5 b1)
(on b6 b8)
(on-table b7)
(on-table b8)
(on b9 b7)
(on b10 b3)
(clear b2)
(clear b9)
(clear b10)
)
(:goal
(and
(on b1 b8)
(on b2 b10)
(on b3 b2)
(on b4 b1)
(on b6 b4)
(on b7 b3)
(on b10 b6))
)
)
