; Optimality lenght is (:optlen 36)
; Solution is (:solution fuelup r0 l0,load c2 r0 l0,fly r0 l0 l2,unload c2 r0 l2,fuelup r0 l2,load c6 r0 l2,fly r0 l2 l9,unload c6 r0 l9,fuelup r0 l9,load c7 r0 l9,fly r0 l9 l7,unload c7 r0 l7,fuelup r0 l7,load c0 r0 l7,fly r0 l7 l5,unload c0 r0 l5,fuelup r0 l5,load c1 r0 l5,fly r0 l5 l8,unload c1 r0 l8,fuelup r0 l8,load c3 r0 l8,fly r0 l8 l6,unload c3 r0 l6,fuelup r0 l6,load c9 r0 l6,fly r0 l6 l4,unload c9 r0 l4,fuelup r0 l4,load c4 r0 l4,fly r0 l4 l3,unload c4 r0 l3,fuelup r0 l3,load c5 r0 l3,fly r0 l3 l0,unload c5 r0 l0)
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
	(at r0 l0)
	
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
	
	(at c6 l2)
	(at c0 l7)
	(at c7 l9)
	(at c4 l4)
	(at c3 l8)
	(at c9 l6)
	(at c1 l5)
	(at c8 l1)
	(at c2 l0)
	(at c5 l3)
	  )
  (:goal (and 
	(at c2 l2)
	(at c9 l4)
	(at c5 l0)
	(at c7 l7)
	(at c3 l6)
	(at c6 l9)
	(at c4 l3)
	(at c1 l8)
	(at c0 l5)
	(at c8 l1)
	  )
  )
)
