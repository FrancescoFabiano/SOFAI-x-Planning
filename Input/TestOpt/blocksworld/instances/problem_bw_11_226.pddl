; Optimality lenght is (:optlen 18)



(define (problem BW-rand-11)
(:domain blocksworld-4ops)
(:objects b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 )
(:init
(arm-empty)
(on b1 b5)
(on-table b2)
(on b3 b11)
(on b4 b10)
(on b5 b8)
(on b6 b2)
(on b7 b4)
(on b8 b9)
(on b9 b7)
(on-table b10)
(on-table b11)
(clear b1)
(clear b3)
(clear b6)
)
(:goal
(and
(on b3 b1)
(on b4 b9)
(on b6 b5)
(on b7 b2)
(on b9 b3)
(on b10 b11))
)
)
