; Optimality lenght is (:optlen 16)
; Solution is (:solution fuelup r0 l0,load c3 r0 l0,fly r0 l0 l3,unload c3 r0 l3,fuelup r0 l3,load c0 r0 l3,fly r0 l3 l6,unload c0 r0 l6,fuelup r0 l6,load c6 r0 l6,fly r0 l6 l5,unload c6 r0 l5,fuelup r0 l5,load c5 r0 l5,fly r0 l5 l0,unload c5 r0 l0)
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
	(at r0 l0)
	
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
	
	(at c0 l3)
	(at c2 l4)
	(at c4 l2)
	(at c6 l6)
	(at c5 l5)
	(at c3 l0)
	(at c1 l1)
	  )
  (:goal (and 
	(at c5 l0)
	(at c4 l2)
	(at c3 l3)
	(at c0 l6)
	(at c6 l5)
	(at c1 l1)
	(at c2 l4)
	  )
  )
)
