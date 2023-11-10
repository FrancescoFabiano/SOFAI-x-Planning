(define (problem rocket_4_28_7)
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
	l0 l1 l2 l3
	l4 l5 l6   )
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
	(location l0) (location l1) (location l2) (location l3)
	(location l4) (location l5) (location l6) 
	(at c6 l4) (at c10 l1) (at c4 l3) (at c21 l5)
	(at c15 l0) (at c8 l6) (at c26 l2) (at c24 l6)
	(at c17 l1) (at c11 l0) (at c25 l5) (at c20 l3)
	(at c22 l2) (at c23 l4) (at c12 l2) (at c9 l5)
	(at c27 l0) (at c18 l6) (at c7 l3) (at c3 l4)
	(at c0 l1) (at c16 l5) (at c19 l2) (at c14 l0)
	(at c13 l1) (at c1 l4) (at c2 l6) (at c5 l3)
	  )
  (:goal (and 
	(at c17 l0) (at c8 l1) (at c11 l4) (at c26 l3)
	(at c6 l6) (at c2 l2) (at c22 l5) (at c14 l1)
	(at c4 l2) (at c27 l4) (at c23 l3) (at c16 l0)
	(at c7 l5) (at c24 l6) (at c13 l4) (at c0 l3)
	(at c25 l2) (at c9 l0) (at c1 l5) (at c19 l6)
	(at c10 l1) (at c5 l4) (at c18 l2) (at c21 l3)
	(at c20 l1) (at c15 l5) (at c12 l0) (at c3 l6)
	  )
  )
)
