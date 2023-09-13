; Optimality lenght is (:optlen 20)



(define (problem BW-rand-10)
(:domain blocksworld-4ops)
(:objects b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 )
(:init
(arm-empty)
(on-table b1)
(on b2 b4)
(on-table b3)
(on b4 b8)
(on b5 b9)
(on b6 b10)
(on b7 b6)
(on-table b8)
(on b9 b3)
(on b10 b1)
(clear b2)
(clear b5)
(clear b7)
)
(:goal
(and
(on b2 b3)
(on b6 b8)
(on b7 b6)
(on b8 b1)
(on b10 b2))
)
)
