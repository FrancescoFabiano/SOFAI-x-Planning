; Optimality lenght is (:optlen 26)



(define (problem BW-rand-10)
(:domain blocksworld-4ops)
(:objects b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 )
(:init
(arm-empty)
(on b1 b6)
(on b2 b10)
(on b3 b9)
(on b4 b7)
(on b5 b8)
(on-table b6)
(on b7 b3)
(on-table b8)
(on b9 b2)
(on b10 b5)
(clear b1)
(clear b4)
)
(:goal
(and
(on b2 b7)
(on b3 b5)
(on b4 b2)
(on b5 b4)
(on b6 b1)
(on b9 b8)
(on b10 b9))
)
)
