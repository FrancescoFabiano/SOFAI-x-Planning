


(define (problem briefcase-o8)
(:domain briefcase)
(:objects l0 l1 l2 l3 l4 l5 l6 l7 l8 - location
          o0 o1 o2 o3 o4 o5 o6 o7 - portable)
(:init
(at o0 l2)
(at o1 l4)
(at o2 l1)
(at o3 l4)
(at o4 l8)
(at o5 l5)
(at o6 l4)
(at o7 l6)
(is-at l0)
)
(:goal
(and
(at o0 l1)
(at o1 l1)
(at o2 l1)
(at o3 l4)
(at o4 l7)
(at o5 l8)
(at o6 l0)
(at o7 l6)
(is-at l8)
)
)
)


