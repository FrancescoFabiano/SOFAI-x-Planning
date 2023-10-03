; Optimality lenght is (:optlen 28)



(define (problem BW-rand-10)
(:domain blocksworld-4ops)
(:objects b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 )
(:init
(arm-empty)
(on b1 b2)
(on-table b2)
(on b3 b7)
(on b4 b10)
(on b5 b9)
(on b6 b8)
(on-table b7)
(on b8 b1)
(on b9 b3)
(on b10 b5)
(clear b4)
(clear b6)
)
(:goal
(and
(on b3 b9)
(on b4 b10)
(on b5 b6)
(on b6 b3)
(on b7 b1)
(on b8 b5)
(on b9 b2)
(on b10 b8))
)
)
