(define (problem rocket_3_3_3)
  (:domain rocket)
  (:requirements :strips)
  (:objects
	r0 r1 r2
	c0 c1 c2
	l0 l1 l2
	
  )
  (:init 
     
	(rocket r0) (rocket r1) (rocket r2)
	(cargo c0) (cargo c1) (cargo c2)
	(location l0) (location l1) (location l2)
	(at c1 l1) (at c2 l0) (at c0 l2)
	(at c1 l1) (at c2 l2) (at c0 l0)
	(at c2 l0) (at c1 l2) (at c0 l1)
	  )
  (:goal (and 
  
  
  )
  )
  )
