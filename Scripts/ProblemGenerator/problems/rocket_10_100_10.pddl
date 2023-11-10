(define (problem rocket_10_100_10)
  (:domain rocket)
  (:requirements :strips)
  (:objects
	r0 r1 r2 r3 r4 r5 r6 r7 r8 r9
	c0 c1 c2 c3 c4 c5 c6 c7 c8 c9
	c10 c11 c12 c13 c14 c15 c16 c17 c18 c19
	c20 c21 c22 c23 c24 c25 c26 c27 c28 c29
	c30 c31 c32 c33 c34 c35 c36 c37 c38 c39
	c40 c41 c42 c43 c44 c45 c46 c47 c48 c49
	c50 c51 c52 c53 c54 c55 c56 c57 c58 c59
	c60 c61 c62 c63 c64 c65 c66 c67 c68 c69
	c70 c71 c72 c73 c74 c75 c76 c77 c78 c79
	c80 c81 c82 c83 c84 c85 c86 c87 c88 c89
	c90 c91 c92 c93 c94 c95 c96 c97 c98 c99
	l0 l1 l2 l3 l4 l5 l6 l7 l8 l9
	  )
  (:init
	(at r0 l0) (at r1 l0) (at r2 l0) (at r3 l0) (at r4 l0) (at r5 l0) (at r6 l0) (at r7 l0) (at r8 l0) (at r9 l0)
	
	(rocket r0) (rocket r1) (rocket r2) (rocket r3) (rocket r4) (rocket r5) (rocket r6) (rocket r7) (rocket r8) (rocket r9)
	(cargo c0) (cargo c1) (cargo c2) (cargo c3) (cargo c4) (cargo c5) (cargo c6) (cargo c7) (cargo c8) (cargo c9)
	(cargo c10) (cargo c11) (cargo c12) (cargo c13) (cargo c14) (cargo c15) (cargo c16) (cargo c17) (cargo c18) (cargo c19)
	(cargo c20) (cargo c21) (cargo c22) (cargo c23) (cargo c24) (cargo c25) (cargo c26) (cargo c27) (cargo c28) (cargo c29)
	(cargo c30) (cargo c31) (cargo c32) (cargo c33) (cargo c34) (cargo c35) (cargo c36) (cargo c37) (cargo c38) (cargo c39)
	(cargo c40) (cargo c41) (cargo c42) (cargo c43) (cargo c44) (cargo c45) (cargo c46) (cargo c47) (cargo c48) (cargo c49)
	(cargo c50) (cargo c51) (cargo c52) (cargo c53) (cargo c54) (cargo c55) (cargo c56) (cargo c57) (cargo c58) (cargo c59)
	(cargo c60) (cargo c61) (cargo c62) (cargo c63) (cargo c64) (cargo c65) (cargo c66) (cargo c67) (cargo c68) (cargo c69)
	(cargo c70) (cargo c71) (cargo c72) (cargo c73) (cargo c74) (cargo c75) (cargo c76) (cargo c77) (cargo c78) (cargo c79)
	(cargo c80) (cargo c81) (cargo c82) (cargo c83) (cargo c84) (cargo c85) (cargo c86) (cargo c87) (cargo c88) (cargo c89)
	(cargo c90) (cargo c91) (cargo c92) (cargo c93) (cargo c94) (cargo c95) (cargo c96) (cargo c97) (cargo c98) (cargo c99)
	(location l0) (location l1) (location l2) (location l3) (location l4) (location l5) (location l6) (location l7) (location l8) (location l9)
	
	(at c11 l9) (at c40 l7) (at c4 l2) (at c5 l5) (at c15 l0) (at c0 l1) (at c55 l4) (at c95 l6) (at c91 l8) (at c56 l3)
	(at c79 l1) (at c23 l3) (at c51 l7) (at c25 l2) (at c98 l6) (at c21 l8) (at c76 l0) (at c77 l5) (at c69 l4) (at c52 l9)
	(at c71 l5) (at c57 l2) (at c14 l4) (at c17 l6) (at c63 l7) (at c29 l9) (at c19 l8) (at c12 l0) (at c49 l1) (at c80 l3)
	(at c3 l2) (at c31 l4) (at c38 l3) (at c43 l1) (at c60 l5) (at c35 l9) (at c10 l0) (at c1 l7) (at c93 l6) (at c44 l8)
	(at c92 l9) (at c88 l8) (at c97 l6) (at c28 l2) (at c61 l3) (at c67 l1) (at c85 l4) (at c53 l0) (at c9 l7) (at c89 l5)
	(at c94 l2) (at c2 l6) (at c81 l0) (at c6 l3) (at c18 l5) (at c36 l1) (at c48 l4) (at c41 l9) (at c50 l8) (at c54 l7)
	(at c90 l8) (at c46 l5) (at c13 l6) (at c70 l2) (at c47 l7) (at c20 l1) (at c27 l3) (at c83 l4) (at c86 l0) (at c7 l9)
	(at c16 l0) (at c22 l7) (at c78 l8) (at c26 l4) (at c34 l1) (at c74 l9) (at c24 l5) (at c73 l3) (at c75 l6) (at c59 l2)
	(at c82 l2) (at c8 l8) (at c62 l9) (at c39 l7) (at c72 l6) (at c87 l5) (at c84 l0) (at c30 l4) (at c64 l3) (at c37 l1)
	(at c99 l7) (at c68 l6) (at c58 l0) (at c33 l1) (at c42 l8) (at c65 l2) (at c66 l3) (at c32 l4) (at c45 l5) (at c96 l9)
	  )
  (:goal (and 
	(at c67 l0) (at c96 l4) (at c61 l7) (at c69 l9) (at c68 l5) (at c21 l6) (at c52 l1) (at c60 l8) (at c90 l3) (at c36 l2)
	(at c44 l2) (at c72 l7) (at c94 l8) (at c40 l1) (at c99 l3) (at c91 l9) (at c39 l4) (at c51 l6) (at c17 l0) (at c87 l5)
	(at c85 l2) (at c74 l6) (at c10 l4) (at c24 l7) (at c59 l5) (at c31 l1) (at c80 l0) (at c77 l8) (at c78 l3) (at c81 l9)
	(at c7 l8) (at c19 l6) (at c43 l4) (at c97 l7) (at c25 l2) (at c26 l5) (at c62 l1) (at c13 l9) (at c16 l3) (at c2 l0)
	(at c93 l7) (at c27 l4) (at c23 l6) (at c70 l2) (at c73 l8) (at c56 l1) (at c88 l0) (at c14 l3) (at c37 l9) (at c45 l5)
	(at c75 l3) (at c92 l5) (at c55 l1) (at c76 l0) (at c63 l2) (at c3 l4) (at c0 l8) (at c34 l7) (at c95 l9) (at c38 l6)
	(at c15 l9) (at c89 l7) (at c6 l0) (at c9 l1) (at c66 l8) (at c57 l4) (at c71 l5) (at c22 l2) (at c54 l6) (at c48 l3)
	(at c8 l9) (at c42 l4) (at c30 l1) (at c50 l5) (at c12 l3) (at c83 l7) (at c47 l6) (at c64 l8) (at c5 l2) (at c4 l0)
	(at c11 l0) (at c20 l1) (at c28 l4) (at c41 l9) (at c98 l2) (at c79 l8) (at c49 l7) (at c65 l3) (at c35 l5) (at c32 l6)
	(at c46 l2) (at c58 l5) (at c18 l9) (at c53 l1) (at c33 l8) (at c86 l7) (at c82 l3) (at c29 l6) (at c1 l4) (at c84 l0)
	  )
  )
)
