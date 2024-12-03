; Optimality lenght is (:optlen 48)
; Solution is (:solution fuelup r0 l5,load c6 r0 l5,fly r0 l5 l1,unload c6 r0 l1,fuelup r0 l1,load c12 r0 l1,fly r0 l1 l3,unload c12 r0 l3,fuelup r0 l3,load c2 r0 l3,fly r0 l3 l6,unload c2 r0 l6,fuelup r0 l6,load c10 r0 l6,fly r0 l6 l7,unload c10 r0 l7,fuelup r0 l7,load c0 r0 l7,fly r0 l7 l5,unload c0 r0 l5,fuelup r1 l1,load c5 r1 l1,fly r1 l1 l8,unload c5 r1 l8,fuelup r1 l8,load c11 r1 l8,fly r1 l8 l2,unload c11 r1 l2,fuelup r1 l2,load c8 r1 l2,fly r1 l2 l4,unload c8 r1 l4,fuelup r1 l4,load c1 r1 l4,fly r1 l4 l3,unload c1 r1 l3,fuelup r1 l3,load c13 r1 l3,fly r1 l3 l5,unload c13 r1 l5,fuelup r1 l5,load c9 r1 l5,fly r1 l5 l6,unload c9 r1 l6,fuelup r1 l6,load c17 r1 l6,fly r1 l6 l1,unload c17 r1 l1)
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
	(at r0 l5) (at r1 l1)
	
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
	(at c6 l5) (at c10 l6)
	(at c13 l3) (at c16 l0)
	(at c12 l1) (at c7 l7)
	(at c3 l4) (at c8 l2)
	(at c11 l8) (at c9 l5)
	(at c2 l3) (at c14 l8)
	(at c5 l1) (at c17 l6)
	(at c0 l7) (at c1 l4)
	(at c4 l0) (at c15 l2)
	  )
  (:goal (and 
	(at c14 l8) (at c16 l0)
	(at c11 l2) (at c1 l3)
	(at c3 l4) (at c2 l6)
	(at c7 l7) (at c13 l5)
	(at c6 l1) (at c0 l5)
	(at c10 l7) (at c8 l4)
	(at c15 l2) (at c4 l0)
	(at c12 l3) (at c17 l1)
	(at c9 l6) (at c5 l8)
	  )
  )
)