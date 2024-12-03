; Optimality lenght is (:optlen 32)
; Solution is (:solution fuelup r0 l3,load c0 r0 l3,fly r0 l3 l4,unload c0 r0 l4,fuelup r0 l4,load c2 r0 l4,fly r0 l4 l1,unload c2 r0 l1,fuelup r0 l1,load c5 r0 l1,fly r0 l1 l0,unload c5 r0 l0,fuelup r1 l0,load c6 r1 l0,fly r1 l0 l1,unload c6 r1 l1,fuelup r1 l1,load c1 r1 l1,fly r1 l1 l2,unload c1 r1 l2,fuelup r1 l2,load c4 r1 l2,fly r1 l2 l0,unload c4 r1 l0,fuelup r1 l0,load c7 r1 l0,fly r1 l0 l4,unload c7 r1 l4,fuelup r1 l4,load c8 r1 l4,fly r1 l4 l3,unload c8 r1 l3)
(define (problem rocket_2_10_5)
  (:domain rocket)
  (:requirements :strips)
  (:objects
	r0 r1
	c0 c1
	c2 c3
	c4 c5
	c6 c7
	c8 c9
	l0 l1
	l2 l3
	l4   )
  (:init
	(at r0 l3) (at r1 l0)
	
	(rocket r0) (rocket r1)
	(cargo c0) (cargo c1)
	(cargo c2) (cargo c3)
	(cargo c4) (cargo c5)
	(cargo c6) (cargo c7)
	(cargo c8) (cargo c9)
	(location l0) (location l1)
	(location l2) (location l3)
	(location l4) 
	(at c5 l1) (at c2 l4)
	(at c9 l2) (at c0 l3)
	(at c7 l0) (at c1 l1)
	(at c4 l2) (at c8 l4)
	(at c6 l0) (at c3 l3)
	  )
  (:goal (and 
	(at c2 l1) (at c1 l2)
	(at c7 l4) (at c5 l0)
	(at c8 l3) (at c9 l2)
	(at c4 l0) (at c6 l1)
	(at c3 l3) (at c0 l4)
	  )
  )
)