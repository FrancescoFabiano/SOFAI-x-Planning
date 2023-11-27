; Optimality lenght is (:optlen 8)
; Solution is (:solution fuelup r1 l0,load c6 r1 l0,fly r1 l0 l2,unload c6 r1 l2,fuelup r1 l2,load c5 r1 l2,fly r1 l2 l0,unload c5 r1 l0)
(define (problem rocket_3_9_3)
  (:domain rocket)
  (:requirements :strips)
  (:objects
	r0 r1 r2
	c0 c1 c2
	c3 c4 c5
	c6 c7 c8
	l0 l1 l2
	  )
  (:init
	(at r0 l1) (at r1 l0) (at r2 l0)
	
	(rocket r0) (rocket r1) (rocket r2)
	(cargo c0) (cargo c1) (cargo c2)
	(cargo c3) (cargo c4) (cargo c5)
	(cargo c6) (cargo c7) (cargo c8)
	(location l0) (location l1) (location l2)
	
	(at c0 l2) (at c3 l1) (at c1 l0)
	(at c4 l0) (at c7 l1) (at c5 l2)
	(at c2 l2) (at c6 l0) (at c8 l1)
	  )
  (:goal (and 
	(at c6 l2) (at c1 l0) (at c7 l1)
	(at c0 l2) (at c5 l0) (at c3 l1)
	(at c4 l0) (at c8 l1) (at c2 l2)
	  )
  )
)
