; Optimality lenght is (:optlen 22)



(define (problem BW-rand-10)
(:domain blocksworld-4ops)
(:objects b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 )
(:init
(arm-empty)
(on-table b1)
(on-table b2)
(on b3 b5)
(on b4 b7)
(on-table b5)
(on b6 b1)
(on b7 b6)
(on b8 b4)
(on b9 b10)
(on b10 b3)
(clear b2)
(clear b8)
(clear b9)
)
(:goal
(and
(on b3 b4)
(on b4 b5)
(on b5 b10)
(on b6 b9)
(on b7 b2)
(on b8 b6)
(on b9 b7))
)
)
