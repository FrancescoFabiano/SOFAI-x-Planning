; Optimality lenght is (:optlen 24)
; Solution is (:solution fuelup r0 l0,load c0 r0 l0,fly r0 l0 l1,unload c0 r0 l1,fuelup r0 l1,load c3 r0 l1,fly r0 l1 l0,unload c3 r0 l0,fuelup r1 l0,load c2 r1 l0,fly r1 l0 l1,unload c2 r1 l1,fuelup r1 l1,load c6 r1 l1,fly r1 l1 l0,unload c6 r1 l0,fuelup r2 l1,load c4 r2 l1,fly r2 l1 l0,unload c4 r2 l0,fuelup r2 l0,load c8 r2 l0,fly r2 l0 l1,unload c8 r2 l1)
(define (problem rocket_5_10_2)
  (:domain rocket)
  (:requirements :strips)
  (:objects
	r0 r1 r2 r3 r4
	c0 c1 c2 c3 c4
	c5 c6 c7 c8 c9
	l0 l1   )
  (:init
	(at r0 l0) (at r1 l0) (at r2 l1) (at r3 l1) (at r4 l0)
	
	(rocket r0) (rocket r1) (rocket r2) (rocket r3) (rocket r4)
	(cargo c0) (cargo c1) (cargo c2) (cargo c3) (cargo c4)
	(cargo c5) (cargo c6) (cargo c7) (cargo c8) (cargo c9)
	(location l0) (location l1) 
	(at c1 l1) (at c5 l0) (at c9 l1) (at c2 l0) (at c8 l0)
	(at c6 l1) (at c4 l1) (at c7 l0) (at c0 l0) (at c3 l1)
	  )
  (:goal (and 
	(at c4 l0) (at c2 l1) (at c5 l0) (at c9 l1) (at c0 l1)
	(at c7 l0) (at c1 l1) (at c3 l0) (at c6 l0) (at c8 l1)
	  )
  )
)
