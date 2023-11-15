; Optimality lenght is (:optlen 12)
; Solution is (:solution fuelup r0 l0,load c1 r0 l0,fly r0 l0 l3,unload c1 r0 l3,fuelup r0 l3,load c0 r0 l3,fly r0 l3 l1,unload c0 r0 l1,fuelup r0 l1,load c2 r0 l1,fly r0 l1 l0,unload c2 r0 l0)
(define (problem rocket_1_4_4)
  (:domain rocket)
  (:requirements :strips)
  (:objects
	r0
	c0
	c1
	c2
	c3
	l0
	l1
	l2
	l3
	  )
  (:init
	(at r0 l0)
	
	(rocket r0)
	(cargo c0)
	(cargo c1)
	(cargo c2)
	(cargo c3)
	(location l0)
	(location l1)
	(location l2)
	(location l3)
	
	(at c2 l1)
	(at c3 l2)
	(at c1 l0)
	(at c0 l3)
	  )
  (:goal (and 
	(at c2 l0)
	(at c3 l2)
	(at c0 l1)
	(at c1 l3)
	  )
  )
)
