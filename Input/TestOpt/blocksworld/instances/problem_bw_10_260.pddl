; Optimality lenght is (:optlen 26)



(define (problem BW-rand-10)
(:domain blocksworld-4ops)
(:objects b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 )
(:init
(arm-empty)
(on b1 b3)
(on-table b2)
(on b3 b8)
(on b4 b10)
(on b5 b1)
(on b6 b5)
(on b7 b2)
(on b8 b7)
(on b9 b6)
(on b10 b9)
(clear b4)
)
(:goal
(and
(on b1 b3)
(on b2 b9)
(on b3 b10)
(on b4 b5)
(on b7 b6)
(on b8 b4)
(on b9 b8))
)
)
