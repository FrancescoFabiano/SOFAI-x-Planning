; Optimality lenght is (:optlen 24)



(define (problem BW-rand-10)
(:domain blocksworld-4ops)
(:objects b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 )
(:init
(arm-empty)
(on b1 b5)
(on-table b2)
(on-table b3)
(on b4 b8)
(on b5 b10)
(on b6 b2)
(on-table b7)
(on b8 b7)
(on b9 b3)
(on b10 b6)
(clear b1)
(clear b4)
(clear b9)
)
(:goal
(and
(on b3 b2)
(on b4 b8)
(on b5 b4)
(on b6 b3)
(on b7 b9)
(on b8 b10)
(on b9 b1))
)
)
