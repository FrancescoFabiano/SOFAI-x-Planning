; Optimality lenght is (:optlen 20)



(define (problem BW-rand-11)
(:domain blocksworld-4ops)
(:objects b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 )
(:init
(arm-empty)
(on b1 b5)
(on-table b2)
(on b3 b6)
(on b4 b8)
(on-table b5)
(on b6 b10)
(on b7 b3)
(on b8 b1)
(on b9 b2)
(on b10 b11)
(on-table b11)
(clear b4)
(clear b7)
(clear b9)
)
(:goal
(and
(on b3 b1)
(on b4 b8)
(on b5 b6)
(on b6 b4)
(on b10 b9)
(on b11 b7))
)
)
