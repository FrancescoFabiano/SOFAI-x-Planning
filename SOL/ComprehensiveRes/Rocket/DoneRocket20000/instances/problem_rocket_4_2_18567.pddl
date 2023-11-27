; Optimality lenght is (:optlen 8)
; Solution is (:solution fuelup r0 l0,load c6 r0 l0,fly r0 l0 l1,unload c6 r0 l1,fuelup r0 l1,load c5 r0 l1,fly r0 l1 l0,unload c5 r0 l0)
(define (problem rocket_4_8_2)
  (:domain rocket)
  (:requirements :strips)
  (:objects
	r0 r1 r2 r3
	c0 c1 c2 c3
	c4 c5 c6 c7
	l0 l1   )
  (:init
	(at r0 l0) (at r1 l0) (at r2 l1) (at r3 l1)
	
	(rocket r0) (rocket r1) (rocket r2) (rocket r3)
	(cargo c0) (cargo c1) (cargo c2) (cargo c3)
	(cargo c4) (cargo c5) (cargo c6) (cargo c7)
	(location l0) (location l1) 
	(at c2 l0) (at c4 l1) (at c5 l1) (at c3 l0)
	(at c0 l1) (at c6 l0) (at c7 l1) (at c1 l0)
	  )
  (:goal (and 
	(at c2 l0) (at c0 l1) (at c6 l1) (at c3 l0)
	(at c4 l1) (at c1 l0) (at c7 l1) (at c5 l0)
	  )
  )
)
