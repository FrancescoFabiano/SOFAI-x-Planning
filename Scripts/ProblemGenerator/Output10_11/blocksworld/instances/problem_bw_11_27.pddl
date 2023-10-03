; Optimality lenght is (:optlen 22)



(define (problem BW-rand-11)
(:domain blocksworld-4ops)
(:objects b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 )
(:init
(arm-empty)
(on-table b1)
(on-table b2)
(on b3 b7)
(on b4 b5)
(on b5 b8)
(on b6 b11)
(on b7 b10)
(on b8 b1)
(on-table b9)
(on b10 b2)
(on b11 b9)
(clear b3)
(clear b4)
(clear b6)
)
(:goal
(and
(on b2 b3)
(on b3 b7)
(on b7 b5)
(on b9 b1)
(on b10 b6)
(on b11 b10))
)
)
