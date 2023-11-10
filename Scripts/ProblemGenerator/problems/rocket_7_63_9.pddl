(define (problem rocket_7_63_9)
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
	c49 c50 c51 c52 c53 c54 c55
	c56 c57 c58 c59 c60 c61 c62
	l0 l1 l2 l3 l4 l5 l6
	l7 l8   )
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
	(cargo c49) (cargo c50) (cargo c51) (cargo c52) (cargo c53) (cargo c54) (cargo c55)
	(cargo c56) (cargo c57) (cargo c58) (cargo c59) (cargo c60) (cargo c61) (cargo c62)
	(location l0) (location l1) (location l2) (location l3) (location l4) (location l5) (location l6)
	(location l7) (location l8) 
	(at c22 l6) (at c51 l3) (at c28 l5) (at c21 l7) (at c44 l8) (at c19 l0) (at c50 l1)
	(at c60 l4) (at c43 l2) (at c9 l0) (at c20 l4) (at c10 l7) (at c53 l5) (at c52 l2)
	(at c27 l8) (at c26 l6) (at c15 l1) (at c3 l3) (at c55 l8) (at c61 l0) (at c11 l2)
	(at c23 l3) (at c18 l4) (at c39 l6) (at c42 l5) (at c54 l7) (at c31 l1) (at c45 l0)
	(at c29 l4) (at c49 l1) (at c16 l2) (at c25 l3) (at c0 l6) (at c13 l5) (at c40 l7)
	(at c6 l8) (at c36 l5) (at c47 l8) (at c1 l2) (at c59 l3) (at c4 l6) (at c12 l0)
	(at c41 l1) (at c58 l4) (at c17 l7) (at c32 l8) (at c7 l7) (at c8 l0) (at c34 l1)
	(at c48 l2) (at c24 l4) (at c57 l3) (at c62 l6) (at c33 l5) (at c14 l2) (at c30 l8)
	(at c35 l5) (at c37 l6) (at c56 l4) (at c46 l0) (at c38 l3) (at c5 l7) (at c2 l1)
	  )
  (:goal (and 
	(at c45 l4) (at c52 l8) (at c37 l2) (at c54 l5) (at c49 l6) (at c59 l3) (at c55 l0)
	(at c21 l7) (at c24 l1) (at c7 l7) (at c31 l2) (at c46 l6) (at c10 l1) (at c26 l5)
	(at c58 l8) (at c9 l0) (at c40 l4) (at c27 l3) (at c35 l3) (at c11 l8) (at c38 l0)
	(at c60 l1) (at c23 l7) (at c41 l6) (at c20 l5) (at c44 l2) (at c22 l4) (at c51 l7)
	(at c14 l2) (at c6 l5) (at c1 l6) (at c13 l8) (at c61 l4) (at c43 l3) (at c25 l0)
	(at c50 l1) (at c3 l4) (at c56 l7) (at c28 l5) (at c2 l1) (at c42 l8) (at c8 l3)
	(at c12 l0) (at c0 l2) (at c34 l6) (at c15 l1) (at c19 l0) (at c18 l7) (at c32 l6)
	(at c36 l2) (at c48 l4) (at c29 l8) (at c47 l3) (at c57 l5) (at c17 l3) (at c4 l8)
	(at c39 l0) (at c5 l2) (at c53 l7) (at c30 l6) (at c33 l1) (at c62 l4) (at c16 l5)
	  )
  )
)
