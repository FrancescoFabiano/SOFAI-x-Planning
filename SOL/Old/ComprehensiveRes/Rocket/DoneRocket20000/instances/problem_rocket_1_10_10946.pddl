; Optimality lenght is (:optlen 24)
; Solution is (:solution fuelup r0 l9,load c3 r0 l9,fly r0 l9 l3,unload c3 r0 l3,fuelup r0 l3,load c8 r0 l3,fly r0 l3 l7,unload c8 r0 l7,fuelup r0 l7,load c2 r0 l7,fly r0 l7 l6,unload c2 r0 l6,fuelup r0 l6,load c4 r0 l6,fly r0 l6 l2,unload c4 r0 l2,fuelup r0 l2,load c5 r0 l2,fly r0 l2 l1,unload c5 r0 l1,fuelup r0 l1,load c6 r0 l1,fly r0 l1 l9,unload c6 r0 l9)
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
	(at r0 l9)
	
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
	
	(at c3 l9)
	(at c6 l1)
	(at c5 l2)
	(at c1 l8)
	(at c8 l3)
	(at c2 l7)
	(at c0 l5)
	(at c4 l6)
	(at c9 l4)
	(at c7 l0)
	  )
  (:goal (and 
	(at c8 l7)
	(at c1 l8)
	(at c2 l6)
	(at c9 l4)
	(at c0 l5)
	(at c5 l1)
	(at c3 l3)
	(at c4 l2)
	(at c6 l9)
	(at c7 l0)
	  )
  )
)