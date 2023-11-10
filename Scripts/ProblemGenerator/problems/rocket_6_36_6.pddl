(define (problem rocket_6_36_6)
  (:domain rocket)
  (:requirements :strips)
  (:objects
	r0 r1 r2 r3 r4 r5
	c0 c1 c2 c3 c4 c5
	c6 c7 c8 c9 c10 c11
	c12 c13 c14 c15 c16 c17
	c18 c19 c20 c21 c22 c23
	c24 c25 c26 c27 c28 c29
	c30 c31 c32 c33 c34 c35
	l0 l1 l2 l3 l4 l5
	  )
  (:init
	(at r0 l0) (at r1 l0) (at r2 l0) (at r3 l0) (at r4 l0) (at r5 l0)
	
	(rocket r0) (rocket r1) (rocket r2) (rocket r3) (rocket r4) (rocket r5)
	(cargo c0) (cargo c1) (cargo c2) (cargo c3) (cargo c4) (cargo c5)
	(cargo c6) (cargo c7) (cargo c8) (cargo c9) (cargo c10) (cargo c11)
	(cargo c12) (cargo c13) (cargo c14) (cargo c15) (cargo c16) (cargo c17)
	(cargo c18) (cargo c19) (cargo c20) (cargo c21) (cargo c22) (cargo c23)
	(cargo c24) (cargo c25) (cargo c26) (cargo c27) (cargo c28) (cargo c29)
	(cargo c30) (cargo c31) (cargo c32) (cargo c33) (cargo c34) (cargo c35)
	(location l0) (location l1) (location l2) (location l3) (location l4) (location l5)
	
	(at c13 l0) (at c29 l4) (at c12 l5) (at c34 l3) (at c9 l1) (at c35 l2)
	(at c3 l4) (at c1 l0) (at c10 l1) (at c0 l2) (at c15 l5) (at c6 l3)
	(at c22 l2) (at c14 l3) (at c23 l5) (at c25 l0) (at c11 l4) (at c18 l1)
	(at c2 l5) (at c24 l2) (at c28 l1) (at c16 l0) (at c26 l3) (at c27 l4)
	(at c19 l2) (at c32 l0) (at c21 l4) (at c4 l1) (at c5 l5) (at c31 l3)
	(at c8 l0) (at c30 l1) (at c20 l5) (at c33 l2) (at c17 l3) (at c7 l4)
	  )
  (:goal (and 
	(at c27 l2) (at c28 l1) (at c17 l4) (at c5 l5) (at c32 l3) (at c21 l0)
	(at c2 l2) (at c6 l5) (at c18 l1) (at c14 l4) (at c3 l0) (at c24 l3)
	(at c13 l4) (at c7 l0) (at c30 l3) (at c35 l1) (at c31 l5) (at c29 l2)
	(at c12 l3) (at c8 l0) (at c25 l2) (at c15 l4) (at c33 l5) (at c20 l1)
	(at c9 l5) (at c26 l2) (at c23 l1) (at c19 l4) (at c22 l3) (at c1 l0)
	(at c0 l4) (at c10 l0) (at c11 l5) (at c16 l2) (at c34 l1) (at c4 l3)
	  )
  )
)
