; Optimality lenght is (:optlen 60)
; Solution is (:solution fuelup r0 l6,load c3 r0 l6,fly r0 l6 l1,unload c3 r0 l1,fuelup r0 l1,load c8 r0 l1,fly r0 l1 l4,unload c8 r0 l4,fuelup r0 l4,load c16 r0 l4,fly r0 l4 l8,unload c16 r0 l8,fuelup r0 l8,load c2 r0 l8,fly r0 l8 l7,unload c2 r0 l7,fuelup r0 l7,load c11 r0 l7,fly r0 l7 l2,unload c11 r0 l2,fuelup r0 l2,load c15 r0 l2,fly r0 l2 l6,unload c15 r0 l6,fuelup r1 l7,load c0 r1 l7,fly r1 l7 l2,unload c0 r1 l2,fuelup r1 l2,load c9 r1 l2,fly r1 l2 l3,unload c9 r1 l3,fuelup r1 l3,load c12 r1 l3,fly r1 l3 l0,unload c12 r1 l0,fuelup r1 l0,load c13 r1 l0,fly r1 l0 l6,unload c13 r1 l6,fuelup r1 l6,load c10 r1 l6,fly r1 l6 l8,unload c10 r1 l8,fuelup r1 l8,load c7 r1 l8,fly r1 l8 l4,unload c7 r1 l4,fuelup r1 l4,load c5 r1 l4,fly r1 l4 l5,unload c5 r1 l5,fuelup r1 l5,load c17 r1 l5,fly r1 l5 l1,unload c17 r1 l1,fuelup r1 l1,load c1 r1 l1,fly r1 l1 l7,unload c1 r1 l7)
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
	(at r0 l6) (at r1 l7)
	
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
	(at c0 l7) (at c13 l0)
	(at c16 l4) (at c4 l3)
	(at c8 l1) (at c9 l2)
	(at c2 l8) (at c10 l6)
	(at c17 l5) (at c1 l1)
	(at c11 l7) (at c7 l8)
	(at c15 l2) (at c3 l6)
	(at c5 l4) (at c6 l5)
	(at c12 l3) (at c14 l0)
	  )
  (:goal (and 
	(at c0 l2) (at c17 l1)
	(at c10 l8) (at c14 l0)
	(at c4 l3) (at c8 l4)
	(at c2 l7) (at c6 l5)
	(at c13 l6) (at c7 l4)
	(at c15 l6) (at c1 l7)
	(at c16 l8) (at c5 l5)
	(at c12 l0) (at c11 l2)
	(at c3 l1) (at c9 l3)
	  )
  )
)
