; Optimality lenght is (:optlen 22)



(define (problem BW-rand-10)
(:domain blocksworld-4ops)
(:objects b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 )
(:init
(arm-empty)
(on b1 b7)
(on b2 b9)
(on-table b3)
(on b4 b10)
(on b5 b4)
(on b6 b5)
(on-table b7)
(on b8 b1)
(on b9 b8)
(on b10 b2)
(clear b3)
(clear b6)
)
(:goal
(and
(on b2 b10)
(on b3 b7)
(on b5 b1)
(on b6 b8)
(on b10 b4))
)
)
