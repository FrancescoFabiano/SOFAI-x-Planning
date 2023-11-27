; Optimality lenght is (:optlen 56)
; Solution is (:solution fuelup r0 l0,load c8 r0 l0,fly r0 l0 l2,unload c8 r0 l2,fuelup r0 l2,load c18 r0 l2,fly r0 l2 l3,unload c18 r0 l3,fuelup r0 l3,load c22 r0 l3,fly r0 l3 l4,unload c22 r0 l4,fuelup r0 l4,load c2 r0 l4,fly r0 l4 l5,unload c2 r0 l5,fuelup r0 l5,load c15 r0 l5,fly r0 l5 l0,unload c15 r0 l0,fuelup r1 l1,load c4 r1 l1,fly r1 l1 l4,unload c4 r1 l4,fuelup r1 l4,load c3 r1 l4,fly r1 l4 l0,unload c3 r1 l0,fuelup r1 l0,load c19 r1 l0,fly r1 l0 l5,unload c19 r1 l5,fuelup r1 l5,load c0 r1 l5,fly r1 l5 l2,unload c0 r1 l2,fuelup r1 l2,load c23 r1 l2,fly r1 l2 l1,unload c23 r1 l1,fuelup r2 l1,load c13 r2 l1,fly r2 l1 l5,unload c13 r2 l5,fuelup r2 l5,load c16 r2 l5,fly r2 l5 l3,unload c16 r2 l3,fuelup r2 l3,load c9 r2 l3,fly r2 l3 l2,unload c9 r2 l2,fuelup r2 l2,load c6 r2 l2,fly r2 l2 l1,unload c6 r2 l1)
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
	(at r0 l0) (at r1 l1) (at r2 l1) (at r3 l4)
	
	(rocket r0) (rocket r1) (rocket r2) (rocket r3)
	(cargo c0) (cargo c1) (cargo c2) (cargo c3)
	(cargo c4) (cargo c5) (cargo c6) (cargo c7)
	(cargo c8) (cargo c9) (cargo c10) (cargo c11)
	(cargo c12) (cargo c13) (cargo c14) (cargo c15)
	(cargo c16) (cargo c17) (cargo c18) (cargo c19)
	(cargo c20) (cargo c21) (cargo c22) (cargo c23)
	(location l0) (location l1) (location l2) (location l3)
	(location l4) (location l5) 
	(at c18 l2) (at c9 l3) (at c3 l4) (at c17 l0)
	(at c7 l5) (at c13 l1) (at c14 l0) (at c23 l2)
	(at c20 l3) (at c2 l4) (at c16 l5) (at c10 l1)
	(at c12 l1) (at c1 l4) (at c5 l2) (at c19 l0)
	(at c15 l5) (at c11 l3) (at c8 l0) (at c21 l4)
	(at c0 l5) (at c22 l3) (at c6 l2) (at c4 l1)
	  )
  (:goal (and 
	(at c0 l2) (at c23 l1) (at c22 l4) (at c18 l3)
	(at c17 l0) (at c7 l5) (at c4 l4) (at c15 l0)
	(at c12 l1) (at c19 l5) (at c8 l2) (at c11 l3)
	(at c20 l3) (at c5 l2) (at c1 l4) (at c14 l0)
	(at c2 l5) (at c10 l1) (at c9 l2) (at c16 l3)
	(at c6 l1) (at c13 l5) (at c21 l4) (at c3 l0)
	  )
  )
)