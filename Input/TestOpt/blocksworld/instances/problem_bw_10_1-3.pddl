; Optimality lenght is (:optlen 26)



(define (problem BW-rand-10)
(:domain blocksworld-4ops)
(:objects b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 )
(:init
(arm-empty)
(on b1 b6)
(on b2 b1)
(on b3 b5)
(on b4 b10)
(on-table b5)
(on b6 b4)
(on-table b7)
(on b8 b2)
(on b9 b3)
(on b10 b9)
(clear b7)
(clear b8)
)
(:goal
(and
(on b2 b4)
(on b4 b7)
(on b5 b3)
(on b6 b2)
(on b8 b10)
(on b9 b1)
(on b10 b5))
)
)
