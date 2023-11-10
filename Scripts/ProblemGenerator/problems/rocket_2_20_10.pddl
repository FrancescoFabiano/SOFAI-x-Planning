(define (problem rocket_2_20_10)
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
	c18 c19
	l0 l1
	l2 l3
	l4 l5
	l6 l7
	l8 l9
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
	(cargo c16) (cargo c17)
	(cargo c18) (cargo c19)
	(location l0) (location l1)
	(location l2) (location l3)
	(location l4) (location l5)
	(location l6) (location l7)
	(location l8) (location l9)
	
	(at c18 l7) (at c4 l9)
	(at c6 l0) (at c1 l8)
	(at c19 l3) (at c7 l4)
	(at c11 l1) (at c16 l5)
	(at c3 l6) (at c5 l2)
	(at c0 l8) (at c12 l5)
	(at c9 l4) (at c17 l7)
	(at c13 l6) (at c14 l3)
	(at c8 l1) (at c10 l2)
	(at c15 l0) (at c2 l9)
	  )
  (:goal (and 
	(at c19 l0) (at c10 l9)
	(at c16 l3) (at c4 l2)
	(at c15 l4) (at c17 l5)
	(at c8 l1) (at c0 l6)
	(at c18 l7) (at c1 l8)
	(at c7 l5) (at c3 l4)
	(at c12 l8) (at c14 l9)
	(at c2 l1) (at c11 l7)
	(at c6 l2) (at c9 l3)
	(at c5 l0) (at c13 l6)
	  )
  )
)
