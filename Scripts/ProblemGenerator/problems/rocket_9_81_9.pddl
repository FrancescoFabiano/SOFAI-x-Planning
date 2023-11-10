(define (problem rocket_9_81_9)
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
	c54 c55 c56 c57 c58 c59 c60 c61 c62
	c63 c64 c65 c66 c67 c68 c69 c70 c71
	c72 c73 c74 c75 c76 c77 c78 c79 c80
	l0 l1 l2 l3 l4 l5 l6 l7 l8
	  )
  (:init
	(at r0 l0) (at r1 l0) (at r2 l0) (at r3 l0) (at r4 l0) (at r5 l0) (at r6 l0) (at r7 l0) (at r8 l0)
	
	(rocket r0) (rocket r1) (rocket r2) (rocket r3) (rocket r4) (rocket r5) (rocket r6) (rocket r7) (rocket r8)
	(cargo c0) (cargo c1) (cargo c2) (cargo c3) (cargo c4) (cargo c5) (cargo c6) (cargo c7) (cargo c8)
	(cargo c9) (cargo c10) (cargo c11) (cargo c12) (cargo c13) (cargo c14) (cargo c15) (cargo c16) (cargo c17)
	(cargo c18) (cargo c19) (cargo c20) (cargo c21) (cargo c22) (cargo c23) (cargo c24) (cargo c25) (cargo c26)
	(cargo c27) (cargo c28) (cargo c29) (cargo c30) (cargo c31) (cargo c32) (cargo c33) (cargo c34) (cargo c35)
	(cargo c36) (cargo c37) (cargo c38) (cargo c39) (cargo c40) (cargo c41) (cargo c42) (cargo c43) (cargo c44)
	(cargo c45) (cargo c46) (cargo c47) (cargo c48) (cargo c49) (cargo c50) (cargo c51) (cargo c52) (cargo c53)
	(cargo c54) (cargo c55) (cargo c56) (cargo c57) (cargo c58) (cargo c59) (cargo c60) (cargo c61) (cargo c62)
	(cargo c63) (cargo c64) (cargo c65) (cargo c66) (cargo c67) (cargo c68) (cargo c69) (cargo c70) (cargo c71)
	(cargo c72) (cargo c73) (cargo c74) (cargo c75) (cargo c76) (cargo c77) (cargo c78) (cargo c79) (cargo c80)
	(location l0) (location l1) (location l2) (location l3) (location l4) (location l5) (location l6) (location l7) (location l8)
	
	(at c44 l5) (at c9 l0) (at c26 l6) (at c14 l2) (at c46 l4) (at c8 l1) (at c74 l3) (at c39 l8) (at c63 l7)
	(at c66 l4) (at c43 l8) (at c70 l3) (at c42 l2) (at c52 l0) (at c7 l7) (at c45 l1) (at c30 l6) (at c27 l5)
	(at c53 l8) (at c67 l2) (at c69 l1) (at c57 l3) (at c78 l0) (at c65 l7) (at c19 l5) (at c3 l6) (at c38 l4)
	(at c37 l3) (at c17 l0) (at c35 l5) (at c49 l2) (at c11 l4) (at c29 l8) (at c71 l6) (at c0 l7) (at c77 l1)
	(at c58 l0) (at c48 l8) (at c32 l7) (at c64 l5) (at c40 l4) (at c23 l1) (at c2 l6) (at c28 l3) (at c68 l2)
	(at c61 l1) (at c10 l5) (at c79 l3) (at c60 l4) (at c16 l6) (at c6 l2) (at c54 l8) (at c36 l0) (at c56 l7)
	(at c4 l7) (at c33 l3) (at c51 l5) (at c15 l8) (at c18 l2) (at c59 l4) (at c73 l1) (at c1 l0) (at c5 l6)
	(at c20 l1) (at c72 l8) (at c80 l6) (at c76 l0) (at c50 l2) (at c41 l7) (at c12 l5) (at c25 l4) (at c21 l3)
	(at c24 l1) (at c31 l0) (at c13 l7) (at c22 l6) (at c34 l3) (at c55 l4) (at c47 l2) (at c75 l5) (at c62 l8)
	  )
  (:goal (and 
	(at c75 l0) (at c6 l4) (at c5 l3) (at c4 l2) (at c0 l1) (at c30 l5) (at c49 l7) (at c58 l8) (at c68 l6)
	(at c8 l2) (at c23 l6) (at c19 l8) (at c79 l1) (at c80 l7) (at c46 l3) (at c41 l4) (at c11 l0) (at c62 l5)
	(at c60 l8) (at c55 l6) (at c39 l5) (at c51 l7) (at c38 l1) (at c1 l0) (at c45 l3) (at c56 l2) (at c35 l4)
	(at c40 l8) (at c53 l7) (at c27 l3) (at c28 l1) (at c20 l5) (at c69 l0) (at c31 l6) (at c36 l2) (at c54 l4)
	(at c65 l0) (at c29 l1) (at c44 l3) (at c7 l8) (at c74 l7) (at c10 l6) (at c13 l4) (at c42 l5) (at c63 l2)
	(at c64 l4) (at c59 l1) (at c21 l8) (at c77 l3) (at c25 l6) (at c71 l2) (at c43 l5) (at c34 l0) (at c3 l7)
	(at c52 l2) (at c78 l8) (at c67 l3) (at c14 l0) (at c12 l4) (at c61 l1) (at c47 l6) (at c50 l7) (at c15 l5)
	(at c22 l6) (at c17 l1) (at c57 l0) (at c76 l7) (at c70 l2) (at c9 l3) (at c26 l4) (at c24 l8) (at c37 l5)
	(at c2 l7) (at c16 l2) (at c73 l8) (at c33 l0) (at c18 l6) (at c66 l5) (at c32 l3) (at c48 l1) (at c72 l4)
	  )
  )
)
