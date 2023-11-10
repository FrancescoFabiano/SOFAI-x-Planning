(define (problem rocket_6_24_4)
  (:domain rocket)
  (:requirements :strips)
  (:objects
	r0 r1 r2 r3 r4 r5
	c0 c1 c2 c3 c4 c5
	c6 c7 c8 c9 c10 c11
	c12 c13 c14 c15 c16 c17
	c18 c19 c20 c21 c22 c23
	l0 l1 l2 l3   )
  (:init
	(at r0 l0) (at r1 l0) (at r2 l0) (at r3 l0) (at r4 l0) (at r5 l0)
	
	(rocket r0) (rocket r1) (rocket r2) (rocket r3) (rocket r4) (rocket r5)
	(cargo c0) (cargo c1) (cargo c2) (cargo c3) (cargo c4) (cargo c5)
	(cargo c6) (cargo c7) (cargo c8) (cargo c9) (cargo c10) (cargo c11)
	(cargo c12) (cargo c13) (cargo c14) (cargo c15) (cargo c16) (cargo c17)
	(cargo c18) (cargo c19) (cargo c20) (cargo c21) (cargo c22) (cargo c23)
	(location l0) (location l1) (location l2) (location l3) 
	(at c15 l0) (at c21 l2) (at c9 l1) (at c19 l3) (at c13 l0) (at c17 l3)
	(at c16 l2) (at c3 l1) (at c7 l3) (at c0 l0) (at c12 l1) (at c10 l2)
	(at c23 l2) (at c8 l1) (at c1 l3) (at c14 l0) (at c22 l2) (at c6 l0)
	(at c18 l1) (at c11 l3) (at c4 l1) (at c20 l3) (at c5 l2) (at c2 l0)
	  )
  (:goal (and 
	(at c7 l2) (at c12 l0) (at c14 l1) (at c10 l3) (at c20 l0) (at c4 l1)
	(at c21 l2) (at c16 l3) (at c23 l2) (at c13 l3) (at c1 l0) (at c19 l1)
	(at c9 l1) (at c2 l3) (at c22 l0) (at c0 l2) (at c18 l2) (at c11 l3)
	(at c3 l0) (at c8 l1) (at c15 l2) (at c5 l3) (at c17 l1) (at c6 l0)
	  )
  )
)
