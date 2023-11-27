; Optimality lenght is (:optlen 56)
; Solution is (:solution fuelup r0 l6,load c13 r0 l6,fly r0 l6 l0,unload c13 r0 l0,fuelup r0 l0,load c5 r0 l0,fly r0 l0 l6,unload c5 r0 l6,fuelup r0 l6,load c14 r0 l6,fly r0 l6 l8,unload c14 r0 l8,fuelup r0 l8,load c3 r0 l8,fly r0 l8 l3,unload c3 r0 l3,fuelup r0 l3,load c16 r0 l3,fly r0 l3 l1,unload c16 r0 l1,fuelup r0 l1,load c2 r0 l1,fly r0 l1 l7,unload c2 r0 l7,fuelup r0 l7,load c8 r0 l7,fly r0 l7 l5,unload c8 r0 l5,fuelup r0 l5,load c10 r0 l5,fly r0 l5 l4,unload c10 r0 l4,fuelup r1 l4,load c0 r1 l4,fly r1 l4 l0,unload c0 r1 l0,fuelup r1 l0,load c9 r1 l0,fly r1 l0 l5,unload c9 r1 l5,fuelup r1 l5,load c1 r1 l5,fly r1 l5 l1,unload c1 r1 l1,fuelup r1 l1,load c4 r1 l1,fly r1 l1 l4,unload c4 r1 l4,fuelup r1 l4,load c7 r1 l4,fly r1 l4 l8,unload c7 r1 l8,fuelup r1 l8,load c6 r1 l8,fly r1 l8 l6,unload c6 r1 l6)
(define (problem rocket_2_18_9)
  (:domain rocket)
  (:requirements :strips)
  (:objects
	r0 r1
	c0 c1
	c2 c3
	c4 c5
	c6 c7
	c8 c9
	c10 c11
	c12 c13
	c14 c15
	c16 c17
	l0 l1
	l2 l3
	l4 l5
	l6 l7
	l8   )
  (:init
	(at r0 l6) (at r1 l4)
	
	(rocket r0) (rocket r1)
	(cargo c0) (cargo c1)
	(cargo c2) (cargo c3)
	(cargo c4) (cargo c5)
	(cargo c6) (cargo c7)
	(cargo c8) (cargo c9)
	(cargo c10) (cargo c11)
	(cargo c12) (cargo c13)
	(cargo c14) (cargo c15)
	(cargo c16) (cargo c17)
	(location l0) (location l1)
	(location l2) (location l3)
	(location l4) (location l5)
	(location l6) (location l7)
	(location l8) 
	(at c9 l0) (at c14 l6)
	(at c16 l3) (at c15 l7)
	(at c2 l1) (at c7 l4)
	(at c3 l8) (at c11 l2)
	(at c10 l5) (at c12 l3)
	(at c13 l6) (at c1 l5)
	(at c0 l4) (at c6 l8)
	(at c17 l2) (at c4 l1)
	(at c5 l0) (at c8 l7)
	  )
  (:goal (and 
	(at c16 l1) (at c11 l2)
	(at c0 l0) (at c2 l7)
	(at c12 l3) (at c7 l8)
	(at c4 l4) (at c5 l6)
	(at c9 l5) (at c15 l7)
	(at c1 l1) (at c8 l5)
	(at c17 l2) (at c14 l8)
	(at c13 l0) (at c10 l4)
	(at c6 l6) (at c3 l3)
	  )
  )
)
