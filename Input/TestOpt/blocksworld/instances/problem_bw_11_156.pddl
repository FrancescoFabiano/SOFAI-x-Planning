; Optimality lenght is (:optlen 28)



(define (problem BW-rand-11)
(:domain blocksworld-4ops)
(:objects b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 )
(:init
(arm-empty)
(on b1 b2)
(on b2 b9)
(on-table b3)
(on b4 b7)
(on b5 b8)
(on b6 b3)
(on b7 b5)
(on b8 b10)
(on b9 b4)
(on b10 b11)
(on b11 b6)
(clear b1)
)
(:goal
(and
(on b1 b4)
(on b3 b10)
(on b4 b11)
(on b7 b8)
(on b8 b9)
(on b10 b5))
)
)
