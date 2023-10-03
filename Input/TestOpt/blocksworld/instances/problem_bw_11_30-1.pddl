; Optimality lenght is (:optlen 28)



(define (problem BW-rand-11)
(:domain blocksworld-4ops)
(:objects b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 )
(:init
(arm-empty)
(on b1 b6)
(on b2 b1)
(on b3 b8)
(on b4 b5)
(on b5 b2)
(on b6 b3)
(on b7 b10)
(on b8 b7)
(on-table b9)
(on b10 b9)
(on b11 b4)
(clear b11)
)
(:goal
(and
(on b1 b9)
(on b2 b3)
(on b4 b7)
(on b6 b1)
(on b7 b2)
(on b10 b5))
)
)
