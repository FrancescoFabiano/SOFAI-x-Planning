; Optimality lenght is (:optlen 26)



(define (problem BW-rand-10)
(:domain blocksworld-4ops)
(:objects b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 )
(:init
(arm-empty)
(on b1 b7)
(on-table b2)
(on-table b3)
(on-table b4)
(on b5 b1)
(on b6 b3)
(on b7 b4)
(on b8 b2)
(on-table b9)
(on b10 b6)
(clear b5)
(clear b8)
(clear b9)
(clear b10)
)
(:goal
(and
(on b1 b4)
(on b2 b10)
(on b3 b7)
(on b4 b2)
(on b6 b9)
(on b9 b1)
(on b10 b3))
)
)
