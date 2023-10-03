; Optimality lenght is (:optlen 20)



(define (problem BW-rand-10)
(:domain blocksworld-4ops)
(:objects b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 )
(:init
(arm-empty)
(on b1 b3)
(on-table b2)
(on b3 b10)
(on b4 b7)
(on b5 b4)
(on-table b6)
(on b7 b1)
(on b8 b2)
(on-table b9)
(on b10 b6)
(clear b5)
(clear b8)
(clear b9)
)
(:goal
(and
(on b2 b10)
(on b3 b9)
(on b4 b1)
(on b5 b8)
(on b8 b7)
(on b9 b5)
(on b10 b6))
)
)
