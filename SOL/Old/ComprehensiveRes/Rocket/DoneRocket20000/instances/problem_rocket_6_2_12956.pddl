; Optimality lenght is (:optlen 16)
; Solution is (:solution fuelup r0 l0,load c6 r0 l0,fly r0 l0 l1,unload c6 r0 l1,fuelup r0 l1,load c4 r0 l1,fly r0 l1 l0,unload c4 r0 l0,fuelup r1 l0,load c11 r1 l0,fly r1 l0 l1,unload c11 r1 l1,fuelup r1 l1,load c8 r1 l1,fly r1 l1 l0,unload c8 r1 l0)
(define (problem rocket_6_12_2)
  (:domain rocket)
  (:requirements :strips)
  (:objects
	r0 r1 r2 r3 r4 r5
	c0 c1 c2 c3 c4 c5
	c6 c7 c8 c9 c10 c11
	l0 l1   )
  (:init
	(at r0 l0) (at r1 l0) (at r2 l0) (at r3 l1) (at r4 l1) (at r5 l0)
	
	(rocket r0) (rocket r1) (rocket r2) (rocket r3) (rocket r4) (rocket r5)
	(cargo c0) (cargo c1) (cargo c2) (cargo c3) (cargo c4) (cargo c5)
	(cargo c6) (cargo c7) (cargo c8) (cargo c9) (cargo c10) (cargo c11)
	(location l0) (location l1) 
	(at c11 l0) (at c8 l1) (at c6 l0) (at c4 l1) (at c7 l0) (at c9 l1)
	(at c5 l0) (at c10 l1) (at c1 l0) (at c0 l1) (at c2 l0) (at c3 l1)
	  )
  (:goal (and 
	(at c11 l1) (at c1 l0) (at c8 l0) (at c3 l1) (at c7 l0) (at c0 l1)
	(at c9 l1) (at c2 l0) (at c4 l0) (at c6 l1) (at c10 l1) (at c5 l0)
	  )
  )
)
