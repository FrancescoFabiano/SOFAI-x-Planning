; Optimality lenght is (:optlen 20)



(define (problem BW-rand-10)
(:domain blocksworld-4ops)
(:objects b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 )
(:init
(arm-empty)
(on b1 b6)
(on b2 b9)
(on b3 b8)
(on-table b4)
(on-table b5)
(on b6 b5)
(on-table b7)
(on b8 b7)
(on b9 b1)
(on b10 b3)
(clear b2)
(clear b4)
(clear b10)
)
(:goal
(and
(on b3 b9)
(on b4 b10)
(on b6 b5)
(on b7 b8)
(on b8 b3)
(on b9 b6)
(on b10 b7))
)
)
