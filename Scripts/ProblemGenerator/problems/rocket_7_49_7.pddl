(define (problem rocket_7_49_7)
  (:domain rocket)
  (:requirements :strips)
  (:objects
	r0 r1 r2 r3 r4 r5 r6
	c0 c1 c2 c3 c4 c5 c6
	c7 c8 c9 c10 c11 c12 c13
	c14 c15 c16 c17 c18 c19 c20
	c21 c22 c23 c24 c25 c26 c27
	c28 c29 c30 c31 c32 c33 c34
	c35 c36 c37 c38 c39 c40 c41
	c42 c43 c44 c45 c46 c47 c48
	l0 l1 l2 l3 l4 l5 l6
	  )
  (:init
	(at r0 l0) (at r1 l0) (at r2 l0) (at r3 l0) (at r4 l0) (at r5 l0) (at r6 l0)
	
	(rocket r0) (rocket r1) (rocket r2) (rocket r3) (rocket r4) (rocket r5) (rocket r6)
	(cargo c0) (cargo c1) (cargo c2) (cargo c3) (cargo c4) (cargo c5) (cargo c6)
	(cargo c7) (cargo c8) (cargo c9) (cargo c10) (cargo c11) (cargo c12) (cargo c13)
	(cargo c14) (cargo c15) (cargo c16) (cargo c17) (cargo c18) (cargo c19) (cargo c20)
	(cargo c21) (cargo c22) (cargo c23) (cargo c24) (cargo c25) (cargo c26) (cargo c27)
	(cargo c28) (cargo c29) (cargo c30) (cargo c31) (cargo c32) (cargo c33) (cargo c34)
	(cargo c35) (cargo c36) (cargo c37) (cargo c38) (cargo c39) (cargo c40) (cargo c41)
	(cargo c42) (cargo c43) (cargo c44) (cargo c45) (cargo c46) (cargo c47) (cargo c48)
	(location l0) (location l1) (location l2) (location l3) (location l4) (location l5) (location l6)
	
	(at c25 l3) (at c22 l6) (at c16 l1) (at c35 l5) (at c5 l0) (at c45 l4) (at c13 l2)
	(at c47 l6) (at c6 l1) (at c29 l4) (at c28 l3) (at c0 l0) (at c27 l5) (at c32 l2)
	(at c36 l4) (at c38 l5) (at c33 l6) (at c21 l0) (at c19 l1) (at c15 l2) (at c46 l3)
	(at c23 l1) (at c31 l6) (at c2 l5) (at c7 l4) (at c11 l3) (at c30 l2) (at c43 l0)
	(at c24 l4) (at c12 l0) (at c26 l2) (at c1 l5) (at c41 l1) (at c8 l6) (at c40 l3)
	(at c42 l2) (at c17 l1) (at c48 l3) (at c44 l5) (at c4 l6) (at c20 l4) (at c9 l0)
	(at c37 l1) (at c34 l2) (at c3 l6) (at c39 l4) (at c10 l0) (at c18 l3) (at c14 l5)
	  )
  (:goal (and 
	(at c21 l1) (at c9 l6) (at c37 l5) (at c6 l4) (at c17 l2) (at c22 l0) (at c40 l3)
	(at c13 l2) (at c16 l5) (at c4 l4) (at c26 l6) (at c8 l0) (at c41 l1) (at c34 l3)
	(at c42 l1) (at c11 l0) (at c12 l2) (at c35 l5) (at c38 l3) (at c47 l6) (at c32 l4)
	(at c27 l0) (at c25 l3) (at c28 l5) (at c10 l2) (at c44 l4) (at c31 l6) (at c46 l1)
	(at c43 l1) (at c0 l6) (at c5 l0) (at c23 l3) (at c18 l5) (at c24 l4) (at c45 l2)
	(at c29 l5) (at c33 l4) (at c39 l0) (at c48 l6) (at c1 l2) (at c19 l1) (at c20 l3)
	(at c7 l5) (at c36 l3) (at c15 l4) (at c30 l0) (at c2 l6) (at c3 l1) (at c14 l2)
	  )
  )
)
