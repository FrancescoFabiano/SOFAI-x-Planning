(define (problem rocket_6_42_7)
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
	c36 c37 c38 c39 c40 c41
	l0 l1 l2 l3 l4 l5
	l6   )
  (:init
	(at r0 l0) (at r1 l0) (at r2 l0) (at r3 l0) (at r4 l0) (at r5 l0)
	
	(rocket r0) (rocket r1) (rocket r2) (rocket r3) (rocket r4) (rocket r5)
	(cargo c0) (cargo c1) (cargo c2) (cargo c3) (cargo c4) (cargo c5)
	(cargo c6) (cargo c7) (cargo c8) (cargo c9) (cargo c10) (cargo c11)
	(cargo c12) (cargo c13) (cargo c14) (cargo c15) (cargo c16) (cargo c17)
	(cargo c18) (cargo c19) (cargo c20) (cargo c21) (cargo c22) (cargo c23)
	(cargo c24) (cargo c25) (cargo c26) (cargo c27) (cargo c28) (cargo c29)
	(cargo c30) (cargo c31) (cargo c32) (cargo c33) (cargo c34) (cargo c35)
	(cargo c36) (cargo c37) (cargo c38) (cargo c39) (cargo c40) (cargo c41)
	(location l0) (location l1) (location l2) (location l3) (location l4) (location l5)
	(location l6) 
	(at c18 l0) (at c33 l5) (at c30 l6) (at c3 l4) (at c5 l1) (at c34 l3)
	(at c32 l2) (at c1 l0) (at c11 l3) (at c8 l1) (at c6 l5) (at c37 l4)
	(at c9 l6) (at c35 l2) (at c13 l6) (at c16 l4) (at c15 l1) (at c0 l0)
	(at c27 l5) (at c2 l2) (at c39 l3) (at c26 l3) (at c4 l5) (at c22 l0)
	(at c40 l1) (at c23 l4) (at c14 l2) (at c7 l6) (at c29 l3) (at c38 l6)
	(at c28 l0) (at c31 l2) (at c17 l4) (at c25 l5) (at c12 l1) (at c21 l3)
	(at c36 l2) (at c20 l0) (at c41 l5) (at c19 l4) (at c24 l1) (at c10 l6)
	  )
  (:goal (and 
	(at c6 l1) (at c13 l5) (at c1 l6) (at c18 l4) (at c31 l0) (at c32 l3)
	(at c17 l2) (at c14 l6) (at c33 l1) (at c7 l3) (at c9 l5) (at c21 l4)
	(at c5 l0) (at c16 l2) (at c38 l5) (at c19 l1) (at c26 l3) (at c27 l4)
	(at c0 l0) (at c34 l2) (at c8 l6) (at c37 l5) (at c36 l3) (at c35 l2)
	(at c24 l0) (at c2 l6) (at c15 l1) (at c22 l4) (at c41 l6) (at c25 l0)
	(at c40 l2) (at c4 l4) (at c28 l3) (at c10 l5) (at c20 l1) (at c23 l6)
	(at c12 l5) (at c30 l1) (at c39 l2) (at c3 l3) (at c11 l4) (at c29 l0)
	  )
  )
)
