(define (problem rocket_8_72_9)
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
	c56 c57 c58 c59 c60 c61 c62 c63
	c64 c65 c66 c67 c68 c69 c70 c71
	l0 l1 l2 l3 l4 l5 l6 l7
	l8   )
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
	(cargo c56) (cargo c57) (cargo c58) (cargo c59) (cargo c60) (cargo c61) (cargo c62) (cargo c63)
	(cargo c64) (cargo c65) (cargo c66) (cargo c67) (cargo c68) (cargo c69) (cargo c70) (cargo c71)
	(location l0) (location l1) (location l2) (location l3) (location l4) (location l5) (location l6) (location l7)
	(location l8) 
	(at c20 l3) (at c24 l8) (at c3 l6) (at c16 l5) (at c33 l1) (at c9 l4) (at c37 l0) (at c68 l2)
	(at c57 l7) (at c21 l2) (at c28 l8) (at c31 l6) (at c58 l1) (at c66 l5) (at c45 l3) (at c52 l0)
	(at c50 l4) (at c44 l7) (at c41 l2) (at c22 l1) (at c30 l7) (at c65 l8) (at c6 l6) (at c12 l3)
	(at c15 l5) (at c42 l4) (at c7 l0) (at c51 l1) (at c62 l4) (at c13 l2) (at c19 l0) (at c5 l6)
	(at c49 l5) (at c67 l7) (at c35 l8) (at c46 l3) (at c43 l0) (at c40 l7) (at c26 l3) (at c69 l6)
	(at c56 l8) (at c39 l2) (at c64 l1) (at c8 l5) (at c14 l4) (at c0 l6) (at c63 l0) (at c54 l8)
	(at c17 l7) (at c38 l5) (at c60 l3) (at c4 l1) (at c29 l2) (at c10 l4) (at c23 l6) (at c61 l1)
	(at c59 l8) (at c70 l5) (at c34 l3) (at c32 l7) (at c2 l0) (at c53 l4) (at c71 l2) (at c36 l5)
	(at c47 l7) (at c48 l0) (at c55 l6) (at c27 l8) (at c1 l1) (at c18 l3) (at c25 l4) (at c11 l2)
	  )
  (:goal (and 
	(at c51 l2) (at c29 l3) (at c67 l8) (at c23 l5) (at c64 l1) (at c61 l4) (at c55 l0) (at c52 l6)
	(at c40 l7) (at c47 l5) (at c19 l3) (at c39 l6) (at c3 l0) (at c59 l2) (at c11 l1) (at c66 l7)
	(at c24 l4) (at c7 l8) (at c49 l6) (at c17 l8) (at c36 l2) (at c56 l3) (at c50 l5) (at c25 l0)
	(at c33 l7) (at c71 l1) (at c53 l4) (at c27 l5) (at c58 l3) (at c37 l2) (at c31 l6) (at c30 l1)
	(at c2 l7) (at c21 l8) (at c22 l0) (at c38 l4) (at c54 l0) (at c8 l8) (at c4 l7) (at c70 l6)
	(at c26 l3) (at c34 l2) (at c42 l4) (at c6 l5) (at c46 l1) (at c44 l6) (at c0 l7) (at c43 l1)
	(at c35 l8) (at c60 l4) (at c45 l5) (at c5 l0) (at c10 l3) (at c41 l2) (at c28 l0) (at c9 l2)
	(at c18 l1) (at c14 l4) (at c63 l3) (at c57 l6) (at c1 l7) (at c15 l8) (at c20 l5) (at c32 l8)
	(at c68 l1) (at c65 l2) (at c12 l6) (at c62 l3) (at c13 l4) (at c48 l7) (at c16 l0) (at c69 l5)
	  )
  )
)
