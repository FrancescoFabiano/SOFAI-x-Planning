(define (problem rocket_4_24_6)
  (:domain rocket)
  (:requirements :strips)
  (:objects
	r0 r1 r2 r3
	c0 c1 c2 c3
	c4 c5 c6 c7
	c8 c9 c10 c11
	c12 c13 c14 c15
	c16 c17 c18 c19
	c20 c21 c22 c23
	l0 l1 l2 l3
	l4 l5   )
  (:init
	(at r0 l0) (at r1 l0) (at r2 l0) (at r3 l0)
	
	(rocket r0) (rocket r1) (rocket r2) (rocket r3)
	(cargo c0) (cargo c1) (cargo c2) (cargo c3)
	(cargo c4) (cargo c5) (cargo c6) (cargo c7)
	(cargo c8) (cargo c9) (cargo c10) (cargo c11)
	(cargo c12) (cargo c13) (cargo c14) (cargo c15)
	(cargo c16) (cargo c17) (cargo c18) (cargo c19)
	(cargo c20) (cargo c21) (cargo c22) (cargo c23)
	(location l0) (location l1) (location l2) (location l3)
	(location l4) (location l5) 
	(at c10 l4) (at c11 l0) (at c18 l5) (at c21 l2)
	(at c0 l3) (at c1 l1) (at c22 l1) (at c6 l5)
	(at c3 l3) (at c2 l0) (at c5 l2) (at c16 l4)
	(at c23 l3) (at c19 l0) (at c7 l4) (at c20 l2)
	(at c9 l1) (at c8 l5) (at c13 l4) (at c17 l0)
	(at c14 l1) (at c15 l2) (at c12 l5) (at c4 l3)
	  )
  (:goal (and 
	(at c4 l3) (at c7 l1) (at c5 l5) (at c10 l0)
	(at c13 l4) (at c23 l2) (at c22 l0) (at c1 l1)
	(at c12 l4) (at c20 l2) (at c19 l5) (at c0 l3)
	(at c17 l2) (at c16 l1) (at c21 l5) (at c8 l3)
	(at c15 l0) (at c18 l4) (at c11 l3) (at c14 l2)
	(at c2 l1) (at c6 l5) (at c9 l4) (at c3 l0)
	  )
  )
)
