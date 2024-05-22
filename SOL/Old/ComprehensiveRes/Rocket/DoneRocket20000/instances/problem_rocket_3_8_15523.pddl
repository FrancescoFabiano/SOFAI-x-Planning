; Optimality lenght is (:optlen 48)
; Solution is (:solution fuelup r0 l6,load c11 r0 l6,fly r0 l6 l5,unload c11 r0 l5,fuelup r0 l5,load c19 r0 l5,fly r0 l5 l2,unload c19 r0 l2,fuelup r0 l2,load c12 r0 l2,fly r0 l2 l7,unload c12 r0 l7,fuelup r0 l7,load c18 r0 l7,fly r0 l7 l4,unload c18 r0 l4,fuelup r0 l4,load c2 r0 l4,fly r0 l4 l0,unload c2 r0 l0,fuelup r0 l0,load c22 r0 l0,fly r0 l0 l6,unload c22 r0 l6,fuelup r0 l6,load c16 r0 l6,fly r0 l6 l3,unload c16 r0 l3,fuelup r0 l3,load c20 r0 l3,fly r0 l3 l1,unload c20 r0 l1,fuelup r1 l1,load c8 r1 l1,fly r1 l1 l6,unload c8 r1 l6,fuelup r2 l7,load c10 r2 l7,fly r2 l7 l4,unload c10 r2 l4,fuelup r2 l4,load c7 r2 l4,fly r2 l4 l3,unload c7 r2 l3,fuelup r2 l3,load c6 r2 l3,fly r2 l3 l7,unload c6 r2 l7)
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
	(at r0 l6) (at r1 l1) (at r2 l7)
	
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
	(at c20 l3) (at c10 l7) (at c3 l0)
	(at c9 l2) (at c8 l1) (at c19 l5)
	(at c11 l6) (at c0 l4) (at c12 l2)
	(at c18 l7) (at c5 l5) (at c23 l1)
	(at c2 l4) (at c22 l0) (at c13 l3)
	(at c16 l6) (at c15 l1) (at c21 l6)
	(at c1 l2) (at c14 l7) (at c17 l5)
	(at c7 l4) (at c6 l3) (at c4 l0)
	  )
  (:goal (and 
	(at c6 l7) (at c1 l2) (at c3 l0)
	(at c8 l6) (at c20 l1) (at c11 l5)
	(at c0 l4) (at c13 l3) (at c7 l3)
	(at c21 l6) (at c10 l4) (at c14 l7)
	(at c15 l1) (at c4 l0) (at c9 l2)
	(at c17 l5) (at c16 l3) (at c18 l4)
	(at c5 l5) (at c19 l2) (at c23 l1)
	(at c12 l7) (at c2 l0) (at c22 l6)
	  )
  )
)
