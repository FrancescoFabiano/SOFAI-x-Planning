; Optimality lenght is (:optlen 20)
; Solution is (:solution fuelup r0 l3,load c3 r0 l3,fly r0 l3 l8,unload c3 r0 l8,fuelup r0 l8,load c6 r0 l8,fly r0 l8 l7,unload c6 r0 l7,fuelup r0 l7,load c5 r0 l7,fly r0 l7 l5,unload c5 r0 l5,fuelup r0 l5,load c7 r0 l5,fly r0 l5 l4,unload c7 r0 l4,fuelup r0 l4,load c2 r0 l4,fly r0 l4 l3,unload c2 r0 l3)
(define (problem rocket_1_9_9)
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
	l0
	l1
	l2
	l3
	l4
	l5
	l6
	l7
	l8
	  )
  (:init
	(at r0 l3)
	
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
	(location l0)
	(location l1)
	(location l2)
	(location l3)
	(location l4)
	(location l5)
	(location l6)
	(location l7)
	(location l8)
	
	(at c2 l4)
	(at c6 l8)
	(at c3 l3)
	(at c7 l5)
	(at c5 l7)
	(at c1 l2)
	(at c0 l1)
	(at c4 l0)
	(at c8 l6)
	  )
  (:goal (and 
	(at c6 l7)
	(at c5 l5)
	(at c8 l6)
	(at c7 l4)
	(at c2 l3)
	(at c3 l8)
	(at c1 l2)
	(at c4 l0)
	(at c0 l1)
	  )
  )
)
