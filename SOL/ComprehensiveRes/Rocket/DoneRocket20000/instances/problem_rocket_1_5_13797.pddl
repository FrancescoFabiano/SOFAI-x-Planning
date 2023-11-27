; Optimality lenght is (:optlen 12)
; Solution is (:solution fuelup r0 l1,load c2 r0 l1,fly r0 l1 l2,unload c2 r0 l2,fuelup r0 l2,load c3 r0 l2,fly r0 l2 l0,unload c3 r0 l0,fuelup r0 l0,load c0 r0 l0,fly r0 l0 l1,unload c0 r0 l1)
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
	(at r0 l1)
	
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
	
	(at c4 l4)
	(at c0 l0)
	(at c2 l1)
	(at c1 l3)
	(at c3 l2)
	  )
  (:goal (and 
	(at c4 l4)
	(at c2 l2)
	(at c1 l3)
	(at c3 l0)
	(at c0 l1)
	  )
  )
)
