; Optimality lenght is (:optlen 84)
; Solution is (:solution fuelup r0 l0,load c14 r0 l0,fly r0 l5,unload c14 r0 l5,fuelup r0 l5,load c3 r0 l5,fly r0 l3,unload c3 r0 l3,fuelup r0 l3,load c10 r0 l3,fly r0 l1,unload c10 r0 l1,fuelup r0 l1,load c13 r0 l1,fly r0 l7,unload c13 r0 l7,fuelup r0 l7,load c16 r0 l7,fly r0 l6,unload c16 r0 l6,fuelup r0 l6,load c9 r0 l6,fly r0 l2,unload c9 r0 l2,fuelup r0 l2,load c23 r0 l2,fly r0 l0,unload c23 r0 l0,fuelup r1 l0,load c18 r1 l0,fly r1 l2,unload c18 r1 l2,fuelup r1 l2,load c4 r1 l2,fly r1 l7,unload c4 r1 l7,fuelup r1 l7,load c6 r1 l7,fly r1 l4,unload c6 r1 l4,fuelup r1 l4,load c7 r1 l4,fly r1 l3,unload c7 r1 l3,fuelup r1 l3,load c17 r1 l3,fly r1 l6,unload c17 r1 l6,fuelup r1 l6,load c0 r1 l6,fly r1 l5,unload c0 r1 l5,fuelup r1 l5,load c15 r1 l5,fly r1 l0,unload c15 r1 l0,fuelup r2 l0,load c21 r2 l0,fly r2 l5,unload c21 r2 l5,fuelup r2 l5,load c5 r2 l5,fly r2 l4,unload c5 r2 l4,fuelup r2 l4,load c2 r2 l4,fly r2 l2,unload c2 r2 l2,fuelup r2 l2,load c8 r2 l2,fly r2 l3,unload c8 r2 l3,fuelup r2 l3,load c19 r2 l3,fly r2 l1,unload c19 r2 l1,fuelup r2 l1,load c1 r2 l1,fly r2 l6,unload c1 r2 l6,fuelup r2 l6,load c12 r2 l6,fly r2 l0,unload c12 r2 l0)
(define (problem rocket_3_24_8)
  (:domain rocket)
  (:requirements :strips)
  (:objects
	r0 r1 r2
	c0 c1 c2
	c3 c4 c5
	c6 c7 c8
	c9 c10 c11
	c12 c13 c14
	c15 c16 c17
	c18 c19 c20
	c21 c22 c23
	l0 l1 l2
	l3 l4 l5
	l6 l7   )
  (:init
	(at r0 l0) (at r1 l0) (at r2 l0)
	
	(rocket r0) (rocket r1) (rocket r2)
	(cargo c0) (cargo c1) (cargo c2)
	(cargo c3) (cargo c4) (cargo c5)
	(cargo c6) (cargo c7) (cargo c8)
	(cargo c9) (cargo c10) (cargo c11)
	(cargo c12) (cargo c13) (cargo c14)
	(cargo c15) (cargo c16) (cargo c17)
	(cargo c18) (cargo c19) (cargo c20)
	(cargo c21) (cargo c22) (cargo c23)
	(location l0) (location l1) (location l2)
	(location l3) (location l4) (location l5)
	(location l6) (location l7) 
	(at c2 l4) (at c19 l3) (at c3 l5)
	(at c12 l6) (at c1 l1) (at c11 l7)
	(at c21 l0) (at c4 l2) (at c10 l3)
	(at c8 l2) (at c20 l4) (at c18 l0)
	(at c13 l1) (at c16 l7) (at c5 l5)
	(at c0 l6) (at c14 l0) (at c6 l7)
	(at c22 l1) (at c9 l6) (at c7 l4)
	(at c23 l2) (at c17 l3) (at c15 l5)
	  )
  (:goal (and 
	(at c4 l7) (at c7 l3) (at c12 l0)
	(at c22 l1) (at c2 l2) (at c17 l6)
	(at c0 l5) (at c6 l4) (at c16 l6)
	(at c13 l7) (at c9 l2) (at c3 l3)
	(at c19 l1) (at c5 l4) (at c21 l5)
	(at c23 l0) (at c18 l2) (at c8 l3)
	(at c11 l7) (at c14 l5) (at c15 l0)
	(at c1 l6) (at c20 l4) (at c10 l1)
	  )
  )
)
