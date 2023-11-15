; Optimality lenght is (:optlen 16)
; Solution is (:solution fuelup r0 l0,load c2 r0 l0,fly r0 l0 l4,unload c2 r0 l4,fuelup r0 l4,load c3 r0 l4,fly r0 l4 l3,unload c3 r0 l3,fuelup r0 l3,load c4 r0 l3,fly r0 l3 l1,unload c4 r0 l1,fuelup r0 l1,load c0 r0 l1,fly r0 l1 l0,unload c0 r0 l0)
(define (problem rocket_1_5_5)
  (:domain rocket)
  (:requirements :strips)
  (:objects
	r0
	c0
	c1
	c2
	c3
	c4
	l0
	l1
	l2
	l3
	l4
	  )
  (:init
	(at r0 l0)
	
	(rocket r0)
	(cargo c0)
	(cargo c1)
	(cargo c2)
	(cargo c3)
	(cargo c4)
	(location l0)
	(location l1)
	(location l2)
	(location l3)
	(location l4)
	
	(at c4 l3)
	(at c1 l2)
	(at c3 l4)
	(at c0 l1)
	(at c2 l0)
	  )
  (:goal (and 
	(at c1 l2)
	(at c4 l1)
	(at c2 l4)
	(at c3 l3)
	(at c0 l0)
	  )
  )
)
