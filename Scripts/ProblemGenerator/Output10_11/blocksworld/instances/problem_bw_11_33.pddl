; Optimality lenght is (:optlen 26)



(define (problem BW-rand-11)
(:domain blocksworld-4ops)
(:objects b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 )
(:init
(arm-empty)
(on b1 b8)
(on-table b2)
(on b3 b5)
(on b4 b2)
(on b5 b11)
(on b6 b3)
(on b7 b6)
(on b8 b7)
(on-table b9)
(on b10 b4)
(on b11 b10)
(clear b1)
(clear b9)
)
(:goal
(and
(on b3 b6)
(on b4 b7)
(on b6 b4)
(on b7 b1)
(on b8 b3)
(on b9 b2)
(on b10 b5))
)
)
