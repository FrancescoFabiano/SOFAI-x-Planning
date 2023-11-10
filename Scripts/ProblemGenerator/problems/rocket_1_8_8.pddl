; Optimality lenght is (:optlen 28)
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
	(at r0 l0)
	
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
	
	(at c4 l7)
	(at c7 l0)
	(at c6 l4)
	(at c3 l6)
	(at c5 l3)
	(at c1 l5)
	(at c0 l1)
	(at c2 l2)
	  )
  (:goal (and 
	(at c0 l2)
	(at c4 l7)
	(at c7 l1)
	(at c1 l0)
	(at c6 l3)
	(at c2 l4)
	(at c3 l5)
	(at c5 l6)
	  )
  )
)
