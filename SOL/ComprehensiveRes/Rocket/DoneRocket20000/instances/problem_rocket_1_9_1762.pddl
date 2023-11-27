; Optimality lenght is (:optlen 28)
; Solution is (:solution fuelup r0 l6,load c8 r0 l6,fly r0 l6 l3,unload c8 r0 l3,fuelup r0 l3,load c1 r0 l3,fly r0 l3 l5,unload c1 r0 l5,fuelup r0 l5,load c0 r0 l5,fly r0 l5 l2,unload c0 r0 l2,fuelup r0 l2,load c6 r0 l2,fly r0 l2 l0,unload c6 r0 l0,fuelup r0 l0,load c5 r0 l0,fly r0 l0 l7,unload c5 r0 l7,fuelup r0 l7,load c4 r0 l7,fly r0 l7 l8,unload c4 r0 l8,fuelup r0 l8,load c3 r0 l8,fly r0 l8 l6,unload c3 r0 l6)
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
	(at r0 l6)
	
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
	
	(at c1 l3)
	(at c2 l1)
	(at c5 l0)
	(at c0 l5)
	(at c3 l8)
	(at c4 l7)
	(at c8 l6)
	(at c7 l4)
	(at c6 l2)
	  )
  (:goal (and 
	(at c0 l2)
	(at c7 l4)
	(at c4 l8)
	(at c8 l3)
	(at c3 l6)
	(at c1 l5)
	(at c5 l7)
	(at c6 l0)
	(at c2 l1)
	  )
  )
)
