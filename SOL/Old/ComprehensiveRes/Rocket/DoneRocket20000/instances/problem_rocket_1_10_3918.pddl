; Optimality lenght is (:optlen 28)
; Solution is (:solution fuelup r0 l7,load c9 r0 l7,fly r0 l7 l5,unload c9 r0 l5,fuelup r0 l5,load c6 r0 l5,fly r0 l5 l2,unload c6 r0 l2,fuelup r0 l2,load c8 r0 l2,fly r0 l2 l3,unload c8 r0 l3,fuelup r0 l3,load c7 r0 l3,fly r0 l3 l1,unload c7 r0 l1,fuelup r0 l1,load c5 r0 l1,fly r0 l1 l9,unload c5 r0 l9,fuelup r0 l9,load c1 r0 l9,fly r0 l9 l6,unload c1 r0 l6,fuelup r0 l6,load c4 r0 l6,fly r0 l6 l7,unload c4 r0 l7)
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
	(at r0 l7)
	
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
	
	(at c9 l7)
	(at c7 l3)
	(at c4 l6)
	(at c2 l4)
	(at c3 l8)
	(at c1 l9)
	(at c0 l0)
	(at c5 l1)
	(at c8 l2)
	(at c6 l5)
	  )
  (:goal (and 
	(at c5 l9)
	(at c6 l2)
	(at c1 l6)
	(at c2 l4)
	(at c0 l0)
	(at c4 l7)
	(at c7 l1)
	(at c9 l5)
	(at c8 l3)
	(at c3 l8)
	  )
  )
)
