; Optimality lenght is (:optlen 22)



(define (problem BW-rand-10)
(:domain blocksworld-4ops)
(:objects b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 )
(:init
(arm-empty)
(on b1 b5)
(on b2 b8)
(on-table b3)
(on b4 b9)
(on b5 b3)
(on b6 b4)
(on b7 b2)
(on b8 b1)
(on b9 b10)
(on-table b10)
(clear b6)
(clear b7)
)
(:goal
(and
(on b1 b7)
(on b2 b4)
(on b4 b5)
(on b7 b2)
(on b8 b6)
(on b9 b1)
(on b10 b8))
)
)
