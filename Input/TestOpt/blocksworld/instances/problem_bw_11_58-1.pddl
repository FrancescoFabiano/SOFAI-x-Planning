; Optimality lenght is (:optlen 22)



(define (problem BW-rand-11)
(:domain blocksworld-4ops)
(:objects b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 )
(:init
(arm-empty)
(on b1 b2)
(on b2 b5)
(on b3 b10)
(on-table b4)
(on b5 b4)
(on b6 b9)
(on b7 b8)
(on-table b8)
(on b9 b3)
(on b10 b7)
(on b11 b6)
(clear b1)
(clear b11)
)
(:goal
(and
(on b1 b11)
(on b2 b6)
(on b4 b1)
(on b5 b7)
(on b7 b10)
(on b10 b4))
)
)
