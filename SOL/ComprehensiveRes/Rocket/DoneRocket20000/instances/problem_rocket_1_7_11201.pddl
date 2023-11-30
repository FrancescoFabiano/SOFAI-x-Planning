; Optimality lenght is (:optlen 20)
; Solution is (:solution fuelup r0 l3,load c4 r0 l3,fly r0 l3 l6,unload c4 r0 l6,fuelup r0 l6,load c2 r0 l6,fly r0 l6 l2,unload c2 r0 l2,fuelup r0 l2,load c5 r0 l2,fly r0 l2 l5,unload c5 r0 l5,fuelup r0 l5,load c1 r0 l5,fly r0 l5 l4,unload c1 r0 l4,fuelup r0 l4,load c3 r0 l4,fly r0 l4 l3,unload c3 r0 l3)
(define (problem rocket_1_7_7)
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
	l0
	l1
	l2
	l3
	l4
	l5
	l6
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
	(location l0)
	(location l1)
	(location l2)
	(location l3)
	(location l4)
	(location l5)
	(location l6)
	
	(at c1 l5)
	(at c6 l0)
	(at c4 l3)
	(at c3 l4)
	(at c0 l1)
	(at c5 l2)
	(at c2 l6)
	  )
  (:goal (and 
	(at c1 l4)
	(at c5 l5)
	(at c6 l0)
	(at c0 l1)
	(at c3 l3)
	(at c4 l6)
	(at c2 l2)
	  )
  )
)
