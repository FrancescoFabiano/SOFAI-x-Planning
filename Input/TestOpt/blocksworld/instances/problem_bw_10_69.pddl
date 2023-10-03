; Optimality lenght is (:optlen 20)



(define (problem BW-rand-10)
(:domain blocksworld-4ops)
(:objects b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 )
(:init
(arm-empty)
(on b1 b10)
(on b2 b8)
(on b3 b9)
(on b4 b6)
(on b5 b2)
(on-table b6)
(on b7 b5)
(on-table b8)
(on-table b9)
(on-table b10)
(clear b1)
(clear b3)
(clear b4)
(clear b7)
)
(:goal
(and
(on b1 b10)
(on b5 b9)
(on b6 b7)
(on b7 b5)
(on b9 b1)
(on b10 b3))
)
)
