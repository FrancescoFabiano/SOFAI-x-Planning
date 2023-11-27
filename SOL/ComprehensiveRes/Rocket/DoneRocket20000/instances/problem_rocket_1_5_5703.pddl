; Optimality lenght is (:optlen 16)
; Solution is (:solution fuelup r0 l3,load c3 r0 l3,fly r0 l3 l2,unload c3 r0 l2,fuelup r0 l2,load c1 r0 l2,fly r0 l2 l4,unload c1 r0 l4,fuelup r0 l4,load c4 r0 l4,fly r0 l4 l1,unload c4 r0 l1,fuelup r0 l1,load c2 r0 l1,fly r0 l1 l3,unload c2 r0 l3)
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
	(at r0 l3)
	
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
	(at c1 l2)
	(at c3 l3)
	(at c2 l1)
	  )
  (:goal (and 
	(at c4 l1)
	(at c3 l2)
	(at c1 l4)
	(at c0 l0)
	(at c2 l3)
	  )
  )
)
