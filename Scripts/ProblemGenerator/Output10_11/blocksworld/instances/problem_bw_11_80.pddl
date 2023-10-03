; Optimality lenght is (:optlen 22)



(define (problem BW-rand-11)
(:domain blocksworld-4ops)
(:objects b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 )
(:init
(arm-empty)
(on b1 b3)
(on b2 b6)
(on b3 b2)
(on b4 b8)
(on-table b5)
(on-table b6)
(on b7 b11)
(on b8 b7)
(on b9 b1)
(on-table b10)
(on b11 b5)
(clear b4)
(clear b9)
(clear b10)
)
(:goal
(and
(on b2 b11)
(on b3 b9)
(on b4 b3)
(on b5 b8)
(on b7 b6)
(on b10 b5))
)
)
