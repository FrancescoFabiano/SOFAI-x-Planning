; Optimality lenght is (:optlen -1)



(define (problem BW-rand-10)
(:domain blocksworld-4ops)
(:objects b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 )
(:init
(arm-empty)
(on b1 b6)
(on b2 b3)
(on b3 b5)
(on b4 b2)
(on b5 b10)
(on-table b6)
(on-table b7)
(on-table b8)
(on b9 b8)
(on b10 b9)
(clear b1)
(clear b4)
(clear b7)
)
(:goal
(and
(on b2 b9)
(on b4 b3)
(on b5 b4)
(on b7 b5)
(on b9 b6)
(on b10 b8))
)
)
