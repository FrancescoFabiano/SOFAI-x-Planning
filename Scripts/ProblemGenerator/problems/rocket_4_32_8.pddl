(define (problem rocket_4_32_8)
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
	c24 c25 c26 c27
	c28 c29 c30 c31
	l0 l1 l2 l3
	l4 l5 l6 l7
	  )
  (:init
	(at r0 l0) (at r1 l0) (at r2 l0) (at r3 l0)
	
	(rocket r0) (rocket r1) (rocket r2) (rocket r3)
	(cargo c0) (cargo c1) (cargo c2) (cargo c3)
	(cargo c4) (cargo c5) (cargo c6) (cargo c7)
	(cargo c8) (cargo c9) (cargo c10) (cargo c11)
	(cargo c12) (cargo c13) (cargo c14) (cargo c15)
	(cargo c16) (cargo c17) (cargo c18) (cargo c19)
	(cargo c20) (cargo c21) (cargo c22) (cargo c23)
	(cargo c24) (cargo c25) (cargo c26) (cargo c27)
	(cargo c28) (cargo c29) (cargo c30) (cargo c31)
	(location l0) (location l1) (location l2) (location l3)
	(location l4) (location l5) (location l6) (location l7)
	
	(at c12 l7) (at c0 l5) (at c24 l1) (at c18 l2)
	(at c6 l3) (at c3 l4) (at c23 l0) (at c2 l6)
	(at c9 l0) (at c5 l6) (at c17 l2) (at c19 l7)
	(at c30 l1) (at c4 l5) (at c14 l4) (at c27 l3)
	(at c8 l3) (at c15 l2) (at c22 l4) (at c10 l7)
	(at c28 l0) (at c25 l6) (at c11 l5) (at c16 l1)
	(at c21 l4) (at c7 l0) (at c13 l5) (at c29 l7)
	(at c1 l2) (at c20 l3) (at c31 l1) (at c26 l6)
	  )
  (:goal (and 
	(at c19 l1) (at c26 l5) (at c6 l6) (at c18 l0)
	(at c1 l3) (at c24 l2) (at c14 l7) (at c11 l4)
	(at c28 l5) (at c29 l6) (at c17 l0) (at c16 l3)
	(at c12 l4) (at c0 l2) (at c5 l7) (at c30 l1)
	(at c9 l1) (at c8 l0) (at c20 l7) (at c4 l5)
	(at c10 l4) (at c7 l6) (at c13 l2) (at c23 l3)
	(at c31 l4) (at c2 l6) (at c15 l0) (at c3 l2)
	(at c27 l7) (at c25 l1) (at c22 l5) (at c21 l3)
	  )
  )
)
