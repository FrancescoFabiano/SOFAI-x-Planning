; Optimality lenght is (:optlen 20)



(define (problem BW-rand-10)
(:domain blocksworld-4ops)
(:objects b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 )
(:init
(arm-empty)
(on b1 b3)
(on b2 b5)
(on-table b3)
(on-table b4)
(on b5 b6)
(on b6 b7)
(on-table b7)
(on b8 b1)
(on b9 b8)
(on b10 b2)
(clear b4)
(clear b9)
(clear b10)
)
(:goal
(and
(on b4 b9)
(on b7 b1)
(on b8 b6)
(on b10 b3))
)
)
