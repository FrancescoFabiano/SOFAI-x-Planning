; Optimality lenght is (:optlen 36)
; Solution is (:solution fuelup r0 l0,load c2 r0 l0,fly r0 l0 l1,unload c2 r0 l1,fuelup r0 l1,load c4 r0 l1,fly r0 l1 l2,unload c4 r0 l2,fuelup r0 l2,load c17 r0 l2,fly r0 l2 l0,unload c17 r0 l0,fuelup r1 l1,load c0 r1 l1,fly r1 l1 l0,unload c0 r1 l0,fuelup r1 l0,load c8 r1 l0,fly r1 l0 l1,unload c8 r1 l1,fuelup r1 l1,load c11 r1 l1,fly r1 l1 l2,unload c11 r1 l2,fuelup r2 l0,load c14 r2 l0,fly r2 l0 l2,unload c14 r2 l2,fuelup r2 l2,load c3 r2 l2,fly r2 l2 l1,unload c3 r2 l1,fuelup r5 l2,load c19 r5 l2,fly r5 l2 l0,unload c19 r5 l0)
(define (problem rocket_7_21_3)
  (:domain rocket)
  (:requirements :strips)
  (:objects
	r0 r1 r2 r3 r4 r5 r6
	c0 c1 c2 c3 c4 c5 c6
	c7 c8 c9 c10 c11 c12 c13
	c14 c15 c16 c17 c18 c19 c20
	l0 l1 l2   )
  (:init
	(at r0 l0) (at r1 l1) (at r2 l0) (at r3 l1) (at r4 l0) (at r5 l2) (at r6 l2)
	
	(rocket r0) (rocket r1) (rocket r2) (rocket r3) (rocket r4) (rocket r5) (rocket r6)
	(cargo c0) (cargo c1) (cargo c2) (cargo c3) (cargo c4) (cargo c5) (cargo c6)
	(cargo c7) (cargo c8) (cargo c9) (cargo c10) (cargo c11) (cargo c12) (cargo c13)
	(cargo c14) (cargo c15) (cargo c16) (cargo c17) (cargo c18) (cargo c19) (cargo c20)
	(location l0) (location l1) (location l2) 
	(at c6 l0) (at c18 l1) (at c15 l2) (at c4 l1) (at c1 l0) (at c17 l2) (at c3 l2)
	(at c10 l1) (at c14 l0) (at c13 l0) (at c7 l2) (at c9 l1) (at c11 l1) (at c12 l0)
	(at c19 l2) (at c5 l2) (at c0 l1) (at c8 l0) (at c2 l0) (at c20 l2) (at c16 l1)
	  )
  (:goal (and 
	(at c12 l0) (at c3 l1) (at c7 l2) (at c9 l1) (at c17 l0) (at c20 l2) (at c14 l2)
	(at c10 l1) (at c0 l0) (at c18 l1) (at c1 l0) (at c4 l2) (at c19 l0) (at c8 l1)
	(at c5 l2) (at c11 l2) (at c2 l1) (at c6 l0) (at c15 l2) (at c13 l0) (at c16 l1)
	  )
  )
)
