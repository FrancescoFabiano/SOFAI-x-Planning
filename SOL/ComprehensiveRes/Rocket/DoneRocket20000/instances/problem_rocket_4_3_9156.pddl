; Optimality lenght is (:optlen 20)
; Solution is (:solution fuelup r0 l0,load c6 r0 l0,fly r0 l0 l1,unload c6 r0 l1,fuelup r0 l1,load c3 r0 l1,fly r0 l1 l2,unload c3 r0 l2,fuelup r0 l2,load c10 r0 l2,fly r0 l2 l0,unload c10 r0 l0,fuelup r1 l1,load c4 r1 l1,fly r1 l1 l2,unload c4 r1 l2,fuelup r1 l2,load c5 r1 l2,fly r1 l2 l1,unload c5 r1 l1)
(define (problem rocket_4_12_3)
  (:domain rocket)
  (:requirements :strips)
  (:objects
	r0 r1 r2 r3
	c0 c1 c2 c3
	c4 c5 c6 c7
	c8 c9 c10 c11
	l0 l1 l2   )
  (:init
	(at r0 l0) (at r1 l1) (at r2 l1) (at r3 l0)
	
	(rocket r0) (rocket r1) (rocket r2) (rocket r3)
	(cargo c0) (cargo c1) (cargo c2) (cargo c3)
	(cargo c4) (cargo c5) (cargo c6) (cargo c7)
	(cargo c8) (cargo c9) (cargo c10) (cargo c11)
	(location l0) (location l1) (location l2) 
	(at c3 l1) (at c10 l2) (at c11 l0) (at c2 l1)
	(at c6 l0) (at c7 l2) (at c1 l2) (at c0 l0)
	(at c9 l1) (at c5 l2) (at c4 l1) (at c8 l0)
	  )
  (:goal (and 
	(at c4 l2) (at c5 l1) (at c10 l0) (at c6 l1)
	(at c11 l0) (at c1 l2) (at c3 l2) (at c2 l1)
	(at c8 l0) (at c0 l0) (at c7 l2) (at c9 l1)
	  )
  )
)
