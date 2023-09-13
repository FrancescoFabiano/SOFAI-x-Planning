; Optimality lenght is (:optlen 18)



(define (problem BW-rand-10)
(:domain blocksworld-4ops)
(:objects b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 )
(:init
(arm-empty)
(on-table b1)
(on-table b2)
(on b3 b8)
(on-table b4)
(on b5 b4)
(on b6 b1)
(on b7 b10)
(on b8 b6)
(on-table b9)
(on b10 b3)
(clear b2)
(clear b5)
(clear b7)
(clear b9)
)
(:goal
(and
(on b1 b8)
(on b7 b3)
(on b8 b5)
(on b9 b7)
(on b10 b9))
)
)
