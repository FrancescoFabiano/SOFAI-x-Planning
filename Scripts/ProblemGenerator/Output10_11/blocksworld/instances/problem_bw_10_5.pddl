; Optimality lenght is (:optlen 18)



(define (problem BW-rand-10)
(:domain blocksworld-4ops)
(:objects b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 )
(:init
(arm-empty)
(on b1 b7)
(on-table b2)
(on-table b3)
(on b4 b6)
(on b5 b3)
(on b6 b10)
(on-table b7)
(on-table b8)
(on-table b9)
(on b10 b9)
(clear b1)
(clear b2)
(clear b4)
(clear b5)
(clear b8)
)
(:goal
(and
(on b2 b1)
(on b3 b10)
(on b7 b9)
(on b9 b2)
(on b10 b6))
)
)
