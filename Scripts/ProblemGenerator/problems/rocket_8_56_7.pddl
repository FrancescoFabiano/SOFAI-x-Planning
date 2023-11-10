(define (problem rocket_8_56_7)
  (:domain rocket)
  (:requirements :strips)
  (:objects
	r0 r1 r2 r3 r4 r5 r6 r7
	c0 c1 c2 c3 c4 c5 c6 c7
	c8 c9 c10 c11 c12 c13 c14 c15
	c16 c17 c18 c19 c20 c21 c22 c23
	c24 c25 c26 c27 c28 c29 c30 c31
	c32 c33 c34 c35 c36 c37 c38 c39
	c40 c41 c42 c43 c44 c45 c46 c47
	c48 c49 c50 c51 c52 c53 c54 c55
	l0 l1 l2 l3 l4 l5 l6   )
  (:init
	(at r0 l0) (at r1 l0) (at r2 l0) (at r3 l0) (at r4 l0) (at r5 l0) (at r6 l0) (at r7 l0)
	
	(rocket r0) (rocket r1) (rocket r2) (rocket r3) (rocket r4) (rocket r5) (rocket r6) (rocket r7)
	(cargo c0) (cargo c1) (cargo c2) (cargo c3) (cargo c4) (cargo c5) (cargo c6) (cargo c7)
	(cargo c8) (cargo c9) (cargo c10) (cargo c11) (cargo c12) (cargo c13) (cargo c14) (cargo c15)
	(cargo c16) (cargo c17) (cargo c18) (cargo c19) (cargo c20) (cargo c21) (cargo c22) (cargo c23)
	(cargo c24) (cargo c25) (cargo c26) (cargo c27) (cargo c28) (cargo c29) (cargo c30) (cargo c31)
	(cargo c32) (cargo c33) (cargo c34) (cargo c35) (cargo c36) (cargo c37) (cargo c38) (cargo c39)
	(cargo c40) (cargo c41) (cargo c42) (cargo c43) (cargo c44) (cargo c45) (cargo c46) (cargo c47)
	(cargo c48) (cargo c49) (cargo c50) (cargo c51) (cargo c52) (cargo c53) (cargo c54) (cargo c55)
	(location l0) (location l1) (location l2) (location l3) (location l4) (location l5) (location l6) 
	(at c20 l0) (at c16 l4) (at c27 l1) (at c32 l5) (at c18 l3) (at c38 l6) (at c5 l2) (at c23 l0)
	(at c34 l2) (at c43 l6) (at c28 l5) (at c6 l1) (at c49 l4) (at c50 l3) (at c22 l0) (at c26 l3)
	(at c37 l6) (at c17 l4) (at c1 l2) (at c53 l1) (at c42 l5) (at c25 l0) (at c44 l6) (at c52 l1)
	(at c54 l3) (at c11 l4) (at c36 l2) (at c14 l5) (at c15 l3) (at c24 l4) (at c51 l6) (at c35 l2)
	(at c47 l1) (at c29 l0) (at c13 l5) (at c45 l2) (at c21 l4) (at c12 l5) (at c39 l1) (at c19 l0)
	(at c41 l6) (at c8 l3) (at c55 l4) (at c2 l0) (at c46 l1) (at c30 l2) (at c3 l6) (at c0 l5)
	(at c7 l3) (at c4 l3) (at c9 l2) (at c31 l6) (at c48 l4) (at c33 l1) (at c10 l5) (at c40 l0)
	  )
  (:goal (and 
	(at c22 l1) (at c34 l3) (at c30 l2) (at c12 l5) (at c33 l6) (at c17 l4) (at c25 l0) (at c52 l5)
	(at c6 l4) (at c40 l2) (at c46 l6) (at c29 l3) (at c19 l1) (at c3 l0) (at c36 l0) (at c37 l3)
	(at c13 l2) (at c55 l5) (at c9 l1) (at c4 l6) (at c26 l4) (at c8 l0) (at c39 l3) (at c23 l4)
	(at c43 l5) (at c5 l6) (at c49 l2) (at c38 l1) (at c15 l4) (at c48 l0) (at c44 l5) (at c18 l2)
	(at c20 l3) (at c1 l1) (at c35 l6) (at c51 l6) (at c45 l5) (at c11 l3) (at c42 l4) (at c14 l0)
	(at c50 l1) (at c16 l2) (at c24 l2) (at c47 l0) (at c10 l1) (at c7 l5) (at c53 l3) (at c0 l4)
	(at c21 l6) (at c31 l1) (at c41 l2) (at c2 l5) (at c32 l4) (at c27 l3) (at c54 l0) (at c28 l6)
	  )
  )
)
