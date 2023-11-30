; Optimality lenght is (:optlen 8)
; Solution is (:solution fuelup r0 l0,load c1 r0 l0,fly r0 l0 l1,unload c1 r0 l1,fuelup r0 l1,load c0 r0 l1,fly r0 l1 l0,unload c0 r0 l0)
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
	
	(at c0 l1)
	(at c1 l0)
	  )
  (:goal (and 
	(at c0 l0)
	(at c1 l1)
	  )
  )
)
