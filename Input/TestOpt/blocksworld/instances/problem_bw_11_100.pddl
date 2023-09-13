; Optimality lenght is (:optlen 24)



(define (problem BW-rand-11)
(:domain blocksworld-4ops)
(:objects b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 )
(:init
(arm-empty)
(on b1 b3)
(on b2 b9)
(on b3 b8)
(on b4 b1)
(on b5 b7)
(on b6 b5)
(on b7 b2)
(on b8 b11)
(on b9 b10)
(on-table b10)
(on-table b11)
(clear b4)
(clear b6)
)
(:goal
(and
(on b3 b11)
(on b5 b1)
(on b6 b4)
(on b7 b8)
(on b8 b5)
(on b10 b6)
(on b11 b9))
)
)
