; Optimality lenght is (:optlen 28)
; Solution is (:solution fuelup r0 l5,load c6 r0 l5,fly r0 l5 l4,unload c6 r0 l4,fuelup r0 l4,load c7 r0 l4,fly r0 l4 l3,unload c7 r0 l3,fuelup r0 l3,load c0 r0 l3,fly r0 l3 l7,unload c0 r0 l7,fuelup r0 l7,load c4 r0 l7,fly r0 l7 l6,unload c4 r0 l6,fuelup r0 l6,load c1 r0 l6,fly r0 l6 l1,unload c1 r0 l1,fuelup r0 l1,load c3 r0 l1,fly r0 l1 l0,unload c3 r0 l0,fuelup r0 l0,load c2 r0 l0,fly r0 l0 l5,unload c2 r0 l5)
(define (problem rocket_1_8_8)
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
	l0
	l1
	l2
	l3
	l4
	l5
	l6
	l7
	  )
  (:init
	(at r0 l5)
	
	(rocket r0)
	(cargo c0)
	(cargo c1)
	(cargo c2)
	(cargo c3)
	(cargo c4)
	(cargo c5)
	(cargo c6)
	(cargo c7)
	(location l0)
	(location l1)
	(location l2)
	(location l3)
	(location l4)
	(location l5)
	(location l6)
	(location l7)
	
	(at c0 l3)
	(at c1 l6)
	(at c3 l1)
	(at c7 l4)
	(at c5 l2)
	(at c6 l5)
	(at c4 l7)
	(at c2 l0)
	  )
  (:goal (and 
	(at c1 l1)
	(at c3 l0)
	(at c5 l2)
	(at c2 l5)
	(at c0 l7)
	(at c6 l4)
	(at c7 l3)
	(at c4 l6)
	  )
  )
)