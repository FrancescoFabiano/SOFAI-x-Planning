; Optimality lenght is (:optlen 30)



(define (problem BW-rand-10)
(:domain blocksworld-4ops)
(:objects b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 )
(:init
(arm-empty)
(on b1 b7)
(on-table b2)
(on b3 b9)
(on b4 b8)
(on b5 b3)
(on b6 b1)
(on-table b7)
(on b8 b2)
(on b9 b10)
(on b10 b4)
(clear b5)
(clear b6)
)
(:goal
(and
(on b1 b9)
(on b2 b6)
(on b3 b8)
(on b4 b2)
(on b5 b3)
(on b7 b4)
(on b8 b7)
(on b10 b5))
)
)
