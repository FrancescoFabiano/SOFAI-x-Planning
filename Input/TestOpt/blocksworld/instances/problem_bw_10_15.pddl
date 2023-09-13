; Optimality lenght is (:optlen 10)



(define (problem BW-rand-10)
(:domain blocksworld-4ops)
(:objects b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 )
(:init
(arm-empty)
(on-table b1)
(on-table b2)
(on-table b3)
(on-table b4)
(on b5 b10)
(on b6 b5)
(on b7 b2)
(on b8 b1)
(on b9 b3)
(on-table b10)
(clear b4)
(clear b6)
(clear b7)
(clear b8)
(clear b9)
)
(:goal
(and
(on b5 b9)
(on b6 b8)
(on b7 b5)
(on b9 b1))
)
)
