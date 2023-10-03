; Optimality lenght is (:optlen 30)



(define (problem BW-rand-10)
(:domain blocksworld-4ops)
(:objects b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 )
(:init
(arm-empty)
(on b1 b7)
(on b2 b9)
(on-table b3)
(on-table b4)
(on b5 b1)
(on b6 b10)
(on b7 b3)
(on b8 b5)
(on b9 b6)
(on b10 b8)
(clear b2)
(clear b4)
)
(:goal
(and
(on b1 b3)
(on b2 b6)
(on b3 b8)
(on b4 b2)
(on b5 b7)
(on b8 b5)
(on b9 b1)
(on b10 b4))
)
)
