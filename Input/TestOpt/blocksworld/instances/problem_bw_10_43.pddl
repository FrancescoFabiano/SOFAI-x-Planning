; Optimality lenght is (:optlen 20)



(define (problem BW-rand-10)
(:domain blocksworld-4ops)
(:objects b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 )
(:init
(arm-empty)
(on-table b1)
(on-table b2)
(on b3 b1)
(on b4 b5)
(on b5 b6)
(on-table b6)
(on b7 b9)
(on b8 b2)
(on b9 b4)
(on-table b10)
(clear b3)
(clear b7)
(clear b8)
(clear b10)
)
(:goal
(and
(on b2 b4)
(on b3 b5)
(on b5 b6)
(on b6 b10)
(on b8 b3)
(on b10 b7))
)
)
