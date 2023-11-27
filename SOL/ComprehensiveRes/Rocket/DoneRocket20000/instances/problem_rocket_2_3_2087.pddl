; Optimality lenght is (:optlen 8)
; Solution is (:solution fuelup r1 l1,load c2 r1 l1,fly r1 l1 l0,unload c2 r1 l0,fuelup r1 l0,load c0 r1 l0,fly r1 l0 l1,unload c0 r1 l1)
(define (problem rocket_2_6_3)
  (:domain rocket)
  (:requirements :strips)
  (:objects
	r0 r1
	c0 c1
	c2 c3
	c4 c5
	l0 l1
	l2   )
  (:init
	(at r0 l2) (at r1 l1)
	
	(rocket r0) (rocket r1)
	(cargo c0) (cargo c1)
	(cargo c2) (cargo c3)
	(cargo c4) (cargo c5)
	(location l0) (location l1)
	(location l2) 
	(at c4 l1) (at c1 l2)
	(at c0 l0) (at c2 l1)
	(at c3 l2) (at c5 l0)
	  )
  (:goal (and 
	(at c2 l0) (at c0 l1)
	(at c1 l2) (at c5 l0)
	(at c3 l2) (at c4 l1)
	  )
  )
)
