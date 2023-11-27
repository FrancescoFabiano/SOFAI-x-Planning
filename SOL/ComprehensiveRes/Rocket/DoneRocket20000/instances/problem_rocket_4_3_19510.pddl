; Optimality lenght is (:optlen 48)
; Solution is (:solution fuelup r0 l0,load c0 r0 l0,fly r0 l0 l2,unload c0 r0 l2,fuelup r0 l2,load c6 r0 l2,fly r0 l2 l1,unload c6 r0 l1,fuelup r0 l1,load c10 r0 l1,fly r0 l1 l0,unload c10 r0 l0,fuelup r1 l2,load c1 r1 l2,fly r1 l2 l1,unload c1 r1 l1,fuelup r1 l1,load c3 r1 l1,fly r1 l1 l2,unload c3 r1 l2,fuelup r1 l2,load c8 r1 l2,fly r1 l2 l0,unload c8 r1 l0,fuelup r2 l0,load c4 r2 l0,fly r2 l0 l1,unload c4 r2 l1,fuelup r2 l1,load c2 r2 l1,fly r2 l1 l0,unload c2 r2 l0,fuelup r2 l0,load c11 r2 l0,fly r2 l0 l2,unload c11 r2 l2,fuelup r3 l0,load c7 r3 l0,fly r3 l0 l1,unload c7 r3 l1,fuelup r3 l1,load c5 r3 l1,fly r3 l1 l2,unload c5 r3 l2,fuelup r3 l2,load c9 r3 l2,fly r3 l2 l0,unload c9 r3 l0)
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
	(at r0 l0) (at r1 l2) (at r2 l0) (at r3 l0)
	
	(rocket r0) (rocket r1) (rocket r2) (rocket r3)
	(cargo c0) (cargo c1) (cargo c2) (cargo c3)
	(cargo c4) (cargo c5) (cargo c6) (cargo c7)
	(cargo c8) (cargo c9) (cargo c10) (cargo c11)
	(location l0) (location l1) (location l2) 
	(at c10 l1) (at c4 l0) (at c1 l2) (at c0 l0)
	(at c6 l2) (at c3 l1) (at c9 l2) (at c11 l0)
	(at c2 l1) (at c5 l1) (at c7 l0) (at c8 l2)
	  )
  (:goal (and 
	(at c10 l0) (at c0 l2) (at c7 l1) (at c4 l1)
	(at c2 l0) (at c3 l2) (at c6 l1) (at c9 l0)
	(at c11 l2) (at c1 l1) (at c5 l2) (at c8 l0)
	  )
  )
)