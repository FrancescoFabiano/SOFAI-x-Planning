; Optimality lenght is (:optlen 28)



(define (problem BW-rand-10)
(:domain blocksworld-4ops)
(:objects b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 )
(:init
(arm-empty)
(on b1 b4)
(on-table b2)
(on b3 b7)
(on b4 b5)
(on-table b5)
(on b6 b10)
(on b7 b1)
(on b8 b2)
(on b9 b8)
(on-table b10)
(clear b3)
(clear b6)
(clear b9)
)
(:goal
(and
(on b1 b3)
(on b2 b7)
(on b3 b5)
(on b6 b2)
(on b7 b9)
(on b8 b1)
(on b9 b10)
(on b10 b8))
)
)
