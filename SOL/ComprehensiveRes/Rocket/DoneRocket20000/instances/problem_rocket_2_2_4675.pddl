; Optimality lenght is (:optlen 8)
; Solution is (:solution fuelup r0 l1,load c1 r0 l1,fly r0 l1 l0,unload c1 r0 l0,fuelup r0 l0,load c3 r0 l0,fly r0 l0 l1,unload c3 r0 l1)
(define (problem rocket_2_4_2)
  (:domain rocket)
  (:requirements :strips)
  (:objects
	r0 r1
	c0 c1
	c2 c3
	l0 l1
	  )
  (:init
	(at r0 l1) (at r1 l1)
	
	(rocket r0) (rocket r1)
	(cargo c0) (cargo c1)
	(cargo c2) (cargo c3)
	(location l0) (location l1)
	
	(at c3 l0) (at c1 l1)
	(at c0 l1) (at c2 l0)
	  )
  (:goal (and 
	(at c3 l1) (at c1 l0)
	(at c2 l0) (at c0 l1)
	  )
  )
)
