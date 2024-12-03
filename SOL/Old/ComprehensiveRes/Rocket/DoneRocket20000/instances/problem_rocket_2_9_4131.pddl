; Optimality lenght is (:optlen 56)
; Solution is (:solution fuelup r0 l4,load c9 r0 l4,fly r0 l4 l8,unload c9 r0 l8,fuelup r0 l8,load c12 r0 l8,fly r0 l8 l0,unload c12 r0 l0,fuelup r0 l0,load c14 r0 l0,fly r0 l0 l7,unload c14 r0 l7,fuelup r0 l7,load c10 r0 l7,fly r0 l7 l1,unload c10 r0 l1,fuelup r0 l1,load c2 r0 l1,fly r0 l1 l2,unload c2 r0 l2,fuelup r0 l2,load c0 r0 l2,fly r0 l2 l3,unload c0 r0 l3,fuelup r0 l3,load c16 r0 l3,fly r0 l3 l6,unload c16 r0 l6,fuelup r0 l6,load c7 r0 l6,fly r0 l6 l4,unload c7 r0 l4,fuelup r1 l7,load c4 r1 l7,fly r1 l7 l0,unload c4 r1 l0,fuelup r1 l0,load c5 r1 l0,fly r1 l0 l8,unload c5 r1 l8,fuelup r1 l8,load c3 r1 l8,fly r1 l8 l6,unload c3 r1 l6,fuelup r1 l6,load c11 r1 l6,fly r1 l6 l3,unload c11 r1 l3,fuelup r1 l3,load c6 r1 l3,fly r1 l3 l1,unload c6 r1 l1,fuelup r1 l1,load c13 r1 l1,fly r1 l1 l7,unload c13 r1 l7)
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
	(at r0 l4) (at r1 l7)
	
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
	(at c5 l0) (at c15 l2)
	(at c9 l4) (at c17 l5)
	(at c3 l8) (at c16 l3)
	(at c7 l6) (at c10 l7)
	(at c13 l1) (at c4 l7)
	(at c1 l5) (at c14 l0)
	(at c8 l4) (at c12 l8)
	(at c2 l1) (at c0 l2)
	(at c11 l6) (at c6 l3)
	  )
  (:goal (and 
	(at c9 l8) (at c8 l4)
	(at c14 l7) (at c1 l5)
	(at c0 l3) (at c3 l6)
	(at c10 l1) (at c4 l0)
	(at c15 l2) (at c12 l0)
	(at c17 l5) (at c2 l2)
	(at c16 l6) (at c7 l4)
	(at c6 l1) (at c5 l8)
	(at c11 l3) (at c13 l7)
	  )
  )
)