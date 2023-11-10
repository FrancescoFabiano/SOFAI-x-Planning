(define (problem rocket_9_36_4)
  (:domain rocket)
  (:requirements :strips)
  (:objects
	r0 r1 r2 r3 r4 r5 r6 r7 r8
	c0 c1 c2 c3 c4 c5 c6 c7 c8
	c9 c10 c11 c12 c13 c14 c15 c16 c17
	c18 c19 c20 c21 c22 c23 c24 c25 c26
	c27 c28 c29 c30 c31 c32 c33 c34 c35
	l0 l1 l2 l3   )
  (:init
	(at r0 l0) (at r1 l0) (at r2 l0) (at r3 l0) (at r4 l0) (at r5 l0) (at r6 l0) (at r7 l0) (at r8 l0)
	
	(rocket r0) (rocket r1) (rocket r2) (rocket r3) (rocket r4) (rocket r5) (rocket r6) (rocket r7) (rocket r8)
	(cargo c0) (cargo c1) (cargo c2) (cargo c3) (cargo c4) (cargo c5) (cargo c6) (cargo c7) (cargo c8)
	(cargo c9) (cargo c10) (cargo c11) (cargo c12) (cargo c13) (cargo c14) (cargo c15) (cargo c16) (cargo c17)
	(cargo c18) (cargo c19) (cargo c20) (cargo c21) (cargo c22) (cargo c23) (cargo c24) (cargo c25) (cargo c26)
	(cargo c27) (cargo c28) (cargo c29) (cargo c30) (cargo c31) (cargo c32) (cargo c33) (cargo c34) (cargo c35)
	(location l0) (location l1) (location l2) (location l3) 
	(at c21 l3) (at c17 l1) (at c11 l0) (at c14 l2) (at c10 l3) (at c33 l1) (at c28 l0) (at c26 l2) (at c19 l3)
	(at c34 l0) (at c23 l1) (at c4 l2) (at c18 l2) (at c5 l3) (at c9 l0) (at c25 l1) (at c12 l1) (at c30 l2)
	(at c3 l3) (at c1 l0) (at c31 l0) (at c27 l3) (at c7 l2) (at c6 l1) (at c22 l1) (at c29 l0) (at c24 l3)
	(at c32 l2) (at c16 l0) (at c15 l3) (at c8 l1) (at c35 l2) (at c13 l0) (at c2 l1) (at c0 l2) (at c20 l3)
	  )
  (:goal (and 
	(at c22 l0) (at c17 l2) (at c12 l3) (at c35 l1) (at c29 l1) (at c25 l2) (at c7 l0) (at c21 l3) (at c32 l2)
	(at c15 l0) (at c20 l1) (at c26 l3) (at c11 l2) (at c23 l3) (at c34 l1) (at c31 l0) (at c30 l3) (at c16 l2)
	(at c9 l0) (at c18 l1) (at c4 l2) (at c3 l1) (at c27 l0) (at c24 l3) (at c5 l3) (at c1 l2) (at c14 l0)
	(at c13 l1) (at c0 l1) (at c8 l3) (at c28 l2) (at c33 l0) (at c10 l2) (at c2 l1) (at c19 l3) (at c6 l0)
	  )
  )
)
