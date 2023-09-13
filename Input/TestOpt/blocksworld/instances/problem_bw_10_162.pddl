; Optimality lenght is (:optlen 26)



(define (problem BW-rand-10)
(:domain blocksworld-4ops)
(:objects b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 )
(:init
(arm-empty)
(on b1 b8)
(on b2 b5)
(on-table b3)
(on-table b4)
(on b5 b3)
(on-table b6)
(on b7 b9)
(on b8 b2)
(on b9 b1)
(on b10 b7)
(clear b4)
(clear b6)
(clear b10)
)
(:goal
(and
(on b3 b6)
(on b5 b9)
(on b6 b8)
(on b7 b10)
(on b8 b1)
(on b9 b3)
(on b10 b5))
)
)
