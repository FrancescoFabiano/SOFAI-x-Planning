; Optimality lenght is (:optlen 16)
; Solution is (:solution fuelup r0 l0,load c2 r0 l0,fly r0 l0 l2,unload c2 r0 l2,fuelup r0 l2,load c1 r0 l2,fly r0 l2 l0,unload c1 r0 l0,fuelup r0 l0,load c3 r0 l0,fly r0 l0 l1,unload c3 r0 l1,fuelup r1 l1,load c0 r1 l1,fly r1 l1 l0,unload c0 r1 l0)
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
	(at r0 l0) (at r1 l1)
	
	(rocket r0) (rocket r1)
	(cargo c0) (cargo c1)
	(cargo c2) (cargo c3)
	(cargo c4) (cargo c5)
	(location l0) (location l1)
	(location l2) 
	(at c0 l1) (at c1 l2)
	(at c3 l0) (at c5 l1)
	(at c4 l2) (at c2 l0)
	  )
  (:goal (and 
	(at c3 l1) (at c4 l2)
	(at c1 l0) (at c0 l0)
	(at c2 l2) (at c5 l1)
	  )
  )
)
