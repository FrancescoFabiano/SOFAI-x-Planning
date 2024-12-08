;(:optlen 12)



(define (problem briefcase-o5)
(:domain briefcase)
(:objects l0 l1 l2 l3 l4 l5 - location
          o0 o1 o2 o3 o4 - portable)
(:init
(at o0 l2)
(at o1 l1)
(at o2 l3)
(at o3 l0)
(at o4 l1)
(is-at l1)
)
(:goal
(and
(at o0 l0)
(at o1 l1)
(at o2 l5)
(at o3 l1)
(at o4 l1)
(is-at l4)
)
)
)


