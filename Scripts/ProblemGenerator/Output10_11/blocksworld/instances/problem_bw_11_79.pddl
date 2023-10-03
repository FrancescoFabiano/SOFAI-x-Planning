; Optimality lenght is (:optlen 28)



(define (problem BW-rand-11)
(:domain blocksworld-4ops)
(:objects b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 )
(:init
(arm-empty)
(on b1 b7)
(on b2 b10)
(on b3 b4)
(on b4 b8)
(on b5 b1)
(on-table b6)
(on b7 b9)
(on-table b8)
(on b9 b3)
(on b10 b5)
(on b11 b2)
(clear b6)
(clear b11)
)
(:goal
(and
(on b2 b9)
(on b4 b7)
(on b6 b10)
(on b8 b5)
(on b9 b1)
(on b10 b4)
(on b11 b3))
)
)
