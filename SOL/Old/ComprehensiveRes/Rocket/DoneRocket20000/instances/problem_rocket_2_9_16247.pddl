; Optimality lenght is (:optlen 56)
; Solution is (:solution fuelup r0 l0,load c12 r0 l0,fly r0 l0 l6,unload c12 r0 l6,fuelup r0 l6,load c6 r0 l6,fly r0 l6 l1,unload c6 r0 l1,fuelup r0 l1,load c8 r0 l1,fly r0 l1 l0,unload c8 r0 l0,fuelup r0 l0,load c16 r0 l0,fly r0 l0 l4,unload c16 r0 l4,fuelup r0 l4,load c7 r0 l4,fly r0 l4 l8,unload c7 r0 l8,fuelup r0 l8,load c14 r0 l8,fly r0 l8 l2,unload c14 r0 l2,fuelup r0 l2,load c5 r0 l2,fly r0 l2 l7,unload c5 r0 l7,fuelup r0 l7,load c15 r0 l7,fly r0 l7 l3,unload c15 r0 l3,fuelup r0 l3,load c3 r0 l3,fly r0 l3 l5,unload c3 r0 l5,fuelup r1 l5,load c4 r1 l5,fly r1 l5 l4,unload c4 r1 l4,fuelup r1 l4,load c10 r1 l4,fly r1 l4 l8,unload c10 r1 l8,fuelup r1 l8,load c17 r1 l8,fly r1 l8 l1,unload c17 r1 l1,fuelup r1 l1,load c1 r1 l1,fly r1 l1 l7,unload c1 r1 l7,fuelup r1 l7,load c11 r1 l7,fly r1 l7 l0,unload c11 r1 l0)
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
	(at r0 l0) (at r1 l5)
	
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
	(at c10 l4) (at c11 l7)
	(at c17 l8) (at c16 l0)
	(at c8 l1) (at c4 l5)
	(at c6 l6) (at c13 l2)
	(at c3 l3) (at c2 l3)
	(at c7 l4) (at c0 l6)
	(at c14 l8) (at c15 l7)
	(at c9 l5) (at c12 l0)
	(at c1 l1) (at c5 l2)
	  )
  (:goal (and 
	(at c16 l4) (at c17 l1)
	(at c10 l8) (at c5 l7)
	(at c11 l0) (at c9 l5)
	(at c13 l2) (at c0 l6)
	(at c2 l3) (at c4 l4)
	(at c8 l0) (at c1 l7)
	(at c15 l3) (at c3 l5)
	(at c12 l6) (at c14 l2)
	(at c7 l8) (at c6 l1)
	  )
  )
)
