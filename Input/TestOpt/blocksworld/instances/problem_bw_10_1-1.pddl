; Optimality lenght is (:optlen 18)



(define (problem BW-rand-10)
(:domain blocksworld-4ops)
(:objects b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 )
(:init
(arm-empty)
(on b1 b7)
(on-table b2)
(on b3 b4)
(on b4 b1)
(on b5 b6)
(on-table b6)
(on-table b7)
(on b8 b5)
(on-table b9)
(on b10 b9)
(clear b2)
(clear b3)
(clear b8)
(clear b10)
)
(:goal
(and
(on b1 b10)
(on b2 b9)
(on b3 b2)
(on b4 b5)
(on b5 b6)
(on b6 b8))
)
)
