; Optimality lenght is (:optlen 24)
; Solution is (:solution fuelup r0 l0,load c5 r0 l0,fly r0 l0 l1,unload c5 r0 l1,fuelup r0 l1,load c7 r0 l1,fly r0 l1 l0,unload c7 r0 l0,fuelup r1 l1,load c11 r1 l1,fly r1 l1 l0,unload c11 r1 l0,fuelup r1 l0,load c18 r1 l0,fly r1 l0 l1,unload c18 r1 l1,fuelup r2 l0,load c6 r2 l0,fly r2 l0 l1,unload c6 r2 l1,fuelup r2 l1,load c12 r2 l1,fly r2 l1 l0,unload c12 r2 l0)
(define (problem rocket_10_20_2)
  (:domain rocket)
  (:requirements :strips)
  (:objects
	r0 r1 r2 r3 r4 r5 r6 r7 r8 r9
	c0 c1 c2 c3 c4 c5 c6 c7 c8 c9
	c10 c11 c12 c13 c14 c15 c16 c17 c18 c19
	l0 l1   )
  (:init
	(at r0 l0) (at r1 l1) (at r2 l0) (at r3 l0) (at r4 l0) (at r5 l0) (at r6 l0) (at r7 l0) (at r8 l0) (at r9 l1)
	
	(rocket r0) (rocket r1) (rocket r2) (rocket r3) (rocket r4) (rocket r5) (rocket r6) (rocket r7) (rocket r8) (rocket r9)
	(cargo c0) (cargo c1) (cargo c2) (cargo c3) (cargo c4) (cargo c5) (cargo c6) (cargo c7) (cargo c8) (cargo c9)
	(cargo c10) (cargo c11) (cargo c12) (cargo c13) (cargo c14) (cargo c15) (cargo c16) (cargo c17) (cargo c18) (cargo c19)
	(location l0) (location l1) 
	(at c0 l0) (at c13 l1) (at c7 l1) (at c3 l0) (at c1 l0) (at c4 l1) (at c10 l0) (at c16 l1) (at c5 l0) (at c9 l1)
	(at c17 l0) (at c14 l1) (at c6 l0) (at c12 l1) (at c11 l1) (at c18 l0) (at c2 l0) (at c19 l1) (at c8 l1) (at c15 l0)
	  )
  (:goal (and 
	(at c9 l1) (at c11 l0) (at c18 l1) (at c0 l0) (at c2 l0) (at c14 l1) (at c19 l1) (at c3 l0) (at c13 l1) (at c10 l0)
	(at c4 l1) (at c15 l0) (at c12 l0) (at c5 l1) (at c16 l1) (at c7 l0) (at c17 l0) (at c8 l1) (at c1 l0) (at c6 l1)
	  )
  )
)
