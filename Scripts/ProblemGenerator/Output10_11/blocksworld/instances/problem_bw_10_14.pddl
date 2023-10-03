; Optimality lenght is (:optlen 16)



(define (problem BW-rand-10)
(:domain blocksworld-4ops)
(:objects b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 )
(:init
(arm-empty)
(on-table b1)
(on b2 b10)
(on b3 b5)
(on-table b4)
(on b5 b7)
(on b6 b3)
(on-table b7)
(on-table b8)
(on b9 b1)
(on-table b10)
(clear b2)
(clear b4)
(clear b6)
(clear b8)
(clear b9)
)
(:goal
(and
(on b3 b1)
(on b5 b2)
(on b7 b9)
(on b9 b5)
(on b10 b4))
)
)
