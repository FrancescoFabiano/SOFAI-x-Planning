; Optimality lenght is (:optlen 18)



(define (problem BW-rand-10)
(:domain blocksworld-4ops)
(:objects b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 )
(:init
(arm-empty)
(on b1 b3)
(on b2 b9)
(on b3 b6)
(on-table b4)
(on-table b5)
(on b6 b4)
(on b7 b10)
(on b8 b7)
(on-table b9)
(on b10 b5)
(clear b1)
(clear b2)
(clear b8)
)
(:goal
(and
(on b1 b7)
(on b2 b4)
(on b6 b5)
(on b7 b2)
(on b8 b3)
(on b10 b9))
)
)
