; Optimality lenght is (:optlen 32)
; Solution is (:solution fuelup r0 l4,load c0 r0 l4,fly r0 l4 l9,unload c0 r0 l9,fuelup r0 l9,load c6 r0 l9,fly r0 l9 l0,unload c6 r0 l0,fuelup r0 l0,load c8 r0 l0,fly r0 l0 l3,unload c8 r0 l3,fuelup r0 l3,load c9 r0 l3,fly r0 l3 l8,unload c9 r0 l8,fuelup r0 l8,load c3 r0 l8,fly r0 l8 l6,unload c3 r0 l6,fuelup r0 l6,load c1 r0 l6,fly r0 l6 l1,unload c1 r0 l1,fuelup r0 l1,load c2 r0 l1,fly r0 l1 l5,unload c2 r0 l5,fuelup r0 l5,load c7 r0 l5,fly r0 l5 l4,unload c7 r0 l4)
(define (problem rocket_1_10_10)
  (:domain rocket)
  (:requirements :strips)
  (:objects
	r0
	c0
	c1
	c2
	c3
	c4
	c5
	c6
	c7
	c8
	c9
	l0
	l1
	l2
	l3
	l4
	l5
	l6
	l7
	l8
	l9
	  )
  (:init
	(at r0 l4)
	
	(rocket r0)
	(cargo c0)
	(cargo c1)
	(cargo c2)
	(cargo c3)
	(cargo c4)
	(cargo c5)
	(cargo c6)
	(cargo c7)
	(cargo c8)
	(cargo c9)
	(location l0)
	(location l1)
	(location l2)
	(location l3)
	(location l4)
	(location l5)
	(location l6)
	(location l7)
	(location l8)
	(location l9)
	
	(at c9 l3)
	(at c6 l9)
	(at c3 l8)
	(at c7 l5)
	(at c8 l0)
	(at c0 l4)
	(at c2 l1)
	(at c1 l6)
	(at c5 l7)
	(at c4 l2)
	  )
  (:goal (and 
	(at c9 l8)
	(at c5 l7)
	(at c7 l4)
	(at c3 l6)
	(at c0 l9)
	(at c6 l0)
	(at c1 l1)
	(at c8 l3)
	(at c2 l5)
	(at c4 l2)
	  )
  )
)
