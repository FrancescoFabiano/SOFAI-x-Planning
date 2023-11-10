; Optimality lenght is (:optlen 40)
(define (problem rocket_2_10_5)
  (:domain rocket)
  (:requirements :strips)
  (:objects
	r0 r1
	c0 c1
	c2 c3
	c4 c5
	c6 c7
	c8 c9
	l0 l1
	l2 l3
	l4   )
  (:init
	(at r0 l0) (at r1 l0)
	
	(rocket r0) (rocket r1)
	(cargo c0) (cargo c1)
	(cargo c2) (cargo c3)
	(cargo c4) (cargo c5)
	(cargo c6) (cargo c7)
	(cargo c8) (cargo c9)
	(location l0) (location l1)
	(location l2) (location l3)
	(location l4) 
	(at c7 l3) (at c6 l2)
	(at c8 l1) (at c1 l4)
	(at c4 l0) (at c5 l1)
	(at c3 l2) (at c9 l0)
	(at c2 l4) (at c0 l3)
	  )
  (:goal (and 
	(at c9 l3) (at c7 l2)
	(at c2 l0) (at c4 l1)
	(at c8 l4) (at c3 l3)
	(at c1 l2) (at c5 l4)
	(at c0 l0) (at c6 l1)
	  )
  )
)
