(define (problem rocket_9_54_6)
  (:domain rocket)
  (:requirements :strips)
  (:objects
	r0 r1 r2 r3 r4 r5 r6 r7 r8
	c0 c1 c2 c3 c4 c5 c6 c7 c8
	c9 c10 c11 c12 c13 c14 c15 c16 c17
	c18 c19 c20 c21 c22 c23 c24 c25 c26
	c27 c28 c29 c30 c31 c32 c33 c34 c35
	c36 c37 c38 c39 c40 c41 c42 c43 c44
	c45 c46 c47 c48 c49 c50 c51 c52 c53
	l0 l1 l2 l3 l4 l5   )
  (:init
	(at r0 l0) (at r1 l0) (at r2 l0) (at r3 l0) (at r4 l0) (at r5 l0) (at r6 l0) (at r7 l0) (at r8 l0)
	
	(rocket r0) (rocket r1) (rocket r2) (rocket r3) (rocket r4) (rocket r5) (rocket r6) (rocket r7) (rocket r8)
	(cargo c0) (cargo c1) (cargo c2) (cargo c3) (cargo c4) (cargo c5) (cargo c6) (cargo c7) (cargo c8)
	(cargo c9) (cargo c10) (cargo c11) (cargo c12) (cargo c13) (cargo c14) (cargo c15) (cargo c16) (cargo c17)
	(cargo c18) (cargo c19) (cargo c20) (cargo c21) (cargo c22) (cargo c23) (cargo c24) (cargo c25) (cargo c26)
	(cargo c27) (cargo c28) (cargo c29) (cargo c30) (cargo c31) (cargo c32) (cargo c33) (cargo c34) (cargo c35)
	(cargo c36) (cargo c37) (cargo c38) (cargo c39) (cargo c40) (cargo c41) (cargo c42) (cargo c43) (cargo c44)
	(cargo c45) (cargo c46) (cargo c47) (cargo c48) (cargo c49) (cargo c50) (cargo c51) (cargo c52) (cargo c53)
	(location l0) (location l1) (location l2) (location l3) (location l4) (location l5) 
	(at c14 l5) (at c53 l0) (at c35 l1) (at c10 l3) (at c46 l4) (at c26 l2) (at c19 l2) (at c31 l4) (at c3 l5)
	(at c8 l1) (at c25 l0) (at c18 l3) (at c12 l5) (at c44 l3) (at c24 l0) (at c37 l4) (at c40 l2) (at c45 l1)
	(at c33 l5) (at c34 l2) (at c48 l3) (at c29 l0) (at c1 l4) (at c30 l1) (at c51 l4) (at c50 l2) (at c16 l1)
	(at c52 l3) (at c15 l5) (at c2 l0) (at c17 l3) (at c20 l5) (at c27 l4) (at c49 l0) (at c9 l2) (at c23 l1)
	(at c39 l4) (at c32 l2) (at c5 l3) (at c0 l5) (at c42 l0) (at c4 l1) (at c43 l4) (at c41 l0) (at c6 l3)
	(at c11 l5) (at c22 l2) (at c28 l1) (at c36 l4) (at c7 l3) (at c21 l1) (at c38 l0) (at c47 l2) (at c13 l5)
	  )
  (:goal (and 
	(at c49 l0) (at c19 l5) (at c46 l4) (at c8 l2) (at c16 l3) (at c25 l1) (at c0 l3) (at c17 l1) (at c35 l2)
	(at c15 l4) (at c3 l5) (at c48 l0) (at c2 l3) (at c5 l0) (at c36 l4) (at c18 l1) (at c11 l2) (at c40 l5)
	(at c53 l2) (at c20 l1) (at c9 l5) (at c38 l3) (at c34 l4) (at c29 l0) (at c10 l2) (at c23 l4) (at c24 l5)
	(at c4 l1) (at c27 l0) (at c28 l3) (at c6 l0) (at c1 l5) (at c52 l1) (at c21 l2) (at c43 l4) (at c50 l3)
	(at c47 l4) (at c31 l5) (at c45 l0) (at c12 l2) (at c32 l3) (at c41 l1) (at c44 l3) (at c30 l1) (at c22 l2)
	(at c42 l0) (at c7 l5) (at c37 l4) (at c26 l5) (at c39 l0) (at c14 l2) (at c13 l4) (at c33 l3) (at c51 l1)
	  )
  )
)
