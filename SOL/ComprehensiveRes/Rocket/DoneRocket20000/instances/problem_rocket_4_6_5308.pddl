; Optimality lenght is (:optlen 56)
; Solution is (:solution fuelup r0 l4,load c8 r0 l4,fly r0 l4 l3,unload c8 r0 l3,fuelup r0 l3,load c18 r0 l3,fly r0 l3 l1,unload c18 r0 l1,fuelup r0 l1,load c20 r0 l1,fly r0 l1 l5,unload c20 r0 l5,fuelup r0 l5,load c7 r0 l5,fly r0 l5 l2,unload c7 r0 l2,fuelup r0 l2,load c0 r0 l2,fly r0 l2 l4,unload c0 r0 l4,fuelup r1 l2,load c4 r1 l2,fly r1 l2 l3,unload c4 r1 l3,fuelup r1 l3,load c19 r1 l3,fly r1 l3 l1,unload c19 r1 l1,fuelup r1 l1,load c15 r1 l1,fly r1 l1 l0,unload c15 r1 l0,fuelup r1 l0,load c17 r1 l0,fly r1 l0 l2,unload c17 r1 l2,fuelup r3 l0,load c5 r3 l0,fly r3 l0 l3,unload c5 r3 l3,fuelup r3 l3,load c1 r3 l3,fly r3 l3 l4,unload c1 r3 l4,fuelup r3 l4,load c13 r3 l4,fly r3 l4 l5,unload c13 r3 l5,fuelup r3 l5,load c22 r3 l5,fly r3 l5 l2,unload c22 r3 l2,fuelup r3 l2,load c6 r3 l2,fly r3 l2 l0,unload c6 r3 l0)
(define (problem rocket_4_24_6)
  (:domain rocket)
  (:requirements :strips)
  (:objects
	r0 r1 r2 r3
	c0 c1 c2 c3
	c4 c5 c6 c7
	c8 c9 c10 c11
	c12 c13 c14 c15
	c16 c17 c18 c19
	c20 c21 c22 c23
	l0 l1 l2 l3
	l4 l5   )
  (:init
	(at r0 l4) (at r1 l2) (at r2 l1) (at r3 l0)
	
	(rocket r0) (rocket r1) (rocket r2) (rocket r3)
	(cargo c0) (cargo c1) (cargo c2) (cargo c3)
	(cargo c4) (cargo c5) (cargo c6) (cargo c7)
	(cargo c8) (cargo c9) (cargo c10) (cargo c11)
	(cargo c12) (cargo c13) (cargo c14) (cargo c15)
	(cargo c16) (cargo c17) (cargo c18) (cargo c19)
	(cargo c20) (cargo c21) (cargo c22) (cargo c23)
	(location l0) (location l1) (location l2) (location l3)
	(location l4) (location l5) 
	(at c15 l1) (at c22 l5) (at c21 l2) (at c13 l4)
	(at c18 l3) (at c17 l0) (at c0 l2) (at c5 l0)
	(at c1 l3) (at c9 l5) (at c16 l4) (at c20 l1)
	(at c3 l4) (at c4 l2) (at c12 l3) (at c7 l5)
	(at c2 l1) (at c14 l0) (at c11 l1) (at c8 l4)
	(at c6 l2) (at c23 l5) (at c19 l3) (at c10 l0)
	  )
  (:goal (and 
	(at c22 l2) (at c2 l1) (at c10 l0) (at c12 l3)
	(at c13 l5) (at c16 l4) (at c7 l2) (at c14 l0)
	(at c19 l1) (at c0 l4) (at c20 l5) (at c8 l3)
	(at c21 l2) (at c4 l3) (at c1 l4) (at c6 l0)
	(at c23 l5) (at c18 l1) (at c3 l4) (at c11 l1)
	(at c5 l3) (at c17 l2) (at c15 l0) (at c9 l5)
	  )
  )
)
