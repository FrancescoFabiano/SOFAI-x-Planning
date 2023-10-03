; Optimality lenght is (:optlen 28)



(define (problem BW-rand-10)
(:domain blocksworld-4ops)
(:objects b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 )
(:init
(arm-empty)
(on-table b1)
(on-table b2)
(on b3 b2)
(on b4 b6)
(on b5 b9)
(on b6 b1)
(on b7 b8)
(on b8 b10)
(on b9 b4)
(on b10 b3)
(clear b5)
(clear b7)
)
(:goal
(and
(on b1 b8)
(on b2 b7)
(on b3 b6)
(on b5 b9)
(on b7 b5)
(on b8 b2)
(on b9 b4)
(on b10 b3))
)
)
