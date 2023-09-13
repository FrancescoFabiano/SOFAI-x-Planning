; Optimality lenght is (:optlen 22)



(define (problem BW-rand-11)
(:domain blocksworld-4ops)
(:objects b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 )
(:init
(arm-empty)
(on b1 b11)
(on-table b2)
(on b3 b1)
(on b4 b9)
(on b5 b8)
(on b6 b3)
(on-table b7)
(on b8 b2)
(on b9 b5)
(on b10 b4)
(on b11 b10)
(clear b6)
(clear b7)
)
(:goal
(and
(on b4 b9)
(on b6 b3)
(on b7 b1)
(on b9 b11)
(on b10 b6)
(on b11 b10))
)
)
