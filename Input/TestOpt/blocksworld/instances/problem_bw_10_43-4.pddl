; Optimality lenght is (:optlen 22)



(define (problem BW-rand-10)
(:domain blocksworld-4ops)
(:objects b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 )
(:init
(arm-empty)
(on-table b1)
(on b2 b7)
(on-table b3)
(on b4 b10)
(on b5 b4)
(on-table b6)
(on b7 b3)
(on b8 b1)
(on b9 b2)
(on b10 b8)
(clear b5)
(clear b6)
(clear b9)
)
(:goal
(and
(on b1 b4)
(on b2 b3)
(on b5 b1)
(on b6 b8)
(on b7 b5))
)
)