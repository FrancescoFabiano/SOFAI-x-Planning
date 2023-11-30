; Optimality lenght is (:optlen 8)
; Solution is (:solution fuelup r0 l2,load c1 r0 l2,fly r0 l2 l1,unload c1 r0 l1,fuelup r0 l1,load c0 r0 l1,fly r0 l1 l2,unload c0 r0 l2)
(define (problem rocket_1_3_3)
  (:domain rocket)
  (:requirements :strips)
  (:objects
	r0
	c0
	c1
	c2
	l0
	l1
	l2
	  )
  (:init
	(at r0 l2)
	
	(rocket r0)
	(cargo c0)
	(cargo c1)
	(cargo c2)
	(location l0)
	(location l1)
	(location l2)
	
	(at c1 l2)
	(at c0 l1)
	(at c2 l0)
	  )
  (:goal (and 
	(at c1 l1)
	(at c0 l2)
	(at c2 l0)
	  )
  )
)
