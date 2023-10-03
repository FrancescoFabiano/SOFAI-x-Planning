; Optimality lenght is (:optlen 22)



(define (problem BW-rand-11)
(:domain blocksworld-4ops)
(:objects b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 )
(:init
(arm-empty)
(on b1 b9)
(on-table b2)
(on b3 b1)
(on b4 b5)
(on b5 b10)
(on-table b6)
(on b7 b8)
(on b8 b4)
(on b9 b2)
(on b10 b11)
(on b11 b6)
(clear b3)
(clear b7)
)
(:goal
(and
(on b2 b5)
(on b5 b4)
(on b7 b8)
(on b9 b3)
(on b11 b2))
)
)
