; Optimality lenght is (:optlen 8)
; Solution is (:solution fuelup r0 l0,load c4 r0 l0,fly r0 l0 l1,unload c4 r0 l1,fuelup r0 l1,load c5 r0 l1,fly r0 l1 l0,unload c5 r0 l0)
(define (problem rocket_3_6_2)
  (:domain rocket)
  (:requirements :strips)
  (:objects
	r0 r1 r2
	c0 c1 c2
	c3 c4 c5
	l0 l1   )
  (:init
	(at r0 l0) (at r1 l0) (at r2 l1)
	
	(rocket r0) (rocket r1) (rocket r2)
	(cargo c0) (cargo c1) (cargo c2)
	(cargo c3) (cargo c4) (cargo c5)
	(location l0) (location l1) 
	(at c4 l0) (at c1 l1) (at c0 l0)
	(at c5 l1) (at c2 l1) (at c3 l0)
	  )
  (:goal (and 
	(at c1 l1) (at c0 l0) (at c3 l0)
	(at c2 l1) (at c5 l0) (at c4 l1)
	  )
  )
)
