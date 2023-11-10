(define (problem rocket_2_16_8)
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
	l0 l1
	l2 l3
	l4 l5
	l6 l7
	  )
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
	(location l0) (location l1)
	(location l2) (location l3)
	(location l4) (location l5)
	(location l6) (location l7)
	
	(at c13 l7) (at c15 l3)
	(at c14 l0) (at c10 l6)
	(at c7 l5) (at c1 l4)
	(at c9 l2) (at c8 l1)
	(at c11 l3) (at c4 l1)
	(at c12 l7) (at c0 l5)
	(at c2 l0) (at c6 l6)
	(at c3 l2) (at c5 l4)
	  )
  (:goal (and 
	(at c0 l4) (at c12 l3)
	(at c14 l6) (at c9 l2)
	(at c4 l0) (at c13 l1)
	(at c8 l7) (at c11 l5)
	(at c1 l1) (at c15 l4)
	(at c2 l7) (at c10 l6)
	(at c6 l5) (at c7 l0)
	(at c3 l3) (at c5 l2)
	  )
  )
)
