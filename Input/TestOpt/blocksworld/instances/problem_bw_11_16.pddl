; Optimality lenght is (:optlen 22)



(define (problem BW-rand-11)
(:domain blocksworld-4ops)
(:objects b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 )
(:init
(arm-empty)
(on-table b1)
(on b2 b6)
(on-table b3)
(on b4 b2)
(on b5 b4)
(on b6 b9)
(on-table b7)
(on b8 b7)
(on-table b9)
(on b10 b11)
(on b11 b5)
(clear b1)
(clear b3)
(clear b8)
(clear b10)
)
(:goal
(and
(on b1 b3)
(on b3 b2)
(on b4 b6)
(on b5 b9)
(on b8 b7)
(on b9 b1)
(on b11 b10))
)
)
