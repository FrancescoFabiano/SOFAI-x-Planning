(define (problem rocket_3_18_6)
  (:domain rocket)
  (:requirements :strips)
  (:objects
	r0 r1 r2
	c0 c1 c2
	c3 c4 c5
	c6 c7 c8
	c9 c10 c11
	c12 c13 c14
	c15 c16 c17
	l0 l1 l2
	l3 l4 l5
	  )
  (:init
	(at r0 l0) (at r1 l0) (at r2 l0)
	
	(rocket r0) (rocket r1) (rocket r2)
	(cargo c0) (cargo c1) (cargo c2)
	(cargo c3) (cargo c4) (cargo c5)
	(cargo c6) (cargo c7) (cargo c8)
	(cargo c9) (cargo c10) (cargo c11)
	(cargo c12) (cargo c13) (cargo c14)
	(cargo c15) (cargo c16) (cargo c17)
	(location l0) (location l1) (location l2)
	(location l3) (location l4) (location l5)
	
	(at c7 l0) (at c10 l4) (at c17 l5)
	(at c14 l2) (at c6 l1) (at c8 l3)
	(at c4 l4) (at c1 l0) (at c5 l5)
	(at c16 l1) (at c11 l2) (at c15 l3)
	(at c9 l2) (at c3 l1) (at c12 l5)
	(at c2 l3) (at c0 l4) (at c13 l0)
	  )
  (:goal (and 
	(at c6 l5) (at c13 l2) (at c2 l4)
	(at c15 l0) (at c8 l1) (at c3 l3)
	(at c0 l5) (at c5 l3) (at c14 l4)
	(at c16 l0) (at c17 l1) (at c12 l2)
	(at c7 l5) (at c11 l0) (at c9 l3)
	(at c1 l4) (at c4 l1) (at c10 l2)
	  )
  )
)
