; Optimality lenght is (:optlen 26)



(define (problem BW-rand-11)
(:domain blocksworld-4ops)
(:objects b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 )
(:init
(arm-empty)
(on b1 b9)
(on b2 b5)
(on b3 b6)
(on-table b4)
(on b5 b10)
(on-table b6)
(on b7 b2)
(on b8 b11)
(on b9 b7)
(on b10 b3)
(on b11 b4)
(clear b1)
(clear b8)
)
(:goal
(and
(on b2 b6)
(on b3 b11)
(on b5 b8)
(on b6 b3)
(on b8 b4)
(on b9 b2)
(on b10 b1))
)
)
