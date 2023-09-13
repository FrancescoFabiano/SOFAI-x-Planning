; Optimality lenght is (:optlen 22)



(define (problem BW-rand-10)
(:domain blocksworld-4ops)
(:objects b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 )
(:init
(arm-empty)
(on b1 b6)
(on b2 b8)
(on-table b3)
(on b4 b10)
(on b5 b9)
(on b6 b5)
(on-table b7)
(on-table b8)
(on b9 b4)
(on b10 b7)
(clear b1)
(clear b2)
(clear b3)
)
(:goal
(and
(on b2 b6)
(on b3 b2)
(on b5 b10)
(on b6 b1)
(on b7 b3)
(on b9 b7)
(on b10 b4))
)
)
