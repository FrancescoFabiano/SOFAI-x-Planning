(define (problem rocket_1_2_2)
  (:domain rocket)
  (:requirements :strips)
  (:objects
	r0
	c0
	c1
	l0
	l1
	  )
  (:init
	(at r0 l0)
	
	(rocket r0)
	(cargo c0)
	(cargo c1)
	(location l0)
	(location l1)
	
	(at c0 l0)
	(at c1 l1)
	  )
  (:goal (and 
	(at c1 l0)
	(at c0 l1)
	  )
  )
)
