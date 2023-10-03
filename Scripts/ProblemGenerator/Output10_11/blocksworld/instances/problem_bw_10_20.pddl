; Optimality lenght is (:optlen 26)



(define (problem BW-rand-10)
(:domain blocksworld-4ops)
(:objects b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 )
(:init
(arm-empty)
(on-table b1)
(on b2 b1)
(on b3 b2)
(on b4 b9)
(on b5 b6)
(on b6 b3)
(on-table b7)
(on b8 b7)
(on b9 b10)
(on b10 b8)
(clear b4)
(clear b5)
)
(:goal
(and
(on b1 b8)
(on b4 b7)
(on b5 b3)
(on b6 b5)
(on b8 b2)
(on b9 b1)
(on b10 b6))
)
)
