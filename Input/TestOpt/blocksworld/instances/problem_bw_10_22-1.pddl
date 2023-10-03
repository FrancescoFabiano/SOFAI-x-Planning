; Optimality lenght is (:optlen 28)



(define (problem BW-rand-10)
(:domain blocksworld-4ops)
(:objects b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 )
(:init
(arm-empty)
(on-table b1)
(on-table b2)
(on b3 b1)
(on b4 b2)
(on b5 b3)
(on b6 b9)
(on b7 b10)
(on b8 b7)
(on b9 b4)
(on b10 b5)
(clear b6)
(clear b8)
)
(:goal
(and
(on b1 b2)
(on b3 b1)
(on b4 b8)
(on b5 b3)
(on b6 b10)
(on b8 b7)
(on b9 b6)
(on b10 b4))
)
)
