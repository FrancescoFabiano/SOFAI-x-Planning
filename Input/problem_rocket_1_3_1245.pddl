; Optimality lenght is (:optlen 12)
(define (problem rocket_1_3_3)
  (:domain rocket)
  (:requirements :strips)
  (:objects
	r0
	c0
	c1
	c2
	l0
	l1
	l2
	  )
(:init
(at r0 l0)
(at c1 l2)
(at c2 l0)
(at c0 l1)
)
(:goal
(and
(at c0 l2)
(at c1 l0)
(at c2 l1)
)
)
)
