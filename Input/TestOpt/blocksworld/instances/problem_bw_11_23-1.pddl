; Optimality lenght is (:optlen 20)



(define (problem BW-rand-11)
(:domain blocksworld-4ops)
(:objects b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 )
(:init
(arm-empty)
(on b1 b8)
(on-table b2)
(on b3 b11)
(on b4 b9)
(on-table b5)
(on b6 b1)
(on b7 b6)
(on b8 b4)
(on-table b9)
(on b10 b7)
(on-table b11)
(clear b2)
(clear b3)
(clear b5)
(clear b10)
)
(:goal
(and
(on b3 b8)
(on b5 b3)
(on b6 b1)
(on b8 b7)
(on b9 b2))
)
)
