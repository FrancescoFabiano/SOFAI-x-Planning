; Optimality lenght is (:optlen 20)



(define (problem BW-rand-11)
(:domain blocksworld-4ops)
(:objects b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 )
(:init
(arm-empty)
(on-table b1)
(on-table b2)
(on b3 b4)
(on b4 b7)
(on b5 b1)
(on-table b6)
(on b7 b8)
(on b8 b11)
(on-table b9)
(on b10 b3)
(on b11 b9)
(clear b2)
(clear b5)
(clear b6)
(clear b10)
)
(:goal
(and
(on b4 b10)
(on b5 b1)
(on b6 b4)
(on b7 b3)
(on b8 b6)
(on b10 b11)
(on b11 b2))
)
)
