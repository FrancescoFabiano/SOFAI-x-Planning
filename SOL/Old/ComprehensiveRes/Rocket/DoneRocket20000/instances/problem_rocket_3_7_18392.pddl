; Optimality lenght is (:optlen 56)
; Solution is (:solution fuelup r0 l5,load c7 r0 l5,fly r0 l5 l6,unload c7 r0 l6,fuelup r0 l6,load c13 r0 l6,fly r0 l6 l4,unload c13 r0 l4,fuelup r0 l4,load c17 r0 l4,fly r0 l4 l2,unload c17 r0 l2,fuelup r0 l2,load c11 r0 l2,fly r0 l2 l0,unload c11 r0 l0,fuelup r0 l0,load c20 r0 l0,fly r0 l0 l5,unload c20 r0 l5,fuelup r1 l1,load c1 r1 l1,fly r1 l1 l5,unload c1 r1 l5,fuelup r1 l5,load c14 r1 l5,fly r1 l5 l6,unload c14 r1 l6,fuelup r1 l6,load c19 r1 l6,fly r1 l6 l0,unload c19 r1 l0,fuelup r1 l0,load c5 r1 l0,fly r1 l0 l3,unload c5 r1 l3,fuelup r1 l3,load c0 r1 l3,fly r1 l3 l1,unload c0 r1 l1,fuelup r2 l3,load c8 r2 l3,fly r2 l3 l4,unload c8 r2 l4,fuelup r2 l4,load c16 r2 l4,fly r2 l4 l6,unload c16 r2 l6,fuelup r2 l6,load c2 r2 l6,fly r2 l6 l0,unload c2 r2 l0,fuelup r2 l0,load c10 r2 l0,fly r2 l0 l3,unload c10 r2 l3)
(define (problem rocket_3_21_7)
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
	l0 l1 l2
	l3 l4 l5
	l6   )
  (:init
	(at r0 l5) (at r1 l1) (at r2 l3)
	
	(rocket r0) (rocket r1) (rocket r2)
	(cargo c0) (cargo c1) (cargo c2)
	(cargo c3) (cargo c4) (cargo c5)
	(cargo c6) (cargo c7) (cargo c8)
	(cargo c9) (cargo c10) (cargo c11)
	(cargo c12) (cargo c13) (cargo c14)
	(cargo c15) (cargo c16) (cargo c17)
	(cargo c18) (cargo c19) (cargo c20)
	(location l0) (location l1) (location l2)
	(location l3) (location l4) (location l5)
	(location l6) 
	(at c15 l2) (at c7 l5) (at c16 l4)
	(at c13 l6) (at c0 l3) (at c6 l1)
	(at c20 l0) (at c1 l1) (at c5 l0)
	(at c19 l6) (at c14 l5) (at c4 l2)
	(at c3 l3) (at c12 l4) (at c10 l0)
	(at c11 l2) (at c8 l3) (at c2 l6)
	(at c18 l5) (at c17 l4) (at c9 l1)
	  )
  (:goal (and 
	(at c13 l4) (at c20 l5) (at c17 l2)
	(at c2 l0) (at c0 l1) (at c16 l6)
	(at c5 l3) (at c1 l5) (at c7 l6)
	(at c9 l1) (at c15 l2) (at c19 l0)
	(at c8 l4) (at c10 l3) (at c18 l5)
	(at c4 l2) (at c6 l1) (at c3 l3)
	(at c11 l0) (at c14 l6) (at c12 l4)
	  )
  )
)
