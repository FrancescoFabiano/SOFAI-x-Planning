; Optimality lenght is (:optlen 22)



(define (problem BW-rand-10)
(:domain blocksworld-4ops)
(:objects b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 )
(:init
(arm-empty)
(on-table b1)
(on b2 b6)
(on b3 b4)
(on b4 b2)
(on-table b5)
(on b6 b5)
(on-table b7)
(on b8 b10)
(on b9 b1)
(on b10 b9)
(clear b3)
(clear b7)
(clear b8)
)
(:goal
(and
(on b2 b4)
(on b3 b10)
(on b5 b2)
(on b6 b5)
(on b7 b6)
(on b8 b1)
(on b9 b3))
)
)
