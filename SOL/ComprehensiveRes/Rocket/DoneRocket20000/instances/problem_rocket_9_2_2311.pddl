; Optimality lenght is (:optlen 48)
; Solution is (:solution fuelup r0 l1,load c1 r0 l1,fly r0 l1 l0,unload c1 r0 l0,fuelup r0 l0,load c6 r0 l0,fly r0 l0 l1,unload c6 r0 l1,fuelup r1 l0,load c11 r1 l0,fly r1 l0 l1,unload c11 r1 l1,fuelup r1 l1,load c2 r1 l1,fly r1 l1 l0,unload c2 r1 l0,fuelup r2 l0,load c14 r2 l0,fly r2 l0 l1,unload c14 r2 l1,fuelup r2 l1,load c3 r2 l1,fly r2 l1 l0,unload c3 r2 l0,fuelup r3 l0,load c15 r3 l0,fly r3 l0 l1,unload c15 r3 l1,fuelup r3 l1,load c4 r3 l1,fly r3 l1 l0,unload c4 r3 l0,fuelup r4 l0,load c16 r4 l0,fly r4 l0 l1,unload c16 r4 l1,fuelup r4 l1,load c9 r4 l1,fly r4 l1 l0,unload c9 r4 l0,fuelup r5 l0,load c17 r5 l0,fly r5 l0 l1,unload c17 r5 l1,fuelup r5 l1,load c13 r5 l1,fly r5 l1 l0,unload c13 r5 l0)
(define (problem rocket_9_18_2)
  (:domain rocket)
  (:requirements :strips)
  (:objects
	r0 r1 r2 r3 r4 r5 r6 r7 r8
	c0 c1 c2 c3 c4 c5 c6 c7 c8
	c9 c10 c11 c12 c13 c14 c15 c16 c17
	l0 l1   )
  (:init
	(at r0 l1) (at r1 l0) (at r2 l0) (at r3 l0) (at r4 l0) (at r5 l0) (at r6 l1) (at r7 l1) (at r8 l1)
	
	(rocket r0) (rocket r1) (rocket r2) (rocket r3) (rocket r4) (rocket r5) (rocket r6) (rocket r7) (rocket r8)
	(cargo c0) (cargo c1) (cargo c2) (cargo c3) (cargo c4) (cargo c5) (cargo c6) (cargo c7) (cargo c8)
	(cargo c9) (cargo c10) (cargo c11) (cargo c12) (cargo c13) (cargo c14) (cargo c15) (cargo c16) (cargo c17)
	(location l0) (location l1) 
	(at c14 l0) (at c3 l1) (at c9 l1) (at c11 l0) (at c15 l0) (at c1 l1) (at c8 l0) (at c2 l1) (at c10 l1)
	(at c0 l0) (at c17 l0) (at c7 l1) (at c5 l1) (at c6 l0) (at c4 l1) (at c16 l0) (at c12 l0) (at c13 l1)
	  )
  (:goal (and 
	(at c11 l1) (at c0 l0) (at c12 l0) (at c15 l1) (at c7 l1) (at c4 l0) (at c2 l0) (at c5 l1) (at c1 l0)
	(at c16 l1) (at c8 l0) (at c10 l1) (at c13 l0) (at c6 l1) (at c17 l1) (at c9 l0) (at c14 l1) (at c3 l0)
	  )
  )
)
