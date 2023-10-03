; Optimality lenght is (:optlen 22)



(define (problem BW-rand-10)
(:domain blocksworld-4ops)
(:objects b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 )
(:init
(arm-empty)
(on b1 b3)
(on b2 b9)
(on b3 b7)
(on b4 b8)
(on-table b5)
(on b6 b2)
(on b7 b5)
(on b8 b6)
(on-table b9)
(on-table b10)
(clear b1)
(clear b4)
(clear b10)
)
(:goal
(and
(on b2 b9)
(on b5 b8)
(on b7 b1)
(on b9 b10)
(on b10 b5))
)
)
