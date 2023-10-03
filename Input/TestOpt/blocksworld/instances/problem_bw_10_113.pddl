; Optimality lenght is (:optlen 26)



(define (problem BW-rand-10)
(:domain blocksworld-4ops)
(:objects b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 )
(:init
(arm-empty)
(on b1 b9)
(on b2 b3)
(on-table b3)
(on b4 b7)
(on b5 b6)
(on b6 b8)
(on b7 b5)
(on b8 b1)
(on-table b9)
(on b10 b4)
(clear b2)
(clear b10)
)
(:goal
(and
(on b1 b4)
(on b2 b5)
(on b3 b10)
(on b5 b8)
(on b6 b3)
(on b7 b6)
(on b8 b7)
(on b9 b1))
)
)
