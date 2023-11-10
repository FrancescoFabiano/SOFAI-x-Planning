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
	
	(at c0 l3)
	(at c3 l1)
	(at c2 l0)
	(at c1 l2)
	  )
  (:goal (and 
	(at c1 l2)
	(at c2 l1)
	(at c3 l3)
	(at c0 l0)
	  )
  )
)
