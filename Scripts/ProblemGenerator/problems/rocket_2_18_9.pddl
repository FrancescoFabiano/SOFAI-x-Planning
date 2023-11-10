(define (problem rocket_2_18_9)
  (:domain rocket)
  (:requirements :strips)
  (:objects
	r0 r1
	c0 c1
	c2 c3
	c4 c5
	c6 c7
	c8 c9
	c10 c11
	c12 c13
	c14 c15
	c16 c17
	l0 l1
	l2 l3
	l4 l5
	l6 l7
	l8   )
  (:init
	(at r0 l0) (at r1 l0)
	
	(rocket r0) (rocket r1)
	(cargo c0) (cargo c1)
	(cargo c2) (cargo c3)
	(cargo c4) (cargo c5)
	(cargo c6) (cargo c7)
	(cargo c8) (cargo c9)
	(cargo c10) (cargo c11)
	(cargo c12) (cargo c13)
	(cargo c14) (cargo c15)
	(cargo c16) (cargo c17)
	(location l0) (location l1)
	(location l2) (location l3)
	(location l4) (location l5)
	(location l6) (location l7)
	(location l8) 
	(at c11 l0) (at c2 l6)
	(at c12 l5) (at c1 l2)
	(at c7 l8) (at c9 l4)
	(at c6 l7) (at c17 l1)
	(at c5 l3) (at c3 l8)
	(at c8 l4) (at c16 l0)
	(at c0 l2) (at c13 l1)
	(at c15 l6) (at c4 l3)
	(at c10 l7) (at c14 l5)
	  )
  (:goal (and 
	(at c1 l3) (at c10 l8)
	(at c12 l4) (at c11 l6)
	(at c4 l5) (at c8 l2)
	(at c13 l7) (at c2 l1)
	(at c9 l0) (at c14 l3)
	(at c5 l8) (at c17 l5)
	(at c0 l0) (at c7 l4)
	(at c6 l7) (at c16 l6)
	(at c3 l2) (at c15 l1)
	  )
  )
)
